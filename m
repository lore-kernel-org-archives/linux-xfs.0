Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DFDE07F6F
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 13:42:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BFD8E8F808F
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 11:42:06 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id IGdUtj7jalqHz9sh (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Jun 2015 11:42:05 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id 5D20F134BB
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 18:42:05 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t52Ig4Dk010507
	for <xfs@oss.sgi.com>; Tue, 2 Jun 2015 14:42:05 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 24/28] repair: reconstruct sparse inode records correctly on
	disk
Date: Tue,  2 Jun 2015 14:41:57 -0400
Message-Id: <1433270521-62026-25-git-send-email-bfoster@redhat.com>
In-Reply-To: <1433270521-62026-1-git-send-email-bfoster@redhat.com>
References: <1433270521-62026-1-git-send-email-bfoster@redhat.com>
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

Phase 5 traverses all of the in-core inode records and regenerates the
inode btrees a record at a time. The record insertion code doesn't
account for sparse inodes which means the ir_holemask and ir_count
fields are not set on-disk and ir_freecount is set with an invalid value
for sparse inode records.

Update build_ino_tree() to handle sparse inode records correctly. We
must account real, allocated inodes only into the ir_freecount field.
The 64-bit in-core sparse inode bitmask must be converted to compressed
16-bit ir_holemask format. Finally, the ir_count field must set to the
total (non-sparse) inode count of the record.

If the fs does not support sparse inodes, both the ir_holemask and
ir_count field are initialized to zero to preserve backwards
compatibility. These bytes historically landed in the high order bytes
of ir_freecount and must be 0 to be interpreted correctly by older XFS
implementations without sparse inode support.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 repair/phase5.c | 47 +++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 39 insertions(+), 8 deletions(-)

diff --git a/repair/phase5.c b/repair/phase5.c
index 30f2d05..0601810 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -1158,8 +1158,12 @@ build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 	xfs_agino_t		count = 0;
 	xfs_agino_t		freecount = 0;
 	int			inocnt;
+	uint8_t			finocnt;
 	int			k;
 	int			level = btree_curs->num_levels;
+	int			spmask;
+	uint64_t		sparse;
+	uint16_t		holemask;
 
 	for (i = 0; i < level; i++)  {
 		lptr = &btree_curs->level[i];
@@ -1243,19 +1247,46 @@ build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 					cpu_to_be32(ino_rec->ino_startnum);
 			bt_rec[j].ir_free = cpu_to_be64(ino_rec->ir_free);
 
-			inocnt = 0;
+			inocnt = finocnt = 0;
 			for (k = 0; k < sizeof(xfs_inofree_t)*NBBY; k++)  {
 				ASSERT(is_inode_confirmed(ino_rec, k));
-				inocnt += is_inode_free(ino_rec, k);
+
+				if (is_inode_sparse(ino_rec, k))
+					continue;
+				if (is_inode_free(ino_rec, k))
+					finocnt++;
+				inocnt++;
 			}
 
-			if (xfs_sb_version_hassparseinodes(&mp->m_sb))
-				bt_rec[j].ir_u.sp.ir_freecount = inocnt;
-			else
+			if (!xfs_sb_version_hassparseinodes(&mp->m_sb)) {
 				bt_rec[j].ir_u.f.ir_freecount =
-							cpu_to_be32(inocnt);
-			freecount += inocnt;
-			count += XFS_INODES_PER_CHUNK;
+							cpu_to_be32(finocnt);
+				goto nextrec;
+			}
+
+			/*
+			 * Convert the 64-bit in-core sparse inode state to the
+			 * 16-bit on-disk holemask.
+			 */
+			holemask = 0;
+			spmask = (1 << XFS_INODES_PER_HOLEMASK_BIT) - 1;
+			sparse = ino_rec->ir_sparse;
+			for (k = 0; k < XFS_INOBT_HOLEMASK_BITS; k++) {
+				if (sparse & spmask) {
+					ASSERT((sparse & spmask) == spmask);
+					holemask |= (1 << k);
+				} else
+					ASSERT((sparse & spmask) == 0);
+				sparse >>= XFS_INODES_PER_HOLEMASK_BIT;
+			}
+
+			bt_rec[j].ir_u.sp.ir_freecount = finocnt;
+			bt_rec[j].ir_u.sp.ir_count = inocnt;
+			bt_rec[j].ir_u.sp.ir_holemask = cpu_to_be16(holemask);
+
+nextrec:
+			freecount += finocnt;
+			count += inocnt;
 
 			if (finobt)
 				ino_rec = next_free_ino_rec(ino_rec);
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
