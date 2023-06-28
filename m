Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EBACEB64DA
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jun 2023 17:52:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231996AbjF1Rw3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jun 2023 13:52:29 -0400
Received: from dfw.source.kernel.org ([139.178.84.217]:33644 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231855AbjF1RwM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Jun 2023 13:52:12 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A51761425
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jun 2023 17:52:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA023C433C9;
        Wed, 28 Jun 2023 17:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687974731;
        bh=LpBupyGpHNL7RcxRupu8GNR8iy4nP5WOIizBqQ9PKwQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VBbFp/ZaoGa8DWUASj9coMFJVPGyRz/kRMhxmdRGiwLxZp974W4c+jXnDX47FFfYD
         yxspVaj/VhlTI0moauEIb8vvLqAb6D9f2czReXA4SjY2a59FewWQQ69a4HjAMst/n7
         E/whzpewrT3qej0Xy6nYz+nERx5WMgE91Zp3AFfFjDXxDHxsrgZkvzcrIsT06HkMUM
         7h/UNfS2mgez8LWUx2hiyJE/xTR37C9GXRglJZZb6Z2G1xupKdlB0yJKhcVU0VZufj
         FW3+gIg/Lo5A2uam+52saHA6nBa4ly3VJaPaFS1DPiEGS1i2Pq9VBeOCJVkWwNvphi
         npoPD2GaNAbEw==
Date:   Wed, 28 Jun 2023 10:52:11 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/8] xfs: AGF length has never been bounds checked
Message-ID: <20230628175211.GX11441@frogsfrogsfrogs>
References: <20230627224412.2242198-1-david@fromorbit.com>
 <20230627224412.2242198-8-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230627224412.2242198-8-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 28, 2023 at 08:44:11AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The AGF verifier does not check that the AGF length field is within
> known good bounds. This has never been checked by runtime kernel
> code (i.e. the lack of verification goes back to 1993) yet we assume
> in many places that it is correct and verify other metdata against
> it.
> 
> Add length verification to the AGF verifier. The length of the AGF
> must be equal to the size of the AG specified in the superblock,
> unless it is the last AG in the filesystem. In that case, it must be
> less than or equal to sb->sb_agblocks and greater than
> XFS_MIN_AG_BLOCKS, which is the smallest AG a growfs operation will
> allow to exist.
> 
> This requires a bit of rework of the verifier function. We want to
> verify metadata before we use it to verify other metadata. Hence
> we need to verify the AGF sequence numbers before using them to
> verify the length of the AGF. Then we can verify the AGF length
> before we verify AGFL fields. Then we can verifier other fields that
> are bounds limited by the AGF length.
> 
> And, finally, by calculating agf_length only once into a local
> variable, we can collapse repeated "if (xfs_has_foo() &&"
> conditionaly checks into single checks. This makes the code much
> easier to follow as all the checks for a given feature are obviously
> in the same place.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

LGTM
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_alloc.c | 86 +++++++++++++++++++++++----------------
>  1 file changed, 51 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 1e72b91daff6..7c86a69354fb 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2974,6 +2974,7 @@ xfs_agf_verify(
>  {
>  	struct xfs_mount	*mp = bp->b_mount;
>  	struct xfs_agf		*agf = bp->b_addr;
> +	uint32_t		agf_length = be32_to_cpu(agf->agf_length);
>  
>  	if (xfs_has_crc(mp)) {
>  		if (!uuid_equal(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid))
> @@ -2985,18 +2986,43 @@ xfs_agf_verify(
>  	if (!xfs_verify_magic(bp, agf->agf_magicnum))
>  		return __this_address;
>  
> -	if (!(XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum)) &&
> -	      be32_to_cpu(agf->agf_freeblks) <= be32_to_cpu(agf->agf_length) &&
> -	      be32_to_cpu(agf->agf_flfirst) < xfs_agfl_size(mp) &&
> -	      be32_to_cpu(agf->agf_fllast) < xfs_agfl_size(mp) &&
> -	      be32_to_cpu(agf->agf_flcount) <= xfs_agfl_size(mp)))
> +	if (!XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum)))
>  		return __this_address;
>  
> -	if (be32_to_cpu(agf->agf_length) > mp->m_sb.sb_dblocks)
> +	/*
> +	 * Both agf_seqno and agf_length need to validated before anything else
> +	 * block number related in the AGF or AGFL can be checked.
> +	 *
> +	 * During growfs operations, the perag is not fully initialised,
> +	 * so we can't use it for any useful checking. growfs ensures we can't
> +	 * use it by using uncached buffers that don't have the perag attached
> +	 * so we can detect and avoid this problem.
> +	 */
> +	if (bp->b_pag && be32_to_cpu(agf->agf_seqno) != bp->b_pag->pag_agno)
> +		return __this_address;
> +
> +	/*
> +	 * Only the last AGF in the filesytsem is allowed to be shorter
> +	 * than the AG size recorded in the superblock.
> +	 */
> +	if (agf_length != mp->m_sb.sb_agblocks) {
> +		if (be32_to_cpu(agf->agf_seqno) != mp->m_sb.sb_agcount - 1)
> +			return __this_address;
> +		if (agf_length < XFS_MIN_AG_BLOCKS)
> +			return __this_address;
> +		if (agf_length > mp->m_sb.sb_agblocks)
> +			return __this_address;
> +	}
> +
> +	if (be32_to_cpu(agf->agf_flfirst) >= xfs_agfl_size(mp))
> +		return __this_address;
> +	if (be32_to_cpu(agf->agf_fllast) >= xfs_agfl_size(mp))
> +		return __this_address;
> +	if (be32_to_cpu(agf->agf_flcount) > xfs_agfl_size(mp))
>  		return __this_address;
>  
>  	if (be32_to_cpu(agf->agf_freeblks) < be32_to_cpu(agf->agf_longest) ||
> -	    be32_to_cpu(agf->agf_freeblks) > be32_to_cpu(agf->agf_length))
> +	    be32_to_cpu(agf->agf_freeblks) > agf_length)
>  		return __this_address;
>  
>  	if (be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) < 1 ||
> @@ -3007,38 +3033,28 @@ xfs_agf_verify(
>  						mp->m_alloc_maxlevels)
>  		return __this_address;
>  
> -	if (xfs_has_rmapbt(mp) &&
> -	    (be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]) < 1 ||
> -	     be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]) >
> -						mp->m_rmap_maxlevels))
> -		return __this_address;
> -
> -	if (xfs_has_rmapbt(mp) &&
> -	    be32_to_cpu(agf->agf_rmap_blocks) > be32_to_cpu(agf->agf_length))
> -		return __this_address;
> -
> -	/*
> -	 * during growfs operations, the perag is not fully initialised,
> -	 * so we can't use it for any useful checking. growfs ensures we can't
> -	 * use it by using uncached buffers that don't have the perag attached
> -	 * so we can detect and avoid this problem.
> -	 */
> -	if (bp->b_pag && be32_to_cpu(agf->agf_seqno) != bp->b_pag->pag_agno)
> -		return __this_address;
> -
>  	if (xfs_has_lazysbcount(mp) &&
> -	    be32_to_cpu(agf->agf_btreeblks) > be32_to_cpu(agf->agf_length))
> +	    be32_to_cpu(agf->agf_btreeblks) > agf_length)
>  		return __this_address;
>  
> -	if (xfs_has_reflink(mp) &&
> -	    be32_to_cpu(agf->agf_refcount_blocks) >
> -	    be32_to_cpu(agf->agf_length))
> -		return __this_address;
> +	if (xfs_has_rmapbt(mp)) {
> +		if (be32_to_cpu(agf->agf_rmap_blocks) > agf_length)
> +			return __this_address;
>  
> -	if (xfs_has_reflink(mp) &&
> -	    (be32_to_cpu(agf->agf_refcount_level) < 1 ||
> -	     be32_to_cpu(agf->agf_refcount_level) > mp->m_refc_maxlevels))
> -		return __this_address;
> +		if (be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]) < 1 ||
> +		    be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]) >
> +							mp->m_rmap_maxlevels)
> +			return __this_address;
> +	}
> +
> +	if (xfs_has_reflink(mp)) {
> +		if (be32_to_cpu(agf->agf_refcount_blocks) > agf_length)
> +			return __this_address;
> +
> +		if (be32_to_cpu(agf->agf_refcount_level) < 1 ||
> +		    be32_to_cpu(agf->agf_refcount_level) > mp->m_refc_maxlevels)
> +			return __this_address;
> +	}
>  
>  	return NULL;
>  }
> -- 
> 2.40.1
> 
