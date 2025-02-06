Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B09224B13
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 06:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738824361; cv=none; b=qrfeiz1s7+66WwjT82vUWy8Eh3TmTOm001ZibGnBaDikp5kMLh5qEs22ZQt7vxCsB8UweLHRmiT+vwKDzvEYdf0NI+I4q8HrFD1EAjulgR8HSbeX68ikvgIcl/K4aMM6sw1aQdQCEAspZoiUj/WEkht4cSulTvFUjfT4sWdPii0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738824361; c=relaxed/simple;
	bh=QSkedGSqpVnISg1VlifZ99hWQ2vf5Q9EeWvccUHiPsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iABATv6dQjYI+0l/WvEip1CbJ+qtwZQtp8OqBINhlPRLWtKq9KuXEo2Mp0JFg+fJA21FJNhLe8YFyt5ueWCWyEIVYqf4LNzjhjfDOE/gfBwVgDpdBmpLJxHTmqHK4HhjFJAfatE+TJhwOTKmvwlk6SZ/VbvRbKjLOWli6G45pic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xPKLY3KZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xPKLY3KZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=r08cPEKCtBlmp+nY3FUXAKT+Wl2/hfo8+GZbqyCFeJw=; b=xPKLY3KZKM6d3sNv4Nd8d7kkQc
	UVLzJM/xataRS8oqzePa7a6pzP8BqF7RVpl/QsqfPl1KkXiBcSfw1YPmMrQcIOCeTR9/6SlggqL08
	VeTdehkCaLPDntUwF40xKtaOuPGu+CvKqp4mBEpQbB33W3Q2UZ9Ihr0vDb0xCO6Wl5i4QUkRddaa4
	2nDO8X7WABzHTO60tkPK1+CKw1qSQrKZEtYyzcJ5bbNCpdOznaaYqomvX2jV2L7WjwX20H8qCicX/
	Itb7HucDl8ttQWWp4HXHGjMq3tOnjVaw6pN0EMIPEVqXXF+Hx8sh31BAaZOhr8giYnLN5SgfWBDTT
	ld8i03fw==;
Received: from 2a02-8389-2341-5b80-9d5d-e9d2-4927-2bd6.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d5d:e9d2:4927:2bd6] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tfveB-00000005QJy-3TzM;
	Thu, 06 Feb 2025 06:46:00 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 16/43] xfs: export zoned geometry via XFS_FSOP_GEOM
Date: Thu,  6 Feb 2025 07:44:32 +0100
Message-ID: <20250206064511.2323878-17-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250206064511.2323878-1-hch@lst.de>
References: <20250206064511.2323878-1-hch@lst.de>
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
index 088c192810f5..71cf5eba94a7 100644
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

