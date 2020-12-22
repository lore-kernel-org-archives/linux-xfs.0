Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFB76C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Dec 2020 17:13:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75AA223133
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Dec 2020 17:13:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbgLVRNW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Dec 2020 12:13:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44741 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726889AbgLVRNV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Dec 2020 12:13:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608657114;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QcV3CGx/EduojLtekcl3xCjkIbUfEHtku8/6ALkg1GU=;
        b=K+FE6RJESJe8R3UAvmWz4WX1xGWOx719aHCsDqgYpKjTypcgg85XHHDEp4fguFqEDMqJuB
        sNP5Anmc+OIAyYfcrigeGoRoIEEi94PsmRXxxiSbbk8MJBCDdPEzNkAmz0tPHymLTCk5uP
        Y75vVVzHz30yhWBxjyDKtgSzw3qSUOk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-549-75SfkLoEPBiF3IvXGeS2qA-1; Tue, 22 Dec 2020 12:11:51 -0500
X-MC-Unique: 75SfkLoEPBiF3IvXGeS2qA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B189A1015C80;
        Tue, 22 Dec 2020 17:11:50 +0000 (UTC)
Received: from bfoster (ovpn-112-184.rdu2.redhat.com [10.10.112.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 437DA5C8B8;
        Tue, 22 Dec 2020 17:11:50 +0000 (UTC)
Date:   Tue, 22 Dec 2020 12:11:48 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v14 04/15] xfs: Add delay ready attr remove routines
Message-ID: <20201222171148.GC2808393@bfoster>
References: <20201218072917.16805-1-allison.henderson@oracle.com>
 <20201218072917.16805-5-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201218072917.16805-5-allison.henderson@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 18, 2020 at 12:29:06AM -0700, Allison Henderson wrote:
> This patch modifies the attr remove routines to be delay ready. This
> means they no longer roll or commit transactions, but instead return
> -EAGAIN to have the calling routine roll and refresh the transaction. In
> this series, xfs_attr_remove_args has become xfs_attr_remove_iter, which
> uses a sort of state machine like switch to keep track of where it was
> when EAGAIN was returned. xfs_attr_node_removename has also been
> modified to use the switch, and a new version of xfs_attr_remove_args
> consists of a simple loop to refresh the transaction until the operation
> is completed. A new XFS_DAC_DEFER_FINISH flag is used to finish the
> transaction where ever the existing code used to.
> 
> Calls to xfs_attr_rmtval_remove are replaced with the delay ready
> version __xfs_attr_rmtval_remove. We will rename
> __xfs_attr_rmtval_remove back to xfs_attr_rmtval_remove when we are
> done.
> 
> xfs_attr_rmtval_remove itself is still in use by the set routines (used
> during a rename).  For reasons of preserving existing function, we
> modify xfs_attr_rmtval_remove to call xfs_defer_finish when the flag is
> set.  Similar to how xfs_attr_remove_args does here.  Once we transition
> the set routines to be delay ready, xfs_attr_rmtval_remove is no longer
> used and will be removed.
> 
> This patch also adds a new struct xfs_delattr_context, which we will use
> to keep track of the current state of an attribute operation. The new
> xfs_delattr_state enum is used to track various operations that are in
> progress so that we know not to repeat them, and resume where we left
> off before EAGAIN was returned to cycle out the transaction. Other
> members take the place of local variables that need to retain their
> values across multiple function recalls.  See xfs_attr.h for a more
> detailed diagram of the states.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---

I started with a couple small comments on this patch but inevitably
started thinking more about the factoring again and ended up with a
couple patches on top. The first is more of some small tweaks and
open-coding that IMO makes this patch a bit easier to follow. The
second is more of an RFC so I'll follow up with that in a second email.
I'm curious what folks' thoughts might be on either. Also note that I'm
primarily focusing on code structure and whatnot here, so these are fast
and loose, compile tested only and likely to be broken.

First diff:

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index b6330f953f40..2e466c4ac283 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -58,6 +58,9 @@ STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
 				 struct xfs_da_state **state);
 STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
+STATIC
+int xfs_attr_node_removename_setup(
+	struct xfs_delattr_context	*dac);
 
 int
 xfs_inode_hasattr(
@@ -395,12 +398,34 @@ xfs_attr_remove_args(
 	struct xfs_da_args	*args)
 {
 	int				error;
+	struct xfs_inode		*dp = args->dp;
 	struct xfs_delattr_context	dac = {
+		.dela_state	= XFS_DAS_UNINIT,
 		.da_args	= args,
 	};
 
+	if (!xfs_inode_hasattr(dp))
+		return -ENOATTR;
+
+	if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL) {
+		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
+		return xfs_attr_shortform_remove(args);
+	}
+
+	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
+		return xfs_attr_leaf_removename(args);
+
+	/* node format requires multiple transactions... */
+
+	trace_xfs_attr_node_removename(args);
+	if (!dac.da_state) {
+		error = xfs_attr_node_removename_setup(&dac);
+		if (error)
+			return error;
+	}
+
 	do {
-		error = xfs_attr_remove_iter(&dac);
+		error = xfs_attr_node_removename_iter(&dac);
 		if (error != -EAGAIN)
 			break;
 
@@ -413,39 +438,6 @@ xfs_attr_remove_args(
 	return error;
 }
 
-/*
- * Remove the attribute specified in @args.
- *
- * This function may return -EAGAIN to signal that the transaction needs to be
- * rolled.  Callers should continue calling this function until they receive a
- * return value other than -EAGAIN.
- */
-int
-xfs_attr_remove_iter(
-	struct xfs_delattr_context	*dac)
-{
-	struct xfs_da_args		*args = dac->da_args;
-	struct xfs_inode		*dp = args->dp;
-
-	/* If we are shrinking a node, resume shrink */
-	if (dac->dela_state == XFS_DAS_RM_SHRINK)
-		goto node;
-
-	if (!xfs_inode_hasattr(dp))
-		return -ENOATTR;
-
-	if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL) {
-		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
-		return xfs_attr_shortform_remove(args);
-	}
-
-	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
-		return xfs_attr_leaf_removename(args);
-node:
-	/* If we are not short form or leaf, then proceed to remove node */
-	return  xfs_attr_node_removename_iter(dac);
-}
-
 /*
  * Note: If args->value is NULL the attribute will be removed, just like the
  * Linux ->setattr API.
@@ -1266,46 +1258,6 @@ int xfs_attr_node_removename_setup(
 	return 0;
 }
 
-STATIC int
-xfs_attr_node_remove_rmt (
-	struct xfs_delattr_context	*dac,
-	struct xfs_da_state		*state)
-{
-	int				error = 0;
-
-	/*
-	 * May return -EAGAIN to request that the caller recall this function
-	 */
-	error = __xfs_attr_rmtval_remove(dac);
-	if (error)
-		return error;
-
-	/*
-	 * Refill the state structure with buffers, the prior calls released our
-	 * buffers.
-	 */
-	return xfs_attr_refillstate(state);
-}
-
-STATIC int
-xfs_attr_node_remove_cleanup(
-	struct xfs_da_args	*args,
-	struct xfs_da_state	*state)
-{
-	struct xfs_da_state_blk	*blk;
-	int			retval;
-
-	/*
-	 * Remove the name and update the hashvals in the tree.
-	 */
-	blk = &state->path.blk[state->path.active-1];
-	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
-	retval = xfs_attr3_leaf_remove(blk->bp, args);
-	xfs_da3_fixhashpath(state, &state->path);
-
-	return retval;
-}
-
 /*
  * Step through removeing a name from a B-tree attribute list.
  *
@@ -1320,25 +1272,54 @@ xfs_attr_node_remove_cleanup(
  */
 STATIC int
 xfs_attr_node_remove_step(
-	struct xfs_delattr_context	*dac)
+	struct xfs_delattr_context	*dac,
+	bool				*joined)
 {
 	struct xfs_da_args		*args = dac->da_args;
 	struct xfs_da_state		*state = dac->da_state;
-	int				error = 0;
+	struct xfs_da_state_blk		*blk;
+	int				error = 0, retval, done;
+
 	/*
-	 * If there is an out-of-line value, de-allocate the blocks.
-	 * This is done before we remove the attribute so that we don't
-	 * overflow the maximum size of a transaction and/or hit a deadlock.
+	 * If there is an out-of-line value, de-allocate the blocks.  This is
+	 * done before we remove the attribute so that we don't overflow the
+	 * maximum size of a transaction and/or hit a deadlock.
 	 */
 	if (args->rmtblkno > 0) {
-		/*
-		 * May return -EAGAIN. Remove blocks until args->rmtblkno == 0
-		 */
-		error = xfs_attr_node_remove_rmt(dac, state);
+		error = xfs_bunmapi(args->trans, args->dp, args->rmtblkno,
+				args->rmtblkcnt, XFS_BMAPI_ATTRFORK, 1, &done);
+		if (error)
+			return error;
+		if (!done) {
+			dac->flags |= XFS_DAC_DEFER_FINISH;
+			return -EAGAIN;
+		}
+
+		error = xfs_attr_refillstate(state);
 		if (error)
 			return error;
 	}
 
+	/*
+	 * Remove the name and update the hashvals in the tree.
+	 */
+	blk = &state->path.blk[state->path.active-1];
+	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
+	retval = xfs_attr3_leaf_remove(blk->bp, args);
+	xfs_da3_fixhashpath(state, &state->path);
+
+	/*
+	 * Check to see if the tree needs to be collapsed. Set the flag to
+	 * indicate that the calling function needs to move the shrink
+	 * operation
+	 */
+	if (retval && (state->path.active > 1)) {
+		error = xfs_da3_join(state);
+		if (error)
+			return error;
+		*joined = true;
+	}
+
 	return error;
 }
 
@@ -1358,18 +1339,10 @@ xfs_attr_node_removename_iter(
 	struct xfs_delattr_context	*dac)
 {
 	struct xfs_da_args		*args = dac->da_args;
-	struct xfs_da_state		*state = NULL;
-	int				retval, error;
+	struct xfs_da_state		*state = dac->da_state;
+	int				error;
 	struct xfs_inode		*dp = args->dp;
-
-	trace_xfs_attr_node_removename(args);
-
-	if (!dac->da_state) {
-		error = xfs_attr_node_removename_setup(dac);
-		if (error)
-			goto out;
-	}
-	state = dac->da_state;
+	bool				joined = false;
 
 	switch (dac->dela_state) {
 	case XFS_DAS_UNINIT:
@@ -1377,27 +1350,14 @@ xfs_attr_node_removename_iter(
 		 * repeatedly remove remote blocks, remove the entry and join.
 		 * returns -EAGAIN or 0 for completion of the step.
 		 */
-		error = xfs_attr_node_remove_step(dac);
+		error = xfs_attr_node_remove_step(dac, &joined);
 		if (error)
-			break;
-
-		retval = xfs_attr_node_remove_cleanup(args, state);
-
-		/*
-		 * Check to see if the tree needs to be collapsed. Set the flag
-		 * to indicate that the calling function needs to move the
-		 * shrink operation
-		 */
-		if (retval && (state->path.active > 1)) {
-			error = xfs_da3_join(state);
-			if (error)
-				return error;
-
+			goto out;
+		if (joined) {
 			dac->flags |= XFS_DAC_DEFER_FINISH;
 			dac->dela_state = XFS_DAS_RM_SHRINK;
 			return -EAGAIN;
 		}
-
 		/* fallthrough */
 	case XFS_DAS_RM_SHRINK:
 		/*
@@ -1405,7 +1365,6 @@ xfs_attr_node_removename_iter(
 		 */
 		if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
 			error = xfs_attr_node_shrink(args, state);
-
 		break;
 	default:
 		ASSERT(0);
@@ -1413,10 +1372,8 @@ xfs_attr_node_removename_iter(
 		goto out;
 	}
 
-	if (error == -EAGAIN)
-		return error;
 out:
-	if (state)
+	if (state && error != -EAGAIN)
 		xfs_da_state_free(state);
 	return error;
 }

