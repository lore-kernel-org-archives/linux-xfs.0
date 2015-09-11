Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1D4A07F5E
	for <xfs@oss.sgi.com>; Fri, 11 Sep 2015 13:55:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F18888F8040
	for <xfs@oss.sgi.com>; Fri, 11 Sep 2015 11:55:46 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id CLaRqGnL9eEMEhBk (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 11 Sep 2015 11:55:45 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id BF489C0A1615
	for <xfs@oss.sgi.com>; Fri, 11 Sep 2015 18:55:44 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-37.bos.redhat.com [10.18.41.37])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t8BItiso020246
	for <xfs@oss.sgi.com>; Fri, 11 Sep 2015 14:55:44 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 06/12] libxlog: pull struct xlog out of xlog_is_dirty()
Date: Fri, 11 Sep 2015 14:55:36 -0400
Message-Id: <1441997742-37160-7-git-send-email-bfoster@redhat.com>
In-Reply-To: <1441997742-37160-1-git-send-email-bfoster@redhat.com>
References: <1441997742-37160-1-git-send-email-bfoster@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

The xlog_is_dirty() helper is called in various places to acquire the
current log head, tail and to determine whether the log is dirty. Some
callers will require additional information to deal with formatting the
log, such as the current LSN. xlog_is_dirty() already acquires this
information through existing sub-helpers, but it is not available to
callers as the xlog structure is allocated on the local stack.

Update xlog_is_dirty() to receive the xlog structure as a parameter and
pass it along such that additional information about the log is
available to callers. Update the existing callers to allocate the xlog
structure on the stack.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 db/metadump.c     |  5 +++--
 db/sb.c           |  3 ++-
 include/libxlog.h |  3 ++-
 libxlog/util.c    | 37 +++++++++++++++++++------------------
 4 files changed, 26 insertions(+), 22 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index af96e12..129670e 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2512,7 +2512,8 @@ copy_sb_inodes(void)
 static int
 copy_log(void)
 {
-	int dirty;
+	struct xlog	log;
+	int		dirty;
 
 	if (show_progress)
 		print_progress("Copying log");
@@ -2530,7 +2531,7 @@ copy_log(void)
 	if (!obfuscate && !zero_stale_data)
 		goto done;
 
-	dirty = xlog_is_dirty(mp, &x, 0);
+	dirty = xlog_is_dirty(mp, &log, &x, 0);
 
 	switch (dirty) {
 	case 0:
diff --git a/db/sb.c b/db/sb.c
index 560e653..9c585ca 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -229,6 +229,7 @@ int xlog_recover_do_trans(struct xlog *log, xlog_recover_t *t, int p)
 int
 sb_logcheck(void)
 {
+	struct xlog	log;
 	int		dirty;
 
 	if (mp->m_sb.sb_logstart) {
@@ -247,7 +248,7 @@ sb_logcheck(void)
 
 	libxfs_buftarg_init(mp, x.ddev, x.logdev, x.rtdev);
 
-	dirty = xlog_is_dirty(mp, &x, 0);
+	dirty = xlog_is_dirty(mp, &log, &x, 0);
 	if (dirty == -1) {
 		dbprintf(_("ERROR: cannot find log head/tail, run xfs_repair\n"));
 		return 0;
diff --git a/include/libxlog.h b/include/libxlog.h
index 05b16e8..6c6e83a 100644
--- a/include/libxlog.h
+++ b/include/libxlog.h
@@ -84,7 +84,8 @@ extern int	print_record_header;
 extern libxfs_init_t	x;
 
 
-extern int xlog_is_dirty(xfs_mount_t *mp, libxfs_init_t *x, int verbose);
+extern int xlog_is_dirty(struct xfs_mount *, struct xlog *, libxfs_init_t *,
+			 int);
 extern struct xfs_buf *xlog_get_bp(struct xlog *, int);
 extern void	xlog_put_bp(struct xfs_buf *);
 extern int	xlog_bread(struct xlog *log, xfs_daddr_t blk_no, int nbblks,
diff --git a/libxlog/util.c b/libxlog/util.c
index c6b8f2a..72b8b18 100644
--- a/libxlog/util.c
+++ b/libxlog/util.c
@@ -29,15 +29,15 @@ libxfs_init_t x;
  */
 int
 xlog_is_dirty(
-	xfs_mount_t *mp,
-	libxfs_init_t *x,
-	int verbose)
+	struct xfs_mount	*mp,
+	struct xlog		*log,
+	libxfs_init_t		*x,
+	int			verbose)
 {
-	int error;
-	struct xlog	log;
-	xfs_daddr_t head_blk, tail_blk;
+	int			error;
+	xfs_daddr_t		head_blk, tail_blk;
 
-	memset(&log, 0, sizeof(log));
+	memset(log, 0, sizeof(*log));
 
 	/* We (re-)init members of libxfs_init_t here?  really? */
 	x->logBBsize = XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
@@ -46,23 +46,24 @@ xlog_is_dirty(
 	if (xfs_sb_version_hassector(&mp->m_sb))
 		x->lbsize <<= (mp->m_sb.sb_logsectlog - BBSHIFT);
 
-	log.l_dev = mp->m_logdev_targp;
-	log.l_logBBsize = x->logBBsize;
-	log.l_logBBstart = x->logBBstart;
-	log.l_sectBBsize = BTOBB(x->lbsize);
-	log.l_mp = mp;
+	log->l_dev = mp->m_logdev_targp;
+	log->l_logBBsize = x->logBBsize;
+	log->l_logBBstart = x->logBBstart;
+	log->l_sectBBsize = BTOBB(x->lbsize);
+	log->l_mp = mp;
 	if (xfs_sb_version_hassector(&mp->m_sb)) {
-		log.l_sectbb_log = mp->m_sb.sb_logsectlog - BBSHIFT;
-		ASSERT(log.l_sectbb_log <= mp->m_sectbb_log);
+		log->l_sectbb_log = mp->m_sb.sb_logsectlog - BBSHIFT;
+		ASSERT(log->l_sectbb_log <= mp->m_sectbb_log);
 		/* for larger sector sizes, must have v2 or external log */
-		ASSERT(log.l_sectbb_log == 0 ||
-			log.l_logBBstart == 0 ||
+		ASSERT(log->l_sectbb_log == 0 ||
+			log->l_logBBstart == 0 ||
 			xfs_sb_version_haslogv2(&mp->m_sb));
 		ASSERT(mp->m_sb.sb_logsectlog >= BBSHIFT);
 	}
-	log.l_sectbb_mask = (1 << log.l_sectbb_log) - 1;
+	log->l_sectbb_mask = (1 << log->l_sectbb_log) - 1;
 
-	if ((error = xlog_find_tail(&log, &head_blk, &tail_blk))) {
+	error = xlog_find_tail(log, &head_blk, &tail_blk);
+	if (error) {
 		xlog_warn(_("%s: cannot find log head/tail "
 			  "(xlog_find_tail=%d)\n"),
 			__func__, error);
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
