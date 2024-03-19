Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D9050A67
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 07:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710832802; cv=none; b=FL3yrSRrfQ6F6d822rLc/Aj55nm8ax4alwUIOulo03LgkAOHE0CJY6EIOeIxml1aUR+vrzLBY1NsUWUkl/EbaklAxILMJMtSJ2+Yf+fWhsO+qZw53oNS/UIp5pSm0umH1V4Gypy8Z23Ef5qNtyINmmYr8gIbBQluEjexEL9CxbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710832802; c=relaxed/simple;
	bh=heqh2L7gN7JuBeaD8g7q3mjDLf2QZTWI5BX+Mw0/bvg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=F+i8oT3dFScTagC4ax/67KB8ktYrkDNnIq/x6loD+C5epTPUakEwQcdNFw+GZ9+eM1d5nSiKIcifwb0nMtFQDqT7uIXnitoNdXbrvF6cK00w1ibubMuAfucaV5+T1XiOP/qIHuRcP4BlsIRNDNSiQ6uvl/M6iNeVE/OHOfie2OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bnoFJ+pj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bnoFJ+pj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=/YkDg2dPuWtlI32ZpnNUy5wmfQJqtrsvfZafBaUmc4Q=; b=bnoFJ+pj6U9aSPXx7VsAa1H7yr
	m+5546Bi6SM/4Mjm4Dxu6i+X5Y9sC1puJJ0Z3M9pStolJWeI2qeO10p1XfTE+4+FMH9SqGIRct+Uj
	TbRdY2oqjd8Rel5GyrdKLMyDBgTD8e2qSy3pDhXEYpT/S5ns4awCQqZqRLjD4L9TLlhZ7o6rlITtW
	/um7xZw7WbnbjeZu0E0nARl/ZmRTw6X40pat6B6wXtpPKkNmKLnWruHma0AYLdva+53eMdnhsQbt6
	ZCkhyx82k9a69yk2FX08i3OMJwbXZGNbpU8OO7qZ34+HQwTjrUDQ7xlQoNKg7i0Z5wNqukNToYZo3
	AjH+mijQ==;
Received: from 27-33-182-58.static.tpgi.com.au ([27.33.182.58] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rmTlO-0000000BgAa-3lfQ;
	Tue, 19 Mar 2024 07:19:59 +0000
From: Christoph Hellwig <hch@lst.de>
To: chandan.babu@oracle.com
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: compile out v4 support if disabled
Date: Tue, 19 Mar 2024 17:19:51 +1000
Message-Id: <20240319071952.682266-1-hch@lst.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a strategic IS_ENABLED to let the compiler eliminate the unused
non-crc code is CONFIG_XFS_SUPPORT_V4 is disabled.

This saves almost 20k worth of .text for my .config:

$ size xfs.o.*
   text	   data	    bss	    dec	    hex	filename
1351126	 294836	    592	1646554	 191fda	xfs.o.new
1371453	 294868	    592	1666913	 196f61	xfs.o.old

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_mount.h |  7 ++++++-
 fs/xfs/xfs_super.c | 22 +++++++++++++---------
 2 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index e880aa48de68bb..24fe6e7913c49f 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -327,6 +327,12 @@ static inline void xfs_add_ ## name (struct xfs_mount *mp) \
 	xfs_sb_version_add ## name(&mp->m_sb); \
 }
 
+static inline bool xfs_has_crc(struct xfs_mount *mp)
+{
+	return IS_ENABLED(CONFIG_XFS_SUPPORT_V4) &&
+		(mp->m_features & XFS_FEAT_CRC);
+}
+
 /* Superblock features */
 __XFS_ADD_FEAT(attr, ATTR)
 __XFS_HAS_FEAT(nlink, NLINK)
@@ -341,7 +347,6 @@ __XFS_HAS_FEAT(lazysbcount, LAZYSBCOUNT)
 __XFS_ADD_FEAT(attr2, ATTR2)
 __XFS_HAS_FEAT(parent, PARENT)
 __XFS_ADD_FEAT(projid32, PROJID32)
-__XFS_HAS_FEAT(crc, CRC)
 __XFS_HAS_FEAT(v3inodes, V3INODES)
 __XFS_HAS_FEAT(pquotino, PQUOTINO)
 __XFS_HAS_FEAT(ftype, FTYPE)
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 6828c48b15e9bd..7d972e1179255b 100644
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

