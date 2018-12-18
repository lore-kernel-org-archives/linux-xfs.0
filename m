Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:41248 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726590AbeLRXYp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Dec 2018 18:24:45 -0500
Date: Tue, 18 Dec 2018 15:24:37 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 11/11] xfs: introduce an always_cow mode
Message-ID: <20181218232437.GS27208@magnolia>
References: <20181203222503.30649-1-hch@lst.de>
 <20181203222503.30649-12-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181203222503.30649-12-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Dec 03, 2018 at 05:25:03PM -0500, Christoph Hellwig wrote:
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
>  fs/xfs/xfs_file.c    | 11 ++++++++++-
>  fs/xfs/xfs_iomap.c   | 28 ++++++++++++++++++----------
>  fs/xfs/xfs_reflink.c | 28 ++++++++++++++++++++++++----
>  fs/xfs/xfs_reflink.h | 13 +++++++++++++
>  fs/xfs/xfs_super.c   | 13 +++++++++----
>  fs/xfs/xfs_sysctl.h  |  1 +
>  fs/xfs/xfs_sysfs.c   | 24 ++++++++++++++++++++++++
>  8 files changed, 100 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 7d95a84064e7..a900924f16e1 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -986,7 +986,7 @@ xfs_vm_bmap(
>  	 * Since we don't pass back blockdev info, we can't return bmap
>  	 * information for rt files either.
>  	 */
> -	if (xfs_is_reflink_inode(ip) || XFS_IS_REALTIME_INODE(ip))
> +	if (xfs_is_cow_inode(ip) || XFS_IS_REALTIME_INODE(ip))
>  		return 0;
>  	return iomap_bmap(mapping, block, &xfs_iomap_ops);
>  }
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index e47425071e65..8d2be043590a 100644
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
> @@ -806,6 +806,15 @@ xfs_file_fallocate(
>  		return -EOPNOTSUPP;
>  
>  	xfs_ilock(ip, iolock);
> +	/*
> +	 * If always_cow mode we can't use preallocation and thus should not
> +	 * allow creating them.
> +	 */
> +	if (xfs_is_always_cow_inode(ip) && (mode & ~FALLOC_FL_KEEP_SIZE) == 0) {
> +		error = -EOPNOTSUPP;
> +		goto out_unlock;

I think this screws up both UNSHARE and ZERO_RANGE here -- if the first
mode is set, we'll cow the shared extents, but we'll also fill holes
with unwritten extents, which the comment implies isn't allowed.  In the
second set we'll punch the range but refill it with unwritten extents
that we'll never actually overwrite.

Granted, I'm still rather fuzzy on what exactly is supposed to happen
with preallocating fallocate when all writes require an allocation to
succeed?  btrfs fills holes with unwritten extents which the next write
will overwrite, but non-holes cow like normal.  That only makes sense if
you assume people only use fallocate to preallocate holes.  Maybe we
don't want to follow that route.  It's probably simpler not to support
creation of unwritten extents for always_cow files, in which case you'll
have to neuter UNSHARE too.

As for ZERO_RANGE, I think it's sufficient to punch the range, since we
COW even the unwritten extents (which makes allocating them pointless),
right?

What's the real goal here?  I assume you're targeting both O_ATOMIC in
addition to being able to use SMR drives as realtime devices, right?  It
would help to have a better idea of where we're going here before adding
anything user visible, even if it's just a debug knob for now.

> +	}
> +
>  	error = xfs_break_layouts(inode, &iolock, BREAK_UNMAP);
>  	if (error)
>  		goto out_unlock;
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index bbc5d2e06b06..244ea0007c09 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -395,12 +395,13 @@ xfs_quota_calc_throttle(
>  STATIC xfs_fsblock_t
>  xfs_iomap_prealloc_size(
>  	struct xfs_inode	*ip,
> +	int			whichfork,
>  	loff_t			offset,
>  	loff_t			count,
>  	struct xfs_iext_cursor	*icur)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
> -	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
> +	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
>  	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
>  	struct xfs_bmbt_irec	prev;
>  	int			shift = 0;
> @@ -593,7 +594,11 @@ xfs_file_iomap_begin_delay(
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
> @@ -609,7 +614,7 @@ xfs_file_iomap_begin_delay(
>  		 * overwriting shared extents.   This includes zeroing of
>  		 * existing extents that contain data.
>  		 */
> -		if (!xfs_is_reflink_inode(ip) ||
> +		if (!xfs_is_cow_inode(ip) ||
>  		    ((flags & IOMAP_ZERO) && imap.br_state != XFS_EXT_NORM)) {
>  			trace_xfs_iomap_found(ip, offset, count, XFS_DATA_FORK,
>  					&imap);
> @@ -619,7 +624,7 @@ xfs_file_iomap_begin_delay(
>  		xfs_trim_extent(&imap, offset_fsb, end_fsb - offset_fsb);
>  
>  		/* Trim the mapping to the nearest shared extent boundary. */
> -		error = xfs_reflink_trim_around_shared(ip, &imap, &shared);
> +		error = xfs_inode_need_cow(ip, &imap, &shared);
>  		if (error)
>  			goto out_unlock;
>  
> @@ -648,15 +653,18 @@ xfs_file_iomap_begin_delay(
>  		 */
>  		count = min_t(loff_t, count, 1024 * PAGE_SIZE);
>  		end_fsb = min(XFS_B_TO_FSB(mp, offset + count), maxbytes_fsb);
> +
> +		if (xfs_is_always_cow_inode(ip))
> +			whichfork = XFS_COW_FORK;
>  	}
>  
>  	error = xfs_qm_dqattach_locked(ip, false);
>  	if (error)
>  		goto out_unlock;
>  
> -	if (eof && whichfork == XFS_DATA_FORK) {
> -		prealloc_blocks = xfs_iomap_prealloc_size(ip, offset, count,
> -				&icur);
> +	if (eof) {
> +		prealloc_blocks = xfs_iomap_prealloc_size(ip, whichfork, offset,
> +				count, &icur);
>  		if (prealloc_blocks) {
>  			xfs_extlen_t	align;
>  			xfs_off_t	end_offset;
> @@ -987,7 +995,7 @@ xfs_ilock_for_iomap(
>  	 * COW writes may allocate delalloc space or convert unwritten COW
>  	 * extents, so we need to make sure to take the lock exclusively here.
>  	 */
> -	if (xfs_is_reflink_inode(ip) && is_write) {
> +	if (xfs_is_cow_inode(ip) && is_write) {
>  		/*
>  		 * FIXME: It could still overwrite on unshared extents and not
>  		 * need allocation.
> @@ -1021,7 +1029,7 @@ xfs_ilock_for_iomap(
>  	 * check, so if we got ILOCK_SHARED for a write and but we're now a
>  	 * reflink inode we have to switch to ILOCK_EXCL and relock.
>  	 */
> -	if (mode == XFS_ILOCK_SHARED && is_write && xfs_is_reflink_inode(ip)) {
> +	if (mode == XFS_ILOCK_SHARED && is_write && xfs_is_cow_inode(ip)) {
>  		xfs_iunlock(ip, mode);
>  		mode = XFS_ILOCK_EXCL;
>  		goto relock;
> @@ -1093,7 +1101,7 @@ xfs_file_iomap_begin(
>  	 * Break shared extents if necessary. Checks for non-blocking IO have
>  	 * been done up front, so we don't need to do them here.
>  	 */
> -	if (xfs_is_reflink_inode(ip)) {
> +	if (xfs_is_cow_inode(ip)) {
>  		struct xfs_bmbt_irec	orig = imap;
>  
>  		/* if zeroing doesn't need COW allocation, then we are done. */
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 0cf13cb1b2fe..1da46899c215 100644
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
>  static int
>  xfs_reflink_convert_cow_locked(
>  	struct xfs_inode	*ip,
> @@ -321,7 +338,7 @@ xfs_find_trim_cow_extent(
>  	if (got.br_startoff > offset_fsb) {
>  		xfs_trim_extent(imap, imap->br_startoff,
>  				got.br_startoff - imap->br_startoff);
> -		return xfs_reflink_trim_around_shared(ip, imap, shared);
> +		return xfs_inode_need_cow(ip, imap, shared);
>  	}
>  
>  	*shared = true;
> @@ -356,7 +373,10 @@ xfs_reflink_allocate_cow(
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
> @@ -537,7 +557,7 @@ xfs_reflink_cancel_cow_range(
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

How does xfs handle the situation where always_cow mode comes on after
you've already opened a file and begun writing to it?  I assume we
allocate a new cow fork for files that need it and all writes after the
switch flips will be COW?

--D

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
