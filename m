Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27926200D9
	for <linux-xfs@vger.kernel.org>; Mon, 19 Feb 2024 06:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708324491; cv=none; b=m9f0J8oQ7benyFR7xB8OXLqpwZ9P0veEdNQRZeBWTkIQlvdQEfm2ymH2WbUpZLFz2mJLWhzEHzH2Ygu/Un991xtljEmwyabAWVaD3aJnnf/PjZtI7nj1dPH4Lt6RFtl5/qJuFPRE1eq76XkssliH6tEO1pEFkZ7v9YEaUKp/AiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708324491; c=relaxed/simple;
	bh=8BK7YXfys2/LCAiXFGPFnZAo2mjBBNyXGdB72HfNl/0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HIMF49mpKyeo2qvyVfzeU09sp7z2KFTUU335nVQRNuQymc/vmfW9v7yLRT6dCIBdzCgnt3LCi8gLV0NrWNCXdJbmhYEy/CpaiTjx87kyJbuvjlKjSrRjdD/a8JVv5jHoI7QlR30EYszX+I4ZcTd/BxtqEPH27lfN0yj6U8RG+LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Y6ylytqx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Y6ylytqx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=zloJEx2IXPGo5/DTphTR2ixiz4Rnf0oFUPezs7NdTgg=; b=Y6ylytqxo1wJyG5Rwz+42UvsFG
	j4iHiyXimQF+QRB2OVQ/fp+EUAFl5mJ9lS1CVHn/cKq9C0zMHqGTTvbwgCT2+BYaHyWFrz8bEy05L
	B+o3rxAu5pCBASMnc3yXn4xs593Th/gQCM1dwxs6ne2OJeR8BSPP2GCuirAhlAwUgGdm2Rl6eFzhd
	7zJ4aVLv7kJs38T1Ml5mrzErjGrfHKmiZViC6DZdOHrD23s6dk0FrkUrteBN9DGTF1S2zHaHAO5r+
	67hqJ7UDhkaD1C5GXfoE1Jdn9IYwjTWuOViH7G5C1xEJgUvCvN9Gv9U1ECptRRQdxnjK8w4Ztwy2S
	ySiQsK4g==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rbxEn-00000009GK4-1tDp;
	Mon, 19 Feb 2024 06:34:49 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/9] xfs: move RT inode locking out of __xfs_bunmapi
Date: Mon, 19 Feb 2024 07:34:43 +0100
Message-Id: <20240219063450.3032254-3-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240219063450.3032254-1-hch@lst.de>
References: <20240219063450.3032254-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

__xfs_bunmapi is a bit of an odd place to lock the rtbitmap and rtsummary
inodes given that it is very high level code.  While this only looks ugly
right now, it will become a problem when supporting delayed allocations
for RT inodes as __xfs_bunmapi might end up deleting only delalloc extents
and thus never unlock the rt inodes.

Move the locking into xfs_rtfree_blocks instead (where it will also be
helpful once we support extfree items for RT allocations), and use a new
flag in the transaction to ensure they aren't locked twice.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c     | 10 ----------
 fs/xfs/libxfs/xfs_rtbitmap.c | 14 ++++++++++++++
 fs/xfs/libxfs/xfs_shared.h   |  3 +++
 3 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index b525524a2da4ef..f8cc7c510d7bd5 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5321,16 +5321,6 @@ __xfs_bunmapi(
 	} else
 		cur = NULL;
 
-	if (isrt) {
-		/*
-		 * Synchronize by locking the bitmap inode.
-		 */
-		xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL|XFS_ILOCK_RTBITMAP);
-		xfs_trans_ijoin(tp, mp->m_rbmip, XFS_ILOCK_EXCL);
-		xfs_ilock(mp->m_rsumip, XFS_ILOCK_EXCL|XFS_ILOCK_RTSUM);
-		xfs_trans_ijoin(tp, mp->m_rsumip, XFS_ILOCK_EXCL);
-	}
-
 	extno = 0;
 	while (end != (xfs_fileoff_t)-1 && end >= start &&
 	       (nexts == 0 || extno < nexts)) {
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index e31663cb7b4349..2759c48390241d 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1001,6 +1001,20 @@ xfs_rtfree_blocks(
 		return -EIO;
 	}
 
+	/*
+	 * Ensure the bitmap and summary inodes are locked before modifying
+	 * them.  We can get called multiples times per transaction, so record
+	 * the fact that they are locked in the transaction.
+	 */
+	if (!(tp->t_flags & XFS_TRANS_RTBITMAP_LOCKED)) {
+		tp->t_flags |= XFS_TRANS_RTBITMAP_LOCKED;
+
+		xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL|XFS_ILOCK_RTBITMAP);
+		xfs_trans_ijoin(tp, mp->m_rbmip, XFS_ILOCK_EXCL);
+		xfs_ilock(mp->m_rsumip, XFS_ILOCK_EXCL|XFS_ILOCK_RTSUM);
+		xfs_trans_ijoin(tp, mp->m_rsumip, XFS_ILOCK_EXCL);
+	}
+
 	return xfs_rtfree_extent(tp, start, len);
 }
 
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index 6f1cedb850eb39..1598ff00f6805f 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -83,6 +83,9 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
  */
 #define XFS_TRANS_LOWMODE		(1u << 8)
 
+/* Transaction has locked the rtbitmap and rtsum inodes */
+#define XFS_TRANS_RTBITMAP_LOCKED	(1u << 9)
+
 /*
  * Field values for xfs_trans_mod_sb.
  */
-- 
2.39.2

