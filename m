Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2U2mXR3003824 for <xfs@oss.sgi.com>; Tue, 29 Mar 2011 21:48:34 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0CE84112F086
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2011 19:51:42 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	iqVSAw4fzI75T3aC for <xfs@oss.sgi.com>;
	Tue, 29 Mar 2011 19:51:42 -0700 (PDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1Q4lVP-0005KK-Iq
	for xfs@oss.sgi.com; Wed, 30 Mar 2011 13:51:35 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1Q4lVq-0001T5-8o
	for xfs@oss.sgi.com; Wed, 30 Mar 2011 13:52:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: fix extent format buffer allocation size
Date: Wed, 30 Mar 2011 13:52:01 +1100
Message-Id: <1301453521-5614-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

When formatting an inode item, we have to allocate a separate buffer
to hold extents when there are delayed allocation extents on the
inode and it is in extent format. The allocation size is derived
from the in-core data fork representation, which accounts for
delayed allocation extents, while the on-disk representation does
not contain any delalloc extents.

As a result of this mismatch, the allocated buffer can be far larger
than needed to hold the real extent list which, due to the fact the
inode is in extent format, is limited to the size of the literal
area of the inode. However, we can have thousands of delalloc
extents, resulting in an allocation size orders of magnitude larger
than is needed to hold all the real extents.

Fix this by limiting the size of the buffer being allocated to the
size of the literal area of the inodes in the filesystem (i.e. the
maximum size an inode fork can grow to).

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode_item.c |   69 ++++++++++++++++++++++++++++------------------
 1 files changed, 42 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 46cc401..12cdc39 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -198,6 +198,43 @@ xfs_inode_item_size(
 }
 
 /*
+ * xfs_inode_item_format_extents - convert in-core extents to on-disk form
+ *
+ * For either the data or attr fork in extent format, we need to endian convert
+ * the in-core extent as we place them into the on-disk inode. In this case, we
+ * ned to do this conversion before we write the extents into the log. Because
+ * we don't have the disk inode to write into here, we allocate a buffer and
+ * format the extents into it via xfs_iextents_copy(). We free the buffer in
+ * the unlock routine after the copy for the log has been made.
+ *
+ * For the data fork, there can be delayed allocation extents
+ * in the inode as well, so the in-core data fork can be much larger than the
+ * on-disk data representation of real inodes. Hence we need to limit the size
+ * of the allocation to what will fit in the inode fork, otherwise we could be
+ * asking for excessively large allocation sizes.
+ */
+STATIC void
+xfs_inode_item_format_extents(
+	struct xfs_inode	*ip,
+	struct xfs_log_iovec	*vecp,
+	int			whichfork,
+	int			type)
+{
+	xfs_bmbt_rec_t		*ext_buffer;
+
+	ext_buffer = kmem_alloc(XFS_IFORK_SIZE(ip, whichfork),
+							KM_SLEEP | KM_NOFS);
+	if (whichfork == XFS_DATA_FORK)
+		ip->i_itemp->ili_extents_buf = ext_buffer;
+	else
+		ip->i_itemp->ili_aextents_buf = ext_buffer;
+
+	vecp->i_addr = ext_buffer;
+	vecp->i_len = xfs_iextents_copy(ip, ext_buffer, whichfork);
+	vecp->i_type = type;
+}
+
+/*
  * This is called to fill in the vector of log iovecs for the
  * given inode log item.  It fills the first item with an inode
  * log format structure, the second with the on-disk inode structure,
@@ -213,7 +250,6 @@ xfs_inode_item_format(
 	struct xfs_inode	*ip = iip->ili_inode;
 	uint			nvecs;
 	size_t			data_bytes;
-	xfs_bmbt_rec_t		*ext_buffer;
 	xfs_mount_t		*mp;
 
 	vecp->i_addr = &iip->ili_format;
@@ -320,22 +356,8 @@ xfs_inode_item_format(
 			} else
 #endif
 			{
-				/*
-				 * There are delayed allocation extents
-				 * in the inode, or we need to convert
-				 * the extents to on disk format.
-				 * Use xfs_iextents_copy()
-				 * to copy only the real extents into
-				 * a separate buffer.  We'll free the
-				 * buffer in the unlock routine.
-				 */
-				ext_buffer = kmem_alloc(ip->i_df.if_bytes,
-					KM_SLEEP);
-				iip->ili_extents_buf = ext_buffer;
-				vecp->i_addr = ext_buffer;
-				vecp->i_len = xfs_iextents_copy(ip, ext_buffer,
-						XFS_DATA_FORK);
-				vecp->i_type = XLOG_REG_TYPE_IEXT;
+				xfs_inode_item_format_extents(ip, vecp,
+					XFS_DATA_FORK, XLOG_REG_TYPE_IEXT);
 			}
 			ASSERT(vecp->i_len <= ip->i_df.if_bytes);
 			iip->ili_format.ilf_dsize = vecp->i_len;
@@ -445,19 +467,12 @@ xfs_inode_item_format(
 			 */
 			vecp->i_addr = ip->i_afp->if_u1.if_extents;
 			vecp->i_len = ip->i_afp->if_bytes;
+			vecp->i_type = XLOG_REG_TYPE_IATTR_EXT;
 #else
 			ASSERT(iip->ili_aextents_buf == NULL);
-			/*
-			 * Need to endian flip before logging
-			 */
-			ext_buffer = kmem_alloc(ip->i_afp->if_bytes,
-				KM_SLEEP);
-			iip->ili_aextents_buf = ext_buffer;
-			vecp->i_addr = ext_buffer;
-			vecp->i_len = xfs_iextents_copy(ip, ext_buffer,
-					XFS_ATTR_FORK);
+			xfs_inode_item_format_extents(ip, vecp,
+					XFS_ATTR_FORK, XLOG_REG_TYPE_IATTR_EXT);
 #endif
-			vecp->i_type = XLOG_REG_TYPE_IATTR_EXT;
 			iip->ili_format.ilf_asize = vecp->i_len;
 			vecp++;
 			nvecs++;
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
