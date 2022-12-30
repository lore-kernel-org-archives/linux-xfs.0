Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9621C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:20:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235929AbiLaAUg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:20:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235925AbiLaAUf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:20:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 496961E3F0
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:20:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C680AB81E75
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:20:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AD51C433D2;
        Sat, 31 Dec 2022 00:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446031;
        bh=L0wMRy6dsOzdI2xGuPtKR9dKFgTH7VX8YjD5pIcikbs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Mt9Rk7QOlaYmIBdgEkxQtlO7xP3DgS+nogYa7g+xj7/bzm7FiQKz67s+R1QEKHyCx
         KjMTqBw+z/bsTCjbyglP0WSKSUrszPsFvviAWwdySNyPKc7SHHrlJtp6wIQLzOkhYw
         Ut0TWM64uFmlLd7kfGvKp07ORr/TuPwYKAiVUG2PaqWnOGZK9uzJ8v3wxdZj5HRGY2
         elqVanoWP7vnv/U0Ol6VGPlWC8Fo9MMtxaQ72I0jXpOqfESJFcMa3wdrssbwJnKvk7
         9KUswHKSj78axPE98W1VyAMOO87YqvuqbtdRPLXRt1yTHu5Att6bpPI2kqA5tJRaSJ
         KV9skNKXZ100w==
Subject: [PATCH 07/19] xfs: condense extended attributes after an atomic swap
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:00 -0800
Message-ID: <167243868029.713817.7290507359754607129.stgit@magnolia>
In-Reply-To: <167243867932.713817.982387501030567647.stgit@magnolia>
References: <167243867932.713817.982387501030567647.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add a new swapext flag that enables us to perform post-swap processing
on file2 once we're done swapping the extent maps.  If we were swapping
the extended attributes, we want to be able to convert file2's attr fork
from block to inline format.

This isn't used anywhere right now, but we need to have the basic ondisk
flags in place so that a future online xattr repair feature can create
salvaged attrs in a temporary file and swap the attr forks when ready.
If one file is in extents format and the other is inline, we will have to
promote both to extents format to perform the swap.  After the swap, we
can try to condense the fixed file's attr fork back down to inline
format if possible.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_log_format.h |    9 ++++++--
 libxfs/xfs_swapext.c    |   51 ++++++++++++++++++++++++++++++++++++++++++++++-
 libxfs/xfs_swapext.h    |    9 ++++++--
 3 files changed, 64 insertions(+), 5 deletions(-)


diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 65a84fdefe5..378201a7002 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -906,18 +906,23 @@ struct xfs_swap_extent {
 /* Clear the reflink flag from inode2 after the operation. */
 #define XFS_SWAP_EXT_CLEAR_INO2_REFLINK	(1ULL << 4)
 
+/* Try to convert inode2 from block to short format at the end, if possible. */
+#define XFS_SWAP_EXT_CVT_INO2_SF	(1ULL << 5)
+
 #define XFS_SWAP_EXT_FLAGS		(XFS_SWAP_EXT_ATTR_FORK | \
 					 XFS_SWAP_EXT_SET_SIZES | \
 					 XFS_SWAP_EXT_SKIP_INO1_HOLES | \
 					 XFS_SWAP_EXT_CLEAR_INO1_REFLINK | \
-					 XFS_SWAP_EXT_CLEAR_INO2_REFLINK)
+					 XFS_SWAP_EXT_CLEAR_INO2_REFLINK | \
+					 XFS_SWAP_EXT_CVT_INO2_SF)
 
 #define XFS_SWAP_EXT_STRINGS \
 	{ XFS_SWAP_EXT_ATTR_FORK,		"ATTRFORK" }, \
 	{ XFS_SWAP_EXT_SET_SIZES,		"SETSIZES" }, \
 	{ XFS_SWAP_EXT_SKIP_INO1_HOLES,		"SKIP_INO1_HOLES" }, \
 	{ XFS_SWAP_EXT_CLEAR_INO1_REFLINK,	"CLEAR_INO1_REFLINK" }, \
-	{ XFS_SWAP_EXT_CLEAR_INO2_REFLINK,	"CLEAR_INO2_REFLINK" }
+	{ XFS_SWAP_EXT_CLEAR_INO2_REFLINK,	"CLEAR_INO2_REFLINK" }, \
+	{ XFS_SWAP_EXT_CVT_INO2_SF,		"CVT_INO2_SF" }
 
 /* This is the structure used to lay out an sxi log item in the log. */
 struct xfs_sxi_log_format {
diff --git a/libxfs/xfs_swapext.c b/libxfs/xfs_swapext.c
index 3557efedeb6..68aa34de0ed 100644
--- a/libxfs/xfs_swapext.c
+++ b/libxfs/xfs_swapext.c
@@ -21,6 +21,10 @@
 #include "xfs_quota_defs.h"
 #include "xfs_health.h"
 #include "xfs_errortag.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_attr_leaf.h"
+#include "xfs_attr.h"
 
 struct kmem_cache	*xfs_swapext_intent_cache;
 
@@ -119,7 +123,8 @@ static inline bool
 sxi_has_postop_work(const struct xfs_swapext_intent *sxi)
 {
 	return sxi->sxi_flags & (XFS_SWAP_EXT_CLEAR_INO1_REFLINK |
-				 XFS_SWAP_EXT_CLEAR_INO2_REFLINK);
+				 XFS_SWAP_EXT_CLEAR_INO2_REFLINK |
+				 XFS_SWAP_EXT_CVT_INO2_SF);
 }
 
 static inline void
@@ -348,6 +353,36 @@ xfs_swapext_exchange_mappings(
 	sxi_advance(sxi, irec1);
 }
 
+/* Convert inode2's leaf attr fork back to shortform, if possible.. */
+STATIC int
+xfs_swapext_attr_to_sf(
+	struct xfs_trans		*tp,
+	struct xfs_swapext_intent	*sxi)
+{
+	struct xfs_da_args	args = {
+		.dp		= sxi->sxi_ip2,
+		.geo		= tp->t_mountp->m_attr_geo,
+		.whichfork	= XFS_ATTR_FORK,
+		.trans		= tp,
+	};
+	struct xfs_buf		*bp;
+	int			forkoff;
+	int			error;
+
+	if (!xfs_attr_is_leaf(sxi->sxi_ip2))
+		return 0;
+
+	error = xfs_attr3_leaf_read(tp, sxi->sxi_ip2, 0, &bp);
+	if (error)
+		return error;
+
+	forkoff = xfs_attr_shortform_allfit(bp, sxi->sxi_ip2);
+	if (forkoff == 0)
+		return 0;
+
+	return xfs_attr3_leaf_to_shortform(bp, &args, forkoff);
+}
+
 static inline void
 xfs_swapext_clear_reflink(
 	struct xfs_trans	*tp,
@@ -365,6 +400,16 @@ xfs_swapext_do_postop_work(
 	struct xfs_trans		*tp,
 	struct xfs_swapext_intent	*sxi)
 {
+	if (sxi->sxi_flags & XFS_SWAP_EXT_CVT_INO2_SF) {
+		int			error = 0;
+
+		if (sxi->sxi_flags & XFS_SWAP_EXT_ATTR_FORK)
+			error = xfs_swapext_attr_to_sf(tp, sxi);
+		sxi->sxi_flags &= ~XFS_SWAP_EXT_CVT_INO2_SF;
+		if (error)
+			return error;
+	}
+
 	if (sxi->sxi_flags & XFS_SWAP_EXT_CLEAR_INO1_REFLINK) {
 		xfs_swapext_clear_reflink(tp, sxi->sxi_ip1);
 		sxi->sxi_flags &= ~XFS_SWAP_EXT_CLEAR_INO1_REFLINK;
@@ -792,6 +837,8 @@ xfs_swapext_init_intent(
 
 	if (req->req_flags & XFS_SWAP_REQ_SKIP_INO1_HOLES)
 		sxi->sxi_flags |= XFS_SWAP_EXT_SKIP_INO1_HOLES;
+	if (req->req_flags & XFS_SWAP_REQ_CVT_INO2_SF)
+		sxi->sxi_flags |= XFS_SWAP_EXT_CVT_INO2_SF;
 
 	if (req->req_flags & XFS_SWAP_REQ_LOGGED)
 		sxi->sxi_op_flags |= XFS_SWAP_EXT_OP_LOGGED;
@@ -1011,6 +1058,8 @@ xfs_swapext(
 	ASSERT(!(req->req_flags & ~XFS_SWAP_REQ_FLAGS));
 	if (req->req_flags & XFS_SWAP_REQ_SET_SIZES)
 		ASSERT(req->whichfork == XFS_DATA_FORK);
+	if (req->req_flags & XFS_SWAP_REQ_CVT_INO2_SF)
+		ASSERT(req->whichfork == XFS_ATTR_FORK);
 
 	if (req->blockcount == 0)
 		return;
diff --git a/libxfs/xfs_swapext.h b/libxfs/xfs_swapext.h
index 1987897ddc2..6b610fea150 100644
--- a/libxfs/xfs_swapext.h
+++ b/libxfs/xfs_swapext.h
@@ -126,16 +126,21 @@ struct xfs_swapext_req {
 /* Files need to be upgraded to have large extent counts. */
 #define XFS_SWAP_REQ_NREXT64		(1U << 3)
 
+/* Try to convert inode2's fork to local format, if possible. */
+#define XFS_SWAP_REQ_CVT_INO2_SF	(1U << 4)
+
 #define XFS_SWAP_REQ_FLAGS		(XFS_SWAP_REQ_LOGGED | \
 					 XFS_SWAP_REQ_SET_SIZES | \
 					 XFS_SWAP_REQ_SKIP_INO1_HOLES | \
-					 XFS_SWAP_REQ_NREXT64)
+					 XFS_SWAP_REQ_NREXT64 | \
+					 XFS_SWAP_REQ_CVT_INO2_SF)
 
 #define XFS_SWAP_REQ_STRINGS \
 	{ XFS_SWAP_REQ_LOGGED,			"LOGGED" }, \
 	{ XFS_SWAP_REQ_SET_SIZES,		"SETSIZES" }, \
 	{ XFS_SWAP_REQ_SKIP_INO1_HOLES,		"SKIP_INO1_HOLES" }, \
-	{ XFS_SWAP_REQ_NREXT64,			"NREXT64" }
+	{ XFS_SWAP_REQ_NREXT64,			"NREXT64" }, \
+	{ XFS_SWAP_REQ_CVT_INO2_SF,		"CVT_INO2_SF" }
 
 unsigned int xfs_swapext_reflink_prep(const struct xfs_swapext_req *req);
 void xfs_swapext_reflink_finish(struct xfs_trans *tp,

