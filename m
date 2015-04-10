Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 88CE77FA7
	for <xfs@oss.sgi.com>; Fri, 10 Apr 2015 08:38:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 52B61304048
	for <xfs@oss.sgi.com>; Fri, 10 Apr 2015 06:38:07 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	3vlaJBNkYBo3sLFM for <xfs@oss.sgi.com>;
	Fri, 10 Apr 2015 06:38:05 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1YgZ8E-0001Pf-3X
	for xfs@oss.sgi.com; Fri, 10 Apr 2015 23:38:02 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1YgZ8E-00068c-2w
	for xfs@oss.sgi.com; Fri, 10 Apr 2015 23:38:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/5] xfs: DIO requires an ioend for writes
Date: Fri, 10 Apr 2015 23:37:56 +1000
Message-Id: <1428673080-23052-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1428673080-23052-1-git-send-email-david@fromorbit.com>
References: <1428673080-23052-1-git-send-email-david@fromorbit.com>
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

Right now unwritten extent conversion information is passed by
making the end IO private data non-null, which does not enable us to
pass any information from submission context to completion context,
which we need to use the standard IO completion paths.

Allocate an ioend in block allocation for direct IO and attach it to
the mapping buffer used during direct IO block allocation. Factor
the mapping code to make it obvious that this is happening only for
direct IO writes, and and place the mapping info and IO type
directly into the ioend for use in completion context.

The completion is changed to check the ioend type to determine if
unwritten extent completion is necessary or not.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_aops.c | 79 ++++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 61 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 3a9b7a1..d95a42b 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1233,6 +1233,57 @@ xfs_vm_releasepage(
 	return try_to_free_buffers(page);
 }
 
+static void
+xfs_get_blocks_map_buffer(
+	struct inode		*inode,
+	struct buffer_head	*bh_result,
+	int			create,
+	int			direct,
+	struct xfs_bmbt_irec	*imap,
+	xfs_off_t		offset,
+	ssize_t			size)
+{
+	struct xfs_ioend	*ioend;
+	int			type;
+
+	if (!create) {
+		/*
+		 * Unwritten extents do not report a disk address for
+		 * the read case (treat as if we're reading into a hole).
+		 */
+		if (!ISUNWRITTEN(imap))
+			xfs_map_buffer(inode, bh_result, imap, offset);
+		return;
+	}
+
+	xfs_map_buffer(inode, bh_result, imap, offset);
+
+	if (ISUNWRITTEN(imap))
+		set_buffer_unwritten(bh_result);
+
+	if (!direct)
+		return;
+
+	/*
+	 * Direct IO writes require an ioend to be allocated and
+	 * passed via the returned mapping. This allows the end
+	 * io function to determine the correct course of
+	 * action.
+	 */
+
+	if (ISUNWRITTEN(imap)) {
+		type = XFS_IO_UNWRITTEN;
+		set_buffer_defer_completion(bh_result);
+	} else
+		type = XFS_IO_OVERWRITE;
+	ioend = xfs_alloc_ioend(inode, type);
+	ioend->io_offset = offset;
+	ioend->io_size = size;
+	bh_result->b_private = ioend;
+
+	return;
+}
+
 STATIC int
 __xfs_get_blocks(
 	struct inode		*inode,
@@ -1252,6 +1303,7 @@ __xfs_get_blocks(
 	ssize_t			size;
 	int			new = 0;
 
+
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
@@ -1332,21 +1384,9 @@ __xfs_get_blocks(
 	}
 
 	if (imap.br_startblock != HOLESTARTBLOCK &&
-	    imap.br_startblock != DELAYSTARTBLOCK) {
-		/*
-		 * For unwritten extents do not report a disk address on
-		 * the read case (treat as if we're reading into a hole).
-		 */
-		if (create || !ISUNWRITTEN(&imap))
-			xfs_map_buffer(inode, bh_result, &imap, offset);
-		if (create && ISUNWRITTEN(&imap)) {
-			if (direct) {
-				bh_result->b_private = inode;
-				set_buffer_defer_completion(bh_result);
-			}
-			set_buffer_unwritten(bh_result);
-		}
-	}
+	    imap.br_startblock != DELAYSTARTBLOCK)
+		xfs_get_blocks_map_buffer(inode, bh_result, create, direct,
+					  &imap, offset, size);
 
 	/*
 	 * If this is a realtime file, data may be on a different device.
@@ -1455,9 +1495,10 @@ xfs_end_io_direct_write(
 	struct inode		*inode = file_inode(iocb->ki_filp);
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_ioend	*ioend = private;
 
 	if (XFS_FORCED_SHUTDOWN(mp))
-		return;
+		goto out_destroy_ioend;
 
 	/*
 	 * While the generic direct I/O code updates the inode size, it does
@@ -1477,7 +1518,7 @@ xfs_end_io_direct_write(
 	 * we can pass the ioend to the direct IO allocation callbacks and
 	 * avoid nesting that way.
 	 */
-	if (private && size > 0) {
+	if (ioend->io_type == XFS_IO_UNWRITTEN && size > 0) {
 		xfs_iomap_write_unwritten(ip, offset, size);
 	} else if (offset + size > ip->i_d.di_size) {
 		struct xfs_trans	*tp;
@@ -1487,11 +1528,13 @@ xfs_end_io_direct_write(
 		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_fsyncts, 0, 0);
 		if (error) {
 			xfs_trans_cancel(tp, 0);
-			return;
+			goto out_destroy_ioend;
 		}
 
 		xfs_setfilesize(ip, tp, offset, size);
 	}
+out_destroy_ioend:
+	xfs_destroy_ioend(ioend);
 }
 
 STATIC ssize_t
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
