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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61DF7C47089
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 08:02:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 432A7613AC
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 08:02:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235109AbhE0IDV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 May 2021 04:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234529AbhE0IDG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 May 2021 04:03:06 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D08C061760
        for <linux-xfs@vger.kernel.org>; Thu, 27 May 2021 01:01:22 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 29so3084987pgu.11
        for <linux-xfs@vger.kernel.org>; Thu, 27 May 2021 01:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=tEgsXGu1JQUQJCv8clnNei+WfgQqArW10zMob0EnAFw=;
        b=QAr5GV9ZzIq3NPN8MjY2BM8I26E2tuAO7O3duAEs6fT7t/j5YOhD+AnDTv/XGTcMiB
         PFv+R0WAfmJLSuNkemAu5TLTAM4NmyATW1YZ0mj+mmNr7FJngbryq2evDeiaRuWS1sgL
         2TMPg96ccevwa9D9Ni30EIZ15O4uSSgrDaExxJx9oF3VmtSd9uGrH+zrwP5IWkODthsk
         goYpIfIKZh48aks1JWUJdelm0VdE8CHjjS4UM2BTSJ1hT0qhTQQUqDYcsR9WSPWn3dIr
         gHv7t5BQCfDIbHYWgtZcalLjkr9XT7EybssefJ3Vp+ea3gvVxWFVn87Zmm24q/wNOqRI
         yrag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=tEgsXGu1JQUQJCv8clnNei+WfgQqArW10zMob0EnAFw=;
        b=t4jc1tvwl+cRNdZhdsiseQx+WzgWYVyfIaj9EU4iy+S7XFKeu1ty415vKlRhG1s1YU
         /EXEl/8Z4T5cGMUq7uIyqxk/af6rxpq5BR8qEkT6atZJFdzYrze701eEZM/0UU+KVa5G
         YvcNGgRe9uPZSmpkZafVLbPpztruMIM8IsBBrl/SO38c85EcLElMB53gKoIpFabSkEXS
         9qO35plCp9+NQ38u7BPt0K3BZK3mcZ1+K591T+mJ0Who5rHr8QLwZlFy/pt5Ni1U3y9R
         7MaqnQSc4M7btXiFxaTPKAG8jNRb6q+LyadfkhPQX9R5PVOaZ+7N1jWUc1TE60j4lWyK
         Uq/Q==
X-Gm-Message-State: AOAM533v0Nhj0OeCchL+VQdWki7ksQIoy731NUMYf6pjTzAR1NpZw33L
        omI0SUDw3GRuYpidin9zC2GxMuuhmoqYIQ==
X-Google-Smtp-Source: ABdhPJwp2lALKmR/zRa2lq2y3MVIk0lZoSoxPACUBvAGS2NT1Jwgest+/xOevvR5gPsDLFUdI9fxOg==
X-Received: by 2002:a62:1b47:0:b029:2e8:ff52:16ab with SMTP id b68-20020a621b470000b02902e8ff5216abmr2562599pfb.5.1622102481618;
        Thu, 27 May 2021 01:01:21 -0700 (PDT)
Received: from garuda ([122.171.209.190])
        by smtp.gmail.com with ESMTPSA id 4sm1095290pgn.31.2021.05.27.01.01.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 27 May 2021 01:01:21 -0700 (PDT)
References: <20210525195504.7332-1-allison.henderson@oracle.com> <20210525195504.7332-15-allison.henderson@oracle.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v19 14/14] xfs: Make attr name schemes consistent
In-reply-to: <20210525195504.7332-15-allison.henderson@oracle.com>
Date:   Thu, 27 May 2021 13:31:18 +0530
Message-ID: <87eedsobap.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 26 May 2021 at 01:25, Allison Henderson wrote:
> This patch renames the following functions to make the nameing scheme more consistent:
> xfs_attr_shortform_remove -> xfs_attr_sf_removename
> xfs_attr_node_remove_name -> xfs_attr_node_removename
> xfs_attr_set_fmt -> xfs_attr_sf_addname
>

Looks good.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Suggested-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c      | 18 +++++++++---------
>  fs/xfs/libxfs/xfs_attr_leaf.c |  2 +-
>  fs/xfs/libxfs/xfs_attr_leaf.h |  2 +-
>  3 files changed, 11 insertions(+), 11 deletions(-)
>
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 7294a2e..20b1e3c 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -63,8 +63,8 @@ STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>  STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
>  STATIC int xfs_attr_set_iter(struct xfs_delattr_context *dac,
>  			     struct xfs_buf **leaf_bp);
> -STATIC int xfs_attr_node_remove_name(struct xfs_da_args *args,
> -				     struct xfs_da_state *state);
> +STATIC int xfs_attr_node_removename(struct xfs_da_args *args,
> +				    struct xfs_da_state *state);
>  
>  int
>  xfs_inode_hasattr(
> @@ -298,7 +298,7 @@ xfs_attr_set_args(
>  }
>  
>  STATIC int
> -xfs_attr_set_fmt(
> +xfs_attr_sf_addname(
>  	struct xfs_delattr_context	*dac,
>  	struct xfs_buf			**leaf_bp)
>  {
> @@ -367,7 +367,7 @@ xfs_attr_set_iter(
>  		 * release the hold once we return with a clean transaction.
>  		 */
>  		if (xfs_attr_is_shortform(dp))
> -			return xfs_attr_set_fmt(dac, leaf_bp);
> +			return xfs_attr_sf_addname(dac, leaf_bp);
>  		if (*leaf_bp != NULL) {
>  			xfs_trans_bhold_release(args->trans, *leaf_bp);
>  			*leaf_bp = NULL;
> @@ -839,7 +839,7 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
>  	if (retval == -EEXIST) {
>  		if (args->attr_flags & XATTR_CREATE)
>  			return retval;
> -		retval = xfs_attr_shortform_remove(args);
> +		retval = xfs_attr_sf_removename(args);
>  		if (retval)
>  			return retval;
>  		/*
> @@ -1222,7 +1222,7 @@ xfs_attr_node_addname_clear_incomplete(
>  	if (error)
>  		goto out;
>  
> -	error = xfs_attr_node_remove_name(args, state);
> +	error = xfs_attr_node_removename(args, state);
>  
>  	/*
>  	 * Check to see if the tree needs to be collapsed.
> @@ -1338,7 +1338,7 @@ int xfs_attr_node_removename_setup(
>  }
>  
>  STATIC int
> -xfs_attr_node_remove_name(
> +xfs_attr_node_removename(
>  	struct xfs_da_args	*args,
>  	struct xfs_da_state	*state)
>  {
> @@ -1389,7 +1389,7 @@ xfs_attr_remove_iter(
>  		 * thus state transitions. Call the right helper and return.
>  		 */
>  		if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL)
> -			return xfs_attr_shortform_remove(args);
> +			return xfs_attr_sf_removename(args);
>  
>  		if (xfs_attr_is_leaf(dp))
>  			return xfs_attr_leaf_removename(args);
> @@ -1442,7 +1442,7 @@ xfs_attr_remove_iter(
>  
>  		/* fallthrough */
>  	case XFS_DAS_RM_NAME:
> -		retval = xfs_attr_node_remove_name(args, state);
> +		retval = xfs_attr_node_removename(args, state);
>  
>  		/*
>  		 * Check to see if the tree needs to be collapsed. If so, roll
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index d97de20..5a3d261 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -773,7 +773,7 @@ xfs_attr_fork_remove(
>   * Remove an attribute from the shortform attribute list structure.
>   */
>  int
> -xfs_attr_shortform_remove(
> +xfs_attr_sf_removename(
>  	struct xfs_da_args		*args)
>  {
>  	struct xfs_attr_shortform	*sf;
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
> index 9b1c59f..efa757f 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.h
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.h
> @@ -51,7 +51,7 @@ int	xfs_attr_shortform_lookup(struct xfs_da_args *args);
>  int	xfs_attr_shortform_getvalue(struct xfs_da_args *args);
>  int	xfs_attr_shortform_to_leaf(struct xfs_da_args *args,
>  			struct xfs_buf **leaf_bp);
> -int	xfs_attr_shortform_remove(struct xfs_da_args *args);
> +int	xfs_attr_sf_removename(struct xfs_da_args *args);
>  int	xfs_attr_sf_findname(struct xfs_da_args *args,
>  			     struct xfs_attr_sf_entry **sfep,
>  			     unsigned int *basep);


-- 
chandan
