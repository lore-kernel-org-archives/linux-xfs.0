Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rScg+W/X"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE4E391
	for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2023 08:38:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=FtVDf2BvTNsPIqBX1aCrgYsKN1KD/vMDX0iHsctNH6Q=; b=rScg+W/XfIiVy2ay6WbGqWV1kr
	rRMOVU3rQBccOt4LNIypmIJz/WaEdb/i/9hEFH9EQoAXjjdahddCfrin40UJ72Pd78Dd7lavxXAJW
	4MuCHdOWoFpK57H/DiphoVG8GYVv1uigP0QEwD4KQHLW6lROUTOPBulJ6Hq7ACa757E81GJW1hYLO
	QxdyB/+qtvaDBkEH84dWibYgAhuqsydoB8TduYf/BuYb1UOe7WYXJepofsA7fSGwMmZ79DpTkANNP
	ltW41YvXd/zEc51saoUCDigx6Tmk7MqONeV+wzNrwiunJ8mCoPvzAMGFmt9UKglXHGZ5YFuph5Y42
	uZ0HMxUA==;
Received: from [2001:4bb8:19a:a621:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rCjIE-005t0Y-3B;
	Mon, 11 Dec 2023 16:38:07 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 07/23] libxlog: add a helper to initialize a xlog without clobbering the x structure
Date: Mon, 11 Dec 2023 17:37:26 +0100
Message-Id: <20231211163742.837427-8-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231211163742.837427-1-hch@lst.de>
References: <20231211163742.837427-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfsprogs has three copies of a code sequence to initialize an xlog
structure from a libxfs_init structure. Factor the code into a helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/libxlog.h   |  1 +
 libxlog/util.c      | 25 +++++++++++++++++--------
 logprint/logprint.c | 25 +++++++++----------------
 repair/phase2.c     | 23 +----------------------
 4 files changed, 28 insertions(+), 46 deletions(-)

diff --git a/include/libxlog.h b/include/libxlog.h
index a598a7b3c..657acfe42 100644
--- a/include/libxlog.h
+++ b/include/libxlog.h
@@ -71,6 +71,7 @@ extern int	print_record_header;
 /* libxfs parameters */
 extern libxfs_init_t	x;
 
+void xlog_init(struct xfs_mount *mp, struct xlog *log, libxfs_init_t *x);
 int xlog_is_dirty(struct xfs_mount *mp, struct xlog *log, libxfs_init_t *x);
 
 extern struct xfs_buf *xlog_get_bp(struct xlog *, int);
diff --git a/libxlog/util.c b/libxlog/util.c
index 1022e3378..bc4db478e 100644
--- a/libxlog/util.c
+++ b/libxlog/util.c
@@ -12,18 +12,12 @@ int print_skip_uuid;
 int print_record_header;
 libxfs_init_t x;
 
-/*
- * Return 1 for dirty, 0 for clean, -1 for errors
- */
-int
-xlog_is_dirty(
+void
+xlog_init(
 	struct xfs_mount	*mp,
 	struct xlog		*log,
 	libxfs_init_t		*x)
 {
-	int			error;
-	xfs_daddr_t		head_blk, tail_blk;
-
 	memset(log, 0, sizeof(*log));
 
 	/* We (re-)init members of libxfs_init_t here?  really? */
@@ -48,6 +42,21 @@ xlog_is_dirty(
 		ASSERT(mp->m_sb.sb_logsectlog >= BBSHIFT);
 	}
 	log->l_sectbb_mask = (1 << log->l_sectbb_log) - 1;
+}
+
+/*
+ * Return 1 for dirty, 0 for clean, -1 for errors
+ */
+int
+xlog_is_dirty(
+	struct xfs_mount	*mp,
+	struct xlog		*log,
+	libxfs_init_t		*x)
+{
+	int			error;
+	xfs_daddr_t		head_blk, tail_blk;
+
+	xlog_init(mp, log, x);
 
 	error = xlog_find_tail(log, &head_blk, &tail_blk);
 	if (error) {
diff --git a/logprint/logprint.c b/logprint/logprint.c
index 7d51cdd91..c78aeb2f8 100644
--- a/logprint/logprint.c
+++ b/logprint/logprint.c
@@ -58,7 +58,6 @@ logstat(
 {
 	int		fd;
 	char		buf[BBSIZE];
-	xfs_sb_t	*sb;
 
 	/* On Linux we always read the superblock of the
 	 * filesystem. We need this to get the length of the
@@ -77,19 +76,16 @@ logstat(
 	close (fd);
 
 	if (!x.disfile) {
+		struct xfs_sb	*sb = &mp->m_sb;
+
 		/*
 		 * Conjure up a mount structure
 		 */
-		sb = &mp->m_sb;
 		libxfs_sb_from_disk(sb, (struct xfs_dsb *)buf);
 		mp->m_features |= libxfs_sb_version_to_features(&mp->m_sb);
 		mp->m_blkbb_log = sb->sb_blocklog - BBSHIFT;
 
-		x.logBBsize = XFS_FSB_TO_BB(mp, sb->sb_logblocks);
-		x.logBBstart = XFS_FSB_TO_DADDR(mp, sb->sb_logstart);
-		x.lbsize = BBSIZE;
-		if (xfs_has_sector(mp))
-			x.lbsize <<= (sb->sb_logsectlog - BBSHIFT);
+		xlog_init(mp, log, &x);
 
 		if (!x.logname && sb->sb_logstart == 0) {
 			fprintf(stderr, _("    external log device not specified\n\n"));
@@ -100,16 +96,13 @@ logstat(
 		struct stat	s;
 
 		stat(x.dname, &s);
-		x.logBBsize = s.st_size >> 9;
-		x.logBBstart = 0;
-		x.lbsize = BBSIZE;
-	}
 
-	log->l_dev = mp->m_logdev_targp;
-	log->l_logBBstart = x.logBBstart;
-	log->l_logBBsize = x.logBBsize;
-	log->l_sectBBsize = BTOBB(x.lbsize);
-	log->l_mp = mp;
+		log->l_logBBsize = s.st_size >> 9;
+		log->l_logBBstart = 0;
+		log->l_sectBBsize = BTOBB(BBSIZE);
+		log->l_dev = mp->m_logdev_targp;
+		log->l_mp = mp;
+	}
 
 	if (x.logname && *x.logname) {    /* External log */
 		if ((fd = open(x.logname, O_RDONLY)) == -1) {
diff --git a/repair/phase2.c b/repair/phase2.c
index 2ada95aef..a9dd77be3 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -30,28 +30,7 @@ zero_log(
 	xfs_daddr_t		tail_blk;
 	struct xlog		*log = mp->m_log;
 
-	memset(log, 0, sizeof(struct xlog));
-	x.logBBsize = XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
-	x.logBBstart = XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart);
-	x.lbsize = BBSIZE;
-	if (xfs_has_sector(mp))
-		x.lbsize <<= (mp->m_sb.sb_logsectlog - BBSHIFT);
-
-	log->l_dev = mp->m_logdev_targp;
-	log->l_logBBsize = x.logBBsize;
-	log->l_logBBstart = x.logBBstart;
-	log->l_sectBBsize  = BTOBB(x.lbsize);
-	log->l_mp = mp;
-	if (xfs_has_sector(mp)) {
-		log->l_sectbb_log = mp->m_sb.sb_logsectlog - BBSHIFT;
-		ASSERT(log->l_sectbb_log <= mp->m_sectbb_log);
-		/* for larger sector sizes, must have v2 or external log */
-		ASSERT(log->l_sectbb_log == 0 ||
-			log->l_logBBstart == 0 ||
-			xfs_has_logv2(mp));
-		ASSERT(mp->m_sb.sb_logsectlog >= BBSHIFT);
-	}
-	log->l_sectbb_mask = (1 << log->l_sectbb_log) - 1;
+	xlog_init(mp, mp->m_log, &x);
 
 	/*
 	 * Find the log head and tail and alert the user to the situation if the
-- 
2.39.2

