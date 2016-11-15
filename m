Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39144 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965289AbcKOPeM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 15 Nov 2016 10:34:12 -0500
Date: Tue, 15 Nov 2016 10:34:10 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/5] xfs: remove i_iolock and use i_rwsem in the VFS
 inode instead
Message-ID: <20161115153408.GA65218@bfoster.bfoster>
References: <1479064054-10474-1-git-send-email-hch@lst.de>
 <1479064054-10474-3-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1479064054-10474-3-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Sun, Nov 13, 2016 at 08:07:31PM +0100, Christoph Hellwig wrote:
> This patch drops the XFS-own i_iolock and uses the VFS i_rwsem which
> recently replaced i_mutex instead.  This means we only have to take
> one looks instead of two in many fast path operations, and we can
> also shrink the xfs_inode structure.  Thanks to the xfs_ilock family
> there is very little churn, the only thing of note is that we need
> to switch to use the lock_two_directory helper for taking the i_rwsem
> on two inodes in a few places to make sure our lock order matches
> the one used in the VFS.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_aops.c         |  7 ++--
>  fs/xfs/xfs_bmap_util.c    | 12 +++----
>  fs/xfs/xfs_dir2_readdir.c |  2 --
>  fs/xfs/xfs_file.c         | 79 +++++++++++++--------------------------------
>  fs/xfs/xfs_icache.c       |  6 ++--
>  fs/xfs/xfs_inode.c        | 82 +++++++++++++++++++----------------------------
>  fs/xfs/xfs_inode.h        |  7 ++--
>  fs/xfs/xfs_ioctl.c        |  2 +-
>  fs/xfs/xfs_iops.c         | 14 ++++----
>  fs/xfs/xfs_pnfs.c         |  7 +---
>  fs/xfs/xfs_pnfs.h         |  4 +--
>  fs/xfs/xfs_reflink.c      | 14 +++-----
>  fs/xfs/xfs_super.c        |  2 +-
>  fs/xfs/xfs_symlink.c      |  7 ++--
>  14 files changed, 86 insertions(+), 159 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 73bfc9e..2b350d0 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -1584,7 +1584,6 @@ xfs_vm_bmap(
>  	struct xfs_inode	*ip = XFS_I(inode);
>  
>  	trace_xfs_vm_bmap(XFS_I(inode));
> -	xfs_ilock(ip, XFS_IOLOCK_SHARED);
>  
>  	/*
>  	 * The swap code (ab-)uses ->bmap to get a block mapping and then
> @@ -1592,12 +1591,10 @@ xfs_vm_bmap(
>  	 * that on reflinks inodes, so we have to skip out here.  And yes,
>  	 * 0 is the magic code for a bmap error..
>  	 */
> -	if (xfs_is_reflink_inode(ip)) {
> -		xfs_iunlock(ip, XFS_IOLOCK_SHARED);
> +	if (xfs_is_reflink_inode(ip))
>  		return 0;
> -	}
> +
>  	filemap_write_and_wait(mapping);
> -	xfs_iunlock(ip, XFS_IOLOCK_SHARED);

The commit log makes no mention of dropping lock usage, unless I missed
where the inode lock is taken elsewhere..?

>  	return generic_block_bmap(mapping, block, xfs_get_blocks);
>  }
>  
...
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 4e560e6..e9ab42d 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
...
> @@ -370,8 +373,9 @@ xfs_isilocked(
>  
>  	if (lock_flags & (XFS_IOLOCK_EXCL|XFS_IOLOCK_SHARED)) {
>  		if (!(lock_flags & XFS_IOLOCK_SHARED))
> -			return !!ip->i_iolock.mr_writer;
> -		return rwsem_is_locked(&ip->i_iolock.mr_lock);
> +			return !debug_locks ||
> +				lockdep_is_held_type(&VFS_I(ip)->i_rwsem, 0);
> +		return rwsem_is_locked(&VFS_I(ip)->i_rwsem);

So if I read this correctly, we can no longer safely assert that an
inode is not exclusively locked because the debug_locks == 0 case would
always tell us it is. It doesn't look like we do that today, but it
warrants a comment IMO.

Otherwise looks Ok to me..

Brian

>  	}
>  
>  	ASSERT(0);
> @@ -421,11 +425,7 @@ xfs_lock_inumorder(int lock_mode, int subclass)
>  
>  	if (lock_mode & (XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL)) {
>  		ASSERT(subclass <= XFS_IOLOCK_MAX_SUBCLASS);
> -		ASSERT(xfs_lockdep_subclass_ok(subclass +
> -						XFS_IOLOCK_PARENT_VAL));
>  		class += subclass << XFS_IOLOCK_SHIFT;
> -		if (lock_mode & XFS_IOLOCK_PARENT)
> -			class += XFS_IOLOCK_PARENT_VAL << XFS_IOLOCK_SHIFT;
>  	}
>  
>  	if (lock_mode & (XFS_MMAPLOCK_SHARED|XFS_MMAPLOCK_EXCL)) {
> @@ -477,8 +477,6 @@ xfs_lock_inodes(
>  			    XFS_ILOCK_EXCL));
>  	ASSERT(!(lock_mode & (XFS_IOLOCK_SHARED | XFS_MMAPLOCK_SHARED |
>  			      XFS_ILOCK_SHARED)));
> -	ASSERT(!(lock_mode & XFS_IOLOCK_EXCL) ||
> -		inodes <= XFS_IOLOCK_MAX_SUBCLASS + 1);
>  	ASSERT(!(lock_mode & XFS_MMAPLOCK_EXCL) ||
>  		inodes <= XFS_MMAPLOCK_MAX_SUBCLASS + 1);
>  	ASSERT(!(lock_mode & XFS_ILOCK_EXCL) ||
> @@ -581,10 +579,8 @@ xfs_lock_two_inodes(
>  	int			attempts = 0;
>  	xfs_log_item_t		*lp;
>  
> -	if (lock_mode & (XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL)) {
> -		ASSERT(!(lock_mode & (XFS_MMAPLOCK_SHARED|XFS_MMAPLOCK_EXCL)));
> -		ASSERT(!(lock_mode & (XFS_ILOCK_SHARED|XFS_ILOCK_EXCL)));
> -	} else if (lock_mode & (XFS_MMAPLOCK_SHARED|XFS_MMAPLOCK_EXCL))
> +	ASSERT(!(lock_mode & (XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL)));
> +	if (lock_mode & (XFS_MMAPLOCK_SHARED|XFS_MMAPLOCK_EXCL))
>  		ASSERT(!(lock_mode & (XFS_ILOCK_SHARED|XFS_ILOCK_EXCL)));
>  
>  	ASSERT(ip0->i_ino != ip1->i_ino);
> @@ -715,7 +711,6 @@ xfs_lookup(
>  	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
>  		return -EIO;
>  
> -	xfs_ilock(dp, XFS_IOLOCK_SHARED);
>  	error = xfs_dir_lookup(NULL, dp, name, &inum, ci_name);
>  	if (error)
>  		goto out_unlock;
> @@ -724,14 +719,12 @@ xfs_lookup(
>  	if (error)
>  		goto out_free_name;
>  
> -	xfs_iunlock(dp, XFS_IOLOCK_SHARED);
>  	return 0;
>  
>  out_free_name:
>  	if (ci_name)
>  		kmem_free(ci_name->name);
>  out_unlock:
> -	xfs_iunlock(dp, XFS_IOLOCK_SHARED);
>  	*ipp = NULL;
>  	return error;
>  }
> @@ -1215,8 +1208,7 @@ xfs_create(
>  	if (error)
>  		goto out_release_inode;
>  
> -	xfs_ilock(dp, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL |
> -		      XFS_IOLOCK_PARENT | XFS_ILOCK_PARENT);
> +	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
>  	unlock_dp_on_error = true;
>  
>  	xfs_defer_init(&dfops, &first_block);
> @@ -1252,7 +1244,7 @@ xfs_create(
>  	 * the transaction cancel unlocking dp so don't do it explicitly in the
>  	 * error path.
>  	 */
> -	xfs_trans_ijoin(tp, dp, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
>  	unlock_dp_on_error = false;
>  
>  	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
> @@ -1325,7 +1317,7 @@ xfs_create(
>  	xfs_qm_dqrele(pdqp);
>  
>  	if (unlock_dp_on_error)
> -		xfs_iunlock(dp, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
> +		xfs_iunlock(dp, XFS_ILOCK_EXCL);
>  	return error;
>  }
>  
> @@ -1466,11 +1458,10 @@ xfs_link(
>  	if (error)
>  		goto std_return;
>  
> -	xfs_ilock(tdp, XFS_IOLOCK_EXCL | XFS_IOLOCK_PARENT);
>  	xfs_lock_two_inodes(sip, tdp, XFS_ILOCK_EXCL);
>  
>  	xfs_trans_ijoin(tp, sip, XFS_ILOCK_EXCL);
> -	xfs_trans_ijoin(tp, tdp, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, tdp, XFS_ILOCK_EXCL);
>  
>  	/*
>  	 * If we are using project inheritance, we only allow hard link
> @@ -2579,10 +2570,9 @@ xfs_remove(
>  		goto std_return;
>  	}
>  
> -	xfs_ilock(dp, XFS_IOLOCK_EXCL | XFS_IOLOCK_PARENT);
>  	xfs_lock_two_inodes(dp, ip, XFS_ILOCK_EXCL);
>  
> -	xfs_trans_ijoin(tp, dp, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
>  	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
>  
>  	/*
> @@ -2963,12 +2953,6 @@ xfs_rename(
>  	 * whether the target directory is the same as the source
>  	 * directory, we can lock from 2 to 4 inodes.
>  	 */
> -	if (!new_parent)
> -		xfs_ilock(src_dp, XFS_IOLOCK_EXCL | XFS_IOLOCK_PARENT);
> -	else
> -		xfs_lock_two_inodes(src_dp, target_dp,
> -				    XFS_IOLOCK_EXCL | XFS_IOLOCK_PARENT);
> -
>  	xfs_lock_inodes(inodes, num_inodes, XFS_ILOCK_EXCL);
>  
>  	/*
> @@ -2976,9 +2960,9 @@ xfs_rename(
>  	 * we can rely on either trans_commit or trans_cancel to unlock
>  	 * them.
>  	 */
> -	xfs_trans_ijoin(tp, src_dp, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, src_dp, XFS_ILOCK_EXCL);
>  	if (new_parent)
> -		xfs_trans_ijoin(tp, target_dp, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
> +		xfs_trans_ijoin(tp, target_dp, XFS_ILOCK_EXCL);
>  	xfs_trans_ijoin(tp, src_ip, XFS_ILOCK_EXCL);
>  	if (target_ip)
>  		xfs_trans_ijoin(tp, target_ip, XFS_ILOCK_EXCL);
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 71e8a81..10dcf27 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -56,7 +56,6 @@ typedef struct xfs_inode {
>  	/* Transaction and locking information. */
>  	struct xfs_inode_log_item *i_itemp;	/* logging information */
>  	mrlock_t		i_lock;		/* inode lock */
> -	mrlock_t		i_iolock;	/* inode IO lock */
>  	mrlock_t		i_mmaplock;	/* inode mmap IO lock */
>  	atomic_t		i_pincount;	/* inode pin count */
>  	spinlock_t		i_flags_lock;	/* inode i_flags lock */
> @@ -333,7 +332,7 @@ static inline void xfs_ifunlock(struct xfs_inode *ip)
>   * IOLOCK values
>   *
>   * 0-3		subclass value
> - * 4-7		PARENT subclass values
> + * 4-7		unused
>   *
>   * MMAPLOCK values
>   *
> @@ -348,10 +347,8 @@ static inline void xfs_ifunlock(struct xfs_inode *ip)
>   * 
>   */
>  #define XFS_IOLOCK_SHIFT		16
> -#define XFS_IOLOCK_PARENT_VAL		4
> -#define XFS_IOLOCK_MAX_SUBCLASS		(XFS_IOLOCK_PARENT_VAL - 1)
> +#define XFS_IOLOCK_MAX_SUBCLASS		3
>  #define XFS_IOLOCK_DEP_MASK		0x000f0000
> -#define	XFS_IOLOCK_PARENT		(XFS_IOLOCK_PARENT_VAL << XFS_IOLOCK_SHIFT)
>  
>  #define XFS_MMAPLOCK_SHIFT		20
>  #define XFS_MMAPLOCK_NUMORDER		0
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index a391975..fc563b8 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -639,7 +639,7 @@ xfs_ioc_space(
>  		return error;
>  
>  	xfs_ilock(ip, iolock);
> -	error = xfs_break_layouts(inode, &iolock, false);
> +	error = xfs_break_layouts(inode, &iolock);
>  	if (error)
>  		goto out_unlock;
>  
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 405a65c..c962999 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -983,15 +983,13 @@ xfs_vn_setattr(
>  		struct xfs_inode	*ip = XFS_I(d_inode(dentry));
>  		uint			iolock = XFS_IOLOCK_EXCL;
>  
> -		xfs_ilock(ip, iolock);
> -		error = xfs_break_layouts(d_inode(dentry), &iolock, true);
> -		if (!error) {
> -			xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
> -			iolock |= XFS_MMAPLOCK_EXCL;
> +		error = xfs_break_layouts(d_inode(dentry), &iolock);
> +		if (error)
> +			return error;
>  
> -			error = xfs_vn_setattr_size(dentry, iattr);
> -		}
> -		xfs_iunlock(ip, iolock);
> +		xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
> +		error = xfs_setattr_size(ip, iattr);
> +		xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
>  	} else {
>  		error = xfs_vn_setattr_nonsize(dentry, iattr);
>  	}
> diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
> index 93a7aaf..2f2dc3c 100644
> --- a/fs/xfs/xfs_pnfs.c
> +++ b/fs/xfs/xfs_pnfs.c
> @@ -32,8 +32,7 @@
>  int
>  xfs_break_layouts(
>  	struct inode		*inode,
> -	uint			*iolock,
> -	bool			with_imutex)
> +	uint			*iolock)
>  {
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	int			error;
> @@ -42,12 +41,8 @@ xfs_break_layouts(
>  
>  	while ((error = break_layout(inode, false) == -EWOULDBLOCK)) {
>  		xfs_iunlock(ip, *iolock);
> -		if (with_imutex && (*iolock & XFS_IOLOCK_EXCL))
> -			inode_unlock(inode);
>  		error = break_layout(inode, true);
>  		*iolock = XFS_IOLOCK_EXCL;
> -		if (with_imutex)
> -			inode_lock(inode);
>  		xfs_ilock(ip, *iolock);
>  	}
>  
> diff --git a/fs/xfs/xfs_pnfs.h b/fs/xfs/xfs_pnfs.h
> index e8339f7..b587cb9 100644
> --- a/fs/xfs/xfs_pnfs.h
> +++ b/fs/xfs/xfs_pnfs.h
> @@ -8,10 +8,10 @@ int xfs_fs_map_blocks(struct inode *inode, loff_t offset, u64 length,
>  int xfs_fs_commit_blocks(struct inode *inode, struct iomap *maps, int nr_maps,
>  		struct iattr *iattr);
>  
> -int xfs_break_layouts(struct inode *inode, uint *iolock, bool with_imutex);
> +int xfs_break_layouts(struct inode *inode, uint *iolock);
>  #else
>  static inline int
> -xfs_break_layouts(struct inode *inode, uint *iolock, bool with_imutex)
> +xfs_break_layouts(struct inode *inode, uint *iolock)
>  {
>  	return 0;
>  }
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 0edf835..3554a1c 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1302,13 +1302,11 @@ xfs_reflink_remap_range(
>  		return -EIO;
>  
>  	/* Lock both files against IO */
> -	if (same_inode) {
> -		xfs_ilock(src, XFS_IOLOCK_EXCL);
> +	lock_two_nondirectories(inode_in, inode_out);
> +	if (same_inode)
>  		xfs_ilock(src, XFS_MMAPLOCK_EXCL);
> -	} else {
> -		xfs_lock_two_inodes(src, dest, XFS_IOLOCK_EXCL);
> +	else
>  		xfs_lock_two_inodes(src, dest, XFS_MMAPLOCK_EXCL);
> -	}
>  
>  	/* Don't touch certain kinds of inodes */
>  	ret = -EPERM;
> @@ -1447,11 +1445,9 @@ xfs_reflink_remap_range(
>  
>  out_unlock:
>  	xfs_iunlock(src, XFS_MMAPLOCK_EXCL);
> -	xfs_iunlock(src, XFS_IOLOCK_EXCL);
> -	if (src->i_ino != dest->i_ino) {
> +	if (!same_inode)
>  		xfs_iunlock(dest, XFS_MMAPLOCK_EXCL);
> -		xfs_iunlock(dest, XFS_IOLOCK_EXCL);
> -	}
> +	unlock_two_nondirectories(inode_in, inode_out);
>  	if (ret)
>  		trace_xfs_reflink_remap_range_error(dest, ret, _RET_IP_);
>  	return ret;
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index ade4691..563d1d1 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -943,7 +943,7 @@ xfs_fs_destroy_inode(
>  
>  	trace_xfs_destroy_inode(ip);
>  
> -	ASSERT(!rwsem_is_locked(&ip->i_iolock.mr_lock));
> +	ASSERT(!rwsem_is_locked(&inode->i_rwsem));
>  	XFS_STATS_INC(ip->i_mount, vn_rele);
>  	XFS_STATS_INC(ip->i_mount, vn_remove);
>  
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index 58142ae..f2cb45e 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -238,8 +238,7 @@ xfs_symlink(
>  	if (error)
>  		goto out_release_inode;
>  
> -	xfs_ilock(dp, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL |
> -		      XFS_IOLOCK_PARENT | XFS_ILOCK_PARENT);
> +	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
>  	unlock_dp_on_error = true;
>  
>  	/*
> @@ -287,7 +286,7 @@ xfs_symlink(
>  	 * the transaction cancel unlocking dp so don't do it explicitly in the
>  	 * error path.
>  	 */
> -	xfs_trans_ijoin(tp, dp, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
>  	unlock_dp_on_error = false;
>  
>  	/*
> @@ -412,7 +411,7 @@ xfs_symlink(
>  	xfs_qm_dqrele(pdqp);
>  
>  	if (unlock_dp_on_error)
> -		xfs_iunlock(dp, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
> +		xfs_iunlock(dp, XFS_ILOCK_EXCL);
>  	return error;
>  }
>  
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
