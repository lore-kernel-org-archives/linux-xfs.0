Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n61MF2WW044257 for <xfs@oss.sgi.com>; Wed, 1 Jul 2009 17:15:02 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8916633921D
	for <xfs@oss.sgi.com>; Wed,  1 Jul 2009 15:15:33 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 2jZDDaF32ZghLUeC for
	<xfs@oss.sgi.com>; Wed, 01 Jul 2009 15:15:33 -0700 (PDT)
Message-ID: <4A4BE005.3000102@sandeen.net>
Date: Wed, 01 Jul 2009 17:15:33 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_repair: fix verify_ag_bno() overflow
References: <4A4BC7FF.6050004@sandeen.net>
In-Reply-To: <4A4BC7FF.6050004@sandeen.net>
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

Argh self-nak on that one, stupid thinko; it always returns
1 for a non-last AG :/  Just add the cast and don't get fancy!

V2 below:

-------

The last test in verify_ag_bno() may overflow:

return (agbno >= (sbp->sb_dblocks -
		((sbp->sb_agcount - 1) * sbp->sb_agblocks)));

because sb_agcount & sb_agblocks are 32-bit integers; this
may then miss corrupt agbnos for the last ag, which can in
turn lead to out of bounds memory accesses later, for example
when the block nr is used to offset in set_agbno_state():

	addr = ba_bmap[(agno)] + (ag_blockno)/XR_BB_NUM;

Reported-by: Jesse Stroik <jstroik@ssec.wisc.edu>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/repair/dinode.c b/repair/dinode.c
index fdf52db..84e1d05 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -319,7 +319,8 @@ verify_ag_bno(xfs_sb_t *sbp,
 		return (agbno >= sbp->sb_agblocks);
 	if (agno == (sbp->sb_agcount - 1)) 
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
