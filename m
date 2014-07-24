Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 17B787F50
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 09:23:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 061E48F804C
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 07:23:13 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id PhSobJuCK1gr6HDU (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 24 Jul 2014 07:23:12 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s6OENA7r016646
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 10:23:11 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s6OENAAW029068
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 10:23:10 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 14/18] xfs: update free inode record logic to support sparse
	inode records
Date: Thu, 24 Jul 2014 10:23:04 -0400
Message-Id: <1406211788-63206-15-git-send-email-bfoster@redhat.com>
In-Reply-To: <1406211788-63206-1-git-send-email-bfoster@redhat.com>
References: <1406211788-63206-1-git-send-email-bfoster@redhat.com>
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
index 1d74394..f75f191 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1724,7 +1724,7 @@ xfs_difree_inobt(
 	 * When an inode cluster is free, it becomes eligible for removal
 	 */
 	if (!(mp->m_flags & XFS_MOUNT_IKEEP) &&
-	    (rec.ir_freecount == mp->m_ialloc_inos)) {
+	    (rec.ir_free == XFS_INOBT_ALL_FREE)) {
 
 		*deleted = 1;
 		*first_ino = XFS_AGINO_TO_INO(mp, agno, rec.ir_startino);
@@ -1734,7 +1734,7 @@ xfs_difree_inobt(
 		 * AGI and Superblock inode counts, and mark the disk space
 		 * to be freed when the transaction is committed.
 		 */
-		ilen = mp->m_ialloc_inos;
+		ilen = rec.ir_freecount;
 		be32_add_cpu(&agi->agi_count, -ilen);
 		be32_add_cpu(&agi->agi_freecount, -(ilen - 1));
 		xfs_ialloc_log_agi(tp, agbp, XFS_AGI_COUNT | XFS_AGI_FREECOUNT);
@@ -1856,7 +1856,7 @@ xfs_difree_finobt(
 	 * keeping inode chunks permanently on disk, remove the record.
 	 * Otherwise, update the record with the new information.
 	 */
-	if (rec.ir_freecount == mp->m_ialloc_inos &&
+	if (rec.ir_free == XFS_INOBT_ALL_FREE &&
 	    !(mp->m_flags & XFS_MOUNT_IKEEP)) {
 		error = xfs_btree_delete(cur, &i);
 		if (error)
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
