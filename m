Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9FC13AC0C8;
	Thu, 24 Sep 2026 10:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244145; cv=none; b=dvzdyjxvDHW2xKcqJRUd8/akYxHZvdheCkC9BgTUjCpINOXQ9Zh2DFUpMWhlN2JnqWRgAUg6EOCXErajEMq6DQwe/RJ2jV073JBMI3bvuorQcScd1UT1I9vQ1N6sdVMrGsNoxG+q7FByDyqzNF9lFj4S/pZJyJqH+J+vJoVXHuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244145; c=relaxed/simple;
	bh=jk8jIf2zkjsivNMm0TInFfXhUfDzqhoulBhAINN9ZJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LtKMNz5JwNJPZNTBoYmCKdYPQpZ7UivPyj8aWiOL9HRLMBm0S0tNPrUU7PohNlfKp8OGTlO7uJVu0MhCdjNiZw/3E+ZIIX4wV3CY0IulxWCxfeBF9Mys6AFrD+E7nN9T/rGkMRtkgOpsDkS4VtAnuW5AO9JD2jj6nEpQupy2Hjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ywdCQkeG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ywdCQkeG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=dPv94LCSnxf/9QP2pSuf9/oZy2LebDi8OKeOyhC2ncw=; b=ywdCQkeGC2BFF2LcLBW9lrNy3x
	r6b+pQyLYuBc3gdBvDBfAlF+R/WDeKDK82PBFGmNSOy3iCQGysjy+l9BiHAfmdHOysT3Q4VR8ArSb
	WNWG0YHOxo2qElwm+eCSlubx1tAjh0z2tvWVOf89TKF7B7l+Gsc8RRVPvcMgZzQRyuviPUkeCjSVS
	7hm3goGGfobVPYmFeiZJid0SZswN8eVoXpXYviXUPPQNuEexGKwGL3GihBXeZD7z//HbsiqtNsqJT
	itqC1ore4Oz9wSSe3Oleg63Jw31fsVGDTs6Vo4nVdSY+lqv6WJgV7io1TDHGpbVcLx+YqNUD6jQn5
	KhgWkdLg==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gHN-0000000AehH-3yi4;
	Thu, 24 Sep 2026 10:02:14 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 19/21] xfs: report RT data checksum information via XFS_FSOP_GEOM
Date: Thu, 24 Sep 2026 11:59:51 +0200
Message-ID: <20260924100032.2733101-20-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924100032.2733101-1-hch@lst.de>
References: <20260924100032.2733101-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Report the RT data checksum flag and the checksum algorithm to userspace.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_fs.h | 6 +++++-
 fs/xfs/libxfs/xfs_sb.c | 5 +++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 185f09f327c0..afe83ff23ef3 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
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
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 3a470aec6c0c..506caf3e5201 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
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

