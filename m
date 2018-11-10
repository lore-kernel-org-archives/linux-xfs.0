Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:41578 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726292AbeKKDdv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 10 Nov 2018 22:33:51 -0500
Date: Sat, 10 Nov 2018 09:47:52 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/3] xfs: introduce an always_cow mode
Message-ID: <20181110174752.GA4235@magnolia>
References: <20181110115104.30293-1-hch@lst.de>
 <20181110115104.30293-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181110115104.30293-4-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Sat, Nov 10, 2018 at 12:51:04PM +0100, Christoph Hellwig wrote:
> Add a mode where XFS never overwrites existing blocks in place.  This
> is to aid debugging our COW code, and also put infatructure in place
> for things like possible future support for zoned block devices, which
> can't support overwrites.
> 
> This mode is enabled globally by doing a:
> 
>     echo 1 > /sys/fs/xfs/debug/always_cow
> 
> Note that the parameter is global to allow running all tests in xfstests
> easily in this mode, which would not easily be possible with a per-fs
> sysfs file.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_aops.c    |  2 +-
>  fs/xfs/xfs_file.c    |  7 ++++++-
>  fs/xfs/xfs_iomap.c   | 16 ++++++++++------
>  fs/xfs/xfs_reflink.c | 28 ++++++++++++++++++++++++----
>  fs/xfs/xfs_reflink.h | 13 +++++++++++++
>  fs/xfs/xfs_super.c   | 13 +++++++++----
>  fs/xfs/xfs_sysctl.h  |  1 +
>  fs/xfs/xfs_sysfs.c   | 24 ++++++++++++++++++++++++
>  8 files changed, 88 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 338b9d9984e0..9119805d5ac7 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -981,7 +981,7 @@ xfs_vm_bmap(
>  	 * Since we don't pass back blockdev info, we can't return bmap
>  	 * information for rt files either.
>  	 */
> -	if (xfs_is_reflink_inode(ip) || XFS_IS_REALTIME_INODE(ip))
> +	if (xfs_is_cow_inode(ip) || XFS_IS_REALTIME_INODE(ip))
>  		return 0;
>  	return iomap_bmap(mapping, block, &xfs_iomap_ops);
>  }
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 53c9ab8fb777..6873041f5222 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -507,7 +507,7 @@ xfs_file_dio_aio_write(
>  		 * We can't properly handle unaligned direct I/O to reflink
>  		 * files yet, as we can't unshare a partial block.
>  		 */
> -		if (xfs_is_reflink_inode(ip)) {
> +		if (xfs_is_cow_inode(ip)) {
>  			trace_xfs_reflink_bounce_dio_write(ip, iocb->ki_pos, count);
>  			return -EREMCHG;
>  		}
> @@ -806,6 +806,11 @@ xfs_file_fallocate(
>  		return -EOPNOTSUPP;
>  
>  	xfs_ilock(ip, iolock);
> +	if (xfs_is_always_cow_inode(ip) && mode != FALLOC_FL_PUNCH_HOLE) {
> +		error = -EOPNOTSUPP;
> +		goto out_unlock;

It's the weekend, so I'm only doing a quick scan of patches:

Why can't we support collapse range, insert range, zero range, or
unshare in always_cow mode?

--D

> +	}
> +
>  	error = xfs_break_layouts(inode, &iolock, BREAK_UNMAP);
>  	if (error)
>  		goto out_unlock;
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 3e7f0ca78669..df9751eaf5fa 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -581,7 +581,11 @@ xfs_file_iomap_begin_delay(
>  	 * themselves.  Second the lookup in the extent list is generally faster
>  	 * than going out to the shared extent tree.
>  	 */
> -	if (xfs_is_reflink_inode(ip)) {
> +	if (xfs_is_cow_inode(ip)) {
> +		if (!ip->i_cowfp) {
> +			ASSERT(!xfs_is_reflink_inode(ip));
> +			xfs_ifork_init_cow(ip);
> +		}
>  		cow_eof = !xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb,
>  				&ccur, &cmap);
>  		if (!cow_eof && cmap.br_startoff <= offset_fsb) {
> @@ -604,7 +608,7 @@ xfs_file_iomap_begin_delay(
>  		 * overwriting shared extents.   This includes zeroing of
>  		 * existing extents that contain data.
>  		 */
> -		if (!xfs_is_reflink_inode(ip) ||
> +		if (!xfs_is_cow_inode(ip) ||
>  		    ((flags & IOMAP_ZERO) && imap.br_state != XFS_EXT_NORM)) {
>  			trace_xfs_iomap_found(ip, offset, count, 0, &imap);
>  			goto done;
> @@ -613,7 +617,7 @@ xfs_file_iomap_begin_delay(
>  		xfs_trim_extent(&imap, offset_fsb, end_fsb - offset_fsb);
>  
>  		/* Trim the mapping to the nearest shared extent boundary. */
> -		error = xfs_reflink_trim_around_shared(ip, &imap, &shared);
> +		error = xfs_inode_need_cow(ip, &imap, &shared);
>  		if (error)
>  			goto out_unlock;
>  
> @@ -1024,7 +1028,7 @@ xfs_ilock_for_iomap(
>  	 * COW writes may allocate delalloc space or convert unwritten COW
>  	 * extents, so we need to make sure to take the lock exclusively here.
>  	 */
> -	if (xfs_is_reflink_inode(ip) && is_write) {
> +	if (xfs_is_cow_inode(ip) && is_write) {
>  		/*
>  		 * FIXME: It could still overwrite on unshared extents and not
>  		 * need allocation.
> @@ -1058,7 +1062,7 @@ xfs_ilock_for_iomap(
>  	 * check, so if we got ILOCK_SHARED for a write and but we're now a
>  	 * reflink inode we have to switch to ILOCK_EXCL and relock.
>  	 */
> -	if (mode == XFS_ILOCK_SHARED && is_write && xfs_is_reflink_inode(ip)) {
> +	if (mode == XFS_ILOCK_SHARED && is_write && xfs_is_cow_inode(ip)) {
>  		xfs_iunlock(ip, mode);
>  		mode = XFS_ILOCK_EXCL;
>  		goto relock;
> @@ -1130,7 +1134,7 @@ xfs_file_iomap_begin(
>  	 * Break shared extents if necessary. Checks for non-blocking IO have
>  	 * been done up front, so we don't need to do them here.
>  	 */
> -	if (xfs_is_reflink_inode(ip)) {
> +	if (xfs_is_cow_inode(ip)) {
>  		struct xfs_bmbt_irec	orig = imap;
>  
>  		/* if zeroing doesn't need COW allocation, then we are done. */
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 6a002f024349..4d2854cef8fc 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -192,7 +192,7 @@ xfs_reflink_trim_around_shared(
>  	int			error = 0;
>  
>  	/* Holes, unwritten, and delalloc extents cannot be shared */
> -	if (!xfs_is_reflink_inode(ip) || !xfs_bmap_is_real_extent(irec)) {
> +	if (!xfs_is_cow_inode(ip) || !xfs_bmap_is_real_extent(irec)) {
>  		*shared = false;
>  		return 0;
>  	}
> @@ -234,6 +234,23 @@ xfs_reflink_trim_around_shared(
>  	}
>  }
>  
> +bool
> +xfs_inode_need_cow(
> +	struct xfs_inode	*ip,
> +	struct xfs_bmbt_irec	*imap,
> +	bool			*shared)
> +{
> +	/* We can't update any real extents in always COW mode. */
> +	if (xfs_is_always_cow_inode(ip) &&
> +	    !isnullstartblock(imap->br_startblock)) {
> +		*shared = true;
> +		return 0;
> +	}
> +
> +	/* Trim the mapping to the nearest shared extent boundary. */
> +	return xfs_reflink_trim_around_shared(ip, imap, shared);
> +}
> +
>  /* Convert part of an unwritten CoW extent to a real one. */
>  STATIC int
>  xfs_reflink_convert_cow_extent(
> @@ -308,7 +325,7 @@ xfs_find_trim_cow_extent(
>  	if (got.br_startoff > offset_fsb) {
>  		xfs_trim_extent(imap, imap->br_startoff,
>  				got.br_startoff - imap->br_startoff);
> -		return xfs_reflink_trim_around_shared(ip, imap, shared);
> +		return xfs_inode_need_cow(ip, imap, shared);
>  	}
>  
>  	*shared = true;
> @@ -343,7 +360,10 @@ xfs_reflink_allocate_cow(
>  	xfs_extlen_t		resblks = 0;
>  
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> -	ASSERT(xfs_is_reflink_inode(ip));
> +	if (!ip->i_cowfp) {
> +		ASSERT(!xfs_is_reflink_inode(ip));
> +		xfs_ifork_init_cow(ip);
> +	}
>  
>  	error = xfs_find_trim_cow_extent(ip, imap, shared, &found);
>  	if (error || !*shared)
> @@ -522,7 +542,7 @@ xfs_reflink_cancel_cow_range(
>  	int			error;
>  
>  	trace_xfs_reflink_cancel_cow_range(ip, offset, count);
> -	ASSERT(xfs_is_reflink_inode(ip));
> +	ASSERT(ip->i_cowfp);
>  
>  	offset_fsb = XFS_B_TO_FSBT(ip->i_mount, offset);
>  	if (count == NULLFILEOFF)
> diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
> index d76fc520cac8..f6505ae37626 100644
> --- a/fs/xfs/xfs_reflink.h
> +++ b/fs/xfs/xfs_reflink.h
> @@ -6,11 +6,24 @@
>  #ifndef __XFS_REFLINK_H
>  #define __XFS_REFLINK_H 1
>  
> +static inline bool xfs_is_always_cow_inode(struct xfs_inode *ip)
> +{
> +	return xfs_globals.always_cow &&
> +		xfs_sb_version_hasreflink(&ip->i_mount->m_sb);
> +}
> +
> +static inline bool xfs_is_cow_inode(struct xfs_inode *ip)
> +{
> +	return xfs_is_reflink_inode(ip) || xfs_is_always_cow_inode(ip);
> +}
> +
>  extern int xfs_reflink_find_shared(struct xfs_mount *mp, struct xfs_trans *tp,
>  		xfs_agnumber_t agno, xfs_agblock_t agbno, xfs_extlen_t aglen,
>  		xfs_agblock_t *fbno, xfs_extlen_t *flen, bool find_maximal);
>  extern int xfs_reflink_trim_around_shared(struct xfs_inode *ip,
>  		struct xfs_bmbt_irec *irec, bool *shared);
> +bool xfs_inode_need_cow(struct xfs_inode *ip, struct xfs_bmbt_irec *imap,
> +		bool *shared);
>  
>  extern int xfs_reflink_allocate_cow(struct xfs_inode *ip,
>  		struct xfs_bmbt_irec *imap, bool *shared, uint *lockmode,
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index d3e6cd063688..f4d34749505e 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1728,11 +1728,16 @@ xfs_fs_fill_super(
>  		}
>  	}
>  
> -	if (xfs_sb_version_hasreflink(&mp->m_sb) && mp->m_sb.sb_rblocks) {
> -		xfs_alert(mp,
> +	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
> +		if (mp->m_sb.sb_rblocks) {
> +			xfs_alert(mp,
>  	"reflink not compatible with realtime device!");
> -		error = -EINVAL;
> -		goto out_filestream_unmount;
> +			error = -EINVAL;
> +			goto out_filestream_unmount;
> +		}
> +
> +		if (xfs_globals.always_cow)
> +			xfs_info(mp, "using DEBUG-only always_cow mode.");
>  	}
>  
>  	if (xfs_sb_version_hasrmapbt(&mp->m_sb) && mp->m_sb.sb_rblocks) {
> diff --git a/fs/xfs/xfs_sysctl.h b/fs/xfs/xfs_sysctl.h
> index 168488130a19..ad7f9be13087 100644
> --- a/fs/xfs/xfs_sysctl.h
> +++ b/fs/xfs/xfs_sysctl.h
> @@ -85,6 +85,7 @@ struct xfs_globals {
>  	int	log_recovery_delay;	/* log recovery delay (secs) */
>  	int	mount_delay;		/* mount setup delay (secs) */
>  	bool	bug_on_assert;		/* BUG() the kernel on assert failure */
> +	bool	always_cow;		/* use COW fork for all overwrites */
>  };
>  extern struct xfs_globals	xfs_globals;
>  
> diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
> index cd6a994a7250..cabda13f3c64 100644
> --- a/fs/xfs/xfs_sysfs.c
> +++ b/fs/xfs/xfs_sysfs.c
> @@ -183,10 +183,34 @@ mount_delay_show(
>  }
>  XFS_SYSFS_ATTR_RW(mount_delay);
>  
> +static ssize_t
> +always_cow_store(
> +	struct kobject	*kobject,
> +	const char	*buf,
> +	size_t		count)
> +{
> +	ssize_t		ret;
> +
> +	ret = kstrtobool(buf, &xfs_globals.always_cow);
> +	if (ret < 0)
> +		return ret;
> +	return count;
> +}
> +
> +static ssize_t
> +always_cow_show(
> +	struct kobject	*kobject,
> +	char		*buf)
> +{
> +	return snprintf(buf, PAGE_SIZE, "%d\n", xfs_globals.always_cow);
> +}
> +XFS_SYSFS_ATTR_RW(always_cow);
> +
>  static struct attribute *xfs_dbg_attrs[] = {
>  	ATTR_LIST(bug_on_assert),
>  	ATTR_LIST(log_recovery_delay),
>  	ATTR_LIST(mount_delay),
> +	ATTR_LIST(always_cow),
>  	NULL,
>  };
>  
> -- 
> 2.19.1
> 
