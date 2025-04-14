Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7B41862
	for <linux-xfs@vger.kernel.org>; Mon, 14 Apr 2025 05:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744609002; cv=none; b=bjncGpM9nGaq6f9VTw31JyRsDw2p/1RSmIJL+outWaJhUdrk4kvFg144+n21CFrt/jEVHsj+JF4Qh0f2odZmgJKSy7ZVMxknWeOid0Epiq3kFNOyMPjC/+O2krLi8NLCCtJajr5YPfjfb1eaJrxQpW9dzDQ2CWwwU5mlXNTVaGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744609002; c=relaxed/simple;
	bh=qOiJHqNn4Ctcr9W19v8hqoeCNUFYVOrVHWpWsj6aARM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pD/o/2CLNy11iYjhjMWdHIqoYWWPUdRpKysz893QmvS2QwLx9m1b/wNkJ/df+hB9vtRqxy/BbQrfcR+1oUY/0D28iPG93/MsPjrzbYHeGv4rmNO0OVDePyUR+i+bpYDq07hhLO9QbT9LD7iudPUL6QXSzM/YORdbXsG9ILGblX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XUgkez7/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XUgkez7/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Ohnu+Vzv/uFm6Vb++/DAToVMSdcMYp/tA5zaPYeZEPc=; b=XUgkez7/sgz5Tx1ZsmG9N3q7Kb
	i2zN6/3IlvirGUpAsd7kfzjdYa2S2Q8GiaEFac8bNRaWZfHUYeW2uKVOtFTzL+ahbCeqw6dkTQfzk
	O7iUhGUYzn9FXiSJdxaQxEMZa7OiVGC9pPZEHUocoJtGOYz4V1DT87Hiv8yCvJxq1vc7KlyAlBUzs
	90j2iUwV+cDsJKrI5nAyDx/2NrOTmBHjDGi5mR7ZYpy6TUWlU2W/crhoXEPwi/nAUmGkuUHS6k3yL
	fEYODrTGfnvy2rkMRcY32sS5rqeZKeXyQ7XI4nu0LgPl3fycuZDfhcDI0yLjsuG/2cjNzl1LjB8Oi
	Z2hBO6XQ==;
Received: from 2a02-8389-2341-5b80-9d44-dd57-c276-829a.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d44:dd57:c276:829a] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u4CUp-00000000i7J-0yMx;
	Mon, 14 Apr 2025 05:36:39 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 02/43] FIXUP: xfs: generalize the freespace and reserved blocks handling
Date: Mon, 14 Apr 2025 07:35:45 +0200
Message-ID: <20250414053629.360672-3-hch@lst.de>
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
 include/xfs_mount.h  | 32 ++++++++++++++++++++++++++++++--
 libxfs/libxfs_priv.h | 13 +------------
 2 files changed, 31 insertions(+), 14 deletions(-)

diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 383cba7d6e3f..e0f72fc32b25 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -63,8 +63,6 @@ typedef struct xfs_mount {
 	xfs_sb_t		m_sb;		/* copy of fs superblock */
 #define m_icount	m_sb.sb_icount
 #define m_ifree		m_sb.sb_ifree
-#define m_fdblocks	m_sb.sb_fdblocks
-#define m_frextents	m_sb.sb_frextents
 	spinlock_t		m_sb_lock;
 
 	/*
@@ -332,6 +330,36 @@ static inline bool xfs_is_ ## name (struct xfs_mount *mp) \
 __XFS_UNSUPP_OPSTATE(readonly)
 __XFS_UNSUPP_OPSTATE(shutdown)
 
+static inline int64_t xfs_sum_freecounter(struct xfs_mount *mp,
+		enum xfs_free_counter ctr)
+{
+	if (ctr == XC_FREE_RTEXTENTS)
+		return mp->m_sb.sb_frextents;
+	return mp->m_sb.sb_fdblocks;
+}
+
+static inline int64_t xfs_estimate_freecounter(struct xfs_mount *mp,
+		enum xfs_free_counter ctr)
+{
+	return xfs_sum_freecounter(mp, ctr);
+}
+
+static inline int xfs_compare_freecounter(struct xfs_mount *mp,
+		enum xfs_free_counter ctr, int64_t rhs, int32_t batch)
+{
+	uint64_t count;
+
+	if (ctr == XC_FREE_RTEXTENTS)
+		count = mp->m_sb.sb_frextents;
+	else
+		count = mp->m_sb.sb_fdblocks;
+	if (count > rhs)
+		return 1;
+	else if (count < rhs)
+		return -1;
+	return 0;
+}
+
 /* don't fail on device size or AG count checks */
 #define LIBXFS_MOUNT_DEBUGGER		(1U << 0)
 /* report metadata corruption to stdout */
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 7e5c125b581a..cb4800de0b11 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -209,7 +209,7 @@ static inline bool WARN_ON(bool expr) {
 }
 
 #define WARN_ON_ONCE(e)			WARN_ON(e)
-#define percpu_counter_read(x)		(*x)
+
 #define percpu_counter_read_positive(x)	((*x) > 0 ? (*x) : 0)
 #define percpu_counter_sum_positive(x)	((*x) > 0 ? (*x) : 0)
 
@@ -219,17 +219,6 @@ uint32_t get_random_u32(void);
 #define get_random_u32()	(0)
 #endif
 
-static inline int
-__percpu_counter_compare(uint64_t *count, int64_t rhs, int32_t batch)
-{
-	if (*count > rhs)
-		return 1;
-	else if (*count < rhs)
-		return -1;
-	return 0;
-}
-
-
 #define PAGE_SIZE		getpagesize()
 extern unsigned int PAGE_SHIFT;
 
-- 
2.47.2

