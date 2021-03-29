Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8FAFC433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 09:22:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70AB261938
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 09:22:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231620AbhC2JVs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Mar 2021 05:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbhC2JVW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Mar 2021 05:21:22 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E960C061574
        for <linux-xfs@vger.kernel.org>; Mon, 29 Mar 2021 02:21:22 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id kk2-20020a17090b4a02b02900c777aa746fso5617927pjb.3
        for <linux-xfs@vger.kernel.org>; Mon, 29 Mar 2021 02:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=d80hTVNpjdxdx9kNFt6HONssYEaNhEDcS7F3KtotiGE=;
        b=YaulkOKGSgvHalq7/nZFGl1xE0NwKNESaOsopaIH4YYde6n0qjumM0rmcVV0Gjwkdy
         GdDi02CcouKCQa+/DPHigIFCgfPygMY6bEGkCM3yAlwdXBfRO7fm413fh13eNDQ2TUOu
         gQtcsZ56Twlf/GBtmniXNLWMvgw85UcRKj7WTB4atWvaoDHsfyW5XhqKdx4mtW9CAjWF
         LPIl9z4ueX7O9BE0nMn1Cg8X5TdEfDiADhkgqeLerIdn3dVFv3Z6Zy5fbt6dpn7S5xei
         gvKzQq5CjHq7k9ckZ4+GFNuwsVFVsYtJ7CHLoaZ6s4IB0NBM7Y1zBaseWoyqxLl2xJOQ
         6w5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=d80hTVNpjdxdx9kNFt6HONssYEaNhEDcS7F3KtotiGE=;
        b=aC3gdLZMrMPakYfl3VgwQ3G57oS0aGzxoLFhxo7U0tqejqh8tx6kXd9M0dm0Dcqb/+
         NAYwXteg6EuVIhvHZOduMZssf1vGeVbB8zLcR4bHv9OIQGNCTwSW/rOzjCwjEwPdNjdx
         wTZd4lWjYuEdhYNHzwxpWpZ+R/mBnHAS+vzphKxaFGbCTH4VoH3c8p4lXN/4EY//88yE
         MCXfB5vNugr8CKPe4W6Pe+UISWYcFwRZIpqS6w0td4SraYlRrYqj2JoIlAhS8omoYdiF
         Fk8+uRfANeXj9/9fNDxTWIgGJJJnsWdVV8rM1ULfMt2xiY6fMA4+9gFZ4WVTTAN1NFJZ
         2dhg==
X-Gm-Message-State: AOAM530k3LX8wiCCSd4Cj1wvr8XPoYEcRgyXsl6RXcZ/BEvaSpl9MPvG
        dug3q1ong9Iog+B9H23udHLM1J8lppo=
X-Google-Smtp-Source: ABdhPJwvak34P5xeYzmfwa41JNJn91Ut74hiQmRsBBb8oTGabf4HYsLQby6FPQS8yxQUFMoumvhVPg==
X-Received: by 2002:a17:902:9a98:b029:e6:faf5:7bc2 with SMTP id w24-20020a1709029a98b02900e6faf57bc2mr27934191plp.61.1617009681920;
        Mon, 29 Mar 2021 02:21:21 -0700 (PDT)
Received: from garuda ([122.171.151.73])
        by smtp.gmail.com with ESMTPSA id s1sm14787207pjo.36.2021.03.29.02.21.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 29 Mar 2021 02:21:21 -0700 (PDT)
References: <20210326003308.32753-1-allison.henderson@oracle.com> <20210326003308.32753-4-allison.henderson@oracle.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v16 03/11] xfs: Hoist xfs_attr_set_shortform
In-reply-to: <20210326003308.32753-4-allison.henderson@oracle.com>
Date:   Mon, 29 Mar 2021 14:51:18 +0530
Message-ID: <87im5ab9ip.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 26 Mar 2021 at 06:03, Allison Henderson wrote:
> This patch hoists xfs_attr_set_shortform into the calling function. This
> will help keep all state management code in the same scope.
>

That looks simple enough.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 81 ++++++++++++++++--------------------------------
>  1 file changed, 27 insertions(+), 54 deletions(-)
>
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 32c7447..5216f67 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -217,53 +217,6 @@ xfs_attr_is_shortform(
>  }
>  
>  /*
> - * Attempts to set an attr in shortform, or converts short form to leaf form if
> - * there is not enough room.  If the attr is set, the transaction is committed
> - * and set to NULL.
> - */
> -STATIC int
> -xfs_attr_set_shortform(
> -	struct xfs_da_args	*args,
> -	struct xfs_buf		**leaf_bp)
> -{
> -	struct xfs_inode	*dp = args->dp;
> -	int			error, error2 = 0;
> -
> -	/*
> -	 * Try to add the attr to the attribute list in the inode.
> -	 */
> -	error = xfs_attr_try_sf_addname(dp, args);
> -	if (error != -ENOSPC) {
> -		error2 = xfs_trans_commit(args->trans);
> -		args->trans = NULL;
> -		return error ? error : error2;
> -	}
> -	/*
> -	 * It won't fit in the shortform, transform to a leaf block.  GROT:
> -	 * another possible req'mt for a double-split btree op.
> -	 */
> -	error = xfs_attr_shortform_to_leaf(args, leaf_bp);
> -	if (error)
> -		return error;
> -
> -	/*
> -	 * Prevent the leaf buffer from being unlocked so that a concurrent AIL
> -	 * push cannot grab the half-baked leaf buffer and run into problems
> -	 * with the write verifier. Once we're done rolling the transaction we
> -	 * can release the hold and add the attr to the leaf.
> -	 */
> -	xfs_trans_bhold(args->trans, *leaf_bp);
> -	error = xfs_defer_finish(&args->trans);
> -	xfs_trans_bhold_release(args->trans, *leaf_bp);
> -	if (error) {
> -		xfs_trans_brelse(args->trans, *leaf_bp);
> -		return error;
> -	}
> -
> -	return 0;
> -}
> -
> -/*
>   * Set the attribute specified in @args.
>   */
>  int
> @@ -272,7 +225,7 @@ xfs_attr_set_args(
>  {
>  	struct xfs_inode	*dp = args->dp;
>  	struct xfs_buf          *leaf_bp = NULL;
> -	int			error = 0;
> +	int			error2, error = 0;
>  
>  	/*
>  	 * If the attribute list is already in leaf format, jump straight to
> @@ -281,16 +234,36 @@ xfs_attr_set_args(
>  	 * again.
>  	 */
>  	if (xfs_attr_is_shortform(dp)) {
> +		/*
> +		 * Try to add the attr to the attribute list in the inode.
> +		 */
> +		error = xfs_attr_try_sf_addname(dp, args);
> +		if (error != -ENOSPC) {
> +			error2 = xfs_trans_commit(args->trans);
> +			args->trans = NULL;
> +			return error ? error : error2;
> +		}
> +
> +		/*
> +		 * It won't fit in the shortform, transform to a leaf block.
> +		 * GROT: another possible req'mt for a double-split btree op.
> +		 */
> +		error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
> +		if (error)
> +			return error;
>  
>  		/*
> -		 * If the attr was successfully set in shortform, the
> -		 * transaction is committed and set to NULL.  Otherwise, is it
> -		 * converted from shortform to leaf, and the transaction is
> -		 * retained.
> +		 * Prevent the leaf buffer from being unlocked so that a
> +		 * concurrent AIL push cannot grab the half-baked leaf buffer
> +		 * and run into problems with the write verifier.
>  		 */
> -		error = xfs_attr_set_shortform(args, &leaf_bp);
> -		if (error || !args->trans)
> +		xfs_trans_bhold(args->trans, leaf_bp);
> +		error = xfs_defer_finish(&args->trans);
> +		xfs_trans_bhold_release(args->trans, leaf_bp);
> +		if (error) {
> +			xfs_trans_brelse(args->trans, leaf_bp);
>  			return error;
> +		}
>  	}
>  
>  	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {


-- 
chandan
