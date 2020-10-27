Return-Path: <SRS0=u7A2=EC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A25C0C55178
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 13:33:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DCAF218AC
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 13:33:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rpIL04hO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1752128AbgJ0NdA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Oct 2020 09:33:00 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:44502 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752127AbgJ0Nc7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Oct 2020 09:32:59 -0400
Received: by mail-pl1-f195.google.com with SMTP id t6so237431plq.11
        for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2020 06:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eMIC6DNi1I0kZ57T6DI+ymSsQqJLOhkpJGNeywJxGoA=;
        b=rpIL04hOjxP/k+VLWS4JWph6ZYcJmT95QW9jVs6gLB8drcIHcswOENmEY7FsMxykAg
         ZuRbj4GVxTkZej767UpijGqLpnpPYxnJHDgXpCi6Fu3kfihrO+NXCkzS+iYKLVorFU4V
         3qbLu6h4vQZ80Q+8v4VfXIaHRW/6JAufObT1pajyo7dFHfaIQfv6bDNbis0CdIClJW4M
         Ar5P/mwkbjYXd1VLT4o6un1xgzF6FDx6olZEsdPPdFPJfxtDfEtS+tl8+5k+9az9+0yk
         CivLMqmZRR26QO639fdz/R9xi+eqgsea5n68R5XySJJHeM3rwQxbMhfm+ps07D4Jo2lh
         GZMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eMIC6DNi1I0kZ57T6DI+ymSsQqJLOhkpJGNeywJxGoA=;
        b=VvrZPkvDeYyQoWFtL/dpW99K1KkRpW6Nw91k1Tn/9wGUGJUUfN7bi6ES7N0YFCQEFc
         bPANrIyFrwFur8NYjf1UV+ITFwIQK/0Q84oM4r464mOCHRdYifi+2orQOOkUDFNiAPSL
         UpBmkMEwZYys9L4bAfoDJQqH1iNA9Rx2gsgFgPbtid8ggo6QI2T4i9/xagkuhGzdjm1+
         UwOyBpdpGCT9pzHPX8G7puVUIqIdCgyirhLejZXizZ9SD8E9qugaEgHlLO4FIVl2RLlC
         wCv64HGUVbuT9/anHHkRDBqEjheM5ltVjIqrFJBEXXlGCv00tFyxp5XGvtsD0fqYcqU/
         y3cA==
X-Gm-Message-State: AOAM532myB6vRFxf2aZcqrHGT3sh5L10KOXqYhMQAcKkbTBmvCVjaeCP
        VIZDYewEAhVhepZlUw+jE6Y=
X-Google-Smtp-Source: ABdhPJxwyq+yed42T9nY3GponqcbkBl8/tVirixX4aByeNLS29u+VMEBQj2A0EyFTYCTq7XZGqQn4g==
X-Received: by 2002:a17:90a:d303:: with SMTP id p3mr1992246pju.93.1603805578611;
        Tue, 27 Oct 2020 06:32:58 -0700 (PDT)
Received: from garuda.localnet ([122.179.70.119])
        by smtp.gmail.com with ESMTPSA id s10sm2064695pji.7.2020.10.27.06.32.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 06:32:57 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v13 03/10] xfs: Add delay ready attr set routines
Date:   Tue, 27 Oct 2020 19:02:55 +0530
Message-ID: <534604869.YD8572SIOA@garuda>
In-Reply-To: <20201023063435.7510-4-allison.henderson@oracle.com>
References: <20201023063435.7510-1-allison.henderson@oracle.com> <20201023063435.7510-4-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Friday 23 October 2020 12:04:28 PM IST Allison Henderson wrote:
> This patch modifies the attr set routines to be delay ready. This means
> they no longer roll or commit transactions, but instead return -EAGAIN
> to have the calling routine roll and refresh the transaction.  In this
> series, xfs_attr_set_args has become xfs_attr_set_iter, which uses a
> state machine like switch to keep track of where it was when EAGAIN was
> returned. See xfs_attr.h for a more detailed diagram of the states.
> 
> Two new helper functions have been added: xfs_attr_rmtval_set_init and
> xfs_attr_rmtval_set_blk.  They provide a subset of logic similar to
> xfs_attr_rmtval_set, but they store the current block in the delay attr
> context to allow the caller to roll the transaction between allocations.
> This helps to simplify and consolidate code used by
> xfs_attr_leaf_addname and xfs_attr_node_addname. xfs_attr_set_args has
> now become a simple loop to refresh the transaction until the operation
> is completed.  Lastly, xfs_attr_rmtval_remove is no longer used, and is
> removed.

One nit. xfs_attr_rmtval_remove()'s prototype declaration needs to be removed
from xfs_attr_remote.h.

> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c        | 370 ++++++++++++++++++++++++++--------------
>  fs/xfs/libxfs/xfs_attr.h        | 126 +++++++++++++-
>  fs/xfs/libxfs/xfs_attr_remote.c |  99 +++++++----
>  fs/xfs/libxfs/xfs_attr_remote.h |   4 +
>  fs/xfs/xfs_trace.h              |   1 -
>  5 files changed, 439 insertions(+), 161 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 6ca94cb..95c98d7 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -44,7 +44,7 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
>   * Internal routines when attribute list is one block.
>   */
>  STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
> -STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args);
> +STATIC int xfs_attr_leaf_addname(struct xfs_delattr_context *dac);
>  STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
>  STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
>  
> @@ -52,12 +52,15 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
>   * Internal routines when attribute list is more than one block.
>   */
>  STATIC int xfs_attr_node_get(xfs_da_args_t *args);
> -STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
> +STATIC int xfs_attr_node_addname(struct xfs_delattr_context *dac);
>  STATIC int xfs_attr_node_removename_iter(struct xfs_delattr_context *dac);
>  STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>  				 struct xfs_da_state **state);
>  STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>  STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
> +STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *args, struct xfs_buf *bp);
> +STATIC int xfs_attr_set_iter(struct xfs_delattr_context *dac,
> +			     struct xfs_buf **leaf_bp);
>  
>  int
>  xfs_inode_hasattr(
> @@ -218,8 +221,11 @@ xfs_attr_is_shortform(
>  
>  /*
>   * Attempts to set an attr in shortform, or converts short form to leaf form if
> - * there is not enough room.  If the attr is set, the transaction is committed
> - * and set to NULL.
> + * there is not enough room.  This function is meant to operate as a helper
> + * routine to the delayed attribute functions.  It returns -EAGAIN to indicate
> + * that the calling function should roll the transaction, and then proceed to
> + * add the attr in leaf form.  This subroutine does not expect to be recalled
> + * again like the other delayed attr routines do.
>   */
>  STATIC int
>  xfs_attr_set_shortform(
> @@ -227,16 +233,16 @@ xfs_attr_set_shortform(
>  	struct xfs_buf		**leaf_bp)
>  {
>  	struct xfs_inode	*dp = args->dp;
> -	int			error, error2 = 0;
> +	int			error = 0;
>  
>  	/*
>  	 * Try to add the attr to the attribute list in the inode.
>  	 */
>  	error = xfs_attr_try_sf_addname(dp, args);
> +
> +	/* Should only be 0, -EEXIST or ENOSPC */
>  	if (error != -ENOSPC) {
> -		error2 = xfs_trans_commit(args->trans);
> -		args->trans = NULL;
> -		return error ? error : error2;
> +		return error;
>  	}
>  	/*
>  	 * It won't fit in the shortform, transform to a leaf block.  GROT:
> @@ -249,18 +255,10 @@ xfs_attr_set_shortform(
>  	/*
>  	 * Prevent the leaf buffer from being unlocked so that a concurrent AIL
>  	 * push cannot grab the half-baked leaf buffer and run into problems
> -	 * with the write verifier. Once we're done rolling the transaction we
> -	 * can release the hold and add the attr to the leaf.
> +	 * with the write verifier.
>  	 */
>  	xfs_trans_bhold(args->trans, *leaf_bp);
> -	error = xfs_defer_finish(&args->trans);
> -	xfs_trans_bhold_release(args->trans, *leaf_bp);
> -	if (error) {
> -		xfs_trans_brelse(args->trans, *leaf_bp);
> -		return error;
> -	}
> -
> -	return 0;
> +	return -EAGAIN;
>  }
>  
>  /*
> @@ -268,7 +266,7 @@ xfs_attr_set_shortform(
>   * also checks for a defer finish.  Transaction is finished and rolled as
>   * needed, and returns true of false if the delayed operation should continue.
>   */
> -int
> +STATIC int
>  xfs_attr_trans_roll(
>  	struct xfs_delattr_context	*dac)
>  {
> @@ -297,61 +295,130 @@ int
>  xfs_attr_set_args(
>  	struct xfs_da_args	*args)
>  {
> -	struct xfs_inode	*dp = args->dp;
> -	struct xfs_buf          *leaf_bp = NULL;
> -	int			error = 0;
> +	struct xfs_buf			*leaf_bp = NULL;
> +	int				error = 0;
> +	struct xfs_delattr_context	dac = {
> +		.da_args	= args,
> +	};
> +
> +	do {
> +		error = xfs_attr_set_iter(&dac, &leaf_bp);
> +		if (error != -EAGAIN)
> +			break;
> +
> +		error = xfs_attr_trans_roll(&dac);
> +		if (error)
> +			return error;
> +
> +		if (leaf_bp) {
> +			xfs_trans_bjoin(args->trans, leaf_bp);
> +			xfs_trans_bhold(args->trans, leaf_bp);
> +		}

When xfs_attr_set_iter() causes a "short form" attribute list to be converted
to "leaf form", leaf_bp would point to an xfs_buf which has been added to the
transaction and also XFS_BLI_HOLD flag is set on the buffer (last statement in
xfs_attr_set_shortform()). XFS_BLI_HOLD flag makes sure that the new
transaction allocated by xfs_attr_trans_roll() would continue to have leaf_bp
in the transaction's item list. Hence I think the above calls to
xfs_trans_bjoin() and xfs_trans_bhold() are not required. Please let me know
if I am missing something obvious here.


-- 
chandan



