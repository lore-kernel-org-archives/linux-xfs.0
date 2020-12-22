Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0A77C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Dec 2020 16:51:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 842D523103
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Dec 2020 16:51:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727904AbgLVQvu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Dec 2020 11:51:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21458 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727872AbgLVQvt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Dec 2020 11:51:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608655823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=D1S3spCTQPr8AlckVwZ16Ly+Avdigleily3Uuhgyga4=;
        b=KXbQGdj9mGjvLVr72+wuLt8j6Qwz9MFx3ZR/vJdOFGAXlRh6kpzYfhSuHvkKvQYC+GQTOX
        NwEiOjh3Cb5rEJwlJEMgikZuhRmmmdCeK130/TYVCwZb6hfIjlgzV7Bw5WvWQTv5npqtwn
        STNyZ+ubUBfc9+uzNa9wB0OR388/054=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-527-cFo6mLCNNWWmolsbW5ndbA-1; Tue, 22 Dec 2020 11:50:21 -0500
X-MC-Unique: cFo6mLCNNWWmolsbW5ndbA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B1CAC801817;
        Tue, 22 Dec 2020 16:50:19 +0000 (UTC)
Received: from bfoster (ovpn-112-184.rdu2.redhat.com [10.10.112.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 380D95C8B8;
        Tue, 22 Dec 2020 16:50:19 +0000 (UTC)
Date:   Tue, 22 Dec 2020 11:50:17 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v14 02/15] xfs: Add xfs_attr_node_remove_cleanup
Message-ID: <20201222165017.GB2808393@bfoster>
References: <20201218072917.16805-1-allison.henderson@oracle.com>
 <20201218072917.16805-3-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201218072917.16805-3-allison.henderson@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 18, 2020 at 12:29:04AM -0700, Allison Henderson wrote:
> This patch pulls a new helper function xfs_attr_node_remove_cleanup out
> of xfs_attr_node_remove_step.  This helps to modularize
> xfs_attr_node_remove_step which will help make the delayed attribute
> code easier to follow
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_attr.c | 29 ++++++++++++++++++++---------
>  1 file changed, 20 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 8b55a8d..e93d76a 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1220,6 +1220,25 @@ xfs_attr_node_remove_rmt(
>  	return xfs_attr_refillstate(state);
>  }
>  
> +STATIC int
> +xfs_attr_node_remove_cleanup(
> +	struct xfs_da_args	*args,
> +	struct xfs_da_state	*state)
> +{
> +	struct xfs_da_state_blk	*blk;
> +	int			retval;
> +
> +	/*
> +	 * Remove the name and update the hashvals in the tree.
> +	 */
> +	blk = &state->path.blk[state->path.active-1];
> +	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
> +	retval = xfs_attr3_leaf_remove(blk->bp, args);
> +	xfs_da3_fixhashpath(state, &state->path);
> +
> +	return retval;
> +}
> +
>  /*
>   * Remove a name from a B-tree attribute list.
>   *
> @@ -1232,7 +1251,6 @@ xfs_attr_node_remove_step(
>  	struct xfs_da_args	*args,
>  	struct xfs_da_state	*state)
>  {
> -	struct xfs_da_state_blk	*blk;
>  	int			retval, error;
>  	struct xfs_inode	*dp = args->dp;
>  
> @@ -1247,14 +1265,7 @@ xfs_attr_node_remove_step(
>  		if (error)
>  			return error;
>  	}
> -
> -	/*
> -	 * Remove the name and update the hashvals in the tree.
> -	 */
> -	blk = &state->path.blk[ state->path.active-1 ];
> -	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
> -	retval = xfs_attr3_leaf_remove(blk->bp, args);
> -	xfs_da3_fixhashpath(state, &state->path);
> +	retval = xfs_attr_node_remove_cleanup(args, state);
>  
>  	/*
>  	 * Check to see if the tree needs to be collapsed.
> -- 
> 2.7.4
> 

