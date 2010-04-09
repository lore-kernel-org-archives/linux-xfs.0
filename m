Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o39MTlFD146481 for <xfs@oss.sgi.com>; Fri, 9 Apr 2010 17:29:47 -0500
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E7AE98F80D1
	for <xfs@oss.sgi.com>; Fri,  9 Apr 2010 15:31:39 -0700 (PDT)
Subject: [PATCH 2/10] xfs: fix min bufsize bugs in two places
From: Alex Elder <aelder@sgi.com>
Date: Fri, 09 Apr 2010 17:26:53 -0500
Message-ID: <1270852013.7840.132.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

(No change from original submission; I have implemented Christoph's
suggestion about storing l_sectsize rather than l_sectbb_log in
a new, separate patch in this series.)

Signed-off-by: Alex Elder <aelder@sgi.com>

---
fs/xfs/xfs_log_recover.c |   21 +++++++++++++++++----
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
