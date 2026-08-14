Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0301371049;
	Fri, 14 Aug 2026 15:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786720771; cv=none; b=YPojs2X/V7KgXDud5qwWBbqdJrnHAUFBtLNRUSneGppZbnqQQNmgsSLj1caSBxEIX4/LKMRW6EIRBF0AyZ2t2s8gx+0Y00gWuHJBEtPVVoLxasGPX0K56gojasuoNhDrgMwI55VFEWh71O2xSv9r2Tn9UJ5umg5Vb3k+laVNlQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786720771; c=relaxed/simple;
	bh=jbJyzGZ3fwQRcrNkA1167Kvzd1fz7sJ+ClanBLAh270=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q3N5/t4S853fnz4k1xofONejAs2NMA0IRvt3Rdv5QwpE5N6LO5LPKvjXHa94T4ihLstDwRcWIcZCBHHuSOsOmxq0TCJL8TKbA1c6cfWqEXRZnhqTejklrnerctx/LbZPOSWYDXha+UGe1rF+BZRp/1jknqS5bG6TsuueNvLKfZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sh6Ix6p8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sh6Ix6p8"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3CBF01F000E9;
	Fri, 14 Aug 2026 15:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786720770;
	bh=0klogLjyyrJ7xYZT2XeSv/GSN01RIwWoJwmz22NNlKY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Sh6Ix6p8w0rMY21l/SyGhDH/Puiq3KCD2ZfqRtXlwaGKVe6mzlRjCAHUhwv2CbZSF
	 gzTExqrBONIkQS0VqKcDbn/v5Uq9qR1dZsaaGWz+H1CbqcVlW2/bIFDRhUr6v0febU
	 oDlzCW2QCbye8SdY7FhtKp6nk+DofT/YnjdAOntIlEW62h07hjCttKo00tEvILyd7q
	 aayX+e8EXQS9E4WypU/Peskdb/uQTtLVWZ5Ti6nSF9HZ2fWHt+r0NpFkI0SyFR4kxh
	 BVdlsVK8QglbY3yG2ZuijNh7PjXezokYiIS3BCeT7TQeQ63mVKl51d/g6uKpkiefMd
	 xVswMRUtWLDSA==
Date: Fri, 14 Aug 2026 08:19:29 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: ebiggers@kernel.org, hch@lst.de, Jens Axboe <axboe@kernel.dk>,
	Carlos Maiolino <cem@kernel.org>, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-unionfs@vger.kernel.org, linux-block@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, david@fromorbit.com,
	Tal Zussman <tz2294@columbia.edu>
Subject: Re: [PATCH v15 18/25] xfs: make xfs_free_eofblocks() work with
 fsverity inodes
Message-ID: <20260814151929.GH3556460@frogsfrogsfrogs>
References: <20260814092448.1818082-1-aalbersh@kernel.org>
 <20260814092448.1818082-19-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260814092448.1818082-19-aalbersh@kernel.org>

On Fri, Aug 14, 2026 at 11:24:35AM +0200, Andrey Albershteyn wrote:
> xfs_free_eofblocks() removes any preallocations and unwritten extents
> beyond EOF. This is undesired for fsverity as it stores metadata beyond
> EOF. However, while merkle tree is being built delayed preallocation and

grammar nit: "... is being built, delayed preallocations..."

> unwritten extents are used. After metadata construction is done,
> fsverity inodes becomes read-only and won't be changed anymore, none of
> these unwritten extents or preallocations in post EOF region will be
> used.
> 
> Add XFS_BMAPI_UNWRITTEN and change xfs_bunmapi_range to remove only
> unwritten extents sitting beyond EOF and set it for fsverity inodes.
> 
> The xfs_free_eofblocks() will be called on fsverity inode as usual.
> However, inodes which are undergoing merkle tree construction need to
> be skipped in case reclaim takes place.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Looks good to me, thanks for revising the commit message :)
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 55 +++++++++++++++++++++++++++++-----------
>  fs/xfs/libxfs/xfs_bmap.h |  6 ++++-
>  fs/xfs/xfs_bmap_util.c   | 25 +++++++++++++++---
>  3 files changed, 67 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index cc48f6e20e80..a2d9cef952c4 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -6144,15 +6144,12 @@ xfs_bmap_validate_extent(
>  			XFS_IS_REALTIME_INODE(ip), whichfork, irec);
>  }
>  
> -/*
> - * Used in xfs_itruncate_extents().  This is the maximum number of extents
> - * freed from a file in a single transaction.
> - */
> -#define	XFS_ITRUNC_MAX_EXTENTS	2
> -
>  /*
>   * Unmap every extent in part of an inode's fork.  We don't do any higher level
>   * invalidation work at all.
> + *
> + * The XFS_BMAPI_UNWRITTEN could be passed to remove only unwritten extents,
> + * leaving out normal extents in place.
>   */
>  int
>  xfs_bunmapi_range(
> @@ -6162,23 +6159,51 @@ xfs_bunmapi_range(
>  	xfs_fileoff_t		startoff,
>  	xfs_fileoff_t		endoff)
>  {
> -	xfs_filblks_t		unmap_len = endoff - startoff + 1;
> +	xfs_filblks_t           unmap_len;
>  	int			error = 0;
> +	int			nimaps = 1;
> +	int			done = 0;
> +	struct xfs_bmbt_irec	imap;
> +	int			read_flags =
> +			flags & (XFS_BMAPI_ATTRFORK | XFS_BMAPI_ENTIRE);
>  
>  	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
>  
> -	while (unmap_len > 0) {
> -		ASSERT((*tpp)->t_highest_agno == NULLAGNUMBER);
> -		error = __xfs_bunmapi(*tpp, ip, startoff, &unmap_len, flags,
> -				XFS_ITRUNC_MAX_EXTENTS);
> +	while (startoff < endoff) {
> +		nimaps = 1;
> +
> +		error = xfs_bmapi_read(ip, startoff, endoff - startoff + 1,
> +				&imap, &nimaps, read_flags);
>  		if (error)
>  			goto out;
>  
> -		/* free the just unmapped extents */
> -		error = xfs_defer_finish(tpp);
> -		if (error)
> +		if (nimaps == 0)
>  			goto out;
> -		cond_resched();
> +
> +		if ((flags & XFS_BMAPI_UNWRITTEN) &&
> +				imap.br_state != XFS_EXT_UNWRITTEN) {
> +			startoff = imap.br_startoff + imap.br_blockcount;
> +			continue;
> +		}
> +
> +		unmap_len = min(endoff - imap.br_startoff + 1,
> +				imap.br_blockcount);
> +		done = 0;
> +		while (!done) {
> +			ASSERT((*tpp)->t_highest_agno == NULLAGNUMBER);
> +			error = xfs_bunmapi(*tpp, ip, imap.br_startoff,
> +					unmap_len, flags, nimaps, &done);
> +			if (error)
> +				goto out;
> +
> +			/* free the just unmapped extent */
> +			error = xfs_defer_finish(tpp);
> +			if (error)
> +				goto out;
> +			cond_resched();
> +		}
> +
> +		startoff = imap.br_startoff + unmap_len;
>  	}
>  out:
>  	return error;
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index d5f2729305fa..0f36431d9936 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -90,6 +90,9 @@ struct xfs_bmalloca {
>  /* Try to align allocations to the extent size hint */
>  #define XFS_BMAPI_EXTSZALIGN	(1u << 11)
>  
> +/* Process unwritten extents only. Used for unmapping */
> +#define XFS_BMAPI_UNWRITTEN	(1u << 12)
> +
>  #define XFS_BMAPI_FLAGS \
>  	{ XFS_BMAPI_ENTIRE,	"ENTIRE" }, \
>  	{ XFS_BMAPI_METADATA,	"METADATA" }, \
> @@ -102,7 +105,8 @@ struct xfs_bmalloca {
>  	{ XFS_BMAPI_COWFORK,	"COWFORK" }, \
>  	{ XFS_BMAPI_NODISCARD,	"NODISCARD" }, \
>  	{ XFS_BMAPI_NORMAP,	"NORMAP" },\
> -	{ XFS_BMAPI_EXTSZALIGN,	"EXTSZALIGN" }
> +	{ XFS_BMAPI_EXTSZALIGN,	"EXTSZALIGN" }, \
> +	{ XFS_BMAPI_UNWRITTEN,	"UNWRITTEN" }
>  
>  
>  static inline int xfs_bmapi_aflag(int w)
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index c88b9ade7389..36ac18df5743 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -31,6 +31,7 @@
>  #include "xfs_rtbitmap.h"
>  #include "xfs_rtgroup.h"
>  #include "xfs_zone_alloc.h"
> +#include <linux/fsverity.h>
>  
>  /* Kernel only BMAP related definitions and functions */
>  
> @@ -553,6 +554,13 @@ xfs_can_free_eofblocks(
>  	if (last_fsb <= end_fsb)
>  		return false;
>  
> +	/*
> +	 * Don't clean fsverity inodes which have merkle tree being built, the
> +	 * merkle tree is written beyond EOF
> +	 */
> +	if (xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION))
> +		return false;
> +
>  	/*
>  	 * Check if there is an post-EOF extent to free.  If there are any
>  	 * delalloc blocks attached to the inode (data fork delalloc
> @@ -579,6 +587,9 @@ xfs_free_eofblocks(
>  	struct xfs_trans	*tp;
>  	struct xfs_mount	*mp = ip->i_mount;
>  	int			error;
> +	int			bmapi_flags = XFS_BMAPI_NODISCARD;
> +	bool			has_verity =
> +			ip->i_diflags2 & XFS_DIFLAG2_VERITY;
>  
>  	/* Attach the dquots to the inode up front. */
>  	error = xfs_qm_dqattach(ip);
> @@ -593,15 +604,20 @@ xfs_free_eofblocks(
>  	 *
>  	 * Note that this means we also leave speculative preallocations in
>  	 * place for preallocated files.
> +	 *
> +	 * Clean up delalloc reservations for fsverity too as those won't be
> +	 * used
>  	 */
> -	if (ip->i_diflags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)) {
> +	if (ip->i_diflags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND) ||
> +			has_verity) {
>  		if (ip->i_delayed_blks) {
>  			xfs_bmap_punch_delalloc_range(ip, XFS_DATA_FORK,
>  				round_up(XFS_ISIZE(ip), mp->m_sb.sb_blocksize),
>  				LLONG_MAX, NULL);
>  		}
>  		xfs_inode_clear_eofblocks_tag(ip);
> -		return 0;
> +		if (!has_verity)
> +			return 0;
>  	}
>  
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
> @@ -613,6 +629,9 @@ xfs_free_eofblocks(
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	xfs_trans_ijoin(tp, ip, 0);
>  
> +	if (has_verity)
> +		bmapi_flags |= XFS_BMAPI_UNWRITTEN;
> +
>  	/*
>  	 * Do not update the on-disk file size.  If we update the on-disk file
>  	 * size and then the system crashes before the contents of the file are
> @@ -620,7 +639,7 @@ xfs_free_eofblocks(
>  	 * bug).
>  	 */
>  	error = xfs_itruncate_extents_flags(&tp, ip, XFS_DATA_FORK,
> -				XFS_ISIZE(ip), XFS_BMAPI_NODISCARD);
> +				XFS_ISIZE(ip), bmapi_flags);
>  	if (error)
>  		goto err_cancel;
>  
> -- 
> 2.54.0
> 
> 
