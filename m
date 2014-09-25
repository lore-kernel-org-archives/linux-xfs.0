Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 784617FA5
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 07:34:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5DC648F8039
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 05:34:48 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	yaIA8dymPJsXQSQo for <xfs@oss.sgi.com>;
	Thu, 25 Sep 2014 05:34:47 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XX8Fc-0006nL-0F
	for xfs@oss.sgi.com; Thu, 25 Sep 2014 22:34:24 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XX8Fb-0007h8-VQ
	for xfs@oss.sgi.com; Thu, 25 Sep 2014 22:34:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 11/11] xfs: simplify xfs_zero_remaining_bytes
Date: Thu, 25 Sep 2014 22:34:21 +1000
Message-Id: <1411648461-29003-12-git-send-email-david@fromorbit.com>
In-Reply-To: <1411648461-29003-1-git-send-email-david@fromorbit.com>
References: <1411648461-29003-1-git-send-email-david@fromorbit.com>
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

From: Christoph Hellwig <hch@infradead.org>

xfs_zero_remaining_bytes() open codes a log of buffer manupulations
to do a read forllowed by a write. It can simply be replaced by an
uncached read followed by a xfs_bwrite() call.

[Christoph, can I get your sign-off for this?]

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_bmap_util.c | 44 ++++++++++++++------------------------------
 1 file changed, 14 insertions(+), 30 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 41d9488..c2aaa58 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1122,14 +1122,6 @@ xfs_zero_remaining_bytes(
 	if (endoff > XFS_ISIZE(ip))
 		endoff = XFS_ISIZE(ip);
 
-	bp = xfs_buf_get_uncached(XFS_IS_REALTIME_INODE(ip) ?
-					mp->m_rtdev_targp : mp->m_ddev_targp,
-				  BTOBB(mp->m_sb.sb_blocksize), 0);
-	if (!bp)
-		return -ENOMEM;
-
-	xfs_buf_unlock(bp);
-
 	for (offset = startoff; offset <= endoff; offset = lastoffset + 1) {
 		uint lock_mode;
 
@@ -1152,32 +1144,24 @@ xfs_zero_remaining_bytes(
 		ASSERT(imap.br_startblock != DELAYSTARTBLOCK);
 		if (imap.br_state == XFS_EXT_UNWRITTEN)
 			continue;
-		XFS_BUF_UNDONE(bp);
-		XFS_BUF_UNWRITE(bp);
-		XFS_BUF_READ(bp);
-		XFS_BUF_SET_ADDR(bp, xfs_fsb_to_db(ip, imap.br_startblock));
 
-		error = xfs_buf_submit_wait(bp);
-		if (error) {
-			xfs_buf_ioerror_alert(bp,
-					"xfs_zero_remaining_bytes(read)");
-			break;
-		}
+		error = xfs_buf_read_uncached(XFS_IS_REALTIME_INODE(ip) ?
+				mp->m_rtdev_targp : mp->m_ddev_targp,
+				xfs_fsb_to_db(ip, imap.br_startblock),
+				BTOBB(mp->m_sb.sb_blocksize),
+				0, &bp, NULL);
+		if (error)
+			return error;
+
 		memset(bp->b_addr +
-			(offset - XFS_FSB_TO_B(mp, imap.br_startoff)),
-		      0, lastoffset - offset + 1);
-		XFS_BUF_UNDONE(bp);
-		XFS_BUF_UNREAD(bp);
-		XFS_BUF_WRITE(bp);
+				(offset - XFS_FSB_TO_B(mp, imap.br_startoff)),
+		       0, lastoffset - offset + 1);
 
-		error = xfs_buf_submit_wait(bp);
-		if (error) {
-			xfs_buf_ioerror_alert(bp,
-					"xfs_zero_remaining_bytes(write)");
-			break;
-		}
+		error = xfs_bwrite(bp);
+		xfs_buf_relse(bp);
+		if (error)
+			return error;
 	}
-	xfs_buf_free(bp);
 	return error;
 }
 
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
