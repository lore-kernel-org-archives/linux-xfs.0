Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAFA8450917
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 10:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244408; cv=none; b=nS2AHA/oKGvI/fjNy735fgdPtQ071Z8fMdInCwbtOcEt338CNwLAUN6U9PORUSRom6Lu4FFAhdGcTRnZfAntp+TqbCN9nRa7BVeNBC4HxPaL0MInDHRijjYUKTOoGjPu43yff4ti1nFs7IVE309UFM60g+1C0hnff1i65545aL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244408; c=relaxed/simple;
	bh=xSyYUI7Wo2Xef5ER5WRvqLJ3VYeSTGkeYaJOUJPB5Ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oRenNyihRoZ0vKJa091//c5cw4cjJ3ttKfdAOY/s8Bfn3O1WHkXU6Na4+R3WFUQ0HyszYzLIkd7w9yfBEYgYdtNNx89K/IAwt6CowuxJpbUfjlVGnaddzcFWxW1TXNBi2JVYYgVc6rEJHqe3GXlrq/o67kaufQfRLPst1zeERcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2Ycv9ABj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2Ycv9ABj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=eFaBR1YiJeuH9rYkVzNFkd5WzT6d5VaiXVtlHu1+0cg=; b=2Ycv9ABjn0oLK3vR2aFqm/2af1
	B+htZybWzCVsoaAjrRdeGyPSMv/u5t89/Y+XPEqzqZYNW/oeZiN9PlV3BmcFzFDtFpgFY4HgIWHDy
	/+ZiT20bYvoIu++Q+dYAQCVDXI8b1jWac4wMovXuzlNeNZhIHxg5oMB1iraZMZDPTZpI1+GxG0Qv0
	HaxJq9480t+66QVIzp8tREFwPaLCKsVDUaZjgdV7d7MMVtXj4iUacgILRiZktBS+BjZG9C4f7Io4x
	2Z0HRlTqpt+XCPqj7cir+sYZd2cJYuOeTc70LXkCL93dmdeOU4xtZpAvN6eHyRZtqP8vLQopN74VT
	oqZHW5eg==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gLb-0000000AfPq-2xy9;
	Thu, 24 Sep 2026 10:06:36 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 20/32] FIXUP
Date: Thu, 24 Sep 2026 12:04:10 +0200
Message-ID: <20260924100512.2733748-21-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924100512.2733748-1-hch@lst.de>
References: <20260924100512.2733748-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

---
 libxfs/stubs/xfs_mount.h |  7 +++++++
 repair/agheader.h        |  6 ++++++
 repair/sb.c              | 13 +++++++++++++
 3 files changed, 26 insertions(+)

diff --git a/libxfs/stubs/xfs_mount.h b/libxfs/stubs/xfs_mount.h
index 5a714333c16e..838746fa16d8 100644
--- a/libxfs/stubs/xfs_mount.h
+++ b/libxfs/stubs/xfs_mount.h
@@ -111,6 +111,8 @@ typedef struct xfs_mount {
 	uint8_t			m_sectbb_log;	/* sectorlog - BBSHIFT */
 	uint8_t			m_agno_log;	/* log #ag's */
 	int8_t			m_rtxblklog;	/* log2 of rextsize, if possible */
+	uint8_t			m_rtcsum_shift;	/* log2 of RT data csum size */
+	uint32_t		m_rtcsum_bsize;	/* rtcsum block size in bytes */
 
 	uint			m_blockmask;	/* sb_blocksize-1 */
 	uint			m_blockwsize;	/* sb_blocksize in words */
@@ -272,6 +274,11 @@ __XFS_HAS_FEAT(exchange_range, EXCHANGE_RANGE)
 __XFS_HAS_FEAT(metadir, METADIR)
 __XFS_HAS_FEAT(zoned, ZONED)
 
+static inline bool xfs_has_rtcsum(const struct xfs_mount *mp)
+{
+	return mp->m_sb.sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_RTCSUM;
+}
+
 static inline bool xfs_has_rtgroups(const struct xfs_mount *mp)
 {
 	/* all metadir file systems also allow rtgroups */
diff --git a/repair/agheader.h b/repair/agheader.h
index c81147b6607d..e11d13f620bf 100644
--- a/repair/agheader.h
+++ b/repair/agheader.h
@@ -91,4 +91,10 @@ static inline bool xfs_sb_version_hasmetadir(const struct xfs_sb *sbp)
 		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR);
 }
 
+static inline bool xfs_sb_version_rtcsum(const struct xfs_sb *sbp)
+{
+	return xfs_sb_is_v5(sbp) &&
+		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_RTCSUM);
+}
+
 #endif /* __XFS_REPAIR_AGHEADER_H__ */
diff --git a/repair/sb.c b/repair/sb.c
index ee1cc63fae64..73562c3d061a 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -523,6 +523,19 @@ verify_sb(char *sb_buf, xfs_sb_t *sb, int is_primary_sb)
 		ret = verify_sb_rtgroups(sb);
 		if (ret)
 			return ret;
+
+		if (xfs_sb_version_rtcsum(sb)) {
+			if (sb->sb_rtcsum_type >= XFS_CSUM_TYPE_MAX)
+				return XR_SB_GEO_MISMATCH;
+			if (sb->sb_rtcsum_blklog < XFS_RTCSUM_BSIZE_LOG_MIN ||
+			    sb->sb_rtcsum_blklog > XFS_RTCSUM_BSIZE_LOG_MAX)
+				return XR_SB_GEO_MISMATCH;
+		} else {
+			if (sb->sb_rtcsum_type)
+				return XR_SB_GEO_MISMATCH;
+			if (sb->sb_rtcsum_blklog)
+				return XR_SB_GEO_MISMATCH;
+		}
 	}
 
 	return(XR_OK);
-- 
2.53.0

