Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC1F14F9D5
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 02:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711333466; cv=none; b=CN4s0Q/kFi1QQKqFwVNCW1Zt8Y85lRPCD1KOPXWHFT6JbrSsVkYACZRjosPa3jqyhGybZI2BjdshUsUP6eSxkGL0Dmvaucb42m16f7sy6nkGF+nSapm7u3vX/XgW/U+MMgwivyqh9ZNWSlCJhpFbk6Q12fCZWzyAvp0Ze/1RMW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711333466; c=relaxed/simple;
	bh=amfXI+xdCPquIG48BJSUlcrD3ytr3h4clPPQkOuTYdA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GWjgaQNFsTTVgixK6dwdZK+mLbO0GVAP+j9hxPfT8M+a0Yg7kE0O3EQD/fv5HIicwiUyz+v/T7Vkg/rSCkAujY8wn3pehQ8WK3FPEHHIKmo6nB55/TnfdH++cLmAZ6mqQOh9r1kI8Odsn7rXyj6xzbh2AXC/WgiNYnXw+P21CZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=eC9Epmdy; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eC9Epmdy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=PQ2ytX0kZ2dvcgf5y9+awHMMSYIcRnCCJDQomAtfmJs=; b=eC9Epmdyh52i9sgniaQjJL84bX
	36+bBt4ja9/q/V2ALi898eSaO0KWTH6b1AeBcz1XF2/CW1XNIinWRHpDZ+mfSIJyD7FYwQUBbLQBT
	gI/bljOwLwQ7q1bSRZ0Tj38lP9hr25m1GSGUy/diOHaQp9A6FapUbXWSPp6wbBtKORlMHOHgi1qZd
	am6DeTycGUNUmDPziI1Ag/xlM+4YYAPqtXyd9BJA056yTUwrEh+XJKyoV3DTTowsudL/+Z2Uia+Um
	fORUw+iEI0bh8GqalY9QXGDT8o1xL/199n+IdPDrS9tZXd1VQNgE6FUyXTxSjZC4AziCwAxDpSDJb
	pb7jL23A==;
Received: from [210.13.83.2] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1roa0d-0000000EeQQ-3qUI;
	Mon, 25 Mar 2024 02:24:24 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 02/11] xfs: move RT inode locking out of __xfs_bunmapi
Date: Mon, 25 Mar 2024 10:24:02 +0800
Message-Id: <20240325022411.2045794-3-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240325022411.2045794-1-hch@lst.de>
References: <20240325022411.2045794-1-hch@lst.de>
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
index 656c95a22f2e6d..5fb7b38921c9a3 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5414,16 +5414,6 @@ __xfs_bunmapi(
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
index f246d6dbf4eca8..b8d395fa2448f3 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1008,6 +1008,20 @@ xfs_rtfree_blocks(
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
index f35640ad3e7fe4..34f104ed372c09 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -137,6 +137,9 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
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

