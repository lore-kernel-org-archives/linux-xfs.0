Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F2946D551
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 10:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244425; cv=none; b=SU/MQcGx54uQn5UAZQECybQ1f37p7qrvZUffq/qDA7kCmMTNFjTmxEWAsxfL3GTAKYPNJMZiuk7o62YkVT3Ta4kX38p9fjdUUfw8jTWteMTyEatv2zsv66ZWZ9miUlJvGfKHKQbPjLbb09W+cEai+HYfcondyh0TymrEH7yZlFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244425; c=relaxed/simple;
	bh=r+PLKngNNTh8ITnTvH1XSSbRRIIY9/LUYYXF93qjUnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sIkIotJX6Z1jERnxEn18bgZeLjT55GjnqLrTSY6nbtG8RaRq0GT+LU2b19ySW/egAM9nIZ+9jlUxI9cjAI2+MVYJiJCMPtdd0Vatf1uu4xXTF11HdITE0y8ME23Nult3W/5Ac4xF3m44argPFo9xYC9Agd3doBk1pQPJfhBomJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pLwHBbj7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pLwHBbj7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Yaa/qJ1PuN7ZbImwE+E+De8ZWXfes0WG/t6+9ZQN7m8=; b=pLwHBbj79bB8796S9/4Pn3U/Fh
	vqlAVa8LJyuLnqrWkVTPNYN54sxTHxDeRMQ65j8lOuo0QHWWK/ZJ7yhPg1u1Oq/xggBmdxuzbXttR
	hSBeCZTPQ1339Ze6oMzSFlH5qbXZztMRff96zmwS3sytD2ElhsLD911oV4xqajRoh5IJT0G5MUFnY
	qd5eOCqmUccqlUwxJ/N5Y1hNQLBAHm3Hx9Y55wR+6x4r5uFKZiMcTnF6r+sE7v7gXA1FDMmGM3g1i
	j8mAzLC24Aic/Nfyh4T99SqVPRyjolh+478D8NIYDSdYb8LBfCXRq8CXseJH/DJDU/tpgn/WD52kd
	E0VPXoDQ==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gLt-0000000AfTR-1czf;
	Thu, 24 Sep 2026 10:06:53 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 24/32] xfs: report RT data checksum information via XFS_FSOP_GEOM
Date: Thu, 24 Sep 2026 12:04:14 +0200
Message-ID: <20260924100512.2733748-25-hch@lst.de>
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

Source kernel commit: 581da73914b7380f50e435a2260a72ab8601f0e4

Report the RT data checksum flag and the checksum algorithm to userspace.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_fs.h | 6 +++++-
 libxfs/xfs_sb.c | 5 +++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 185f09f327c0..afe83ff23ef3 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -191,7 +191,10 @@ struct xfs_fsop_geom {
 	__u32		rgcount;	/* number of realtime groups	*/
 	__u64		rtstart;	/* start of internal rt section */
 	__u64		rtreserved;	/* RT (zoned) reserved blocks	*/
-	__u64		reserved[14];	/* reserved space		*/
+	__u8		rtcsum_type;	/* RT data checksum type	*/
+	__u8		rtcsum_blklog;	/* log2 of rtcsum bsize		*/
+	__u8		reserved_pad[6];/* reserved space		*/
+	__u64		reserved[13];	/* reserved space		*/
 };
 
 #define XFS_FSOP_GEOM_SICK_COUNTERS	(1 << 0)  /* summary counters */
@@ -250,6 +253,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_PARENT	(1 << 25) /* linux parent pointers */
 #define XFS_FSOP_GEOM_FLAGS_METADIR	(1 << 26) /* metadata directories */
 #define XFS_FSOP_GEOM_FLAGS_ZONED	(1 << 27) /* zoned rt device */
+#define XFS_FSOP_GEOM_FLAGS_DATA_CSUM	(1 << 28) /* data checksums */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 2d64412363b4..372009424970 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -1660,6 +1660,11 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_METADIR;
 	if (xfs_has_zoned(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_ZONED;
+	if (xfs_has_rtcsum(mp)) {
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_DATA_CSUM;
+		geo->rtcsum_type = mp->m_sb.sb_rtcsum_type;
+		geo->rtcsum_blklog = mp->m_sb.sb_rtcsum_blklog;
+	}
 	geo->rtsectsize = sbp->sb_blocksize;
 	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
 
-- 
2.53.0

