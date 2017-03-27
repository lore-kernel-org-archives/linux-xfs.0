Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19116 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752110AbdC0UV3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Mar 2017 16:21:29 -0400
Date: Mon, 27 Mar 2017 13:20:30 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfsdump: fix race condition between lseek() and
 read()/write()
Message-ID: <20170327202030.GK5722@birch.djwong.org>
References: <1461244016-7373-1-git-send-email-eguan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1461244016-7373-1-git-send-email-eguan@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>

[move to new list]

On Thu, Apr 21, 2016 at 09:06:56PM +0800, Eryu Guan wrote:
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
> 
> Also convert and remove all *_SEEKCUR routines to "SEEK_SET" variants,
> because they depend on the maintenance of current file offset, but
> pread()/pwrite() don't change file offset.
> 
> Signed-off-by: Eryu Guan <eguan@redhat.com>
> ---
> 
> Tested via the reproducer and xfstests "-g dump" run, with both v4 and v5 XFS.
> 
> I'm not sure if this is the right fix, perhaps what should be fixed is the
> "INVLOCK()", which is now implemented by flock(2), and doesn't work in
> multi-thread env, if what it's meant to protect is concurrent accesses from
> different threads, not processes.
> 
> If so, it seems to me that making INVLOCK() a pthread rw lock could fix the
> race condition as well. But the INVLOCK calls are almost everywhere, I didn't
> find a simple way to try it.

I wonder, did this ever make any progress?  Offhand it looks ok, but then
I'm no xfsdump expert.

(Yes, our QA is bugging me about xfs/302 failures too...)

--D

> 
>  common/inventory.c   |  4 ++--
>  inventory/inv_api.c  |  5 ++---
>  inventory/inv_core.c | 24 ++++--------------------
>  inventory/inv_idx.c  |  4 ++--
>  inventory/inv_priv.h |  9 ---------
>  5 files changed, 10 insertions(+), 36 deletions(-)
> 
> diff --git a/common/inventory.c b/common/inventory.c
> index d1b810c..0e9c256 100644
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
> index acca40b..46fdde8 100644
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
> index a17c2c9..42d0ac4 100644
> --- a/inventory/inv_core.c
> +++ b/inventory/inv_core.c
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
> @@ -162,15 +153,8 @@ put_invtrecord( int fd, void *buf, size_t bufsz, off64_t off,
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
> index 95529e8..cd9b9cb 100644
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
> index 1690271..cd1b527 100644
> --- a/inventory/inv_priv.h
> +++ b/inventory/inv_priv.h
> @@ -303,9 +303,6 @@ typedef bool_t (*search_callback_t) (int, invt_seshdr_t *, void *, void *);
>  #define GET_REC_NOLOCK( fd, buf, sz, off )  \
>                   get_invtrecord( fd, buf, sz, off, SEEK_SET, INVT_DONTLOCK )
>  
> -#define GET_REC_SEEKCUR( fd, buf, sz, off )  \
> -                 get_invtrecord( fd, buf, sz, off, SEEK_CUR, INVT_DOLOCK )
> -
>  #define GET_ALLHDRS_N_CNTS( fd, h, c, hsz, csz ) \
>                   get_headerinfo( fd, h, c, hsz, csz, INVT_DOLOCK )
>  
> @@ -318,12 +315,6 @@ typedef bool_t (*search_callback_t) (int, invt_seshdr_t *, void *, void *);
>  #define PUT_REC_NOLOCK( fd, buf, sz, off )  \
>                   put_invtrecord( fd, buf, sz, off, SEEK_SET, INVT_DONTLOCK )
>  
> -#define PUT_REC_SEEKCUR( fd, buf, sz, off )  \
> -                 put_invtrecord( fd, buf, sz, off, SEEK_CUR, INVT_DOLOCK )
> -
> -#define PUT_REC_NOLOCK_SEEKCUR( fd, buf, sz, off )  \
> -                 put_invtrecord( fd, buf, sz, off, SEEK_CUR, INVT_DONTLOCK )
> -
>  
>  #define GET_COUNTERS( fd, cnt ) get_counters( fd, (void **)(cnt), \
>  					      sizeof(invt_counter_t) )
> -- 
> 2.5.5
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
