Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7907EE
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WbXJFZ03"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14576C433C7;
	Mon,  1 Jan 2024 00:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068691;
	bh=mQLvLoWsR8xQnyv5hkRoe4T/lRU8EnO8XIqlmfZHOSY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WbXJFZ03gaAHRvN5VpiByYXGJo7V8IXAo3eEqSfhZcjJpaK9vRIuF06RSyl/Le9LW
	 sCOaD/ojM3TdzolC6YQrPSvtgXl75QwgrrMN/HijWUXzAHBrx3UY0LuoW7FGrQBo+/
	 wBqPG3ygpusUyesbP8lAqz+srdUDW5z8NWZak9ltqLYGkSJDdVSfLkER7O+2UHigf4
	 ioL5NqrU4F0U9DXf8Zey0V6TAM/t12vqFg55b5q46l56kpMwde5AAZLta5tFnTAi0Z
	 8YU3Sk5FnutFgYBoPsxrq/VTrkUSAJ7r0xi40DY4UeB7Fo5QdKxOyd9kHgg8BKdeMr
	 LrEOUhr1WIuBA==
Date: Sun, 31 Dec 2023 16:24:50 +9900
Subject: [PATCH 4/9] xfs: clean up refcount log intent item tracepoint
 callsites
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405016674.1816837.1510641157689213799.stgit@frogsfrogsfrogs>
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

Pass the incore refcount intent structure to the tracepoints instead of
open-coding the argument passing.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_refcount.c |   14 ++++----------
 libxfs/xfs_refcount.h |    6 ++++++
 2 files changed, 10 insertions(+), 10 deletions(-)


diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 18b04c38cdd..3ae68ea22e3 100644
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
 			GFP_NOFS | __GFP_NOFAIL);
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
index 9b56768a590..01a20621192 100644
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

