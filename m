Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CF08C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Apr 2022 09:46:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241594AbiDNJtE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Apr 2022 05:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242297AbiDNJsQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Apr 2022 05:48:16 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E415678FFD
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 02:44:46 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-115-138.pa.nsw.optusnet.com.au [49.181.115.138])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id CBA7510C79AB
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 19:44:37 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1new1j-00HZKA-SO
        for linux-xfs@vger.kernel.org; Thu, 14 Apr 2022 19:44:35 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1new1j-00AWzS-RM
        for linux-xfs@vger.kernel.org;
        Thu, 14 Apr 2022 19:44:35 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 05/16] xfs: kill XFS_DAC_LEAF_ADDNAME_INIT
Date:   Thu, 14 Apr 2022 19:44:23 +1000
Message-Id: <20220414094434.2508781-6-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220414094434.2508781-1-david@fromorbit.com>
References: <20220414094434.2508781-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=6257ed06
        a=/kVtbFzwtM2bJgxRVb+eeA==:117 a=/kVtbFzwtM2bJgxRVb+eeA==:17
        a=z0gMJWrwH1QA:10 a=20KFwNOVAAAA:8 a=-5dJtcHi5CXNrSph2GIA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We re-enter the XFS_DAS_FOUND_LBLK state when we have to allocate
multiple extents for a remote xattr. We currently have a flag
called XFS_DAC_LEAF_ADDNAME_INIT to avoid running the remote attr
hole finding code more than once.

However, for the node format tree, we have a separate state for this
so we never reenter the state machine at XFS_DAS_FOUND_NBLK and so
it does not need a special flag to skip over the remote attr hold
finding code.

Convert the leaf block code to use the same state machine as the
node blocks and kill the  XFS_DAC_LEAF_ADDNAME_INIT flag.

This further points out that this "ALLOC" state is only traversed
if we have remote xattrs or we are doing a rename operation. Rename
both the leaf and node alloc states to _ALLOC_RMT to indicate they
are iterating to do allocation of remote xattr blocks.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c | 45 ++++++++++++++++++++--------------------
 fs/xfs/libxfs/xfs_attr.h |  6 ++++--
 fs/xfs/xfs_trace.h       |  3 ++-
 3 files changed, 29 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index b0bbf827fbca..fed476bd048e 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -419,40 +419,41 @@ xfs_attr_set_iter(
 		return xfs_attr_node_addname(attr);
 
 	case XFS_DAS_FOUND_LBLK:
+		/*
+		 * Find space for remote blocks and fall into the allocation
+		 * state.
+		 */
+		if (args->rmtblkno > 0) {
+			error = xfs_attr_rmtval_find_space(attr);
+			if (error)
+				return error;
+		}
+		attr->xattri_dela_state = XFS_DAS_LEAF_ALLOC_RMT;
+		fallthrough;
+	case XFS_DAS_LEAF_ALLOC_RMT:
+
 		/*
 		 * If there was an out-of-line value, allocate the blocks we
 		 * identified for its storage and copy the value.  This is done
 		 * after we create the attribute so that we don't overflow the
 		 * maximum size of a transaction and/or hit a deadlock.
 		 */
-
-		/* Open coded xfs_attr_rmtval_set without trans handling */
-		if ((attr->xattri_flags & XFS_DAC_LEAF_ADDNAME_INIT) == 0) {
-			attr->xattri_flags |= XFS_DAC_LEAF_ADDNAME_INIT;
-			if (args->rmtblkno > 0) {
-				error = xfs_attr_rmtval_find_space(attr);
+		if (args->rmtblkno > 0) {
+			if (attr->xattri_blkcnt > 0) {
+				error = xfs_attr_rmtval_set_blk(attr);
 				if (error)
 					return error;
+				trace_xfs_attr_set_iter_return(
+						attr->xattri_dela_state,
+						args->dp);
+				return -EAGAIN;
 			}
-		}
 
-		/*
-		 * Repeat allocating remote blocks for the attr value until
-		 * blkcnt drops to zero.
-		 */
-		if (attr->xattri_blkcnt > 0) {
-			error = xfs_attr_rmtval_set_blk(attr);
+			error = xfs_attr_rmtval_set_value(args);
 			if (error)
 				return error;
-			trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
-						       args->dp);
-			return -EAGAIN;
 		}
 
-		error = xfs_attr_rmtval_set_value(args);
-		if (error)
-			return error;
-
 		/*
 		 * If this is not a rename, clear the incomplete flag and we're
 		 * done.
@@ -547,15 +548,15 @@ xfs_attr_set_iter(
 				return error;
 		}
 
+		attr->xattri_dela_state = XFS_DAS_NODE_ALLOC_RMT;
 		fallthrough;
-	case XFS_DAS_ALLOC_NODE:
+	case XFS_DAS_NODE_ALLOC_RMT:
 		/*
 		 * If there was an out-of-line value, allocate the blocks we
 		 * identified for its storage and copy the value.  This is done
 		 * after we create the attribute so that we don't overflow the
 		 * maximum size of a transaction and/or hit a deadlock.
 		 */
-		attr->xattri_dela_state = XFS_DAS_ALLOC_NODE;
 		if (args->rmtblkno > 0) {
 			if (attr->xattri_blkcnt > 0) {
 				error = xfs_attr_rmtval_set_blk(attr);
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index fc2a177f6994..184dca735cf3 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -451,11 +451,12 @@ enum xfs_delattr_state {
 	XFS_DAS_RM_NAME,		/* Remove attr name */
 	XFS_DAS_RM_SHRINK,		/* We are shrinking the tree */
 	XFS_DAS_FOUND_LBLK,		/* We found leaf blk for attr */
+	XFS_DAS_LEAF_ALLOC_RMT,		/* We are allocating remote blocks */
 	XFS_DAS_FOUND_NBLK,		/* We found node blk for attr */
+	XFS_DAS_NODE_ALLOC_RMT,		/* We are allocating remote blocks */
 	XFS_DAS_FLIP_LFLAG,		/* Flipped leaf INCOMPLETE attr flag */
 	XFS_DAS_RM_LBLK,		/* A rename is removing leaf blocks */
 	XFS_DAS_RD_LEAF,		/* Read in the new leaf */
-	XFS_DAS_ALLOC_NODE,		/* We are allocating node blocks */
 	XFS_DAS_FLIP_NFLAG,		/* Flipped node INCOMPLETE attr flag */
 	XFS_DAS_RM_NBLK,		/* A rename is removing node blocks */
 	XFS_DAS_CLR_FLAG,		/* Clear incomplete flag */
@@ -471,11 +472,12 @@ enum xfs_delattr_state {
 	{ XFS_DAS_RM_NAME,	"XFS_DAS_RM_NAME" }, \
 	{ XFS_DAS_RM_SHRINK,	"XFS_DAS_RM_SHRINK" }, \
 	{ XFS_DAS_FOUND_LBLK,	"XFS_DAS_FOUND_LBLK" }, \
+	{ XFS_DAS_LEAF_ALLOC_RMT, "XFS_DAS_LEAF_ALLOC_RMT" }, \
 	{ XFS_DAS_FOUND_NBLK,	"XFS_DAS_FOUND_NBLK" }, \
+	{ XFS_DAS_NODE_ALLOC_RMT, "XFS_DAS_NODE_ALLOC_RMT" },  \
 	{ XFS_DAS_FLIP_LFLAG,	"XFS_DAS_FLIP_LFLAG" }, \
 	{ XFS_DAS_RM_LBLK,	"XFS_DAS_RM_LBLK" }, \
 	{ XFS_DAS_RD_LEAF,	"XFS_DAS_RD_LEAF" }, \
-	{ XFS_DAS_ALLOC_NODE,	"XFS_DAS_ALLOC_NODE" }, \
 	{ XFS_DAS_FLIP_NFLAG,	"XFS_DAS_FLIP_NFLAG" }, \
 	{ XFS_DAS_RM_NBLK,	"XFS_DAS_RM_NBLK" }, \
 	{ XFS_DAS_CLR_FLAG,	"XFS_DAS_CLR_FLAG" }, \
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 9fc3fe334b5f..8739cc1e0561 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -4106,11 +4106,12 @@ TRACE_DEFINE_ENUM(XFS_DAS_RMTBLK);
 TRACE_DEFINE_ENUM(XFS_DAS_RM_NAME);
 TRACE_DEFINE_ENUM(XFS_DAS_RM_SHRINK);
 TRACE_DEFINE_ENUM(XFS_DAS_FOUND_LBLK);
+TRACE_DEFINE_ENUM(XFS_DAS_LEAF_ALLOC_RMT);
 TRACE_DEFINE_ENUM(XFS_DAS_FOUND_NBLK);
+TRACE_DEFINE_ENUM(XFS_DAS_NODE_ALLOC_RMT);
 TRACE_DEFINE_ENUM(XFS_DAS_FLIP_LFLAG);
 TRACE_DEFINE_ENUM(XFS_DAS_RM_LBLK);
 TRACE_DEFINE_ENUM(XFS_DAS_RD_LEAF);
-TRACE_DEFINE_ENUM(XFS_DAS_ALLOC_NODE);
 TRACE_DEFINE_ENUM(XFS_DAS_FLIP_NFLAG);
 TRACE_DEFINE_ENUM(XFS_DAS_RM_NBLK);
 TRACE_DEFINE_ENUM(XFS_DAS_CLR_FLAG);
-- 
2.35.1

