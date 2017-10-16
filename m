Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35500 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751722AbdJPLXC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Oct 2017 07:23:02 -0400
Date: Mon, 16 Oct 2017 19:23:00 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] fs: invalidate page cache after end_io() in dio
 completion
Message-ID: <20171016112300.GC10593@eguan.usersys.redhat.com>
References: <20171003160201.11208-1-eguan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171003160201.11208-1-eguan@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, Jan Kara <jack@suse.cz>

On Wed, Oct 04, 2017 at 12:02:01AM +0800, Eryu Guan wrote:
> Commit 332391a9935d ("fs: Fix page cache inconsistency when mixing
> buffered and AIO DIO") moved page cache invalidation from
> iomap_dio_rw() to iomap_dio_complete() for iomap based direct write
> path, but before the dio->end_io() call, and it re-introdued the bug
> fixed by commit c771c14baa33 ("iomap: invalidate page caches should
> be after iomap_dio_complete() in direct write").
> 
> I found this because fstests generic/418 started failing on XFS with
> v4.14-rc3 kernel, which is the regression test for this specific
> bug.
> 
> So similarly, fix it by moving dio->end_io() (which does the
> unwritten extent conversion) before page cache invalidation, to make
> sure next buffer read reads the final real allocations not unwritten
> extents. I also add some comments about why should end_io() go first
> in case we get it wrong again in the future.
> 
> Note that, there's no such problem in the non-iomap based direct
> write path, because we didn't remove the page cache invalidation
> after the ->direct_IO() in generic_file_direct_write() call, but I
> decided to fix dio_complete() too so we don't leave a landmine
> there, also be consistent with iomap_dio_complete().
> 
> Fixes: 332391a9935d ("fs: Fix page cache inconsistency when mixing buffered and AIO DIO")
> Signed-off-by: Eryu Guan <eguan@redhat.com>

Ping on this patch, and cc Jan for broader attention.

It fixed a regression (re-)introduced in v4.14-rc3, and currently only
XFS was affected (because of the iomap based DIO adoption). I've tested
it with the reproducer generic/418, LTP and full rounds of fstests runs
with different feature and block size enabled.

Thanks,
Eryu

> ---
>  fs/direct-io.c | 20 ++++++++++++--------
>  fs/iomap.c     | 41 ++++++++++++++++++++++++-----------------
>  2 files changed, 36 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/direct-io.c b/fs/direct-io.c
> index 62cf812ed0e5..1dba6842c349 100644
> --- a/fs/direct-io.c
> +++ b/fs/direct-io.c
> @@ -259,12 +259,24 @@ static ssize_t dio_complete(struct dio *dio, ssize_t ret, bool is_async)
>  	if (ret == 0)
>  		ret = transferred;
>  
> +	if (dio->end_io) {
> +		// XXX: ki_pos??
> +		err = dio->end_io(dio->iocb, offset, ret, dio->private);
> +		if (err)
> +			ret = err;
> +	}
> +
>  	/*
>  	 * Try again to invalidate clean pages which might have been cached by
>  	 * non-direct readahead, or faulted in by get_user_pages() if the source
>  	 * of the write was an mmap'ed region of the file we're writing.  Either
>  	 * one is a pretty crazy thing to do, so we don't support it 100%.  If
>  	 * this invalidation fails, tough, the write still worked...
> +	 *
> +	 * And this page cache invalidation has to be after dio->end_io(), as
> +	 * some filesystems convert unwritten extents to real allocations in
> +	 * end_io() when necessary, otherwise a racing buffer read would cache
> +	 * zeros from unwritten extents.
>  	 */
>  	if (ret > 0 && dio->op == REQ_OP_WRITE &&
>  	    dio->inode->i_mapping->nrpages) {
> @@ -274,14 +286,6 @@ static ssize_t dio_complete(struct dio *dio, ssize_t ret, bool is_async)
>  		WARN_ON_ONCE(err);
>  	}
>  
> -	if (dio->end_io) {
> -
> -		// XXX: ki_pos??
> -		err = dio->end_io(dio->iocb, offset, ret, dio->private);
> -		if (err)
> -			ret = err;
> -	}
> -
>  	if (!(dio->flags & DIO_SKIP_DIO_COUNT))
>  		inode_dio_end(dio->inode);
>  
> diff --git a/fs/iomap.c b/fs/iomap.c
> index be61cf742b5e..d4801f8dd4fd 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -714,23 +714,9 @@ static ssize_t iomap_dio_complete(struct iomap_dio *dio)
>  {
>  	struct kiocb *iocb = dio->iocb;
>  	struct inode *inode = file_inode(iocb->ki_filp);
> +	loff_t offset = iocb->ki_pos;
>  	ssize_t ret;
>  
> -	/*
> -	 * Try again to invalidate clean pages which might have been cached by
> -	 * non-direct readahead, or faulted in by get_user_pages() if the source
> -	 * of the write was an mmap'ed region of the file we're writing.  Either
> -	 * one is a pretty crazy thing to do, so we don't support it 100%.  If
> -	 * this invalidation fails, tough, the write still worked...
> -	 */
> -	if (!dio->error &&
> -	    (dio->flags & IOMAP_DIO_WRITE) && inode->i_mapping->nrpages) {
> -		ret = invalidate_inode_pages2_range(inode->i_mapping,
> -				iocb->ki_pos >> PAGE_SHIFT,
> -				(iocb->ki_pos + dio->size - 1) >> PAGE_SHIFT);
> -		WARN_ON_ONCE(ret);
> -	}
> -
>  	if (dio->end_io) {
>  		ret = dio->end_io(iocb,
>  				dio->error ? dio->error : dio->size,
> @@ -742,12 +728,33 @@ static ssize_t iomap_dio_complete(struct iomap_dio *dio)
>  	if (likely(!ret)) {
>  		ret = dio->size;
>  		/* check for short read */
> -		if (iocb->ki_pos + ret > dio->i_size &&
> +		if (offset + ret > dio->i_size &&
>  		    !(dio->flags & IOMAP_DIO_WRITE))
> -			ret = dio->i_size - iocb->ki_pos;
> +			ret = dio->i_size - offset;
>  		iocb->ki_pos += ret;
>  	}
>  
> +	/*
> +	 * Try again to invalidate clean pages which might have been cached by
> +	 * non-direct readahead, or faulted in by get_user_pages() if the source
> +	 * of the write was an mmap'ed region of the file we're writing.  Either
> +	 * one is a pretty crazy thing to do, so we don't support it 100%.  If
> +	 * this invalidation fails, tough, the write still worked...
> +	 *
> +	 * And this page cache invalidation has to be after dio->end_io(), as
> +	 * some filesystems convert unwritten extents to real allocations in
> +	 * end_io() when necessary, otherwise a racing buffer read would cache
> +	 * zeros from unwritten extents.
> +	 */
> +	if (!dio->error &&
> +	    (dio->flags & IOMAP_DIO_WRITE) && inode->i_mapping->nrpages) {
> +		int err;
> +		err = invalidate_inode_pages2_range(inode->i_mapping,
> +				offset >> PAGE_SHIFT,
> +				(offset + dio->size - 1) >> PAGE_SHIFT);
> +		WARN_ON_ONCE(err);
> +	}
> +
>  	inode_dio_end(file_inode(iocb->ki_filp));
>  	kfree(dio);
>  
> -- 
> 2.13.6
> 
