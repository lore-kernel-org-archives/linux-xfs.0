Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2621C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 18:44:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6B4864F0C
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 18:44:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234502AbhBXSnu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 13:43:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49054 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234982AbhBXSnr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Feb 2021 13:43:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614192140;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XWme3y56tWm4NV+C23WmQeKm/agq6yV+Hwr06H+NQYE=;
        b=XnmF1EDHuQY8MMIlwfzrXk/7XuF9TEGXm+CbeJ6w8tKs/YPu9d7mqzAvIJtBfJxP9Trpr2
        1IttBpLGuhP31cSm7y2sT0ESfGa9U49vONQJ+MQojN0itTMSBi8wgQL/K4vIvKjVMYaqGP
        bWqRHkqsPJxrAMd+zj98cOtlJSZQbN8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-msMfO5hRMTawC6Yv_pTkpQ-1; Wed, 24 Feb 2021 13:42:17 -0500
X-MC-Unique: msMfO5hRMTawC6Yv_pTkpQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 95A2819611A3;
        Wed, 24 Feb 2021 18:42:16 +0000 (UTC)
Received: from bfoster (ovpn-119-92.rdu2.redhat.com [10.10.119.92])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3CA605D9D3;
        Wed, 24 Feb 2021 18:42:16 +0000 (UTC)
Date:   Wed, 24 Feb 2021 13:42:14 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v15 09/22] xfs: Hoist xfs_attr_leaf_addname
Message-ID: <20210224184214.GI981777@bfoster>
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-10-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210218165348.4754-10-allison.henderson@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 18, 2021 at 09:53:35AM -0700, Allison Henderson wrote:
> This patch hoists xfs_attr_leaf_addname into the calling function.  The
> goal being to get all the code that will require state management into
> the same scope. This isn't particuarly asetheic right away, but it is a
> preliminary step to to manageing the state machine code.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 209 ++++++++++++++++++++++-------------------------
>  1 file changed, 96 insertions(+), 113 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 19a532a..bfd4466 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
...
> @@ -286,10 +287,101 @@ xfs_attr_set_args(
...
>  			return error;
>  
> +		xfs_attr3_leaf_remove(bp, args);
> +
> +		/*
> +		 * If the result is small enough, shrink it all into the inode.
> +		 */
> +		forkoff = xfs_attr_shortform_allfit(bp, dp);
> +		if (forkoff)
> +			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
> +			/* bp is gone due to xfs_da_shrink_inode */
> +
> +		return error;
> +node:

Hmm, I'm not a fan of this unconditional return followed by a jump label
in the middle of the function. It's a pretty clear indication that this
is just two functions smashed together, so I'm not sure what the
advantage of this is. I'll continue on to see what falls out of the next
patches..

Brian

>  		/*
>  		 * Promote the attribute list to the Btree format.
>  		 */
> @@ -731,115 +823,6 @@ xfs_attr_leaf_try_add(
>  	return retval;
>  }
>  
> -
> -/*
> - * Add a name to the leaf attribute list structure
> - *
> - * This leaf block cannot have a "remote" value, we only call this routine
> - * if bmap_one_block() says there is only one block (ie: no remote blks).
> - */
> -STATIC int
> -xfs_attr_leaf_addname(
> -	struct xfs_da_args	*args)
> -{
> -	int			error, forkoff;
> -	struct xfs_buf		*bp = NULL;
> -	struct xfs_inode	*dp = args->dp;
> -
> -	trace_xfs_attr_leaf_addname(args);
> -
> -	error = xfs_attr_leaf_try_add(args, bp);
> -	if (error)
> -		return error;
> -
> -	/*
> -	 * Commit the transaction that added the attr name so that
> -	 * later routines can manage their own transactions.
> -	 */
> -	error = xfs_trans_roll_inode(&args->trans, dp);
> -	if (error)
> -		return error;
> -
> -	/*
> -	 * If there was an out-of-line value, allocate the blocks we
> -	 * identified for its storage and copy the value.  This is done
> -	 * after we create the attribute so that we don't overflow the
> -	 * maximum size of a transaction and/or hit a deadlock.
> -	 */
> -	if (args->rmtblkno > 0) {
> -		error = xfs_attr_rmtval_set(args);
> -		if (error)
> -			return error;
> -	}
> -
> -	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
> -		/*
> -		 * Added a "remote" value, just clear the incomplete flag.
> -		 */
> -		if (args->rmtblkno > 0)
> -			error = xfs_attr3_leaf_clearflag(args);
> -
> -		return error;
> -	}
> -
> -	/*
> -	 * If this is an atomic rename operation, we must "flip" the incomplete
> -	 * flags on the "new" and "old" attribute/value pairs so that one
> -	 * disappears and one appears atomically.  Then we must remove the "old"
> -	 * attribute/value pair.
> -	 *
> -	 * In a separate transaction, set the incomplete flag on the "old" attr
> -	 * and clear the incomplete flag on the "new" attr.
> -	 */
> -
> -	error = xfs_attr3_leaf_flipflags(args);
> -	if (error)
> -		return error;
> -	/*
> -	 * Commit the flag value change and start the next trans in series.
> -	 */
> -	error = xfs_trans_roll_inode(&args->trans, args->dp);
> -	if (error)
> -		return error;
> -
> -	/*
> -	 * Dismantle the "old" attribute/value pair by removing a "remote" value
> -	 * (if it exists).
> -	 */
> -	xfs_attr_restore_rmt_blk(args);
> -
> -	if (args->rmtblkno) {
> -		error = xfs_attr_rmtval_invalidate(args);
> -		if (error)
> -			return error;
> -
> -		error = xfs_attr_rmtval_remove(args);
> -		if (error)
> -			return error;
> -	}
> -
> -	/*
> -	 * Read in the block containing the "old" attr, then remove the "old"
> -	 * attr from that block (neat, huh!)
> -	 */
> -	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
> -				   &bp);
> -	if (error)
> -		return error;
> -
> -	xfs_attr3_leaf_remove(bp, args);
> -
> -	/*
> -	 * If the result is small enough, shrink it all into the inode.
> -	 */
> -	forkoff = xfs_attr_shortform_allfit(bp, dp);
> -	if (forkoff)
> -		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
> -		/* bp is gone due to xfs_da_shrink_inode */
> -
> -	return error;
> -}
> -
>  /*
>   * Return EEXIST if attr is found, or ENOATTR if not
>   */
> -- 
> 2.7.4
> 

