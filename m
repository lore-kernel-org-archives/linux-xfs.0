Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4527D539A
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831942; cv=none; b=b5w9gaRiIureOqM3vvQcpmu0aRCpItgvTA+gc32NcpWhBJ592goIlEQFpZzmC1xWXwyC8aD8qPVf0xgcIVr1ssCKX9iwGlCIDIlzXVeUgvEA1dLjjqVaAcS69pZE28QKme6ChkZgW5YO+xUIwtfoR5pj4L38I6ikBZI8bTpkX3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831942; c=relaxed/simple;
	bh=Z6M5OeTPN8VMm17kB9/XMil7qYsi+qdiw36ZHCxIP68=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BgxDH4BanEcP5JxtBS8IRVu4JebrTFASdBFpC5OpKkxidRxhQOLmSivgvv0fw5KDafh2aUbVuDj7x9GKN7oP9MhLzBfpnOYtpDgEDIqrfO20PisHWPv+C9auY/EOea40TuIiKjqWQavnggkb4rswIJz4kbmG1A0lUvZj05RylmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QejZJRJI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QejZJRJI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20A91C4CECD;
	Wed,  2 Oct 2024 01:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831942;
	bh=Z6M5OeTPN8VMm17kB9/XMil7qYsi+qdiw36ZHCxIP68=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QejZJRJIqKCJ+C94z2pwfsMpi+Y7VegClk2ETEbaoekvUiF1Ztz2m3257ee8u3nCe
	 NbVPtrceee2UuRSJfyBT8BPfctJftcyLWRHqHq7Ye1wRH/bsrQ7s+68DwC+5IQW2fz
	 oPIBfKtyGyA5v2KK1oDNxd7C/YkqQkeRpRFRpObb9zwbjE+d6MtDxbruYohFH8jOFa
	 fdrh1p00qgYXEfckx/MpjTFrqUlvSp88jbIO1ZfkEq6rcB/Q41jbzm86eIvbbyX8kO
	 IazpgANWlmSXtl3NN9T53bLQFtDeShPhaQCsopUMzTDdwUw32CR8AXNDBbFpd7vAlO
	 wWMDIFSKMt0cQ==
Date: Tue, 01 Oct 2024 18:19:01 -0700
Subject: [PATCH 43/64] xfs: clean up rmap log intent item tracepoint callsites
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172783102430.4036371.7906621999791674767.stgit@frogsfrogsfrogs>
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

Source kernel commit: fbe8c7e167a6b226ae0234c26ebb65d8401473a5

Pass the incore rmap structure to the tracepoints instead of open-coding
the argument passing.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_rmap.c |   22 +++++-----------------
 libxfs/xfs_rmap.h |   10 ++++++++++
 2 files changed, 15 insertions(+), 17 deletions(-)


diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 46bee57cc..57c0d9418 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -2584,20 +2584,15 @@ xfs_rmap_finish_one(
 	struct xfs_rmap_intent		*ri,
 	struct xfs_btree_cur		**pcur)
 {
+	struct xfs_owner_info		oinfo;
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_btree_cur		*rcur;
 	struct xfs_buf			*agbp = NULL;
-	int				error = 0;
-	struct xfs_owner_info		oinfo;
 	xfs_agblock_t			bno;
 	bool				unwritten;
+	int				error = 0;
 
-	bno = XFS_FSB_TO_AGBNO(mp, ri->ri_bmap.br_startblock);
-
-	trace_xfs_rmap_deferred(mp, ri->ri_pag->pag_agno, ri->ri_type, bno,
-			ri->ri_owner, ri->ri_whichfork,
-			ri->ri_bmap.br_startoff, ri->ri_bmap.br_blockcount,
-			ri->ri_bmap.br_state);
+	trace_xfs_rmap_deferred(mp, ri);
 
 	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_RMAP_FINISH_ONE))
 		return -EIO;
@@ -2672,15 +2667,6 @@ __xfs_rmap_add(
 {
 	struct xfs_rmap_intent		*ri;
 
-	trace_xfs_rmap_defer(tp->t_mountp,
-			XFS_FSB_TO_AGNO(tp->t_mountp, bmap->br_startblock),
-			type,
-			XFS_FSB_TO_AGBNO(tp->t_mountp, bmap->br_startblock),
-			owner, whichfork,
-			bmap->br_startoff,
-			bmap->br_blockcount,
-			bmap->br_state);
-
 	ri = kmem_cache_alloc(xfs_rmap_intent_cache, GFP_KERNEL | __GFP_NOFAIL);
 	INIT_LIST_HEAD(&ri->ri_list);
 	ri->ri_type = type;
@@ -2688,6 +2674,8 @@ __xfs_rmap_add(
 	ri->ri_whichfork = whichfork;
 	ri->ri_bmap = *bmap;
 
+	trace_xfs_rmap_defer(tp->t_mountp, ri);
+
 	xfs_rmap_update_get_group(tp->t_mountp, ri);
 	xfs_defer_add(tp, &ri->ri_list, &xfs_rmap_update_defer_type);
 }
diff --git a/libxfs/xfs_rmap.h b/libxfs/xfs_rmap.h
index 9d01fe689..731c97137 100644
--- a/libxfs/xfs_rmap.h
+++ b/libxfs/xfs_rmap.h
@@ -157,6 +157,16 @@ enum xfs_rmap_intent_type {
 	XFS_RMAP_FREE,
 };
 
+#define XFS_RMAP_INTENT_STRINGS \
+	{ XFS_RMAP_MAP,			"map" }, \
+	{ XFS_RMAP_MAP_SHARED,		"map_shared" }, \
+	{ XFS_RMAP_UNMAP,		"unmap" }, \
+	{ XFS_RMAP_UNMAP_SHARED,	"unmap_shared" }, \
+	{ XFS_RMAP_CONVERT,		"cvt" }, \
+	{ XFS_RMAP_CONVERT_SHARED,	"cvt_shared" }, \
+	{ XFS_RMAP_ALLOC,		"alloc" }, \
+	{ XFS_RMAP_FREE,		"free" }
+
 struct xfs_rmap_intent {
 	struct list_head			ri_list;
 	enum xfs_rmap_intent_type		ri_type;

