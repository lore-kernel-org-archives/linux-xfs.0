Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC94384
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LuCk1eOQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E250DC433C7;
	Mon,  1 Jan 2024 00:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067721;
	bh=hbWr5nmOcsQyTlDi48Ic5uQDAZo4kfazEIl9D1cPvaI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LuCk1eOQMHw7p/3FWpAa/knohflwn4m+Fwo5bKBkFENucOO1LztC3hj7W+gM0WM/F
	 Q+WAXTg524Rqdi70qnXBtGvaC3ELuoaeuU9TMnqe4rnqSracYe6TjdQvri0knaWy1a
	 CmaYjlJy45EVj7ZEPEc/PS/LImAfWcxptUjh3QEL2Qx0MQU2Coz3WnFk5+Ma1gciCl
	 ujd4c+R09OcP/i8zO9WJnbOPFgiKfYRxchRxR14a50uyZdT4CKj0gJ8Xyxq5VumBnT
	 LkRH2kXVvENIe/9E7Yxuo/QyASQL2RkE/vV2Tyv5UFw4Yl9M6CXtENj4DiP0cWGuch
	 30mPWSR3f9i/g==
Date: Sun, 31 Dec 2023 16:08:41 +9900
Subject: [PATCH 2/9] xfs: give rmap btree cursor error tracepoints their own
 class
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405014846.1815232.15906808276779223619.stgit@frogsfrogsfrogs>
In-Reply-To: <170405014813.1815232.16195473149230327174.stgit@frogsfrogsfrogs>
References: <170405014813.1815232.16195473149230327174.stgit@frogsfrogsfrogs>
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

Create a new tracepoint class for btree-related errors, then convert all
the rmap tracepoints to use it.  Also fix the one tracepoint that was
abusing the old class by making it a separate tracepoint.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_rmap.c |   33 +++++++++++----------------------
 1 file changed, 11 insertions(+), 22 deletions(-)


diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 8df591840dc..5b2cac8302a 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -110,8 +110,7 @@ xfs_rmap_update(
 			xfs_rmap_irec_offset_pack(irec));
 	error = xfs_btree_update(cur, &rec);
 	if (error)
-		trace_xfs_rmap_update_error(cur->bc_mp,
-				cur->bc_ag.pag->pag_agno, error, _RET_IP_);
+		trace_xfs_rmap_update_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -154,8 +153,7 @@ xfs_rmap_insert(
 	}
 done:
 	if (error)
-		trace_xfs_rmap_insert_error(rcur->bc_mp,
-				rcur->bc_ag.pag->pag_agno, error, _RET_IP_);
+		trace_xfs_rmap_insert_error(rcur, error, _RET_IP_);
 	return error;
 }
 
@@ -193,8 +191,7 @@ xfs_rmap_delete(
 	}
 done:
 	if (error)
-		trace_xfs_rmap_delete_error(rcur->bc_mp,
-				rcur->bc_ag.pag->pag_agno, error, _RET_IP_);
+		trace_xfs_rmap_delete_error(rcur, error, _RET_IP_);
 	return error;
 }
 
@@ -815,8 +812,7 @@ xfs_rmap_unmap(
 			unwritten, oinfo);
 out_error:
 	if (error)
-		trace_xfs_rmap_unmap_error(mp, cur->bc_ag.pag->pag_agno,
-				error, _RET_IP_);
+		trace_xfs_rmap_unmap_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -1138,8 +1134,7 @@ xfs_rmap_map(
 			unwritten, oinfo);
 out_error:
 	if (error)
-		trace_xfs_rmap_map_error(mp, cur->bc_ag.pag->pag_agno,
-				error, _RET_IP_);
+		trace_xfs_rmap_map_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -1334,8 +1329,7 @@ xfs_rmap_convert(
 	     RIGHT.rm_blockcount > XFS_RMAP_LEN_MAX)
 		state &= ~RMAP_RIGHT_CONTIG;
 
-	trace_xfs_rmap_convert_state(mp, cur->bc_ag.pag->pag_agno, state,
-			_RET_IP_);
+	trace_xfs_rmap_convert_state(cur, state, _RET_IP_);
 
 	/* reset the cursor back to PREV */
 	error = xfs_rmap_lookup_le(cur, bno, owner, offset, oldext, NULL, &i);
@@ -1688,8 +1682,7 @@ xfs_rmap_convert(
 			unwritten, oinfo);
 done:
 	if (error)
-		trace_xfs_rmap_convert_error(cur->bc_mp,
-				cur->bc_ag.pag->pag_agno, error, _RET_IP_);
+		trace_xfs_rmap_convert_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -1812,8 +1805,7 @@ xfs_rmap_convert_shared(
 	     RIGHT.rm_blockcount > XFS_RMAP_LEN_MAX)
 		state &= ~RMAP_RIGHT_CONTIG;
 
-	trace_xfs_rmap_convert_state(mp, cur->bc_ag.pag->pag_agno, state,
-			_RET_IP_);
+	trace_xfs_rmap_convert_state(cur, state, _RET_IP_);
 	/*
 	 * Switch out based on the FILLING and CONTIG state bits.
 	 */
@@ -2115,8 +2107,7 @@ xfs_rmap_convert_shared(
 			unwritten, oinfo);
 done:
 	if (error)
-		trace_xfs_rmap_convert_error(cur->bc_mp,
-				cur->bc_ag.pag->pag_agno, error, _RET_IP_);
+		trace_xfs_rmap_convert_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -2315,8 +2306,7 @@ xfs_rmap_unmap_shared(
 			unwritten, oinfo);
 out_error:
 	if (error)
-		trace_xfs_rmap_unmap_error(cur->bc_mp,
-				cur->bc_ag.pag->pag_agno, error, _RET_IP_);
+		trace_xfs_rmap_unmap_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -2476,8 +2466,7 @@ xfs_rmap_map_shared(
 			unwritten, oinfo);
 out_error:
 	if (error)
-		trace_xfs_rmap_map_error(cur->bc_mp,
-				cur->bc_ag.pag->pag_agno, error, _RET_IP_);
+		trace_xfs_rmap_map_error(cur, error, _RET_IP_);
 	return error;
 }
 

