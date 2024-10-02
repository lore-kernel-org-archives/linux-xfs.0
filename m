Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7D05227
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831911; cv=none; b=Y/tthhMT9XF1FoyNPbrGwhXQoNCBOBKQ6mrAWk4NT8j4RU9YG8wSOiWfMJU1m4sF9sJv273BtlvhtOjBvNTaZV44HxGrvinFMgYmvfFdf6n8dSLqpIf89VsiNFniuTclqxePfdQguGEPz26BCTA9u4b13gpAGXEbCrauOXF1XgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831911; c=relaxed/simple;
	bh=rxw5VjdeDWTZXd81QHGK0uQH/RPwxVsdqml6md0Rg+M=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TVDP44vKcYZtKUAef0IIo+gGge2jUqR9uiv9Ecr4bYlM8X0q9iXfaXFHZ8aCl3X+S9ALl2iybFNjZ++aQWfh4vMl/DBi3Yq6bA1H/HaLo3yOU7+UdwEAMH889saRiTOf4k/oXJlZxIBFMf+Ta7fQ2ePZ4a3XqlGz0I314szo2rQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mPISRbvm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mPISRbvm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF4FFC4CEC6;
	Wed,  2 Oct 2024 01:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831910;
	bh=rxw5VjdeDWTZXd81QHGK0uQH/RPwxVsdqml6md0Rg+M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mPISRbvmgORm0A/OR3ariB0P4OrPlvW7vZRr4kSyAB4BJCMuV+ZMjSjWTFtZDM/ka
	 051PT6JMqVPTIxhD7BsWpk2VqAnuwqIiFR1MOrHxlpXKRXUUzJFxBM62Q6CXrghfpM
	 ZQHqzSSthVdSXDv50rx0uToHCqvs+JuLLJi3yGpvtGl0rlW3JOxnA/xrAOaBJeYyk2
	 3LhwrhRwIiSex46CSS6HTGK51hfc3c+0V/L3IsqDDz0cSIS/XQtROeUJDlkbmGU3sk
	 /StBq/T5BCxtSCsbzJiOhKss17doyHcLSRbnwWNJtNJnWJTbiutys/g2qOoiDjD/py
	 SfBcARq/luEMg==
Date: Tue, 01 Oct 2024 18:18:30 -0700
Subject: [PATCH 41/64] xfs: give rmap btree cursor error tracepoints their own
 class
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172783102399.4036371.3611039986319198280.stgit@frogsfrogsfrogs>
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

Source kernel commit: 71f5a17e526775f001f643c9d54e5b59fa29d7ac

Create a new tracepoint class for btree-related errors, then convert all
the rmap tracepoints to use it.  Also fix the one tracepoint that was
abusing the old class by making it a separate tracepoint.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_rmap.c |   33 +++++++++++----------------------
 1 file changed, 11 insertions(+), 22 deletions(-)


diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index c3195e532..74a30ed81 100644
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
 
@@ -1147,8 +1143,7 @@ xfs_rmap_map(
 			unwritten, oinfo);
 out_error:
 	if (error)
-		trace_xfs_rmap_map_error(mp, cur->bc_ag.pag->pag_agno,
-				error, _RET_IP_);
+		trace_xfs_rmap_map_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -1343,8 +1338,7 @@ xfs_rmap_convert(
 	     RIGHT.rm_blockcount > XFS_RMAP_LEN_MAX)
 		state &= ~RMAP_RIGHT_CONTIG;
 
-	trace_xfs_rmap_convert_state(mp, cur->bc_ag.pag->pag_agno, state,
-			_RET_IP_);
+	trace_xfs_rmap_convert_state(cur, state, _RET_IP_);
 
 	/* reset the cursor back to PREV */
 	error = xfs_rmap_lookup_le(cur, bno, owner, offset, oldext, NULL, &i);
@@ -1697,8 +1691,7 @@ xfs_rmap_convert(
 			unwritten, oinfo);
 done:
 	if (error)
-		trace_xfs_rmap_convert_error(cur->bc_mp,
-				cur->bc_ag.pag->pag_agno, error, _RET_IP_);
+		trace_xfs_rmap_convert_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -1821,8 +1814,7 @@ xfs_rmap_convert_shared(
 	     RIGHT.rm_blockcount > XFS_RMAP_LEN_MAX)
 		state &= ~RMAP_RIGHT_CONTIG;
 
-	trace_xfs_rmap_convert_state(mp, cur->bc_ag.pag->pag_agno, state,
-			_RET_IP_);
+	trace_xfs_rmap_convert_state(cur, state, _RET_IP_);
 	/*
 	 * Switch out based on the FILLING and CONTIG state bits.
 	 */
@@ -2124,8 +2116,7 @@ xfs_rmap_convert_shared(
 			unwritten, oinfo);
 done:
 	if (error)
-		trace_xfs_rmap_convert_error(cur->bc_mp,
-				cur->bc_ag.pag->pag_agno, error, _RET_IP_);
+		trace_xfs_rmap_convert_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -2324,8 +2315,7 @@ xfs_rmap_unmap_shared(
 			unwritten, oinfo);
 out_error:
 	if (error)
-		trace_xfs_rmap_unmap_error(cur->bc_mp,
-				cur->bc_ag.pag->pag_agno, error, _RET_IP_);
+		trace_xfs_rmap_unmap_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -2485,8 +2475,7 @@ xfs_rmap_map_shared(
 			unwritten, oinfo);
 out_error:
 	if (error)
-		trace_xfs_rmap_map_error(cur->bc_mp,
-				cur->bc_ag.pag->pag_agno, error, _RET_IP_);
+		trace_xfs_rmap_map_error(cur, error, _RET_IP_);
 	return error;
 }
 

