Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D806F8F40
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727832035; cv=none; b=lBHNQsH/k6L986D8gRxnmV1GZhm4sja3VTUU3536x+PI4s1yrObsD30N0dyUmz31iJETebnePLiaSNDJQS9ftro4XpVZxU3qWGOMuZ16mvv7uVxwq2HDdkgcwHBLJnwpRx7rOdGcVO/6UfrHy43CKl9Vlpe3kIAZm6TyktBCeuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727832035; c=relaxed/simple;
	bh=EtiuB3M2n9APjs1uSaZM/3EX2x+mSeghXy8dZT8kTyE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W8/t1Uy3vdk6POO4HANfYd1YFlHcOS6eI1PpONP9csG4GRg9EpaiLA613esx+EMoVn9o0QB8c9gB9N7a8iJ8yaQ2pulM2b1IEqeKDyJcl+RmeDnQ5aGabWAZf5I1RfgwaNeQUZn5oANh9ncfWFkDBBwXj2FQeLZ1HWb4VrhZBug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sv6jhHwx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sv6jhHwx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B438EC4CEC6;
	Wed,  2 Oct 2024 01:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727832035;
	bh=EtiuB3M2n9APjs1uSaZM/3EX2x+mSeghXy8dZT8kTyE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Sv6jhHwxgS1paK3iJzar70cwrnIHbqiHS6C+XuWBWRoP7U1x6T4DzUKvmhfxS5BqE
	 u8xyBrbxaVWREZhpPu4j8T5VT+6I6WKmDmdqJZ3WF1qxZlfw9pdMQXdRffEvhRU6fd
	 oME+ax8qpE6O+dr7L823kQlofn/lhn04RCG96I+wjq5UvhNqUdmANFEnAQyH+WECBI
	 fq/lstwiQ++hfbeW8w6JyOyhFcb2q/RjkwEbsaPdFK7xUq7VGlI7BXdrD4Ej9fXA6M
	 mwaUU6HzNRXvCU8FtLPfdgtyNK1FN+I7WBNkg0sLRn6ExNEEYclVM9PtH9MNu1qIBh
	 zOjVOn4EPjQbg==
Date: Tue, 01 Oct 2024 18:20:35 -0700
Subject: [PATCH 49/64] xfs: give refcount btree cursor error tracepoints their
 own class
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172783102520.4036371.2374416951894228476.stgit@frogsfrogsfrogs>
In-Reply-To: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
References: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
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

Source kernel commit: 7cf2663ff1cfb20f5fe025122016b68920b28041

Convert all the refcount tracepoints to use the btree error tracepoint
class.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_refcount.c |   42 ++++++++++++++----------------------------
 1 file changed, 14 insertions(+), 28 deletions(-)


diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index b4e6900be..c78d42728 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -210,8 +210,7 @@ xfs_refcount_update(
 
 	error = xfs_btree_update(cur, &rec);
 	if (error)
-		trace_xfs_refcount_update_error(cur->bc_mp,
-				cur->bc_ag.pag->pag_agno, error, _RET_IP_);
+		trace_xfs_refcount_update_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -246,8 +245,7 @@ xfs_refcount_insert(
 
 out_error:
 	if (error)
-		trace_xfs_refcount_insert_error(cur->bc_mp,
-				cur->bc_ag.pag->pag_agno, error, _RET_IP_);
+		trace_xfs_refcount_insert_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -287,8 +285,7 @@ xfs_refcount_delete(
 			&found_rec);
 out_error:
 	if (error)
-		trace_xfs_refcount_delete_error(cur->bc_mp,
-				cur->bc_ag.pag->pag_agno, error, _RET_IP_);
+		trace_xfs_refcount_delete_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -437,8 +434,7 @@ xfs_refcount_split_extent(
 	return error;
 
 out_error:
-	trace_xfs_refcount_split_extent_error(cur->bc_mp,
-			cur->bc_ag.pag->pag_agno, error, _RET_IP_);
+	trace_xfs_refcount_split_extent_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -521,8 +517,7 @@ xfs_refcount_merge_center_extents(
 	return error;
 
 out_error:
-	trace_xfs_refcount_merge_center_extents_error(cur->bc_mp,
-			cur->bc_ag.pag->pag_agno, error, _RET_IP_);
+	trace_xfs_refcount_merge_center_extents_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -588,8 +583,7 @@ xfs_refcount_merge_left_extent(
 	return error;
 
 out_error:
-	trace_xfs_refcount_merge_left_extent_error(cur->bc_mp,
-			cur->bc_ag.pag->pag_agno, error, _RET_IP_);
+	trace_xfs_refcount_merge_left_extent_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -657,8 +651,7 @@ xfs_refcount_merge_right_extent(
 	return error;
 
 out_error:
-	trace_xfs_refcount_merge_right_extent_error(cur->bc_mp,
-			cur->bc_ag.pag->pag_agno, error, _RET_IP_);
+	trace_xfs_refcount_merge_right_extent_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -752,8 +745,7 @@ xfs_refcount_find_left_extents(
 	return error;
 
 out_error:
-	trace_xfs_refcount_find_left_extent_error(cur->bc_mp,
-			cur->bc_ag.pag->pag_agno, error, _RET_IP_);
+	trace_xfs_refcount_find_left_extent_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -847,8 +839,7 @@ xfs_refcount_find_right_extents(
 	return error;
 
 out_error:
-	trace_xfs_refcount_find_right_extent_error(cur->bc_mp,
-			cur->bc_ag.pag->pag_agno, error, _RET_IP_);
+	trace_xfs_refcount_find_right_extent_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -1253,8 +1244,7 @@ xfs_refcount_adjust_extents(
 
 	return error;
 out_error:
-	trace_xfs_refcount_modify_extent_error(cur->bc_mp,
-			cur->bc_ag.pag->pag_agno, error, _RET_IP_);
+	trace_xfs_refcount_modify_extent_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -1314,8 +1304,7 @@ xfs_refcount_adjust(
 	return 0;
 
 out_error:
-	trace_xfs_refcount_adjust_error(cur->bc_mp, cur->bc_ag.pag->pag_agno,
-			error, _RET_IP_);
+	trace_xfs_refcount_adjust_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -1629,8 +1618,7 @@ xfs_refcount_find_shared(
 
 out_error:
 	if (error)
-		trace_xfs_refcount_find_shared_error(cur->bc_mp,
-				cur->bc_ag.pag->pag_agno, error, _RET_IP_);
+		trace_xfs_refcount_find_shared_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -1785,8 +1773,7 @@ xfs_refcount_adjust_cow_extents(
 
 	return error;
 out_error:
-	trace_xfs_refcount_modify_extent_error(cur->bc_mp,
-			cur->bc_ag.pag->pag_agno, error, _RET_IP_);
+	trace_xfs_refcount_modify_extent_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -1832,8 +1819,7 @@ xfs_refcount_adjust_cow(
 	return 0;
 
 out_error:
-	trace_xfs_refcount_adjust_cow_error(cur->bc_mp, cur->bc_ag.pag->pag_agno,
-			error, _RET_IP_);
+	trace_xfs_refcount_adjust_cow_error(cur, error, _RET_IP_);
 	return error;
 }
 

