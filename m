Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:37758 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725870AbfHKXLI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 11 Aug 2019 19:11:08 -0400
Date: Mon, 12 Aug 2019 09:09:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] vfs: fix page locking deadlocks when deduping files
Message-ID: <20190811230955.GG7777@dread.disaster.area>
References: <156527561023.1960675.17007470833732765300.stgit@magnolia>
 <156527561641.1960675.7113883901730327475.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156527561641.1960675.7113883901730327475.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Aug 08, 2019 at 07:46:56AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When dedupe wants to use the page cache to compare parts of two files
> for dedupe, we must be very careful to handle locking correctly.  The
> current code doesn't do this.  It must lock and unlock the page only
> once if the two pages are the same, since the overlapping range check
> doesn't catch this when blocksize < pagesize.  If the pages are distinct
> but from the same file, we must observe page locking order and lock them
> in order of increasing offset to avoid clashing with writeback locking.
> 
> Fixes: 876bec6f9bbfcb3 ("vfs: refactor clone/dedupe_file_range common functions")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/read_write.c |   36 ++++++++++++++++++++++++++++--------
>  1 file changed, 28 insertions(+), 8 deletions(-)
> 
> 
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 1f5088dec566..4dbdccffa59e 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -1811,10 +1811,7 @@ static int generic_remap_check_len(struct inode *inode_in,
>  	return (remap_flags & REMAP_FILE_DEDUP) ? -EBADE : -EINVAL;
>  }
>  
> -/*
> - * Read a page's worth of file data into the page cache.  Return the page
> - * locked.
> - */
> +/* Read a page's worth of file data into the page cache. */
>  static struct page *vfs_dedupe_get_page(struct inode *inode, loff_t offset)
>  {
>  	struct page *page;
> @@ -1826,10 +1823,32 @@ static struct page *vfs_dedupe_get_page(struct inode *inode, loff_t offset)
>  		put_page(page);
>  		return ERR_PTR(-EIO);
>  	}
> -	lock_page(page);
>  	return page;
>  }
>  
> +/*
> + * Lock two pages, ensuring that we lock in offset order if the pages are from
> + * the same file.
> + */
> +static void vfs_lock_two_pages(struct page *page1, struct page *page2)
> +{
> +	/* Always lock in order of increasing index. */
> +	if (page1->index > page2->index)
> +		swap(page1, page2);
> +
> +	lock_page(page1);
> +	if (page1 != page2)
> +		lock_page(page2);
> +}
> +
> +/* Unlock two pages, being careful not to unlock the same page twice. */
> +static void vfs_unlock_two_pages(struct page *page1, struct page *page2)
> +{
> +	unlock_page(page1);
> +	if (page1 != page2)
> +		unlock_page(page2);
> +}
> +
>  /*
>   * Compare extents of two files to see if they are the same.
>   * Caller must have locked both inodes to prevent write races.
> @@ -1867,10 +1886,12 @@ static int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
>  		dest_page = vfs_dedupe_get_page(dest, destoff);
>  		if (IS_ERR(dest_page)) {
>  			error = PTR_ERR(dest_page);
> -			unlock_page(src_page);
>  			put_page(src_page);
>  			goto out_error;
>  		}
> +
> +		vfs_lock_two_pages(src_page, dest_page);
> +

Locking looks fine now, but....

... don't we need to check for invalidation races on the source page
here because the src inode is only locked shared and so can race with
things like direct IO under shared inode locking doing invalidation?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
