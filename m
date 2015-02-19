Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6F6297F51
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 12:13:50 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 504FC8F8073
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 10:13:50 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id HkyzvsNvTv2VycP2 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 19 Feb 2015 10:13:46 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t1JIDje0014606
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 13:13:45 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t1JIDjdh029965
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 13:13:45 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v5 02/18] xfs: update free inode record logic to support
	sparse inode records
Date: Thu, 19 Feb 2015 13:13:27 -0500
Message-Id: <1424369623-5656-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1424369623-5656-1-git-send-email-bfoster@redhat.com>
References: <1424369623-5656-1-git-send-email-bfoster@redhat.com>
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
from the inobt to use the ir_free mask rather than ir_freecount.

Fix the agi counters modification to use ir_freecount to add the actual
number of inodes freed rather than assuming a full inode chunk.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 12b62a34..ffac044 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1509,7 +1509,7 @@ xfs_difree_inobt(
 	 * When an inode cluster is free, it becomes eligible for removal
 	 */
 	if (!(mp->m_flags & XFS_MOUNT_IKEEP) &&
-	    (rec.ir_freecount == mp->m_ialloc_inos)) {
+	    (rec.ir_free == XFS_INOBT_ALL_FREE)) {
 
 		*deleted = 1;
 		*first_ino = XFS_AGINO_TO_INO(mp, agno, rec.ir_startino);
@@ -1519,7 +1519,7 @@ xfs_difree_inobt(
 		 * AGI and Superblock inode counts, and mark the disk space
 		 * to be freed when the transaction is committed.
 		 */
-		ilen = mp->m_ialloc_inos;
+		ilen = rec.ir_freecount;
 		be32_add_cpu(&agi->agi_count, -ilen);
 		be32_add_cpu(&agi->agi_freecount, -(ilen - 1));
 		xfs_ialloc_log_agi(tp, agbp, XFS_AGI_COUNT | XFS_AGI_FREECOUNT);
@@ -1640,7 +1640,7 @@ xfs_difree_finobt(
 	 * keeping inode chunks permanently on disk, remove the record.
 	 * Otherwise, update the record with the new information.
 	 */
-	if (rec.ir_freecount == mp->m_ialloc_inos &&
+	if (rec.ir_free == XFS_INOBT_ALL_FREE &&
 	    !(mp->m_flags & XFS_MOUNT_IKEEP)) {
 		error = xfs_btree_delete(cur, &i);
 		if (error)
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
