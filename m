Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F0B37C90F
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jun 2026 12:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780317864; cv=none; b=V3Bh9dJjZzw2JO0LIN6hLz/l90rdyQWsDgPQmw05sYlwSvYvcT6JtaCvqyZSysRmfQdjaQwqzNQVjDEhzevjwXAyiPYlnSzcbbs3cnjieUSRdA+CS/c5XWKWlUb20fyY/vDFucrfTd9U8brf2mfJFXw88oUhd/1NQrjKwXek8Ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780317864; c=relaxed/simple;
	bh=dgEknTyM3bvY1bM/bw+09eNbNGsm7/vOelZxPKTe4BM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AKXjAL/so/wM2ImK7yxxQQKcEmzbeqvocEK6gaGQy7zLMYn8LHB3VQ5TeXuaaQ4k0z1BNPMAzRcUhiMa0rRtcJpe2h0HFbt4+SeCLT8JokiQQ6HI3B0MQ8frkoxjolikmzfGHgfboguCC1SC8f1y4HZsFLxsFG8CnFIgb6C9sjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ecEHdWM8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ecEHdWM8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=j0Uz84unZAphg1p836hZb9CHet/wowjXxBTTJzjZpvU=; b=ecEHdWM8FmjAyDJp93w5VVJQJ2
	yD1E5hm0H5tAfpcZC0O9W1CHy4QGDC6/g4JXVkonDwzqHlTNMTCSDwwxtBjjuTiKZqopXDqmXB1Xr
	NrUWMv5o/YfXViwFQurs/clJMXGsMoGmczPZHoqGhNCRHaHkkv2+LdvdSbnhWKiC80jotIlIGX+Fr
	PJE7xA9iaeFP+s44mxXYVu5os6fPsKoynK4hY3L0YPHDbnr0PhP4es5/gT1F4Ifel/A8apEvfdZq4
	JixkAd4wj0usmHNeG1bOL1L7hj3Kxrl86yZvjdEFdLsTqy1ZjZaXsVNLQ3ZODt1PkTGunGTi88mqT
	LqWsHwdw==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wU20E-0000000BA27-0Rqf;
	Mon, 01 Jun 2026 12:44:22 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 3/5] xfs: massage xfs_imap_to_bp into xfs_read_icluster
Date: Mon,  1 Jun 2026 14:43:49 +0200
Message-ID: <20260601124410.3508980-4-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260601124410.3508980-1-hch@lst.de>
References: <20260601124410.3508980-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_imap_to_bp only uses the im_blkno field from struct xfs_imap, so pass
that directly.  Rename the function to xfs_read_icluster, which describes
the functionality much better and matches other helpers like xfs_read_agf
and xfs_read_agi.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_ialloc.c    |  2 +-
 fs/xfs/libxfs/xfs_inode_buf.c | 12 +++++-------
 fs/xfs/libxfs/xfs_inode_buf.h |  6 +++---
 fs/xfs/scrub/ialloc.c         |  3 ++-
 fs/xfs/scrub/ialloc_repair.c  |  7 +++----
 fs/xfs/xfs_icache.c           |  2 +-
 fs/xfs/xfs_inode_item.c       |  3 ++-
 fs/xfs/xfs_iunlink_item.c     |  2 +-
 8 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 6ea7e96a07b4..18d07cf4c3e0 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1075,7 +1075,7 @@ xfs_dialloc_check_ino(
 	if (error)
 		return -EAGAIN;
 
-	error = xfs_imap_to_bp(pag_mount(pag), tp, &imap, &bp);
+	error = xfs_read_icluster(pag_mount(pag), tp, imap.im_blkno, &bp);
 	if (error)
 		return -EAGAIN;
 
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index ecc50daa67ba..a9864e3050cb 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -123,24 +123,22 @@ const struct xfs_buf_ops xfs_inode_buf_ra_ops = {
 
 
 /*
- * This routine is called to map an inode to the buffer containing the on-disk
- * version of the inode.  It returns a pointer to the buffer containing the
- * on-disk inode in the bpp parameter.
+ * Read the inode cluster at @bno and return it in @bpp.
  */
 int
-xfs_imap_to_bp(
+xfs_read_icluster(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
-	struct xfs_imap		*imap,
+	xfs_daddr_t		bno,
 	struct xfs_buf		**bpp)
 {
 	int			error;
 
-	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, imap->im_blkno,
+	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, bno,
 			XFS_FSB_TO_BB(mp, M_IGEO(mp)->blocks_per_cluster),
 			0, bpp, &xfs_inode_buf_ops);
 	if (xfs_metadata_is_sick(error))
-		xfs_agno_mark_sick(mp, xfs_daddr_to_agno(mp, imap->im_blkno),
+		xfs_agno_mark_sick(mp, xfs_daddr_to_agno(mp, bno),
 				XFS_SICK_AG_INODES);
 	return error;
 }
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 54870796da41..bcad22871b5c 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -11,15 +11,15 @@ struct xfs_dinode;
 
 /*
  * Inode location information.  Stored in the inode and passed to
- * xfs_imap_to_bp() to get a buffer and dinode for a given inode.
+ * xfs_read_icluster() to get a buffer and dinode for a given inode.
  */
 struct xfs_imap {
 	xfs_daddr_t	im_blkno;	/* starting BB of inode chunk */
 	unsigned short	im_boffset;	/* inode offset in block in bytes */
 };
 
-int	xfs_imap_to_bp(struct xfs_mount *mp, struct xfs_trans *tp,
-		       struct xfs_imap *imap, struct xfs_buf **bpp);
+int	xfs_read_icluster(struct xfs_mount *mp, struct xfs_trans *tp,
+		xfs_daddr_t bno, struct xfs_buf **bpp);
 void	xfs_dinode_calc_crc(struct xfs_mount *mp, struct xfs_dinode *dip);
 void	xfs_inode_to_disk(struct xfs_inode *ip, struct xfs_dinode *to,
 			  xfs_lsn_t lsn);
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index a7192ba29262..fafbf1636723 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -429,7 +429,8 @@ xchk_iallocbt_check_cluster(
 			&XFS_RMAP_OINFO_INODES);
 
 	/* Grab the inode cluster buffer. */
-	error = xfs_imap_to_bp(mp, bs->cur->bc_tp, &imap, &cluster_bp);
+	error = xfs_read_icluster(mp, bs->cur->bc_tp, imap.im_blkno,
+			&cluster_bp);
 	if (!xchk_btree_xref_process_error(bs->sc, bs->cur, 0, &error))
 		return error;
 
diff --git a/fs/xfs/scrub/ialloc_repair.c b/fs/xfs/scrub/ialloc_repair.c
index 2d7b9ce968dc..167f605a4962 100644
--- a/fs/xfs/scrub/ialloc_repair.c
+++ b/fs/xfs/scrub/ialloc_repair.c
@@ -287,7 +287,6 @@ xrep_ibt_process_cluster(
 	struct xrep_ibt		*ri,
 	xfs_agblock_t		cluster_bno)
 {
-	struct xfs_imap		imap;
 	struct xfs_buf		*cluster_bp;
 	struct xfs_scrub	*sc = ri->sc;
 	struct xfs_mount	*mp = sc->mp;
@@ -305,9 +304,9 @@ xrep_ibt_process_cluster(
 	 * inobt because imap_to_bp directly maps the buffer without touching
 	 * either inode btree.
 	 */
-	imap.im_blkno = xfs_agbno_to_daddr(sc->sa.pag, cluster_bno);
-	imap.im_boffset = 0;
-	error = xfs_imap_to_bp(mp, sc->tp, &imap, &cluster_bp);
+	error = xfs_read_icluster(mp, sc->tp,
+			xfs_agbno_to_daddr(sc->sa.pag, cluster_bno),
+			&cluster_bp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 6f19e751bb8a..234c1e6974e4 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -663,7 +663,7 @@ xfs_iget_cache_miss(
 	} else {
 		struct xfs_buf		*bp;
 
-		error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &bp);
+		error = xfs_read_icluster(mp, tp, ip->i_imap.im_blkno, &bp);
 		if (error)
 			goto out_destroy;
 
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 3256495202cf..b4a835eb2e6d 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -167,7 +167,8 @@ xfs_inode_item_precommit(
 		 * here.
 		 */
 		spin_unlock(&iip->ili_lock);
-		error = xfs_imap_to_bp(ip->i_mount, tp, &ip->i_imap, &bp);
+		error = xfs_read_icluster(ip->i_mount, tp, ip->i_imap.im_blkno,
+				&bp);
 		if (error)
 			return error;
 
diff --git a/fs/xfs/xfs_iunlink_item.c b/fs/xfs/xfs_iunlink_item.c
index c8817112d49d..f8f2edea0934 100644
--- a/fs/xfs/xfs_iunlink_item.c
+++ b/fs/xfs/xfs_iunlink_item.c
@@ -59,7 +59,7 @@ xfs_iunlink_log_dinode(
 	int			offset;
 	int			error;
 
-	error = xfs_imap_to_bp(tp->t_mountp, tp, &ip->i_imap, &ibp);
+	error = xfs_read_icluster(tp->t_mountp, tp, ip->i_imap.im_blkno, &ibp);
 	if (error)
 		return error;
 	/*
-- 
2.53.0

