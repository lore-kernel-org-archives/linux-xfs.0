Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A569E19DFA7
	for <linux-xfs@vger.kernel.org>; Mon, 14 Apr 2025 05:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744609037; cv=none; b=eA56KOPiVt0kmNIFW/AlFDItTqPsaju478jOClOdCm2HPnRsbrHQxPkp5xnqAAVfx+Ci9RBKJtxfb8+vHXCjleqQm7JIXhgZk/PGpyAWrFaKpchKz8lypOOvyNwKU8iU6/lN4lQfmbW586ncIVRHzJidwaQVIts6hePVlUy34AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744609037; c=relaxed/simple;
	bh=KNgw4BfBmCNabAGKLNd22PlX4EWI72eZMPjawsS99Co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a3UaYgDI5vSYMOOEBC6GNBwofOH3fS09VSJIjgNmSX5cPc4rSPwWjG00E7ofnQ3rfvQ0BsTgLnix6yI7U+wb7FkO9nJiWH5cycUpLCLcBe0BzVbo3HzxD75yU3nh3f5FaHgFYsZYJexPPinVsoge6jtKeaHkUD9Hsi+0PnJY7z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rAp8kDlB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rAp8kDlB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=uJa8WsDEo198yE/S0Yk0Bbvbw64eNL41lY7WDF4Vo9g=; b=rAp8kDlBC0TAvF+T6tDWFzo7GB
	76KzoRal1Q7zwiiXiitk3p9PfxKBRV16jV8aHwkr2lIkt/VQY36r99tbExUKB4+FUaF8vJRBRfIjM
	IMnUwpnxDNJiOfIu/xF6qAJ7DBsF0a+HUNJMtz4laMTy6fG+QZ7wxf4d9DJxBZqgKL9ChmM+rrW89
	l0hds7JHWq5vj70fWY+miqNiPXYratNFjx6WjbHrIcBf4ugYK1z5jmtSKghEdW2CAxS1PgmTssM3g
	NU6X6qnJsX+QmMvGKiN4k1swVCkKhKIzcJCma8i7gXdTbJRJ1cvXfhs5OJCaY05z7ZT6Jl2C6uM1p
	Tx/gaomw==;
Received: from 2a02-8389-2341-5b80-9d44-dd57-c276-829a.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d44:dd57:c276:829a] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u4CVQ-00000000iES-0Ddo;
	Mon, 14 Apr 2025 05:37:16 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 14/43] xfs: export zoned geometry via XFS_FSOP_GEOM
Date: Mon, 14 Apr 2025 07:35:57 +0200
Message-ID: <20250414053629.360672-15-hch@lst.de>
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

Source kernel commit: 1fd8159e7ca41203798b6f65efaf1724eb318cd4

Export the zoned geometry information so that userspace can query it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_fs.h | 5 ++++-
 libxfs/xfs_sb.c | 6 ++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 2c3171262b44..5e66fb2b2cc7 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
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
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index a95d712363fa..8344b40e4ab9 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -1566,6 +1566,8 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_EXCHANGE_RANGE;
 	if (xfs_has_metadir(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_METADIR;
+	if (xfs_has_zoned(mp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_ZONED;
 	geo->rtsectsize = sbp->sb_blocksize;
 	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
 
@@ -1586,6 +1588,10 @@ xfs_fs_geometry(
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
2.47.2

