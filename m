Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o39MTloE146484 for <xfs@oss.sgi.com>; Fri, 9 Apr 2010 17:29:47 -0500
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 037848F80D3
	for <xfs@oss.sgi.com>; Fri,  9 Apr 2010 15:31:40 -0700 (PDT)
Subject: [PATCH 4/10] xfs: kill XLOG_SECTOR_ROUND*()
From: Alex Elder <aelder@sgi.com>
Date: Fri, 09 Apr 2010 17:27:55 -0500
Message-ID: <1270852075.7840.142.camel@doink>
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

XLOG_SECTOR_ROUNDUP_BBCOUNT() and XLOG_SECTOR_ROUNDDOWN_BLKNO()
are now fairly simple macro translations.  Just get rid of them in
favor of the round_up() and round_down() macro calls they represent.

Also, in spots in xlog_get_bp() and xlog_write_log_records(),
round_up() was being called with value 1, which just evaluates
to the macro's second argument; so just use that instead.
In the latter case, make use of that value, as long as it's
already been computed.

Signed-off-by: Alex Elder <aelder@sgi.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>

---
fs/xfs/xfs_log_recover.c |   23 +++++++++--------------
 fs/xfs/xfs_log_recover.c |   23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

Index: b/fs/xfs/xfs_log_recover.c
===================================================================
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -56,7 +56,6 @@ STATIC void	xlog_recover_check_summary(x
 #define	xlog_recover_check_summary(log)
 #endif
 
-
 /*
  * Sector aligned buffer routines for buffer create/read/write/access
  */
@@ -64,10 +63,6 @@ STATIC void	xlog_recover_check_summary(x
 /* Number of basic blocks in a log sector */
 #define xlog_sectbb(log) (1 << (log)->l_sectbb_log)
 
-#define XLOG_SECTOR_ROUNDUP_BBCOUNT(log, bbs) round_up((bbs), xlog_sectbb(log))
-#define XLOG_SECTOR_ROUNDDOWN_BLKNO(log, bno) \
-		round_down((bno), xlog_sectbb(log))
-
 STATIC xfs_buf_t *
 xlog_get_bp(
 	xlog_t		*log,
@@ -82,8 +77,8 @@ xlog_get_bp(
 
 	if (log->l_sectbb_log) {
 		if (nbblks > 1)
-			nbblks += XLOG_SECTOR_ROUNDUP_BBCOUNT(log, 1);
-		nbblks = XLOG_SECTOR_ROUNDUP_BBCOUNT(log, nbblks);
+			nbblks += xlog_sectbb(log);
+		nbblks = round_up(nbblks, xlog_sectbb(log));
 	}
 	return xfs_buf_get_noaddr(BBTOB(nbblks), log->l_mp->m_logdev_targp);
 }
@@ -134,8 +129,8 @@ xlog_bread_noalign(
 	}
 
 	if (log->l_sectbb_log) {
-		blk_no = XLOG_SECTOR_ROUNDDOWN_BLKNO(log, blk_no);
-		nbblks = XLOG_SECTOR_ROUNDUP_BBCOUNT(log, nbblks);
+		blk_no = round_down(blk_no, xlog_sectbb(log));
+		nbblks = round_up(nbblks, xlog_sectbb(log));
 	}
 
 	ASSERT(nbblks > 0);
@@ -196,8 +191,8 @@ xlog_bwrite(
 	}
 
 	if (log->l_sectbb_log) {
-		blk_no = XLOG_SECTOR_ROUNDDOWN_BLKNO(log, blk_no);
-		nbblks = XLOG_SECTOR_ROUNDUP_BBCOUNT(log, nbblks);
+		blk_no = round_down(blk_no, xlog_sectbb(log));
+		nbblks = round_up(nbblks, xlog_sectbb(log));
 	}
 
 	ASSERT(nbblks > 0);
@@ -1158,7 +1153,7 @@ xlog_write_log_records(
 	xfs_caddr_t	offset;
 	xfs_buf_t	*bp;
 	int		balign, ealign;
-	int		sectbb = XLOG_SECTOR_ROUNDUP_BBCOUNT(log, 1);
+	int		sectbb = xlog_sectbb(log);
 	int		end_block = start_block + blocks;
 	int		bufblks;
 	int		error = 0;
@@ -1181,7 +1176,7 @@ xlog_write_log_records(
 	 * the buffer in the starting sector not covered by the first
 	 * write below.
 	 */
-	balign = XLOG_SECTOR_ROUNDDOWN_BLKNO(log, start_block);
+	balign = round_down(start_block, sectbb);
 	if (balign != start_block) {
 		error = xlog_bread_noalign(log, start_block, 1, bp);
 		if (error)
@@ -1200,7 +1195,7 @@ xlog_write_log_records(
 		 * the buffer in the final sector not covered by the write.
 		 * If this is the same sector as the above read, skip it.
 		 */
-		ealign = XLOG_SECTOR_ROUNDDOWN_BLKNO(log, end_block);
+		ealign = round_down(end_block, sectbb);
 		if (j == 0 && (start_block + endcount > ealign)) {
 			offset = XFS_BUF_PTR(bp);
 			balign = BBTOB(ealign - start_block);


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
