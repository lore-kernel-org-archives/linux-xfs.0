Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C44210EE
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 06:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713766403; cv=none; b=JkLPR02lroOfCxu8Q1KzNWMQs0INTDbesuHZ2E2WXzwXtvkZchtgvPR5TlSbdfP7jLKqVEjQz6WeMqliuHs0fbhmSy2bBbGFQ2/3ZPiEwLxlkZfTbWk8imN+mg0ZMsP2LJ0cMtOLMXI5MLgSafUdaLsVRs/1ZyKs9RwJ9o3JnKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713766403; c=relaxed/simple;
	bh=N5k0Qx86XsU8Sh1iXAzv2vTwCDzprtm6xpsiv7v3JBY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=NSK6YNfG5u/EVAr8zelFEknxpw3RUp42z8NUAGktSN1lAjJk8D+cmBtBCMevoUf/5cCQznQCf1KtQKOM6SnyEe4Q3xAEgX5MwSORT2QlEye7dpg9pFgDNH/Q9TZ47vbddZXbS3HB5Rm69+OCdolAVtodeXxiI67IppDr8mMB/tI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VcgA0QSy; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VcgA0QSy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=bQ7C9ocFc3atzJetmiENEVRvvPwk1Z2EMYBkH9nDdqY=; b=VcgA0QSyTcUWGnZACi9NTApbKE
	W80JHuUCeChA5stWkNLaTXlNdOnUIRmn0MyU7sniX1ITAjTT1iQt8NH4GcJ9wyGZYMoNRMq49y+hJ
	et7QsioisDcI9DT29pROFeC+icUUpctiljtxRvAysWWS364wS76ZmLVyrQ6RdOdUYjwHAkjTvDAfv
	sQvBPsDup80wwlgLpyl685wzJvJE5KkA/Z4q8Yg3bW6Eh2mHzuZO5J3YU6xtYI6ekTYKImZEHkEfo
	AIf5NT0F6Oqw8J37kFP4KR9GXej1h77uityeRUCGTBXllqAuY87NPwJIJnj1V5pSk4M1pUvo5k5rN
	bdzHqGqg==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rymvX-0000000CDmS-0vfK;
	Mon, 22 Apr 2024 06:13:19 +0000
From: Christoph Hellwig <hch@lst.de>
To: chandan.babu@oracle.com
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v2,resend] xfs: compile out v4 support if disabled
Date: Mon, 22 Apr 2024 08:13:16 +0200
Message-Id: <20240422061316.115491-1-hch@lst.de>
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
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---

No changes exept for the added Reviewed-by from v2, just resending as
requested by the maintainer.

 fs/xfs/xfs_mount.h | 40 +++++++++++++++++++++++++++++++---------
 fs/xfs/xfs_super.c | 22 +++++++++++++---------
 2 files changed, 44 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index b022e5120dc42d..283a5a26db3170 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -332,19 +332,10 @@ static inline void xfs_add_ ## name (struct xfs_mount *mp) \
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
@@ -358,6 +349,37 @@ __XFS_HAS_FEAT(needsrepair, NEEDSREPAIR)
 __XFS_HAS_FEAT(large_extent_counts, NREXT64)
 __XFS_HAS_FEAT(exchange_range, EXCHANGE_RANGE)
 
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
index 5c9ba974252d16..02c1a4aeaa4c3b 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1580,17 +1580,21 @@ xfs_fs_fill_super(
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

