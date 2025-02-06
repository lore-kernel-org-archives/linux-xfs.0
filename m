Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C3323C380
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881557; cv=none; b=TISVkrZL4IDRaNTslddbTh5l48OTCVgHLewH0wnL1D98Q4O8KZbtMBjh09Hpz9DVpJdC+8huMi913vtekmQ7g1Zi3fAQNJzjl1OY8zyAivkfRUTuP7Kl8ddlRqByXPBPVD/w51H9yUnLZaJmxDCuFrvMPLzOeKDS2UC+ZTvGDys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881557; c=relaxed/simple;
	bh=32alhsIJDbkZ5p47+ZoQryDaWSLeY4fsJ8Fd1M732t4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=stl/8g3WxQiLAfe+vouDNjIDjc3Igvu3tt95QiVRt4Ad4f/p0RiSSF7OXRJeDfOxs2hP+j3UseEuwk3UvhvnPr3LeGfwb0J6H7Qumc1ncZhnu6uFaKBsknzEqY6+Ld/UkMokhjQQxhggMjT46prIQ5TG3fFMdgZn8dEsAKWk44U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qx97nDvv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qx97nDvv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5681BC4CEDF;
	Thu,  6 Feb 2025 22:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738881557;
	bh=32alhsIJDbkZ5p47+ZoQryDaWSLeY4fsJ8Fd1M732t4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Qx97nDvv9VXYf6TpG8YHFYgdymg9zA/kxqys4if1MK0WK6k5x2h6N2wcqnZ0p/pGb
	 B0fY/q9lAggk5OxViMmpTquHFdF/j+WfvgjuQuXt4egd8ECbM7lncmwp1/JkMewANm
	 ukgaLs7FCUUvfGu9PCnSDREyoCzDgTZNhbndgdww+ZwM2R4GguMF1IUKE9K6OXRu32
	 /AAd1nWmxYErVg4pLg4Q9MILaiBKLyO3pY2a/8V1oJ7DZPkMwzxetqyQVwwz8SNNju
	 03n8Q3qn2xjFxz2wcmWIKBe9cc8gT1//6q9hGrGu6SOVj2zRZtbuhkH8d7qO4KuTkX
	 9ZsMC7dSMMC+A==
Date: Thu, 06 Feb 2025 14:39:16 -0800
Subject: [PATCH 16/56] xfs: prepare rmap functions to deal with rtrmapbt
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888087037.2739176.18041314160794496737.stgit@frogsfrogsfrogs>
In-Reply-To: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
References: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: adafb31c80e608e63adcf8cae5675db00c734149

Prepare the high-level rmap functions to deal with the new realtime
rmapbt and its slightly different conventions.  Provide the ability
to talk to either rmapbt or rtrmapbt formats from the same high
level code.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_rmap.c    |   63 ++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_rmap.h    |    3 ++
 libxfs/xfs_rtgroup.h |   26 +++++++++++++++++++++
 3 files changed, 92 insertions(+)


diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index e23972f934f9ef..f1bc677c56e8d9 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -24,6 +24,7 @@
 #include "xfs_ag.h"
 #include "xfs_health.h"
 #include "defer_item.h"
+#include "xfs_rtgroup.h"
 
 struct kmem_cache	*xfs_rmap_intent_cache;
 
@@ -263,11 +264,69 @@ xfs_rmap_check_irec(
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
 
@@ -282,6 +341,10 @@ xfs_rmap_complain_bad_rec(
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
diff --git a/libxfs/xfs_rmap.h b/libxfs/xfs_rmap.h
index 8e2657af038e9e..1b19f54b65047f 100644
--- a/libxfs/xfs_rmap.h
+++ b/libxfs/xfs_rmap.h
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
diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
index 2e145ea2de8007..bff319fa5a7173 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
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

