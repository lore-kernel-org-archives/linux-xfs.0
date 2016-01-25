Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9DF707CA9
	for <xfs@oss.sgi.com>; Mon, 25 Jan 2016 12:25:28 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 31019AC004
	for <xfs@oss.sgi.com>; Mon, 25 Jan 2016 10:25:28 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id D5zTCpcJjoapOTGF (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 25 Jan 2016 10:25:23 -0800 (PST)
Date: Mon, 25 Jan 2016 13:25:21 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 8/8] xfs: mode di_mode to vfs inode
Message-ID: <20160125182521.GD27301@bfoster.bfoster>
References: <1452751765-4420-1-git-send-email-david@fromorbit.com>
	<1452751765-4420-9-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1452751765-4420-9-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Jan 14, 2016 at 05:09:25PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Move the di_mode value from the xfs_icdinode to the VFS inode, reducing
> the xfs_icdinode byte another 2 bytes and collapsing another 2 byte hole
> in the structure.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/fs-writeback.c              |  1 +
>  fs/xfs/libxfs/xfs_bmap.c       |  6 +++---
>  fs/xfs/libxfs/xfs_dir2.c       | 12 +++++------
>  fs/xfs/libxfs/xfs_inode_buf.c  |  8 +++----
>  fs/xfs/libxfs/xfs_inode_buf.h  |  1 -
>  fs/xfs/libxfs/xfs_inode_fork.c |  2 +-
>  fs/xfs/xfs_bmap_util.c         |  4 ++--
>  fs/xfs/xfs_dir2_readdir.c      |  2 +-
>  fs/xfs/xfs_file.c              |  6 +++---
>  fs/xfs/xfs_filestream.c        |  4 ++--
>  fs/xfs/xfs_icache.c            | 42 +++++++++++++++++++++++++++++++-----
>  fs/xfs/xfs_inode.c             | 48 ++++++++++++++++++++----------------------
>  fs/xfs/xfs_inode.h             |  4 ++--
>  fs/xfs/xfs_inode_item.c        |  2 +-
>  fs/xfs/xfs_ioctl.c             | 14 ++++++------
>  fs/xfs/xfs_iops.c              | 12 ++++-------
>  fs/xfs/xfs_itable.c            |  2 +-
>  fs/xfs/xfs_log_recover.c       |  2 +-
>  fs/xfs/xfs_mount.c             |  2 +-
>  19 files changed, 100 insertions(+), 74 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 023f6a1..0858457 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -2106,6 +2106,7 @@ EXPORT_SYMBOL(__mark_inode_dirty);
>   * completed by the time we have gained the lock and waited for all IO that is
>   * in progress regardless of the order callers are granted the lock.
>   */
> +#include "linux/delay.h"
>  static void wait_sb_inodes(struct super_block *sb)
>  {
>  	struct inode *inode, *old_inode = NULL;

What's this hunk about?

...
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 7c26f86..c1edb0f 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
...
> @@ -135,6 +138,35 @@ xfs_inode_free(
>  }
>  
>  /*
> + * When we recycle a reclaimable inode, we need to re-initialise the VFS inode
> + * part of the structure. This is made more complex by the fact we store
> + * information about the on-disk values in the VFS inode and so we can't just
> + * overwrite it's values unconditionally. Hence we save the parameters we

Nit:		its

> + * need to retain across reinitialisation, and rewrite them into the VFS inode
> + * after resetting it's state even if resetting fails.

... and above as well.

That aside, it looks like xfs_reinit_inode() addresses my previous
questions around reclaimable inodes. Could we introduce this function
properly when it is first needed (the nlink patch) and update it
appropriately?

Brian

> + */
> +static int
> +xfs_reinit_inode(
> +	struct xfs_mount	*mp,
> +	struct inode		*inode)
> +{
> +	uint32_t	nlink = inode->i_nlink;
> +	umode_t		mode = inode->i_mode;
> +	uint32_t	generation = inode->i_generation;
> +	uint64_t	version = inode->i_version;
> +	int		error;
> +
> +	error = inode_init_always(mp->m_super, inode);
> +
> +	set_nlink(inode, nlink);
> +	inode->i_mode = mode;
> +	inode->i_generation = generation;
> +	inode->i_version = version;
> +
> +	return error;
> +}
> +
> +/*
>   * Check the validity of the inode we just found it the cache
>   */
>  static int
> @@ -185,7 +217,7 @@ xfs_iget_cache_hit(
>  	/*
>  	 * If lookup is racing with unlink return an error immediately.
>  	 */
> -	if (ip->i_d.di_mode == 0 && !(flags & XFS_IGET_CREATE)) {
> +	if (VFS_I(ip)->i_mode == 0 && !(flags & XFS_IGET_CREATE)) {
>  		error = -ENOENT;
>  		goto out_error;
>  	}
> @@ -208,7 +240,7 @@ xfs_iget_cache_hit(
>  		spin_unlock(&ip->i_flags_lock);
>  		rcu_read_unlock();
>  
> -		error = inode_init_always(mp->m_super, inode);
> +		error = xfs_reinit_inode(mp, inode);
>  		if (error) {
>  			/*
>  			 * Re-initializing the inode failed, and we are in deep
> @@ -295,7 +327,7 @@ xfs_iget_cache_miss(
>  
>  	trace_xfs_iget_miss(ip);
>  
> -	if ((ip->i_d.di_mode == 0) && !(flags & XFS_IGET_CREATE)) {
> +	if ((VFS_I(ip)->i_mode == 0) && !(flags & XFS_IGET_CREATE)) {
>  		error = -ENOENT;
>  		goto out_destroy;
>  	}
> @@ -444,7 +476,7 @@ again:
>  	 * If we have a real type for an on-disk inode, we can setup the inode
>  	 * now.	 If it's a new inode being created, xfs_ialloc will handle it.
>  	 */
> -	if (xfs_iflags_test(ip, XFS_INEW) && ip->i_d.di_mode != 0)
> +	if (xfs_iflags_test(ip, XFS_INEW) && VFS_I(ip)->i_mode != 0)
>  		xfs_setup_existing_inode(ip);
>  	return 0;
>  
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 96aee23..a0e7cdf 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -793,7 +793,7 @@ xfs_ialloc(
>  	if (ip->i_d.di_version == 1)
>  		ip->i_d.di_version = 2;
>  
> -	ip->i_d.di_mode = mode;
> +	inode->i_mode = mode;
>  	set_nlink(inode, nlink);
>  	ip->i_d.di_uid = xfs_kuid_to_uid(current_fsuid());
>  	ip->i_d.di_gid = xfs_kgid_to_gid(current_fsgid());
> @@ -801,9 +801,8 @@ xfs_ialloc(
>  
>  	if (pip && XFS_INHERIT_GID(pip)) {
>  		ip->i_d.di_gid = pip->i_d.di_gid;
> -		if ((pip->i_d.di_mode & S_ISGID) && S_ISDIR(mode)) {
> -			ip->i_d.di_mode |= S_ISGID;
> -		}
> +		if ((VFS_I(pip)->i_mode & S_ISGID) && S_ISDIR(mode))
> +			inode->i_mode |= S_ISGID;
>  	}
>  
>  	/*
> @@ -812,10 +811,9 @@ xfs_ialloc(
>  	 * (and only if the irix_sgid_inherit compatibility variable is set).
>  	 */
>  	if ((irix_sgid_inherit) &&
> -	    (ip->i_d.di_mode & S_ISGID) &&
> -	    (!in_group_p(xfs_gid_to_kgid(ip->i_d.di_gid)))) {
> -		ip->i_d.di_mode &= ~S_ISGID;
> -	}
> +	    (inode->i_mode & S_ISGID) &&
> +	    (!in_group_p(xfs_gid_to_kgid(ip->i_d.di_gid))))
> +		inode->i_mode &= ~S_ISGID;
>  
>  	ip->i_d.di_size = 0;
>  	ip->i_d.di_nextents = 0;
> @@ -1407,7 +1405,7 @@ xfs_link(
>  
>  	trace_xfs_link(tdp, target_name);
>  
> -	ASSERT(!S_ISDIR(sip->i_d.di_mode));
> +	ASSERT(!S_ISDIR(VFS_I(sip)->i_mode));
>  
>  	if (XFS_FORCED_SHUTDOWN(mp))
>  		return -EIO;
> @@ -1614,7 +1612,7 @@ xfs_release(
>  	xfs_mount_t	*mp = ip->i_mount;
>  	int		error;
>  
> -	if (!S_ISREG(ip->i_d.di_mode) || (ip->i_d.di_mode == 0))
> +	if (!S_ISREG(VFS_I(ip)->i_mode) || (VFS_I(ip)->i_mode == 0))
>  		return 0;
>  
>  	/* If this is a read-only mount, don't do this (would generate I/O) */
> @@ -1849,7 +1847,7 @@ xfs_inactive(
>  	 * If the inode is already free, then there can be nothing
>  	 * to clean up here.
>  	 */
> -	if (ip->i_d.di_mode == 0) {
> +	if (VFS_I(ip)->i_mode == 0) {
>  		ASSERT(ip->i_df.if_real_bytes == 0);
>  		ASSERT(ip->i_df.if_broot_bytes == 0);
>  		return;
> @@ -1873,7 +1871,7 @@ xfs_inactive(
>  		return;
>  	}
>  
> -	if (S_ISREG(ip->i_d.di_mode) &&
> +	if (S_ISREG(VFS_I(ip)->i_mode) &&
>  	    (ip->i_d.di_size != 0 || XFS_ISIZE(ip) != 0 ||
>  	     ip->i_d.di_nextents > 0 || ip->i_delayed_blks > 0))
>  		truncate = 1;
> @@ -1882,7 +1880,7 @@ xfs_inactive(
>  	if (error)
>  		return;
>  
> -	if (S_ISLNK(ip->i_d.di_mode))
> +	if (S_ISLNK(VFS_I(ip)->i_mode))
>  		error = xfs_inactive_symlink(ip);
>  	else if (truncate)
>  		error = xfs_inactive_truncate(ip);
> @@ -1944,7 +1942,7 @@ xfs_iunlink(
>  	int		error;
>  
>  	ASSERT(VFS_I(ip)->i_nlink == 0 || ignore_linkcount);
> -	ASSERT(ip->i_d.di_mode != 0);
> +	ASSERT(VFS_I(ip)->i_mode != 0);
>  
>  	mp = tp->t_mountp;
>  
> @@ -2387,7 +2385,7 @@ xfs_ifree(
>  	ASSERT(VFS_I(ip)->i_nlink == 0);
>  	ASSERT(ip->i_d.di_nextents == 0);
>  	ASSERT(ip->i_d.di_anextents == 0);
> -	ASSERT(ip->i_d.di_size == 0 || !S_ISREG(ip->i_d.di_mode));
> +	ASSERT(ip->i_d.di_size == 0 || !S_ISREG(VFS_I(ip)->i_mode));
>  	ASSERT(ip->i_d.di_nblocks == 0);
>  
>  	/*
> @@ -2401,7 +2399,7 @@ xfs_ifree(
>  	if (error)
>  		return error;
>  
> -	ip->i_d.di_mode = 0;		/* mark incore inode as free */
> +	VFS_I(ip)->i_mode = 0;		/* mark incore inode as free */
>  	ip->i_d.di_flags = 0;
>  	ip->i_d.di_dmevmask = 0;
>  	ip->i_d.di_forkoff = 0;		/* mark the attr fork not in use */
> @@ -2498,7 +2496,7 @@ xfs_remove(
>  {
>  	xfs_mount_t		*mp = dp->i_mount;
>  	xfs_trans_t             *tp = NULL;
> -	int			is_dir = S_ISDIR(ip->i_d.di_mode);
> +	int			is_dir = S_ISDIR(VFS_I(ip)->i_mode);
>  	int                     error = 0;
>  	xfs_bmap_free_t         free_list;
>  	xfs_fsblock_t           first_block;
> @@ -2743,7 +2741,7 @@ xfs_cross_rename(
>  	if (dp1 != dp2) {
>  		dp2_flags = XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG;
>  
> -		if (S_ISDIR(ip2->i_d.di_mode)) {
> +		if (S_ISDIR(VFS_I(ip2)->i_mode)) {
>  			error = xfs_dir_replace(tp, ip2, &xfs_name_dotdot,
>  						dp1->i_ino, first_block,
>  						free_list, spaceres);
> @@ -2751,7 +2749,7 @@ xfs_cross_rename(
>  				goto out_trans_abort;
>  
>  			/* transfer ip2 ".." reference to dp1 */
> -			if (!S_ISDIR(ip1->i_d.di_mode)) {
> +			if (!S_ISDIR(VFS_I(ip1)->i_mode)) {
>  				error = xfs_droplink(tp, dp2);
>  				if (error)
>  					goto out_trans_abort;
> @@ -2770,7 +2768,7 @@ xfs_cross_rename(
>  			ip2_flags |= XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG;
>  		}
>  
> -		if (S_ISDIR(ip1->i_d.di_mode)) {
> +		if (S_ISDIR(VFS_I(ip1)->i_mode)) {
>  			error = xfs_dir_replace(tp, ip1, &xfs_name_dotdot,
>  						dp2->i_ino, first_block,
>  						free_list, spaceres);
> @@ -2778,7 +2776,7 @@ xfs_cross_rename(
>  				goto out_trans_abort;
>  
>  			/* transfer ip1 ".." reference to dp2 */
> -			if (!S_ISDIR(ip2->i_d.di_mode)) {
> +			if (!S_ISDIR(VFS_I(ip2)->i_mode)) {
>  				error = xfs_droplink(tp, dp1);
>  				if (error)
>  					goto out_trans_abort;
> @@ -2875,7 +2873,7 @@ xfs_rename(
>  	struct xfs_inode	*inodes[__XFS_SORT_INODES];
>  	int			num_inodes = __XFS_SORT_INODES;
>  	bool			new_parent = (src_dp != target_dp);
> -	bool			src_is_directory = S_ISDIR(src_ip->i_d.di_mode);
> +	bool			src_is_directory = S_ISDIR(VFS_I(src_ip)->i_mode);
>  	int			spaceres;
>  	int			error;
>  
> @@ -3004,7 +3002,7 @@ xfs_rename(
>  		 * target and source are directories and that target can be
>  		 * destroyed, or that neither is a directory.
>  		 */
> -		if (S_ISDIR(target_ip->i_d.di_mode)) {
> +		if (S_ISDIR(VFS_I(target_ip)->i_mode)) {
>  			/*
>  			 * Make sure target dir is empty.
>  			 */
> @@ -3434,7 +3432,7 @@ xfs_iflush_int(
>  			__func__, ip->i_ino, be16_to_cpu(dip->di_magic), dip);
>  		goto corrupt_out;
>  	}
> -	if (S_ISREG(ip->i_d.di_mode)) {
> +	if (S_ISREG(VFS_I(ip)->i_mode)) {
>  		if (XFS_TEST_ERROR(
>  		    (ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS) &&
>  		    (ip->i_d.di_format != XFS_DINODE_FMT_BTREE),
> @@ -3444,7 +3442,7 @@ xfs_iflush_int(
>  				__func__, ip->i_ino, ip);
>  			goto corrupt_out;
>  		}
> -	} else if (S_ISDIR(ip->i_d.di_mode)) {
> +	} else if (S_ISDIR(VFS_I(ip)->i_mode)) {
>  		if (XFS_TEST_ERROR(
>  		    (ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS) &&
>  		    (ip->i_d.di_format != XFS_DINODE_FMT_BTREE) &&
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index e74d13d..d627749 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -88,7 +88,7 @@ static inline struct inode *VFS_I(struct xfs_inode *ip)
>   */
>  static inline xfs_fsize_t XFS_ISIZE(struct xfs_inode *ip)
>  {
> -	if (S_ISREG(ip->i_d.di_mode))
> +	if (S_ISREG(VFS_I(ip)->i_mode))
>  		return i_size_read(VFS_I(ip));
>  	return ip->i_d.di_size;
>  }
> @@ -369,7 +369,7 @@ static inline int xfs_isiflocked(struct xfs_inode *ip)
>   */
>  #define XFS_INHERIT_GID(pip)	\
>  	(((pip)->i_mount->m_flags & XFS_MOUNT_GRPID) || \
> -	 ((pip)->i_d.di_mode & S_ISGID))
> +	 (VFS_I(pip)->i_mode & S_ISGID))
>  
>  int		xfs_release(struct xfs_inode *ip);
>  void		xfs_inactive(struct xfs_inode *ip);
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 334d657..bd9808f 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -333,7 +333,6 @@ xfs_inode_to_log_dinode(
>  
>  	to->di_magic = XFS_DINODE_MAGIC;
>  
> -	to->di_mode = from->di_mode;
>  	to->di_version = from->di_version;
>  	to->di_format = from->di_format;
>  	to->di_uid = from->di_uid;
> @@ -351,6 +350,7 @@ xfs_inode_to_log_dinode(
>  	to->di_ctime.t_nsec = inode->i_ctime.tv_nsec;
>  	to->di_nlink = inode->i_nlink;
>  	to->di_gen = inode->i_generation;
> +	to->di_mode = inode->i_mode;
>  
>  	to->di_size = from->di_size;
>  	to->di_nblocks = from->di_nblocks;
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 2c40c5f..5069bd8 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -962,7 +962,7 @@ xfs_set_diflags(
>  		di_flags |= XFS_DIFLAG_NODEFRAG;
>  	if (xflags & XFS_XFLAG_FILESTREAM)
>  		di_flags |= XFS_DIFLAG_FILESTREAM;
> -	if (S_ISDIR(ip->i_d.di_mode)) {
> +	if (S_ISDIR(VFS_I(ip)->i_mode)) {
>  		if (xflags & XFS_XFLAG_RTINHERIT)
>  			di_flags |= XFS_DIFLAG_RTINHERIT;
>  		if (xflags & XFS_XFLAG_NOSYMLINKS)
> @@ -971,7 +971,7 @@ xfs_set_diflags(
>  			di_flags |= XFS_DIFLAG_EXTSZINHERIT;
>  		if (xflags & XFS_XFLAG_PROJINHERIT)
>  			di_flags |= XFS_DIFLAG_PROJINHERIT;
> -	} else if (S_ISREG(ip->i_d.di_mode)) {
> +	} else if (S_ISREG(VFS_I(ip)->i_mode)) {
>  		if (xflags & XFS_XFLAG_REALTIME)
>  			di_flags |= XFS_DIFLAG_REALTIME;
>  		if (xflags & XFS_XFLAG_EXTSIZE)
> @@ -1112,14 +1112,14 @@ xfs_ioctl_setattr_check_extsize(
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  
> -	if ((fa->fsx_xflags & XFS_XFLAG_EXTSIZE) && !S_ISREG(ip->i_d.di_mode))
> +	if ((fa->fsx_xflags & XFS_XFLAG_EXTSIZE) && !S_ISREG(VFS_I(ip)->i_mode))
>  		return -EINVAL;
>  
>  	if ((fa->fsx_xflags & XFS_XFLAG_EXTSZINHERIT) &&
> -	    !S_ISDIR(ip->i_d.di_mode))
> +	    !S_ISDIR(VFS_I(ip)->i_mode))
>  		return -EINVAL;
>  
> -	if (S_ISREG(ip->i_d.di_mode) && ip->i_d.di_nextents &&
> +	if (S_ISREG(VFS_I(ip)->i_mode) && ip->i_d.di_nextents &&
>  	    ((ip->i_d.di_extsize << mp->m_sb.sb_blocklog) != fa->fsx_extsize))
>  		return -EINVAL;
>  
> @@ -1240,9 +1240,9 @@ xfs_ioctl_setattr(
>  	 * successful return from chown()
>  	 */
>  
> -	if ((ip->i_d.di_mode & (S_ISUID|S_ISGID)) &&
> +	if ((VFS_I(ip)->i_mode & (S_ISUID|S_ISGID)) &&
>  	    !capable_wrt_inode_uidgid(VFS_I(ip), CAP_FSETID))
> -		ip->i_d.di_mode &= ~(S_ISUID|S_ISGID);
> +		VFS_I(ip)->i_mode &= ~(S_ISUID|S_ISGID);
>  
>  	/* Change the ownerships and register project quota modifications */
>  	if (xfs_get_projid(ip) != fa->fsx_projid) {
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 397ce85..34bff1e 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -454,7 +454,7 @@ xfs_vn_getattr(
>  
>  	stat->size = XFS_ISIZE(ip);
>  	stat->dev = inode->i_sb->s_dev;
> -	stat->mode = ip->i_d.di_mode;
> +	stat->mode = inode->i_mode;
>  	stat->nlink = inode->i_nlink;
>  	stat->uid = inode->i_uid;
>  	stat->gid = inode->i_gid;
> @@ -501,9 +501,6 @@ xfs_setattr_mode(
>  
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
>  
> -	ip->i_d.di_mode &= S_IFMT;
> -	ip->i_d.di_mode |= mode & ~S_IFMT;
> -
>  	inode->i_mode &= S_IFMT;
>  	inode->i_mode |= mode & ~S_IFMT;
>  }
> @@ -647,9 +644,9 @@ xfs_setattr_nonsize(
>  		 * The set-user-ID and set-group-ID bits of a file will be
>  		 * cleared upon successful return from chown()
>  		 */
> -		if ((ip->i_d.di_mode & (S_ISUID|S_ISGID)) &&
> +		if ((inode->i_mode & (S_ISUID|S_ISGID)) &&
>  		    !capable(CAP_FSETID))
> -			ip->i_d.di_mode &= ~(S_ISUID|S_ISGID);
> +			inode->i_mode &= ~(S_ISUID|S_ISGID);
>  
>  		/*
>  		 * Change the ownerships and register quota modifications
> @@ -759,7 +756,7 @@ xfs_setattr_size(
>  
>  	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
>  	ASSERT(xfs_isilocked(ip, XFS_MMAPLOCK_EXCL));
> -	ASSERT(S_ISREG(ip->i_d.di_mode));
> +	ASSERT(S_ISREG(inode->i_mode));
>  	ASSERT((iattr->ia_valid & (ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET|
>  		ATTR_MTIME_SET|ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0);
>  
> @@ -1211,7 +1208,6 @@ xfs_setup_inode(
>  	/* make the inode look hashed for the writeback code */
>  	hlist_add_fake(&inode->i_hash);
>  
> -	inode->i_mode	= ip->i_d.di_mode;
>  	inode->i_uid    = xfs_uid_to_kuid(ip->i_d.di_uid);
>  	inode->i_gid    = xfs_gid_to_kgid(ip->i_d.di_gid);
>  
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index 6162e65..ce73eb3 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -88,7 +88,6 @@ xfs_bulkstat_one_int(
>  	buf->bs_projid_lo = dic->di_projid_lo;
>  	buf->bs_projid_hi = dic->di_projid_hi;
>  	buf->bs_ino = ino;
> -	buf->bs_mode = dic->di_mode;
>  	buf->bs_uid = dic->di_uid;
>  	buf->bs_gid = dic->di_gid;
>  	buf->bs_size = dic->di_size;
> @@ -101,6 +100,7 @@ xfs_bulkstat_one_int(
>  	buf->bs_ctime.tv_sec = inode->i_ctime.tv_sec;
>  	buf->bs_ctime.tv_nsec = inode->i_ctime.tv_nsec;
>  	buf->bs_gen = inode->i_generation;
> +	buf->bs_mode = inode->i_mode;
>  
>  	buf->bs_xflags = xfs_ip2xflags(ip);
>  	buf->bs_extsize = dic->di_extsize << mp->m_sb.sb_blocklog;
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 611c25c..bd6f23b 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -4338,7 +4338,7 @@ xlog_recover_process_one_iunlink(
>  		goto fail_iput;
>  
>  	ASSERT(VFS_I(ip)->i_nlink == 0);
> -	ASSERT(ip->i_d.di_mode != 0);
> +	ASSERT(VFS_I(ip)->i_mode != 0);
>  
>  	/* setup for the next pass */
>  	agino = be32_to_cpu(dip->di_next_unlinked);
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index bb753b3..d306105 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -865,7 +865,7 @@ xfs_mountfs(
>  
>  	ASSERT(rip != NULL);
>  
> -	if (unlikely(!S_ISDIR(rip->i_d.di_mode))) {
> +	if (unlikely(!S_ISDIR(VFS_I(rip)->i_mode))) {
>  		xfs_warn(mp, "corrupted root inode %llu: not a directory",
>  			(unsigned long long)rip->i_ino);
>  		xfs_iunlock(rip, XFS_ILOCK_EXCL);
> -- 
> 2.5.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
