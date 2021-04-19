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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ABB3C433B4
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Apr 2021 05:31:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 482466113C
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Apr 2021 05:31:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbhDSFcT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Apr 2021 01:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbhDSFcT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Apr 2021 01:32:19 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E7BAC06174A
        for <linux-xfs@vger.kernel.org>; Sun, 18 Apr 2021 22:31:50 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id s14so12388674pjl.5
        for <linux-xfs@vger.kernel.org>; Sun, 18 Apr 2021 22:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=tAjmoZ3l1PZCyIb1toQKjezYr4haSUDKGy1KlU/QUtE=;
        b=fPcortY3+SYWzZLp2liEDeTVykafbaJ+4ccCQeQGiEPrbCZDbwdHg77Ra+afSVKZmu
         GE7vWUS2WyoF1Fvfr/nIXzhVKG7n6zmTlQ+9j+dtN6nnXRmVqEk1TmdAtCyfSUGO3l6o
         lROlOOdv4Txh6nbHwknM4Gdu9jRR0Ha/XIn41N17olPNN/62/ELC1cTbWjX58NsFX9Jd
         MPwN+dpezi3tV9EmqKxLMCpQ/vTCZgpNhvoTG3/eFnGs3vQjBzLzCY6wcs3HtC0apt7a
         hEMhDKaqisRp3FxvDjicictqCtmPdSIgJtVuMPG86sXQ+UrfIovogwSOf4JJY3cnuOoN
         tuJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=tAjmoZ3l1PZCyIb1toQKjezYr4haSUDKGy1KlU/QUtE=;
        b=tv9bz6pTdXg/uLonVEz/m8gAT2n/U5mCEs3+4EuUMwOTGPmcFvX8B3qtb40/VKNn/+
         ZWWdvOgYliSj3rhh4isXF6FfNYM92mBaBDVK4tkGj4UPra45Te1lxop5eHl6Nl9kc0r9
         jSpWTXCKlbhacT0qnH6POLINlGbb4TYi9l/aPtDl3KKZ/PIeWYhu4aCPf+JXAWXjiTv5
         ecaJifLm62yYJ7nNz6McfmGtB0lNMRfKDfMQZ5pUQTGhYwF459MbRHIcTfi2HEareE83
         hvwPUtk4qpR4k9OT5yJgdb7NKE8akuEC0T7HbEfPNSdCxuWxmh7QJID3z4Zgjjrimolu
         l30g==
X-Gm-Message-State: AOAM531oisuJWQ+tnJRPmq2UP9G16wejRk24Rrx48Uni+vaKeVoOaiLW
        NztIlQTnYeXQKa/Vw5acPfG8c92mDVY=
X-Google-Smtp-Source: ABdhPJzvStTM3seiMIUItWK2FtBd6Cp6oyYzkQRoD0irSu5BUxgNeK/o+2SbQId5JXOP79VIH/oUfA==
X-Received: by 2002:a17:902:a60c:b029:ea:c9fd:a170 with SMTP id u12-20020a170902a60cb02900eac9fda170mr21534200plq.14.1618810309236;
        Sun, 18 Apr 2021 22:31:49 -0700 (PDT)
Received: from garuda ([122.179.111.183])
        by smtp.gmail.com with ESMTPSA id g14sm13253302pjh.28.2021.04.18.22.31.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 18 Apr 2021 22:31:48 -0700 (PDT)
References: <20210416092045.2215-1-allison.henderson@oracle.com> <20210416092045.2215-8-allison.henderson@oracle.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v17 07/11] xfs: Hoist xfs_attr_node_addname
In-reply-to: <20210416092045.2215-8-allison.henderson@oracle.com>
Date:   Mon, 19 Apr 2021 11:01:45 +0530
Message-ID: <87mttuj0vy.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 16 Apr 2021 at 14:50, Allison Henderson wrote:
> This patch hoists the later half of xfs_attr_node_addname into
> the calling function.  We do this because it is this area that
> will need the most state management, and we want to keep such
> code in the same scope as much as possible
>

The changes look good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 157 +++++++++++++++++++++++------------------------
>  1 file changed, 76 insertions(+), 81 deletions(-)
>
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 16159f6..80212d2 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -52,6 +52,7 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
>   * Internal routines when attribute list is more than one block.
>   */
>  STATIC int xfs_attr_node_get(xfs_da_args_t *args);
> +STATIC void xfs_attr_restore_rmt_blk(struct xfs_da_args *args);
>  STATIC int xfs_attr_node_addname(struct xfs_da_args *args,
>  				 struct xfs_da_state *state);
>  STATIC int xfs_attr_node_addname_find_attr(struct xfs_da_args *args,
> @@ -270,8 +271,8 @@ xfs_attr_set_args(
>  	struct xfs_da_args	*args)
>  {
>  	struct xfs_inode	*dp = args->dp;
> -	struct xfs_da_state     *state;
> -	int			error;
> +	struct xfs_da_state     *state = NULL;
> +	int			error = 0;
>  
>  	/*
>  	 * If the attribute list is already in leaf format, jump straight to
> @@ -322,8 +323,77 @@ xfs_attr_set_args(
>  			return error;
>  		error = xfs_attr_node_addname(args, state);
>  	} while (error == -EAGAIN);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * Commit the leaf addition or btree split and start the next
> +	 * trans in the chain.
> +	 */
> +	error = xfs_trans_roll_inode(&args->trans, dp);
> +	if (error)
> +		goto out;
> +
> +	/*
> +	 * If there was an out-of-line value, allocate the blocks we
> +	 * identified for its storage and copy the value.  This is done
> +	 * after we create the attribute so that we don't overflow the
> +	 * maximum size of a transaction and/or hit a deadlock.
> +	 */
> +	if (args->rmtblkno > 0) {
> +		error = xfs_attr_rmtval_set(args);
> +		if (error)
> +			return error;
> +	}
> +
> +	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
> +		/*
> +		 * Added a "remote" value, just clear the incomplete flag.
> +		 */
> +		if (args->rmtblkno > 0)
> +			error = xfs_attr3_leaf_clearflag(args);
> +		goto out;
> +	}
> +
> +	/*
> +	 * If this is an atomic rename operation, we must "flip" the incomplete
> +	 * flags on the "new" and "old" attribute/value pairs so that one
> +	 * disappears and one appears atomically.  Then we must remove the "old"
> +	 * attribute/value pair.
> +	 *
> +	 * In a separate transaction, set the incomplete flag on the "old" attr
> +	 * and clear the incomplete flag on the "new" attr.
> +	 */
> +	error = xfs_attr3_leaf_flipflags(args);
> +	if (error)
> +		goto out;
> +	/*
> +	 * Commit the flag value change and start the next trans in series
> +	 */
> +	error = xfs_trans_roll_inode(&args->trans, args->dp);
> +	if (error)
> +		goto out;
> +
> +	/*
> +	 * Dismantle the "old" attribute/value pair by removing a "remote" value
> +	 * (if it exists).
> +	 */
> +	xfs_attr_restore_rmt_blk(args);
> +
> +	if (args->rmtblkno) {
> +		error = xfs_attr_rmtval_invalidate(args);
> +		if (error)
> +			return error;
> +
> +		error = xfs_attr_rmtval_remove(args);
> +		if (error)
> +			return error;
> +	}
>  
> +	error = xfs_attr_node_addname_clear_incomplete(args);
> +out:
>  	return error;
> +
>  }
>  
>  /*
> @@ -957,7 +1027,7 @@ xfs_attr_node_addname(
>  {
>  	struct xfs_da_state_blk	*blk;
>  	struct xfs_inode	*dp;
> -	int			retval, error;
> +	int			error;
>  
>  	trace_xfs_attr_node_addname(args);
>  
> @@ -965,8 +1035,8 @@ xfs_attr_node_addname(
>  	blk = &state->path.blk[state->path.active-1];
>  	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
>  
> -	retval = xfs_attr3_leaf_add(blk->bp, state->args);
> -	if (retval == -ENOSPC) {
> +	error = xfs_attr3_leaf_add(blk->bp, state->args);
> +	if (error == -ENOSPC) {
>  		if (state->path.active == 1) {
>  			/*
>  			 * Its really a single leaf node, but it had
> @@ -1012,85 +1082,10 @@ xfs_attr_node_addname(
>  		xfs_da3_fixhashpath(state, &state->path);
>  	}
>  
> -	/*
> -	 * Kill the state structure, we're done with it and need to
> -	 * allow the buffers to come back later.
> -	 */
> -	xfs_da_state_free(state);
> -	state = NULL;
> -
> -	/*
> -	 * Commit the leaf addition or btree split and start the next
> -	 * trans in the chain.
> -	 */
> -	error = xfs_trans_roll_inode(&args->trans, dp);
> -	if (error)
> -		goto out;
> -
> -	/*
> -	 * If there was an out-of-line value, allocate the blocks we
> -	 * identified for its storage and copy the value.  This is done
> -	 * after we create the attribute so that we don't overflow the
> -	 * maximum size of a transaction and/or hit a deadlock.
> -	 */
> -	if (args->rmtblkno > 0) {
> -		error = xfs_attr_rmtval_set(args);
> -		if (error)
> -			return error;
> -	}
> -
> -	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
> -		/*
> -		 * Added a "remote" value, just clear the incomplete flag.
> -		 */
> -		if (args->rmtblkno > 0)
> -			error = xfs_attr3_leaf_clearflag(args);
> -		retval = error;
> -		goto out;
> -	}
> -
> -	/*
> -	 * If this is an atomic rename operation, we must "flip" the incomplete
> -	 * flags on the "new" and "old" attribute/value pairs so that one
> -	 * disappears and one appears atomically.  Then we must remove the "old"
> -	 * attribute/value pair.
> -	 *
> -	 * In a separate transaction, set the incomplete flag on the "old" attr
> -	 * and clear the incomplete flag on the "new" attr.
> -	 */
> -	error = xfs_attr3_leaf_flipflags(args);
> -	if (error)
> -		goto out;
> -	/*
> -	 * Commit the flag value change and start the next trans in series
> -	 */
> -	error = xfs_trans_roll_inode(&args->trans, args->dp);
> -	if (error)
> -		goto out;
> -
> -	/*
> -	 * Dismantle the "old" attribute/value pair by removing a "remote" value
> -	 * (if it exists).
> -	 */
> -	xfs_attr_restore_rmt_blk(args);
> -
> -	if (args->rmtblkno) {
> -		error = xfs_attr_rmtval_invalidate(args);
> -		if (error)
> -			return error;
> -
> -		error = xfs_attr_rmtval_remove(args);
> -		if (error)
> -			return error;
> -	}
> -
> -	error = xfs_attr_node_addname_clear_incomplete(args);
>  out:
>  	if (state)
>  		xfs_da_state_free(state);
> -	if (error)
> -		return error;
> -	return retval;
> +	return error;
>  }


-- 
chandan
