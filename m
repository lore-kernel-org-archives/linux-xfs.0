Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D030E21353
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711425271; cv=none; b=D3SL4nDe2+2fZ16hV6FoZi9yAGn3nXDH62Rl3kf9rOAtnSV2yT2UTMz5MFoarWfnPyb8FDPmgUgM6+UxfMrJS9gxs3rGP/8fUobEkg7zmkMMr+S1ps73xxN21Yfhpsh1Q6XpeFmXXbcG5/dkAk3ji+nP1olYlOUq52ZAeDfT/kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711425271; c=relaxed/simple;
	bh=UQb269XlSpSvcLgkVuuRLMhqFBQtKsmzMbznEu9aCR0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J6AaWs2M2zMuRwohIXyXjofEcwtRt2+zid5al7VwNIg/1ZBghQ5V9rurTYPJQ2tjfTX32OTB7dnLj5tJ+0usGId7wX851VUklbqoBHkYtoliMYYW2irQ/MBVnh9OyJILpl7toRsio0QY7qnejRvMgt4xAVbiumMgLIJT64gBFhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mY1+Jb1S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mY1+Jb1S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1D0CC433C7;
	Tue, 26 Mar 2024 03:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711425271;
	bh=UQb269XlSpSvcLgkVuuRLMhqFBQtKsmzMbznEu9aCR0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mY1+Jb1SN0pM9X2Xb1bKDbpBFjJfbBnxNzQBjTlLEQjftG4FQieSFco7vLuiVQaNb
	 E0qnh5tMewqZzvPDipdtyws8b37El26LmtKItaeuwuZ1N++qY0VoDx6v+Ne1el+O0Z
	 8W+ExbGEFgwOle9JX03SJpA0jHXTwI+gT+9mvYOGROt45KoedQYDN+DHaFNsvu3b5z
	 NPC3iNHUMqnwQzOQi04WVxpBVQ80FwkhhQFga8VqOH5pBNgVrO9i/J7r1n6ArQkGDB
	 kikVZHC4Zc8TQw1YTHQ1nb2BWboM9WJTXrHKm1+VXm+xUigm6setcJSQZij6AXhY5j
	 pugmmnyaJIp/w==
Date: Mon, 25 Mar 2024 20:54:31 -0700
Subject: [PATCH 100/110] xfs: clean up bmap log intent item tracepoint
 callsites
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142132820.2215168.15971543956375690805.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
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

Source kernel commit: 2a15e7686094d1362b5026533b96f57ec989a245

Pass the incore bmap structure to the tracepoints instead of open-coding
the argument passing.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_bmap.c |   19 +++----------------
 libxfs/xfs_bmap.h |    4 ++++
 2 files changed, 7 insertions(+), 16 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index a82a41249fd3..ae4f7e699922 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -6185,15 +6185,6 @@ __xfs_bmap_add(
 {
 	struct xfs_bmap_intent		*bi;
 
-	trace_xfs_bmap_defer(tp->t_mountp,
-			XFS_FSB_TO_AGNO(tp->t_mountp, bmap->br_startblock),
-			type,
-			XFS_FSB_TO_AGBNO(tp->t_mountp, bmap->br_startblock),
-			ip->i_ino, whichfork,
-			bmap->br_startoff,
-			bmap->br_blockcount,
-			bmap->br_state);
-
 	bi = kmem_cache_alloc(xfs_bmap_intent_cache, GFP_KERNEL | __GFP_NOFAIL);
 	INIT_LIST_HEAD(&bi->bi_list);
 	bi->bi_type = type;
@@ -6201,6 +6192,8 @@ __xfs_bmap_add(
 	bi->bi_whichfork = whichfork;
 	bi->bi_bmap = *bmap;
 
+	trace_xfs_bmap_defer(bi);
+
 	xfs_bmap_update_get_group(tp->t_mountp, bi);
 	xfs_defer_add(tp, &bi->bi_list, &xfs_bmap_update_defer_type);
 	return 0;
@@ -6246,13 +6239,7 @@ xfs_bmap_finish_one(
 
 	ASSERT(tp->t_highest_agno == NULLAGNUMBER);
 
-	trace_xfs_bmap_deferred(tp->t_mountp,
-			XFS_FSB_TO_AGNO(tp->t_mountp, bmap->br_startblock),
-			bi->bi_type,
-			XFS_FSB_TO_AGBNO(tp->t_mountp, bmap->br_startblock),
-			bi->bi_owner->i_ino, bi->bi_whichfork,
-			bmap->br_startoff, bmap->br_blockcount,
-			bmap->br_state);
+	trace_xfs_bmap_deferred(bi);
 
 	if (WARN_ON_ONCE(bi->bi_whichfork != XFS_DATA_FORK)) {
 		xfs_bmap_mark_sick(bi->bi_owner, bi->bi_whichfork);
diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index 10b85865204d..0a2fd9304d1c 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -232,6 +232,10 @@ enum xfs_bmap_intent_type {
 	XFS_BMAP_UNMAP,
 };
 
+#define XFS_BMAP_INTENT_STRINGS \
+	{ XFS_BMAP_MAP,		"map" }, \
+	{ XFS_BMAP_UNMAP,	"unmap" }
+
 struct xfs_bmap_intent {
 	struct list_head			bi_list;
 	enum xfs_bmap_intent_type		bi_type;

