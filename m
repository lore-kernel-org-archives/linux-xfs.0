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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3CFDC432BE
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Aug 2021 10:15:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C365E610A8
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Aug 2021 10:15:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236361AbhH3KQ0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Aug 2021 06:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236355AbhH3KQ0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Aug 2021 06:16:26 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00DCBC061575
        for <linux-xfs@vger.kernel.org>; Mon, 30 Aug 2021 03:15:33 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id m4so8286490pll.0
        for <linux-xfs@vger.kernel.org>; Mon, 30 Aug 2021 03:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:message-id
         :date:mime-version;
        bh=/IfecmfRfn1hv885pqBGFjLuA13nebZQBHEUQkvW6Dw=;
        b=qjvBeGDtIKATcBr6+tjcmH2gbjqWiCurW/bYazYuYkV8JsBPIaD4VTB3ndd3vP7DoZ
         IM+SPvBLkNS6UQHHrLiwKIqp0/9k/bCM/HwpwOYsZozlL8A9CUgckmVbQmcoUdJmdVOK
         JWJUVppH/K9KGcP+LpshMDSOl4NcuAa82sWSJMGmaQy05YxUFv/GKSzkXBJcqiFZWQGl
         IMRpTdzA7EZNCODJ5ugFOBs02RBhq8WGe1CWoGZbmDqnIzwaw1ylacfbtv3+rBya/FS8
         pOuQPrTgJfiA/j3pgPMVmzEA9SRADRODppQ3STwXwjLuVb9jzT7X1tHLjJRowENdu4k+
         mKKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:message-id:date:mime-version;
        bh=/IfecmfRfn1hv885pqBGFjLuA13nebZQBHEUQkvW6Dw=;
        b=kEvDFS6OrcHnRbtutW1zVY5rSZM2I8gwqLPQkpjbWdcv2I/eD0HDf9zLoJTqrctqGX
         sfa88aQcnz7adnzpOJ91Hvq2hJF1wdHsGS8YFKmgsSJfwsYpXVbL1szoPgTenuYpSJ4D
         bqp8d+IopKaQ0n5sXFi5M7tKeLI1CAdgnf7Sw0sx5ggiwi0qYovqQv3YUgpBkBNaxNOj
         Bc/+wAtukucY4O2uvm9/aKCC7t576xApk7kAJu524r0Sa7ONpsMXWJTJhHHDF/sg135f
         wd+3mW9NGKDwXSRhHFfSxSfkqK3aWQDK+Js2kVbFQLNTTrvbzsYHvmmjU8UQZ2SUsD9V
         J4PA==
X-Gm-Message-State: AOAM531Zv44aGSbnJj8SowxCkyTW40KFoulrjzSvYIer7WlZWNtYF0eA
        f50w7dcyuXbHTj1uIj8S91nnkB5J64E=
X-Google-Smtp-Source: ABdhPJy8X8UgXhhHGwYv0lypV5Kle7LUs8tAq1zMbZHhOL8cuzy50qJc0RkHT6bGl3TE6Oy+JESYtg==
X-Received: by 2002:a17:90a:bc98:: with SMTP id x24mr26577759pjr.51.1630318531822;
        Mon, 30 Aug 2021 03:15:31 -0700 (PDT)
Received: from garuda ([122.171.149.36])
        by smtp.gmail.com with ESMTPSA id 5sm3528538pfl.135.2021.08.30.03.15.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 30 Aug 2021 03:15:31 -0700 (PDT)
References: <20210824224434.968720-1-allison.henderson@oracle.com>
 <20210824224434.968720-6-allison.henderson@oracle.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v24 05/11] RFC xfs: Skip flip flags for delayed attrs
In-reply-to: <20210824224434.968720-6-allison.henderson@oracle.com>
Message-ID: <87bl5f9r28.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Mon, 30 Aug 2021 15:45:27 +0530
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 25 Aug 2021 at 04:14, Allison Henderson wrote:
> This is a clean up patch that skips the flip flag logic for delayed attr
> renames.  Since the log replay keeps the inode locked, we do not need to
> worry about race windows with attr lookups.  So we can skip over
> flipping the flag and the extra transaction roll for it
>
> RFC: In the last review, folks asked for some performance analysis, so I
> did a few perf captures with and with out this patch.  What I found was
> that there wasnt very much difference at all between having the patch or
> not having it.  Of the time we do spend in the affected code, the
> percentage is small.  Most of the time we spend about %0.03 of the time
> in this function, with or with out the patch.  Occasionally we get a
> 0.02%, though not often.  So I think this starts to challenge needing
> this patch at all. This patch was requested some number of reviews ago,
> be perhaps in light of the findings, it may no longer be of interest.
>
>      0.03%     0.00%  fsstress  [xfs]               [k] xfs_attr_set_iter
>
> Keep it or drop it?

Looks good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_attr.c      | 54 +++++++++++++++++++++--------------
>  fs/xfs/libxfs/xfs_attr_leaf.c |  3 +-
>  2 files changed, 35 insertions(+), 22 deletions(-)
>
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index dfff81024e46..fce67c717be2 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -355,6 +355,7 @@ xfs_attr_set_iter(
>  	struct xfs_inode		*dp = args->dp;
>  	struct xfs_buf			*bp = NULL;
>  	int				forkoff, error = 0;
> +	struct xfs_mount		*mp = args->dp->i_mount;
>  
>  	/* State machine switch */
>  	switch (dac->dela_state) {
> @@ -477,16 +478,21 @@ xfs_attr_set_iter(
>  		 * In a separate transaction, set the incomplete flag on the
>  		 * "old" attr and clear the incomplete flag on the "new" attr.
>  		 */
> -		error = xfs_attr3_leaf_flipflags(args);
> -		if (error)
> -			return error;
> -		/*
> -		 * Commit the flag value change and start the next trans in
> -		 * series.
> -		 */
> -		dac->dela_state = XFS_DAS_FLIP_LFLAG;
> -		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
> -		return -EAGAIN;
> +		if (!xfs_has_larp(mp)) {
> +			error = xfs_attr3_leaf_flipflags(args);
> +			if (error)
> +				return error;
> +			/*
> +			 * Commit the flag value change and start the next trans
> +			 * in series.
> +			 */
> +			dac->dela_state = XFS_DAS_FLIP_LFLAG;
> +			trace_xfs_attr_set_iter_return(dac->dela_state,
> +						       args->dp);
> +			return -EAGAIN;
> +		}
> +
> +		/* fallthrough */
>  	case XFS_DAS_FLIP_LFLAG:
>  		/*
>  		 * Dismantle the "old" attribute/value pair by removing a
> @@ -589,17 +595,21 @@ xfs_attr_set_iter(
>  		 * In a separate transaction, set the incomplete flag on the
>  		 * "old" attr and clear the incomplete flag on the "new" attr.
>  		 */
> -		error = xfs_attr3_leaf_flipflags(args);
> -		if (error)
> -			goto out;
> -		/*
> -		 * Commit the flag value change and start the next trans in
> -		 * series
> -		 */
> -		dac->dela_state = XFS_DAS_FLIP_NFLAG;
> -		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
> -		return -EAGAIN;
> +		if (!xfs_has_larp(mp)) {
> +			error = xfs_attr3_leaf_flipflags(args);
> +			if (error)
> +				goto out;
> +			/*
> +			 * Commit the flag value change and start the next trans
> +			 * in series
> +			 */
> +			dac->dela_state = XFS_DAS_FLIP_NFLAG;
> +			trace_xfs_attr_set_iter_return(dac->dela_state,
> +						       args->dp);
> +			return -EAGAIN;
> +		}
>  
> +		/* fallthrough */
>  	case XFS_DAS_FLIP_NFLAG:
>  		/*
>  		 * Dismantle the "old" attribute/value pair by removing a
> @@ -1236,6 +1246,7 @@ xfs_attr_node_addname_clear_incomplete(
>  {
>  	struct xfs_da_args		*args = dac->da_args;
>  	struct xfs_da_state		*state = NULL;
> +	struct xfs_mount		*mp = args->dp->i_mount;
>  	int				retval = 0;
>  	int				error = 0;
>  
> @@ -1243,7 +1254,8 @@ xfs_attr_node_addname_clear_incomplete(
>  	 * Re-find the "old" attribute entry after any split ops. The INCOMPLETE
>  	 * flag means that we will find the "old" attr, not the "new" one.
>  	 */
> -	args->attr_filter |= XFS_ATTR_INCOMPLETE;
> +	if (!xfs_has_larp(mp))
> +		args->attr_filter |= XFS_ATTR_INCOMPLETE;
>  	state = xfs_da_state_alloc(args);
>  	state->inleaf = 0;
>  	error = xfs_da3_node_lookup_int(state, &retval);
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index e1d11e314228..a0a352bdea59 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -1487,7 +1487,8 @@ xfs_attr3_leaf_add_work(
>  	if (tmp)
>  		entry->flags |= XFS_ATTR_LOCAL;
>  	if (args->op_flags & XFS_DA_OP_RENAME) {
> -		entry->flags |= XFS_ATTR_INCOMPLETE;
> +		if (!xfs_has_larp(mp))
> +			entry->flags |= XFS_ATTR_INCOMPLETE;
>  		if ((args->blkno2 == args->blkno) &&
>  		    (args->index2 <= args->index)) {
>  			args->index2++;


-- 
chandan
