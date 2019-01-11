Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46818 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729349AbfAKQ2k (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 11 Jan 2019 11:28:40 -0500
Date: Fri, 11 Jan 2019 11:28:38 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 01/12] xfs: free COW staging extents when freezing
 filesystem
Message-ID: <20190111162837.GA33275@bfoster>
References: <154630901076.16693.13111277988041606505.stgit@magnolia>
 <154630901708.16693.4337908735292154622.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154630901708.16693.4337908735292154622.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Dec 31, 2018 at 06:16:57PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When we're freezing the filesystem, free all the COW staging extents
> before we shut the log down so that we can minimize the amount of
> recovery work that will be necessary during the next mount.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_icache.c |   17 ++++++++++++-----
>  fs/xfs/xfs_super.c  |   18 ++++++++++++++++++
>  2 files changed, 30 insertions(+), 5 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 245483cc282b..36d986087abb 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1741,6 +1741,7 @@ xfs_inode_free_cowblocks(
>  	void			*args)
>  {
>  	struct xfs_eofblocks	*eofb = args;
> +	uint			lock_mode = 0;
>  	int			match;
>  	int			ret = 0;
>  
> @@ -1761,9 +1762,15 @@ xfs_inode_free_cowblocks(
>  			return 0;
>  	}
>  
> -	/* Free the CoW blocks */
> -	xfs_ilock(ip, XFS_IOLOCK_EXCL);
> -	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
> +	/*
> +	 * Free the CoW blocks.  We don't need to lock the inode if we're in
> +	 * the process of freezing the filesystem because we've already locked
> +	 * out writes and page faults.
> +	 */
> +	if (ip->i_mount->m_super->s_writers.frozen == SB_UNFROZEN)
> +		lock_mode = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;

Ok, but is there a problem with actually locking in this context? If so,
I'd expect the comment to say something like: "Free the COW blocks.
Don't lock the inode if we're in the process of freezing the filesystem
because <some bad thing happens>. This is safe because we've already
locked out writes and page faults."

> +	if (lock_mode)
> +		xfs_ilock(ip, lock_mode);
>  
>  	/*
>  	 * Check again, nobody else should be able to dirty blocks or change
> @@ -1772,8 +1779,8 @@ xfs_inode_free_cowblocks(
>  	if (xfs_prep_free_cowblocks(ip))
>  		ret = xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF, false);
>  
> -	xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
> -	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
> +	if (lock_mode)
> +		xfs_iunlock(ip, lock_mode);
>  
>  	return ret;
>  }
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 6903b36eac5d..bb4953cfd683 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1102,6 +1102,24 @@ xfs_fs_sync_fs(
>  	if (!wait)
>  		return 0;
>  
> +	/*
> +	 * If we're in the middle of freezing the filesystem, this is our last
> +	 * chance to run regular transactions.  Clear all the COW staging
> +	 * extents so that we can freeze the filesystem with as little recovery
> +	 * work to do at the next mount as possible.  It's safe to do this
> +	 * without locking inodes because the freezer code flushed all the
> +	 * dirty data from the page cache and locked out writes and page faults.
> +	 */

Well, we have XFS_TRANS_NO_WRITECOUNT. It seems we could use an eofb
freeze flag or some such to notify the scan that we're in a special
freeze context and in turn use that to tweak the locking (instead of the
SB_FREEZE_* checks) and avoid blocking on transaction allocation. Would
that allow us to run this in xfs_fs_freeze() context?

I'm also a little curious about the high-level tradeoff we're making.
This patch means that a freeze, and thus something like an LVM snapshot,
would clear/reset all COW blocks in the fs, right? If so, ISTM that
could be annoying if the user had a bunch of reflinked vdisk images or
something on the fs.

Is the tradeoff just that if the user freezes and then doesn't unfreeze
before the next mount that log recovery will have to deal with COW
blocks, or are there considerations for a typical freeze/unfreeze cycle
as well? Is this more expensive at recovery time than at freeze time?

Brian

> +	if (sb->s_writers.frozen == SB_FREEZE_PAGEFAULT) {
> +		int		error;
> +
> +		error = xfs_icache_free_cowblocks(mp, NULL);
> +		if (error) {
> +			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> +			return error;
> +		}
> +	}
> +
>  	xfs_log_force(mp, XFS_LOG_SYNC);
>  	if (laptop_mode) {
>  		/*
> 
