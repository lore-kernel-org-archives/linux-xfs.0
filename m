Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 80F427F58
	for <xfs@oss.sgi.com>; Mon,  8 Jun 2015 06:29:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 624EE304043
	for <xfs@oss.sgi.com>; Mon,  8 Jun 2015 04:29:27 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 02VumIjaraPkA7XW (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 08 Jun 2015 04:29:26 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id B656BA10A6
	for <xfs@oss.sgi.com>; Mon,  8 Jun 2015 11:29:25 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t58BTPoB021621
	for <xfs@oss.sgi.com>; Mon, 8 Jun 2015 07:29:25 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 1/4] repair: access helpers for on-disk inobt record freecount
Date: Mon,  8 Jun 2015 07:29:21 -0400
Message-Id: <1433762964-11502-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1433762964-11502-1-git-send-email-bfoster@redhat.com>
References: <1433762964-11502-1-git-send-email-bfoster@redhat.com>
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

The on-disk inobt record has two formats depending on whether sparse
inode support is enabled or not. If so, the freecount field is a single
byte and does not require byte-conversion. Otherwise, it is a 4-byte
field and does.

Create the inorec_[get|set]_freecount() helpers to abstract this detail
away from the core repair code.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 repair/incore.h | 28 ++++++++++++++++++++++++++++
 repair/phase5.c | 12 +++++++-----
 repair/scan.c   | 15 +++------------
 3 files changed, 38 insertions(+), 17 deletions(-)

diff --git a/repair/incore.h b/repair/incore.h
index 5a63e1e..c92475e 100644
--- a/repair/incore.h
+++ b/repair/incore.h
@@ -591,4 +591,32 @@ typedef struct bm_cursor  {
 
 void init_bm_cursor(bmap_cursor_t *cursor, int num_level);
 
+/*
+ * On-disk inobt record helpers. The sparse inode record format has a single
+ * byte freecount. The older format has a 32-bit freecount and thus byte
+ * conversion is necessary.
+ */
+
+static inline int
+inorec_get_freecount(
+	struct xfs_mount	*mp,
+	struct xfs_inobt_rec	*rp)
+{
+	if (xfs_sb_version_hassparseinodes(&mp->m_sb))
+		return rp->ir_u.sp.ir_freecount;
+	return be32_to_cpu(rp->ir_u.f.ir_freecount);
+}
+
+static inline void
+inorec_set_freecount(
+	struct xfs_mount	*mp,
+	struct xfs_inobt_rec	*rp,
+	int			freecount)
+{
+	if (xfs_sb_version_hassparseinodes(&mp->m_sb))
+		rp->ir_u.sp.ir_freecount = freecount;
+	else
+		rp->ir_u.f.ir_freecount = cpu_to_be32(freecount);
+}
+
 #endif /* XFS_REPAIR_INCORE_H */
diff --git a/repair/phase5.c b/repair/phase5.c
index 0601810..7372734 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -1258,11 +1258,14 @@ build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 				inocnt++;
 			}
 
-			if (!xfs_sb_version_hassparseinodes(&mp->m_sb)) {
-				bt_rec[j].ir_u.f.ir_freecount =
-							cpu_to_be32(finocnt);
+			/*
+			 * Set the freecount and check whether we need to update
+			 * the sparse format fields. Otherwise, skip to the next
+			 * record.
+			 */
+			inorec_set_freecount(mp, &bt_rec[j], finocnt);
+			if (!xfs_sb_version_hassparseinodes(&mp->m_sb))
 				goto nextrec;
-			}
 
 			/*
 			 * Convert the 64-bit in-core sparse inode state to the
@@ -1280,7 +1283,6 @@ build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 				sparse >>= XFS_INODES_PER_HOLEMASK_BIT;
 			}
 
-			bt_rec[j].ir_u.sp.ir_freecount = finocnt;
 			bt_rec[j].ir_u.sp.ir_count = inocnt;
 			bt_rec[j].ir_u.sp.ir_holemask = cpu_to_be16(holemask);
 
diff --git a/repair/scan.c b/repair/scan.c
index e3895c2..1a6f0c5 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -786,10 +786,7 @@ scan_single_ino_chunk(
 	off = XFS_AGINO_TO_OFFSET(mp, ino);
 	agbno = XFS_AGINO_TO_AGBNO(mp, ino);
 	lino = XFS_AGINO_TO_INO(mp, agno, ino);
-	if (xfs_sb_version_hassparseinodes(&mp->m_sb))
-		freecount = rp->ir_u.sp.ir_freecount;
-	else
-		freecount = be32_to_cpu(rp->ir_u.f.ir_freecount);
+	freecount = inorec_get_freecount(mp, rp);
 
 	/*
 	 * on multi-block block chunks, all chunks start
@@ -987,10 +984,7 @@ scan_single_finobt_chunk(
 	off = XFS_AGINO_TO_OFFSET(mp, ino);
 	agbno = XFS_AGINO_TO_AGBNO(mp, ino);
 	lino = XFS_AGINO_TO_INO(mp, agno, ino);
-	if (xfs_sb_version_hassparseinodes(&mp->m_sb))
-		freecount = rp->ir_u.sp.ir_freecount;
-	else
-		freecount = be32_to_cpu(rp->ir_u.f.ir_freecount);
+	freecount = inorec_get_freecount(mp, rp);
 
 	/*
 	 * on multi-block block chunks, all chunks start at the beginning of the
@@ -1331,10 +1325,7 @@ _("inode btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 		 * the block.  skip processing of bogus records.
 		 */
 		for (i = 0; i < numrecs; i++) {
-			if (xfs_sb_version_hassparseinodes(&mp->m_sb))
-				freecount = rp[i].ir_u.sp.ir_freecount;
-			else
-				freecount = be32_to_cpu(rp[i].ir_u.f.ir_freecount);
+			freecount = inorec_get_freecount(mp, &rp[i]);
 
 			if (magic == XFS_IBT_MAGIC ||
 			    magic == XFS_IBT_CRC_MAGIC) {
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
