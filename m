Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE374052AA
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 05:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790313246; cv=none; b=MafRWXmBlqi7dfJ1SQaGftnl+CpetvuyMe0RaQfbJuHBrbYCaWhCVVQ0CAD2s5g4mlxEVVZUL0f39S96zCjWo/D8ksqnmIBI2qqdM4HNOFjMOfdlPY+Sm9NuNZl5GGvbE8zcFoG9WwnL9Hi5Jyf7sxxex+RNub5XXncMVtjnNyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790313246; c=relaxed/simple;
	bh=tWIFfO3xp+6IfhY3wbWCFWBUpWlTVb70Hts6eZvWp7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ww6nZi4ewklqeZOoG74AlLZG3LBReHu/DCLqqaclhw2yoBhRCPOIk0rde3b0tjJ2Y7A7lwMKLvsuItnb/2yp20A82ZJAZrd3qYxZAcTfktzj/nLI29vk65bY7wBb8nolZYlpHaAODzzx5uJVarUPaR92WU2uuEwLKJAOn+ta2tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vbb+kC9Q; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vbb+kC9Q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=k9aGMNzwBthXgjCDLLsdLyV2EjB1FOJbeKywAK4VUhg=; b=vbb+kC9Q6dPc+29VfYcg/gtWk0
	Pmb8aa3ckJ+rXk4PQleeyXFAG36DpsBeFZwZHMWUqvwKGN3/897e+ARJu/llBRYRz6e5VfzNSuqkG
	TRdtKFwB2nphqoB/cNkaWa6j8Y20JsrYfmTDvXa9MLgcwxgO3mvHGSviUEcSC1B5vasodtGGzYMWt
	dd8Wd4OAK6PFNqKUEJ+gcPuv84kSrTmrvBfiTRrumP7Gs85r6V9Y3Ia5yOZ+j9mbsvLq60weKd6xI
	CEHW/avbeiS6gz+4qmZmL1Ht9t6s5BwXwaCmOC//2EWUSJEwMVYua3oni5pEGl3xFzgRN73rmj3dP
	gb2Em5jg==;
Received: from 2a02-8389-2301-9f00-b711-947d-6c5b-1af5.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b711:947d:6c5b:1af5] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9yG2-0000000Cgcd-1Xgh;
	Fri, 25 Sep 2026 05:14:02 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 08/10] libxfs: rename bt_bdev*
Date: Fri, 25 Sep 2026 07:12:54 +0200
Message-ID: <20260925051336.2997014-9-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260925051336.2997014-1-hch@lst.de>
References: <20260925051336.2997014-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Unlike the kernel, there is no block device concept in libxfs.

Rename the bt_bdev field to bt_dev as it stores a dev_t, and bt_bdev_fd
to just bt_fd to make the naming a bit less confusing.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/buf_mem.c   |  4 ++--
 libxfs/init.c      | 10 +++++-----
 libxfs/libxfs_io.h |  4 ++--
 libxfs/rdwr.c      | 12 ++++++------
 repair/prefetch.c  |  2 +-
 repair/zoned.c     |  2 +-
 6 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/libxfs/buf_mem.c b/libxfs/buf_mem.c
index 3c8452de9689..f3db59dfc63e 100644
--- a/libxfs/buf_mem.c
+++ b/libxfs/buf_mem.c
@@ -294,8 +294,8 @@ xmbuf_alloc(
 
 	/* Initialize buffer target */
 	btp->bt_mount = mp;
-	btp->bt_bdev = (dev_t)-1;
-	btp->bt_bdev_fd = -1;
+	btp->bt_dev = (dev_t)-1;
+	btp->bt_fd = -1;
 	btp->bt_xfile = xfile;
 	btp->bcache = cache;
 
diff --git a/libxfs/init.c b/libxfs/init.c
index 97c5286c00a9..5a4b255165ab 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -457,8 +457,8 @@ libxfs_buftarg_alloc(
 		exit(1);
 	}
 	btp->bt_mount = mp;
-	btp->bt_bdev = dev->dev;
-	btp->bt_bdev_fd = dev->fd;
+	btp->bt_dev = dev->dev;
+	btp->bt_fd = dev->fd;
 	btp->bt_xfile = NULL;
 	btp->flags = 0;
 	pthread_mutex_init(&btp->lock, NULL);
@@ -534,7 +534,7 @@ libxfs_buftarg_reinit(
 	struct xfs_mount	*mp,
 	struct libxfs_init	*xi)
 {
-	if (mp->m_ddev_targp->bt_bdev != xi->data.dev ||
+	if (mp->m_ddev_targp->bt_dev != xi->data.dev ||
 	    mp->m_ddev_targp->bt_mount != mp) {
 		fprintf(stderr,
 			_("%s: bad buftarg reinit, ddev\n"),
@@ -544,7 +544,7 @@ libxfs_buftarg_reinit(
 
 	if (mp->m_logdev_targp != mp->m_ddev_targp) {
 		if ((xi->log.dev && xi->log.dev == xi->data.dev) ||
-		    mp->m_logdev_targp->bt_bdev != xi->log.dev ||
+		    mp->m_logdev_targp->bt_dev != xi->log.dev ||
 		    mp->m_logdev_targp->bt_mount != mp) {
 			fprintf(stderr,
 				_("%s: bad buftarg reinit, logdev\n"),
@@ -554,7 +554,7 @@ libxfs_buftarg_reinit(
 	}
 
 	if (mp->m_rtdev_targp && mp->m_rtdev_targp != mp->m_ddev_targp) {
-		if (mp->m_rtdev_targp->bt_bdev != xi->rt.dev ||
+		if (mp->m_rtdev_targp->bt_dev != xi->rt.dev ||
 		    mp->m_rtdev_targp->bt_mount != mp) {
 			fprintf(stderr,
 				_("%s: bad buftarg reinit, rtdev\n"),
diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 5562e2928254..d861763a2a63 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -25,8 +25,8 @@ struct xfs_buftarg {
 	struct xfs_mount	*bt_mount;
 	pthread_mutex_t		lock;
 	unsigned long		writes_left;
-	dev_t			bt_bdev;
-	int			bt_bdev_fd;
+	dev_t			bt_dev;
+	int			bt_fd;
 	struct xfile		*bt_xfile;
 	unsigned int		flags;
 	struct cache		*bcache;	/* buffer cache */
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 14cfec7a2859..837288be0307 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -62,7 +62,7 @@ static void libxfs_brelse(struct cache_node *node);
 int
 libxfs_device_zero(struct xfs_buftarg *btp, xfs_daddr_t start, uint len)
 {
-	int		fd = btp->bt_bdev_fd;
+	int		fd = btp->bt_fd;
 	xfs_off_t	start_offset, end_offset, offset;
 	ssize_t		zsize, bytes;
 	size_t		len_bytes;
@@ -608,7 +608,7 @@ int
 libxfs_readbufr(struct xfs_buftarg *btp, xfs_daddr_t blkno, struct xfs_buf *bp,
 		int len, int flags)
 {
-	int	fd = btp->bt_bdev_fd;
+	int	fd = btp->bt_fd;
 	int	bytes = BBTOB(len);
 	int	error;
 
@@ -644,7 +644,7 @@ libxfs_readbuf_verify(
 int
 libxfs_readbufr_map(struct xfs_buftarg *btp, struct xfs_buf *bp, int flags)
 {
-	int	fd = btp->bt_bdev_fd;
+	int	fd = btp->bt_fd;
 	int	error = 0;
 	void	*buf;
 	int	i;
@@ -834,7 +834,7 @@ int
 libxfs_bwrite(
 	struct xfs_buf	*bp)
 {
-	int		fd = bp->b_target->bt_bdev_fd;
+	int		fd = bp->b_target->bt_fd;
 
 	/*
 	 * we never write buffers that are marked stale. This indicates they
@@ -1109,10 +1109,10 @@ libxfs_blkdev_issue_flush(
 {
 	int			ret;
 
-	if (btp->bt_bdev == 0)
+	if (btp->bt_dev == 0)
 		return 0;
 
-	ret = platform_flush_device(btp->bt_bdev_fd, btp->bt_bdev);
+	ret = platform_flush_device(btp->bt_fd, btp->bt_dev);
 	return ret ? -errno : 0;
 }
 
diff --git a/repair/prefetch.c b/repair/prefetch.c
index 3d26636e5e56..3e03ae7f0210 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -878,7 +878,7 @@ init_prefetch(
 	xfs_mount_t		*pmp)
 {
 	mp = pmp;
-	mp_fd = mp->m_ddev_targp->bt_bdev_fd;;
+	mp_fd = mp->m_ddev_targp->bt_fd;;
 	pf_max_bytes = sysconf(_SC_PAGE_SIZE) << 7;
 	pf_max_bbs = pf_max_bytes >> BBSHIFT;
 	pf_max_fsbs = pf_max_bytes >> mp->m_sb.sb_blocklog;
diff --git a/repair/zoned.c b/repair/zoned.c
index 6ab91371d95a..1e949f549583 100644
--- a/repair/zoned.c
+++ b/repair/zoned.c
@@ -50,7 +50,7 @@ void
 check_zones(
 	struct xfs_mount	*mp)
 {
-	int			fd = mp->m_rtdev_targp->bt_bdev_fd;
+	int			fd = mp->m_rtdev_targp->bt_fd;
 	uint64_t		sector = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rtstart);
 	unsigned int		zone_size, zone_capacity;
 	uint64_t		device_size;
-- 
2.53.0

