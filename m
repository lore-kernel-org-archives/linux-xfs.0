Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBBDEC433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Dec 2020 06:46:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F5642158C
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Dec 2020 06:46:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727224AbgLUGqO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Dec 2020 01:46:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbgLUGqO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Dec 2020 01:46:14 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21132C061282
        for <linux-xfs@vger.kernel.org>; Sun, 20 Dec 2020 22:45:34 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id s15so694119plr.9
        for <linux-xfs@vger.kernel.org>; Sun, 20 Dec 2020 22:45:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BkoUw3l9svY2M9q6xXE7ZHvmdWsqVaFxO1g9MABwqfE=;
        b=F+Wp76QBlMCXz9EbVVSjzF5wFbgCWhJxujy7cTM5gjuJMQi54nS0DZrGSQ6+1nOuJc
         j7yCEh+pQSk3g/uyPn6btKha+4frNlcQA4BjJ5ymW6UxBH0pdX7UBeDCLw4kGD6vwgVX
         Jdx7jbIRvDOXamClON6Jw5GZhhHbpdkcL5x4V7FMjpqg1/ewDVheGpRkYvUsxiZ3zNlC
         7ukNkXZx88o9vkw/tUljZfpbyF41Vy0LrRvgqxADDPg2meRLT7ZN5qneVObyKOK0p3yv
         oAtB4Nfv3uDoG3WoIg4TXQngKN3s3YgFTAN11CZJAYltU3NlLtZdHyEauyDzckiBWkno
         GlQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BkoUw3l9svY2M9q6xXE7ZHvmdWsqVaFxO1g9MABwqfE=;
        b=AdVpWUSsAOXIactLqAJx8FVovstbjXAYLd2ynVmgj3uLC/KSePcCPQU92UV1ApGE6d
         mItw3Jt3KBaEy4BlTC4OAS6ocB6IBvrx3KluoGCDgcsavL0Ke3Gtg7a/Ju5rZQnGlhOo
         LLgo3eTkMYxRAKKz3YgJ+rBitdmZGLDtlKTBErbGUKC0/NrkkddmyE5oDEBTjLmLMzza
         SRTPIgA/cNq7K1KYxS0BScmQBmGsVGZ0+nJPema4z2BjiYDj7TXlEsJO790WilGL/EGz
         vFpLy/kykQOIqIMtVTjlBq3hTb+cJAryqkL1+g82P6a6Hq1w9i73zKKAEtWVQjlD43nw
         YqwA==
X-Gm-Message-State: AOAM5320983mNsXrbDITQIDUtyjoGhUbtdHz/bAR1emE/f4qJvupIkXV
        yf21YbnsaiW+zB2M3HihabzFv9k0R1cQhg==
X-Google-Smtp-Source: ABdhPJxRVMFJltHrMe8gsew5frex218GkYwSNxK/fG67fpZyT2j+rG6yjCgyJCft1IeB86yBUSi1dQ==
X-Received: by 2002:a17:90a:1b0d:: with SMTP id q13mr15592191pjq.21.1608533133776;
        Sun, 20 Dec 2020 22:45:33 -0800 (PST)
Received: from garuda.localnet ([122.179.35.127])
        by smtp.gmail.com with ESMTPSA id o2sm15273001pgi.60.2020.12.20.22.45.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Dec 2020 22:45:33 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v14 02/15] xfs: Add xfs_attr_node_remove_cleanup
Date:   Mon, 21 Dec 2020 12:15:31 +0530
Message-ID: <4861977.KByABTbv6y@garuda>
In-Reply-To: <20201218072917.16805-3-allison.henderson@oracle.com>
References: <20201218072917.16805-1-allison.henderson@oracle.com> <20201218072917.16805-3-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, 18 Dec 2020 00:29:04 -0700, Allison Henderson wrote:
> This patch pulls a new helper function xfs_attr_node_remove_cleanup out
> of xfs_attr_node_remove_step.  This helps to modularize
> xfs_attr_node_remove_step which will help make the delayed attribute
> code easier to follow

The changes look good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 29 ++++++++++++++++++++---------
>  1 file changed, 20 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 8b55a8d..e93d76a 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1220,6 +1220,25 @@ xfs_attr_node_remove_rmt(
>  	return xfs_attr_refillstate(state);
>  }
>  
> +STATIC int
> +xfs_attr_node_remove_cleanup(
> +	struct xfs_da_args	*args,
> +	struct xfs_da_state	*state)
> +{
> +	struct xfs_da_state_blk	*blk;
> +	int			retval;
> +
> +	/*
> +	 * Remove the name and update the hashvals in the tree.
> +	 */
> +	blk = &state->path.blk[state->path.active-1];
> +	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
> +	retval = xfs_attr3_leaf_remove(blk->bp, args);
> +	xfs_da3_fixhashpath(state, &state->path);
> +
> +	return retval;
> +}
> +
>  /*
>   * Remove a name from a B-tree attribute list.
>   *
> @@ -1232,7 +1251,6 @@ xfs_attr_node_remove_step(
>  	struct xfs_da_args	*args,
>  	struct xfs_da_state	*state)
>  {
> -	struct xfs_da_state_blk	*blk;
>  	int			retval, error;
>  	struct xfs_inode	*dp = args->dp;
>  
> @@ -1247,14 +1265,7 @@ xfs_attr_node_remove_step(
>  		if (error)
>  			return error;
>  	}
> -
> -	/*
> -	 * Remove the name and update the hashvals in the tree.
> -	 */
> -	blk = &state->path.blk[ state->path.active-1 ];
> -	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
> -	retval = xfs_attr3_leaf_remove(blk->bp, args);
> -	xfs_da3_fixhashpath(state, &state->path);
> +	retval = xfs_attr_node_remove_cleanup(args, state);
>  
>  	/*
>  	 * Check to see if the tree needs to be collapsed.
> 


-- 
chandan



