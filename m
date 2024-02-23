Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F907134BE
	for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2024 07:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708672550; cv=none; b=s0/6ZvLWdzLRcm85cIdOcsFiH51p7ddzkvqXXcLUTeHcKg+2agB2uPaTE0uSstrC35pwJTYBymMVUVYab9/cF/eBQOwAzDJBv7m5bBaIgwFXvHwADX7uOZ3p+TljhOpHavuAYv2d9XLG7/oALssAwZIYAxsMs8fG0jM3esplO7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708672550; c=relaxed/simple;
	bh=8BK7YXfys2/LCAiXFGPFnZAo2mjBBNyXGdB72HfNl/0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=luLNF32ZQMeu8S5qs9AFLYAo/11y0d4JFOwv6uS5TFsuHALVj+zVjqXSsT189x5ZfU5EGNP88nxIgOKeiyTBQs5sIQomD/2w4tszVZe39dcP2AAdnyosOQr0aGw9Cf1aWtE8m1Vt4yhY9LCe+glsRefO5IQm91vDEh9ghXsM1Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DaOXPpfp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DaOXPpfp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=zloJEx2IXPGo5/DTphTR2ixiz4Rnf0oFUPezs7NdTgg=; b=DaOXPpfpATfWfalyqoVZgmY3mu
	bLlEW4g/jslmR4eErtKoKOWS7PkSzJ7asYxrxfvkG6TvVpoI1+3ZMR1WD/O0VXVMpLCniYJyI8Rfu
	GY1iP1LoyHX3jL9LWpQna9sqImnI7YPJvrFSpDUS9/q5GXOIuqzV3lrtOZA/OxuVy6aFI7rfTzdcK
	0sEytou54KeFvQBIE/8Xv0Pe5Z0PpIXbIX7+tJ6So27FCZPCHWGtr5gxWTfb0ZO6rTjJzpaJO2fEC
	FFRZhuCmRLCd183m03OS7BJYDtuVjHT43sAkjqFEBXoQJY3b7X+nFgIvKwNixrQaeQBnTTtvhmNLY
	79j3VMeA==;
Received: from [2001:4bb8:19a:62b2:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rdPmc-00000008Gsg-04cB;
	Fri, 23 Feb 2024 07:15:47 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 02/10] xfs: move RT inode locking out of __xfs_bunmapi
Date: Fri, 23 Feb 2024 08:14:58 +0100
Message-Id: <20240223071506.3968029-3-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240223071506.3968029-1-hch@lst.de>
References: <20240223071506.3968029-1-hch@lst.de>
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

