Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA8C9C433E9
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Mar 2021 20:37:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3C1D601FD
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Mar 2021 20:37:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237086AbhCAUhS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Mar 2021 15:37:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:51358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237087AbhCAUdr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 Mar 2021 15:33:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1FC664DF3;
        Mon,  1 Mar 2021 18:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614622817;
        bh=205xJWOraGqWBUSuFWL4DiVdXXsyIocV6+2K8TFIRWw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U6DnaxaU5a+dDOeSl/iJia4ebKVevoa1rqFJPESKvMbPZin0O08NhiLgoA8atU2eO
         yLtg/6smDUoHRyKAH4b9P7O82pFMKM3pNDAV0tLjt714cTpBhsCoG13/kczuyKjFHh
         T5GZ5i6Nm9w5d3EXisw7mPFpL/kGec8R4z4xOTQeFIkGfQf+9witrcOdCAxqXyMVgV
         zWJY1/AGeUw3YKhnBOSQeayOhieb+hLJn96X2IKOrY9/dEBKlndiKc8QKGT7shyGoP
         tX/kbaHbgwVVJnP/ii0cgywttubZjcITSxhflXbE7jWnJRUqHxHHWb4F5+HS2Lju4e
         SD9Uw+Yrs9Vdg==
Date:   Mon, 1 Mar 2021 10:20:16 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v15 10/22] xfs: Hoist node transaction handling
Message-ID: <20210301182016.GJ7272@magnolia>
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-11-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210218165348.4754-11-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 18, 2021 at 09:53:36AM -0700, Allison Henderson wrote:
> This patch basically hoists the node transaction handling around the
> leaf code we just hoisted.  This will helps setup this area for the
> state machine since the goto is easily replaced with a state since it
> ends with a transaction roll.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 53 +++++++++++++++++++++++++-----------------------
>  1 file changed, 28 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index bfd4466..56d4b56 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -288,8 +288,34 @@ xfs_attr_set_args(
>  
>  	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>  		error = xfs_attr_leaf_try_add(args, bp);
> -		if (error == -ENOSPC)
> +		if (error == -ENOSPC) {
> +			/*
> +			 * Promote the attribute list to the Btree format.
> +			 */
> +			error = xfs_attr3_leaf_to_node(args);
> +			if (error)
> +				return error;
> +
> +			/*
> +			 * Finish any deferred work items and roll the transaction once
> +			 * more.  The goal here is to call node_addname with the inode
> +			 * and transaction in the same state (inode locked and joined,
> +			 * transaction clean) no matter how we got to this step.
> +			 */
> +			error = xfs_defer_finish(&args->trans);
> +			if (error)
> +				return error;
> +
> +			/*
> +			 * Commit the current trans (including the inode) and
> +			 * start a new one.
> +			 */
> +			error = xfs_trans_roll_inode(&args->trans, dp);
> +			if (error)
> +				return error;
> +
>  			goto node;
> +		}
>  		else if (error)
>  			return error;

With the braces and indenting fixed the way Brian said,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  
> @@ -381,32 +407,9 @@ xfs_attr_set_args(
>  			/* bp is gone due to xfs_da_shrink_inode */
>  
>  		return error;
> +	}
>  node:
> -		/*
> -		 * Promote the attribute list to the Btree format.
> -		 */
> -		error = xfs_attr3_leaf_to_node(args);
> -		if (error)
> -			return error;
> -
> -		/*
> -		 * Finish any deferred work items and roll the transaction once
> -		 * more.  The goal here is to call node_addname with the inode
> -		 * and transaction in the same state (inode locked and joined,
> -		 * transaction clean) no matter how we got to this step.
> -		 */
> -		error = xfs_defer_finish(&args->trans);
> -		if (error)
> -			return error;
>  
> -		/*
> -		 * Commit the current trans (including the inode) and
> -		 * start a new one.
> -		 */
> -		error = xfs_trans_roll_inode(&args->trans, dp);
> -		if (error)
> -			return error;
> -	}
>  
>  	do {
>  		error = xfs_attr_node_addname_find_attr(args, &state);
> -- 
> 2.7.4
> 
