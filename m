Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 17A7B7F66
	for <xfs@oss.sgi.com>; Mon,  2 Mar 2015 07:28:12 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DA3AE8F8068
	for <xfs@oss.sgi.com>; Mon,  2 Mar 2015 05:28:11 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id zRqCCy0VqMmzDBS5 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Mar 2015 05:28:10 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t22DS97n010010
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Mon, 2 Mar 2015 08:28:10 -0500
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t22DS8BI021856
	for <xfs@oss.sgi.com>; Mon, 2 Mar 2015 08:28:09 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v6 02/18] xfs: update free inode record logic to support
	sparse inode records
Date: Mon,  2 Mar 2015 08:27:52 -0500
Message-Id: <1425302888-4962-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1425302888-4962-1-git-send-email-bfoster@redhat.com>
References: <1425302888-4962-1-git-send-email-bfoster@redhat.com>
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

xfs_difree_inobt() uses logic in a couple places that assume inobt
records refer to fully allocated chunks. Specifically, the use of
mp->m_ialloc_inos can cause problems for inode chunks that are sparsely
allocated. Sparse inode chunks can, by definition, define a smaller
number of inodes than a full inode chunk.

Fix the logic that determines whether an inode record should be removed
from the inobt to use the ir_free mask rather than ir_freecount. Fix the
agi counters modification to use ir_freecount to add the actual number
of inodes freed rather than assuming a full inode chunk.

Also make sure that we preserve the behavior to not remove inode chunks
if the block size is large enough for multiple inode chunks (e.g.,
bsize=64k, isize=512). This behavior was previously implicit in that in
such configurations, ir.freecount of a single record never matches
m_ialloc_inos. Hence, add some comments as well.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index a186831..3033099 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1508,10 +1508,13 @@ xfs_difree_inobt(
 	rec.ir_freecount++;
 
 	/*
-	 * When an inode cluster is free, it becomes eligible for removal
+	 * When an inode chunk is free, it becomes eligible for removal. Don't
+	 * remove the chunk if the block size is large enough for multiple inode
+	 * chunks (that might not be free).
 	 */
 	if (!(mp->m_flags & XFS_MOUNT_IKEEP) &&
-	    (rec.ir_freecount == mp->m_ialloc_inos)) {
+	    rec.ir_free == XFS_INOBT_ALL_FREE &&
+	    mp->m_sb.sb_inopblock <= XFS_INODES_PER_CHUNK) {
 
 		*deleted = 1;
 		*first_ino = XFS_AGINO_TO_INO(mp, agno, rec.ir_startino);
@@ -1521,7 +1524,7 @@ xfs_difree_inobt(
 		 * AGI and Superblock inode counts, and mark the disk space
 		 * to be freed when the transaction is committed.
 		 */
-		ilen = mp->m_ialloc_inos;
+		ilen = rec.ir_freecount;
 		be32_add_cpu(&agi->agi_count, -ilen);
 		be32_add_cpu(&agi->agi_freecount, -(ilen - 1));
 		xfs_ialloc_log_agi(tp, agbp, XFS_AGI_COUNT | XFS_AGI_FREECOUNT);
@@ -1641,8 +1644,13 @@ xfs_difree_finobt(
 	 * free inode. Hence, if all of the inodes are free and we aren't
 	 * keeping inode chunks permanently on disk, remove the record.
 	 * Otherwise, update the record with the new information.
+	 *
+	 * Note that we currently can't free chunks when the block size is large
+	 * enough for multiple chunks. Leave the finobt record to remain in sync
+	 * with the inobt.
 	 */
-	if (rec.ir_freecount == mp->m_ialloc_inos &&
+	if (rec.ir_free == XFS_INOBT_ALL_FREE &&
+	    mp->m_sb.sb_inopblock <= XFS_INODES_PER_CHUNK &&
 	    !(mp->m_flags & XFS_MOUNT_IKEEP)) {
 		error = xfs_btree_delete(cur, &i);
 		if (error)
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
