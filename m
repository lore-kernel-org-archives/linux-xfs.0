Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6DC5236421
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 18:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740596251; cv=none; b=aNhwm/wBKSKVGSPLdg4zqD+I/5f4X31T2CbWUPboF34YpmVVtkZk6uyW1heD6dyzKvZfYzk2pjkIOCbSMs6ZC/2/jW5HkFiJn4rAMJuUjHokbh+/Ee6zuajiJCfxiDS438SUrs+fYBhZbuoOXshU4OIXV8OzYBE04o1xuDn1Lh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740596251; c=relaxed/simple;
	bh=cXn7SYDo/HQljYWDDFF8fdX6i6ps3tzeGoHP3yN8SHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NOn+sObOb/90wqP4cNEts+AIb08IKF8Odiza47Mglpi+qLEyvAYn1BaKBwAFvujLe7MA403N3NZZDvIlHCj6iKt107v71T9hXs5S8w196RqAkpX2O0FAB4J007oaCOun8hiQLoCNsj1UWqT1MhZ84xhCqmQ3dXHZWjLe4Zb2egw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=p3ZfARr/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="p3ZfARr/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=3JsT7pk/rvuv3lHfBltf7qyMRYAiPVGrk+72Iht/Wp8=; b=p3ZfARr/be80ixwAkbnQ20f3zG
	/NIX0qaDq8Js3JiyP2YjRx9gozblFUKWntbmvQajAxuv/gkoi9t9A+uR85kAk7YQODGQuksFaGkac
	vHgQqBer2nVYWAPnOAEYLP07YpkCmHrt8lta2ycDE2K0IkmS0STR0zsH/N6lL3nh+wEoyG1p27RIo
	UA3IICN/NNI2JchXOP8oUVHORdfJ4UJe3g+qjReQL15myOKxBTiK5p4O8kniPjKcLRxdWSDemn2bZ
	NgEXcdIMmMLXlqNoG6CLLpKQvgIH6u79vpToEveChpXDPK5WTS2u78C/Cm+maq1cZhHb17uTg8HXh
	P/PrZPDQ==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tnMb3-000000053to-1thq;
	Wed, 26 Feb 2025 18:57:29 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 17/44] xfs: export zoned geometry via XFS_FSOP_GEOM
Date: Wed, 26 Feb 2025 10:56:49 -0800
Message-ID: <20250226185723.518867-18-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250226185723.518867-1-hch@lst.de>
References: <20250226185723.518867-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Export the zoned geometry information so that userspace can query it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h | 5 ++++-
 fs/xfs/libxfs/xfs_sb.c | 6 ++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 2c3171262b44..5e66fb2b2cc7 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -189,7 +189,9 @@ struct xfs_fsop_geom {
 	uint32_t	checked;	/* o: checked fs & rt metadata	*/
 	__u32		rgextents;	/* rt extents in a realtime group */
 	__u32		rgcount;	/* number of realtime groups	*/
-	__u64		reserved[16];	/* reserved space		*/
+	__u64		rtstart;	/* start of internal rt section */
+	__u64		rtreserved;	/* RT (zoned) reserved blocks	*/
+	__u64		reserved[14];	/* reserved space		*/
 };
 
 #define XFS_FSOP_GEOM_SICK_COUNTERS	(1 << 0)  /* summary counters */
@@ -247,6 +249,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_EXCHANGE_RANGE (1 << 24) /* exchange range */
 #define XFS_FSOP_GEOM_FLAGS_PARENT	(1 << 25) /* linux parent pointers */
 #define XFS_FSOP_GEOM_FLAGS_METADIR	(1 << 26) /* metadata directories */
+#define XFS_FSOP_GEOM_FLAGS_ZONED	(1 << 27) /* zoned rt device */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 52a04aae44e8..3b886886ea69 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1569,6 +1569,8 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_EXCHANGE_RANGE;
 	if (xfs_has_metadir(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_METADIR;
+	if (xfs_has_zoned(mp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_ZONED;
 	geo->rtsectsize = sbp->sb_blocksize;
 	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
 
@@ -1589,6 +1591,10 @@ xfs_fs_geometry(
 		geo->rgcount = sbp->sb_rgcount;
 		geo->rgextents = sbp->sb_rgextents;
 	}
+	if (xfs_has_zoned(mp)) {
+		geo->rtstart = sbp->sb_rtstart;
+		geo->rtreserved = sbp->sb_rtreserved;
+	}
 }
 
 /* Read a secondary superblock. */
-- 
2.45.2

