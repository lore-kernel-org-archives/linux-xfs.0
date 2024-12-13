Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA64184
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734051745; cv=none; b=ZEuGWk6LBnr2jBaPqcTxeVUwHRjMXqja+KRyo5oayybM2VIn+cGFys/PO7szvPyjhMbOXuN4Qm0zJk5ZiRfR/HYWDwoB26DeiaKGo7so8Ce6HgZ0I3weWsIRdIQYYZIPY6ML65PLuWT2tqf9GxUvfb99iLvqQQbRQsfjPtsKlf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734051745; c=relaxed/simple;
	bh=MrPwh5YXl0mg5u2sB24zCXUqXlWx2DCpOS2mF+uH4Sg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SgR4TQKfCYRLeP5c/+7sWjwZC6uz92h1Cb3PIHpvI7xhWpyuahWtnJiuTdgRBod00wVE6/M/Tt0kLvhtA1aX3qvIuu6KN5KfRtvwVC7vyrhkh6SAAKACJuHfk8eF0QPDv0TpcgyR9ITCgUvAPLYD7iUqIL6+2UEU4NQevZ5nzFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H3vYcAUk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H3vYcAUk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 099AFC4CECE;
	Fri, 13 Dec 2024 01:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734051745;
	bh=MrPwh5YXl0mg5u2sB24zCXUqXlWx2DCpOS2mF+uH4Sg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=H3vYcAUkLhF66O5s4hDB2tWWKeSEYBYguv+Ixf4ZN2FKtTX3y/uZagt8m2bFmX/lD
	 XLT/qYGe62qdiuMO4OTT1tYXnsIkhWdzXirAzgsuJogUXnzL9fvzqWwqA/q0Fe0dTn
	 nfOilgypv5K30GTPA9wzHmfHw8kmyDl1DnbqOAnD+WWtUQaNK90OOS2SDpnx4TB787
	 kSfPVy8h5QuJHW069tza1C3jAKtED1khF6BX0/uAJgYk6SX0Jpq6oD0047KRZs1Goq
	 g/wZ2bro1sjMKxsmLcE4q+y8EcURbLaeikhkPNqlXEk6ASKl6XYNBQ7KzFaxJCTIjx
	 Mc8o3gP5CQ5LQ==
Date: Thu, 12 Dec 2024 17:02:24 -0800
Subject: [PATCH 07/37] xfs: prepare rmap functions to deal with rtrmapbt
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405123434.1181370.2967234809192965405.stgit@frogsfrogsfrogs>
In-Reply-To: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Prepare the high-level rmap functions to deal with the new realtime
rmapbt and its slightly different conventions.  Provide the ability
to talk to either rmapbt or rtrmapbt formats from the same high
level code.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rmap.c    |   63 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rmap.h    |    3 ++
 fs/xfs/libxfs/xfs_rtgroup.h |   26 ++++++++++++++++++
 3 files changed, 92 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 57dbf99ce00453..da1b004837d3ad 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -25,6 +25,7 @@
 #include "xfs_ag.h"
 #include "xfs_health.h"
 #include "xfs_rmap_item.h"
+#include "xfs_rtgroup.h"
 
 struct kmem_cache	*xfs_rmap_intent_cache;
 
@@ -264,11 +265,69 @@ xfs_rmap_check_irec(
 	return NULL;
 }
 
+static xfs_failaddr_t
+xfs_rtrmap_check_meta_irec(
+	struct xfs_rtgroup		*rtg,
+	const struct xfs_rmap_irec	*irec)
+{
+	struct xfs_mount		*mp = rtg_mount(rtg);
+
+	if (irec->rm_offset != 0)
+		return __this_address;
+	if (irec->rm_flags & XFS_RMAP_UNWRITTEN)
+		return __this_address;
+
+	switch (irec->rm_owner) {
+	case XFS_RMAP_OWN_FS:
+		if (irec->rm_startblock != 0)
+			return __this_address;
+		if (irec->rm_blockcount != mp->m_sb.sb_rextsize)
+			return __this_address;
+		return NULL;
+	default:
+		return __this_address;
+	}
+
+	return NULL;
+}
+
+static xfs_failaddr_t
+xfs_rtrmap_check_inode_irec(
+	struct xfs_rtgroup		*rtg,
+	const struct xfs_rmap_irec	*irec)
+{
+	struct xfs_mount		*mp = rtg_mount(rtg);
+
+	if (!xfs_verify_ino(mp, irec->rm_owner))
+		return __this_address;
+	if (!xfs_verify_rgbext(rtg, irec->rm_startblock, irec->rm_blockcount))
+		return __this_address;
+	if (!xfs_verify_fileext(mp, irec->rm_offset, irec->rm_blockcount))
+		return __this_address;
+	return NULL;
+}
+
+xfs_failaddr_t
+xfs_rtrmap_check_irec(
+	struct xfs_rtgroup		*rtg,
+	const struct xfs_rmap_irec	*irec)
+{
+	if (irec->rm_blockcount == 0)
+		return __this_address;
+	if (irec->rm_flags & (XFS_RMAP_BMBT_BLOCK | XFS_RMAP_ATTR_FORK))
+		return __this_address;
+	if (XFS_RMAP_NON_INODE_OWNER(irec->rm_owner))
+		return xfs_rtrmap_check_meta_irec(rtg, irec);
+	return xfs_rtrmap_check_inode_irec(rtg, irec);
+}
+
 static inline xfs_failaddr_t
 xfs_rmap_check_btrec(
 	struct xfs_btree_cur		*cur,
 	const struct xfs_rmap_irec	*irec)
 {
+	if (xfs_btree_is_rtrmap(cur->bc_ops))
+		return xfs_rtrmap_check_irec(to_rtg(cur->bc_group), irec);
 	return xfs_rmap_check_irec(to_perag(cur->bc_group), irec);
 }
 
@@ -283,6 +342,10 @@ xfs_rmap_complain_bad_rec(
 	if (xfs_btree_is_mem_rmap(cur->bc_ops))
 		xfs_warn(mp,
  "In-Memory Reverse Mapping BTree record corruption detected at %pS!", fa);
+	else if (xfs_btree_is_rtrmap(cur->bc_ops))
+		xfs_warn(mp,
+ "RT Reverse Mapping BTree record corruption in rtgroup %u detected at %pS!",
+				cur->bc_group->xg_gno, fa);
 	else
 		xfs_warn(mp,
  "Reverse Mapping BTree record corruption in AG %d detected at %pS!",
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index 8e2657af038e9e..1b19f54b65047f 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -7,6 +7,7 @@
 #define __XFS_RMAP_H__
 
 struct xfs_perag;
+struct xfs_rtgroup;
 
 static inline void
 xfs_rmap_ino_bmbt_owner(
@@ -206,6 +207,8 @@ xfs_failaddr_t xfs_rmap_btrec_to_irec(const union xfs_btree_rec *rec,
 		struct xfs_rmap_irec *irec);
 xfs_failaddr_t xfs_rmap_check_irec(struct xfs_perag *pag,
 		const struct xfs_rmap_irec *irec);
+xfs_failaddr_t xfs_rtrmap_check_irec(struct xfs_rtgroup *rtg,
+		const struct xfs_rmap_irec *irec);
 
 int xfs_rmap_has_records(struct xfs_btree_cur *cur, xfs_agblock_t bno,
 		xfs_extlen_t len, enum xbtree_recpacking *outcome);
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index 19f8d302b9aa3f..dc3ce660a01307 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -132,6 +132,32 @@ xfs_rtgroup_next(
 	return xfs_rtgroup_next_range(mp, rtg, 0, mp->m_sb.sb_rgcount - 1);
 }
 
+static inline bool
+xfs_verify_rgbno(
+	struct xfs_rtgroup	*rtg,
+	xfs_rgblock_t		rgbno)
+{
+	ASSERT(xfs_has_rtgroups(rtg_mount(rtg)));
+
+	return xfs_verify_gbno(rtg_group(rtg), rgbno);
+}
+
+/*
+ * Check that [@rgbno,@len] is a valid extent range in @rtg.
+ *
+ * Must only be used for RTG-enabled file systems.
+ */
+static inline bool
+xfs_verify_rgbext(
+	struct xfs_rtgroup	*rtg,
+	xfs_rgblock_t		rgbno,
+	xfs_extlen_t		len)
+{
+	ASSERT(xfs_has_rtgroups(rtg_mount(rtg)));
+
+	return xfs_verify_gbext(rtg_group(rtg), rgbno, len);
+}
+
 static inline xfs_rtblock_t
 xfs_rgbno_to_rtb(
 	struct xfs_rtgroup	*rtg,

