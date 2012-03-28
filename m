Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2SHLE86146526 for <xfs@oss.sgi.com>; Wed, 28 Mar 2012 12:21:14 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id upePhivT0bEzl42B for <xfs@oss.sgi.com>;
	Wed, 28 Mar 2012 10:21:13 -0700 (PDT)
Message-ID: <4F734887.7000508@sandeen.net>
Date: Wed, 28 Mar 2012 12:21:11 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 2/1] xfs: use XFS_BMAP_BMDR_SPACE vs. XFS_BROOT_SIZE_ADJ
References: <4F7225BA.40200@redhat.com>
In-Reply-To: <4F7225BA.40200@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

XFS_BROOT_SIZE_ADJ is an undocumented macro which accounts for
the difference in size between the on-disk and in-core btree
root.  It's much clearer to just use the newly-added 
XFS_BMAP_BMDR_SPACE macro which gives us the on-disk size
directly.

In one case, we must test that the if_broot exists before
applying the macro, however.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_dinode.h b/fs/xfs/xfs_dinode.h
index a372163..be76047 100644
--- a/fs/xfs/xfs_dinode.h
+++ b/fs/xfs/xfs_dinode.h
@@ -107,9 +107,6 @@ typedef enum xfs_dinode_fmt {
 #define XFS_LITINO(mp) \
 	((int)(((mp)->m_sb.sb_inodesize) - sizeof(struct xfs_dinode)))
 
-#define	XFS_BROOT_SIZE_ADJ	\
-	(XFS_BTREE_LBLOCK_LEN - sizeof(xfs_bmdr_block_t))
-
 /*
  * Inode data & attribute fork sizes, per inode.
  */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index b210224..a1a6337 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1833,8 +1833,8 @@ xfs_iroot_realloc(
 		np = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
 						     (int)new_size);
 		ifp->if_broot_bytes = (int)new_size;
-		ASSERT(ifp->if_broot_bytes <=
-			XFS_IFORK_SIZE(ip, whichfork) + XFS_BROOT_SIZE_ADJ);
+		ASSERT(XFS_BMAP_BMDR_SPACE(ifp->if_broot) <=
+			XFS_IFORK_SIZE(ip, whichfork));
 		memmove(np, op, cur_max * (uint)sizeof(xfs_dfsbno_t));
 		return;
 	}
@@ -1886,8 +1886,9 @@ xfs_iroot_realloc(
 	kmem_free(ifp->if_broot);
 	ifp->if_broot = new_broot;
 	ifp->if_broot_bytes = (int)new_size;
-	ASSERT(ifp->if_broot_bytes <=
-		XFS_IFORK_SIZE(ip, whichfork) + XFS_BROOT_SIZE_ADJ);
+	if (ifp->if_broot)
+		ASSERT(XFS_BMAP_BMDR_SPACE(ifp->if_broot) <=
+			XFS_IFORK_SIZE(ip, whichfork));
 	return;
 }
 
@@ -2201,9 +2202,8 @@ xfs_iflush_fork(
 		if ((iip->ili_format.ilf_fields & brootflag[whichfork]) &&
 		    (ifp->if_broot_bytes > 0)) {
 			ASSERT(ifp->if_broot != NULL);
-			ASSERT(ifp->if_broot_bytes <=
-			       (XFS_IFORK_SIZE(ip, whichfork) +
-				XFS_BROOT_SIZE_ADJ));
+			ASSERT(XFS_BMAP_BMDR_SPACE(ifp->if_broot) <=
+			        XFS_IFORK_SIZE(ip, whichfork));
 			xfs_bmbt_to_bmdr(mp, ifp->if_broot, ifp->if_broot_bytes,
 				(xfs_bmdr_block_t *)cp,
 				XFS_DFORK_SIZE(dip, mp, whichfork));

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
