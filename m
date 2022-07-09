Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47B24C43334
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Jul 2022 22:58:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbiGIW6t (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 Jul 2022 18:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiGIW6t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Jul 2022 18:58:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78D36BC16
        for <linux-xfs@vger.kernel.org>; Sat,  9 Jul 2022 15:58:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39D02B80159
        for <linux-xfs@vger.kernel.org>; Sat,  9 Jul 2022 22:58:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE260C3411C;
        Sat,  9 Jul 2022 22:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657407524;
        bh=8Rdnc7kOg7unxZxxaG5D0AjVs+5Qe4rVJZSzLRlPxWw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A9tQo60UHZMDBnzlOqrZ5SN2UQYQ9I+fwtih7G08BZY8IReptv+FBk2zl66REsKIb
         4avUyQiS3m7awvtYnnh9SNy4owzrh5lkxG/kQprlfQBkryYNuFETgYniWyVAnU98M3
         +NF93wTNNgPNLS0zu4iP9mA/rn3BqXtPN6sR8rDHRpeJ7qcLugAG7j2UV90gkN9KtA
         gCmdZ6oUy4cslTtC2OquPrCxARyUSXv889kxJ2w7OR/8Bw0a/hv+KziLbcduZHWRCC
         OOnEs9HohTs7QjqNVV/Oq061VWII57e9f5Xm2V2qIRgMQbg4GaxmjNXU0gJHs/SVDn
         MylvoZJWsCPgg==
Date:   Sat, 9 Jul 2022 15:58:44 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: break up xfs_buf_find() into individual pieces
Message-ID: <YsoIJGSjS2VIVOiw@magnolia>
References: <20220707235259.1097443-1-david@fromorbit.com>
 <20220707235259.1097443-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220707235259.1097443-3-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 08, 2022 at 09:52:55AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_buf_find() is made up of three main parts: lookup, insert and
> locking. The interactions with xfs_buf_get_map() require it to be
> called twice - once for a pure lookup, and again on lookup failure
> so the insert path can be run. We want to simplify this down a lot,
> so split it into a fast path lookup, a slow path insert and a "lock
> the found buffer" helper. This will then let us integrate these
> operations more effectively into xfs_buf_get_map() in future
> patches.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Much improved, thank you.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c | 159 +++++++++++++++++++++++++++++++----------------
>  1 file changed, 105 insertions(+), 54 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 143e1c70df5d..91dc691f40a8 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -503,6 +503,99 @@ xfs_buf_hash_destroy(
>  	rhashtable_destroy(&pag->pag_buf_hash);
>  }
>  
> +static int
> +xfs_buf_map_verify(
> +	struct xfs_buftarg	*btp,
> +	struct xfs_buf_map	*map)
> +{
> +	xfs_daddr_t		eofs;
> +
> +	/* Check for IOs smaller than the sector size / not sector aligned */
> +	ASSERT(!(BBTOB(map->bm_len) < btp->bt_meta_sectorsize));
> +	ASSERT(!(BBTOB(map->bm_bn) & (xfs_off_t)btp->bt_meta_sectormask));
> +
> +	/*
> +	 * Corrupted block numbers can get through to here, unfortunately, so we
> +	 * have to check that the buffer falls within the filesystem bounds.
> +	 */
> +	eofs = XFS_FSB_TO_BB(btp->bt_mount, btp->bt_mount->m_sb.sb_dblocks);
> +	if (map->bm_bn < 0 || map->bm_bn >= eofs) {
> +		xfs_alert(btp->bt_mount,
> +			  "%s: daddr 0x%llx out of range, EOFS 0x%llx",
> +			  __func__, map->bm_bn, eofs);
> +		WARN_ON(1);
> +		return -EFSCORRUPTED;
> +	}
> +	return 0;
> +}
> +
> +static int
> +xfs_buf_find_lock(
> +	struct xfs_buftarg	*btp,
> +	struct xfs_buf          *bp,
> +	xfs_buf_flags_t		flags)
> +{
> +	if (!xfs_buf_trylock(bp)) {
> +		if (flags & XBF_TRYLOCK) {
> +			xfs_buf_rele(bp);
> +			XFS_STATS_INC(btp->bt_mount, xb_busy_locked);
> +			return -EAGAIN;
> +		}
> +		xfs_buf_lock(bp);
> +		XFS_STATS_INC(btp->bt_mount, xb_get_locked_waited);
> +	}
> +
> +	/*
> +	 * if the buffer is stale, clear all the external state associated with
> +	 * it. We need to keep flags such as how we allocated the buffer memory
> +	 * intact here.
> +	 */
> +	if (bp->b_flags & XBF_STALE) {
> +		ASSERT((bp->b_flags & _XBF_DELWRI_Q) == 0);
> +		bp->b_flags &= _XBF_KMEM | _XBF_PAGES;
> +		bp->b_ops = NULL;
> +	}
> +	return 0;
> +}
> +
> +static inline struct xfs_buf *
> +xfs_buf_lookup(
> +	struct xfs_perag	*pag,
> +	struct xfs_buf_map	*map)
> +{
> +	struct xfs_buf          *bp;
> +
> +	bp = rhashtable_lookup(&pag->pag_buf_hash, map, xfs_buf_hash_params);
> +	if (!bp)
> +		return NULL;
> +	atomic_inc(&bp->b_hold);
> +	return bp;
> +}
> +
> +/*
> + * Insert the new_bp into the hash table. This consumes the perag reference
> + * taken for the lookup.
> + */
> +static int
> +xfs_buf_find_insert(
> +	struct xfs_buftarg	*btp,
> +	struct xfs_perag	*pag,
> +	struct xfs_buf		*new_bp)
> +{
> +	/* No match found */
> +	if (!new_bp) {
> +		xfs_perag_put(pag);
> +		XFS_STATS_INC(btp->bt_mount, xb_miss_locked);
> +		return -ENOENT;
> +	}
> +
> +	/* the buffer keeps the perag reference until it is freed */
> +	new_bp->b_pag = pag;
> +	rhashtable_insert_fast(&pag->pag_buf_hash, &new_bp->b_rhash_head,
> +			       xfs_buf_hash_params);
> +	return 0;
> +}
> +
>  /*
>   * Look up a buffer in the buffer cache and return it referenced and locked
>   * in @found_bp.
> @@ -533,7 +626,7 @@ xfs_buf_find(
>  	struct xfs_perag	*pag;
>  	struct xfs_buf		*bp;
>  	struct xfs_buf_map	cmap = { .bm_bn = map[0].bm_bn };
> -	xfs_daddr_t		eofs;
> +	int			error;
>  	int			i;
>  
>  	*found_bp = NULL;
> @@ -541,47 +634,22 @@ xfs_buf_find(
>  	for (i = 0; i < nmaps; i++)
>  		cmap.bm_len += map[i].bm_len;
>  
> -	/* Check for IOs smaller than the sector size / not sector aligned */
> -	ASSERT(!(BBTOB(cmap.bm_len) < btp->bt_meta_sectorsize));
> -	ASSERT(!(BBTOB(cmap.bm_bn) & (xfs_off_t)btp->bt_meta_sectormask));
> -
> -	/*
> -	 * Corrupted block numbers can get through to here, unfortunately, so we
> -	 * have to check that the buffer falls within the filesystem bounds.
> -	 */
> -	eofs = XFS_FSB_TO_BB(btp->bt_mount, btp->bt_mount->m_sb.sb_dblocks);
> -	if (cmap.bm_bn < 0 || cmap.bm_bn >= eofs) {
> -		xfs_alert(btp->bt_mount,
> -			  "%s: daddr 0x%llx out of range, EOFS 0x%llx",
> -			  __func__, cmap.bm_bn, eofs);
> -		WARN_ON(1);
> -		return -EFSCORRUPTED;
> -	}
> +	error = xfs_buf_map_verify(btp, &cmap);
> +	if (error)
> +		return error;
>  
>  	pag = xfs_perag_get(btp->bt_mount,
>  			    xfs_daddr_to_agno(btp->bt_mount, cmap.bm_bn));
>  
>  	spin_lock(&pag->pag_buf_lock);
> -	bp = rhashtable_lookup_fast(&pag->pag_buf_hash, &cmap,
> -				    xfs_buf_hash_params);
> -	if (bp) {
> -		atomic_inc(&bp->b_hold);
> +	bp = xfs_buf_lookup(pag, &cmap);
> +	if (bp)
>  		goto found;
> -	}
> -
> -	/* No match found */
> -	if (!new_bp) {
> -		XFS_STATS_INC(btp->bt_mount, xb_miss_locked);
> -		spin_unlock(&pag->pag_buf_lock);
> -		xfs_perag_put(pag);
> -		return -ENOENT;
> -	}
>  
> -	/* the buffer keeps the perag reference until it is freed */
> -	new_bp->b_pag = pag;
> -	rhashtable_insert_fast(&pag->pag_buf_hash, &new_bp->b_rhash_head,
> -			       xfs_buf_hash_params);
> +	error = xfs_buf_find_insert(btp, pag, new_bp);
>  	spin_unlock(&pag->pag_buf_lock);
> +	if (error)
> +		return error;
>  	*found_bp = new_bp;
>  	return 0;
>  
> @@ -589,26 +657,9 @@ xfs_buf_find(
>  	spin_unlock(&pag->pag_buf_lock);
>  	xfs_perag_put(pag);
>  
> -	if (!xfs_buf_trylock(bp)) {
> -		if (flags & XBF_TRYLOCK) {
> -			xfs_buf_rele(bp);
> -			XFS_STATS_INC(btp->bt_mount, xb_busy_locked);
> -			return -EAGAIN;
> -		}
> -		xfs_buf_lock(bp);
> -		XFS_STATS_INC(btp->bt_mount, xb_get_locked_waited);
> -	}
> -
> -	/*
> -	 * if the buffer is stale, clear all the external state associated with
> -	 * it. We need to keep flags such as how we allocated the buffer memory
> -	 * intact here.
> -	 */
> -	if (bp->b_flags & XBF_STALE) {
> -		ASSERT((bp->b_flags & _XBF_DELWRI_Q) == 0);
> -		bp->b_flags &= _XBF_KMEM | _XBF_PAGES;
> -		bp->b_ops = NULL;
> -	}
> +	error = xfs_buf_find_lock(btp, bp, flags);
> +	if (error)
> +		return error;
>  
>  	trace_xfs_buf_find(bp, flags, _RET_IP_);
>  	XFS_STATS_INC(btp->bt_mount, xb_get_locked);
> -- 
> 2.36.1
> 
