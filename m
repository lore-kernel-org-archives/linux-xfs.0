Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:48808 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726128AbeIUCCU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Sep 2018 22:02:20 -0400
Date: Thu, 20 Sep 2018 13:17:02 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 5/5] xfs: introduce an always_cow mode
Message-ID: <20180920201702.GN20086@magnolia>
References: <20180920144220.2181-1-hch@lst.de>
 <20180920144220.2181-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180920144220.2181-6-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Sep 20, 2018 at 04:42:20PM +0200, Christoph Hellwig wrote:
> When the (debug-only) always_cow module parameter is set, we will always
> write out place, even if the file is not reflinked.  In addition to being
> a useful debug aid this prepares for modes where we must always write
> out of place.  An example for that is the upcoming support for atomic
> overwrites.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_aops.c    |  2 +-
>  fs/xfs/xfs_file.c    |  2 +-
>  fs/xfs/xfs_iomap.c   |  8 +++----
>  fs/xfs/xfs_reflink.c | 50 ++++++++++++++++++++++++++++++++------------
>  fs/xfs/xfs_reflink.h | 13 ++++++++++++
>  5 files changed, 56 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 775cdcfe70c2..65352d52d24a 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -980,7 +980,7 @@ xfs_vm_bmap(
>  	 * Since we don't pass back blockdev info, we can't return bmap
>  	 * information for rt files either.
>  	 */
> -	if (xfs_is_reflink_inode(ip) || XFS_IS_REALTIME_INODE(ip))
> +	if (xfs_is_cow_inode(ip) || XFS_IS_REALTIME_INODE(ip))
>  		return 0;
>  	return iomap_bmap(mapping, block, &xfs_iomap_ops);
>  }
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index fa8fbc84eec8..2756fc583716 100644
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
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 1bfc40ce581a..398c5b23a368 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -570,7 +570,7 @@ xfs_delalloc_iomap_begin(
>  	if (eof)
>  		got.br_startoff = maxbytes_fsb;
>  	if (got.br_startoff <= offset_fsb) {
> -		if (xfs_is_reflink_inode(ip) &&
> +		if (xfs_is_cow_inode(ip) &&
>  		    ((flags & IOMAP_WRITE) ||
>  		     got.br_state != XFS_EXT_UNWRITTEN)) {
>  			end_fsb = min(XFS_B_TO_FSB(mp, offset + count),
> @@ -1048,7 +1048,7 @@ xfs_ilock_for_iomap(
>  	 * COW writes may allocate delalloc space or convert unwritten COW
>  	 * extents, so we need to make sure to take the lock exclusively here.
>  	 */
> -	if (xfs_is_reflink_inode(ip) && is_write) {
> +	if (xfs_is_cow_inode(ip) && is_write) {
>  		/*
>  		 * FIXME: It could still overwrite on unshared extents and not
>  		 * need allocation.
> @@ -1082,7 +1082,7 @@ xfs_ilock_for_iomap(
>  	 * check, so if we got ILOCK_SHARED for a write and but we're now a
>  	 * reflink inode we have to switch to ILOCK_EXCL and relock.
>  	 */
> -	if (mode == XFS_ILOCK_SHARED && is_write && xfs_is_reflink_inode(ip)) {
> +	if (mode == XFS_ILOCK_SHARED && is_write && xfs_is_cow_inode(ip)) {
>  		xfs_iunlock(ip, mode);
>  		mode = XFS_ILOCK_EXCL;
>  		goto relock;
> @@ -1151,7 +1151,7 @@ xfs_file_iomap_begin(
>  	 * Break shared extents if necessary. Checks for non-blocking IO have
>  	 * been done up front, so we don't need to do them here.
>  	 */
> -	if (xfs_is_reflink_inode(ip)) {
> +	if (xfs_is_cow_inode(ip)) {
>  		error = xfs_reflink_allocate_cow(ip, &imap, &shared, &lockmode);
>  		if (error)
>  			goto out_unlock;
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index b25ea7a3a0e7..a893f6d65ff0 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -129,6 +129,11 @@
>   * ioend, the better.
>   */
>  
> +#ifdef DEBUG
> +bool xfs_always_cow;
> +module_param_named(always_cow, xfs_always_cow, bool, 0644);
> +#endif

I would have expected this to end up in /proc/sys/fs/xfs/always_cow
along with all the other behavior knobs, but I guess this is a debugging
thing...?

> +
>  /*
>   * Given an AG extent, find the lowest-numbered run of shared blocks
>   * within that range and return the range in fbno/flen.  If
> @@ -192,7 +197,7 @@ xfs_reflink_trim_around_shared(
>  	int			error = 0;
>  
>  	/* Holes, unwritten, and delalloc extents cannot be shared */
> -	if (!xfs_is_reflink_inode(ip) || !xfs_bmap_is_real_extent(irec)) {
> +	if (!xfs_is_cow_inode(ip) || !xfs_bmap_is_real_extent(irec)) {
>  		*shared = false;
>  		return 0;
>  	}
> @@ -234,6 +239,22 @@ xfs_reflink_trim_around_shared(
>  	}
>  }
>  
> +static bool
> +xfs_inode_need_cow(
> +	struct xfs_inode	*ip,
> +	struct xfs_bmbt_irec	*imap,
> +	bool			*shared)
> +{
> +	/* We can't update any real extents in always COW mode. */

/me struggled with this for a minute before figuring out what the
comment was trying to tell me.  Is the following accurate?

"In always_cow mode, behave as if the incoming data fork imap is
completely shared." ?

--D

> +	if (xfs_always_cow && !isnullstartblock(imap->br_startblock)) {
> +		*shared = true;
> +		return 0;
> +	}
> +
> +	/* Trim the mapping to the nearest shared extent boundary. */
> +	return xfs_reflink_trim_around_shared(ip, imap, shared);
> +}
> +
>  /*
>   * Trim the passed in imap to the next shared/unshared extent boundary, and
>   * if imap->br_startoff points to a shared extent reserve space for it in the
> @@ -248,13 +269,17 @@ xfs_reflink_reserve_cow(
>  	struct xfs_inode	*ip,
>  	struct xfs_bmbt_irec	*imap)
>  {
> -	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
>  	struct xfs_bmbt_irec	got;
>  	int			error = 0;
>  	bool			eof = false;
>  	struct xfs_iext_cursor	icur;
>  	bool			shared;
>  
> +	if (!ip->i_cowfp) {
> +		ASSERT(!xfs_is_reflink_inode(ip));
> +		xfs_ifork_init_cow(ip);
> +	}
> +
>  	/*
>  	 * Search the COW fork extent list first.  This serves two purposes:
>  	 * first this implement the speculative preallocation using cowextisze,
> @@ -263,8 +288,8 @@ xfs_reflink_reserve_cow(
>  	 * extent list is generally faster than going out to the shared extent
>  	 * tree.
>  	 */
> -
> -	if (!xfs_iext_lookup_extent(ip, ifp, imap->br_startoff, &icur, &got))
> +	if (!xfs_iext_lookup_extent(ip, ip->i_cowfp, imap->br_startoff, &icur,
> +			&got))
>  		eof = true;
>  	if (!eof && got.br_startoff <= imap->br_startoff) {
>  		trace_xfs_reflink_cow_found(ip, imap);
> @@ -273,14 +298,10 @@ xfs_reflink_reserve_cow(
>  	}
>  
>  	/* Trim the mapping to the nearest shared extent boundary. */
> -	error = xfs_reflink_trim_around_shared(ip, imap, &shared);
> -	if (error)
> +	error = xfs_inode_need_cow(ip, imap, &shared);
> +	if (error || !shared)
>  		return error;
>  
> -	/* Not shared?  Just report the (potentially capped) extent. */
> -	if (!shared)
> -		return 0;
> -
>  	/*
>  	 * Fork all the shared blocks from our write offset until the end of
>  	 * the extent.
> @@ -374,7 +395,7 @@ xfs_find_trim_cow_extent(
>  	if (got.br_startoff > offset_fsb) {
>  		xfs_trim_extent(imap, imap->br_startoff,
>  				got.br_startoff - imap->br_startoff);
> -		return xfs_reflink_trim_around_shared(ip, imap, shared);
> +		return xfs_inode_need_cow(ip, imap, shared);
>  	}
>  
>  	*shared = true;
> @@ -408,7 +429,10 @@ xfs_reflink_allocate_cow(
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
> @@ -585,7 +609,7 @@ xfs_reflink_cancel_cow_range(
>  	int			error;
>  
>  	trace_xfs_reflink_cancel_cow_range(ip, offset, count);
> -	ASSERT(xfs_is_reflink_inode(ip));
> +	ASSERT(ip->i_cowfp);
>  
>  	offset_fsb = XFS_B_TO_FSBT(ip->i_mount, offset);
>  	if (count == NULLFILEOFF)
> diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
> index 7f47202b5639..b89e07239b82 100644
> --- a/fs/xfs/xfs_reflink.h
> +++ b/fs/xfs/xfs_reflink.h
> @@ -6,6 +6,19 @@
>  #ifndef __XFS_REFLINK_H
>  #define __XFS_REFLINK_H 1
>  
> +#ifdef DEBUG
> +extern bool xfs_always_cow;
> +#else
> +#define xfs_always_cow	false
> +#endif
> +
> +static inline bool xfs_is_cow_inode(struct xfs_inode *ip)
> +{
> +	return xfs_is_reflink_inode(ip) ||
> +		(xfs_always_cow &&
> +		 xfs_sb_version_hasreflink(&ip->i_mount->m_sb));
> +}
> +
>  extern int xfs_reflink_find_shared(struct xfs_mount *mp, struct xfs_trans *tp,
>  		xfs_agnumber_t agno, xfs_agblock_t agbno, xfs_extlen_t aglen,
>  		xfs_agblock_t *fbno, xfs_extlen_t *flen, bool find_maximal);
> -- 
> 2.18.0
> 
