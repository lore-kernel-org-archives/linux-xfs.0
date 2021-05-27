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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A414DC47089
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 07:03:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C9EE610A2
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 07:03:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234190AbhE0HEk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 May 2021 03:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233092AbhE0HEj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 May 2021 03:04:39 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30262C061574
        for <linux-xfs@vger.kernel.org>; Thu, 27 May 2021 00:03:06 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id y202so2928172pfc.6
        for <linux-xfs@vger.kernel.org>; Thu, 27 May 2021 00:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=in4kmkkhUZ6Y1ByycaIAGwd2vwBoZ2rLcQgMz7mvWOU=;
        b=QVqNjxqAFTLb33qhPpibvZ5kCx38uyjsqQRuEhY2Kkn9uG5GBPQLGMA9AfjH6HWgTx
         aoiHnWgVIvPiFJnjfA3a7bZcFiUJcmk+b/q7G1sZTmkbdKs4XIPIEDekbc4Pc8zFvAEI
         3YXPjJ2wSrx0lqebneyxhID1LqtjOb6O6BLGjw06k4ZuJh3vPybcrqlAuNrsB5rD1N8l
         vrUTpSZ1vB/3V6nfTSKjMC2ci7NT/ByRyeSTXSeIl3/5rnb24Hzpng8ocbOwDXdgqB/K
         p28+7C+Um0Zd1/89roKvfxnh/I08adkmwFzt7JAv3U/rLeR8BXC041MEinGwiWqiLGeH
         +b1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=in4kmkkhUZ6Y1ByycaIAGwd2vwBoZ2rLcQgMz7mvWOU=;
        b=GUytU6wTpD2yED22UzTdnTxuAhOKW+aIidbcdYdpq0e9AZIbYLovFTcHpMi7L3i/W9
         bX8UfYeE6/uPVkReZmtvEPNP4JlDBTLiQ2ws8hS/cHMBQqqTSPKyFGJanwcokSlKZ9fb
         xce6OAxc9HBe5TJsp7OKkrVP5/O8OZn2ZG/wCTjh6ed3ZVuDKOjC1Qi1EffcaRkbultU
         arl5YBaMu6gG1uczimPyXhRH8UoXicO0N8pCfjX0WE0Wux2kWo6Qn/T1dWAmE9X2NbJN
         JhEBBCdc8wFY5uxBZD3qRXmEt4DNjzsllrZGP3wAjZwDqESxndUew/ebezave+B9iulQ
         wQ0Q==
X-Gm-Message-State: AOAM531njoe/YkSYLYQHBnPvkQal/xlKO8n3WjOjcRFDW56ffMsLZDCJ
        MxfUT5/Exd0feWi8k0U9vAloV6kCA07uYg==
X-Google-Smtp-Source: ABdhPJxCQf6LTfoqgixVLbiHIovURpw5JNT0iE9ig3hBy7rZqMBnaB4PucqqJTN4ZbPVBgPwJ+e6YA==
X-Received: by 2002:a63:2bd5:: with SMTP id r204mr2339790pgr.426.1622098985065;
        Thu, 27 May 2021 00:03:05 -0700 (PDT)
Received: from garuda ([122.171.209.190])
        by smtp.gmail.com with ESMTPSA id z22sm1139282pfa.157.2021.05.27.00.03.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 27 May 2021 00:03:04 -0700 (PDT)
References: <20210525195504.7332-1-allison.henderson@oracle.com> <20210525195504.7332-13-allison.henderson@oracle.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v19 12/14] xfs: Clean up xfs_attr_node_addname_clear_incomplete
In-reply-to: <20210525195504.7332-13-allison.henderson@oracle.com>
Date:   Thu, 27 May 2021 12:33:00 +0530
Message-ID: <87h7ioodzv.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 26 May 2021 at 01:25, Allison Henderson wrote:
> We can use the helper function xfs_attr_node_remove_name to reduce
> duplicate code in this function
>

Looks good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
>
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index f7b0e79..32d451b 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -63,6 +63,8 @@ STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>  STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
>  STATIC int xfs_attr_set_iter(struct xfs_delattr_context *dac,
>  			     struct xfs_buf **leaf_bp);
> +STATIC int xfs_attr_node_remove_name(struct xfs_da_args *args,
> +				     struct xfs_da_state *state);
>  
>  int
>  xfs_inode_hasattr(
> @@ -1207,7 +1209,6 @@ xfs_attr_node_addname_clear_incomplete(
>  {
>  	struct xfs_da_args		*args = dac->da_args;
>  	struct xfs_da_state		*state = NULL;
> -	struct xfs_da_state_blk		*blk;
>  	int				retval = 0;
>  	int				error = 0;
>  
> @@ -1222,13 +1223,7 @@ xfs_attr_node_addname_clear_incomplete(
>  	if (error)
>  		goto out;
>  
> -	/*
> -	 * Remove the name and update the hashvals in the tree.
> -	 */
> -	blk = &state->path.blk[state->path.active-1];
> -	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
> -	error = xfs_attr3_leaf_remove(blk->bp, args);
> -	xfs_da3_fixhashpath(state, &state->path);
> +	error = xfs_attr_node_remove_name(args, state);
>  
>  	/*
>  	 * Check to see if the tree needs to be collapsed.


-- 
chandan
