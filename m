Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38C83C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 18:44:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E032664F0A
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 18:44:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235010AbhBXSo3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 13:44:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44393 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235031AbhBXSo1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Feb 2021 13:44:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614192180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sWHrOakKe4QkkabxuB7amees8mB2WTQZA+cIiBlDfEA=;
        b=DsS7NIbCdDB29qHQewFoocPNUhZ0jeVDMeU8cP9eRiF5VmiixIGLOTIK1ebe8cHUDWCYR/
        Qf1r1ImBLfOX5ag56GzJYmtlYfUuAdd32XQyUyAG7/CQ5tz9LrFUMwL3KxRioeySB0q4se
        5N8kVDfctMACNKH6EwAe6lnsulE0GGg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-573-mebM3spAMLiPUnWPO5RAVw-1; Wed, 24 Feb 2021 13:42:58 -0500
X-MC-Unique: mebM3spAMLiPUnWPO5RAVw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2809C874982;
        Wed, 24 Feb 2021 18:42:57 +0000 (UTC)
Received: from bfoster (ovpn-119-92.rdu2.redhat.com [10.10.119.92])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A194C5D9D3;
        Wed, 24 Feb 2021 18:42:56 +0000 (UTC)
Date:   Wed, 24 Feb 2021 13:42:54 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v15 08/22] xfs: Hoist xfs_attr_node_addname
Message-ID: <20210224184254.GJ981777@bfoster>
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-9-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210218165348.4754-9-allison.henderson@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 18, 2021 at 09:53:34AM -0700, Allison Henderson wrote:
> This patch hoists the later half of xfs_attr_node_addname into
> the calling function.  We do this because it is this area that
> will need the most state management, and we want to keep such
> code in the same scope as much as possible
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 165 ++++++++++++++++++++++++-----------------------
>  1 file changed, 83 insertions(+), 82 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 4333b61..19a532a 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
...
> @@ -320,8 +322,82 @@ xfs_attr_set_args(
>  			return error;
>  		error = xfs_attr_node_addname(args, state);
>  	} while (error == -EAGAIN);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * Commit the leaf addition or btree split and start the next
> +	 * trans in the chain.
> +	 */
> +	error = xfs_trans_roll_inode(&args->trans, dp);
> +	if (error)
> +		goto out;
> +
> +	/*
> +	 * If there was an out-of-line value, allocate the blocks we
> +	 * identified for its storage and copy the value.  This is done
> +	 * after we create the attribute so that we don't overflow the
> +	 * maximum size of a transaction and/or hit a deadlock.
> +	 */
> +	if (args->rmtblkno > 0) {
> +		error = xfs_attr_rmtval_set(args);
> +		if (error)
> +			return error;
> +	}
> +
> +	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
> +		/*
> +		 * Added a "remote" value, just clear the incomplete flag.
> +		 */
> +		if (args->rmtblkno > 0)
> +			error = xfs_attr3_leaf_clearflag(args);
> +		retval = error;

It looks like this is the only use of retval. Otherwise this function is
getting a bit big, but the factoring LGTM:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +		goto out;
> +	}
> +
> +	/*
> +	 * If this is an atomic rename operation, we must "flip" the incomplete
> +	 * flags on the "new" and "old" attribute/value pairs so that one
> +	 * disappears and one appears atomically.  Then we must remove the "old"
> +	 * attribute/value pair.
> +	 *
> +	 * In a separate transaction, set the incomplete flag on the "old" attr
> +	 * and clear the incomplete flag on the "new" attr.
> +	 */
> +	error = xfs_attr3_leaf_flipflags(args);
> +	if (error)
> +		goto out;
> +	/*
> +	 * Commit the flag value change and start the next trans in series
> +	 */
> +	error = xfs_trans_roll_inode(&args->trans, args->dp);
> +	if (error)
> +		goto out;
> +
> +	/*
> +	 * Dismantle the "old" attribute/value pair by removing a "remote" value
> +	 * (if it exists).
> +	 */
> +	xfs_attr_restore_rmt_blk(args);
> +
> +	if (args->rmtblkno) {
> +		error = xfs_attr_rmtval_invalidate(args);
> +		if (error)
> +			return error;
> +
> +		error = xfs_attr_rmtval_remove(args);
> +		if (error)
> +			return error;
> +	}
> +
> +	error = xfs_attr_node_addname_work(args);
> +out:
> +	if (state)
> +		xfs_da_state_free(state);
> +	if (error)
> +		return error;
> +	return retval;
>  
> -	return error;
>  }
>  
>  /*
> @@ -955,7 +1031,7 @@ xfs_attr_node_addname(
>  {
>  	struct xfs_da_state_blk	*blk;
>  	struct xfs_inode	*dp;
> -	int			retval, error;
> +	int			error;
>  
>  	trace_xfs_attr_node_addname(args);
>  
> @@ -963,8 +1039,8 @@ xfs_attr_node_addname(
>  	blk = &state->path.blk[state->path.active-1];
>  	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
>  
> -	retval = xfs_attr3_leaf_add(blk->bp, state->args);
> -	if (retval == -ENOSPC) {
> +	error = xfs_attr3_leaf_add(blk->bp, state->args);
> +	if (error == -ENOSPC) {
>  		if (state->path.active == 1) {
>  			/*
>  			 * Its really a single leaf node, but it had
> @@ -1010,85 +1086,10 @@ xfs_attr_node_addname(
>  		xfs_da3_fixhashpath(state, &state->path);
>  	}
>  
> -	/*
> -	 * Kill the state structure, we're done with it and need to
> -	 * allow the buffers to come back later.
> -	 */
> -	xfs_da_state_free(state);
> -	state = NULL;
> -
> -	/*
> -	 * Commit the leaf addition or btree split and start the next
> -	 * trans in the chain.
> -	 */
> -	error = xfs_trans_roll_inode(&args->trans, dp);
> -	if (error)
> -		goto out;
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
> -		retval = error;
> -		goto out;
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
> -	error = xfs_attr3_leaf_flipflags(args);
> -	if (error)
> -		goto out;
> -	/*
> -	 * Commit the flag value change and start the next trans in series
> -	 */
> -	error = xfs_trans_roll_inode(&args->trans, args->dp);
> -	if (error)
> -		goto out;
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
> -	error = xfs_attr_node_addname_work(args);
>  out:
>  	if (state)
>  		xfs_da_state_free(state);
> -	if (error)
> -		return error;
> -	return retval;
> +	return error;
>  }
>  
>  
> -- 
> 2.7.4
> 

