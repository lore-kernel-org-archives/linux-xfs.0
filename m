Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5D03C001DE
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Aug 2023 18:05:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbjHDSFW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Aug 2023 14:05:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbjHDSFW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Aug 2023 14:05:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE4D246A8
        for <linux-xfs@vger.kernel.org>; Fri,  4 Aug 2023 11:05:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 832CE620D7
        for <linux-xfs@vger.kernel.org>; Fri,  4 Aug 2023 18:05:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCD5FC433C7;
        Fri,  4 Aug 2023 18:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691172319;
        bh=Ds7vsRC+roZ8DePdM4T2PRPxn6Zervc/w6Ca9rahi7Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LY0QIzWIyXM8T4Rs/9TOKFcjdVXKlJn8+6QjSVmWYdgXgekj4AIU/K3n4o4vGcCnF
         GVh2TOsoehOKoNOqakeMofCIwjv6nsifiDuNXyhiyEijSucsMynrsRvVKtrzKjeeJ7
         HBaP0j7TW/bQdpcIZjcLmeXYTTYop6Zo602BcNNToKxSqDRXo3w0RjNdcm0jIDoji3
         S5IEKVuFUPxA1XUNVZs1Wkas0d1Np1dnXWJERXIfDb1SBsW+1fYN7i31fFZMWz6IQ5
         0BGj0to6DP89dBcdr7LY6AY59hCuYU+qlgEi69S0yrlA/GiingYH/wmXyxbiZS04tq
         hXcAbmcce+boA==
Date:   Fri, 4 Aug 2023 11:05:19 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        chandan.babu@oracle.com, leah.rumancik@gmail.com,
        Dave Chinner <dchinner@redhat.com>,
        Xiao Yang <yangx.jy@fujitsu.com>
Subject: Re: [PATCH CANDIDATE v6.1 1/5] xfs: hoist refcount record merge
 predicates
Message-ID: <20230804180519.GJ11352@frogsfrogsfrogs>
References: <20230804171223.1393045-1-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230804171223.1393045-1-tytso@mit.edu>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 04, 2023 at 01:12:19PM -0400, Theodore Ts'o wrote:
> From: "Darrick J. Wong" <djwong@kernel.org>
> 
> commit 9d720a5a658f5135861773f26e927449bef93d61 upstream.
> 
> Hoist these multiline conditionals into separate static inline helpers
> to improve readability and set the stage for corruption fixes that will
> be introduced in the next patch.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Xiao Yang <yangx.jy@fujitsu.com>

For the whole series,
Acked-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_refcount.c | 129 ++++++++++++++++++++++++++++++-----
>  1 file changed, 113 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> index 3f34bafe18dd..4408893333a6 100644
> --- a/fs/xfs/libxfs/xfs_refcount.c
> +++ b/fs/xfs/libxfs/xfs_refcount.c
> @@ -815,11 +815,119 @@ xfs_refcount_find_right_extents(
>  /* Is this extent valid? */
>  static inline bool
>  xfs_refc_valid(
> -	struct xfs_refcount_irec	*rc)
> +	const struct xfs_refcount_irec	*rc)
>  {
>  	return rc->rc_startblock != NULLAGBLOCK;
>  }
>  
> +static inline bool
> +xfs_refc_want_merge_center(
> +	const struct xfs_refcount_irec	*left,
> +	const struct xfs_refcount_irec	*cleft,
> +	const struct xfs_refcount_irec	*cright,
> +	const struct xfs_refcount_irec	*right,
> +	bool				cleft_is_cright,
> +	enum xfs_refc_adjust_op		adjust,
> +	unsigned long long		*ulenp)
> +{
> +	unsigned long long		ulen = left->rc_blockcount;
> +
> +	/*
> +	 * To merge with a center record, both shoulder records must be
> +	 * adjacent to the record we want to adjust.  This is only true if
> +	 * find_left and find_right made all four records valid.
> +	 */
> +	if (!xfs_refc_valid(left)  || !xfs_refc_valid(right) ||
> +	    !xfs_refc_valid(cleft) || !xfs_refc_valid(cright))
> +		return false;
> +
> +	/* There must only be one record for the entire range. */
> +	if (!cleft_is_cright)
> +		return false;
> +
> +	/* The shoulder record refcounts must match the new refcount. */
> +	if (left->rc_refcount != cleft->rc_refcount + adjust)
> +		return false;
> +	if (right->rc_refcount != cleft->rc_refcount + adjust)
> +		return false;
> +
> +	/*
> +	 * The new record cannot exceed the max length.  ulen is a ULL as the
> +	 * individual record block counts can be up to (u32 - 1) in length
> +	 * hence we need to catch u32 addition overflows here.
> +	 */
> +	ulen += cleft->rc_blockcount + right->rc_blockcount;
> +	if (ulen >= MAXREFCEXTLEN)
> +		return false;
> +
> +	*ulenp = ulen;
> +	return true;
> +}
> +
> +static inline bool
> +xfs_refc_want_merge_left(
> +	const struct xfs_refcount_irec	*left,
> +	const struct xfs_refcount_irec	*cleft,
> +	enum xfs_refc_adjust_op		adjust)
> +{
> +	unsigned long long		ulen = left->rc_blockcount;
> +
> +	/*
> +	 * For a left merge, the left shoulder record must be adjacent to the
> +	 * start of the range.  If this is true, find_left made left and cleft
> +	 * contain valid contents.
> +	 */
> +	if (!xfs_refc_valid(left) || !xfs_refc_valid(cleft))
> +		return false;
> +
> +	/* Left shoulder record refcount must match the new refcount. */
> +	if (left->rc_refcount != cleft->rc_refcount + adjust)
> +		return false;
> +
> +	/*
> +	 * The new record cannot exceed the max length.  ulen is a ULL as the
> +	 * individual record block counts can be up to (u32 - 1) in length
> +	 * hence we need to catch u32 addition overflows here.
> +	 */
> +	ulen += cleft->rc_blockcount;
> +	if (ulen >= MAXREFCEXTLEN)
> +		return false;
> +
> +	return true;
> +}
> +
> +static inline bool
> +xfs_refc_want_merge_right(
> +	const struct xfs_refcount_irec	*cright,
> +	const struct xfs_refcount_irec	*right,
> +	enum xfs_refc_adjust_op		adjust)
> +{
> +	unsigned long long		ulen = right->rc_blockcount;
> +
> +	/*
> +	 * For a right merge, the right shoulder record must be adjacent to the
> +	 * end of the range.  If this is true, find_right made cright and right
> +	 * contain valid contents.
> +	 */
> +	if (!xfs_refc_valid(right) || !xfs_refc_valid(cright))
> +		return false;
> +
> +	/* Right shoulder record refcount must match the new refcount. */
> +	if (right->rc_refcount != cright->rc_refcount + adjust)
> +		return false;
> +
> +	/*
> +	 * The new record cannot exceed the max length.  ulen is a ULL as the
> +	 * individual record block counts can be up to (u32 - 1) in length
> +	 * hence we need to catch u32 addition overflows here.
> +	 */
> +	ulen += cright->rc_blockcount;
> +	if (ulen >= MAXREFCEXTLEN)
> +		return false;
> +
> +	return true;
> +}
> +
>  /*
>   * Try to merge with any extents on the boundaries of the adjustment range.
>   */
> @@ -861,23 +969,15 @@ xfs_refcount_merge_extents(
>  		 (cleft.rc_blockcount == cright.rc_blockcount);
>  
>  	/* Try to merge left, cleft, and right.  cleft must == cright. */
> -	ulen = (unsigned long long)left.rc_blockcount + cleft.rc_blockcount +
> -			right.rc_blockcount;
> -	if (xfs_refc_valid(&left) && xfs_refc_valid(&right) &&
> -	    xfs_refc_valid(&cleft) && xfs_refc_valid(&cright) && cequal &&
> -	    left.rc_refcount == cleft.rc_refcount + adjust &&
> -	    right.rc_refcount == cleft.rc_refcount + adjust &&
> -	    ulen < MAXREFCEXTLEN) {
> +	if (xfs_refc_want_merge_center(&left, &cleft, &cright, &right, cequal,
> +				adjust, &ulen)) {
>  		*shape_changed = true;
>  		return xfs_refcount_merge_center_extents(cur, &left, &cleft,
>  				&right, ulen, aglen);
>  	}
>  
>  	/* Try to merge left and cleft. */
> -	ulen = (unsigned long long)left.rc_blockcount + cleft.rc_blockcount;
> -	if (xfs_refc_valid(&left) && xfs_refc_valid(&cleft) &&
> -	    left.rc_refcount == cleft.rc_refcount + adjust &&
> -	    ulen < MAXREFCEXTLEN) {
> +	if (xfs_refc_want_merge_left(&left, &cleft, adjust)) {
>  		*shape_changed = true;
>  		error = xfs_refcount_merge_left_extent(cur, &left, &cleft,
>  				agbno, aglen);
> @@ -893,10 +993,7 @@ xfs_refcount_merge_extents(
>  	}
>  
>  	/* Try to merge cright and right. */
> -	ulen = (unsigned long long)right.rc_blockcount + cright.rc_blockcount;
> -	if (xfs_refc_valid(&right) && xfs_refc_valid(&cright) &&
> -	    right.rc_refcount == cright.rc_refcount + adjust &&
> -	    ulen < MAXREFCEXTLEN) {
> +	if (xfs_refc_want_merge_right(&cright, &right, adjust)) {
>  		*shape_changed = true;
>  		return xfs_refcount_merge_right_extent(cur, &right, &cright,
>  				aglen);
> -- 
> 2.31.0
> 
