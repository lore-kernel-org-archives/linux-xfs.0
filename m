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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D9EBC433B4
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 04:05:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65917610EA
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 04:05:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbhDBEFo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Apr 2021 00:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbhDBEFo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Apr 2021 00:05:44 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6847C0613E6
        for <linux-xfs@vger.kernel.org>; Thu,  1 Apr 2021 21:05:43 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id y3so94339pgi.0
        for <linux-xfs@vger.kernel.org>; Thu, 01 Apr 2021 21:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=AEQcF3IHMhokZivh5SlaSiOYf+2LyULDNy+Z4mSws6U=;
        b=fYNOym/gNJ6IvO6cGciGCniC9ZBFjS6C20OZxk5OYETUlgYsWdYrVV9aNchR21OdsM
         0+zTwEGrFTsgpgBsE6/eGF3Po+Xr9dZRaNmuaVkYKEP3EIa0Fh++k6Jdq9QJWm2/SEl/
         8Iw2xq1Pty3UEkQ+hYNjXnPTgYy+HpyxDA7Yx0rvmrK3ZvSQkxS234N4uwMRPW+dg3kP
         xegQGK6U0Xgw8RNsKwF5OZPQYQRmK7chDAya1+A52MlL57GSEbn1Y0JK8ea3OFLQrFq0
         FoiifamgKVLNS87V3gUHUgye1WTM4mLE99bDDNr7vET2aNeIs2KpASQ7DdpQvGbKT7YF
         vZww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=AEQcF3IHMhokZivh5SlaSiOYf+2LyULDNy+Z4mSws6U=;
        b=jYb3FDV17T5K0BOldGHRfWLITYdbDxLsS5nXd0Th805yR+h65LQsGgL7ZB5oJnd62d
         6fKPD3LxjAgYnrhdEf9Cv44x/JpxOwZDyFmWNjS32ctfhhfxwccmEZSDqezmP//V993M
         tjGyVJoKKesmkXHsCPgHfLVciHn/9sxhKY1CH2FUrG51wlXS/e6cA5hx/xWabHdS1M1+
         ty8GYLJGo+WwdWraHyuNmkz79vy+ylSRfHtrwKdLHymW2s8L98MKlP9ZxiBbr4D5d9jH
         f440wmpZF4EeaktAHsI++IIlk4rjAnSx0uWT1GzMXTrjfXEZWkLzZ9XWN53aTvvEncqz
         6jbg==
X-Gm-Message-State: AOAM5316Fz34Fq/fP2gcCzgVVhccUxizp4SHqzdOg3/AESiZLZ8/DaBs
        nlzhxn399KpgXKBD5C55Br/yfc6wvt4=
X-Google-Smtp-Source: ABdhPJxbvrsQPYfmsbLF5VDh/LJ9SmWy0/p4yUC/99pBAfzOIdTREpqUfQ8QBdvZDHFSFzvEa7DUEg==
X-Received: by 2002:a63:5425:: with SMTP id i37mr4560443pgb.141.1617336343027;
        Thu, 01 Apr 2021 21:05:43 -0700 (PDT)
Received: from garuda ([122.171.33.103])
        by smtp.gmail.com with ESMTPSA id w17sm6825414pgg.41.2021.04.01.21.05.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 01 Apr 2021 21:05:42 -0700 (PDT)
References: <20210326003308.32753-1-allison.henderson@oracle.com> <20210326003308.32753-7-allison.henderson@oracle.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v16 06/11] xfs: Add helper xfs_attr_node_addname_find_attr
In-reply-to: <20210326003308.32753-7-allison.henderson@oracle.com>
Date:   Fri, 02 Apr 2021 09:35:39 +0530
Message-ID: <87tuop72lo.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 26 Mar 2021 at 06:03, Allison Henderson wrote:
> This patch separates the first half of xfs_attr_node_addname into a
> helper function xfs_attr_node_addname_find_attr.  It also replaces the
> restart goto with with an EAGAIN return code driven by a loop in the
> calling function.  This looks odd now, but will clean up nicly once we
> introduce the state machine.  It will also enable hoisting the last
> state out of xfs_attr_node_addname with out having to plumb in a "done"
> parameter to know if we need to move to the next state or not.
>

Looks good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 86 ++++++++++++++++++++++++++++++------------------
>  1 file changed, 54 insertions(+), 32 deletions(-)
>
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 531ff56..16159f6 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -52,7 +52,10 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
>   * Internal routines when attribute list is more than one block.
>   */
>  STATIC int xfs_attr_node_get(xfs_da_args_t *args);
> -STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
> +STATIC int xfs_attr_node_addname(struct xfs_da_args *args,
> +				 struct xfs_da_state *state);
> +STATIC int xfs_attr_node_addname_find_attr(struct xfs_da_args *args,
> +				 struct xfs_da_state **state);
>  STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
>  STATIC int xfs_attr_node_addname_clear_incomplete(struct xfs_da_args *args);
>  STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
> @@ -267,6 +270,7 @@ xfs_attr_set_args(
>  	struct xfs_da_args	*args)
>  {
>  	struct xfs_inode	*dp = args->dp;
> +	struct xfs_da_state     *state;
>  	int			error;
>  
>  	/*
> @@ -312,7 +316,14 @@ xfs_attr_set_args(
>  			return error;
>  	}
>  
> -	return xfs_attr_node_addname(args);
> +	do {
> +		error = xfs_attr_node_addname_find_attr(args, &state);
> +		if (error)
> +			return error;
> +		error = xfs_attr_node_addname(args, state);
> +	} while (error == -EAGAIN);
> +
> +	return error;
>  }
>  
>  /*
> @@ -885,47 +896,26 @@ xfs_attr_node_hasname(
>   * External routines when attribute list size > geo->blksize
>   *========================================================================*/
>  
> -/*
> - * Add a name to a Btree-format attribute list.
> - *
> - * This will involve walking down the Btree, and may involve splitting
> - * leaf nodes and even splitting intermediate nodes up to and including
> - * the root node (a special case of an intermediate node).
> - *
> - * "Remote" attribute values confuse the issue and atomic rename operations
> - * add a whole extra layer of confusion on top of that.
> - */
>  STATIC int
> -xfs_attr_node_addname(
> -	struct xfs_da_args	*args)
> +xfs_attr_node_addname_find_attr(
> +	struct xfs_da_args	*args,
> +	struct xfs_da_state     **state)
>  {
> -	struct xfs_da_state	*state;
> -	struct xfs_da_state_blk	*blk;
> -	struct xfs_inode	*dp;
> -	int			retval, error;
> -
> -	trace_xfs_attr_node_addname(args);
> +	int			retval;
>  
>  	/*
> -	 * Fill in bucket of arguments/results/context to carry around.
> -	 */
> -	dp = args->dp;
> -restart:
> -	/*
>  	 * Search to see if name already exists, and get back a pointer
>  	 * to where it should go.
>  	 */
> -	retval = xfs_attr_node_hasname(args, &state);
> +	retval = xfs_attr_node_hasname(args, state);
>  	if (retval != -ENOATTR && retval != -EEXIST)
> -		goto out;
> +		goto error;
>  
> -	blk = &state->path.blk[ state->path.active-1 ];
> -	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
>  	if (retval == -ENOATTR && (args->attr_flags & XATTR_REPLACE))
> -		goto out;
> +		goto error;
>  	if (retval == -EEXIST) {
>  		if (args->attr_flags & XATTR_CREATE)
> -			goto out;
> +			goto error;
>  
>  		trace_xfs_attr_node_replace(args);
>  
> @@ -943,6 +933,38 @@ xfs_attr_node_addname(
>  		args->rmtvaluelen = 0;
>  	}
>  
> +	return 0;
> +error:
> +	if (*state)
> +		xfs_da_state_free(*state);
> +	return retval;
> +}
> +
> +/*
> + * Add a name to a Btree-format attribute list.
> + *
> + * This will involve walking down the Btree, and may involve splitting
> + * leaf nodes and even splitting intermediate nodes up to and including
> + * the root node (a special case of an intermediate node).
> + *
> + * "Remote" attribute values confuse the issue and atomic rename operations
> + * add a whole extra layer of confusion on top of that.
> + */
> +STATIC int
> +xfs_attr_node_addname(
> +	struct xfs_da_args	*args,
> +	struct xfs_da_state	*state)
> +{
> +	struct xfs_da_state_blk	*blk;
> +	struct xfs_inode	*dp;
> +	int			retval, error;
> +
> +	trace_xfs_attr_node_addname(args);
> +
> +	dp = args->dp;
> +	blk = &state->path.blk[state->path.active-1];
> +	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
> +
>  	retval = xfs_attr3_leaf_add(blk->bp, state->args);
>  	if (retval == -ENOSPC) {
>  		if (state->path.active == 1) {
> @@ -968,7 +990,7 @@ xfs_attr_node_addname(
>  			if (error)
>  				goto out;
>  
> -			goto restart;
> +			return -EAGAIN;
>  		}
>  
>  		/*


-- 
chandan
