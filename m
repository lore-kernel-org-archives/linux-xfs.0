Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n61KWWuB033108 for <xfs@oss.sgi.com>; Wed, 1 Jul 2009 15:32:33 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E04A51499037
	for <xfs@oss.sgi.com>; Wed,  1 Jul 2009 13:39:26 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id SRuW2cBUhfo8Uefn for
	<xfs@oss.sgi.com>; Wed, 01 Jul 2009 13:39:26 -0700 (PDT)
Message-ID: <4A4BC7FF.6050004@sandeen.net>
Date: Wed, 01 Jul 2009 15:33:03 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfs_repair: fix verify_ag_bno() overflow
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
To: xfs-oss <xfs@oss.sgi.com>, Jesse Stroik <jstroik@ssec.wisc.edu>

The last test in verify_ag_bno() may overflow:

return (agbno >= (sbp->sb_dblocks -
		((sbp->sb_agcount - 1) * sbp->sb_agblocks)));

because sb_agcount & sb_agblocks are 32-bit integers; this
may then miss corrupt agbnos for the last ag, which can in
turn lead to out of bounds memory accesses later, for example
when the block nr is used to offset in set_agbno_state():

	addr = ba_bmap[(agno)] + (ag_blockno)/XR_BB_NUM;

Also make the first test simpler; agbno > sb_agblocks
is -always- bad, regardless of the agno.  This may even
speed it up a tiny bit.

Reported-by: Jesse Stroik <jstroik@ssec.wisc.edu>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/repair/dinode.c b/repair/dinode.c
index fdf52db..f50f1ad 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -315,11 +315,14 @@ verify_ag_bno(xfs_sb_t *sbp,
 		xfs_agnumber_t agno,
 		xfs_agblock_t agbno)
 {
-	if (agno < (sbp->sb_agcount - 1)) 
-		return (agbno >= sbp->sb_agblocks);
-	if (agno == (sbp->sb_agcount - 1)) 
+	/* in all cases bno >= agblocks is bad */
+	if (agbno >= sbp->sb_agblocks)
+		return 1;
+	/* last ag may be smaller */
+	if (agno == (sbp->sb_agcount - 1))
 		return (agbno >= (sbp->sb_dblocks -
-				((sbp->sb_agcount - 1) * sbp->sb_agblocks)));
+				((xfs_drfsbno_t)(sbp->sb_agcount - 1) *
+				 sbp->sb_agblocks)));
 	return 1;
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
