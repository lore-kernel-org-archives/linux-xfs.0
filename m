Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0814C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Apr 2022 04:26:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345795AbiDLE2P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Apr 2022 00:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345839AbiDLE2L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Apr 2022 00:28:11 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5FA8F32992
        for <linux-xfs@vger.kernel.org>; Mon, 11 Apr 2022 21:25:55 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-233-190.pa.vic.optusnet.com.au [49.186.233.190])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 9CE9C10C7C30;
        Tue, 12 Apr 2022 14:25:47 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ne865-00Gh2M-Tg; Tue, 12 Apr 2022 14:25:45 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1ne865-009NrM-Sk;
        Tue, 12 Apr 2022 14:25:45 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     allison.henderson@oracle.com
Subject: [PATCH 02/10] xfs: make xattri_leaf_bp more useful
Date:   Tue, 12 Apr 2022 14:25:35 +1000
Message-Id: <20220412042543.2234866-3-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412042543.2234866-1-david@fromorbit.com>
References: <20220412042543.2234866-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6254ff4b
        a=bHAvQTfMiaNt/bo4vVGwyA==:117 a=bHAvQTfMiaNt/bo4vVGwyA==:17
        a=z0gMJWrwH1QA:10 a=20KFwNOVAAAA:8 a=MSQD5IXnzoLRaKXEXdcA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We currently set it and hold it when converting from short to leaf
form, then release it only to immediately look it back up again
to do the leaf insert.

Do a bit of refactoring to xfs_attr_leaf_try_add() to avoid this
messy handling of the newly allocated leaf buffer.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c | 50 +++++++++++++++++++++++++---------------
 1 file changed, 32 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index b3d918195160..a4b0b20a3bab 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -319,7 +319,15 @@ xfs_attr_leaf_addname(
 	int			error;
 
 	if (xfs_attr_is_leaf(dp)) {
+
+		/*
+		 * Use the leaf buffer we may already hold locked as a result of
+		 * a sf-to-leaf conversion. The held buffer is no longer valid
+		 * after this call, regardless of the result.
+		 */
 		error = xfs_attr_leaf_try_add(args, attr->xattri_leaf_bp);
+		attr->xattri_leaf_bp = NULL;
+
 		if (error == -ENOSPC) {
 			error = xfs_attr3_leaf_to_node(args);
 			if (error)
@@ -341,6 +349,8 @@ xfs_attr_leaf_addname(
 		}
 		next_state = XFS_DAS_FOUND_LBLK;
 	} else {
+		ASSERT(!attr->xattri_leaf_bp);
+
 		error = xfs_attr_node_addname_find_attr(attr);
 		if (error)
 			return error;
@@ -396,12 +406,6 @@ xfs_attr_set_iter(
 		 */
 		if (xfs_attr_is_shortform(dp))
 			return xfs_attr_sf_addname(attr);
-		if (attr->xattri_leaf_bp != NULL) {
-			xfs_trans_bhold_release(args->trans,
-						attr->xattri_leaf_bp);
-			attr->xattri_leaf_bp = NULL;
-		}
-
 		return xfs_attr_leaf_addname(attr);
 
 	case XFS_DAS_FOUND_LBLK:
@@ -992,18 +996,31 @@ xfs_attr_leaf_try_add(
 	struct xfs_da_args	*args,
 	struct xfs_buf		*bp)
 {
-	int			retval;
+	int			error;
 
 	/*
-	 * Look up the given attribute in the leaf block.  Figure out if
-	 * the given flags produce an error or call for an atomic rename.
+	 * If the caller provided a buffer to us, it is locked and held in
+	 * the transaction because it just did a shortform to leaf conversion.
+	 * Hence we don't need to read it again. Otherwise read in the leaf
+	 * buffer.
 	 */
-	retval = xfs_attr_leaf_hasname(args, &bp);
-	if (retval != -ENOATTR && retval != -EEXIST)
-		return retval;
-	if (retval == -ENOATTR && (args->attr_flags & XATTR_REPLACE))
+	if (bp) {
+		xfs_trans_bhold_release(args->trans, bp);
+	} else {
+		error = xfs_attr3_leaf_read(args->trans, args->dp, 0, &bp);
+		if (error)
+			return error;
+	}
+
+	/*
+	 * Look up the xattr name to set the insertion point for the new xattr.
+	 */
+	error = xfs_attr3_leaf_lookup_int(bp, args);
+	if (error != -ENOATTR && error != -EEXIST)
 		goto out_brelse;
-	if (retval == -EEXIST) {
+	if (error == -ENOATTR && (args->attr_flags & XATTR_REPLACE))
+		goto out_brelse;
+	if (error == -EEXIST) {
 		if (args->attr_flags & XATTR_CREATE)
 			goto out_brelse;
 
@@ -1023,14 +1040,11 @@ xfs_attr_leaf_try_add(
 		args->rmtvaluelen = 0;
 	}
 
-	/*
-	 * Add the attribute to the leaf block
-	 */
 	return xfs_attr3_leaf_add(bp, args);
 
 out_brelse:
 	xfs_trans_brelse(args->trans, bp);
-	return retval;
+	return error;
 }
 
 /*
-- 
2.35.1

