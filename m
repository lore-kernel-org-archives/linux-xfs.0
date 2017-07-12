Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:51846 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752434AbdGLSqa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 Jul 2017 14:46:30 -0400
Received: from [10.0.0.114] (provider [10.0.0.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id BD0B87FC379
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2017 13:46:10 -0500 (CDT)
Subject: Re: [PATCH] xfsdump: fix race condition between lseek() and
 read()/write()
References: <1461244016-7373-1-git-send-email-eguan@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <9253902d-060e-77d7-84af-b5faa1a43e92@sandeen.net>
Date: Wed, 12 Jul 2017 13:46:29 -0500
MIME-Version: 1.0
In-Reply-To: <1461244016-7373-1-git-send-email-eguan@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>



On 04/21/2016 08:06 AM, Eryu Guan wrote:
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

This seems ok to me; it seems safer and more obvious than changing up
the locking to use pthread locks ... I guess my only handwavy concern is
whether the offsets PUT_REC_NOLOCK are correct?  See below

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

        rval = GET_REC_NOLOCK( fd, &ent, sizeof( invt_entry_t ),
                                tok->sd_invtok->d_invindex_off);

This sets the offset to d_invindex_off


>  			      ent.ie_timeperiod.tp_start,
>  			      ent.ie_timeperiod.tp_end );
>  #endif
> -	rval = PUT_REC_NOLOCK_SEEKCUR( fd, &ent, sizeof( invt_entry_t ),
> -				      -(off64_t)(sizeof( invt_entry_t )));

This backed up one entry from the current offset...

> +	rval = PUT_REC_NOLOCK(fd, &ent, sizeof(invt_entry_t),
> +			      tok->sd_invtok->d_invindex_off);

but this keeps it at the current offset, no?  Isn't this a different behavior?

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
> 
