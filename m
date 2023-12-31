Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D6FBE48
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pl4/SQbt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B6B5C433C8;
	Sun, 31 Dec 2023 21:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058934;
	bh=OwQ8AGUz3mOwvSBSuTpqoFelNiXTwOAK7lOzSht7ZZk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pl4/SQbtCVW1HqHw0EnXfGviQg1RorJI1dlKKBgP3RponBXCrT46gwMFNpFOl91Js
	 obc76QQQlRDy96zVdm5VVb57lSSfQJBivN+6/Mrn6KUqRUuvOlcUOPMOBEBWvAUeOW
	 /UuodM3HGcmPhaEFqBtm3H0u8BVf09fZc9xQvsE4gLZX60zJL4FdzAZ++1nFc1NdcP
	 W89HlgoSjHMTAIe5xh9/t8/IWeO+eCK2y2TxTSkWhW7GRgl71k1RX8T9ftQpotxRs7
	 IQWuiXQmz+4msaO1oLkhJKD0lH9X2fD7wjVu+MkyqeSvkQa9rWk7eT10wasXLX8Rh5
	 1111R4dY8ohfg==
Date: Sun, 31 Dec 2023 13:42:13 -0800
Subject: [PATCH 01/10] xfs: give refcount btree cursor error tracepoints their
 own class
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404850911.1765989.5416387110293065608.stgit@frogsfrogsfrogs>
In-Reply-To: <170404850874.1765989.3728283509894891914.stgit@frogsfrogsfrogs>
References: <170404850874.1765989.3728283509894891914.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Convert all the refcount tracepoints to use the btree error tracepoint
class.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_refcount.c |   42 ++++++++++++++----------------------------
 fs/xfs/xfs_trace.h           |   26 +++++++++++++-------------
 2 files changed, 27 insertions(+), 41 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 7f4433b2a5dd3..b7fe286589063 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -211,8 +211,7 @@ xfs_refcount_update(
 
 	error = xfs_btree_update(cur, &rec);
 	if (error)
-		trace_xfs_refcount_update_error(cur->bc_mp,
-				cur->bc_ag.pag->pag_agno, error, _RET_IP_);
+		trace_xfs_refcount_update_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -247,8 +246,7 @@ xfs_refcount_insert(
 
 out_error:
 	if (error)
-		trace_xfs_refcount_insert_error(cur->bc_mp,
-				cur->bc_ag.pag->pag_agno, error, _RET_IP_);
+		trace_xfs_refcount_insert_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -288,8 +286,7 @@ xfs_refcount_delete(
 			&found_rec);
 out_error:
 	if (error)
-		trace_xfs_refcount_delete_error(cur->bc_mp,
-				cur->bc_ag.pag->pag_agno, error, _RET_IP_);
+		trace_xfs_refcount_delete_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -438,8 +435,7 @@ xfs_refcount_split_extent(
 	return error;
 
 out_error:
-	trace_xfs_refcount_split_extent_error(cur->bc_mp,
-			cur->bc_ag.pag->pag_agno, error, _RET_IP_);
+	trace_xfs_refcount_split_extent_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -522,8 +518,7 @@ xfs_refcount_merge_center_extents(
 	return error;
 
 out_error:
-	trace_xfs_refcount_merge_center_extents_error(cur->bc_mp,
-			cur->bc_ag.pag->pag_agno, error, _RET_IP_);
+	trace_xfs_refcount_merge_center_extents_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -589,8 +584,7 @@ xfs_refcount_merge_left_extent(
 	return error;
 
 out_error:
-	trace_xfs_refcount_merge_left_extent_error(cur->bc_mp,
-			cur->bc_ag.pag->pag_agno, error, _RET_IP_);
+	trace_xfs_refcount_merge_left_extent_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -658,8 +652,7 @@ xfs_refcount_merge_right_extent(
 	return error;
 
 out_error:
-	trace_xfs_refcount_merge_right_extent_error(cur->bc_mp,
-			cur->bc_ag.pag->pag_agno, error, _RET_IP_);
+	trace_xfs_refcount_merge_right_extent_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -753,8 +746,7 @@ xfs_refcount_find_left_extents(
 	return error;
 
 out_error:
-	trace_xfs_refcount_find_left_extent_error(cur->bc_mp,
-			cur->bc_ag.pag->pag_agno, error, _RET_IP_);
+	trace_xfs_refcount_find_left_extent_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -848,8 +840,7 @@ xfs_refcount_find_right_extents(
 	return error;
 
 out_error:
-	trace_xfs_refcount_find_right_extent_error(cur->bc_mp,
-			cur->bc_ag.pag->pag_agno, error, _RET_IP_);
+	trace_xfs_refcount_find_right_extent_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -1254,8 +1245,7 @@ xfs_refcount_adjust_extents(
 
 	return error;
 out_error:
-	trace_xfs_refcount_modify_extent_error(cur->bc_mp,
-			cur->bc_ag.pag->pag_agno, error, _RET_IP_);
+	trace_xfs_refcount_modify_extent_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -1315,8 +1305,7 @@ xfs_refcount_adjust(
 	return 0;
 
 out_error:
-	trace_xfs_refcount_adjust_error(cur->bc_mp, cur->bc_ag.pag->pag_agno,
-			error, _RET_IP_);
+	trace_xfs_refcount_adjust_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -1630,8 +1619,7 @@ xfs_refcount_find_shared(
 
 out_error:
 	if (error)
-		trace_xfs_refcount_find_shared_error(cur->bc_mp,
-				cur->bc_ag.pag->pag_agno, error, _RET_IP_);
+		trace_xfs_refcount_find_shared_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -1786,8 +1774,7 @@ xfs_refcount_adjust_cow_extents(
 
 	return error;
 out_error:
-	trace_xfs_refcount_modify_extent_error(cur->bc_mp,
-			cur->bc_ag.pag->pag_agno, error, _RET_IP_);
+	trace_xfs_refcount_modify_extent_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -1833,8 +1820,7 @@ xfs_refcount_adjust_cow(
 	return 0;
 
 out_error:
-	trace_xfs_refcount_adjust_cow_error(cur->bc_mp, cur->bc_ag.pag->pag_agno,
-			error, _RET_IP_);
+	trace_xfs_refcount_adjust_cow_error(cur, error, _RET_IP_);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 05d8ff68b09e2..925e87772f3d0 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3517,9 +3517,9 @@ DEFINE_REFCOUNT_EXTENT_EVENT(xfs_refcount_get);
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
@@ -3534,20 +3534,20 @@ DEFINE_REFCOUNT_DOUBLE_EXTENT_EVENT(xfs_refcount_merge_left_extent);
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

