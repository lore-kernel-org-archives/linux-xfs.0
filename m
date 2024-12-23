Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD7118052
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734990109; cv=none; b=ThRqnVCz1c0IzBOkaNFjNRtmkNoYYPrLUDBwugLn9FlB8eWPSKwXLOA1wlg33Viz6Z2cSkHtqCUzYdoF7KKESfli4zKfJ6suT7iXsv/30tZjNVq/N77ZAHsIEzRXP7eCLfPWULFaWpYWE42L3VoiyPo/9ROop/Fpo1uH/Rauego=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734990109; c=relaxed/simple;
	bh=tRFa7ReeozaqHVy3/hF8n5QqwOifnsJzmZaQuJfN5yI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d6WM2ATVoMqgxJw+GO+42p3ohLqux7lyqTY1T+nj8ECk1+qNh/Fc3iUV4pyjRyJzRsv7JNWsrlqyw/+kfgoWEzYIW75+ggQWtiWcuO6St35lqEsp/xhfgmNytxvTgv/iKHzeqkkWJW6ofLXhrICZKObYw7UYZ41nkb6dSemnz+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tVozI9jT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tVozI9jT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 452C6C4CED7;
	Mon, 23 Dec 2024 21:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734990109;
	bh=tRFa7ReeozaqHVy3/hF8n5QqwOifnsJzmZaQuJfN5yI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tVozI9jTRZ5jOt+kgD89kevoqhcFZZZ7Ppqkv5uSX7utZfmsIqt6nQW6L8rjev6tn
	 B6v0cWTw8O+XIblAln/7NRcSGVhAI0MIehB7u5Os8BSCDzeAIH67zs6hafrP/bndrJ
	 LgCjKVbU/E2GoTS1RkLVSHJA5UKrjHH28YsRfkwH/sKZdWpl4wtiDxDK9+lUkzDTsZ
	 KUPv3MPO+r6a/HN1XX0yceYAYaroCFnkANYNWBuq2ik6K//lb4y9K+1MpRyGTPBBjK
	 to2Kj+T9Tu9tZk5izhGDY/mYKjEQPqqs9l/pbCKwqj8i8RXNSjfxGiATa7LY/EfYCo
	 zasgtVoR77xOQ==
Date: Mon, 23 Dec 2024 13:41:48 -0800
Subject: [PATCH 18/36] xfs: move metadata health tracking to the generic group
 structure
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498940220.2293042.4076093264884435127.stgit@frogsfrogsfrogs>
In-Reply-To: <173498939893.2293042.8029858406528247316.stgit@frogsfrogsfrogs>
References: <173498939893.2293042.8029858406528247316.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 5c8483cec3fe261a5c1ede7430bab042ed156361

Prepare for also tracking the health status of the upcoming realtime
groups by moving the health tracking code to the generic xfs_group
structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/util.c       |    4 ++--
 libxfs/xfs_ag.c     |    1 -
 libxfs/xfs_ag.h     |    9 ---------
 libxfs/xfs_group.c  |    4 ++++
 libxfs/xfs_group.h  |   12 ++++++++++++
 libxfs/xfs_health.h |   45 +++++++++++++++++----------------------------
 6 files changed, 35 insertions(+), 40 deletions(-)


diff --git a/libxfs/util.c b/libxfs/util.c
index a3f3ad299336c7..97da94506aee01 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -449,8 +449,8 @@ void xfs_ag_geom_health(struct xfs_perag *pag, struct xfs_ag_geometry *ageo) { }
 void xfs_fs_mark_sick(struct xfs_mount *mp, unsigned int mask) { }
 void xfs_agno_mark_sick(struct xfs_mount *mp, xfs_agnumber_t agno,
 		unsigned int mask) { }
-void xfs_ag_mark_sick(struct xfs_perag *pag, unsigned int mask) { }
-void xfs_ag_measure_sickness(struct xfs_perag *pag, unsigned int *sick,
+void xfs_group_mark_sick(struct xfs_group *xg, unsigned int mask) { }
+void xfs_group_measure_sickness(struct xfs_group *xg, unsigned int *sick,
 		unsigned int *checked)
 {
 	*sick = 0;
diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 15d4ac5a99f0e7..20af8b67d86e88 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -230,7 +230,6 @@ xfs_perag_alloc(
 	/* Place kernel structure only init below this point. */
 	spin_lock_init(&pag->pag_ici_lock);
 	spin_lock_init(&pag->pagb_lock);
-	spin_lock_init(&pag->pag_state_lock);
 	INIT_DELAYED_WORK(&pag->pag_blockgc_work, xfs_blockgc_worker);
 	INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
 	xfs_defer_drain_init(&pag->pag_intents_drain);
diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index 80969682dc4746..8271cb72c88387 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -69,13 +69,6 @@ struct xfs_perag {
 #ifdef __KERNEL__
 	/* -- kernel only structures below this line -- */
 
-	/*
-	 * Bitsets of per-ag metadata that have been checked and/or are sick.
-	 * Callers should hold pag_state_lock before accessing this field.
-	 */
-	uint16_t	pag_checked;
-	uint16_t	pag_sick;
-
 #ifdef CONFIG_XFS_ONLINE_REPAIR
 	/*
 	 * Alternate btree heights so that online repair won't trip the write
@@ -87,8 +80,6 @@ struct xfs_perag {
 	uint8_t		pagf_repair_rmap_level;
 #endif
 
-	spinlock_t	pag_state_lock;
-
 	spinlock_t	pagb_lock;	/* lock for pagb_tree */
 	struct rb_root	pagb_tree;	/* ordered tree of busy extents */
 	unsigned int	pagb_gen;	/* generation count for pagb_tree */
diff --git a/libxfs/xfs_group.c b/libxfs/xfs_group.c
index 04d65033b75eca..c5269cd659f327 100644
--- a/libxfs/xfs_group.c
+++ b/libxfs/xfs_group.c
@@ -181,6 +181,10 @@ xfs_group_insert(
 	xg->xg_gno = index;
 	xg->xg_type = type;
 
+#ifdef __KERNEL__
+	spin_lock_init(&xg->xg_state_lock);
+#endif
+
 	/* Active ref owned by mount indicates group is online. */
 	atomic_set(&xg->xg_active_ref, 1);
 
diff --git a/libxfs/xfs_group.h b/libxfs/xfs_group.h
index dd7da90443054b..d2c61dd1f43e44 100644
--- a/libxfs/xfs_group.h
+++ b/libxfs/xfs_group.h
@@ -11,6 +11,18 @@ struct xfs_group {
 	enum xfs_group_type	xg_type;
 	atomic_t		xg_ref;		/* passive reference count */
 	atomic_t		xg_active_ref;	/* active reference count */
+
+#ifdef __KERNEL__
+	/* -- kernel only structures below this line -- */
+
+	/*
+	 * Bitsets of per-ag metadata that have been checked and/or are sick.
+	 * Callers should hold xg_state_lock before accessing this field.
+	 */
+	uint16_t		xg_checked;
+	uint16_t		xg_sick;
+	spinlock_t		xg_state_lock;
+#endif /* __KERNEL__ */
 };
 
 struct xfs_group *xfs_group_get(struct xfs_mount *mp, uint32_t index,
diff --git a/libxfs/xfs_health.h b/libxfs/xfs_health.h
index b0edb4288e5929..13301420a2f670 100644
--- a/libxfs/xfs_health.h
+++ b/libxfs/xfs_health.h
@@ -6,6 +6,8 @@
 #ifndef __XFS_HEALTH_H__
 #define __XFS_HEALTH_H__
 
+struct xfs_group;
+
 /*
  * In-Core Filesystem Health Assessments
  * =====================================
@@ -197,10 +199,12 @@ void xfs_rt_measure_sickness(struct xfs_mount *mp, unsigned int *sick,
 
 void xfs_agno_mark_sick(struct xfs_mount *mp, xfs_agnumber_t agno,
 		unsigned int mask);
-void xfs_ag_mark_sick(struct xfs_perag *pag, unsigned int mask);
-void xfs_ag_mark_corrupt(struct xfs_perag *pag, unsigned int mask);
-void xfs_ag_mark_healthy(struct xfs_perag *pag, unsigned int mask);
-void xfs_ag_measure_sickness(struct xfs_perag *pag, unsigned int *sick,
+void xfs_group_mark_sick(struct xfs_group *xg, unsigned int mask);
+#define xfs_ag_mark_sick(pag, mask) \
+	xfs_group_mark_sick(pag_group(pag), (mask))
+void xfs_group_mark_corrupt(struct xfs_group *xg, unsigned int mask);
+void xfs_group_mark_healthy(struct xfs_group *xg, unsigned int mask);
+void xfs_group_measure_sickness(struct xfs_group *xg, unsigned int *sick,
 		unsigned int *checked);
 
 void xfs_inode_mark_sick(struct xfs_inode *ip, unsigned int mask);
@@ -227,22 +231,19 @@ xfs_fs_has_sickness(struct xfs_mount *mp, unsigned int mask)
 }
 
 static inline bool
-xfs_rt_has_sickness(struct xfs_mount *mp, unsigned int mask)
+xfs_group_has_sickness(
+	struct xfs_group	*xg,
+	unsigned int		mask)
 {
-	unsigned int	sick, checked;
+	unsigned int		sick, checked;
 
-	xfs_rt_measure_sickness(mp, &sick, &checked);
-	return sick & mask;
-}
-
-static inline bool
-xfs_ag_has_sickness(struct xfs_perag *pag, unsigned int mask)
-{
-	unsigned int	sick, checked;
-
-	xfs_ag_measure_sickness(pag, &sick, &checked);
+	xfs_group_measure_sickness(xg, &sick, &checked);
 	return sick & mask;
 }
+#define xfs_ag_has_sickness(pag, mask) \
+	xfs_group_has_sickness(pag_group(pag), (mask))
+#define xfs_ag_is_healthy(pag) \
+	(!xfs_ag_has_sickness((pag), UINT_MAX))
 
 static inline bool
 xfs_inode_has_sickness(struct xfs_inode *ip, unsigned int mask)
@@ -259,18 +260,6 @@ xfs_fs_is_healthy(struct xfs_mount *mp)
 	return !xfs_fs_has_sickness(mp, -1U);
 }
 
-static inline bool
-xfs_rt_is_healthy(struct xfs_mount *mp)
-{
-	return !xfs_rt_has_sickness(mp, -1U);
-}
-
-static inline bool
-xfs_ag_is_healthy(struct xfs_perag *pag)
-{
-	return !xfs_ag_has_sickness(pag, -1U);
-}
-
 static inline bool
 xfs_inode_is_healthy(struct xfs_inode *ip)
 {

