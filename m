Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B760FC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:40:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A9DA610CC
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:40:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237763AbhINClu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Sep 2021 22:41:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:53072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236074AbhINClt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Sep 2021 22:41:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18C20610D1;
        Tue, 14 Sep 2021 02:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631587233;
        bh=0tAKvZgHXFfs93He7cgI2CRL2rJiGZW+TWATXGPX7zY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DrDgmOO4obbkiPG8x740POxSnzGiKfQ6677n9Szch8Tvwo43ZvpSYzdqS2tWkrsVz
         CGgawGwobVfjuDRFRcm3iLxP4UTjgcZhMxSKRS5AwJ4Qob8uokmBa+7h+o9kCvJtAJ
         3OwdXndlgoPEHdWgPMioH7mSBqhniTvLtZr8Wp4xVE/wblPJRoVaWi+QoYZNfeVDR2
         CwFeUGk8glHth22qW+VGffUwNuqeu1ykjFTghfHoZPw6yQr5inNLN+5LzR2bCybOXm
         SiqTINVE9Y8Z/CliFL6hujqlW9TwMVwUodIlrsU+T/oy+BoZkr7r4rS2fLksr0N+pU
         DhUmkDrg/S4mw==
Subject: [PATCH 06/43] xfs: add attr state machine tracepoints
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org
Date:   Mon, 13 Sep 2021 19:40:32 -0700
Message-ID: <163158723281.1604118.9407732943126699887.stgit@magnolia>
In-Reply-To: <163158719952.1604118.14415288328687941574.stgit@magnolia>
References: <163158719952.1604118.14415288328687941574.stgit@magnolia>
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
 

