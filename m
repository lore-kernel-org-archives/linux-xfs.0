Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2B49C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:47:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236144AbiLaBrH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:47:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236138AbiLaBrD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:47:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 972EF1DDD3
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:47:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C4EFB81DF6
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:47:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F38C433D2;
        Sat, 31 Dec 2022 01:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451220;
        bh=fASZhtPJUMZEXSn1VpkUGWF96WMnQK5GL3YSZCRhYV0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=aPxSMRWZXjOZbw0ARNoqU/wAZISjAhRwWuOSH70dgpcR7a7qdBuCm9z9QIfJt366H
         Uw4ngTQtx9Qn8UjH/5b8iq/CeNYDYvgsorU8au01hZ2rX1GZSqo/VsNqAv30zvGKG2
         1elMx0liFgNtWSEMSRkQbnvjTdz2CiCwVkZP2++cqqqZABEBKX9qL1znVjcUIYULyR
         ZOOvy/hngfWsFEmMmzjQokruHYnpI0Rqrxbo3vXDNhczi9mCTzXZsidyenhotv/ol4
         1RRW/nXU0VzElt60jgc2IfKqzEJfiY8snMGO8x9Z1Xrv0gxT5NJeCfLvcA6Rc81wmP
         rI22dLUPZpcdg==
Subject: [PATCH 1/5] xfs: give refcount btree cursor error tracepoints their
 own class
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:24 -0800
Message-ID: <167243870459.716629.10907691572155987244.stgit@magnolia>
In-Reply-To: <167243870440.716629.17983217257958002785.stgit@magnolia>
References: <167243870440.716629.17983217257958002785.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Convert all the refcount tracepoints to use the btree error tracepoint
class.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_refcount.c |   42 ++++++++++++++----------------------------
 fs/xfs/xfs_trace.h           |   26 +++++++++++++-------------
 2 files changed, 27 insertions(+), 41 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 83f681fb49fb..b77d40631e60 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -219,8 +219,7 @@ xfs_refcount_update(
 
 	error = xfs_btree_update(cur, &rec);
 	if (error)
-		trace_xfs_refcount_update_error(cur->bc_mp,
-				cur->bc_ag.pag->pag_agno, error, _RET_IP_);
+		trace_xfs_refcount_update_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -255,8 +254,7 @@ xfs_refcount_insert(
 
 out_error:
 	if (error)
-		trace_xfs_refcount_insert_error(cur->bc_mp,
-				cur->bc_ag.pag->pag_agno, error, _RET_IP_);
+		trace_xfs_refcount_insert_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -296,8 +294,7 @@ xfs_refcount_delete(
 			&found_rec);
 out_error:
 	if (error)
-		trace_xfs_refcount_delete_error(cur->bc_mp,
-				cur->bc_ag.pag->pag_agno, error, _RET_IP_);
+		trace_xfs_refcount_delete_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -446,8 +443,7 @@ xfs_refcount_split_extent(
 	return error;
 
 out_error:
-	trace_xfs_refcount_split_extent_error(cur->bc_mp,
-			cur->bc_ag.pag->pag_agno, error, _RET_IP_);
+	trace_xfs_refcount_split_extent_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -530,8 +526,7 @@ xfs_refcount_merge_center_extents(
 	return error;
 
 out_error:
-	trace_xfs_refcount_merge_center_extents_error(cur->bc_mp,
-			cur->bc_ag.pag->pag_agno, error, _RET_IP_);
+	trace_xfs_refcount_merge_center_extents_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -597,8 +592,7 @@ xfs_refcount_merge_left_extent(
 	return error;
 
 out_error:
-	trace_xfs_refcount_merge_left_extent_error(cur->bc_mp,
-			cur->bc_ag.pag->pag_agno, error, _RET_IP_);
+	trace_xfs_refcount_merge_left_extent_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -666,8 +660,7 @@ xfs_refcount_merge_right_extent(
 	return error;
 
 out_error:
-	trace_xfs_refcount_merge_right_extent_error(cur->bc_mp,
-			cur->bc_ag.pag->pag_agno, error, _RET_IP_);
+	trace_xfs_refcount_merge_right_extent_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -761,8 +754,7 @@ xfs_refcount_find_left_extents(
 	return error;
 
 out_error:
-	trace_xfs_refcount_find_left_extent_error(cur->bc_mp,
-			cur->bc_ag.pag->pag_agno, error, _RET_IP_);
+	trace_xfs_refcount_find_left_extent_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -856,8 +848,7 @@ xfs_refcount_find_right_extents(
 	return error;
 
 out_error:
-	trace_xfs_refcount_find_right_extent_error(cur->bc_mp,
-			cur->bc_ag.pag->pag_agno, error, _RET_IP_);
+	trace_xfs_refcount_find_right_extent_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -1256,8 +1247,7 @@ xfs_refcount_adjust_extents(
 
 	return error;
 out_error:
-	trace_xfs_refcount_modify_extent_error(cur->bc_mp,
-			cur->bc_ag.pag->pag_agno, error, _RET_IP_);
+	trace_xfs_refcount_modify_extent_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -1317,8 +1307,7 @@ xfs_refcount_adjust(
 	return 0;
 
 out_error:
-	trace_xfs_refcount_adjust_error(cur->bc_mp, cur->bc_ag.pag->pag_agno,
-			error, _RET_IP_);
+	trace_xfs_refcount_adjust_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -1632,8 +1621,7 @@ xfs_refcount_find_shared(
 
 out_error:
 	if (error)
-		trace_xfs_refcount_find_shared_error(cur->bc_mp,
-				cur->bc_ag.pag->pag_agno, error, _RET_IP_);
+		trace_xfs_refcount_find_shared_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -1788,8 +1776,7 @@ xfs_refcount_adjust_cow_extents(
 
 	return error;
 out_error:
-	trace_xfs_refcount_modify_extent_error(cur->bc_mp,
-			cur->bc_ag.pag->pag_agno, error, _RET_IP_);
+	trace_xfs_refcount_modify_extent_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -1835,8 +1822,7 @@ xfs_refcount_adjust_cow(
 	return 0;
 
 out_error:
-	trace_xfs_refcount_adjust_cow_error(cur->bc_mp, cur->bc_ag.pag->pag_agno,
-			error, _RET_IP_);
+	trace_xfs_refcount_adjust_cow_error(cur, error, _RET_IP_);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index a6de7b6e4afd..d6da679ebaba 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3513,9 +3513,9 @@ DEFINE_REFCOUNT_EXTENT_EVENT(xfs_refcount_get);
 DEFINE_REFCOUNT_EXTENT_EVENT(xfs_refcount_update);
 DEFINE_REFCOUNT_EXTENT_EVENT(xfs_refcount_insert);
 DEFINE_REFCOUNT_EXTENT_EVENT(xfs_refcount_delete);
-DEFINE_AG_ERROR_EVENT(xfs_refcount_insert_error);
-DEFINE_AG_ERROR_EVENT(xfs_refcount_delete_error);
-DEFINE_AG_ERROR_EVENT(xfs_refcount_update_error);
+DEFINE_BTREE_ERROR_EVENT(xfs_refcount_insert_error);
+DEFINE_BTREE_ERROR_EVENT(xfs_refcount_delete_error);
+DEFINE_BTREE_ERROR_EVENT(xfs_refcount_update_error);
 
 /* refcount adjustment tracepoints */
 DEFINE_AG_EXTENT_EVENT(xfs_refcount_increase);
@@ -3530,20 +3530,20 @@ DEFINE_REFCOUNT_DOUBLE_EXTENT_EVENT(xfs_refcount_merge_left_extent);
 DEFINE_REFCOUNT_DOUBLE_EXTENT_EVENT(xfs_refcount_merge_right_extent);
 DEFINE_REFCOUNT_DOUBLE_EXTENT_AT_EVENT(xfs_refcount_find_left_extent);
 DEFINE_REFCOUNT_DOUBLE_EXTENT_AT_EVENT(xfs_refcount_find_right_extent);
-DEFINE_AG_ERROR_EVENT(xfs_refcount_adjust_error);
-DEFINE_AG_ERROR_EVENT(xfs_refcount_adjust_cow_error);
-DEFINE_AG_ERROR_EVENT(xfs_refcount_merge_center_extents_error);
-DEFINE_AG_ERROR_EVENT(xfs_refcount_modify_extent_error);
-DEFINE_AG_ERROR_EVENT(xfs_refcount_split_extent_error);
-DEFINE_AG_ERROR_EVENT(xfs_refcount_merge_left_extent_error);
-DEFINE_AG_ERROR_EVENT(xfs_refcount_merge_right_extent_error);
-DEFINE_AG_ERROR_EVENT(xfs_refcount_find_left_extent_error);
-DEFINE_AG_ERROR_EVENT(xfs_refcount_find_right_extent_error);
+DEFINE_BTREE_ERROR_EVENT(xfs_refcount_adjust_error);
+DEFINE_BTREE_ERROR_EVENT(xfs_refcount_adjust_cow_error);
+DEFINE_BTREE_ERROR_EVENT(xfs_refcount_merge_center_extents_error);
+DEFINE_BTREE_ERROR_EVENT(xfs_refcount_modify_extent_error);
+DEFINE_BTREE_ERROR_EVENT(xfs_refcount_split_extent_error);
+DEFINE_BTREE_ERROR_EVENT(xfs_refcount_merge_left_extent_error);
+DEFINE_BTREE_ERROR_EVENT(xfs_refcount_merge_right_extent_error);
+DEFINE_BTREE_ERROR_EVENT(xfs_refcount_find_left_extent_error);
+DEFINE_BTREE_ERROR_EVENT(xfs_refcount_find_right_extent_error);
 
 /* reflink helpers */
 DEFINE_AG_EXTENT_EVENT(xfs_refcount_find_shared);
 DEFINE_AG_EXTENT_EVENT(xfs_refcount_find_shared_result);
-DEFINE_AG_ERROR_EVENT(xfs_refcount_find_shared_error);
+DEFINE_BTREE_ERROR_EVENT(xfs_refcount_find_shared_error);
 
 DECLARE_EVENT_CLASS(xfs_refcount_deferred_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,

