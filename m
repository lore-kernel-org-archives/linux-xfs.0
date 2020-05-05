Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F91FC47254
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 13:12:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CC492078C
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 13:12:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aq1dTMZC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728927AbgEENMq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 May 2020 09:12:46 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:40923 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728512AbgEENMp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 May 2020 09:12:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588684364;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eOCfxaF+62kx+i5tkXF/gCCc87X41sVgdA2gn5sjceg=;
        b=aq1dTMZC13ZEeQw60D1HhY4ntezuirvIElDQgcDvMuQ+B1V3D1meRm+F2B1S3WPnLQfQ7S
        jgYgFKbEtpB2GQVTlYc+9qiQMRKLqmIid+/MsnoRSy5Ygw2H4RCI/FL3yP9ndbWf9DAn1y
        MpkSgIWMfUKi6KLaWKyfZeEDrdnHaZo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-65-rZUmnRNhNLq83-Z98eGMWg-1; Tue, 05 May 2020 09:12:38 -0400
X-MC-Unique: rZUmnRNhNLq83-Z98eGMWg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DF0221005510;
        Tue,  5 May 2020 13:12:37 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 97E8D5C1B2;
        Tue,  5 May 2020 13:12:37 +0000 (UTC)
Date:   Tue, 5 May 2020 09:12:35 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v9 20/24] xfs: Simplify xfs_attr_node_addname
Message-ID: <20200505131235.GD60048@bfoster>
References: <20200430225016.4287-1-allison.henderson@oracle.com>
 <20200430225016.4287-21-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430225016.4287-21-allison.henderson@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 30, 2020 at 03:50:12PM -0700, Allison Collins wrote:
> Quick patch to unnest the rename logic in the node code path.  This will
> help simplify delayed attr logic later.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 131 +++++++++++++++++++++++------------------------
>  1 file changed, 64 insertions(+), 67 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 1810f90..9171895 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1030,83 +1030,80 @@ xfs_attr_node_addname(
>  			return error;
>  	}
>  
> -	/*
> -	 * If this is an atomic rename operation, we must "flip" the
> -	 * incomplete flags on the "new" and "old" attribute/value pairs
> -	 * so that one disappears and one appears atomically.  Then we
> -	 * must remove the "old" attribute/value pair.
> -	 */
> -	if (args->op_flags & XFS_DA_OP_RENAME) {
> -		/*
> -		 * In a separate transaction, set the incomplete flag on the
> -		 * "old" attr and clear the incomplete flag on the "new" attr.
> -		 */
> -		error = xfs_attr3_leaf_flipflags(args);
> -		if (error)
> -			goto out;
> +	if ((args->op_flags & XFS_DA_OP_RENAME) == 0) {
>  		/*
> -		 * Commit the flag value change and start the next trans in
> -		 * series
> +		 * Added a "remote" value, just clear the incomplete flag.
>  		 */
> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
> -		if (error)
> -			goto out;
> +		if (args->rmtblkno > 0)
> +			error = xfs_attr3_leaf_clearflag(args);
> +		retval = error;

Can we just init retval to 0 and avoid this assignment? With that and
similar fixups to the previous patch:

Reviewed-by: Brian Foster <bfoster@redhat.com>

Note that I'm also of the mind to break this down into smaller functions
depending on what later patches look like, but if there's more to
consider around that this seems like a good step in that direction.

Brian

> +		goto out;
> +	}
>  
> -		/*
> -		 * Dismantle the "old" attribute/value pair by removing
> -		 * a "remote" value (if it exists).
> -		 */
> -		xfs_attr_restore_rmt_blk(args);
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
>  
> -		if (args->rmtblkno) {
> -			error = xfs_attr_rmtval_invalidate(args);
> -			if (error)
> -				return error;
> +	/*
> +	 * Dismantle the "old" attribute/value pair by removing a "remote" value
> +	 * (if it exists).
> +	 */
> +	xfs_attr_restore_rmt_blk(args);
>  
> -			error = xfs_attr_rmtval_remove(args);
> -			if (error)
> -				return error;
> -		}
> +	if (args->rmtblkno) {
> +		error = xfs_attr_rmtval_invalidate(args);
> +		if (error)
> +			return error;
>  
> -		/*
> -		 * Re-find the "old" attribute entry after any split ops.
> -		 * The INCOMPLETE flag means that we will find the "old"
> -		 * attr, not the "new" one.
> -		 */
> -		args->attr_filter |= XFS_ATTR_INCOMPLETE;
> -		state = xfs_da_state_alloc();
> -		state->args = args;
> -		state->mp = mp;
> -		state->inleaf = 0;
> -		error = xfs_da3_node_lookup_int(state, &retval);
> +		error = xfs_attr_rmtval_remove(args);
>  		if (error)
> -			goto out;
> +			return error;
> +	}
>  
> -		/*
> -		 * Remove the name and update the hashvals in the tree.
> -		 */
> -		blk = &state->path.blk[ state->path.active-1 ];
> -		ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
> -		error = xfs_attr3_leaf_remove(blk->bp, args);
> -		xfs_da3_fixhashpath(state, &state->path);
> +	/*
> +	 * Re-find the "old" attribute entry after any split ops. The INCOMPLETE
> +	 * flag means that we will find the "old" attr, not the "new" one.
> +	 */
> +	args->attr_filter |= XFS_ATTR_INCOMPLETE;
> +	state = xfs_da_state_alloc();
> +	state->args = args;
> +	state->mp = mp;
> +	state->inleaf = 0;
> +	error = xfs_da3_node_lookup_int(state, &retval);
> +	if (error)
> +		goto out;
>  
> -		/*
> -		 * Check to see if the tree needs to be collapsed.
> -		 */
> -		if (retval && (state->path.active > 1)) {
> -			error = xfs_da3_join(state);
> -			if (error)
> -				goto out;
> -			error = xfs_defer_finish(&args->trans);
> -			if (error)
> -				goto out;
> -		}
> +	/*
> +	 * Remove the name and update the hashvals in the tree.
> +	 */
> +	blk = &state->path.blk[state->path.active-1];
> +	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
> +	error = xfs_attr3_leaf_remove(blk->bp, args);
> +	xfs_da3_fixhashpath(state, &state->path);
>  
> -	} else if (args->rmtblkno > 0) {
> -		/*
> -		 * Added a "remote" value, just clear the incomplete flag.
> -		 */
> -		error = xfs_attr3_leaf_clearflag(args);
> +	/*
> +	 * Check to see if the tree needs to be collapsed.
> +	 */
> +	if (retval && (state->path.active > 1)) {
> +		error = xfs_da3_join(state);
> +		if (error)
> +			goto out;
> +		error = xfs_defer_finish(&args->trans);
>  		if (error)
>  			goto out;
>  	}
> -- 
> 2.7.4
> 

