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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83C54C47082
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Jun 2021 08:35:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6304A610C8
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Jun 2021 08:35:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbhFGIhX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Jun 2021 04:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbhFGIhX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Jun 2021 04:37:23 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C12C061766
        for <linux-xfs@vger.kernel.org>; Mon,  7 Jun 2021 01:35:26 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id q25so12547030pfh.7
        for <linux-xfs@vger.kernel.org>; Mon, 07 Jun 2021 01:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=NDXUUQ34z2dzbXUZUAU2Okrpml8dfpFJgZ1JgcD7Ol4=;
        b=dJ5ic9/CS+D/bAovvoyhUJ7ND++TafHPrkY6Gt+HwEgIc5SDMfgDGTS0yT14x5L2hG
         k3V5PORbYPlYjnYyWjjDpzVdJUBATqy24VXJcJYEwW4Y0btyxUN7hgBe5uzcbt/jsa/X
         wmEJ/do0R5O4aS1WXOfCc8ays5n7t2UkPNiF23/tOdPh/E4CxErI3t1PktrQDR6qlMUr
         kL/Vw7G9C2P5/6xWjmU9HRN1Y4/W7Wjd9aogs4GKuTFmysv7wJEWtLc2jAyHR6J9EZwA
         ZcmstRNnOb0DA38kuKPBsjCkpJE1ZrVTmQtcvzDE0OCK33BdnZDhBCEO4pQR/9vRd2oO
         cLYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=NDXUUQ34z2dzbXUZUAU2Okrpml8dfpFJgZ1JgcD7Ol4=;
        b=OJvaoqqTNkJ8VmSgIWUaJ/TveL17r7D9FHtxWArDWhzFUChTaJqM3fDVFpi8QkSq5b
         u0Hyc59Q3JwFm7qhZ5D33a2xVFyfQnuefsOssGFDGM7G2ijRBlwBSl0fK8GBHfsoZ9TE
         yBzbX+TTjm+deQlb81hHS2dWI14wxL0oEawPioddp6VatUJi+pxAjNcgnsyVJ8xGRykV
         JmZTju536fYARxSguc4LQs46/0/bBR7uMnqBATxN2O8GeczXEsZ50ULmswXJtejev5U2
         g3fsr/n7fpAY01OpLVvqtbkCRSglvb/VCk5VJoJtRoDtC9JlX1UICgBW1o4oc3vsluM4
         rzgg==
X-Gm-Message-State: AOAM531Wl2UPIXKkH/gUSTP+devjFlgHWWu8VPmV6HMqmAIw6RlZ2YXf
        pEnXJpC9QiJQR4nKxBJSs68V9X6Uo7Mjpg==
X-Google-Smtp-Source: ABdhPJzuTlvM4iB10espL5o6LMNvYpLPP53/S5aeUG+OO0FNX4XvI2i9VKMubskZ2Dc6dAGqgIz9uA==
X-Received: by 2002:aa7:860a:0:b029:2e9:f8cb:489c with SMTP id p10-20020aa7860a0000b02902e9f8cb489cmr16077703pfn.50.1623054925468;
        Mon, 07 Jun 2021 01:35:25 -0700 (PDT)
Received: from garuda ([122.179.77.39])
        by smtp.gmail.com with ESMTPSA id n8sm11591837pjo.1.2021.06.07.01.35.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 07 Jun 2021 01:35:25 -0700 (PDT)
References: <20210607052747.31422-1-allison.henderson@oracle.com> <20210607052747.31422-5-allison.henderson@oracle.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v20 14/14] xfs: Make attr name schemes consistent
In-reply-to: <20210607052747.31422-5-allison.henderson@oracle.com>
Date:   Mon, 07 Jun 2021 14:05:22 +0530
Message-ID: <87fsxukr79.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 07 Jun 2021 at 10:57, Allison Henderson wrote:
> This patch renames the following functions to make the nameing scheme more consistent:
> xfs_attr_shortform_remove -> xfs_attr_sf_removename
> xfs_attr_node_remove_name -> xfs_attr_node_removename
> xfs_attr_set_fmt -> xfs_attr_sf_addname
>

Looks good to me.

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
> index a0edebc..611dc67 100644
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
> @@ -840,7 +840,7 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
>  	if (retval == -EEXIST) {
>  		if (args->attr_flags & XATTR_CREATE)
>  			return retval;
> -		retval = xfs_attr_shortform_remove(args);
> +		retval = xfs_attr_sf_removename(args);
>  		if (retval)
>  			return retval;
>  		/*
> @@ -1223,7 +1223,7 @@ xfs_attr_node_addname_clear_incomplete(
>  	if (error)
>  		goto out;
>  
> -	error = xfs_attr_node_remove_name(args, state);
> +	error = xfs_attr_node_removename(args, state);
>  
>  	/*
>  	 * Check to see if the tree needs to be collapsed.
> @@ -1339,7 +1339,7 @@ int xfs_attr_node_removename_setup(
>  }
>  
>  STATIC int
> -xfs_attr_node_remove_name(
> +xfs_attr_node_removename(
>  	struct xfs_da_args	*args,
>  	struct xfs_da_state	*state)
>  {
> @@ -1390,7 +1390,7 @@ xfs_attr_remove_iter(
>  		 * thus state transitions. Call the right helper and return.
>  		 */
>  		if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL)
> -			return xfs_attr_shortform_remove(args);
> +			return xfs_attr_sf_removename(args);
>  
>  		if (xfs_attr_is_leaf(dp))
>  			return xfs_attr_leaf_removename(args);
> @@ -1453,7 +1453,7 @@ xfs_attr_remove_iter(
>  				goto out;
>  		}
>  
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
