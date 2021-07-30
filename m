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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1543CC4338F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Jul 2021 14:40:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 022FE60FE7
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Jul 2021 14:40:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239339AbhG3OkN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Jul 2021 10:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239286AbhG3OkN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Jul 2021 10:40:13 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76BEFC061765
        for <linux-xfs@vger.kernel.org>; Fri, 30 Jul 2021 07:40:07 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id nh14so3729672pjb.2
        for <linux-xfs@vger.kernel.org>; Fri, 30 Jul 2021 07:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=kc+LsMPr36uEqQi30YEowzrG+MYNybY3yXsORHPsefk=;
        b=HRhGnBU8YKjc2u3D/D5GfCwIzk37V53EoG6uPrJy2seCLe0mgZ89Vr1CiU5Pi7rOzp
         fTadMD/CPxod+MushAY0lb3PScNZ3rX2d8SH7Pm9C3qWdCIopkVgcSTCZVrcIiTewr31
         hilqSnmcUR6iLCpylMFzExZ52QF8ROivbqD4hmpvqitt0206y4EfpaksgiWQAhMGLsv2
         UkLrwFOZjYkd6tDmv3HFu+9Vr1FTTiQzQmtcQYhXLKKDuTrMNUT85C+1j5r+OPCgC+Bd
         BqVw0rMsPKHf/Hb1lNaoLCZWYj5m9Bu7+fpFb7SYfqHcMXfGDi7EDA0khVQOl0mQG4JP
         zxfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=kc+LsMPr36uEqQi30YEowzrG+MYNybY3yXsORHPsefk=;
        b=okuSjf8tjhxRV8hFldarw9Fku2V/Ocqrc7xtTFCy1UwGqh3j6j/rgf89JhK++lSKJc
         hIxAjP43915eDBEvRmWHiDQQSN64ljb5XIdG89Mhb50oCkbSvMFgAf/OtMYBJM283aNO
         T8Oh00GkEoB/s+vpK0+J8V1QKFLK+Nl7cqRJbULW5vRv6XXZYpHIezV7/LiMneAfAP3r
         G9QUj/nyv/tPuFcGDIhrjQB8b50sVoA4WksIuXUphTtFs38lxxoEl3C2jp8Xma8vv5pC
         kH9PGWVwZEh7qpy0+6M54Dg09Kr0MgEkLhUuONM2Es/fdsLDjOYAFV6o1x0eeCrMpYBd
         uyUg==
X-Gm-Message-State: AOAM531c3HeZ8a1k7pJ5oZhHPSjRPYRENEYxZWPVPE8fOpy/KjYpw38x
        J2C/oErqppWHLLHrS/l5bUTuhKdz+jxdqQ==
X-Google-Smtp-Source: ABdhPJz4ZZUAD/TofNVBCl2inws5SnpHZCx+RFi/ffVV9oWD9VDDvz59nBfQddnuaRuvg4D/TAucOQ==
X-Received: by 2002:a17:90a:5d8a:: with SMTP id t10mr3594260pji.6.1627656006826;
        Fri, 30 Jul 2021 07:40:06 -0700 (PDT)
Received: from garuda ([122.171.174.228])
        by smtp.gmail.com with ESMTPSA id t17sm2579047pfg.93.2021.07.30.07.40.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 30 Jul 2021 07:40:06 -0700 (PDT)
References: <20210727062053.11129-1-allison.henderson@oracle.com> <20210727062053.11129-11-allison.henderson@oracle.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v22 10/16] RFC xfs: Skip flip flags for delayed attrs
In-reply-to: <20210727062053.11129-11-allison.henderson@oracle.com>
Date:   Fri, 30 Jul 2021 20:10:04 +0530
Message-ID: <87tukb986z.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 27 Jul 2021 at 11:50, Allison Henderson wrote:
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
>

Apart from the issues pointed out by Darrick, the remaining changes seem to be
fine.

> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_attr.c      | 51 +++++++++++++++++++++++++------------------
>  fs/xfs/libxfs/xfs_attr_leaf.c |  3 ++-
>  2 files changed, 32 insertions(+), 22 deletions(-)
>
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 11d8081..eee219c6 100644
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
> @@ -476,16 +477,21 @@ xfs_attr_set_iter(
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
> +		if (!xfs_hasdelattr(mp)) {
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
> @@ -587,17 +593,21 @@ xfs_attr_set_iter(
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
> +		if (!xfs_hasdelattr(mp)) {
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
> @@ -1241,7 +1251,6 @@ xfs_attr_node_addname_clear_incomplete(
>  	 * Re-find the "old" attribute entry after any split ops. The INCOMPLETE
>  	 * flag means that we will find the "old" attr, not the "new" one.
>  	 */
> -	args->attr_filter |= XFS_ATTR_INCOMPLETE;
>  	state = xfs_da_state_alloc(args);
>  	state->inleaf = 0;
>  	error = xfs_da3_node_lookup_int(state, &retval);
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index b910bd2..a9116ee 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -1482,7 +1482,8 @@ xfs_attr3_leaf_add_work(
>  	if (tmp)
>  		entry->flags |= XFS_ATTR_LOCAL;
>  	if (args->op_flags & XFS_DA_OP_RENAME) {
> -		entry->flags |= XFS_ATTR_INCOMPLETE;
> +		if (!xfs_hasdelattr(mp))
> +			entry->flags |= XFS_ATTR_INCOMPLETE;
>  		if ((args->blkno2 == args->blkno) &&
>  		    (args->index2 <= args->index)) {
>  			args->index2++;


-- 
chandan
