Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8IKfiBX200886 for <xfs@oss.sgi.com>; Sun, 18 Sep 2011 15:41:45 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 62AAF16A92EB
	for <xfs@oss.sgi.com>; Sun, 18 Sep 2011 13:46:51 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	a3sA1PF4XQL5kyXA for <xfs@oss.sgi.com>;
	Sun, 18 Sep 2011 13:46:51 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1R5OBK-0004eZ-SH
	for xfs@oss.sgi.com; Sun, 18 Sep 2011 20:41:42 +0000
Message-Id: <20110918204142.826688407@bombadil.infradead.org>
Date: Sun, 18 Sep 2011 16:40:42 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 02/27] xfs: remove impossible to read code in
	xfs_bmap_add_extent_delay_real
References: <20110918204040.266805129@bombadil.infradead.org>
Content-Disposition: inline;
	filename=xfs-cleanup-xfs_bmap_add_extent_delay_real-eh
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

We already have the worst case blocks reserved, so xfs_icsb_modify_counters
won't fail in xfs_bmap_add_extent_delay_real.  In fact we've had an assert
to catch this case since day and it never triggered.  So remove the code
to try smaller reservations, and just return the error for that case in
addition to keeping the assert.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alex Elder <aelder@sgi.com>

Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2011-07-15 11:29:03.408815322 -0700
+++ xfs/fs/xfs/xfs_bmap.c	2011-07-15 11:29:16.985408438 -0700
@@ -1045,34 +1045,15 @@ xfs_bmap_add_extent_delay_real(
 		temp2 = xfs_bmap_worst_indlen(ip, temp2);
 		diff = (int)(temp + temp2 - startblockval(PREV.br_startblock) -
 			(cur ? cur->bc_private.b.allocated : 0));
-		if (diff > 0 &&
-		    xfs_icsb_modify_counters(ip->i_mount, XFS_SBS_FDBLOCKS,
-					     -((int64_t)diff), 0)) {
-			/*
-			 * Ick gross gag me with a spoon.
-			 */
-			ASSERT(0);	/* want to see if this ever happens! */
-			while (diff > 0) {
-				if (temp) {
-					temp--;
-					diff--;
-					if (!diff ||
-					    !xfs_icsb_modify_counters(ip->i_mount,
-						    XFS_SBS_FDBLOCKS,
-						    -((int64_t)diff), 0))
-						break;
-				}
-				if (temp2) {
-					temp2--;
-					diff--;
-					if (!diff ||
-					    !xfs_icsb_modify_counters(ip->i_mount,
-						    XFS_SBS_FDBLOCKS,
-						    -((int64_t)diff), 0))
-						break;
-				}
-			}
+		if (diff > 0) {
+			error = xfs_icsb_modify_counters(ip->i_mount,
+					XFS_SBS_FDBLOCKS,
+					-((int64_t)diff), 0);
+			ASSERT(!error);
+			if (error)
+				goto done;
 		}
+
 		ep = xfs_iext_get_ext(ifp, *idx);
 		xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
 		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
