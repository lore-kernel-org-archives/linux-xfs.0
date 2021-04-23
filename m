Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73CE6C433B4
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Apr 2021 19:08:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5565861422
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Apr 2021 19:08:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231760AbhDWTJD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Apr 2021 15:09:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45850 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231735AbhDWTJB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Apr 2021 15:09:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619204904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3THv8/t+B5sCKH8F6onPJzCPqQyCB07LHpjorwHmoZU=;
        b=inHCJ106b4eaypaSNJBbRpZS58H4PYdfbFRUsMapiX29KxyfXew0gJqXwL0dmsOFh78n8b
        T44lYOOjylSSWQ3Y1wJXhSOyT4FjwXnq5CmHihRiG/x4Tf+ky3tioRnKVWYaDF+rVGMXj8
        jozlmN9qtwm8F1MahYdSd6+/c6TamL4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-572-Ys7CTAmtNBi_UcfwC9ezIQ-1; Fri, 23 Apr 2021 15:08:22 -0400
X-MC-Unique: Ys7CTAmtNBi_UcfwC9ezIQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C91B2107ACCD;
        Fri, 23 Apr 2021 19:08:20 +0000 (UTC)
Received: from bfoster (ovpn-112-25.rdu2.redhat.com [10.10.112.25])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5DB135D6D1;
        Fri, 23 Apr 2021 19:08:20 +0000 (UTC)
Date:   Fri, 23 Apr 2021 15:08:18 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v17 11/11] xfs: Add delay ready attr set routines
Message-ID: <YIMbIiSgkzY06rRf@bfoster>
References: <20210416092045.2215-1-allison.henderson@oracle.com>
 <20210416092045.2215-12-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210416092045.2215-12-allison.henderson@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 16, 2021 at 02:20:45AM -0700, Allison Henderson wrote:
> This patch modifies the attr set routines to be delay ready. This means
> they no longer roll or commit transactions, but instead return -EAGAIN
> to have the calling routine roll and refresh the transaction.  In this
> series, xfs_attr_set_args has become xfs_attr_set_iter, which uses a
> state machine like switch to keep track of where it was when EAGAIN was
> returned. See xfs_attr.h for a more detailed diagram of the states.
> 
> Two new helper functions have been added: xfs_attr_rmtval_find_space and
> xfs_attr_rmtval_set_blk.  They provide a subset of logic similar to
> xfs_attr_rmtval_set, but they store the current block in the delay attr
> context to allow the caller to roll the transaction between allocations.
> This helps to simplify and consolidate code used by
> xfs_attr_leaf_addname and xfs_attr_node_addname. xfs_attr_set_args has
> now become a simple loop to refresh the transaction until the operation
> is completed.  Lastly, xfs_attr_rmtval_remove is no longer used, and is
> removed.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> ---

This one looks good to me. My feedback is mostly around some code
formatting and comments, so again I've just appended a diff for your
review. With the various nits addressed:

Reviewed-by: Brian Foster <bfoster@redhat.com>

--- 8< ---

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 302e44efa985..3e242eeac3d7 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -337,15 +337,15 @@ xfs_attr_set_iter(
 	/* State machine switch */
 	switch (dac->dela_state) {
 	case XFS_DAS_UNINIT:
-		if (xfs_attr_is_shortform(dp))
-			return xfs_attr_set_fmt(dac, leaf_bp);
-
 		/*
-		 * After a shortform to leaf conversion, we need to hold the
-		 * leaf and cycle out the transaction.  When we get back,
-		 * we need to release the leaf to release the hold on the leaf
-		 * buffer.
+		 * If the fork is shortform, attempt to add the attr. If there
+		 * is no space, this converts to leaf format and returns
+		 * -EAGAIN with the leaf buffer held across the roll. The caller
+		 * will deal with a transaction roll error, but otherwise
+		 * release the hold once we return with a clean transaction.
 		 */
+		if (xfs_attr_is_shortform(dp))
+			return xfs_attr_set_fmt(dac, leaf_bp);
 		if (*leaf_bp != NULL) {
 			xfs_trans_bhold_release(args->trans, *leaf_bp);
 			*leaf_bp = NULL;
@@ -354,10 +354,6 @@ xfs_attr_set_iter(
 		if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
 			error = xfs_attr_leaf_try_add(args, *leaf_bp);
 			if (error == -ENOSPC) {
-				/*
-				 * Promote the attribute list to the Btree
-				 * format.
-				 */
 				error = xfs_attr3_leaf_to_node(args);
 				if (error)
 					return error;
@@ -382,8 +378,6 @@ xfs_attr_set_iter(
 			}
 
 			dac->dela_state = XFS_DAS_FOUND_LBLK;
-			return -EAGAIN;
-
 		} else {
 			error = xfs_attr_node_addname_find_attr(dac);
 			if (error)
@@ -394,8 +388,8 @@ xfs_attr_set_iter(
 				return error;
 
 			dac->dela_state = XFS_DAS_FOUND_NBLK;
-			return -EAGAIN;
 		}
+		return -EAGAIN;
 	case XFS_DAS_FOUND_LBLK:
 		/*
 		 * If there was an out-of-line value, allocate the blocks we
@@ -415,14 +409,13 @@ xfs_attr_set_iter(
 		}
 
 		/*
-		 * Roll through the "value", allocating blocks on disk as
-		 * required.
+		 * Repeat allocating remote blocks for the attr value until
+		 * blkcnt drops to zero.
 		 */
 		if (dac->blkcnt > 0) {
 			error = xfs_attr_rmtval_set_blk(dac);
 			if (error)
 				return error;
-
 			return -EAGAIN;
 		}
 
@@ -430,14 +423,13 @@ xfs_attr_set_iter(
 		if (error)
 			return error;
 
+		/*
+		 * If this is not a rename, clear the incomplete flag and we're
+		 * done.
+		 */
 		if (!(args->op_flags & XFS_DA_OP_RENAME)) {
-			/*
-			 * Added a "remote" value, just clear the incomplete
-			 *flag.
-			 */
 			if (args->rmtblkno > 0)
 				error = xfs_attr3_leaf_clearflag(args);
-
 			return error;
 		}
 
@@ -450,7 +442,6 @@ xfs_attr_set_iter(
 		 * In a separate transaction, set the incomplete flag on the
 		 * "old" attr and clear the incomplete flag on the "new" attr.
 		 */
-
 		error = xfs_attr3_leaf_flipflags(args);
 		if (error)
 			return error;
@@ -466,16 +457,14 @@ xfs_attr_set_iter(
 		 * "remote" value (if it exists).
 		 */
 		xfs_attr_restore_rmt_blk(args);
-
 		error = xfs_attr_rmtval_invalidate(args);
 		if (error)
 			return error;
 
-		/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
-		dac->dela_state = XFS_DAS_RM_LBLK;
-
 		/* fallthrough */
 	case XFS_DAS_RM_LBLK:
+		/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
+		dac->dela_state = XFS_DAS_RM_LBLK;
 		if (args->rmtblkno) {
 			error = __xfs_attr_rmtval_remove(dac);
 			if (error)
@@ -488,8 +477,9 @@ xfs_attr_set_iter(
 		/* fallthrough */
 	case XFS_DAS_RD_LEAF:
 		/*
-		 * Read in the block containing the "old" attr, then remove the
-		 * "old" attr from that block (neat, huh!)
+		 * This is the last step for leaf format. Read the block with
+		 * the old attr, remove the old attr, check for shortform
+		 * conversion and return.
 		 */
 		error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
 					   &bp);
@@ -498,9 +488,6 @@ xfs_attr_set_iter(
 
 		xfs_attr3_leaf_remove(bp, args);
 
-		/*
-		 * If the result is small enough, shrink it all into the inode.
-		 */
 		forkoff = xfs_attr_shortform_allfit(bp, dp);
 		if (forkoff)
 			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
@@ -510,36 +497,29 @@ xfs_attr_set_iter(
 
 	case XFS_DAS_FOUND_NBLK:
 		/*
-		 * If there was an out-of-line value, allocate the blocks we
-		 * identified for its storage and copy the value.  This is done
-		 * after we create the attribute so that we don't overflow the
-		 * maximum size of a transaction and/or hit a deadlock.
+		 * Find space for remote blocks and fall into the allocation
+		 * state.
 		 */
 		if (args->rmtblkno > 0) {
-			/*
-			 * Open coded xfs_attr_rmtval_set without trans
-			 * handling
-			 */
 			error = xfs_attr_rmtval_find_space(dac);
 			if (error)
 				return error;
-
-			/*
-			 * Roll through the "value", allocating blocks on disk
-			 * as required.  Set the state in case of -EAGAIN return
-			 * code
-			 */
-			dac->dela_state = XFS_DAS_ALLOC_NODE;
 		}
 
 		/* fallthrough */
 	case XFS_DAS_ALLOC_NODE:
+		/*
+		 * If there was an out-of-line value, allocate the blocks we
+		 * identified for its storage and copy the value.  This is done
+		 * after we create the attribute so that we don't overflow the
+		 * maximum size of a transaction and/or hit a deadlock.
+		 */
+		dac->dela_state = XFS_DAS_ALLOC_NODE;
 		if (args->rmtblkno > 0) {
 			if (dac->blkcnt > 0) {
 				error = xfs_attr_rmtval_set_blk(dac);
 				if (error)
 					return error;
-
 				return -EAGAIN;
 			}
 
@@ -548,11 +528,11 @@ xfs_attr_set_iter(
 				return error;
 		}
 
+		/*
+		 * If this was not a rename, clear the incomplete flag and we're
+		 * done.
+		 */
 		if (!(args->op_flags & XFS_DA_OP_RENAME)) {
-			/*
-			 * Added a "remote" value, just clear the incomplete
-			 * flag.
-			 */
 			if (args->rmtblkno > 0)
 				error = xfs_attr3_leaf_clearflag(args);
 			goto out;
@@ -588,11 +568,10 @@ xfs_attr_set_iter(
 		if (error)
 			return error;
 
-		/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
-		dac->dela_state = XFS_DAS_RM_NBLK;
-
 		/* fallthrough */
 	case XFS_DAS_RM_NBLK:
+		/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
+		dac->dela_state = XFS_DAS_RM_NBLK;
 		if (args->rmtblkno) {
 			error = __xfs_attr_rmtval_remove(dac);
 			if (error)
@@ -604,7 +583,12 @@ xfs_attr_set_iter(
 
 		/* fallthrough */
 	case XFS_DAS_CLR_FLAG:
+		/*
+		 * The last state for node format. Look up the old attr and
+		 * remove it.
+		 */
 		error = xfs_attr_node_addname_clear_incomplete(dac);
+		break;
 	default:
 		ASSERT(dac->dela_state != XFS_DAS_RM_SHRINK);
 		break;

