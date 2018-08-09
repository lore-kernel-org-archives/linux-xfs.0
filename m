Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35654 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727371AbeHILVA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 9 Aug 2018 07:21:00 -0400
Date: Thu, 9 Aug 2018 10:57:06 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 2/2] [PATCH] xfs: Close race between direct IO and
 xfs_break_layouts()
Message-ID: <20180809085706.GB5069@quack2.suse.cz>
References: <153374910694.40645.17166196534680658204.stgit@djiang5-desk3.ch.intel.com>
 <153374915981.40645.3350205963852459041.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153374915981.40645.3350205963852459041.stgit@djiang5-desk3.ch.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Jiang <dave.jiang@intel.com>
Cc: tytso@mit.edu, darrick.wong@oracle.com, jack@suse.cz, zwisler@kernel.org, linux-nvdimm@lists.01.org, david@fromorbit.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, lczerner@redhat.com, linux-ext4@vger.kernel.org, hch@lst.de

On Wed 08-08-18 10:26:36, Dave Jiang wrote:
> This patch is the duplicate of ross's fix for ext4 for xfs.
> 
> If the refcount of a page is lowered between the time that it is returned
> by dax_busy_page() and when the refcount is again checked in
> xfs_break_layouts() => ___wait_var_event(), the waiting function
> xfs_wait_dax_page() will never be called.  This means that
> xfs_break_layouts() will still have 'retry' set to false, so we'll stop
> looping and never check the refcount of other pages in this inode.
> 
> Instead, always continue looping as long as dax_layout_busy_page() gives us
> a page which it found with an elevated refcount.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>

I think I gave you my reviewed-by tag already for the previous version. But
here it is again:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> 
> v2:
> - Rename parameter from did_unlock to retry (Jan) 
> 
>  fs/xfs/xfs_file.c |    9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index a3e7767a5715..cd6f0d8c4922 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -721,12 +721,10 @@ xfs_file_write_iter(
>  
>  static void
>  xfs_wait_dax_page(
> -	struct inode		*inode,
> -	bool			*did_unlock)
> +	struct inode		*inode)
>  {
>  	struct xfs_inode        *ip = XFS_I(inode);
>  
> -	*did_unlock = true;
>  	xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
>  	schedule();
>  	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
> @@ -736,7 +734,7 @@ static int
>  xfs_break_dax_layouts(
>  	struct inode		*inode,
>  	uint			iolock,
> -	bool			*did_unlock)
> +	bool			*retry)
>  {
>  	struct page		*page;
>  
> @@ -746,9 +744,10 @@ xfs_break_dax_layouts(
>  	if (!page)
>  		return 0;
>  
> +	*retry = true;
>  	return ___wait_var_event(&page->_refcount,
>  			atomic_read(&page->_refcount) == 1, TASK_INTERRUPTIBLE,
> -			0, 0, xfs_wait_dax_page(inode, did_unlock));
> +			0, 0, xfs_wait_dax_page(inode));
>  }
>  
>  int
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
