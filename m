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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5AB8C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Dec 2020 06:46:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 488C62151B
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Dec 2020 06:46:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbgLUGqE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Dec 2020 01:46:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbgLUGqE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Dec 2020 01:46:04 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5B14C0613D3
        for <linux-xfs@vger.kernel.org>; Sun, 20 Dec 2020 22:45:23 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id c79so5931098pfc.2
        for <linux-xfs@vger.kernel.org>; Sun, 20 Dec 2020 22:45:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KDk053WZ/gKyCjCFzNd6ePWSBrVK9vVzt2tkmDj3gLc=;
        b=VMqYA6UBWc6ihNNXNFHWPrW5hnBH3NPOWYXoZ0plwkMzQgpgvcenXyCg1mpUgxmFy8
         a8OQcV4/q+2S3ICguBDT74ShGwnYkY7MkAe8Qb0wXmsyqeqQUnCs0FMD7tjuACJiXmHb
         P/PoOoU4QWGSn9S1/4/iWkUvbNIXHllgb4upFw/HCXty6ZINeGJngu/1fzhx5M7Mxbp+
         BqWe4rmmv1Wxs0Ba0qi9IXDnM0zcAA2cRfzvXpOs9D7072IvJNbwPfy7KFdnu+44G/vQ
         H0af7jSRLcVszdQD1FgyW4L/+wxXqwKH5RlnD6mFlvqqj5LqDoliVg/TU+GOCo6Wk4ld
         yWtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KDk053WZ/gKyCjCFzNd6ePWSBrVK9vVzt2tkmDj3gLc=;
        b=OHJu87/GHqqGnLeW2QbL1eUJPvsTbYsPegiIrW6w4teP88QzQNm8nBTXuE90e3cFbG
         CBuqo+C8FFKYt536Mz/sbuMLfxMqUt6JtRFaDsw8sCyTYmNiJ6zWHN03f9LaGOz0cBqZ
         4b5SNgdAICMJbAs87broxF+P6eV9jBCalQDHXIlpD/je26NA8IZNb/Th8WWRGfU5L3FW
         OBja6KaiRofas8Svd9A65fwKI5WqddHUuFoTpImrOSCPJQpKBo10m1ezLmIUi6H2UiGI
         a7NwvwDrpfVPLg2AoqdF/sxWqteNOMY86RE7jUCxXePHXoOWbW6MVfNY0UJWc+Jmy/Jv
         jWJQ==
X-Gm-Message-State: AOAM531Ha6drxIWoS+KJv+ZgykdCw5rmfLLs3uSWVXZJ1H2yOCrmf4f/
        rHJWhinYRiqArTDaHaedwAc=
X-Google-Smtp-Source: ABdhPJy9x2am6e/dgkaud1Tq5d1Q0wOh5OWqry5r5YCpaaePed2SnCbDHkmGzFU5tbZVhQ06w4mTmQ==
X-Received: by 2002:a63:f12:: with SMTP id e18mr14371161pgl.101.1608533123264;
        Sun, 20 Dec 2020 22:45:23 -0800 (PST)
Received: from garuda.localnet ([122.179.35.127])
        by smtp.gmail.com with ESMTPSA id a26sm366426pgm.4.2020.12.20.22.45.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Dec 2020 22:45:22 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v14 01/15] xfs: Add helper xfs_attr_node_remove_step
Date:   Mon, 21 Dec 2020 12:15:20 +0530
Message-ID: <7926169.lSfAI5dGga@garuda>
In-Reply-To: <20201218072917.16805-2-allison.henderson@oracle.com>
References: <20201218072917.16805-1-allison.henderson@oracle.com> <20201218072917.16805-2-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, 18 Dec 2020 00:29:03 -0700, Allison Henderson wrote:
> From: Allison Collins <allison.henderson@oracle.com>
> 
> This patch as a new helper function xfs_attr_node_remove_step.  This

The above should probably be "This patch adds a new ...".

> will help simplify and modularize the calling function
> xfs_attr_node_remove.

The calling function is xfs_attr_node_removename.

Other than the above mentioned nits, the changes look good to me,

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 46 ++++++++++++++++++++++++++++++++++------------
>  1 file changed, 34 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index fd8e641..8b55a8d 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1228,19 +1228,14 @@ xfs_attr_node_remove_rmt(
>   * the root node (a special case of an intermediate node).
>   */
>  STATIC int
> -xfs_attr_node_removename(
> -	struct xfs_da_args	*args)
> +xfs_attr_node_remove_step(
> +	struct xfs_da_args	*args,
> +	struct xfs_da_state	*state)
>  {
> -	struct xfs_da_state	*state;
>  	struct xfs_da_state_blk	*blk;
>  	int			retval, error;
>  	struct xfs_inode	*dp = args->dp;
>  
> -	trace_xfs_attr_node_removename(args);
> -
> -	error = xfs_attr_node_removename_setup(args, &state);
> -	if (error)
> -		goto out;
>  
>  	/*
>  	 * If there is an out-of-line value, de-allocate the blocks.
> @@ -1250,7 +1245,7 @@ xfs_attr_node_removename(
>  	if (args->rmtblkno > 0) {
>  		error = xfs_attr_node_remove_rmt(args, state);
>  		if (error)
> -			goto out;
> +			return error;
>  	}
>  
>  	/*
> @@ -1267,18 +1262,45 @@ xfs_attr_node_removename(
>  	if (retval && (state->path.active > 1)) {
>  		error = xfs_da3_join(state);
>  		if (error)
> -			goto out;
> +			return error;
>  		error = xfs_defer_finish(&args->trans);
>  		if (error)
> -			goto out;
> +			return error;
>  		/*
>  		 * Commit the Btree join operation and start a new trans.
>  		 */
>  		error = xfs_trans_roll_inode(&args->trans, dp);
>  		if (error)
> -			goto out;
> +			return error;
>  	}
>  
> +	return error;
> +}
> +
> +/*
> + * Remove a name from a B-tree attribute list.
> + *
> + * This routine will find the blocks of the name to remove, remove them and
> + * shrink the tree if needed.
> + */
> +STATIC int
> +xfs_attr_node_removename(
> +	struct xfs_da_args	*args)
> +{
> +	struct xfs_da_state	*state = NULL;
> +	int			error;
> +	struct xfs_inode	*dp = args->dp;
> +
> +	trace_xfs_attr_node_removename(args);
> +
> +	error = xfs_attr_node_removename_setup(args, &state);
> +	if (error)
> +		goto out;
> +
> +	error = xfs_attr_node_remove_step(args, state);
> +	if (error)
> +		goto out;
> +
>  	/*
>  	 * If the result is small enough, push it all into the inode.
>  	 */
> 


-- 
chandan



