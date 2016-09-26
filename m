Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47126 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933166AbcIZVJG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Sep 2016 17:09:06 -0400
Date: Mon, 26 Sep 2016 14:08:49 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/2] xfs: kill xfs_reflink_is_cow_pending
Message-ID: <20160926210849.GC14092@birch.djwong.org>
References: <1474730361-5234-1-git-send-email-hch@lst.de>
 <1474730361-5234-2-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1474730361-5234-2-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Sat, Sep 24, 2016 at 08:19:20AM -0700, Christoph Hellwig wrote:
> Instead enhance xfs_reflink_find_cow_mapping to properly deal with the
> fact that we might not have a COW mapping at the offset, and just
> return false in this case.
> 
> This avoids code duplication, makes xfs_reflink_find_cow_mapping more
> robust, and last but not least halves the number of extent map lookups
> needed in COW writeback operations.

Hooray!

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_aops.c    | 28 ++++++++++++++++------------
>  fs/xfs/xfs_reflink.c | 42 +++++++++++-------------------------------
>  fs/xfs/xfs_reflink.h |  3 +--
>  3 files changed, 28 insertions(+), 45 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index d8ce18b..1933803 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -379,10 +379,13 @@ xfs_map_blocks(
>  	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + count);
>  	offset_fsb = XFS_B_TO_FSBT(mp, offset);
>  
> -	if (type == XFS_IO_COW)
> -		error = xfs_reflink_find_cow_mapping(ip, offset, imap,
> -						     &need_alloc);
> -	else {
> +	if (type == XFS_IO_COW) {
> +		if (!xfs_reflink_find_cow_mapping(ip, offset, imap,
> +						     &need_alloc)) {
> +			WARN_ON_ONCE(1);
> +			return -EIO;
> +		}

I squinted at this for a second but then realized it goes away in the
next patch anyway.

> +	} else {
>  		error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
>  				       imap, &nimaps, bmapi_flags);
>  		/*
> @@ -712,13 +715,14 @@ xfs_is_cow_io(
>  	struct xfs_inode	*ip,
>  	xfs_off_t		offset)
>  {
> -	bool			is_cow;
> +	struct xfs_bmbt_irec	imap;
> +	bool			is_cow, need_alloc;
>  
>  	if (!xfs_sb_version_hasreflink(&ip->i_mount->m_sb))
>  		return false;
>  
>  	xfs_ilock(ip, XFS_ILOCK_SHARED);
> -	is_cow = xfs_reflink_is_cow_pending(ip, offset);
> +	is_cow = xfs_reflink_find_cow_mapping(ip, offset, &imap, &need_alloc);
>  	xfs_iunlock(ip, XFS_ILOCK_SHARED);
>  
>  	return is_cow;
> @@ -1316,12 +1320,12 @@ __xfs_get_blocks(
>  	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + size);
>  	offset_fsb = XFS_B_TO_FSBT(mp, offset);
>  
> -	if (create && direct)
> -		is_cow = xfs_reflink_is_cow_pending(ip, offset);
> -	if (is_cow)
> -		error = xfs_reflink_find_cow_mapping(ip, offset, &imap,
> -						     &need_alloc);
> -	else {
> +	if (create && direct) {
> +		is_cow = xfs_reflink_find_cow_mapping(ip, offset, &imap,
> +					&need_alloc);
> +	}
> +
> +	if (!is_cow) {
>  		error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
>  					&imap, &nimaps, XFS_BMAPI_ENTIRE);
>  		/*
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 6f87b1e..a1ba7f5 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -429,26 +429,31 @@ advloop:
>  }
>  
>  /*
> - * Determine if there's a CoW reservation at a byte offset of an inode.
> + * Find the CoW reservation (and whether or not it needs block allocation)
> + * for a given byte offset of a file.
>   */
>  bool
> -xfs_reflink_is_cow_pending(
> +xfs_reflink_find_cow_mapping(
>  	struct xfs_inode		*ip,
> -	xfs_off_t			offset)
> +	xfs_off_t			offset,
> +	struct xfs_bmbt_irec		*imap,
> +	bool				*need_alloc)
>  {
> +	struct xfs_bmbt_irec		irec;
>  	struct xfs_ifork		*ifp;
>  	struct xfs_bmbt_rec_host	*gotp;
> -	struct xfs_bmbt_irec		irec;
>  	xfs_fileoff_t			bno;
>  	xfs_extnum_t			idx;
>  
> +	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL | XFS_ILOCK_SHARED));
> +
>  	if (!xfs_is_reflink_inode(ip))
>  		return false;
>  
> +	/* Find the extent in the CoW fork. */
>  	ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
>  	bno = XFS_B_TO_FSBT(ip->i_mount, offset);
>  	gotp = xfs_iext_bno_to_ext(ifp, bno, &idx);
> -
>  	if (!gotp)
>  		return false;
>  
> @@ -456,31 +461,6 @@ xfs_reflink_is_cow_pending(
>  	if (bno >= irec.br_startoff + irec.br_blockcount ||
>  	    bno < irec.br_startoff)
>  		return false;
> -	return true;
> -}
> -
> -/*
> - * Find the CoW reservation (and whether or not it needs block allocation)
> - * for a given byte offset of a file.
> - */
> -int
> -xfs_reflink_find_cow_mapping(
> -	struct xfs_inode		*ip,
> -	xfs_off_t			offset,
> -	struct xfs_bmbt_irec		*imap,
> -	bool				*need_alloc)
> -{
> -	struct xfs_bmbt_irec		irec;
> -	struct xfs_ifork		*ifp;
> -	struct xfs_bmbt_rec_host	*gotp;
> -	xfs_fileoff_t			bno;
> -	xfs_extnum_t			idx;
> -
> -	/* Find the extent in the CoW fork. */
> -	ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
> -	bno = XFS_B_TO_FSBT(ip->i_mount, offset);
> -	gotp = xfs_iext_bno_to_ext(ifp, bno, &idx);
> -	xfs_bmbt_get_all(gotp, &irec);
>  
>  	trace_xfs_reflink_find_cow_mapping(ip, offset, 1, XFS_IO_OVERWRITE,
>  			&irec);
> @@ -489,7 +469,7 @@ xfs_reflink_find_cow_mapping(
>  	*imap = irec;
>  	*need_alloc = !!(isnullstartblock(irec.br_startblock));
>  
> -	return 0;
> +	return true;

Otherwise looks resonable enough, so
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
> index 398e726..6519f19 100644
> --- a/fs/xfs/xfs_reflink.h
> +++ b/fs/xfs/xfs_reflink.h
> @@ -30,8 +30,7 @@ extern int xfs_reflink_reserve_cow_range(struct xfs_inode *ip,
>  		xfs_fileoff_t offset_fsb, xfs_fileoff_t end_fsb);
>  extern int xfs_reflink_allocate_cow_range(struct xfs_inode *ip, xfs_off_t pos,
>  		xfs_off_t len);
> -extern bool xfs_reflink_is_cow_pending(struct xfs_inode *ip, xfs_off_t offset);
> -extern int xfs_reflink_find_cow_mapping(struct xfs_inode *ip, xfs_off_t offset,
> +extern bool xfs_reflink_find_cow_mapping(struct xfs_inode *ip, xfs_off_t offset,
>  		struct xfs_bmbt_irec *imap, bool *need_alloc);
>  extern int xfs_reflink_trim_irec_to_next_cow(struct xfs_inode *ip,
>  		xfs_fileoff_t offset_fsb, struct xfs_bmbt_irec *imap);
> -- 
> 2.1.4
> 
