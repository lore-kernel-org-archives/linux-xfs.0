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
	by smtp.lore.kernel.org (Postfix) with ESMTP id F04C0C433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Dec 2020 06:46:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4F1A221F7
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Dec 2020 06:46:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728128AbgLUGq0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Dec 2020 01:46:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbgLUGq0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Dec 2020 01:46:26 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7825DC061285
        for <linux-xfs@vger.kernel.org>; Sun, 20 Dec 2020 22:45:46 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id m5so5865902pjv.5
        for <linux-xfs@vger.kernel.org>; Sun, 20 Dec 2020 22:45:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6J8pYFuPKkLI4DSvTKsT+/ZXSC29MDEH+RdF9CxcKtQ=;
        b=trKrnijnbJ7H/lW7ZV5BCSRFRhV7N7ewJPyPu1zO51OWJiI1lOzQd+Cyx+1It0MeRD
         jeWuv5lzke3iDKtOhwubXvG36h1C97sj9AqRi86zRpVZRFBSQd24P6XDhcy2VXazXnnM
         ofuxPvvanFMzKIO5Hz0kS0yBgDRtMuIL9+qgIo7MbU7rSc6ipHXO/h6hXaBt1vCj09H9
         Qe9OLKVfvantZ8BX1+T1wDEKtyCfAz5x9mzzl564sgsb6UT+E/NIALk8g1DGP3SSL64G
         +RwLZRfsODHcsFbh9kTdSGp1b4aLMHZEhgJQranYSJRCCQWXdsmC2an4ce1OkJxiVi75
         kjzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6J8pYFuPKkLI4DSvTKsT+/ZXSC29MDEH+RdF9CxcKtQ=;
        b=UvTKKTNEcxMNlvuYYRydx+JDdlCahIlhNxutMkVsbKPfPr7/aInHw4HxEPxrjZoJ2b
         +aXK4rxbYocYolMSHZ/vva8Snzh7wZiZfnPwdLSrsVw2LxyWvC38ozHB1D0/FHvbh8N0
         6m5O9F6XZwIezeJQYvSYiO8q6AZ3HbJqbE/07Fj+N4vCk0lAdAlBCuHjp563ftPIKCPg
         Nm7CGg6WXoriWOOUu1+NYsugXxrvn1XF0Ph8XvqYw8Z/BOMAFBIGdQOG0xVmi9V8gk4O
         mvjmVmMeHXN0p5b6cZQuzrZMf75JnOGV306K+UA5eJMV1k1Mop3ncFyROM3ovAiNuKYV
         NY1g==
X-Gm-Message-State: AOAM533L9gDVM47WvMAnp7tsvTZ9CVIRayG29WMUJDS2xpLxL1lCQbAs
        tGgrzfcdIsZaciVr8Ij+2hrmuR3vpJz7hg==
X-Google-Smtp-Source: ABdhPJx9DGa1j42GBVlzf2L4xnxKFMFP4Uim6qk+KAfhMjnL97ZnNwwlY49UUHuBO2I/Pry5uIh25w==
X-Received: by 2002:a17:902:b58d:b029:db:f8de:551c with SMTP id a13-20020a170902b58db02900dbf8de551cmr15127024pls.24.1608533146094;
        Sun, 20 Dec 2020 22:45:46 -0800 (PST)
Received: from garuda.localnet ([122.179.35.127])
        by smtp.gmail.com with ESMTPSA id b13sm15816358pfi.162.2020.12.20.22.45.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Dec 2020 22:45:45 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v14 03/15] xfs: Hoist transaction handling in xfs_attr_node_remove_step
Date:   Mon, 21 Dec 2020 12:15:43 +0530
Message-ID: <4105761.l86rmMIxAI@garuda>
In-Reply-To: <20201218072917.16805-4-allison.henderson@oracle.com>
References: <20201218072917.16805-1-allison.henderson@oracle.com> <20201218072917.16805-4-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, 18 Dec 2020 00:29:05 -0700, Allison Henderson wrote:
> This patch hoists transaction handling in xfs_attr_node_remove to

... "transaction handling in xfs_attr_node_removename"

> xfs_attr_node_remove_step.  This will help keep transaction handling in
> higher level functions instead of buried in subfunctions when we
> introduce delay attributes
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 43 ++++++++++++++++++++++---------------------
>  1 file changed, 22 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index e93d76a..1969b88 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1251,7 +1251,7 @@ xfs_attr_node_remove_step(
>  	struct xfs_da_args	*args,
>  	struct xfs_da_state	*state)
>  {
> -	int			retval, error;
> +	int			error;
>  	struct xfs_inode	*dp = args->dp;

The declaration of "dp" variable can be removed since there are no references
to it left after the removal of the following hunk.

>  
>  
> @@ -1265,25 +1265,6 @@ xfs_attr_node_remove_step(
>  		if (error)
>  			return error;
>  	}
> -	retval = xfs_attr_node_remove_cleanup(args, state);
> -
> -	/*
> -	 * Check to see if the tree needs to be collapsed.
> -	 */
> -	if (retval && (state->path.active > 1)) {
> -		error = xfs_da3_join(state);
> -		if (error)
> -			return error;
> -		error = xfs_defer_finish(&args->trans);
> -		if (error)
> -			return error;
> -		/*
> -		 * Commit the Btree join operation and start a new trans.
> -		 */
> -		error = xfs_trans_roll_inode(&args->trans, dp);
> -		if (error)
> -			return error;
> -	}
>  
>  	return error;
>  }
> @@ -1299,7 +1280,7 @@ xfs_attr_node_removename(
>  	struct xfs_da_args	*args)
>  {
>  	struct xfs_da_state	*state = NULL;
> -	int			error;
> +	int			retval, error;
>  	struct xfs_inode	*dp = args->dp;
>  
>  	trace_xfs_attr_node_removename(args);
> @@ -1312,6 +1293,26 @@ xfs_attr_node_removename(
>  	if (error)
>  		goto out;
>  
> +	retval = xfs_attr_node_remove_cleanup(args, state);
> +
> +	/*
> +	 * Check to see if the tree needs to be collapsed.
> +	 */
> +	if (retval && (state->path.active > 1)) {
> +		error = xfs_da3_join(state);
> +		if (error)
> +			return error;

When a non-zero value is returned by xfs_da3_join(), the code would fail to
free the memory pointed to by "state". Same review comment applies to the two
return statements below.

> +		error = xfs_defer_finish(&args->trans);
> +		if (error)
> +			return error;
> +		/*
> +		 * Commit the Btree join operation and start a new trans.
> +		 */
> +		error = xfs_trans_roll_inode(&args->trans, dp);
> +		if (error)
> +			return error;
> +	}
> +
>  	/*
>  	 * If the result is small enough, push it all into the inode.
>  	 */
> 


-- 
chandan



