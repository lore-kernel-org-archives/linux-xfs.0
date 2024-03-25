Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CCA174EC2
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 03:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711336407; cv=none; b=Lyv+Qt+5eRc9fmd8ngyWmBrottt3dn/CpQ9Y/UUl1OuZsEG9q81qwCc/DMc61Esudo4sVSDB33acu1pAsW3ln0z2NBHVXpNsVeMQ3ncf8xUaPG0bQ2Cc7rOBg6miFVakuTMKTFVYo3/ILnMhkUX7fFe+LEVTQiBibqCQAyExFMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711336407; c=relaxed/simple;
	bh=yDHkG7Zl23FwjoZMzqhEE+oDf6DOtghGKiMILZoVRQA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tIPdCePk9KliD3EAPRv+/qrVZSewelRwRWX+SOYfZOIQUwMA9Wd7JEG08zAOzgrapfxctOslOlU2r7FfB8IfwrHmLSF1J8ViDTeV7OEZ644Cwu+oy5oFHJx7HU3dWgj56kko6KEL+Bp3pw+/bENq/jOATIwfG9wsH5pCt7mRVd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=e4vc9bmI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="e4vc9bmI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=TwpCMPbNuRMBkGafsULahhV6M8c0A7KTl5de+AYu7Gc=; b=e4vc9bmIeDKfYjAu63sT+RD4kB
	Ia6KrV3ekzQ1hnbrarNngtjBZNyanrIcYvt2oYX2FgBmm+IqBAmlREl87ceAd3JPv4+VYbjnWCJdb
	3LgR5Q0VhC6W/L3UhoSSyD/lrX/o+YGdd6pJ+oo7qD2zzkF5osPRCDpodlSy9SjY4sG2L34XPQoAg
	CaDcbuHaAu1V9Sq+wseEmxbYeYK/phKtL4fKCVodYXUvMZRO7swIsjOQMk+K16MXM2SwEknNWzQhr
	Iqo6j33Cr7g9dOHFajMX92CAZ7gI9pzL9hOt6FO0DQxzWmN3zfQ3HQkxYGki4Lk5tcSsAxZuNlxQW
	5Wc4n6xQ==;
Received: from [101.231.140.162] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1roam4-0000000ErSY-0sBb;
	Mon, 25 Mar 2024 03:13:24 +0000
From: Christoph Hellwig <hch@lst.de>
To: chandan.babu@oracle.com,
	djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH v2] xfs: compile out v4 support if disabled
Date: Mon, 25 Mar 2024 11:13:18 +0800
Message-Id: <20240325031318.2052017-1-hch@lst.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a few strategic IS_ENABLED statements to let the compiler eliminate
unused code when CONFIG_XFS_SUPPORT_V4 is disabled.

This saves multiple kilobytes of .text in my .config:

$ size xfs.o.*
text	   data	    bss	    dec	    hex	filename
1363633	 294836	    592	1659061	 1950b5	xfs.o.new
1371453	 294868	    592	1666913	 196f61	xfs.o.old

Signed-off-by: Christoph Hellwig <hch@lst.de>
---

Changes since v1:
 - compile out the right bits, and more of them

 fs/xfs/xfs_mount.h | 40 +++++++++++++++++++++++++++++++---------
 fs/xfs/xfs_super.c | 22 +++++++++++++---------
 2 files changed, 44 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 0e8d7779c0a561..85e327bf05041f 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -337,19 +337,10 @@ static inline void xfs_add_ ## name (struct xfs_mount *mp) \
 __XFS_ADD_FEAT(attr, ATTR)
 __XFS_HAS_FEAT(nlink, NLINK)
 __XFS_ADD_FEAT(quota, QUOTA)
-__XFS_HAS_FEAT(align, ALIGN)
 __XFS_HAS_FEAT(dalign, DALIGN)
-__XFS_HAS_FEAT(logv2, LOGV2)
 __XFS_HAS_FEAT(sector, SECTOR)
-__XFS_HAS_FEAT(extflg, EXTFLG)
 __XFS_HAS_FEAT(asciici, ASCIICI)
-__XFS_HAS_FEAT(lazysbcount, LAZYSBCOUNT)
-__XFS_ADD_FEAT(attr2, ATTR2)
 __XFS_HAS_FEAT(parent, PARENT)
-__XFS_ADD_FEAT(projid32, PROJID32)
-__XFS_HAS_FEAT(crc, CRC)
-__XFS_HAS_FEAT(v3inodes, V3INODES)
-__XFS_HAS_FEAT(pquotino, PQUOTINO)
 __XFS_HAS_FEAT(ftype, FTYPE)
 __XFS_HAS_FEAT(finobt, FINOBT)
 __XFS_HAS_FEAT(rmapbt, RMAPBT)
@@ -362,6 +353,37 @@ __XFS_HAS_FEAT(bigtime, BIGTIME)
 __XFS_HAS_FEAT(needsrepair, NEEDSREPAIR)
 __XFS_HAS_FEAT(large_extent_counts, NREXT64)
 
+/*
+ * Some features are always on for v5 file systems, allow the compiler to
+ * eliminiate dead code when building without v4 support.
+ */
+#define __XFS_HAS_V4_FEAT(name, NAME) \
+static inline bool xfs_has_ ## name (struct xfs_mount *mp) \
+{ \
+	return !IS_ENABLED(CONFIG_XFS_SUPPORT_V4) || \
+		(mp->m_features & XFS_FEAT_ ## NAME); \
+}
+
+#define __XFS_ADD_V4_FEAT(name, NAME) \
+	__XFS_HAS_V4_FEAT(name, NAME); \
+static inline void xfs_add_ ## name (struct xfs_mount *mp) \
+{ \
+	if (IS_ENABLED(CONFIG_XFS_SUPPORT_V4)) { \
+		mp->m_features |= XFS_FEAT_ ## NAME; \
+		xfs_sb_version_add ## name(&mp->m_sb); \
+	} \
+}
+
+__XFS_HAS_V4_FEAT(align, ALIGN)
+__XFS_HAS_V4_FEAT(logv2, LOGV2)
+__XFS_HAS_V4_FEAT(extflg, EXTFLG)
+__XFS_HAS_V4_FEAT(lazysbcount, LAZYSBCOUNT)
+__XFS_ADD_V4_FEAT(attr2, ATTR2)
+__XFS_ADD_V4_FEAT(projid32, PROJID32)
+__XFS_HAS_V4_FEAT(v3inodes, V3INODES)
+__XFS_HAS_V4_FEAT(crc, CRC)
+__XFS_HAS_V4_FEAT(pquotino, PQUOTINO)
+
 /*
  * Mount features
  *
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 71732457583370..f325a2d1b3a902 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1589,17 +1589,21 @@ xfs_fs_fill_super(
 	if (error)
 		goto out_free_sb;
 
-	/* V4 support is undergoing deprecation. */
-	if (!xfs_has_crc(mp)) {
-#ifdef CONFIG_XFS_SUPPORT_V4
+	/*
+	 * V4 support is undergoing deprecation.
+	 *
+	 * Note: this has to use an open coded m_features check as xfs_has_crc
+	 * always returns false for !CONFIG_XFS_SUPPORT_V4.
+	 */
+	if (!(mp->m_features & XFS_FEAT_CRC)) {
+		if (!IS_ENABLED(CONFIG_XFS_SUPPORT_V4)) {
+			xfs_warn(mp,
+	"Deprecated V4 format (crc=0) not supported by kernel.");
+			error = -EINVAL;
+			goto out_free_sb;
+		}
 		xfs_warn_once(mp,
 	"Deprecated V4 format (crc=0) will not be supported after September 2030.");
-#else
-		xfs_warn(mp,
-	"Deprecated V4 format (crc=0) not supported by kernel.");
-		error = -EINVAL;
-		goto out_free_sb;
-#endif
 	}
 
 	/* ASCII case insensitivity is undergoing deprecation. */
-- 
2.39.2

