Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D4D54279
	for <linux-xfs@vger.kernel.org>; Mon, 26 Feb 2024 10:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708941884; cv=none; b=G2jhgKCkomwDEHYAQpSD51zmn8hWsjoCGLgg1uwtgjiPIcVsVB6/FEWpiwaqp6KswJvPKFmHtVoynSswyEkmxn/OZ0NQi60x01o1dpT8yPFfvRRezBIOA+Xf3nIIXy6JagBFuQQi7wehW8zQZ7FJjpD+V2KR9qkM+sQ7FmZ1KJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708941884; c=relaxed/simple;
	bh=JO/d/fPL0IAXWRpiFCXxbS6SrG9ZvoAmsTD1t0VzsBg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=flq003kTiYky6IrgTRQzDOcHRzxTkDrpFQzmedrvdcdJ+F/Hkl99Sc5dzX2RqPFr4Y9BfzMr8p80enLkEZp8tkC91Y4EOtKe1zqc1Dh1npaordIBStohS875PyG53TDClLv4D5TgycyLOr9izdwAPk62NumhScGUglAcDN3IKj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ABUqfiXx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ABUqfiXx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=PkrnhIW1hrS5hSYUgmNh2BN66HOtns0Jt+X2MhGi6HA=; b=ABUqfiXxWgZujs/ffaFuDRc/Bt
	hlcibdO2qSBvXMNuVZRI5D8/HOL0OMZfyg8zBHNcFYFMEAg7OMGeXC5/nQhpQZmf2VBWEZCbXesS7
	JM8CXI7ymWUDK/E5zchA33KleozzZ6cGnV6CZ78km4eTEcvQsdmvbEsqf+hkgOyue29n3NV4GGJku
	/+0gAX6s69STX7YO8U2WMsaJEdlXfZdnJz25+QGND9qsxrtTAGR473yGis9r77P/fJHNC4mpQUCyF
	fSNnNLpHqCLoIZbvwHdBu2paaIojihoVlh0mhQfRPsj7fL3nwzbD0WE6c4SO5af52r3iaeQXFwKpC
	dNAVnOvA==;
Received: from 213-147-167-65.nat.highway.webapn.at ([213.147.167.65] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1reXqc-0000000HWwB-1u7T;
	Mon, 26 Feb 2024 10:04:35 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 02/10] xfs: move RT inode locking out of __xfs_bunmapi
Date: Mon, 26 Feb 2024 11:04:12 +0100
Message-Id: <20240226100420.280408-3-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240226100420.280408-1-hch@lst.de>
References: <20240226100420.280408-1-hch@lst.de>
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
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c     | 10 ----------
 fs/xfs/libxfs/xfs_rtbitmap.c | 14 ++++++++++++++
 fs/xfs/libxfs/xfs_shared.h   |  3 +++
 3 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 68ab22a2a4530a..ac352cee4950bf 100644
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
index 1f6e05fc359b70..73f2dad6c19471 100644
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

