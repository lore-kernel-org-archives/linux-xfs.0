Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38F54C38142
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Feb 2023 19:10:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbjBATK4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Feb 2023 14:10:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbjBATKz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Feb 2023 14:10:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B87E13D7E
        for <linux-xfs@vger.kernel.org>; Wed,  1 Feb 2023 11:10:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 906C76192C
        for <linux-xfs@vger.kernel.org>; Wed,  1 Feb 2023 19:10:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0D02C433EF;
        Wed,  1 Feb 2023 19:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675278653;
        bh=xl4KzpLGjgs4dzJlRcA6IdIEd2B4n4N9VeXlpWApeGU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bbr/bKjz3zqCzZpm/MQqGYgzzWSQnhRChACQUJYCk3RVgBidotPkSP/vjUcp129L2
         NG2XjpLo9QH5GcKqYTsPtVDBKuYdvBeFX1fFAVhvNrhQHeACu9nYPCbSpyE0ehoZUZ
         mX/km04F/M82HPFfp++a8sTYY6qMjqnyMYxx6a6su3tJLkhdePPSrnkbYvoCGq2ezP
         DwaxZPiGK8JG+MHulyF7NN2G4GhvZdqri6388+/23+FAWkVk5mHwXUz1HJlGTUwrQt
         muTSY75ZszRgNokGPw3eahVReg05at7FvB6iRFseWQs8GzLClqB+qHFzeUJX7J8aMg
         XuTx9AvBd2zow==
Date:   Wed, 1 Feb 2023 11:10:52 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/42] xfs: convert xfs_imap() to take a perag
Message-ID: <Y9q5PAKKyju4npLP@magnolia>
References: <20230118224505.1964941-1-david@fromorbit.com>
 <20230118224505.1964941-10-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230118224505.1964941-10-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 19, 2023 at 09:44:32AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Callers have referenced perags but they don't pass it into
> xfs_imap() so it takes it's own reference. Fix that so we can change
> inode allocation over to using active references.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_ialloc.c | 43 +++++++++++++-------------------------
>  fs/xfs/libxfs/xfs_ialloc.h |  3 ++-
>  fs/xfs/scrub/common.c      | 13 ++++++++----
>  fs/xfs/xfs_icache.c        |  2 +-
>  4 files changed, 27 insertions(+), 34 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index e8068422aa21..2b4961ff2e24 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -2217,15 +2217,15 @@ xfs_difree(
>  
>  STATIC int
>  xfs_imap_lookup(
> -	struct xfs_mount	*mp,
> -	struct xfs_trans	*tp,
>  	struct xfs_perag	*pag,
> +	struct xfs_trans	*tp,
>  	xfs_agino_t		agino,
>  	xfs_agblock_t		agbno,
>  	xfs_agblock_t		*chunk_agbno,
>  	xfs_agblock_t		*offset_agbno,
>  	int			flags)
>  {
> +	struct xfs_mount	*mp = pag->pag_mount;
>  	struct xfs_inobt_rec_incore rec;
>  	struct xfs_btree_cur	*cur;
>  	struct xfs_buf		*agbp;
> @@ -2280,12 +2280,13 @@ xfs_imap_lookup(
>   */
>  int
>  xfs_imap(
> -	struct xfs_mount	 *mp,	/* file system mount structure */
> +	struct xfs_perag	*pag,
>  	struct xfs_trans	 *tp,	/* transaction pointer */

Stupid nit: fix the extra space ^ problem here.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  	xfs_ino_t		ino,	/* inode to locate */
>  	struct xfs_imap		*imap,	/* location map structure */
>  	uint			flags)	/* flags for inode btree lookup */
>  {
> +	struct xfs_mount	*mp = pag->pag_mount;
>  	xfs_agblock_t		agbno;	/* block number of inode in the alloc group */
>  	xfs_agino_t		agino;	/* inode number within alloc group */
>  	xfs_agblock_t		chunk_agbno;	/* first block in inode chunk */
> @@ -2293,17 +2294,15 @@ xfs_imap(
>  	int			error;	/* error code */
>  	int			offset;	/* index of inode in its buffer */
>  	xfs_agblock_t		offset_agbno;	/* blks from chunk start to inode */
> -	struct xfs_perag	*pag;
>  
>  	ASSERT(ino != NULLFSINO);
>  
>  	/*
>  	 * Split up the inode number into its parts.
>  	 */
> -	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ino));
>  	agino = XFS_INO_TO_AGINO(mp, ino);
>  	agbno = XFS_AGINO_TO_AGBNO(mp, agino);
> -	if (!pag || agbno >= mp->m_sb.sb_agblocks ||
> +	if (agbno >= mp->m_sb.sb_agblocks ||
>  	    ino != XFS_AGINO_TO_INO(mp, pag->pag_agno, agino)) {
>  		error = -EINVAL;
>  #ifdef DEBUG
> @@ -2312,20 +2311,14 @@ xfs_imap(
>  		 * as they can be invalid without implying corruption.
>  		 */
>  		if (flags & XFS_IGET_UNTRUSTED)
> -			goto out_drop;
> -		if (!pag) {
> -			xfs_alert(mp,
> -				"%s: agno (%d) >= mp->m_sb.sb_agcount (%d)",
> -				__func__, XFS_INO_TO_AGNO(mp, ino),
> -				mp->m_sb.sb_agcount);
> -		}
> +			return error;
>  		if (agbno >= mp->m_sb.sb_agblocks) {
>  			xfs_alert(mp,
>  		"%s: agbno (0x%llx) >= mp->m_sb.sb_agblocks (0x%lx)",
>  				__func__, (unsigned long long)agbno,
>  				(unsigned long)mp->m_sb.sb_agblocks);
>  		}
> -		if (pag && ino != XFS_AGINO_TO_INO(mp, pag->pag_agno, agino)) {
> +		if (ino != XFS_AGINO_TO_INO(mp, pag->pag_agno, agino)) {
>  			xfs_alert(mp,
>  		"%s: ino (0x%llx) != XFS_AGINO_TO_INO() (0x%llx)",
>  				__func__, ino,
> @@ -2333,7 +2326,7 @@ xfs_imap(
>  		}
>  		xfs_stack_trace();
>  #endif /* DEBUG */
> -		goto out_drop;
> +		return error;
>  	}
>  
>  	/*
> @@ -2344,10 +2337,10 @@ xfs_imap(
>  	 * in all cases where an untrusted inode number is passed.
>  	 */
>  	if (flags & XFS_IGET_UNTRUSTED) {
> -		error = xfs_imap_lookup(mp, tp, pag, agino, agbno,
> +		error = xfs_imap_lookup(pag, tp, agino, agbno,
>  					&chunk_agbno, &offset_agbno, flags);
>  		if (error)
> -			goto out_drop;
> +			return error;
>  		goto out_map;
>  	}
>  
> @@ -2363,8 +2356,7 @@ xfs_imap(
>  		imap->im_len = XFS_FSB_TO_BB(mp, 1);
>  		imap->im_boffset = (unsigned short)(offset <<
>  							mp->m_sb.sb_inodelog);
> -		error = 0;
> -		goto out_drop;
> +		return 0;
>  	}
>  
>  	/*
> @@ -2376,10 +2368,10 @@ xfs_imap(
>  		offset_agbno = agbno & M_IGEO(mp)->inoalign_mask;
>  		chunk_agbno = agbno - offset_agbno;
>  	} else {
> -		error = xfs_imap_lookup(mp, tp, pag, agino, agbno,
> +		error = xfs_imap_lookup(pag, tp, agino, agbno,
>  					&chunk_agbno, &offset_agbno, flags);
>  		if (error)
> -			goto out_drop;
> +			return error;
>  	}
>  
>  out_map:
> @@ -2407,14 +2399,9 @@ xfs_imap(
>  			__func__, (unsigned long long) imap->im_blkno,
>  			(unsigned long long) imap->im_len,
>  			XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks));
> -		error = -EINVAL;
> -		goto out_drop;
> +		return -EINVAL;
>  	}
> -	error = 0;
> -out_drop:
> -	if (pag)
> -		xfs_perag_put(pag);
> -	return error;
> +	return 0;
>  }
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
> index 9bbbca6ac4ed..4cfce2eebe7e 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.h
> +++ b/fs/xfs/libxfs/xfs_ialloc.h
> @@ -12,6 +12,7 @@ struct xfs_imap;
>  struct xfs_mount;
>  struct xfs_trans;
>  struct xfs_btree_cur;
> +struct xfs_perag;
>  
>  /* Move inodes in clusters of this size */
>  #define	XFS_INODE_BIG_CLUSTER_SIZE	8192
> @@ -47,7 +48,7 @@ int xfs_difree(struct xfs_trans *tp, struct xfs_perag *pag,
>   */
>  int
>  xfs_imap(
> -	struct xfs_mount *mp,		/* file system mount structure */
> +	struct xfs_perag *pag,
>  	struct xfs_trans *tp,		/* transaction pointer */
>  	xfs_ino_t	ino,		/* inode to locate */
>  	struct xfs_imap	*imap,		/* location map structure */
> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> index 613260b04a3d..033bf6730ece 100644
> --- a/fs/xfs/scrub/common.c
> +++ b/fs/xfs/scrub/common.c
> @@ -636,6 +636,7 @@ xchk_get_inode(
>  {
>  	struct xfs_imap		imap;
>  	struct xfs_mount	*mp = sc->mp;
> +	struct xfs_perag	*pag;
>  	struct xfs_inode	*ip_in = XFS_I(file_inode(sc->file));
>  	struct xfs_inode	*ip = NULL;
>  	int			error;
> @@ -671,10 +672,14 @@ xchk_get_inode(
>  		 * Otherwise, we really couldn't find it so tell userspace
>  		 * that it no longer exists.
>  		 */
> -		error = xfs_imap(sc->mp, sc->tp, sc->sm->sm_ino, &imap,
> -				XFS_IGET_UNTRUSTED | XFS_IGET_DONTCACHE);
> -		if (error)
> -			return -ENOENT;
> +		pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, sc->sm->sm_ino));
> +		if (pag) {
> +			error = xfs_imap(pag, sc->tp, sc->sm->sm_ino, &imap,
> +					XFS_IGET_UNTRUSTED | XFS_IGET_DONTCACHE);
> +			xfs_perag_put(pag);
> +			if (error)
> +				return -ENOENT;
> +		}
>  		error = -EFSCORRUPTED;
>  		fallthrough;
>  	default:
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 8b2823d85a68..c9a7e270a428 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -586,7 +586,7 @@ xfs_iget_cache_miss(
>  	if (!ip)
>  		return -ENOMEM;
>  
> -	error = xfs_imap(mp, tp, ip->i_ino, &ip->i_imap, flags);
> +	error = xfs_imap(pag, tp, ip->i_ino, &ip->i_imap, flags);
>  	if (error)
>  		goto out_destroy;
>  
> -- 
> 2.39.0
> 
