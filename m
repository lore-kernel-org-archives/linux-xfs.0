Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="u7UiT1N3"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 620CA8E
	for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2023 08:38:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=/gqTejgdpI0z2c8oe/kZNt7Wg4YOkgkoMqOtDFIlUCo=; b=u7UiT1N3ucYsDLhWBHblJ4psvm
	5cqfeQDMPbrkVEoW9iQ+AjqT3XOx3iH8JLIGjZ13bt3ENGdsdeztIAAh+aidgm+ottVXVfYINfprC
	zJ3zYguWfTWC7LUayVZhQTUXudqJ8kQhqCYWeP33aobOFroaRLdJOu27tC2M2QFpLku/54qxn6S93
	zBbvq/IYK4JnS8ORBATmqLRmtrhK1MW3B3K2g/0Zgky/puhB6Hi2hgvv7HSvsemv8kCzNySk5YVOt
	XBk2byWqJVLGOk0VtNRU/9hNwh3UqVKJQH7p4nuRu6q/maetnAKu7a8ZHBcfEnXvllzmbZLkop+9Z
	ThkUZHcg==;
Received: from [2001:4bb8:19a:a621:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rCjIH-005t2p-2s;
	Mon, 11 Dec 2023 16:38:10 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 08/23] libxlog: don't require a libxfs_xinit structure for xlog_init
Date: Mon, 11 Dec 2023 17:37:27 +0100
Message-Id: <20231211163742.837427-9-hch@lst.de>
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

xlog_init currently requires a libxfs_args structure to be passed in,
and then clobbers various log-related arguments to it.  There is no
good reason for that as all the required information can be calculated
without it.

Remove the x argument to xlog_init and xlog_is_dirty and the now unused
logBBstart member in struct libxfs_xinit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 copy/xfs_copy.c     |  2 +-
 db/metadump.c       |  4 ++--
 db/sb.c             |  2 +-
 include/libxfs.h    |  1 -
 include/libxlog.h   |  4 ++--
 libxfs/init.c       |  2 +-
 libxlog/util.c      | 25 ++++++++++---------------
 logprint/logprint.c |  2 +-
 repair/phase2.c     |  2 +-
 9 files changed, 19 insertions(+), 25 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 4bd473a04..86187086d 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -784,7 +784,7 @@ main(int argc, char **argv)
 	 */
 	memset(&xlog, 0, sizeof(struct xlog));
 	mp->m_log = &xlog;
-	c = xlog_is_dirty(mp, mp->m_log, &xargs);
+	c = xlog_is_dirty(mp, mp->m_log);
 	if (!duplicate) {
 		if (c == 1) {
 			do_log(_(
diff --git a/db/metadump.c b/db/metadump.c
index e57b024cd..bac35b9cc 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2615,7 +2615,7 @@ copy_log(void)
 	if (!metadump.obfuscate && !metadump.zero_stale_data)
 		goto done;
 
-	dirty = xlog_is_dirty(mp, &log, &x);
+	dirty = xlog_is_dirty(mp, &log);
 
 	switch (dirty) {
 	case 0:
@@ -2945,7 +2945,7 @@ metadump_f(
 		if (iocur_top->data) {	/* best effort */
 			struct xlog	log;
 
-			if (xlog_is_dirty(mp, &log, &x))
+			if (xlog_is_dirty(mp, &log))
 				metadump.dirty_log = true;
 		}
 		pop_cur();
diff --git a/db/sb.c b/db/sb.c
index a3a4a758f..2f046c6aa 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -235,7 +235,7 @@ sb_logcheck(void)
 
 	libxfs_buftarg_init(mp, x.ddev, x.logdev, x.rtdev);
 
-	dirty = xlog_is_dirty(mp, mp->m_log, &x);
+	dirty = xlog_is_dirty(mp, mp->m_log);
 	if (dirty == -1) {
 		dbprintf(_("ERROR: cannot find log head/tail, run xfs_repair\n"));
 		return 0;
diff --git a/include/libxfs.h b/include/libxfs.h
index b35dc2184..270efb2c1 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -115,7 +115,6 @@ typedef struct libxfs_xinit {
 	long long       logBBsize;      /* size of log subvolume (BBs) */
 					/* (blocks allocated for use as
 					 * log is stored in mount structure) */
-	long long       logBBstart;     /* start block of log subvolume (BBs) */
 	long long       rtsize;         /* size of realtime subvolume (BBs) */
 	int		dbsize;		/* data subvolume device blksize */
 	int		lbsize;		/* log subvolume device blksize */
diff --git a/include/libxlog.h b/include/libxlog.h
index 657acfe42..57f39e4e8 100644
--- a/include/libxlog.h
+++ b/include/libxlog.h
@@ -71,8 +71,8 @@ extern int	print_record_header;
 /* libxfs parameters */
 extern libxfs_init_t	x;
 
-void xlog_init(struct xfs_mount *mp, struct xlog *log, libxfs_init_t *x);
-int xlog_is_dirty(struct xfs_mount *mp, struct xlog *log, libxfs_init_t *x);
+void xlog_init(struct xfs_mount *mp, struct xlog *log);
+int xlog_is_dirty(struct xfs_mount *mp, struct xlog *log);
 
 extern struct xfs_buf *xlog_get_bp(struct xlog *, int);
 extern int	xlog_bread(struct xlog *log, xfs_daddr_t blk_no, int nbblks,
diff --git a/libxfs/init.c b/libxfs/init.c
index 894d84057..6482ba52b 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -304,7 +304,7 @@ libxfs_init(libxfs_init_t *a)
 	a->dfd = a->logfd = a->rtfd = -1;
 	a->ddev = a->logdev = a->rtdev = 0;
 	a->dsize = a->lbsize = a->rtbsize = 0;
-	a->dbsize = a->logBBsize = a->logBBstart = a->rtsize = 0;
+	a->dbsize = a->logBBsize = a->rtsize = 0;
 
 	flags = (a->isreadonly | a->isdirect);
 
diff --git a/libxlog/util.c b/libxlog/util.c
index bc4db478e..d1377c2e2 100644
--- a/libxlog/util.c
+++ b/libxlog/util.c
@@ -15,22 +15,18 @@ libxfs_init_t x;
 void
 xlog_init(
 	struct xfs_mount	*mp,
-	struct xlog		*log,
-	libxfs_init_t		*x)
+	struct xlog		*log)
 {
-	memset(log, 0, sizeof(*log));
+	unsigned int		log_sect_size = BBSIZE;
 
-	/* We (re-)init members of libxfs_init_t here?  really? */
-	x->logBBsize = XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
-	x->logBBstart = XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart);
-	x->lbsize = BBSIZE;
-	if (xfs_has_sector(mp))
-		x->lbsize <<= (mp->m_sb.sb_logsectlog - BBSHIFT);
+	memset(log, 0, sizeof(*log));
 
 	log->l_dev = mp->m_logdev_targp;
-	log->l_logBBsize = x->logBBsize;
-	log->l_logBBstart = x->logBBstart;
-	log->l_sectBBsize = BTOBB(x->lbsize);
+	log->l_logBBsize = XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
+	log->l_logBBstart = XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart);
+	if (xfs_has_sector(mp))
+		log_sect_size <<= (mp->m_sb.sb_logsectlog - BBSHIFT);
+	log->l_sectBBsize  = BTOBB(log_sect_size);
 	log->l_mp = mp;
 	if (xfs_has_sector(mp)) {
 		log->l_sectbb_log = mp->m_sb.sb_logsectlog - BBSHIFT;
@@ -50,13 +46,12 @@ xlog_init(
 int
 xlog_is_dirty(
 	struct xfs_mount	*mp,
-	struct xlog		*log,
-	libxfs_init_t		*x)
+	struct xlog		*log)
 {
 	int			error;
 	xfs_daddr_t		head_blk, tail_blk;
 
-	xlog_init(mp, log, x);
+	xlog_init(mp, log);
 
 	error = xlog_find_tail(log, &head_blk, &tail_blk);
 	if (error) {
diff --git a/logprint/logprint.c b/logprint/logprint.c
index c78aeb2f8..bcdb6b359 100644
--- a/logprint/logprint.c
+++ b/logprint/logprint.c
@@ -85,7 +85,7 @@ logstat(
 		mp->m_features |= libxfs_sb_version_to_features(&mp->m_sb);
 		mp->m_blkbb_log = sb->sb_blocklog - BBSHIFT;
 
-		xlog_init(mp, log, &x);
+		xlog_init(mp, log);
 
 		if (!x.logname && sb->sb_logstart == 0) {
 			fprintf(stderr, _("    external log device not specified\n\n"));
diff --git a/repair/phase2.c b/repair/phase2.c
index a9dd77be3..48263e161 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -30,7 +30,7 @@ zero_log(
 	xfs_daddr_t		tail_blk;
 	struct xlog		*log = mp->m_log;
 
-	xlog_init(mp, mp->m_log, &x);
+	xlog_init(mp, mp->m_log);
 
 	/*
 	 * Find the log head and tail and alert the user to the situation if the
-- 
2.39.2

