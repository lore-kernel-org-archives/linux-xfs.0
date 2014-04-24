Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DFE5B7F67
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2014 00:02:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 73A80AC007
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 22:02:53 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	5zlLcsWeIcT1CT9a for <xfs@oss.sgi.com>;
	Wed, 23 Apr 2014 22:02:51 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WdBnQ-0006xz-SU
	for xfs@oss.sgi.com; Thu, 24 Apr 2014 15:02:04 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WdBnQ-0005gW-Rk
	for xfs@oss.sgi.com; Thu, 24 Apr 2014 15:02:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 8/9] repair: handle remote symlink CRC errors
Date: Thu, 24 Apr 2014 15:02:01 +1000
Message-Id: <1398315722-20870-9-git-send-email-david@fromorbit.com>
In-Reply-To: <1398315722-20870-1-git-send-email-david@fromorbit.com>
References: <1398315722-20870-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

We can't really repair broken symlink buffer contents, but we can at
least warn about it and correct the CRC error so the symlink is
again readable.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 repair/dinode.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/repair/dinode.c b/repair/dinode.c
index b086bec..6360dba 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -1254,6 +1254,7 @@ process_symlink_remote(
 	while (pathlen > 0) {
 		int	blk_cnt = 1;
 		int	byte_cnt;
+		int	dirty = 0;
 
 		fsbno = blkmap_get(blkmap, i);
 		if (fsbno == NULLDFSBNO) {
@@ -1284,6 +1285,12 @@ _("cannot read inode %" PRIu64 ", file block %d, disk block %" PRIu64 "\n"),
 				lino, i, fsbno);
 			return 1;
 		}
+		if (bp->b_error == EFSBADCRC) {
+			do_warn(
+_("Bad symlink buffer CRC, block %" PRIu64 ", inode %" PRIu64 ".\n"
+  "Correcting CRC, but symlink may be bad.\n"), fsbno, lino);
+			dirty = 1;
+		}
 
 		byte_cnt = XFS_SYMLINK_BUF_SPACE(mp, byte_cnt);
 		byte_cnt = MIN(pathlen, byte_cnt);
@@ -1307,7 +1314,10 @@ _("bad symlink header ino %" PRIu64 ", file block %d, disk block %" PRIu64 "\n")
 		offset += byte_cnt;
 		i++;
 
-		libxfs_putbuf(bp);
+		if (dirty)
+			libxfs_writebuf(bp, 0);
+		else
+			libxfs_putbuf(bp);
 	}
 	return 0;
 }
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
