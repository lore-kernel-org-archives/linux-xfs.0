Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F8202C6AF
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 11:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711537421; cv=none; b=YiHWZAVBGmM1EAkzzUT8xW+EgSRQQ1K3PzjDyFQz5fRsXlfvkVfFy+9BnP5GEKNbZmQOb5RNbAAKzqYlQByYoqWCX4ua/clCltHXdVIcZ2Gd0X1sNV/xqZXIw7qwC8nrPw0MbQr+/gxbEV3vIM9TR+ab7d2YKa3hjIqctEWsXU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711537421; c=relaxed/simple;
	bh=dScU4OKzOHeHWE1kCKzFNx8vyQcMIMpUobnb7MDIGYs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YigztkbbEhCxcM382HEWfDKGCiX7H5oAUlbl5Yxr4LsbhD/PnskEN+1oPpzQmwp6dlvgQ+zjaPeFqyUkxbUrX1puJt5LuMwVyLxsZvCn4pWPo2ASzAKUSsIxKQyc8AMe8pcE/badRhD1ciQ63eD04XFytpe5FSuW4ZlBGYun8D4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Pnjl8MCd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Pnjl8MCd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=fazoFHSGHynShqIrChJGEzxgtOsoBotHY9ipnAv+uRc=; b=Pnjl8MCdF9MnP/t4qUS1JUVvlc
	dfQdOJDWLYHXuJ3ww1Wy1/ZzGZFm2NZO/EJZ4CRXAbWLL1chZgQUGcSYxLR112U3iouUtP0LXroGc
	nFdZYQN5LTT4qOIr+zdCpGiG++CnfrCD56txdhODhrLNDk9u4hyVtdAAlngSz0lc09ZEqX5bMQHFD
	0bOuFYEItPia8BeA1IcKrpoGnq6YiMtlRfTi7dlqt04vDo4EG0WzbEZZNrRZyqw93wXyCsu2QxOQO
	lJ2i20ue3TULuYHqf1m6TCCkEOn6hXRockFuuzVu/Y5MNG7taHb8dQaXcbj8roHaROhQCeyWYJIi6
	m0Hx9lgA==;
Received: from [89.144.223.137] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rpR4D-00000008WaG-16vZ;
	Wed, 27 Mar 2024 11:03:37 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 04/13] xfs: move RT inode locking out of __xfs_bunmapi
Date: Wed, 27 Mar 2024 12:03:09 +0100
Message-Id: <20240327110318.2776850-5-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240327110318.2776850-1-hch@lst.de>
References: <20240327110318.2776850-1-hch@lst.de>
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

Move the locking into xfs_bmap_del_extent_real just before the call to
xfs_rtfree_blocks instead and use a new flag in the transaction to ensure
that the locking happens only once.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c   | 15 ++++++++-------
 fs/xfs/libxfs/xfs_shared.h |  3 +++
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 282b44deb9f864..e5e199d325982f 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5305,6 +5305,14 @@ xfs_bmap_del_extent_real(
 		if (xfs_is_reflink_inode(ip) && whichfork == XFS_DATA_FORK) {
 			xfs_refcount_decrease_extent(tp, del);
 		} else if (xfs_ifork_is_realtime(ip, whichfork)) {
+			/*
+			 * Ensure the bitmap and summary inodes are locked
+			 * and joined to the transaction before modifying them.
+			 */
+			if (!(tp->t_flags & XFS_TRANS_RTBITMAP_LOCKED)) {
+				tp->t_flags |= XFS_TRANS_RTBITMAP_LOCKED;
+				xfs_rtbitmap_lock(tp, mp);
+			}
 			error = xfs_rtfree_blocks(tp, del->br_startblock,
 					del->br_blockcount);
 		} else {
@@ -5406,13 +5414,6 @@ __xfs_bunmapi(
 	} else
 		cur = NULL;
 
-	if (isrt) {
-		/*
-		 * Synchronize by locking the realtime bitmap.
-		 */
-		xfs_rtbitmap_lock(tp, mp);
-	}
-
 	extno = 0;
 	while (end != (xfs_fileoff_t)-1 && end >= start &&
 	       (nexts == 0 || extno < nexts)) {
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

