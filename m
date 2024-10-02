Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F86BA27
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727832051; cv=none; b=arSoFlXTFyWsLbYRnSzdlnsCUDrldAZPzbbI6IiZ1UGuhEJyP2sFME2QoSuGocITL1x3ev6NMCkgtGXA7+/8A/jy24RghLA2yWMZV/tHZ4az1OwYuTRtPdL/z8LlVqLWs7sQ3/y3P+IX0vaLQ+Gynk1lnpJe+fjZ7/M2iJavFm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727832051; c=relaxed/simple;
	bh=4T23vnS53igHUl1zgQQbMtlItpC8kn+t3rqhKJCnFu8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AQg6aQBM+nLKPkxjmhQoxDfMBx0HJx9gpp1NRfpSCxaXautc05SXQN7p6iFPRrz+YPALdXi+fMLMv4oe9hA4rLS26sMJSXAMrFEhPnicbVOStsn8S6+0XJffEUa5jhotFHa9/Tkfz+sKGQEQt8GhZsZOleG3UdhEZ+k7WtM9BUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j4p5HunD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j4p5HunD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F3AAC4CEC6;
	Wed,  2 Oct 2024 01:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727832051;
	bh=4T23vnS53igHUl1zgQQbMtlItpC8kn+t3rqhKJCnFu8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=j4p5HunD7TkYd5MlBJM7iRvxOehUoATUW/2iJgI5LWI0zvCTqNxHRocR4NQSh04WG
	 xkwcnwlJKBYqKF6tVq1bDzxB/COjYJECBvQGIqAQP3pR6dCJdFknkv69C2B9tqp3/t
	 OukUqJ0GYhzk2YRZVlFLhXQZ8Mpw6GCIg4b6AtKO0JKMuxIu1n5UqZw8B8MAj129zu
	 ZNUkVtnZbaVI4Dd8sDOsSUqSCsYPiLsemarUbyVkNwtMeBYdl9rfPXbwmJfWjk+DAW
	 9v+dXul9iv9WTj6TkG7KS60clvYhICI7/ArUODDAWCYtz2+TYy/BZJqQDZtKLXkx4h
	 290zOvQ1exyXg==
Date: Tue, 01 Oct 2024 18:20:50 -0700
Subject: [PATCH 50/64] xfs: create specialized classes for refcount
 tracepoints
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172783102535.4036371.3450732570657162424.stgit@frogsfrogsfrogs>
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

Source kernel commit: bb0efb0d0a2885b4c65ca31e2815da2281b99153

The only user of the "ag" tracepoint event classes is the refcount
btree, so rename them to make that obvious and make them take the btree
cursor to simplify the arguments.  This will save us a lot of trouble
later on.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_refcount.c |   24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)


diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index c78d42728..4143aca5f 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -50,7 +50,7 @@ xfs_refcount_lookup_le(
 	xfs_agblock_t		bno,
 	int			*stat)
 {
-	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_ag.pag->pag_agno,
+	trace_xfs_refcount_lookup(cur,
 			xfs_refcount_encode_startblock(bno, domain),
 			XFS_LOOKUP_LE);
 	cur->bc_rec.rc.rc_startblock = bno;
@@ -70,7 +70,7 @@ xfs_refcount_lookup_ge(
 	xfs_agblock_t		bno,
 	int			*stat)
 {
-	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_ag.pag->pag_agno,
+	trace_xfs_refcount_lookup(cur,
 			xfs_refcount_encode_startblock(bno, domain),
 			XFS_LOOKUP_GE);
 	cur->bc_rec.rc.rc_startblock = bno;
@@ -90,7 +90,7 @@ xfs_refcount_lookup_eq(
 	xfs_agblock_t		bno,
 	int			*stat)
 {
-	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_ag.pag->pag_agno,
+	trace_xfs_refcount_lookup(cur,
 			xfs_refcount_encode_startblock(bno, domain),
 			XFS_LOOKUP_LE);
 	cur->bc_rec.rc.rc_startblock = bno;
@@ -1261,11 +1261,9 @@ xfs_refcount_adjust(
 	int			error;
 
 	if (adj == XFS_REFCOUNT_ADJUST_INCREASE)
-		trace_xfs_refcount_increase(cur->bc_mp,
-				cur->bc_ag.pag->pag_agno, *agbno, *aglen);
+		trace_xfs_refcount_increase(cur, *agbno, *aglen);
 	else
-		trace_xfs_refcount_decrease(cur->bc_mp,
-				cur->bc_ag.pag->pag_agno, *agbno, *aglen);
+		trace_xfs_refcount_decrease(cur, *agbno, *aglen);
 
 	/*
 	 * Ensure that no rcextents cross the boundary of the adjustment range.
@@ -1525,8 +1523,7 @@ xfs_refcount_find_shared(
 	int				have;
 	int				error;
 
-	trace_xfs_refcount_find_shared(cur->bc_mp, cur->bc_ag.pag->pag_agno,
-			agbno, aglen);
+	trace_xfs_refcount_find_shared(cur, agbno, aglen);
 
 	/* By default, skip the whole range */
 	*fbno = NULLAGBLOCK;
@@ -1613,8 +1610,7 @@ xfs_refcount_find_shared(
 	}
 
 done:
-	trace_xfs_refcount_find_shared_result(cur->bc_mp,
-			cur->bc_ag.pag->pag_agno, *fbno, *flen);
+	trace_xfs_refcount_find_shared_result(cur, *fbno, *flen);
 
 out_error:
 	if (error)
@@ -1832,8 +1828,7 @@ __xfs_refcount_cow_alloc(
 	xfs_agblock_t		agbno,
 	xfs_extlen_t		aglen)
 {
-	trace_xfs_refcount_cow_increase(rcur->bc_mp, rcur->bc_ag.pag->pag_agno,
-			agbno, aglen);
+	trace_xfs_refcount_cow_increase(rcur, agbno, aglen);
 
 	/* Add refcount btree reservation */
 	return xfs_refcount_adjust_cow(rcur, agbno, aglen,
@@ -1849,8 +1844,7 @@ __xfs_refcount_cow_free(
 	xfs_agblock_t		agbno,
 	xfs_extlen_t		aglen)
 {
-	trace_xfs_refcount_cow_decrease(rcur->bc_mp, rcur->bc_ag.pag->pag_agno,
-			agbno, aglen);
+	trace_xfs_refcount_cow_decrease(rcur, agbno, aglen);
 
 	/* Remove refcount btree reservation */
 	return xfs_refcount_adjust_cow(rcur, agbno, aglen,

