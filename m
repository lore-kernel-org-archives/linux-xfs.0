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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A00A0C433C1
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 09:38:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D60861960
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 09:38:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231623AbhC2Jhk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Mar 2021 05:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231618AbhC2Jh2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Mar 2021 05:37:28 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EBF5C061574
        for <linux-xfs@vger.kernel.org>; Mon, 29 Mar 2021 02:37:27 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id a12so629470pfc.7
        for <linux-xfs@vger.kernel.org>; Mon, 29 Mar 2021 02:37:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=u2XeuMJiDh69PkGfWuWU13kqkUDRGtMYrPxDE3fLFnw=;
        b=fZaaiEnZHXZdWoJW5gtqiiy9kA1jZpcP28CRNz7qKTplAL0d1oX65SyXsdSURED/lK
         rYhLnkpkzQEG7SZmgv3ScQScXKuqF9SM+JPZLF+GGYipKQZXacoXBFmBaPZcjRIWVByw
         7ysRQ+wDNxKXTFNOUJqir7pHxNTB56I94aRlIrJnjf2pQg63yPzd9z9kMwybjTZx5fE1
         tooGOC3UXMu/GyHZdWk5n5p4vR/d2PgPlL2IXDVpkBI8vOYeBhcwSPRwahxBh6HKbOC8
         atWTfdn2983QSf1tHrBhllmxTH+ueRibLIspzFjYjOX+owdsk0SvQmmi5u27V0jcaoDe
         OZ6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=u2XeuMJiDh69PkGfWuWU13kqkUDRGtMYrPxDE3fLFnw=;
        b=o5cSyov+5xqpnnPUNFt1yTJiLmKPmsZvhJUcO+qtuCueGAUSY78JjqCifT6QwuNyMa
         WDJC/mVVM8nV1AnLstxpIgotNZJhnRjWv2iIbgEMN5gnhBTl13+Yx74evkVp9d1XJ862
         AYR3KESPEbandBco7F7GNLRNbKS/dal3lgsyFP48GxBMdaqQkwnXdzhSPa65iUWb/s+k
         sZetsdG7TLPYLXJHTaQ5Glm3G+1LIQlpyeIjQDF053HVQF+UEASFqAKDvp9YZYFct9x7
         Dy1dYhkdjX/FoceyQIeThKY/5wX2avHu0IKeRIvHq6A/Ef7PxSn0m+xL/vxnkYUAM6r6
         sSvA==
X-Gm-Message-State: AOAM532qeGoj1YPryM0oRZlNCPFOaluNrcZ8oZ4ucvXxW4jPosj22e8F
        Je0p5pBhALJYE5ROY6gx/10R0E+vazk=
X-Google-Smtp-Source: ABdhPJxPgZcf3b8yQ+5C8BcJd6Hul7Q5QlBizPFllHapB7CQZp2Jzm6ozKtnuA9izGiZBYPURgbQgg==
X-Received: by 2002:a63:505d:: with SMTP id q29mr22865755pgl.218.1617010646635;
        Mon, 29 Mar 2021 02:37:26 -0700 (PDT)
Received: from garuda ([122.171.151.73])
        by smtp.gmail.com with ESMTPSA id w84sm16699592pfc.142.2021.03.29.02.37.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 29 Mar 2021 02:37:26 -0700 (PDT)
References: <20210326003308.32753-1-allison.henderson@oracle.com> <20210326003308.32753-5-allison.henderson@oracle.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v16 04/11] xfs: Add helper xfs_attr_set_fmt
In-reply-to: <20210326003308.32753-5-allison.henderson@oracle.com>
Date:   Mon, 29 Mar 2021 15:07:24 +0530
Message-ID: <87h7kub8rv.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 26 Mar 2021 at 06:03, Allison Henderson wrote:
> This patch adds a helper function xfs_attr_set_fmt.  This will help
> isolate the code that will require state management from the portions
> that do not.  xfs_attr_set_fmt returns 0 when the attr has been set and
> no further action is needed.  It returns -EAGAIN when shortform has been
> transformed to leaf, and the calling function should proceed the set the
> attr in leaf form.

The previous behaviour is maintained across the changes made by this patch.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 79 ++++++++++++++++++++++++++++--------------------
>  1 file changed, 46 insertions(+), 33 deletions(-)
>
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 5216f67..d46324a 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -216,6 +216,48 @@ xfs_attr_is_shortform(
>  		ip->i_afp->if_nextents == 0);
>  }
>  
> +STATIC int
> +xfs_attr_set_fmt(
> +	struct xfs_da_args	*args)
> +{
> +	struct xfs_buf          *leaf_bp = NULL;
> +	struct xfs_inode	*dp = args->dp;
> +	int			error2, error = 0;
> +
> +	/*
> +	 * Try to add the attr to the attribute list in the inode.
> +	 */
> +	error = xfs_attr_try_sf_addname(dp, args);
> +	if (error != -ENOSPC) {
> +		error2 = xfs_trans_commit(args->trans);
> +		args->trans = NULL;
> +		return error ? error : error2;
> +	}
> +
> +	/*
> +	 * It won't fit in the shortform, transform to a leaf block.
> +	 * GROT: another possible req'mt for a double-split btree op.
> +	 */
> +	error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * Prevent the leaf buffer from being unlocked so that a
> +	 * concurrent AIL push cannot grab the half-baked leaf buffer
> +	 * and run into problems with the write verifier.
> +	 */
> +	xfs_trans_bhold(args->trans, leaf_bp);
> +	error = xfs_defer_finish(&args->trans);
> +	xfs_trans_bhold_release(args->trans, leaf_bp);
> +	if (error) {
> +		xfs_trans_brelse(args->trans, leaf_bp);
> +		return error;
> +	}
> +
> +	return -EAGAIN;
> +}
> +
>  /*
>   * Set the attribute specified in @args.
>   */
> @@ -224,8 +266,7 @@ xfs_attr_set_args(
>  	struct xfs_da_args	*args)
>  {
>  	struct xfs_inode	*dp = args->dp;
> -	struct xfs_buf          *leaf_bp = NULL;
> -	int			error2, error = 0;
> +	int			error;
>  
>  	/*
>  	 * If the attribute list is already in leaf format, jump straight to
> @@ -234,36 +275,9 @@ xfs_attr_set_args(
>  	 * again.
>  	 */
>  	if (xfs_attr_is_shortform(dp)) {
> -		/*
> -		 * Try to add the attr to the attribute list in the inode.
> -		 */
> -		error = xfs_attr_try_sf_addname(dp, args);
> -		if (error != -ENOSPC) {
> -			error2 = xfs_trans_commit(args->trans);
> -			args->trans = NULL;
> -			return error ? error : error2;
> -		}
> -
> -		/*
> -		 * It won't fit in the shortform, transform to a leaf block.
> -		 * GROT: another possible req'mt for a double-split btree op.
> -		 */
> -		error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
> -		if (error)
> -			return error;
> -
> -		/*
> -		 * Prevent the leaf buffer from being unlocked so that a
> -		 * concurrent AIL push cannot grab the half-baked leaf buffer
> -		 * and run into problems with the write verifier.
> -		 */
> -		xfs_trans_bhold(args->trans, leaf_bp);
> -		error = xfs_defer_finish(&args->trans);
> -		xfs_trans_bhold_release(args->trans, leaf_bp);
> -		if (error) {
> -			xfs_trans_brelse(args->trans, leaf_bp);
> +		error = xfs_attr_set_fmt(args);
> +		if (error != -EAGAIN)
>  			return error;
> -		}
>  	}
>  
>  	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> @@ -297,8 +311,7 @@ xfs_attr_set_args(
>  			return error;
>  	}
>  
> -	error = xfs_attr_node_addname(args);
> -	return error;
> +	return xfs_attr_node_addname(args);
>  }
>  
>  /*


-- 
chandan
