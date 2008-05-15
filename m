Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 May 2008 09:17:28 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4FGHIVr012947
	for <xfs@oss.sgi.com>; Thu, 15 May 2008 09:17:19 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AB5CB1723B8
	for <xfs@oss.sgi.com>; Thu, 15 May 2008 09:18:06 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id IXm5aHdu17OKzuEy for <xfs@oss.sgi.com>; Thu, 15 May 2008 09:18:06 -0700 (PDT)
Message-ID: <482C623D.7070208@sandeen.net>
Date: Thu, 15 May 2008 11:18:05 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] fix memory corruption with small buffer reads
References: <20080515142306.GA29842@lst.de>
In-Reply-To: <20080515142306.GA29842@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> When we have multiple buffers in a single page for a blocksize == pagesize
> filesystem we might overwrite the page contents if two callers hit it
> shortly after each other.  To prevent that we need to keep the page
> locked until I/O is completed and the page marked uptodate.
> 
> Thanks to Eric Sandeen for triaging this bug and finding a reproducible
> testcase and Dave Chinner for additional advice.
> 
> This should fix kernel.org bz #10421.

Oh, this should go to -stable too, when everyone is happy with it...

Thanks,

-Eric

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_buf.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_buf.c	2008-05-15 11:45:10.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_buf.c	2008-05-15 15:26:09.000000000 +0200
> @@ -386,6 +386,8 @@ _xfs_buf_lookup_pages(
>  		if (unlikely(page == NULL)) {
>  			if (flags & XBF_READ_AHEAD) {
>  				bp->b_page_count = i;
> +				for (i = 0; i < bp->b_page_count; i++)
> +					unlock_page(bp->b_pages[i]);
>  				return -ENOMEM;
>  			}
>  
> @@ -415,17 +417,24 @@ _xfs_buf_lookup_pages(
>  		ASSERT(!PagePrivate(page));
>  		if (!PageUptodate(page)) {
>  			page_count--;
> -			if (blocksize < PAGE_CACHE_SIZE && !PagePrivate(page)) {
> +			if (blocksize >= PAGE_CACHE_SIZE) {
> +				if (flags & XBF_READ)
> +					bp->b_flags |= _XBF_PAGE_LOCKED;
> +			} else if (!PagePrivate(page)) {
>  				if (test_page_region(page, offset, nbytes))
>  					page_count++;
>  			}
>  		}
>  
> -		unlock_page(page);
>  		bp->b_pages[i] = page;
>  		offset = 0;
>  	}
>  
> +	if (!(bp->b_flags & _XBF_PAGE_LOCKED)) {
> +		for (i = 0; i < bp->b_page_count; i++)
> +			unlock_page(bp->b_pages[i]);
> +	}
> +
>  	if (page_count == bp->b_page_count)
>  		bp->b_flags |= XBF_DONE;
>  
> @@ -746,6 +755,7 @@ xfs_buf_associate_memory(
>  	bp->b_count_desired = len;
>  	bp->b_buffer_length = buflen;
>  	bp->b_flags |= XBF_MAPPED;
> +	bp->b_flags &= ~_XBF_PAGE_LOCKED;
>  
>  	return 0;
>  }
> @@ -1093,8 +1103,10 @@ _xfs_buf_ioend(
>  	xfs_buf_t		*bp,
>  	int			schedule)
>  {
> -	if (atomic_dec_and_test(&bp->b_io_remaining) == 1)
> +	if (atomic_dec_and_test(&bp->b_io_remaining) == 1) {
> +		bp->b_flags &= ~_XBF_PAGE_LOCKED;
>  		xfs_buf_ioend(bp, schedule);
> +	}
>  }
>  
>  STATIC void
> @@ -1125,6 +1137,9 @@ xfs_buf_bio_end_io(
>  
>  		if (--bvec >= bio->bi_io_vec)
>  			prefetchw(&bvec->bv_page->flags);
> +
> +		if (bp->b_flags & _XBF_PAGE_LOCKED)
> +			unlock_page(page);
>  	} while (bvec >= bio->bi_io_vec);
>  
>  	_xfs_buf_ioend(bp, 1);
> @@ -1163,7 +1178,8 @@ _xfs_buf_ioapply(
>  	 * filesystem block size is not smaller than the page size.
>  	 */
>  	if ((bp->b_buffer_length < PAGE_CACHE_SIZE) &&
> -	    (bp->b_flags & XBF_READ) &&
> +	    ((bp->b_flags & (XBF_READ|_XBF_PAGE_LOCKED)) ==
> +	      (XBF_READ|_XBF_PAGE_LOCKED)) &&
>  	    (blocksize >= PAGE_CACHE_SIZE)) {
>  		bio = bio_alloc(GFP_NOIO, 1);
>  
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_buf.h
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_buf.h	2008-05-15 11:45:10.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_buf.h	2008-05-15 15:26:09.000000000 +0200
> @@ -66,6 +66,25 @@ typedef enum {
>  	_XBF_PAGES = (1 << 18),	    /* backed by refcounted pages	   */
>  	_XBF_RUN_QUEUES = (1 << 19),/* run block device task queue	   */
>  	_XBF_DELWRI_Q = (1 << 21),   /* buffer on delwri queue		   */
> +
> +	/*
> +	 * Special flag for supporting metadata blocks smaller than a FSB.
> +	 *
> +	 * In this case we can have multiple xfs_buf_t on a single page and
> +	 * need to lock out concurrent xfs_buf_t readers as they only
> +	 * serialise access to the buffer.
> +	 *
> +	 * If the FSB size >= PAGE_CACHE_SIZE case, we have no serialisation
> +	 * between reads of the page. Hence we can have one thread read the
> +	 * page and modify it, but then race with another thread that thinks
> +	 * the page is not up-to-date and hence reads it again.
> +	 *
> +	 * The result is that the first modifcation to the page is lost.
> +	 * This sort of AGF/AGI reading race can happen when unlinking inodes
> +	 * that require truncation and results in the AGI unlinked list
> +	 * modifications being lost.
> +	 */
> +	_XBF_PAGE_LOCKED = (1 << 22),
>  } xfs_buf_flags_t;
>  
>  typedef enum {
> 
> 
