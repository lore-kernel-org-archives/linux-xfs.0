Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2AF1C433B4
	for <linux-xfs@archiver.kernel.org>; Thu, 13 May 2021 23:14:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCB7261405
	for <linux-xfs@archiver.kernel.org>; Thu, 13 May 2021 23:14:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbhEMXPt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 May 2021 19:15:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:54302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229544AbhEMXPq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 May 2021 19:15:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F3A4613AA;
        Thu, 13 May 2021 23:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620947675;
        bh=Xpg233amjsPwi82/iE4Rle6a8mOX47ysFqCDp7FfUyk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TZeVX5hj4gLiR4WdQ2zaVSChwilob6Mh4yQdZIMxITm3cQkEJEWJoyZjV0QCSZH0i
         7efgaXsgiJ6Nypjgy3Q6erVz8q+sKXYuDRaWOI+gIXeVHih8Xkhw0WgRT0bEJHY7EL
         ALEKC39PA8FD2cM2ND681FfsDs+MTCzC7GzlHZvlYZx7eAiSjUZFrLCUWCyTicrk/c
         9qQe7SSWqsXPd5I0KBraLeVuEGK/SuBIkR2EqF1nmdG6dCokpkpfd0UIvfusgJnUEU
         AtOl0De+SdC1Mt5N0f3uXgiMXAh+exYBloacfMjvnqXgoWls1pu4ijF4no0YNU1KV3
         M5+vYhmn04Tqg==
Date:   Thu, 13 May 2021 16:14:34 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH RESEND v18 01/11] xfs: Reverse apply 72b97ea40d
Message-ID: <20210513231434.GC9675@magnolia>
References: <20210512161408.5516-1-allison.henderson@oracle.com>
 <20210512161408.5516-2-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210512161408.5516-2-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 12, 2021 at 09:13:58AM -0700, Allison Henderson wrote:
> Originally we added this patch to help modularize the attr code in
> preparation for delayed attributes and the state machine it requires.
> However, later reviews found that this slightly alters the transaction
> handling as the helper function is ambiguous as to whether the
> transaction is diry or clean.  This may cause a dirty transaction to be
> included in the next roll, where previously it had not.  To preserve the
> existing code flow, we reverse apply this commit.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

Looks fine I guess...
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c | 28 +++++++++-------------------
>  1 file changed, 9 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 96146f4..190b46d 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1214,24 +1214,6 @@ int xfs_attr_node_removename_setup(
>  	return 0;
>  }
>  
> -STATIC int
> -xfs_attr_node_remove_rmt(
> -	struct xfs_da_args	*args,
> -	struct xfs_da_state	*state)
> -{
> -	int			error = 0;
> -
> -	error = xfs_attr_rmtval_remove(args);
> -	if (error)
> -		return error;
> -
> -	/*
> -	 * Refill the state structure with buffers, the prior calls released our
> -	 * buffers.
> -	 */
> -	return xfs_attr_refillstate(state);
> -}
> -
>  /*
>   * Remove a name from a B-tree attribute list.
>   *
> @@ -1260,7 +1242,15 @@ xfs_attr_node_removename(
>  	 * overflow the maximum size of a transaction and/or hit a deadlock.
>  	 */
>  	if (args->rmtblkno > 0) {
> -		error = xfs_attr_node_remove_rmt(args, state);
> +		error = xfs_attr_rmtval_remove(args);
> +		if (error)
> +			goto out;
> +
> +		/*
> +		 * Refill the state structure with buffers, the prior calls
> +		 * released our buffers.
> +		 */
> +		error = xfs_attr_refillstate(state);
>  		if (error)
>  			goto out;
>  	}
> -- 
> 2.7.4
> 
