Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E345F307494
	for <linux-xfs@vger.kernel.org>; Mon, 27 Oct 2025 14:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761573884; cv=none; b=Ygd6IELnoiFn1IbKDaYcVx7JSqUCXtnLJXlBmavg5/S7gZ/SfvFFBxhA35qGRM6spAQbMHyz5Qu9LKlMFv25liw9XM1FP4INYOA555yWAp5dgotKZbUuQHjjFq6iRPsgUT9AcAudm2knqXs6qScTY8BTNrG1cnwN0QwPvUaUY/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761573884; c=relaxed/simple;
	bh=fqydMj4KEnxl+4c8o+A/X/7XiYHis6QYF9OZj9JAUtg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=F4I9LRpH4IFyWMEGWSdFl79SPMAkMsn8stTEAUgeZJp+shKShZbIvM31m32tUNrv/U/3HjLVyzju1sVc02viSn9Yo/FlP2svRq6GoEkGLxn4mWDS2VBeVlkWiWDN6AgRCQY5d8eR+t016m0FTJVnfYEFzwFQBIrX+C246V7Dt58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KnXYLZsH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KnXYLZsH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=k0Nz45HpcDlXHVEBLm3TJDyCIfMn38JujlVnIk5GYYg=; b=KnXYLZsHSkX9UpFHPU5MF9L+sa
	10sU5ovhUkTB6nKiNz2rw8G+KtdbrY+wAeJrNaZU8hp8mjqtflagWhfuhwpDVhkNkppShEOQ4bkv4
	TnChc3QTbxc/Di+Ilkh9r21/uQYT/EbII7cfXZVVRg8AjSBwH9ykUiXadRhENzE1+h8JXlTDqYxTd
	78Qy96DRwzDfsv6TF17ySDp9tO5UfM86ZLDdTh94UpDFL2bGRYBxwLY/4qRXqeqe6o13Ebd1IfQ28
	IaoikVDl1lAvnOWe65tWq/qOIDey4n5o0CxV3q7zyMbYolj4Mszw19yyxub3LUQsDw6c5gBcYaPmP
	4fH3mTKw==;
Received: from [62.218.44.66] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDNpy-0000000E6lc-0JMf;
	Mon, 27 Oct 2025 14:04:42 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: hans.holmberg@wdc.com,
	linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: fix overflows when converting from a count of groups to blocks
Date: Mon, 27 Oct 2025 15:04:39 +0100
Message-ID: <20251027140439.812210-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a xfs_group helper and a xfs_rtgroup wrapper and use that to avoid
overflows when converting zone/rtg counts to block counts.

Fixes: 0bb2193056b5 ("xfs: add support for zoned space reservations")
Fixes: 080d01c41d44 ("xfs: implement zoned garbage collection")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_group.h    | 9 +++++++++
 fs/xfs/libxfs/xfs_rtgroup.h  | 8 ++++++++
 fs/xfs/xfs_zone_gc.c         | 3 +--
 fs/xfs/xfs_zone_space_resv.c | 8 +++-----
 4 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_group.h b/fs/xfs/libxfs/xfs_group.h
index 4423932a2313..a6eabe6da4fb 100644
--- a/fs/xfs/libxfs/xfs_group.h
+++ b/fs/xfs/libxfs/xfs_group.h
@@ -98,6 +98,15 @@ xfs_group_max_blocks(
 	return xg->xg_mount->m_groups[xg->xg_type].blocks;
 }
 
+static inline xfs_rfsblock_t
+xfs_groups_to_fsb(
+	struct xfs_mount	*mp,
+	uint32_t		nr_groups,
+	enum xfs_group_type	type)
+{
+	return (xfs_rfsblock_t)mp->m_groups[type].blocks * nr_groups;
+}
+
 static inline xfs_fsblock_t
 xfs_group_start_fsb(
 	struct xfs_group	*xg)
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index d36a6ae0abe5..a34da969bb6b 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -365,4 +365,12 @@ static inline int xfs_initialize_rtgroups(struct xfs_mount *mp,
 # define xfs_rtgroup_get_geometry(rtg, rgeo)	(-EOPNOTSUPP)
 #endif /* CONFIG_XFS_RT */
 
+static inline xfs_rfsblock_t
+xfs_rtgs_to_rtb(
+	struct xfs_mount	*mp,
+	uint32_t		nr_groups)
+{
+	return xfs_groups_to_fsb(mp, nr_groups, XG_TYPE_RTG);
+}
+
 #endif /* __LIBXFS_RTGROUP_H */
diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index 109877d9a6bf..c43513531200 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -179,8 +179,7 @@ xfs_zoned_need_gc(
 	available = xfs_estimate_freecounter(mp, XC_FREE_RTAVAILABLE);
 
 	if (available <
-	    mp->m_groups[XG_TYPE_RTG].blocks *
-	    (mp->m_max_open_zones - XFS_OPEN_GC_ZONES))
+	    xfs_rtgs_to_rtb(mp, mp->m_max_open_zones - XFS_OPEN_GC_ZONES))
 		return true;
 
 	free = xfs_estimate_freecounter(mp, XC_FREE_RTEXTENTS);
diff --git a/fs/xfs/xfs_zone_space_resv.c b/fs/xfs/xfs_zone_space_resv.c
index 9cd38716fd25..3a1a363fc8ea 100644
--- a/fs/xfs/xfs_zone_space_resv.c
+++ b/fs/xfs/xfs_zone_space_resv.c
@@ -54,12 +54,10 @@ xfs_zoned_default_resblks(
 {
 	switch (ctr) {
 	case XC_FREE_RTEXTENTS:
-		return (uint64_t)XFS_RESERVED_ZONES *
-			mp->m_groups[XG_TYPE_RTG].blocks +
-			mp->m_sb.sb_rtreserved;
+		return xfs_rtgs_to_rtb(mp, XFS_RESERVED_ZONES) +
+				mp->m_sb.sb_rtreserved;
 	case XC_FREE_RTAVAILABLE:
-		return (uint64_t)XFS_GC_ZONES *
-			mp->m_groups[XG_TYPE_RTG].blocks;
+		return xfs_rtgs_to_rtb(mp, XFS_GC_ZONES);
 	default:
 		ASSERT(0);
 		return 0;
-- 
2.47.3

