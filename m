Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EEB8B7CA2
	for <xfs@oss.sgi.com>; Sat, 13 Feb 2016 06:09:54 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 725D6AC004
	for <xfs@oss.sgi.com>; Sat, 13 Feb 2016 04:09:51 -0800 (PST)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id KCrVjQveWWNr6GhE (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 13 Feb 2016 04:09:44 -0800 (PST)
Received: from 178.115.128.223.wireless.dyn.drei.com ([178.115.128.223]
	helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.85 #2 (Red Hat Linux))
	id 1aUZ1C-0008EZ-VX
	for xfs@oss.sgi.com; Sat, 13 Feb 2016 12:09:43 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] xfs: remove xfs_trans_get_block_res
Date: Sat, 13 Feb 2016 13:09:41 +0100
Message-Id: <1455365381-12592-1-git-send-email-hch@lst.de>
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

Just use the t_blk_res field directly instead of obsfucating the reference
by a macro.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c       | 6 +++---
 fs/xfs/libxfs/xfs_bmap_btree.c | 4 ++--
 fs/xfs/xfs_trans.h             | 1 -
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 3e89e0e..a0fa2f5 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5707,7 +5707,7 @@ xfs_bunmapi(
 			 * This is better than zeroing it.
 			 */
 			ASSERT(del.br_state == XFS_EXT_NORM);
-			ASSERT(xfs_trans_get_block_res(tp) > 0);
+			ASSERT(tp->t_blk_res > 0);
 			/*
 			 * If this spans a realtime extent boundary,
 			 * chop it back to the start of the one we end at.
@@ -5738,7 +5738,7 @@ xfs_bunmapi(
 				del.br_startblock += mod;
 			} else if ((del.br_startoff == start &&
 				    (del.br_state == XFS_EXT_UNWRITTEN ||
-				     xfs_trans_get_block_res(tp) == 0)) ||
+				     tp->t_blk_res == 0)) ||
 				   !xfs_sb_version_hasextflgbit(&mp->m_sb)) {
 				/*
 				 * Can't make it unwritten.  There isn't
@@ -5829,7 +5829,7 @@ xfs_bunmapi(
 		 * conversion to btree format, since the transaction
 		 * will be dirty.
 		 */
-		if (!wasdel && xfs_trans_get_block_res(tp) == 0 &&
+		if (!wasdel && tp->t_blk_res == 0 &&
 		    XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_EXTENTS &&
 		    XFS_IFORK_NEXTENTS(ip, whichfork) >= /* Note the >= */
 			XFS_IFORK_MAXEXT(ip, whichfork) &&
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 77a8c63..5dcbfae 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -464,7 +464,7 @@ try_another_ag:
 		 * reservation amount is insufficient then we may fail a
 		 * block allocation here and corrupt the filesystem.
 		 */
-		args.minleft = xfs_trans_get_block_res(args.tp);
+		args.minleft = args.tp->t_blk_res;
 	} else if (cur->bc_private.b.flist->xbf_low) {
 		args.type = XFS_ALLOCTYPE_START_BNO;
 	} else {
@@ -473,7 +473,7 @@ try_another_ag:
 
 	args.minlen = args.maxlen = args.prod = 1;
 	args.wasdel = cur->bc_private.b.flags & XFS_BTCUR_BPRV_WASDEL;
-	if (!args.wasdel && xfs_trans_get_block_res(args.tp) == 0) {
+	if (!args.wasdel && args.tp->t_blk_res == 0) {
 		error = -ENOSPC;
 		goto error0;
 	}
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 50fe77e..d49dfef 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -133,7 +133,6 @@ typedef struct xfs_trans {
  * XFS transaction mechanism exported interfaces that are
  * actually macros.
  */
-#define	xfs_trans_get_block_res(tp)	((tp)->t_blk_res)
 #define	xfs_trans_set_sync(tp)		((tp)->t_flags |= XFS_TRANS_SYNC)
 
 #if defined(DEBUG) || defined(XFS_WARN)
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
