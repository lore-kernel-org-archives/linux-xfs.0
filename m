Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB7DC127
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Po4IKeIy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0162CC433C8;
	Sun, 31 Dec 2023 22:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704061436;
	bh=WxI8qEsi2aBkEaijeNNHjeoGikJkeIf3JAyLr+2EKEQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Po4IKeIynuXLe54h7EmqFylHKTynxyqiW/SJHQt5Oukq4lyIdJZiRro6yTXuLoZsS
	 lNWCvo7QwjD4Jr9B71UJ2mBjWOtxF7DHugD6d7thG8kZtiCEEeNWmTd9EzuhHjy1AS
	 sLADx1K2Xxl7C1atY6XCWbaGq75jbEnuJYCuCIonI8sXTLBwOhoZ7of1U3ulatXLpn
	 /ZaFW+mZSOSkW4hIT6RyLJwrNatORg6HPKUySUbTrxiNf4tunNBITEjzW+jd3MEdQ5
	 ZmZAPN4YpvIM3v+wls3xasHtXT3rczBX2f08ZQ5O8gQBI9+/DeVh1FxdPnDJgApXWY
	 XcaA0b/jMnMmQ==
Date: Sun, 31 Dec 2023 14:23:55 -0800
Subject: [PATCH 1/5] xfs: clean up bmap log intent item tracepoint callsites
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404994833.1795600.112291653464441473.stgit@frogsfrogsfrogs>
In-Reply-To: <170404994817.1795600.10635472836293725435.stgit@frogsfrogsfrogs>
References: <170404994817.1795600.10635472836293725435.stgit@frogsfrogsfrogs>
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

Pass the incore bmap structure to the tracepoints instead of open-coding
the argument passing.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_bmap.c |   19 +++----------------
 libxfs/xfs_bmap.h |    4 ++++
 2 files changed, 7 insertions(+), 16 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 9a2cb5662d1..6b0d6d2e635 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -6163,15 +6163,6 @@ __xfs_bmap_add(
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
 	bi = kmem_cache_alloc(xfs_bmap_intent_cache, GFP_NOFS | __GFP_NOFAIL);
 	INIT_LIST_HEAD(&bi->bi_list);
 	bi->bi_type = type;
@@ -6179,6 +6170,8 @@ __xfs_bmap_add(
 	bi->bi_whichfork = whichfork;
 	bi->bi_bmap = *bmap;
 
+	trace_xfs_bmap_defer(bi);
+
 	xfs_bmap_update_get_group(tp->t_mountp, bi);
 	xfs_defer_add(tp, &bi->bi_list, &xfs_bmap_update_defer_type);
 	return 0;
@@ -6224,13 +6217,7 @@ xfs_bmap_finish_one(
 
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
index 9dd631bc2dc..b477f92c850 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -230,6 +230,10 @@ enum xfs_bmap_intent_type {
 	XFS_BMAP_UNMAP,
 };
 
+#define XFS_BMAP_INTENT_STRINGS \
+	{ XFS_BMAP_MAP,		"map" }, \
+	{ XFS_BMAP_UNMAP,	"unmap" }
+
 struct xfs_bmap_intent {
 	struct list_head			bi_list;
 	enum xfs_bmap_intent_type		bi_type;

