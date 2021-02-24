Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13CBFC433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 16:02:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5AB564EDB
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 16:02:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234166AbhBXQCF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 11:02:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56274 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233626AbhBXPiM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Feb 2021 10:38:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614180986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=naaWtybLnueNMiTYqkNJZvceWeQPcP0jIn02qVhnHWA=;
        b=M4GLNdwoTGGy20e9NBk+sp6b0oEpjWorHineN4P6lRUF5pi/pxNWYdnd9VFdf98OQT8qVp
        ORVG8v2KN8lrhfAdD0NnT3c6tZULyDKEzup+ipU8HrfkSoc/hmtzf/pEisNCsUJTl2Snwi
        7KDdJ54cvT0GfMakEZClfDYmiWisRqM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-187-kExmNzVMOi-qidSd_MX1kw-1; Wed, 24 Feb 2021 10:35:59 -0500
X-MC-Unique: kExmNzVMOi-qidSd_MX1kw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 79AB32A0045;
        Wed, 24 Feb 2021 15:03:27 +0000 (UTC)
Received: from bfoster (ovpn-119-92.rdu2.redhat.com [10.10.119.92])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1CA0860855;
        Wed, 24 Feb 2021 15:03:27 +0000 (UTC)
Date:   Wed, 24 Feb 2021 10:03:25 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v15 02/22] xfs: Add xfs_attr_node_remove_cleanup
Message-ID: <20210224150325.GC981777@bfoster>
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-3-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210218165348.4754-3-allison.henderson@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 18, 2021 at 09:53:28AM -0700, Allison Henderson wrote:
> This patch pulls a new helper function xfs_attr_node_remove_cleanup out
> of xfs_attr_node_remove_step.  This helps to modularize
> xfs_attr_node_remove_step which will help make the delayed attribute
> code easier to follow
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---

Looks like I sent a review for this on v14...

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_attr.c | 29 ++++++++++++++++++++---------
>  1 file changed, 20 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 28ff93d..4e6c89d 100644
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

