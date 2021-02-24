Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F7E7C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 18:45:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2869964F0C
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 18:45:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232933AbhBXSpC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 13:45:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45214 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231561AbhBXSpB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Feb 2021 13:45:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614192215;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AXzTwejnm0Y+RJIoyQZvBLfmo91qdJPSXWYBxN5FImc=;
        b=hmBtMsaeYys8nCbGYh3/ZJuC1yUG0zp9XJG0njncZ9VEJW5+mqptzoLCRpzV0Sp4Y0CLO3
        b1sYPS9RcbEcZwplOT8odoHJxb/ZOedr02YuHTJievaEeWcqLuK/yGTmDz8eJdM0Ee1cXk
        yAvATzO+67mJGz1s9WI15bWg0yxqsd0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-576-SErzQ3l-PfyZqjztH5dXdw-1; Wed, 24 Feb 2021 13:43:31 -0500
X-MC-Unique: SErzQ3l-PfyZqjztH5dXdw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9F375874988;
        Wed, 24 Feb 2021 18:43:30 +0000 (UTC)
Received: from bfoster (ovpn-119-92.rdu2.redhat.com [10.10.119.92])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3C71D6E515;
        Wed, 24 Feb 2021 18:43:30 +0000 (UTC)
Date:   Wed, 24 Feb 2021 13:43:28 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v15 10/22] xfs: Hoist node transaction handling
Message-ID: <20210224184328.GK981777@bfoster>
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-11-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210218165348.4754-11-allison.henderson@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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

		} else if (error) {
			return error;
		}

(I think we usually try to add braces around all branches of an if/else
if at least one branch requires them.)

Otherwise, the factoring looks Ok to me and this does improve on the
wart from the previous patch:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  			return error;
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

