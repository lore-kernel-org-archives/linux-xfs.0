Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 273FBC433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:18:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235155AbiATASG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:18:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357739AbiATASC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:18:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9089EC06161C
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:18:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31EA16150C
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:18:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E8C4C004E1;
        Thu, 20 Jan 2022 00:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642637881;
        bh=0tAKvZgHXFfs93He7cgI2CRL2rJiGZW+TWATXGPX7zY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=t/yMuLwy5kiMbBTxwjjT1JRmQrj4CISESOlu7xji9i2MyEYRUnDgO3Gu2NeOPtpB+
         Tr2o+keuV4Rsnmz7m3XJaXhihLlDKeqh+GGfUonjgv5Q2AejMHK/quMGbSn5Ow4qXq
         L3v5PFJAvPQFICnfPhBm1q52aa6q0lMDDujULKqCYlDvjuGnsegqswYnr6HdXXLvxQ
         d8LR0g0piPG1M+XPCDYIab1L9PgjYh/X7jH/Nr7JP1hBuJVHeumdOt+LbcuHpvSk13
         5ujEUAAd3W8eIbo/OXCVyuBAoZY6k0Vunu6JrIPp7iUPTnsgTEGvrj1m7dzVHxRlBy
         d87RhYVL6rL+g==
Subject: [PATCH 07/45] xfs: add attr state machine tracepoints
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:18:01 -0800
Message-ID: <164263788124.860211.8673348406529557808.stgit@magnolia>
In-Reply-To: <164263784199.860211.7509808171577819673.stgit@magnolia>
References: <164263784199.860211.7509808171577819673.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Source kernel commit: df0826312a23e495faa91eee0d6ac31bca35dc09

This is a quick patch to add a new xfs_attr_*_return tracepoints.  We
use these to track when ever a new state is set or -EAGAIN is returned

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_trace.h      |    6 ++++++
 libxfs/xfs_attr.c        |   31 +++++++++++++++++++++++++++++--
 libxfs/xfs_attr_remote.c |    1 +
 3 files changed, 36 insertions(+), 2 deletions(-)


diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index a1002638..79743f04 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -39,6 +39,12 @@
 #define trace_xfs_alloc_vextent_loopfailed(a)	((void) 0)
 #define trace_xfs_alloc_vextent_allfailed(a)	((void) 0)
 
+#define trace_xfs_attr_sf_addname_return(...)	((void) 0)
+#define trace_xfs_attr_set_iter_return(...)	((void) 0)
+#define trace_xfs_attr_node_addname_return(...)	((void) 0)
+#define trace_xfs_attr_remove_iter_return(...)	((void) 0)
+#define trace_xfs_attr_rmtval_remove_return(...) ((void) 0)
+
 #define trace_xfs_log_recover_item_add_cont(a,b,c,d)	((void) 0)
 #define trace_xfs_log_recover_item_add(a,b,c,d)	((void) 0)
 
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 80a6a96f..354c7c3f 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -335,6 +335,7 @@ xfs_attr_sf_addname(
 	 * the attr fork to leaf format and will restart with the leaf
 	 * add.
 	 */
+	trace_xfs_attr_sf_addname_return(XFS_DAS_UNINIT, args->dp);
 	dac->flags |= XFS_DAC_DEFER_FINISH;
 	return -EAGAIN;
 }
@@ -394,6 +395,8 @@ xfs_attr_set_iter(
 				 * handling code below
 				 */
 				dac->flags |= XFS_DAC_DEFER_FINISH;
+				trace_xfs_attr_set_iter_return(
+					dac->dela_state, args->dp);
 				return -EAGAIN;
 			} else if (error) {
 				return error;
@@ -411,6 +414,7 @@ xfs_attr_set_iter(
 
 			dac->dela_state = XFS_DAS_FOUND_NBLK;
 		}
+		trace_xfs_attr_set_iter_return(dac->dela_state,	args->dp);
 		return -EAGAIN;
 	case XFS_DAS_FOUND_LBLK:
 		/*
@@ -438,6 +442,8 @@ xfs_attr_set_iter(
 			error = xfs_attr_rmtval_set_blk(dac);
 			if (error)
 				return error;
+			trace_xfs_attr_set_iter_return(dac->dela_state,
+						       args->dp);
 			return -EAGAIN;
 		}
 
@@ -472,6 +478,7 @@ xfs_attr_set_iter(
 		 * series.
 		 */
 		dac->dela_state = XFS_DAS_FLIP_LFLAG;
+		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
 		return -EAGAIN;
 	case XFS_DAS_FLIP_LFLAG:
 		/*
@@ -489,10 +496,14 @@ xfs_attr_set_iter(
 		dac->dela_state = XFS_DAS_RM_LBLK;
 		if (args->rmtblkno) {
 			error = __xfs_attr_rmtval_remove(dac);
+			if (error == -EAGAIN)
+				trace_xfs_attr_set_iter_return(
+					dac->dela_state, args->dp);
 			if (error)
 				return error;
 
 			dac->dela_state = XFS_DAS_RD_LEAF;
+			trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
 			return -EAGAIN;
 		}
 
@@ -542,6 +553,8 @@ xfs_attr_set_iter(
 				error = xfs_attr_rmtval_set_blk(dac);
 				if (error)
 					return error;
+				trace_xfs_attr_set_iter_return(
+					dac->dela_state, args->dp);
 				return -EAGAIN;
 			}
 
@@ -577,6 +590,7 @@ xfs_attr_set_iter(
 		 * series
 		 */
 		dac->dela_state = XFS_DAS_FLIP_NFLAG;
+		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
 		return -EAGAIN;
 
 	case XFS_DAS_FLIP_NFLAG:
@@ -596,10 +610,15 @@ xfs_attr_set_iter(
 		dac->dela_state = XFS_DAS_RM_NBLK;
 		if (args->rmtblkno) {
 			error = __xfs_attr_rmtval_remove(dac);
+			if (error == -EAGAIN)
+				trace_xfs_attr_set_iter_return(
+					dac->dela_state, args->dp);
+
 			if (error)
 				return error;
 
 			dac->dela_state = XFS_DAS_CLR_FLAG;
+			trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
 			return -EAGAIN;
 		}
 
@@ -1176,6 +1195,8 @@ xfs_attr_node_addname(
 			 * this point.
 			 */
 			dac->flags |= XFS_DAC_DEFER_FINISH;
+			trace_xfs_attr_node_addname_return(
+					dac->dela_state, args->dp);
 			return -EAGAIN;
 		}
 
@@ -1422,10 +1443,13 @@ xfs_attr_remove_iter(
 			 * blocks are removed.
 			 */
 			error = __xfs_attr_rmtval_remove(dac);
-			if (error == -EAGAIN)
+			if (error == -EAGAIN) {
+				trace_xfs_attr_remove_iter_return(
+						dac->dela_state, args->dp);
 				return error;
-			else if (error)
+			} else if (error) {
 				goto out;
+			}
 
 			/*
 			 * Refill the state structure with buffers (the prior
@@ -1438,6 +1462,7 @@ xfs_attr_remove_iter(
 				goto out;
 			dac->dela_state = XFS_DAS_RM_NAME;
 			dac->flags |= XFS_DAC_DEFER_FINISH;
+			trace_xfs_attr_remove_iter_return(dac->dela_state, args->dp);
 			return -EAGAIN;
 		}
 
@@ -1466,6 +1491,8 @@ xfs_attr_remove_iter(
 
 			dac->flags |= XFS_DAC_DEFER_FINISH;
 			dac->dela_state = XFS_DAS_RM_SHRINK;
+			trace_xfs_attr_remove_iter_return(
+					dac->dela_state, args->dp);
 			return -EAGAIN;
 		}
 
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index d474ad7d..137e5698 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -695,6 +695,7 @@ __xfs_attr_rmtval_remove(
 	 */
 	if (!done) {
 		dac->flags |= XFS_DAC_DEFER_FINISH;
+		trace_xfs_attr_rmtval_remove_return(dac->dela_state, args->dp);
 		return -EAGAIN;
 	}
 

