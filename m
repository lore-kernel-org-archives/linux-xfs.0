Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9EB07EE
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B7XFXoCk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 484FFC433C7;
	Mon,  1 Jan 2024 00:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068644;
	bh=mCJ8BMV6ts9SnuR70cgNVZcsbguM5ReZVqmfoa48Y9o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=B7XFXoCkf1QD4/f7grgVoLHij4jBzZggmSvxOIkx5ddUVuNqM8Qwq2JNtoWFtOzsY
	 YhJm1HqjOCvDZJGw48g8xMBia1PeduF28xNQToSHY1xkDSvQ109SvekI+YnItPetBi
	 rSDeYhY96LMXA2+nEmVBiJGGms6LEH8HO/giuMQ8UWj3XfZrDKXDLsNBv9VbWH23jH
	 Rn1jX/b1mNhUHjY46MCcUwSeHe0g3xJXIfXUld7bJny/bpICcHpm+J9iH45P+P8lz2
	 efiwIKEeG1zvREJkJMUsXLTX7z6zmZ+9+pQf/c9x8C2+3EIar7d0OOCAOzcEjSAyyQ
	 k5rRS60HX743A==
Date: Sun, 31 Dec 2023 16:24:03 +9900
Subject: [PATCH 1/9] xfs: give refcount btree cursor error tracepoints their
 own class
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405016635.1816837.4406725381956185137.stgit@frogsfrogsfrogs>
In-Reply-To: <170405016616.1816837.2298941345938137266.stgit@frogsfrogsfrogs>
References: <170405016616.1816837.2298941345938137266.stgit@frogsfrogsfrogs>
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
 libxfs/xfs_refcount.c |   42 ++++++++++++++----------------------------
 1 file changed, 14 insertions(+), 28 deletions(-)


diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 0e8daab9986..9bb7acbdc6f 100644
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
 

