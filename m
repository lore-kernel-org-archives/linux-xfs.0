Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5E8187F6F
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 01:25:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0C1C7AC011
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 23:25:43 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	ckMGlzz1M2e3hgqV for <xfs@oss.sgi.com>;
	Thu, 18 Jul 2013 23:25:42 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V0482-00048R-VQ
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:25:23 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V0482-0001yO-UH
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:25:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 22/49] xfs: minor cleanups
Date: Fri, 19 Jul 2013 16:24:53 +1000
Message-Id: <1374215120-7271-23-git-send-email-david@fromorbit.com>
In-Reply-To: <1374215120-7271-1-git-send-email-david@fromorbit.com>
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
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

These come from syncing the shared userspace and kernel code. Small
whitespace and trivial cleanups.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_attr_leaf.c   | 2 --
 fs/xfs/xfs_attr_remote.c | 8 +-------
 fs/xfs/xfs_bmap_btree.c  | 4 +---
 fs/xfs/xfs_inode_fork.c  | 4 ++--
 4 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
index fe0ade9..4dba2f9 100644
--- a/fs/xfs/xfs_attr_leaf.c
+++ b/fs/xfs/xfs_attr_leaf.c
@@ -936,7 +936,6 @@ out:
 	return error;
 }
 
-
 /*========================================================================
  * Routines used for growing the Btree.
  *========================================================================*/
@@ -1297,7 +1296,6 @@ xfs_attr3_leaf_compact(
 	ichdr_dst->freemap[0].size = ichdr_dst->firstused -
 						ichdr_dst->freemap[0].base;
 
-
 	/* write the header back to initialise the underlying buffer */
 	xfs_attr3_leaf_hdr_to_disk(leaf_dst, ichdr_dst);
 
diff --git a/fs/xfs/xfs_attr_remote.c b/fs/xfs/xfs_attr_remote.c
index 13a0ed9..b42926a 100644
--- a/fs/xfs/xfs_attr_remote.c
+++ b/fs/xfs/xfs_attr_remote.c
@@ -251,7 +251,7 @@ xfs_attr_rmtval_copyout(
 		int hdr_size = 0;
 		int byte_cnt = XFS_ATTR3_RMT_BUF_SPACE(mp, XFS_LBSIZE(mp));
 
-		byte_cnt = min_t(int, *valuelen, byte_cnt);
+		byte_cnt = min(*valuelen, byte_cnt);
 
 		if (xfs_sb_version_hascrc(&mp->m_sb)) {
 			if (!xfs_attr3_rmt_hdr_ok(mp, src, ino, *offset,
@@ -545,11 +545,6 @@ xfs_attr_rmtval_remove(
 
 	/*
 	 * Roll through the "value", invalidating the attribute value's blocks.
-	 * Note that args->rmtblkcnt is the minimum number of data blocks we'll
-	 * see for a CRC enabled remote attribute. Each extent will have a
-	 * header, and so we may have more blocks than we realise here.  If we
-	 * fail to map the blocks correctly, we'll have problems with the buffer
-	 * lookups.
 	 */
 	lblkno = args->rmtblkno;
 	blkcnt = args->rmtblkcnt;
@@ -630,4 +625,3 @@ xfs_attr_rmtval_remove(
 	}
 	return(0);
 }
-
diff --git a/fs/xfs/xfs_bmap_btree.c b/fs/xfs/xfs_bmap_btree.c
index bcee383..cf3bc76 100644
--- a/fs/xfs/xfs_bmap_btree.c
+++ b/fs/xfs/xfs_bmap_btree.c
@@ -722,7 +722,7 @@ xfs_bmbt_key_diff(
 				      cur->bc_rec.b.br_startoff;
 }
 
-static int
+static bool
 xfs_bmbt_verify(
 	struct xfs_buf		*bp)
 {
@@ -775,7 +775,6 @@ xfs_bmbt_verify(
 		return false;
 
 	return true;
-
 }
 
 static void
@@ -789,7 +788,6 @@ xfs_bmbt_read_verify(
 				     bp->b_target->bt_mount, bp->b_addr);
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
 	}
-
 }
 
 static void
diff --git a/fs/xfs/xfs_inode_fork.c b/fs/xfs/xfs_inode_fork.c
index 8b8ba02..f06570b 100644
--- a/fs/xfs/xfs_inode_fork.c
+++ b/fs/xfs/xfs_inode_fork.c
@@ -780,8 +780,8 @@ xfs_iextents_copy(
 		}
 
 		/* Translate to on disk format */
-		put_unaligned(cpu_to_be64(ep->l0), &dp->l0);
-		put_unaligned(cpu_to_be64(ep->l1), &dp->l1);
+		put_unaligned_be64(ep->l0, &dp->l0);
+		put_unaligned_be64(ep->l1, &dp->l1);
 		dp++;
 		copied++;
 	}
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
