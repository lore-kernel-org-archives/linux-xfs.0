Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581F81465A8
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 11:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713784839; cv=none; b=H61/3iI1PGturiXF+lPiAk2X+Rzl+y5KNX12wi0ugj0valgAmAXAkqE8Y0DImWq0ocXk5eMex3wq+c9vVSX0hwxszikgqkhJXd3ZYUFv/zGJNAgxNIr0ppFA6e4ykclQLnIjAvApyVVJmEULLP00s214s/FlRtbA2nNUalNVxrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713784839; c=relaxed/simple;
	bh=NRIu/VIRjOFsLgPgsxx08HBEWxVQ3VVNPPzx7fk57p0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SfteekKxidbZq0NxuDoG5Pr/GdMyhGb6qM+XuIjRjxUskvHeuG8ZXOZSmeamxCxi0zFwaFQwsnhgaKBEnIDn/qnsGZO2txIBkEAtGCOkITv1SeJxCuEPh27ADDuI8Zm5VriE4wJqn1g6iy6Zu1kXWweI4VMvO3HrFQTm3vI3fKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ju/ILhKw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ju/ILhKw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=MtatUjASEeAy6Tt9MvTk1euwqlXyYCX1TxD2uhFvQ6Y=; b=Ju/ILhKw0g5LIiho5VCk2wn0ci
	Uk9dRA2F8JHfOiMxVJ8xSL/4CgdK5V10v3kQezNvEuEejFHhBRAgE4GNSg/FfEJD5bV3NGW+yyRrZ
	h7mYkXNBjuJS1xKDJTWAk5vvV3iUcTD/LlCxk5t0fk92df9P4ldDACF+yX+roj7yfy4oEAGy3LPVo
	st+rZyaV0f06LoHbPjlyzMx94TB3KnTAI6u9m6Jj3RO08kps9K3GG7IrR3roV/fMp1sjQMZvhG0VL
	FbsExsqmV8Yd9LOAfQ6bCzzdaaSVOA1SbB6KAD3l51ulfw+DTYRH0v9xLO5WgRAf+yZ2LE9YWVL5K
	g/1oDbug==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ryriv-0000000DL5u-031z;
	Mon, 22 Apr 2024 11:20:37 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org,
	Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 04/13] xfs: move RT inode locking out of __xfs_bunmapi
Date: Mon, 22 Apr 2024 13:20:10 +0200
Message-Id: <20240422112019.212467-5-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240422112019.212467-1-hch@lst.de>
References: <20240422112019.212467-1-hch@lst.de>
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
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c   | 15 ++++++++-------
 fs/xfs/libxfs/xfs_shared.h |  3 +++
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index f529aa40710924..22d44627ec5993 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5307,6 +5307,14 @@ xfs_bmap_del_extent_real(
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
@@ -5408,13 +5416,6 @@ __xfs_bunmapi(
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

