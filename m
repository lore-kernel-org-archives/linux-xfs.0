Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB93BC433B4
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Apr 2021 17:53:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D5F760FF3
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Apr 2021 17:53:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235217AbhDARxN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Apr 2021 13:53:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42265 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234689AbhDARqC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Apr 2021 13:46:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617299161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9getto5pxH6KR+9/yI4vcdajOu1AruvIDUT3qfjsAqA=;
        b=ezoDFDxALfBO7NUGkYZSoQDTf4ztdT4mdm3IVLRUMqvIcnevydL3ZbkOhDBnjN9m3e0+n9
        9CJ70Paug7YB10dcollLp3DSf2hvVkrOyB2YgpTEmYMauAuaS0KHCvmU7dc9KHwtGQUAQe
        A5bztCUmcZquV3h1ioSh4yI85gLeGpk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-231-HKoI7cWfOKyg_ekjJ_sOCQ-1; Thu, 01 Apr 2021 11:43:45 -0400
X-MC-Unique: HKoI7cWfOKyg_ekjJ_sOCQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5EE4C1922966;
        Thu,  1 Apr 2021 15:43:44 +0000 (UTC)
Received: from bfoster (ovpn-112-117.rdu2.redhat.com [10.10.112.117])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 01CCE100760B;
        Thu,  1 Apr 2021 15:43:43 +0000 (UTC)
Date:   Thu, 1 Apr 2021 11:43:42 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v16 08/11] xfs: Hoist xfs_attr_leaf_addname
Message-ID: <YGXqLqrf2p++5k5p@bfoster>
References: <20210326003308.32753-1-allison.henderson@oracle.com>
 <20210326003308.32753-9-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210326003308.32753-9-allison.henderson@oracle.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 25, 2021 at 05:33:05PM -0700, Allison Henderson wrote:
> This patch hoists xfs_attr_leaf_addname into the calling function.  The
> goal being to get all the code that will require state management into
> the same scope. This isn't particuarly aesthetic right away, but it is a
> preliminary step to merging in the state machine code.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 209 ++++++++++++++++++++++-------------------------
>  1 file changed, 96 insertions(+), 113 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 5b5410f..16f10ac 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
...
> @@ -729,115 +821,6 @@ xfs_attr_leaf_try_add(
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

Did this tracepoint disappear for a reason?

Brian

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

