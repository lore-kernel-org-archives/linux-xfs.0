Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00B95C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Jan 2022 02:10:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347470AbiAYCKU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jan 2022 21:10:20 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35036 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1848545AbiAYAcL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jan 2022 19:32:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7EA9BB81229
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jan 2022 00:32:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C004C340E4;
        Tue, 25 Jan 2022 00:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643070726;
        bh=UO5qwXEdPMcRNp2Sxmpe+LbhbSQYyFplp/T+6zkJDrc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RDlmPTw2tG9drhy/sZMrORuBsjzZOG5UzB5a2E6B7vD6rFY3qhWu6ux8q2ZGGxpb7
         TGi+sX7bwAOpevkN6urPPLrpNCcAU8XsWdFGDN/GbeuikDyfSXXGmWGr0UTFyoBwv7
         2Gn3Wazvdxxp3YDi+qIzl3lzj10sf9LwE41OxfHxf2WpcPj3kzFtTYVUjs7h3HR+mf
         NIImjXOhML6wGOm0FlWdd08+T6zGyGrU+AW9Kri6+uAGVg3KJCvPWTck4Z0Dj3atnM
         IZODSyV2BPtf4l8rO9VKFODNM2ghnLrTnrmXhlmUVzAKL0g/jB0ywXnlYGixDXdftw
         Tt/IuP0ziF0Jw==
Date:   Mon, 24 Jan 2022 16:32:05 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH V5 06/16] xfs: Promote xfs_extnum_t and xfs_aextnum_t to
 64 and 32-bits respectively
Message-ID: <20220125003205.GW13540@magnolia>
References: <20220121051857.221105-1-chandan.babu@oracle.com>
 <20220121051857.221105-7-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220121051857.221105-7-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 21, 2022 at 10:48:47AM +0530, Chandan Babu R wrote:
> A future commit will introduce a 64-bit on-disk data extent counter and a
> 32-bit on-disk attr extent counter. This commit promotes xfs_extnum_t and
> xfs_aextnum_t to 64 and 32-bits in order to correctly handle in-core versions
> of these quantities.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>

Looks good now,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c       | 6 +++---
>  fs/xfs/libxfs/xfs_inode_fork.c | 2 +-
>  fs/xfs/libxfs/xfs_inode_fork.h | 2 +-
>  fs/xfs/libxfs/xfs_types.h      | 4 ++--
>  fs/xfs/xfs_inode.c             | 4 ++--
>  fs/xfs/xfs_trace.h             | 2 +-
>  6 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 6a0da0a2b3fd..6cc7817ff425 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -52,9 +52,9 @@ xfs_bmap_compute_maxlevels(
>  	xfs_mount_t	*mp,		/* file system mount structure */
>  	int		whichfork)	/* data or attr fork */
>  {
> +	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
>  	int		level;		/* btree level */
>  	uint		maxblocks;	/* max blocks at this level */
> -	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
>  	int		maxrootrecs;	/* max records in root block */
>  	int		minleafrecs;	/* min records in leaf block */
>  	int		minnoderecs;	/* min records in node block */
> @@ -83,7 +83,7 @@ xfs_bmap_compute_maxlevels(
>  	maxrootrecs = xfs_bmdr_maxrecs(sz, 0);
>  	minleafrecs = mp->m_bmap_dmnr[0];
>  	minnoderecs = mp->m_bmap_dmnr[1];
> -	maxblocks = (maxleafents + minleafrecs - 1) / minleafrecs;
> +	maxblocks = howmany_64(maxleafents, minleafrecs);
>  	for (level = 1; maxblocks > 1; level++) {
>  		if (maxblocks <= maxrootrecs)
>  			maxblocks = 1;
> @@ -467,7 +467,7 @@ xfs_bmap_check_leaf_extents(
>  	if (bp_release)
>  		xfs_trans_brelse(NULL, bp);
>  error_norelse:
> -	xfs_warn(mp, "%s: BAD after btree leaves for %d extents",
> +	xfs_warn(mp, "%s: BAD after btree leaves for %llu extents",
>  		__func__, i);
>  	xfs_err(mp, "%s: CORRUPTED BTREE OR SOMETHING", __func__);
>  	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 829739e249b6..ce690abe5dce 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -117,7 +117,7 @@ xfs_iformat_extents(
>  	 * we just bail out rather than crash in kmem_alloc() or memcpy() below.
>  	 */
>  	if (unlikely(size < 0 || size > XFS_DFORK_SIZE(dip, mp, whichfork))) {
> -		xfs_warn(ip->i_mount, "corrupt inode %Lu ((a)extents = %d).",
> +		xfs_warn(ip->i_mount, "corrupt inode %llu ((a)extents = %llu).",
>  			(unsigned long long) ip->i_ino, nex);
>  		xfs_inode_verifier_error(ip, -EFSCORRUPTED,
>  				"xfs_iformat_extents(1)", dip, sizeof(*dip),
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index 7ed2ecb51bca..4a8b77d425df 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -21,9 +21,9 @@ struct xfs_ifork {
>  		void		*if_root;	/* extent tree root */
>  		char		*if_data;	/* inline file data */
>  	} if_u1;
> +	xfs_extnum_t		if_nextents;	/* # of extents in this fork */
>  	short			if_broot_bytes;	/* bytes allocated for root */
>  	int8_t			if_format;	/* format of this fork */
> -	xfs_extnum_t		if_nextents;	/* # of extents in this fork */
>  };
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> index 794a54cbd0de..373f64a492a4 100644
> --- a/fs/xfs/libxfs/xfs_types.h
> +++ b/fs/xfs/libxfs/xfs_types.h
> @@ -12,8 +12,8 @@ typedef uint32_t	xfs_agblock_t;	/* blockno in alloc. group */
>  typedef uint32_t	xfs_agino_t;	/* inode # within allocation grp */
>  typedef uint32_t	xfs_extlen_t;	/* extent length in blocks */
>  typedef uint32_t	xfs_agnumber_t;	/* allocation group number */
> -typedef int32_t		xfs_extnum_t;	/* # of extents in a file */
> -typedef int16_t		xfs_aextnum_t;	/* # extents in an attribute fork */
> +typedef uint64_t	xfs_extnum_t;	/* # of extents in a file */
> +typedef uint32_t	xfs_aextnum_t;	/* # extents in an attribute fork */
>  typedef int64_t		xfs_fsize_t;	/* bytes in a file */
>  typedef uint64_t	xfs_ufsize_t;	/* unsigned bytes in a file */
>  
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 6771f357ad2c..6813c2337da7 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3495,8 +3495,8 @@ xfs_iflush(
>  	if (XFS_TEST_ERROR(ip->i_df.if_nextents + xfs_ifork_nextents(ip->i_afp) >
>  				ip->i_nblocks, mp, XFS_ERRTAG_IFLUSH_5)) {
>  		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
> -			"%s: detected corrupt incore inode %Lu, "
> -			"total extents = %d, nblocks = %Ld, ptr "PTR_FMT,
> +			"%s: detected corrupt incore inode %llu, "
> +			"total extents = %llu nblocks = %lld, ptr "PTR_FMT,
>  			__func__, ip->i_ino,
>  			ip->i_df.if_nextents + xfs_ifork_nextents(ip->i_afp),
>  			ip->i_nblocks, ip);
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 3153db29de40..6b4a7f197308 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -2182,7 +2182,7 @@ DECLARE_EVENT_CLASS(xfs_swap_extent_class,
>  		__entry->broot_size = ip->i_df.if_broot_bytes;
>  		__entry->fork_off = XFS_IFORK_BOFF(ip);
>  	),
> -	TP_printk("dev %d:%d ino 0x%llx (%s), %s format, num_extents %d, "
> +	TP_printk("dev %d:%d ino 0x%llx (%s), %s format, num_extents %llu, "
>  		  "broot size %d, forkoff 0x%x",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino,
> -- 
> 2.30.2
> 
