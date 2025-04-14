Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7672F13E02A
	for <linux-xfs@vger.kernel.org>; Mon, 14 Apr 2025 05:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744609006; cv=none; b=EZg3Jvotd3jJC67LnzDMu3zxHpyRoO5hReEkgKMC0tvudvTiH1M8YGATv7XsND1ANEueva5OTsGmX0luY9KsBdPCQi02rmKOnt8CngthC4OFFwzjDHGqF0OFBTTajdz3PaZk1+dL1WrWL35NvH+TtYPz1hU+wbFkXCPwVV8gLUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744609006; c=relaxed/simple;
	bh=w8TjUWmTfA+kWf/xcMM4ttxySH39FzaT4MJ94GyZ8nM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m21HfDDM37LL9lrzqdBp2VfEvf488qbWRsoRmlu1dccae8DgxZ3G6aD9hjGlw/0q5cWY23JLT2AouQOcOrc94AdadHVsuqtUj7R4gW6rEtXfLrAKVIxPwO+NXkbEAUeDWLLNuUOS/R/AKAH/VHvXq7q1biGQRx+rpS82D7FoagE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zeVAbiDk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zeVAbiDk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=3AmB0AnGBenXkv9YOxoX9efYS27lAiZ+tagLC1FFCC8=; b=zeVAbiDkLHec5iymuLUziAK3fi
	219o2pleVDrfZIAC2as5emLXxDooA6owm+jqqlor7VgrP1OY4euWMlUSG43t7TZ1ZufBFEevl2gQf
	oJBFMFyDJE8VHrmug85SLx5xK3F8tKn19wx6T9MdgjJuuC7qLkfIiKwq1SB14dfkWy63Ex2QOTo2i
	DuwlCpxZ4zMXeaQizUvJDiwwwSPfjOIjovawYLGDWIZsxzgOptAHhcali+v/fKSIINibXf8URupPu
	WGVHd40Xxz0wckscMY8jlfVOxARsIdoERxjR1OEC3CQ4eb5yrqmCmkRe/WfewQ7SwpvZNzaZPE/t0
	c6GX20CA==;
Received: from 2a02-8389-2341-5b80-9d44-dd57-c276-829a.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d44:dd57:c276:829a] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u4CUt-00000000i7r-3icM;
	Mon, 14 Apr 2025 05:36:44 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 04/43] FIXUP: xfs: make metabtree reservations global
Date: Mon, 14 Apr 2025 07:35:47 +0200
Message-ID: <20250414053629.360672-5-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250414053629.360672-1-hch@lst.de>
References: <20250414053629.360672-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 include/spinlock.h   |  5 +++++
 include/xfs_mount.h  |  4 ++++
 libxfs/libxfs_priv.h |  1 +
 mkfs/xfs_mkfs.c      | 25 ++++---------------------
 4 files changed, 14 insertions(+), 21 deletions(-)

diff --git a/include/spinlock.h b/include/spinlock.h
index 82973726b101..73bd8c078fea 100644
--- a/include/spinlock.h
+++ b/include/spinlock.h
@@ -22,4 +22,9 @@ typedef pthread_mutex_t	spinlock_t;
 #define spin_trylock(l)		(pthread_mutex_trylock(l) != EBUSY)
 #define spin_unlock(l)		pthread_mutex_unlock(l)
 
+#define mutex_init(l)		pthread_mutex_init(l, NULL)
+#define mutex_lock(l)		pthread_mutex_lock(l)
+#define mutex_trylock(l)	(pthread_mutex_trylock(l) != EBUSY)
+#define mutex_unlock(l)		pthread_mutex_unlock(l)
+
 #endif /* __LIBXFS_SPINLOCK_H__ */
diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index e0f72fc32b25..0acf952eb9d7 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -164,6 +164,10 @@ typedef struct xfs_mount {
 	atomic64_t		m_allocbt_blks;
 	spinlock_t		m_perag_lock;	/* lock for m_perag_tree */
 
+	pthread_mutex_t		m_metafile_resv_lock;
+	uint64_t		m_metafile_resv_target;
+	uint64_t		m_metafile_resv_used;
+	uint64_t		m_metafile_resv_avail;
 } xfs_mount_t;
 
 #define M_IGEO(mp)		(&(mp)->m_ino_geo)
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index cb4800de0b11..82952b0db629 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -151,6 +151,7 @@ enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
 
 #define xfs_force_shutdown(d,n)		((void) 0)
 #define xfs_mod_delalloc(a,b,c)		((void) 0)
+#define xfs_mod_sb_delalloc(sb, d)	((void) 0)
 
 /* stop unused var warnings by assigning mp to itself */
 
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 3f4455d46383..ec82e05bf4e4 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -5102,8 +5102,6 @@ check_rt_meta_prealloc(
 	struct xfs_mount	*mp)
 {
 	struct xfs_perag	*pag = NULL;
-	struct xfs_rtgroup	*rtg = NULL;
-	xfs_filblks_t		ask;
 	int			error;
 
 	/*
@@ -5123,27 +5121,12 @@ check_rt_meta_prealloc(
 		}
 	}
 
-	/* Realtime metadata btree inode */
-	while ((rtg = xfs_rtgroup_next(mp, rtg))) {
-		ask = libxfs_rtrmapbt_calc_reserves(mp);
-		error = -libxfs_metafile_resv_init(rtg_rmap(rtg), ask);
-		if (error)
-			prealloc_fail(mp, error, ask, _("realtime rmap btree"));
-
-		ask = libxfs_rtrefcountbt_calc_reserves(mp);
-		error = -libxfs_metafile_resv_init(rtg_refcount(rtg), ask);
-		if (error)
-			prealloc_fail(mp, error, ask,
-					_("realtime refcount btree"));
-	}
+	error = -libxfs_metafile_resv_init(mp);
+	if (error)
+		prealloc_fail(mp, error, 0, _("metadata files"));
 
-	/* Unreserve the realtime metadata reservations. */
-	while ((rtg = xfs_rtgroup_next(mp, rtg))) {
-		libxfs_metafile_resv_free(rtg_rmap(rtg));
-		libxfs_metafile_resv_free(rtg_refcount(rtg));
-	}
+	libxfs_metafile_resv_free(mp);
 
-	/* Unreserve the per-AG reservations. */
 	while ((pag = xfs_perag_next(mp, pag)))
 		libxfs_ag_resv_free(pag);
 
-- 
2.47.2

