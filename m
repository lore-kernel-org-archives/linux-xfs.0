Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB4F20DD52
	for <linux-xfs@vger.kernel.org>; Mon,  3 Nov 2025 10:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762164864; cv=none; b=RTJtL+pqZSlX2TsDfCkqoNYoPgrJBud/maRrnIzrGTYhZWNJwZAAOoSAILkBjdxw7zXYjyb7jmKgSqg4usP2K6og4I7sVSvoSdj2eVI3/6pomnvn9QHkXkYXfh4YiWD2juSQrzbt1CgRyNLokB6iimsaGzD3FNmLzMLmvsowov4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762164864; c=relaxed/simple;
	bh=9TGbJ/e/+RN3zO2cuRfGYXWjb8su4buTWJNxWDz6HXk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hR4+R5bJEVp7Z1PgIuXCo43RCVxbIKng68vtXCR8keiKlkLxU4zpeuN7E79/WypAGwO1ScZ0LK3rhUWvNvNw9RdkwOZEKR4Y3VOfQQ8VaY5BVIo/uuBBjmx5Co/iMWKoXZVTkCryNwRia8DTNMyP60Ki9mVZDTf+N6RAyFFQqfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EPt5Da2m; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EPt5Da2m"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=6tn4IGSRveoTt6qbXRj5YQqFKHUwPlA02O8ubAmrNfM=; b=EPt5Da2mPO3BKYRBIMzydcDWlH
	AxRvyIl7TKHmuJ0PTZJeI1i12GrBGPvxg4QarJLUXdbKG36JmMDcL+5RCVuHvLbRlUEtvArQl3Vq4
	lqX//wIdAQVSdnpqw8l3wFhAoN9UkkO064bZ0paQI/k8MvQM5QsmCJv0RLAaAT0TgpUg8+an+qHTz
	GpyOXRISejR11RYyguDxNno/u8EqXS0mjLpV/I5uf2NtzwPGu9SoudbsNg6JmYEtV/Sml1oN2eb11
	3zAGI2oHrg5G+Yxo06SUuZ0Y5vGOWq9LXBWd6XUk8Rf7MZDtfVkvO5efrUCw4qNkAOqqybBwlA8n7
	oi9daIgw==;
Received: from [207.253.13.66] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vFrZs-00000009aMG-1Md5;
	Mon, 03 Nov 2025 10:14:20 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v2] xfs: add a xfs_groups_to_rfsbs helper
Date: Mon,  3 Nov 2025 05:14:09 -0500
Message-ID: <20251103101419.2082953-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Plus a rtgroup wrapper and use that to avoid overflows when converting
zone/rtg counts to block counts.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---

Changes since v1:
 - new names

 fs/xfs/libxfs/xfs_group.h    | 9 +++++++++
 fs/xfs/libxfs/xfs_rtgroup.h  | 8 ++++++++
 fs/xfs/xfs_zone_gc.c         | 3 +--
 fs/xfs/xfs_zone_space_resv.c | 8 +++-----
 4 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_group.h b/fs/xfs/libxfs/xfs_group.h
index 4423932a2313..4ae638f1c2c5 100644
--- a/fs/xfs/libxfs/xfs_group.h
+++ b/fs/xfs/libxfs/xfs_group.h
@@ -98,6 +98,15 @@ xfs_group_max_blocks(
 	return xg->xg_mount->m_groups[xg->xg_type].blocks;
 }
 
+static inline xfs_rfsblock_t
+xfs_groups_to_rfsbs(
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
index d4fcf591e63d..a94e925ae67c 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -371,4 +371,12 @@ static inline int xfs_initialize_rtgroups(struct xfs_mount *mp,
 # define xfs_rtgroup_get_geometry(rtg, rgeo)	(-EOPNOTSUPP)
 #endif /* CONFIG_XFS_RT */
 
+static inline xfs_rfsblock_t
+xfs_rtgs_to_rfsbs(
+	struct xfs_mount	*mp,
+	uint32_t		nr_groups)
+{
+	return xfs_groups_to_rfsbs(mp, nr_groups, XG_TYPE_RTG);
+}
+
 #endif /* __LIBXFS_RTGROUP_H */
diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index 4ade54445532..a98939aba7b9 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -181,8 +181,7 @@ xfs_zoned_need_gc(
 	available = xfs_estimate_freecounter(mp, XC_FREE_RTAVAILABLE);
 
 	if (available <
-	    mp->m_groups[XG_TYPE_RTG].blocks *
-	    (mp->m_max_open_zones - XFS_OPEN_GC_ZONES))
+	    xfs_rtgs_to_rfsbs(mp, mp->m_max_open_zones - XFS_OPEN_GC_ZONES))
 		return true;
 
 	free = xfs_estimate_freecounter(mp, XC_FREE_RTEXTENTS);
diff --git a/fs/xfs/xfs_zone_space_resv.c b/fs/xfs/xfs_zone_space_resv.c
index 9cd38716fd25..0e54e557a585 100644
--- a/fs/xfs/xfs_zone_space_resv.c
+++ b/fs/xfs/xfs_zone_space_resv.c
@@ -54,12 +54,10 @@ xfs_zoned_default_resblks(
 {
 	switch (ctr) {
 	case XC_FREE_RTEXTENTS:
-		return (uint64_t)XFS_RESERVED_ZONES *
-			mp->m_groups[XG_TYPE_RTG].blocks +
-			mp->m_sb.sb_rtreserved;
+		return xfs_rtgs_to_rfsbs(mp, XFS_RESERVED_ZONES) +
+				mp->m_sb.sb_rtreserved;
 	case XC_FREE_RTAVAILABLE:
-		return (uint64_t)XFS_GC_ZONES *
-			mp->m_groups[XG_TYPE_RTG].blocks;
+		return xfs_rtgs_to_rfsbs(mp, XFS_GC_ZONES);
 	default:
 		ASSERT(0);
 		return 0;
-- 
2.47.3

