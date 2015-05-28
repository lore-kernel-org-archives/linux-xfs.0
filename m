Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EF80E7F56
	for <xfs@oss.sgi.com>; Thu, 28 May 2015 15:17:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8ECACAC002
	for <xfs@oss.sgi.com>; Thu, 28 May 2015 13:16:59 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id H18otiGtvUqkUqrE (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 28 May 2015 13:16:58 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id 5D61A36507E
	for <xfs@oss.sgi.com>; Thu, 28 May 2015 20:16:58 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t4SKGvYS013625
	for <xfs@oss.sgi.com>; Thu, 28 May 2015 16:16:58 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 1/3] xfs: create helper to delete multiple inobt records
Date: Thu, 28 May 2015 16:16:54 -0400
Message-Id: <1432844216-5820-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1432844216-5820-1-git-send-email-bfoster@redhat.com>
References: <1432844216-5820-1-git-send-email-bfoster@redhat.com>
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

In most cases an inode chunk is tracked by a single inode record. With
large block size support up to 64k, however, XFS supports conditions
where a single block might be large enough to allocate an inode chunk
that requires multiple inobt records. For example, an inode record is
fixed at 64 inodes. With a 64k block size, a 512b inode size results in
128-inode chunks and thus requires 2 inobt records per-chunk.

This is handled appropriately at inode allocation time via insertion of
multiple inobt records to span the chunk. We currently have no mechanism
to delete multiple records nor broader chunk context for a particular
record at inode deletion time. Therefore, inode chunks on such
filesystems are never freed and result in non-recoverable space
consumption for the lifetime of the filesystem.

Create the xfs_inobt_delete() helper to remove several inobt records at
a time. Call the helper from the appropriate locations instead of
xfs_btree_delete(). Note that we still do not have the requisite chunk
context at inode deletion time to delete multiple records and therefore
can still only delete records that map to full chunks.

This patch does not alter current behavior but provides a mechanism to
be used by future work that provides the appropriate chunk context.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 56 +++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 53 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index c6d684e..745d965 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -199,6 +199,53 @@ xfs_inobt_insert(
 }
 
 /*
+ * Delete a series of records from the inode btree. Handle multiple records as
+ * an inode chunk might consist of more than one record for large block sizes.
+ */
+static int
+xfs_inobt_delete(
+	struct xfs_mount		*mp,
+	struct xfs_btree_cur		*cur,
+	xfs_agnumber_t			agno,
+	xfs_agino_t			agino,
+	int				ilen)
+{
+	struct xfs_inobt_rec_incore	rec;
+	int				error;
+	int				i;
+
+	ASSERT(ilen % XFS_INODES_PER_CHUNK == 0);
+
+	while (ilen > 0) {
+		error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_EQ, &i);
+		if (error)
+			goto out_error;
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
+
+		/* make sure the record is what we expect */
+		error = xfs_inobt_get_rec(cur, &rec, &i);
+		if (error)
+			goto out_error;
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
+		XFS_WANT_CORRUPTED_GOTO(mp, rec.ir_startino == agino,
+					out_error);
+
+		error = xfs_btree_delete(cur, &i);
+		if (error)
+			goto out_error;
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
+
+		agino += XFS_INODES_PER_CHUNK;
+		ilen -= XFS_INODES_PER_CHUNK;
+	}
+
+	return 0;
+
+out_error:
+	return error;
+}
+
+/*
  * Verify that the number of free inodes in the AGI is correct.
  */
 #ifdef DEBUG
@@ -1965,8 +2012,10 @@ xfs_difree_inobt(
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_ICOUNT, -ilen);
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, -(ilen - 1));
 
-		if ((error = xfs_btree_delete(cur, &i))) {
-			xfs_warn(mp, "%s: xfs_btree_delete returned error %d.",
+		error = xfs_inobt_delete(mp, cur, agno, rec.ir_startino,
+					 XFS_INODES_PER_CHUNK);
+		if (error) {
+			xfs_warn(mp, "%s: xfs_inobt_delete returned error %d.",
 				__func__, error);
 			goto error0;
 		}
@@ -2083,7 +2132,8 @@ xfs_difree_finobt(
 	if (rec.ir_free == XFS_INOBT_ALL_FREE &&
 	    mp->m_sb.sb_inopblock <= XFS_INODES_PER_CHUNK &&
 	    !(mp->m_flags & XFS_MOUNT_IKEEP)) {
-		error = xfs_btree_delete(cur, &i);
+		error = xfs_inobt_delete(mp, cur, agno, rec.ir_startino,
+					 XFS_INODES_PER_CHUNK);
 		if (error)
 			goto error;
 		ASSERT(i == 1);
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
