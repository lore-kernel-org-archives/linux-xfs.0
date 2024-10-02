Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A04875256
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727832082; cv=none; b=rOBUd1uxp2w2IjKzzrvIS177wJHMfKpaNB8kY+AGcvLjTcq22tKuKIngDJlMsiiru55544qJZdLY44Tvx4zO3Iv5ruD6CNRrRYQ/2L2nnYf6W/UuaT8M6TuQWbtJkqqBQUzeekJhMb/SQg1+dGEPPxFwDHnhYF95cbdb2UMYqs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727832082; c=relaxed/simple;
	bh=Xst8ByPSUt6mXwYEzOhB0QIZpi7HushEvl3T7kzkTyk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tcTySnRbf4eduJ8HstPiMlrJCiiWP68rOl4oPsaLMo/o1OOIlmdOzyp2xPQaWg0j1u8aL3ybwl4JKHAXxWYch4n69/tuIs+PnLBjPVvDYo9X4tAUTCf5ZkuferqMZNNTTFd6ScuId0tTfSRm7HnJxyWl+D8sbzsIfUUvoU2+smw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fN14XHW3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fN14XHW3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F3D7C4CEC6;
	Wed,  2 Oct 2024 01:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727832082;
	bh=Xst8ByPSUt6mXwYEzOhB0QIZpi7HushEvl3T7kzkTyk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fN14XHW3hk+Yhj6vugO8HBh5iq9x9XokppDAA7X/6voeW2pdTr079nTbnoK2Vuk0u
	 6+54nBrT4ChlOODqY99B0uWvRgvIpi8U5iOp4RpJnhYnF7jRDmbM0mc7Bf/f2S/+Xe
	 iId2jYwOfq2SAhV15864IwSjNG+hc727GoGjaVYSh7xXKbeQRivrP7t9VKkoeCXUYK
	 oCCRciA2DboZOollbv05qZXhA0kQ1CVu94+o31JPVhEtVO2mlqFIecax/FTE8qwuUO
	 w9CTGa7Gh80bY8lAPrriNC1Bf/QG6pfbGuJ3L4sos6n8EINdTeXzp8kX/6LRz5fJvv
	 acu+MdIs5Ao3A==
Date: Tue, 01 Oct 2024 18:21:22 -0700
Subject: [PATCH 52/64] xfs: clean up refcount log intent item tracepoint
 callsites
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172783102565.4036371.11853166721609364845.stgit@frogsfrogsfrogs>
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

Source kernel commit: 886f11c797722650d98c554b28e66f12317a33e4

Pass the incore refcount intent structure to the tracepoints instead of
open-coding the argument passing.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_refcount.c |   14 ++++----------
 libxfs/xfs_refcount.h |    6 ++++++
 2 files changed, 10 insertions(+), 10 deletions(-)


diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 31b6549f5..14d1101b4 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -1366,9 +1366,7 @@ xfs_refcount_finish_one(
 
 	bno = XFS_FSB_TO_AGBNO(mp, ri->ri_startblock);
 
-	trace_xfs_refcount_deferred(mp, XFS_FSB_TO_AGNO(mp, ri->ri_startblock),
-			ri->ri_type, XFS_FSB_TO_AGBNO(mp, ri->ri_startblock),
-			ri->ri_blockcount);
+	trace_xfs_refcount_deferred(mp, ri);
 
 	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_REFCOUNT_FINISH_ONE))
 		return -EIO;
@@ -1431,8 +1429,7 @@ xfs_refcount_finish_one(
 		return -EFSCORRUPTED;
 	}
 	if (!error && ri->ri_blockcount > 0)
-		trace_xfs_refcount_finish_one_leftover(mp, ri->ri_pag->pag_agno,
-				ri->ri_type, bno, ri->ri_blockcount);
+		trace_xfs_refcount_finish_one_leftover(mp, ri);
 	return error;
 }
 
@@ -1448,11 +1445,6 @@ __xfs_refcount_add(
 {
 	struct xfs_refcount_intent	*ri;
 
-	trace_xfs_refcount_defer(tp->t_mountp,
-			XFS_FSB_TO_AGNO(tp->t_mountp, startblock),
-			type, XFS_FSB_TO_AGBNO(tp->t_mountp, startblock),
-			blockcount);
-
 	ri = kmem_cache_alloc(xfs_refcount_intent_cache,
 			GFP_KERNEL | __GFP_NOFAIL);
 	INIT_LIST_HEAD(&ri->ri_list);
@@ -1460,6 +1452,8 @@ __xfs_refcount_add(
 	ri->ri_startblock = startblock;
 	ri->ri_blockcount = blockcount;
 
+	trace_xfs_refcount_defer(tp->t_mountp, ri);
+
 	xfs_refcount_update_get_group(tp->t_mountp, ri);
 	xfs_defer_add(tp, &ri->ri_list, &xfs_refcount_update_defer_type);
 }
diff --git a/libxfs/xfs_refcount.h b/libxfs/xfs_refcount.h
index 9b56768a5..01a206211 100644
--- a/libxfs/xfs_refcount.h
+++ b/libxfs/xfs_refcount.h
@@ -48,6 +48,12 @@ enum xfs_refcount_intent_type {
 	XFS_REFCOUNT_FREE_COW,
 };
 
+#define XFS_REFCOUNT_INTENT_STRINGS \
+	{ XFS_REFCOUNT_INCREASE,	"incr" }, \
+	{ XFS_REFCOUNT_DECREASE,	"decr" }, \
+	{ XFS_REFCOUNT_ALLOC_COW,	"alloc_cow" }, \
+	{ XFS_REFCOUNT_FREE_COW,	"free_cow" }
+
 struct xfs_refcount_intent {
 	struct list_head			ri_list;
 	struct xfs_perag			*ri_pag;

