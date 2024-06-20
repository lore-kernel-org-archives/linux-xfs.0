Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41FCF14374E
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 23:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718924977; cv=none; b=kgxTvjjp67zZlVZFYOCRK31WEhnjPohIZPlfwDlGxkeIL3ctJFBzC672fPvBC2iCinQBx8PFYt+jePagQhoeO1I8okSXam0ilpkIN5uZAsEDZbXjjGCvb6DK7H4aJ+obP0sAO9+46im55Pb4LSnceiCQjJvl1p4UNoeEoEE49hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718924977; c=relaxed/simple;
	bh=ewCa1J3LyrlI7RMBaGjs0mySdd48RYz4HveQ3PQZ00Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i0/RfXbg7xoMnLnWUAk3y+KRVUVZzh7ho8cLp1sDklW8Sn0KOOQmj8j85E6KIYwb+cCp1547wVAgDfxYMs/paCtkSZYc22hunL+pazLGBfNinIRXpQXcLXyj3rJ1PhpLddtYm4ALfXSvZ/NG5VOOfMVoXoyu9+Xx6EvjFVsRgk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FXrNaM6j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FXrNaM6j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A0CFC2BD10;
	Thu, 20 Jun 2024 23:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718924977;
	bh=ewCa1J3LyrlI7RMBaGjs0mySdd48RYz4HveQ3PQZ00Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FXrNaM6jPESxrMIwyvOjILevqcFCAEdQ/4SHxxYlvDbODAIQha8wpuQJ7CqszOOzr
	 w9D/Zm5l+yHlf7187cuc+6wnyZZUNjmI2sEkmOVqWed6ZKgiPpHwpbPLbrBfK7fAWP
	 0vFUpQvfdRPR5U841O71y27tKLCFqnfKy73KRoRgL0T2KaCO07YcbpoEtY9ado5QI5
	 PROwIpJsAd8ThZS4NrpiifZPPEOcGofOIav8flYXw0DsVTmdcDe/Hv9o3yJAt8jdm9
	 7CF5y16AVvXnv9ZQdmlHIq5C2ocMMfM706byEWcImFwrfHLH2rhbABXcBxseyDWoNv
	 BqsxZxQBwcUhg==
Date: Thu, 20 Jun 2024 16:09:36 -0700
Subject: [PATCH 01/10] xfs: give refcount btree cursor error tracepoints their
 own class
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892419788.3184748.13995968067171093141.stgit@frogsfrogsfrogs>
In-Reply-To: <171892419746.3184748.6406153597005839426.stgit@frogsfrogsfrogs>
References: <171892419746.3184748.6406153597005839426.stgit@frogsfrogsfrogs>
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
index 4d8bb760c7235..77acd311aa55c 100644
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
index 3ca4605927068..ffaf5d7382363 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3432,9 +3432,9 @@ DEFINE_REFCOUNT_EXTENT_EVENT(xfs_refcount_get);
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
@@ -3449,20 +3449,20 @@ DEFINE_REFCOUNT_DOUBLE_EXTENT_EVENT(xfs_refcount_merge_left_extent);
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

