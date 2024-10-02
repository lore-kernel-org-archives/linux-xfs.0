Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B8DBE4A
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727832067; cv=none; b=JfrX1RFcNB20ozgP7vAXYDxe9dKfNk0+1XqUxM4Zi9PiHLFcnb32Yw+TDdHhXe3upU15tkBBf5bVjdcq/pU7OII0q8fapjUbGHFiEW6B5TG0Lqph8M3Ff9lfFLjaJhOck+1/HhNAQi0I91td8EYnqUzz5qjcL3yB2U63tOQ9R8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727832067; c=relaxed/simple;
	bh=U3DhqfRb/IPcoKw4obQHUWzoIMnZ4MJtqxHHGZVh4Tk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XLCzSJIbWRpl1lztsdEuT7eeMYdWOaKOY83BmIqiV4y/bQYE0nnNBC6YdIRzwRHsgt5EsniDRmR28znQOauOXPn8wG3NrcXgZHGPyxvYb5L/THZ2LAsftGqnMYaOQNhi/v8vwSf1PoQkrtOu2ZT7lLprTGki6TPwbf7ZyrFsULI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WGKbpTJe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WGKbpTJe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2CE5C4CEC6;
	Wed,  2 Oct 2024 01:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727832066;
	bh=U3DhqfRb/IPcoKw4obQHUWzoIMnZ4MJtqxHHGZVh4Tk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WGKbpTJeD+oClNrvAf9UwezFU8ktye6BgDEn11rdtI3lUM0s1sVpVC6I06jPG8mAt
	 GPob4cubIDQS5Dqsj6jTz/uyUuFkCxP99BNlHrg2PakrrxPT5xM4vuMBDomg334HqW
	 GL7VcW6UXYxXq+w+TrfcC3P2R6737z9jLT/UgXmniP0BJm3CXweCw44b4Kurg/0MDj
	 yk+/Yq2sZ4i8sZHDJGSoAGxNoGyy0YCqpgTY2EYddJleG1L/HpE4LYdy/c95b7nZY9
	 r0bJBFLx20F3GjN9VjLMWbA0su3e90nstK7INrRbkDt14tr3SEDd2gZ0VvqZ+p5JT4
	 r5AtWbVhMB7XQ==
Date: Tue, 01 Oct 2024 18:21:06 -0700
Subject: [PATCH 51/64] xfs: pass btree cursors to refcount btree tracepoints
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172783102550.4036371.8520230321827262231.stgit@frogsfrogsfrogs>
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

Source kernel commit: 8fbac2f1a0947dc45ecf13e9b5aa17b5942b4a2d

Prepare the rest of refcount btree tracepoints for use with realtime
reflink by making them take the btree cursor object as a parameter.
This will save us a lot of trouble later on.

Remove the xfs_refcount_recover_extent tracepoint since it's already
covered by other refcount tracepoints.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_refcount.c |   42 +++++++++++++++---------------------------
 1 file changed, 15 insertions(+), 27 deletions(-)


diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 4143aca5f..31b6549f5 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -182,7 +182,7 @@ xfs_refcount_get_rec(
 	if (fa)
 		return xfs_refcount_complain_bad_rec(cur, fa, irec);
 
-	trace_xfs_refcount_get(cur->bc_mp, cur->bc_ag.pag->pag_agno, irec);
+	trace_xfs_refcount_get(cur, irec);
 	return 0;
 }
 
@@ -200,7 +200,7 @@ xfs_refcount_update(
 	uint32_t		start;
 	int			error;
 
-	trace_xfs_refcount_update(cur->bc_mp, cur->bc_ag.pag->pag_agno, irec);
+	trace_xfs_refcount_update(cur, irec);
 
 	start = xfs_refcount_encode_startblock(irec->rc_startblock,
 			irec->rc_domain);
@@ -227,7 +227,7 @@ xfs_refcount_insert(
 {
 	int				error;
 
-	trace_xfs_refcount_insert(cur->bc_mp, cur->bc_ag.pag->pag_agno, irec);
+	trace_xfs_refcount_insert(cur, irec);
 
 	cur->bc_rec.rc.rc_startblock = irec->rc_startblock;
 	cur->bc_rec.rc.rc_blockcount = irec->rc_blockcount;
@@ -272,7 +272,7 @@ xfs_refcount_delete(
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
-	trace_xfs_refcount_delete(cur->bc_mp, cur->bc_ag.pag->pag_agno, &irec);
+	trace_xfs_refcount_delete(cur, &irec);
 	error = xfs_btree_delete(cur, i);
 	if (XFS_IS_CORRUPT(cur->bc_mp, *i != 1)) {
 		xfs_btree_mark_sick(cur);
@@ -409,8 +409,7 @@ xfs_refcount_split_extent(
 		return 0;
 
 	*shape_changed = true;
-	trace_xfs_refcount_split_extent(cur->bc_mp, cur->bc_ag.pag->pag_agno,
-			&rcext, agbno);
+	trace_xfs_refcount_split_extent(cur, &rcext, agbno);
 
 	/* Establish the right extent. */
 	tmp = rcext;
@@ -453,8 +452,7 @@ xfs_refcount_merge_center_extents(
 	int				error;
 	int				found_rec;
 
-	trace_xfs_refcount_merge_center_extents(cur->bc_mp,
-			cur->bc_ag.pag->pag_agno, left, center, right);
+	trace_xfs_refcount_merge_center_extents(cur, left, center, right);
 
 	ASSERT(left->rc_domain == center->rc_domain);
 	ASSERT(right->rc_domain == center->rc_domain);
@@ -535,8 +533,7 @@ xfs_refcount_merge_left_extent(
 	int				error;
 	int				found_rec;
 
-	trace_xfs_refcount_merge_left_extent(cur->bc_mp,
-			cur->bc_ag.pag->pag_agno, left, cleft);
+	trace_xfs_refcount_merge_left_extent(cur, left, cleft);
 
 	ASSERT(left->rc_domain == cleft->rc_domain);
 
@@ -600,8 +597,7 @@ xfs_refcount_merge_right_extent(
 	int				error;
 	int				found_rec;
 
-	trace_xfs_refcount_merge_right_extent(cur->bc_mp,
-			cur->bc_ag.pag->pag_agno, cright, right);
+	trace_xfs_refcount_merge_right_extent(cur, cright, right);
 
 	ASSERT(right->rc_domain == cright->rc_domain);
 
@@ -740,8 +736,7 @@ xfs_refcount_find_left_extents(
 		cleft->rc_refcount = 1;
 		cleft->rc_domain = domain;
 	}
-	trace_xfs_refcount_find_left_extent(cur->bc_mp, cur->bc_ag.pag->pag_agno,
-			left, cleft, agbno);
+	trace_xfs_refcount_find_left_extent(cur, left, cleft, agbno);
 	return error;
 
 out_error:
@@ -834,8 +829,8 @@ xfs_refcount_find_right_extents(
 		cright->rc_refcount = 1;
 		cright->rc_domain = domain;
 	}
-	trace_xfs_refcount_find_right_extent(cur->bc_mp, cur->bc_ag.pag->pag_agno,
-			cright, right, agbno + aglen);
+	trace_xfs_refcount_find_right_extent(cur, cright, right,
+			agbno + aglen);
 	return error;
 
 out_error:
@@ -1138,8 +1133,7 @@ xfs_refcount_adjust_extents(
 			tmp.rc_refcount = 1 + adj;
 			tmp.rc_domain = XFS_REFC_DOMAIN_SHARED;
 
-			trace_xfs_refcount_modify_extent(cur->bc_mp,
-					cur->bc_ag.pag->pag_agno, &tmp);
+			trace_xfs_refcount_modify_extent(cur, &tmp);
 
 			/*
 			 * Either cover the hole (increment) or
@@ -1204,8 +1198,7 @@ xfs_refcount_adjust_extents(
 		if (ext.rc_refcount == MAXREFCOUNT)
 			goto skip;
 		ext.rc_refcount += adj;
-		trace_xfs_refcount_modify_extent(cur->bc_mp,
-				cur->bc_ag.pag->pag_agno, &ext);
+		trace_xfs_refcount_modify_extent(cur, &ext);
 		cur->bc_refc.nr_ops++;
 		if (ext.rc_refcount > 1) {
 			error = xfs_refcount_update(cur, &ext);
@@ -1720,8 +1713,7 @@ xfs_refcount_adjust_cow_extents(
 		tmp.rc_refcount = 1;
 		tmp.rc_domain = XFS_REFC_DOMAIN_COW;
 
-		trace_xfs_refcount_modify_extent(cur->bc_mp,
-				cur->bc_ag.pag->pag_agno, &tmp);
+		trace_xfs_refcount_modify_extent(cur, &tmp);
 
 		error = xfs_refcount_insert(cur, &tmp,
 				&found_tmp);
@@ -1752,8 +1744,7 @@ xfs_refcount_adjust_cow_extents(
 		}
 
 		ext.rc_refcount = 0;
-		trace_xfs_refcount_modify_extent(cur->bc_mp,
-				cur->bc_ag.pag->pag_agno, &ext);
+		trace_xfs_refcount_modify_extent(cur, &ext);
 		error = xfs_refcount_delete(cur, &found_rec);
 		if (error)
 			goto out_error;
@@ -1989,9 +1980,6 @@ xfs_refcount_recover_cow_leftovers(
 		if (error)
 			goto out_free;
 
-		trace_xfs_refcount_recover_extent(mp, pag->pag_agno,
-				&rr->rr_rrec);
-
 		/* Free the orphan record */
 		fsb = XFS_AGB_TO_FSB(mp, pag->pag_agno,
 				rr->rr_rrec.rc_startblock);

