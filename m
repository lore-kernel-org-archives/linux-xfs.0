Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22088C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 10 May 2022 22:58:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233372AbiEJW62 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 18:58:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231931AbiEJW61 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 18:58:27 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB8F5F8C2
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 15:58:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 40D9BCE2179
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 22:58:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 965FBC385CE;
        Tue, 10 May 2022 22:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652223502;
        bh=eJJGQUpzm5atGrpJKPfLWm8Ejb4Io1eo1AOr1w93ytE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A6DrvkfWxNcotPSJb2Cw9366B+o3nDayww/Jv8QWCCaIHf8mA/YsgrPMRFqwRuRgl
         tHu5KWzw4y6Nkj/yM4+vKO4CDq5fV+6JQiV8D9skKac2RWYl5My3OFRnod7ZHhH2pZ
         nehChQeB+68BvUVdpMjTXeIG7QIa/+cyHY2NK5dW0ahgsFOQSUt9sPiirZSx5VECTf
         P/B0Z3fNzr0r0rqnmCMlYfNsnxE0zVAT3S/h8rnsxZSo1bd8frHZfh4d913uw/Wyxb
         wSFwWYMKp4SzlsthDBkjIePE81cgxIymMF/IixDi/5gb04c8sCX8HBJVBHTKMI6gyH
         ByPkLhJOSurVw==
Date:   Tue, 10 May 2022 15:58:22 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/18] xfs: make xattri_leaf_bp more useful
Message-ID: <20220510225822.GG27195@magnolia>
References: <20220509004138.762556-1-david@fromorbit.com>
 <20220509004138.762556-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509004138.762556-4-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 09, 2022 at 10:41:23AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We currently set it and hold it when converting from short to leaf
> form, then release it only to immediately look it back up again
> to do the leaf insert.
> 
> Do a bit of refactoring to xfs_attr_leaf_try_add() to avoid this
> messy handling of the newly allocated leaf buffer.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Allison Henderson<allison.henderson@oracle.com>

Took me a while to figure this out, but looks fine to me.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c | 50 +++++++++++++++++++++++++---------------
>  1 file changed, 32 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index b3d918195160..a4b0b20a3bab 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -319,7 +319,15 @@ xfs_attr_leaf_addname(
>  	int			error;
>  
>  	if (xfs_attr_is_leaf(dp)) {
> +
> +		/*
> +		 * Use the leaf buffer we may already hold locked as a result of
> +		 * a sf-to-leaf conversion. The held buffer is no longer valid
> +		 * after this call, regardless of the result.
> +		 */
>  		error = xfs_attr_leaf_try_add(args, attr->xattri_leaf_bp);
> +		attr->xattri_leaf_bp = NULL;
> +
>  		if (error == -ENOSPC) {
>  			error = xfs_attr3_leaf_to_node(args);
>  			if (error)
> @@ -341,6 +349,8 @@ xfs_attr_leaf_addname(
>  		}
>  		next_state = XFS_DAS_FOUND_LBLK;
>  	} else {
> +		ASSERT(!attr->xattri_leaf_bp);
> +
>  		error = xfs_attr_node_addname_find_attr(attr);
>  		if (error)
>  			return error;
> @@ -396,12 +406,6 @@ xfs_attr_set_iter(
>  		 */
>  		if (xfs_attr_is_shortform(dp))
>  			return xfs_attr_sf_addname(attr);
> -		if (attr->xattri_leaf_bp != NULL) {
> -			xfs_trans_bhold_release(args->trans,
> -						attr->xattri_leaf_bp);
> -			attr->xattri_leaf_bp = NULL;
> -		}
> -
>  		return xfs_attr_leaf_addname(attr);
>  
>  	case XFS_DAS_FOUND_LBLK:
> @@ -992,18 +996,31 @@ xfs_attr_leaf_try_add(
>  	struct xfs_da_args	*args,
>  	struct xfs_buf		*bp)
>  {
> -	int			retval;
> +	int			error;
>  
>  	/*
> -	 * Look up the given attribute in the leaf block.  Figure out if
> -	 * the given flags produce an error or call for an atomic rename.
> +	 * If the caller provided a buffer to us, it is locked and held in
> +	 * the transaction because it just did a shortform to leaf conversion.
> +	 * Hence we don't need to read it again. Otherwise read in the leaf
> +	 * buffer.
>  	 */
> -	retval = xfs_attr_leaf_hasname(args, &bp);
> -	if (retval != -ENOATTR && retval != -EEXIST)
> -		return retval;
> -	if (retval == -ENOATTR && (args->attr_flags & XATTR_REPLACE))
> +	if (bp) {
> +		xfs_trans_bhold_release(args->trans, bp);
> +	} else {
> +		error = xfs_attr3_leaf_read(args->trans, args->dp, 0, &bp);
> +		if (error)
> +			return error;
> +	}
> +
> +	/*
> +	 * Look up the xattr name to set the insertion point for the new xattr.
> +	 */
> +	error = xfs_attr3_leaf_lookup_int(bp, args);
> +	if (error != -ENOATTR && error != -EEXIST)
>  		goto out_brelse;
> -	if (retval == -EEXIST) {
> +	if (error == -ENOATTR && (args->attr_flags & XATTR_REPLACE))
> +		goto out_brelse;
> +	if (error == -EEXIST) {
>  		if (args->attr_flags & XATTR_CREATE)
>  			goto out_brelse;
>  
> @@ -1023,14 +1040,11 @@ xfs_attr_leaf_try_add(
>  		args->rmtvaluelen = 0;
>  	}
>  
> -	/*
> -	 * Add the attribute to the leaf block
> -	 */
>  	return xfs_attr3_leaf_add(bp, args);
>  
>  out_brelse:
>  	xfs_trans_brelse(args->trans, bp);
> -	return retval;
> +	return error;
>  }
>  
>  /*
> -- 
> 2.35.1
> 
