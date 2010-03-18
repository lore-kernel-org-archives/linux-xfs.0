Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2IMqDcr198068 for <xfs@oss.sgi.com>; Thu, 18 Mar 2010 17:52:14 -0500
Received: from stout.americas.sgi.com (stout.americas.sgi.com [128.162.232.50])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 001608F809E
	for <xfs@oss.sgi.com>; Thu, 18 Mar 2010 15:53:51 -0700 (PDT)
Received: from stout.americas.sgi.com (localhost6.localdomain6 [127.0.0.1])
	by stout.americas.sgi.com (8.14.3/8.14.2) with ESMTP id o2IMrpG7001853
	for <xfs@oss.sgi.com>; Thu, 18 Mar 2010 17:53:51 -0500
Received: (from aelder@localhost)
	by stout.americas.sgi.com (8.14.3/8.14.3/Submit) id o2IMrp54001850
	for xfs@oss.sgi.com; Thu, 18 Mar 2010 17:53:51 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201003182253.o2IMrp54001850@stout.americas.sgi.com>
Date: Thu, 18 Mar 2010 17:53:51 -0500
Subject: [PATCH 2/7] xfs: fix min bufsize bugs in two places
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This fixes a bug in two places that I found by inspection.  In
xlog_find_verify_cycle() and xlog_write_log_records(), the code
attempts to allocate a buffer to hold as many blocks as possible.
It gives up if the number of blocks to be allocated gets too small.
Right now it uses log->l_sectbb_log as that lower bound, but I'm
sure it's supposed to be the actual log sector size instead.  That
is, the lower bound should be (1 << log->l_sectbb_log).

Also define a simple macro xlog_sectbb(log) to represent the number
of basic blocks in a sector for the given log.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 fs/xfs/xfs_log_recover.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

Index: b/fs/xfs/xfs_log_recover.c
===================================================================
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -66,6 +66,9 @@ STATIC void	xlog_recover_check_summary(x
 	((bbs + (log)->l_sectbb_mask + 1) & ~(log)->l_sectbb_mask) : (bbs) )
 #define XLOG_SECTOR_ROUNDDOWN_BLKNO(log, bno)	((bno) & ~(log)->l_sectbb_mask)
 
+/* Number of basic blocks in a log sector */
+#define xlog_sectbb(log) (1 << (log)->l_sectbb_log)
+
 STATIC xfs_buf_t *
 xlog_get_bp(
 	xlog_t		*log,
@@ -376,12 +379,16 @@ xlog_find_verify_cycle(
 	xfs_caddr_t	buf = NULL;
 	int		error = 0;
 
+	/*
+	 * Greedily allocate a buffer big enough to handle the full
+	 * range of basic blocks we'll be examining.  If that fails,
+	 * try a smaller size.  We need to be able to read at least
+	 * a log sector, or we're out of luck.
+	 */
 	bufblks = 1 << ffs(nbblks);
-
 	while (!(bp = xlog_get_bp(log, bufblks))) {
-		/* can't get enough memory to do everything in one big buffer */
 		bufblks >>= 1;
-		if (bufblks <= log->l_sectbb_log)
+		if (bufblks < xlog_sectbb(log))
 			return ENOMEM;
 	}
 
@@ -1158,10 +1165,16 @@ xlog_write_log_records(
 	int		error = 0;
 	int		i, j = 0;
 
+	/*
+	 * Greedily allocate a buffer big enough to handle the full
+	 * range of basic blocks to be written.  If that fails, try
+	 * a smaller size.  We need to be able to write at least a
+	 * log sector, or we're out of luck.
+	 */
 	bufblks = 1 << ffs(blocks);
 	while (!(bp = xlog_get_bp(log, bufblks))) {
 		bufblks >>= 1;
-		if (bufblks <= log->l_sectbb_log)
+		if (bufblks < xlog_sectbb(log))
 			return ENOMEM;
 	}
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
