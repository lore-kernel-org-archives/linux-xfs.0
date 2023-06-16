Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96BF9EB64D7
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Jun 2023 04:19:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241743AbjFPETH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Jun 2023 00:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240221AbjFPETE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Jun 2023 00:19:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3231E2118
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jun 2023 21:19:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F421619B0
        for <linux-xfs@vger.kernel.org>; Fri, 16 Jun 2023 04:19:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7B30C433C8;
        Fri, 16 Jun 2023 04:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686889141;
        bh=5uWGlZgIAiaBsNENqfMN5gJ2ITlLwCqHLalRgLzcRug=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u9ZqM7zwlIL13BSoMaEbM669LtnKAKBio4uLiQ9gyZTcxOv5B5VgXp/dmDpspv/P4
         ojDcTME0WOZFQfPnB/cFaG14RuAyVii74V9U+OUpmXvgQhlADe+Sv+U+nTAKrPaOmL
         Cx+F7sH+5g/G7PsU5afaDIhN0L9CCIIO0OGYqVp5bFJ6Kx0DaVyoTeqVpKk2EtbrDj
         zl4TO4Wd8T0PHhnOWz0jKrzUzMJf5rq67m0TtXLlliPA7AtOWRHD13dTpJJs31aELB
         AbOap9o/BX2MMweDe3/hFsiPuZYyfpdOOMC33GN63zdfBaj0GHmANjGkrCq/reoAe5
         jNmXvDV0nMaDA==
Date:   Thu, 15 Jun 2023 21:19:01 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: AGF length has never been bounds checked
Message-ID: <20230616041901.GR11441@frogsfrogsfrogs>
References: <20230616015906.3813726-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230616015906.3813726-1-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 16, 2023 at 11:59:06AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The AGF verifier does not check that the AGF length field is within
> known good bounds. This has never been checked by runtime kernel
> code (i.e. the lack of verification goes back to 1993) yet we assume

Woo hoo!

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
> ---
>  fs/xfs/libxfs/xfs_alloc.c | 81 ++++++++++++++++++++++-----------------
>  1 file changed, 46 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 7c675aae0a0f..78556cad57e5 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2970,6 +2970,7 @@ xfs_agf_verify(
>  {
>  	struct xfs_mount	*mp = bp->b_mount;
>  	struct xfs_agf		*agf = bp->b_addr;
> +	uint32_t		agf_length = be32_to_cpu(agf->agf_length);
>  
>  	if (xfs_has_crc(mp)) {
>  		if (!uuid_equal(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid))
> @@ -2981,18 +2982,38 @@ xfs_agf_verify(
>  	if (!xfs_verify_magic(bp, agf->agf_magicnum))
>  		return __this_address;
>  
> -	if (!(XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum)) &&
> -	      be32_to_cpu(agf->agf_freeblks) <= be32_to_cpu(agf->agf_length) &&
> -	      be32_to_cpu(agf->agf_flfirst) < xfs_agfl_size(mp) &&
> -	      be32_to_cpu(agf->agf_fllast) < xfs_agfl_size(mp) &&
> -	      be32_to_cpu(agf->agf_flcount) <= xfs_agfl_size(mp)))
> +	if (!(XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum))))
>  		return __this_address;
>  
> -	if (be32_to_cpu(agf->agf_length) > mp->m_sb.sb_dblocks)
> +	/*
> +	 * during growfs operations, the perag is not fully initialised,
> +	 * so we can't use it for any useful checking. growfs ensures we can't
> +	 * use it by using uncached buffers that don't have the perag attached
> +	 * so we can detect and avoid this problem.

Would you mind adding an extra sentence here:

"Both agf_seqno and agf_length need to be validated before anything else
fsblock related in the AGF."

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

The superblock verifier checks that sb_agblocks >= XFS_MIN_AG_BYTES,
which means that it can't be less than 16MB.  That's the lower bound on
the general AG size, not the lower bound of a runt AG at the end of the
fs.

OTOH, the lower bound of a runt AG is XFS_MIN_AG_BLOCKS, or 64FSB.  I
would sorta like this to be outside this sub-block since that's
independent of whatever sb_agblocks is.

That said, there is no filesystem where setting sb_agblocks to 16MB
would result in an sb_agblocks with a value less than 256, so I suppose
this is a moot worry of mine.

Does that make sense?

> +			return __this_address;
> +		if (agf_length > mp->m_sb.sb_agblocks)
> +			return __this_address;
> +	}
> +
> +	if (be32_to_cpu(agf->agf_flfirst) >= xfs_agfl_size(mp) ||
> +	    be32_to_cpu(agf->agf_fllast) >= xfs_agfl_size(mp) ||
> +	    be32_to_cpu(agf->agf_flcount) > xfs_agfl_size(mp))
>  		return __this_address;

I wish each check would get its own return __this_address.  Today I was
debugging some dumb bug but addr2line dropped me off in the middle of
this mound of code. :(

Oh well, not required to land /this/ patch.  Everything else in this
patch looks good.

--D

>  
>  	if (be32_to_cpu(agf->agf_freeblks) < be32_to_cpu(agf->agf_longest) ||
> -	    be32_to_cpu(agf->agf_freeblks) > be32_to_cpu(agf->agf_length))
> +	    be32_to_cpu(agf->agf_freeblks) > agf_length)
>  		return __this_address;
>  
>  	if (be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) < 1 ||
> @@ -3003,38 +3024,28 @@ xfs_agf_verify(
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
