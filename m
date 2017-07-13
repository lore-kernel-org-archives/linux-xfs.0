Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56688 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752757AbdGMUKT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 Jul 2017 16:10:19 -0400
Subject: Re: [PATCH v2] xfsdump: fix race condition between lseek() and
 read()/write()
References: <a63c9311-8b97-ad31-63cb-35bdea02b6a3@sandeen.net>
 <20170713084153.32535-1-eguan@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <75bab0cd-fd1a-45ed-0a93-0ad59a085a17@sandeen.net>
Date: Thu, 13 Jul 2017 15:10:18 -0500
MIME-Version: 1.0
In-Reply-To: <20170713084153.32535-1-eguan@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>, linux-xfs@vger.kernel.org

On 07/13/2017 03:41 AM, Eryu Guan wrote:
> There's a race condition in the [get|put]_invtrecord() routines, because
> a lseek() followed by a read()/write() is not atmoic, the file offset
> might be changed before read()/write().
> 
> xfs/302 catches this failure as:
> xfsdump: drive 1: INV : Unknown version 0 - Expected version 1
> xfsdump: inv_core.c:66: get_counters: Assertion `((invt_counter_t *)(*cntpp))->ic_vernum == (inv_version_t) 1' failed.
> 
> And it can be reproduced by running multi-stream dump in a tight loop
>   mount /dev/<dev> /mnt/xfs
>   mkdir /mnt/xfs/dumpdir
>   # populate dumpdir here
>   while xfsdump -M l1 -M l2 -f d1 -f d2 -L ses /mnt/xfs -s dumpdir; do
>   	:
>   done
> 
> Fix it by replacing the "lseek(); read()/write()" sequence by
> pread()/pwrite(), which make the seek and I/O an atomic operation.

Thanks, let's go with it :)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> Also convert all *_SEEKCUR routines to "SEEK_SET" variants and
> remove the *_SEEKCUR macros, because they depend on the maintenance
> of current file offset, but pread()/pwrite() don't change file
> offset.
> 
> And in inventory/testmain.c, get|put_invtrecord() are called
> directly, not from the GET|PUT_REC_* macros, so maintain the offset
> explicitly there.
> 
> Signed-off-by: Eryu Guan <eguan@redhat.com>
> ---
> v2 passed xfstests -g dump group tests too, with different block size fs(512,
> 1k, 4k), with different feature enabled (v4, v5, reflink).
> 
> But I didn't really test testmain.c, it's not compiled by default, and I
> suspect it won't be compiled anyway, the usage of inv_put_sessioninfo() doesn't
> match its declaration, and there're might be other problems as well.
> 
> v2:
> - remove whence argument from get|pub_invtrecord()
> - update testmain.c to use get|pub_invtrecord() correctly
> 
>  common/inventory.c   |  4 ++--
>  inventory/inv_api.c  |  5 ++---
>  inventory/inv_core.c | 29 ++++++-----------------------
>  inventory/inv_idx.c  |  4 ++--
>  inventory/inv_priv.h | 21 ++++++---------------
>  inventory/testmain.c | 34 +++++++++++++++++++++++-----------
>  6 files changed, 41 insertions(+), 56 deletions(-)
> 
> diff --git a/common/inventory.c b/common/inventory.c
> index d1b810c5bd10..0e9c2562ec25 100644
> --- a/common/inventory.c
> +++ b/common/inventory.c
> @@ -471,8 +471,8 @@ inv_stream_close(
>  	}
>  			
>  	if (dowrite) {
> -		rval = PUT_REC_NOLOCK_SEEKCUR( fd, &strm, sizeof( invt_stream_t ),
> -					       (off64_t) -(sizeof( invt_stream_t )) );
> +		rval = PUT_REC_NOLOCK(fd, &strm, sizeof(invt_stream_t),
> +				      tok->md_stream_off);
>  	}
>   end:
>  	INVLOCK( fd, LOCK_UN );
> diff --git a/inventory/inv_api.c b/inventory/inv_api.c
> index acca40b00fff..46fdde84740b 100644
> --- a/inventory/inv_api.c
> +++ b/inventory/inv_api.c
> @@ -409,9 +409,8 @@ inv_stream_close(
>  		}
>  			
>  		if (dowrite) {
> -			rval = PUT_REC_NOLOCK_SEEKCUR( fd, &strm, 
> -			             sizeof( invt_stream_t ),
> -				     -(off64_t)(sizeof( invt_stream_t )) );
> +			rval = PUT_REC_NOLOCK(fd, &strm, sizeof(invt_stream_t),
> +					      tok->md_stream_off);
>  		}
>  	}
>  
> diff --git a/inventory/inv_core.c b/inventory/inv_core.c
> index a17c2c9c5603..5ef519c91347 100644
> --- a/inventory/inv_core.c
> +++ b/inventory/inv_core.c
> @@ -112,7 +112,7 @@ get_headers( int fd, void **hdrs, size_t bufsz, size_t off )
>  
>  int
>  get_invtrecord( int fd, void *buf, size_t bufsz, off64_t off, 
> -	        int whence, bool_t dolock )
> +		bool_t dolock )
>  {
>  	int  nread;
>  	
> @@ -121,19 +121,10 @@ get_invtrecord( int fd, void *buf, size_t bufsz, off64_t off,
>  	if ( dolock ) 
>  		INVLOCK( fd, LOCK_SH );
>  
> -	if ( lseek( fd, (off_t)off, whence ) < 0 ) {
> -		INV_PERROR( _("Error in reading inventory record "
> -			      "(lseek failed): ") );
> -		if ( dolock ) 
> -			INVLOCK( fd, LOCK_UN );
> -		return -1;
> -	}
> -	
> -	nread = read( fd, buf, bufsz );
> -
> +	nread = pread(fd, buf, bufsz, (off_t)off);
>  	if (  nread != (int) bufsz ) {
>  		INV_PERROR( _("Error in reading inventory record :") );
> -		if ( dolock ) 
> +		if ( dolock )
>  			INVLOCK( fd, LOCK_UN );
>  		return -1;
>  	}
> @@ -154,23 +145,15 @@ get_invtrecord( int fd, void *buf, size_t bufsz, off64_t off,
>  /*----------------------------------------------------------------------*/
>  
>  int
> -put_invtrecord( int fd, void *buf, size_t bufsz, off64_t off, 
> -	        int whence, bool_t dolock )
> +put_invtrecord( int fd, void *buf, size_t bufsz, off64_t off, bool_t dolock )
>  {
>  	int nwritten;
>  	
>  	if ( dolock )
>  		INVLOCK( fd, LOCK_EX );
>  	
> -	if ( lseek( fd, (off_t)off, whence ) < 0 ) {
> -		INV_PERROR( _("Error in writing inventory record "
> -			      "(lseek failed): ") );
> -		if ( dolock ) 
> -			INVLOCK( fd, LOCK_UN );
> -		return -1;
> -	}
> -	
> -	if (( nwritten = write( fd, buf, bufsz ) ) != (int) bufsz ) {
> +	nwritten = pwrite(fd, buf, bufsz, (off_t)off);
> +	if (nwritten != (int) bufsz ) {
>  		INV_PERROR( _("Error in writing inventory record :") );
>  		if ( dolock )
>  			INVLOCK( fd, LOCK_UN );
> diff --git a/inventory/inv_idx.c b/inventory/inv_idx.c
> index 95529e8135af..cd9b9cbe7a79 100644
> --- a/inventory/inv_idx.c
> +++ b/inventory/inv_idx.c
> @@ -341,8 +341,8 @@ idx_put_sesstime( inv_sestoken_t tok, bool_t whichtime)
>  			      ent.ie_timeperiod.tp_start,
>  			      ent.ie_timeperiod.tp_end );
>  #endif
> -	rval = PUT_REC_NOLOCK_SEEKCUR( fd, &ent, sizeof( invt_entry_t ),
> -				      -(off64_t)(sizeof( invt_entry_t )));
> +	rval = PUT_REC_NOLOCK(fd, &ent, sizeof(invt_entry_t),
> +			      tok->sd_invtok->d_invindex_off);
>  	
>  #ifdef INVT_DEBUG
>  	{
> diff --git a/inventory/inv_priv.h b/inventory/inv_priv.h
> index 1690271dd3e3..aa94a3349d79 100644
> --- a/inventory/inv_priv.h
> +++ b/inventory/inv_priv.h
> @@ -298,13 +298,10 @@ typedef bool_t (*search_callback_t) (int, invt_seshdr_t *, void *, void *);
>  
>  
>  #define GET_REC( fd, buf, sz, off )  \
> -                 get_invtrecord( fd, buf, sz, off, SEEK_SET, INVT_DOLOCK )
> +                 get_invtrecord( fd, buf, sz, off, INVT_DOLOCK )
>  
>  #define GET_REC_NOLOCK( fd, buf, sz, off )  \
> -                 get_invtrecord( fd, buf, sz, off, SEEK_SET, INVT_DONTLOCK )
> -
> -#define GET_REC_SEEKCUR( fd, buf, sz, off )  \
> -                 get_invtrecord( fd, buf, sz, off, SEEK_CUR, INVT_DOLOCK )
> +                 get_invtrecord( fd, buf, sz, off, INVT_DONTLOCK )
>  
>  #define GET_ALLHDRS_N_CNTS( fd, h, c, hsz, csz ) \
>                   get_headerinfo( fd, h, c, hsz, csz, INVT_DOLOCK )
> @@ -313,16 +310,10 @@ typedef bool_t (*search_callback_t) (int, invt_seshdr_t *, void *, void *);
>                   get_headerinfo( fd, h, c, hsz, csz, INVT_DONTLOCK )
>  
>  #define PUT_REC( fd, buf, sz, off )  \
> -                 put_invtrecord( fd, buf, sz, off, SEEK_SET, INVT_DOLOCK )
> +                 put_invtrecord( fd, buf, sz, off, INVT_DOLOCK )
>  
>  #define PUT_REC_NOLOCK( fd, buf, sz, off )  \
> -                 put_invtrecord( fd, buf, sz, off, SEEK_SET, INVT_DONTLOCK )
> -
> -#define PUT_REC_SEEKCUR( fd, buf, sz, off )  \
> -                 put_invtrecord( fd, buf, sz, off, SEEK_CUR, INVT_DOLOCK )
> -
> -#define PUT_REC_NOLOCK_SEEKCUR( fd, buf, sz, off )  \
> -                 put_invtrecord( fd, buf, sz, off, SEEK_CUR, INVT_DONTLOCK )
> +                 put_invtrecord( fd, buf, sz, off, INVT_DONTLOCK )
>  
>  
>  #define GET_COUNTERS( fd, cnt ) get_counters( fd, (void **)(cnt), \
> @@ -515,10 +506,10 @@ int
>  get_invtentry( char *fname, time32_t tm, invt_entry_t *buf, size_t bufsz );
>  
>  int
> -get_invtrecord( int fd, void *buf, size_t bufsz, off64_t off, int, bool_t dolock );
> +get_invtrecord( int fd, void *buf, size_t bufsz, off64_t off, bool_t dolock );
>  
>  int
> -put_invtrecord( int fd, void *buf, size_t bufsz, off64_t off, int, bool_t dolock );
> +put_invtrecord( int fd, void *buf, size_t bufsz, off64_t off, bool_t dolock );
>  
>  inv_idbtoken_t
>  get_token( int fd, int objfd );
> diff --git a/inventory/testmain.c b/inventory/testmain.c
> index ecddf54c4f90..05e3c02af792 100644
> --- a/inventory/testmain.c
> +++ b/inventory/testmain.c
> @@ -89,6 +89,7 @@ int
>  recons_test( int howmany )
>  {
>  	int fd, i, rval = 1;
> +	off64_t off = 0;
>  	
>  	ses sarr[ SESLIM];
>  	
> @@ -96,14 +97,16 @@ recons_test( int howmany )
>  	
>  	for ( i=0; i<howmany && i < SESLIM; i++ ){
>  		rval = get_invtrecord( fd, &sarr[i], 
> -				       sizeof( uuid_t ) + sizeof( size_t ), 0,
> -				       SEEK_CUR, BOOL_FALSE );
> +				       sizeof( uuid_t ) + sizeof( size_t ), off,
> +				       BOOL_FALSE );
>  		assert( rval > 0 );
>  		assert( sarr[i].sz > 0 );
>  		sarr[i].buf = calloc( 1,  sarr[i].sz );
> -		rval = get_invtrecord( fd, sarr[i].buf,  sarr[i].sz, 0, SEEK_CUR,
> +		off += (off64_t)(sizeof(uuid_t) + sizeof(size_t));
> +		rval = get_invtrecord( fd, sarr[i].buf,  sarr[i].sz, off,
>  				       BOOL_FALSE );
>  		assert( rval > 0 );
> +		off += sarr[i].sz;
>  	}
>  	
>  	
> @@ -132,8 +135,7 @@ delete_test( int n )
>  	fd = open( "moids", O_RDONLY );
>  	if ( fd < 0 ) return -1;
>  	
> -	get_invtrecord( fd, &moid, sizeof(uuid_t), (n-1)* sizeof( uuid_t),
> -		        SEEK_SET, 0 );
> +	get_invtrecord( fd, &moid, sizeof(uuid_t), (n-1)* sizeof( uuid_t), 0 );
>  	uuid_to_string( &moid, &str, &stat );
>  	printf("Searching for Moid = %s\n", str );
>  	free( str );
> @@ -263,7 +265,11 @@ write_test( int nsess, int nstreams, int nmedia, int dumplevel )
>  	char strbuf[128];
>  	void *bufp;
>  	size_t sz;
> +#ifdef RECONS
>  	int rfd;
> +	off64_t off;
> +	struct stat64 statbuf;
> +#endif
>  
>  #ifdef FIRSTTIME
>  	printf("first time!\n");
> @@ -285,6 +291,11 @@ write_test( int nsess, int nstreams, int nmedia, int dumplevel )
>  #ifdef RECONS
>  	rfd = open( sesfile, O_RDWR | O_CREAT );
>  	fchmod( rfd, INV_PERMS );
> +	if (fstat64(fd, &statbuf) < 0) {
> +		perror("fstat64 session file");
> +		return -1;
> +	}
> +	off = (off64_t)statbuf.st_size;
>  #endif
>  
>  	for ( i = 0; i < nsess; i++ ) {
> @@ -325,12 +336,13 @@ write_test( int nsess, int nstreams, int nmedia, int dumplevel )
>  	
>  #ifdef RECONS
>  		if (inv_get_sessioninfo( tok2, &bufp, &sz ) == BOOL_TRUE ) {
> -		      put_invtrecord( rfd, fsidp, sizeof( uuid_t ), 0, 
> -				        SEEK_END, BOOL_FALSE );
> -			
> -			put_invtrecord( rfd, &sz, sizeof( size_t ), 0,
> -				        SEEK_END, BOOL_FALSE); 
> -			put_invtrecord( rfd, bufp, sz, 0, SEEK_END, BOOL_FALSE );
> +			put_invtrecord( rfd, fsidp, sizeof( uuid_t ), off,
> +					BOOL_FALSE );
> +			off += (off64_t)sizeof(uuid_t);
> +			put_invtrecord( rfd, &sz, sizeof( size_t ), off,
> +					BOOL_FALSE);
> +			off += (off64_t)sizeof(size_t);
> +			put_invtrecord( rfd, bufp, sz, off, BOOL_FALSE );
>  		}
>  #endif
>  #ifdef NOTDEF
> 
