Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 670B07FA8
	for <xfs@oss.sgi.com>; Mon, 14 Oct 2013 17:18:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 56C1E8F8054
	for <xfs@oss.sgi.com>; Mon, 14 Oct 2013 15:18:36 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	vQdy0Ea1q0uGf7Cp for <xfs@oss.sgi.com>;
	Mon, 14 Oct 2013 15:18:16 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VVqSm-0004wm-7N
	for xfs@oss.sgi.com; Tue, 15 Oct 2013 09:18:08 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VVqSm-0005iu-6P
	for xfs@oss.sgi.com; Tue, 15 Oct 2013 09:18:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 06/19] xfs: split dquot buffer operations out
Date: Tue, 15 Oct 2013 09:17:52 +1100
Message-Id: <1381789085-21923-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1381789085-21923-1-git-send-email-david@fromorbit.com>
References: <1381789085-21923-1-git-send-email-david@fromorbit.com>
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

Parts of userspace want to be able to read and modify dquot buffers
(e.g. xfs_db) so we need to split out the reading and writing of
these buffers so it is easy to shared code with libxfs in userspace.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/Makefile          |   1 +
 fs/xfs/xfs_dquot.c       | 117 +------------------
 fs/xfs/xfs_dquot_buf.c   | 288 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_log_recover.c | 133 +---------------------
 fs/xfs/xfs_qm.c          |  22 +---
 fs/xfs/xfs_qm.h          |   2 -
 fs/xfs/xfs_quota.h       |   2 -
 fs/xfs/xfs_quota_defs.h  |   4 +
 8 files changed, 303 insertions(+), 266 deletions(-)
 create mode 100644 fs/xfs/xfs_dquot_buf.c

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 0719e4d..08f11bb 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -72,6 +72,7 @@ xfs-y				+= xfs_alloc.o \
 				   xfs_dir2_leaf.o \
 				   xfs_dir2_node.o \
 				   xfs_dir2_sf.o \
+				   xfs_dquot_buf.o \
 				   xfs_ialloc.o \
 				   xfs_ialloc_btree.o \
 				   xfs_icreate_item.o \
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 8b1d2c0..f85a893 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -293,118 +293,6 @@ xfs_dquot_set_prealloc_limits(struct xfs_dquot *dqp)
 	dqp->q_low_space[XFS_QLOWSP_5_PCNT] = space * 5;
 }
 
-STATIC bool
-xfs_dquot_buf_verify_crc(
-	struct xfs_mount	*mp,
-	struct xfs_buf		*bp)
-{
-	struct xfs_dqblk	*d = (struct xfs_dqblk *)bp->b_addr;
-	int			ndquots;
-	int			i;
-
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
-		return true;
-
-	/*
-	 * if we are in log recovery, the quota subsystem has not been
-	 * initialised so we have no quotainfo structure. In that case, we need
-	 * to manually calculate the number of dquots in the buffer.
-	 */
-	if (mp->m_quotainfo)
-		ndquots = mp->m_quotainfo->qi_dqperchunk;
-	else
-		ndquots = xfs_qm_calc_dquots_per_chunk(mp,
-					XFS_BB_TO_FSB(mp, bp->b_length));
-
-	for (i = 0; i < ndquots; i++, d++) {
-		if (!xfs_verify_cksum((char *)d, sizeof(struct xfs_dqblk),
-				 XFS_DQUOT_CRC_OFF))
-			return false;
-		if (!uuid_equal(&d->dd_uuid, &mp->m_sb.sb_uuid))
-			return false;
-	}
-	return true;
-}
-
-STATIC bool
-xfs_dquot_buf_verify(
-	struct xfs_mount	*mp,
-	struct xfs_buf		*bp)
-{
-	struct xfs_dqblk	*d = (struct xfs_dqblk *)bp->b_addr;
-	xfs_dqid_t		id = 0;
-	int			ndquots;
-	int			i;
-
-	/*
-	 * if we are in log recovery, the quota subsystem has not been
-	 * initialised so we have no quotainfo structure. In that case, we need
-	 * to manually calculate the number of dquots in the buffer.
-	 */
-	if (mp->m_quotainfo)
-		ndquots = mp->m_quotainfo->qi_dqperchunk;
-	else
-		ndquots = xfs_qm_calc_dquots_per_chunk(mp, bp->b_length);
-
-	/*
-	 * On the first read of the buffer, verify that each dquot is valid.
-	 * We don't know what the id of the dquot is supposed to be, just that
-	 * they should be increasing monotonically within the buffer. If the
-	 * first id is corrupt, then it will fail on the second dquot in the
-	 * buffer so corruptions could point to the wrong dquot in this case.
-	 */
-	for (i = 0; i < ndquots; i++) {
-		struct xfs_disk_dquot	*ddq;
-		int			error;
-
-		ddq = &d[i].dd_diskdq;
-
-		if (i == 0)
-			id = be32_to_cpu(ddq->d_id);
-
-		error = xfs_qm_dqcheck(mp, ddq, id + i, 0, XFS_QMOPT_DOWARN,
-				       "xfs_dquot_buf_verify");
-		if (error)
-			return false;
-	}
-	return true;
-}
-
-static void
-xfs_dquot_buf_read_verify(
-	struct xfs_buf	*bp)
-{
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
-
-	if (!xfs_dquot_buf_verify_crc(mp, bp) || !xfs_dquot_buf_verify(mp, bp)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
-		xfs_buf_ioerror(bp, EFSCORRUPTED);
-	}
-}
-
-/*
- * we don't calculate the CRC here as that is done when the dquot is flushed to
- * the buffer after the update is done. This ensures that the dquot in the
- * buffer always has an up-to-date CRC value.
- */
-void
-xfs_dquot_buf_write_verify(
-	struct xfs_buf	*bp)
-{
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
-
-	if (!xfs_dquot_buf_verify(mp, bp)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
-		xfs_buf_ioerror(bp, EFSCORRUPTED);
-		return;
-	}
-}
-
-const struct xfs_buf_ops xfs_dquot_buf_ops = {
-	.verify_read = xfs_dquot_buf_read_verify,
-	.verify_write = xfs_dquot_buf_write_verify,
-};
-
 /*
  * Allocate a block and fill it with dquots.
  * This is called when the bmapi finds a hole.
@@ -515,6 +403,7 @@ xfs_qm_dqalloc(
 
 	return (error);
 }
+
 STATIC int
 xfs_qm_dqrepair(
 	struct xfs_mount	*mp,
@@ -548,7 +437,7 @@ xfs_qm_dqrepair(
 	/* Do the actual repair of dquots in this buffer */
 	for (i = 0; i < mp->m_quotainfo->qi_dqperchunk; i++) {
 		ddq = &d[i].dd_diskdq;
-		error = xfs_qm_dqcheck(mp, ddq, firstid + i,
+		error = xfs_dqcheck(mp, ddq, firstid + i,
 				       dqp->dq_flags & XFS_DQ_ALLTYPES,
 				       XFS_QMOPT_DQREPAIR, "xfs_qm_dqrepair");
 		if (error) {
@@ -1134,7 +1023,7 @@ xfs_qm_dqflush(
 	/*
 	 * A simple sanity check in case we got a corrupted dquot..
 	 */
-	error = xfs_qm_dqcheck(mp, &dqp->q_core, be32_to_cpu(ddqp->d_id), 0,
+	error = xfs_dqcheck(mp, &dqp->q_core, be32_to_cpu(ddqp->d_id), 0,
 			   XFS_QMOPT_DOWARN, "dqflush (incore copy)");
 	if (error) {
 		xfs_buf_relse(bp);
diff --git a/fs/xfs/xfs_dquot_buf.c b/fs/xfs/xfs_dquot_buf.c
new file mode 100644
index 0000000..ad2c18f
--- /dev/null
+++ b/fs/xfs/xfs_dquot_buf.c
@@ -0,0 +1,288 @@
+/*
+ * Copyright (c) 2000-2006 Silicon Graphics, Inc.
+ * Copyright (c) 2013 Red Hat, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_format.h"
+#include "xfs_bit.h"
+#include "xfs_log.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_ag.h"
+#include "xfs_mount.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_inode.h"
+#include "xfs_quota.h"
+#include "xfs_qm.h"
+#include "xfs_error.h"
+#include "xfs_cksum.h"
+#include "xfs_trace.h"
+
+int
+xfs_calc_dquots_per_chunk(
+	struct xfs_mount	*mp,
+	unsigned int		nbblks)	/* basic block units */
+{
+	unsigned int	ndquots;
+
+	ASSERT(nbblks > 0);
+	ndquots = BBTOB(nbblks);
+	do_div(ndquots, sizeof(xfs_dqblk_t));
+
+	return ndquots;
+}
+
+/*
+ * Do some primitive error checking on ondisk dquot data structures.
+ */
+int
+xfs_dqcheck(
+	struct xfs_mount *mp,
+	xfs_disk_dquot_t *ddq,
+	xfs_dqid_t	 id,
+	uint		 type,	  /* used only when IO_dorepair is true */
+	uint		 flags,
+	char		 *str)
+{
+	xfs_dqblk_t	 *d = (xfs_dqblk_t *)ddq;
+	int		errs = 0;
+
+	/*
+	 * We can encounter an uninitialized dquot buffer for 2 reasons:
+	 * 1. If we crash while deleting the quotainode(s), and those blks got
+	 *    used for user data. This is because we take the path of regular
+	 *    file deletion; however, the size field of quotainodes is never
+	 *    updated, so all the tricks that we play in itruncate_finish
+	 *    don't quite matter.
+	 *
+	 * 2. We don't play the quota buffers when there's a quotaoff logitem.
+	 *    But the allocation will be replayed so we'll end up with an
+	 *    uninitialized quota block.
+	 *
+	 * This is all fine; things are still consistent, and we haven't lost
+	 * any quota information. Just don't complain about bad dquot blks.
+	 */
+	if (ddq->d_magic != cpu_to_be16(XFS_DQUOT_MAGIC)) {
+		if (flags & XFS_QMOPT_DOWARN)
+			xfs_alert(mp,
+			"%s : XFS dquot ID 0x%x, magic 0x%x != 0x%x",
+			str, id, be16_to_cpu(ddq->d_magic), XFS_DQUOT_MAGIC);
+		errs++;
+	}
+	if (ddq->d_version != XFS_DQUOT_VERSION) {
+		if (flags & XFS_QMOPT_DOWARN)
+			xfs_alert(mp,
+			"%s : XFS dquot ID 0x%x, version 0x%x != 0x%x",
+			str, id, ddq->d_version, XFS_DQUOT_VERSION);
+		errs++;
+	}
+
+	if (ddq->d_flags != XFS_DQ_USER &&
+	    ddq->d_flags != XFS_DQ_PROJ &&
+	    ddq->d_flags != XFS_DQ_GROUP) {
+		if (flags & XFS_QMOPT_DOWARN)
+			xfs_alert(mp,
+			"%s : XFS dquot ID 0x%x, unknown flags 0x%x",
+			str, id, ddq->d_flags);
+		errs++;
+	}
+
+	if (id != -1 && id != be32_to_cpu(ddq->d_id)) {
+		if (flags & XFS_QMOPT_DOWARN)
+			xfs_alert(mp,
+			"%s : ondisk-dquot 0x%p, ID mismatch: "
+			"0x%x expected, found id 0x%x",
+			str, ddq, id, be32_to_cpu(ddq->d_id));
+		errs++;
+	}
+
+	if (!errs && ddq->d_id) {
+		if (ddq->d_blk_softlimit &&
+		    be64_to_cpu(ddq->d_bcount) >
+				be64_to_cpu(ddq->d_blk_softlimit)) {
+			if (!ddq->d_btimer) {
+				if (flags & XFS_QMOPT_DOWARN)
+					xfs_alert(mp,
+			"%s : Dquot ID 0x%x (0x%p) BLK TIMER NOT STARTED",
+					str, (int)be32_to_cpu(ddq->d_id), ddq);
+				errs++;
+			}
+		}
+		if (ddq->d_ino_softlimit &&
+		    be64_to_cpu(ddq->d_icount) >
+				be64_to_cpu(ddq->d_ino_softlimit)) {
+			if (!ddq->d_itimer) {
+				if (flags & XFS_QMOPT_DOWARN)
+					xfs_alert(mp,
+			"%s : Dquot ID 0x%x (0x%p) INODE TIMER NOT STARTED",
+					str, (int)be32_to_cpu(ddq->d_id), ddq);
+				errs++;
+			}
+		}
+		if (ddq->d_rtb_softlimit &&
+		    be64_to_cpu(ddq->d_rtbcount) >
+				be64_to_cpu(ddq->d_rtb_softlimit)) {
+			if (!ddq->d_rtbtimer) {
+				if (flags & XFS_QMOPT_DOWARN)
+					xfs_alert(mp,
+			"%s : Dquot ID 0x%x (0x%p) RTBLK TIMER NOT STARTED",
+					str, (int)be32_to_cpu(ddq->d_id), ddq);
+				errs++;
+			}
+		}
+	}
+
+	if (!errs || !(flags & XFS_QMOPT_DQREPAIR))
+		return errs;
+
+	if (flags & XFS_QMOPT_DOWARN)
+		xfs_notice(mp, "Re-initializing dquot ID 0x%x", id);
+
+	/*
+	 * Typically, a repair is only requested by quotacheck.
+	 */
+	ASSERT(id != -1);
+	ASSERT(flags & XFS_QMOPT_DQREPAIR);
+	memset(d, 0, sizeof(xfs_dqblk_t));
+
+	d->dd_diskdq.d_magic = cpu_to_be16(XFS_DQUOT_MAGIC);
+	d->dd_diskdq.d_version = XFS_DQUOT_VERSION;
+	d->dd_diskdq.d_flags = type;
+	d->dd_diskdq.d_id = cpu_to_be32(id);
+
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		uuid_copy(&d->dd_uuid, &mp->m_sb.sb_uuid);
+		xfs_update_cksum((char *)d, sizeof(struct xfs_dqblk),
+				 XFS_DQUOT_CRC_OFF);
+	}
+
+	return errs;
+}
+
+STATIC bool
+xfs_dquot_buf_verify_crc(
+	struct xfs_mount	*mp,
+	struct xfs_buf		*bp)
+{
+	struct xfs_dqblk	*d = (struct xfs_dqblk *)bp->b_addr;
+	int			ndquots;
+	int			i;
+
+	if (!xfs_sb_version_hascrc(&mp->m_sb))
+		return true;
+
+	/*
+	 * if we are in log recovery, the quota subsystem has not been
+	 * initialised so we have no quotainfo structure. In that case, we need
+	 * to manually calculate the number of dquots in the buffer.
+	 */
+	if (mp->m_quotainfo)
+		ndquots = mp->m_quotainfo->qi_dqperchunk;
+	else
+		ndquots = xfs_calc_dquots_per_chunk(mp,
+					XFS_BB_TO_FSB(mp, bp->b_length));
+
+	for (i = 0; i < ndquots; i++, d++) {
+		if (!xfs_verify_cksum((char *)d, sizeof(struct xfs_dqblk),
+				 XFS_DQUOT_CRC_OFF))
+			return false;
+		if (!uuid_equal(&d->dd_uuid, &mp->m_sb.sb_uuid))
+			return false;
+	}
+	return true;
+}
+
+STATIC bool
+xfs_dquot_buf_verify(
+	struct xfs_mount	*mp,
+	struct xfs_buf		*bp)
+{
+	struct xfs_dqblk	*d = (struct xfs_dqblk *)bp->b_addr;
+	xfs_dqid_t		id = 0;
+	int			ndquots;
+	int			i;
+
+	/*
+	 * if we are in log recovery, the quota subsystem has not been
+	 * initialised so we have no quotainfo structure. In that case, we need
+	 * to manually calculate the number of dquots in the buffer.
+	 */
+	if (mp->m_quotainfo)
+		ndquots = mp->m_quotainfo->qi_dqperchunk;
+	else
+		ndquots = xfs_calc_dquots_per_chunk(mp, bp->b_length);
+
+	/*
+	 * On the first read of the buffer, verify that each dquot is valid.
+	 * We don't know what the id of the dquot is supposed to be, just that
+	 * they should be increasing monotonically within the buffer. If the
+	 * first id is corrupt, then it will fail on the second dquot in the
+	 * buffer so corruptions could point to the wrong dquot in this case.
+	 */
+	for (i = 0; i < ndquots; i++) {
+		struct xfs_disk_dquot	*ddq;
+		int			error;
+
+		ddq = &d[i].dd_diskdq;
+
+		if (i == 0)
+			id = be32_to_cpu(ddq->d_id);
+
+		error = xfs_dqcheck(mp, ddq, id + i, 0, XFS_QMOPT_DOWARN,
+				       "xfs_dquot_buf_verify");
+		if (error)
+			return false;
+	}
+	return true;
+}
+
+static void
+xfs_dquot_buf_read_verify(
+	struct xfs_buf	*bp)
+{
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+
+	if (!xfs_dquot_buf_verify_crc(mp, bp) || !xfs_dquot_buf_verify(mp, bp)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
+		xfs_buf_ioerror(bp, EFSCORRUPTED);
+	}
+}
+
+/*
+ * we don't calculate the CRC here as that is done when the dquot is flushed to
+ * the buffer after the update is done. This ensures that the dquot in the
+ * buffer always has an up-to-date CRC value.
+ */
+void
+xfs_dquot_buf_write_verify(
+	struct xfs_buf	*bp)
+{
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+
+	if (!xfs_dquot_buf_verify(mp, bp)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
+		xfs_buf_ioerror(bp, EFSCORRUPTED);
+		return;
+	}
+}
+
+const struct xfs_buf_ops xfs_dquot_buf_ops = {
+	.verify_read = xfs_dquot_buf_read_verify,
+	.verify_write = xfs_dquot_buf_write_verify,
+};
+
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 8bd89a9..1a4321f 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2363,7 +2363,7 @@ xlog_recover_do_reg_buffer(
 					item->ri_buf[i].i_len, __func__);
 				goto next;
 			}
-			error = xfs_qm_dqcheck(mp, item->ri_buf[i].i_addr,
+			error = xfs_dqcheck(mp, item->ri_buf[i].i_addr,
 					       -1, 0, XFS_QMOPT_DOWARN,
 					       "dquot_buf_recover");
 			if (error)
@@ -2395,133 +2395,6 @@ xlog_recover_do_reg_buffer(
 }
 
 /*
- * Do some primitive error checking on ondisk dquot data structures.
- */
-int
-xfs_qm_dqcheck(
-	struct xfs_mount *mp,
-	xfs_disk_dquot_t *ddq,
-	xfs_dqid_t	 id,
-	uint		 type,	  /* used only when IO_dorepair is true */
-	uint		 flags,
-	char		 *str)
-{
-	xfs_dqblk_t	 *d = (xfs_dqblk_t *)ddq;
-	int		errs = 0;
-
-	/*
-	 * We can encounter an uninitialized dquot buffer for 2 reasons:
-	 * 1. If we crash while deleting the quotainode(s), and those blks got
-	 *    used for user data. This is because we take the path of regular
-	 *    file deletion; however, the size field of quotainodes is never
-	 *    updated, so all the tricks that we play in itruncate_finish
-	 *    don't quite matter.
-	 *
-	 * 2. We don't play the quota buffers when there's a quotaoff logitem.
-	 *    But the allocation will be replayed so we'll end up with an
-	 *    uninitialized quota block.
-	 *
-	 * This is all fine; things are still consistent, and we haven't lost
-	 * any quota information. Just don't complain about bad dquot blks.
-	 */
-	if (ddq->d_magic != cpu_to_be16(XFS_DQUOT_MAGIC)) {
-		if (flags & XFS_QMOPT_DOWARN)
-			xfs_alert(mp,
-			"%s : XFS dquot ID 0x%x, magic 0x%x != 0x%x",
-			str, id, be16_to_cpu(ddq->d_magic), XFS_DQUOT_MAGIC);
-		errs++;
-	}
-	if (ddq->d_version != XFS_DQUOT_VERSION) {
-		if (flags & XFS_QMOPT_DOWARN)
-			xfs_alert(mp,
-			"%s : XFS dquot ID 0x%x, version 0x%x != 0x%x",
-			str, id, ddq->d_version, XFS_DQUOT_VERSION);
-		errs++;
-	}
-
-	if (ddq->d_flags != XFS_DQ_USER &&
-	    ddq->d_flags != XFS_DQ_PROJ &&
-	    ddq->d_flags != XFS_DQ_GROUP) {
-		if (flags & XFS_QMOPT_DOWARN)
-			xfs_alert(mp,
-			"%s : XFS dquot ID 0x%x, unknown flags 0x%x",
-			str, id, ddq->d_flags);
-		errs++;
-	}
-
-	if (id != -1 && id != be32_to_cpu(ddq->d_id)) {
-		if (flags & XFS_QMOPT_DOWARN)
-			xfs_alert(mp,
-			"%s : ondisk-dquot 0x%p, ID mismatch: "
-			"0x%x expected, found id 0x%x",
-			str, ddq, id, be32_to_cpu(ddq->d_id));
-		errs++;
-	}
-
-	if (!errs && ddq->d_id) {
-		if (ddq->d_blk_softlimit &&
-		    be64_to_cpu(ddq->d_bcount) >
-				be64_to_cpu(ddq->d_blk_softlimit)) {
-			if (!ddq->d_btimer) {
-				if (flags & XFS_QMOPT_DOWARN)
-					xfs_alert(mp,
-			"%s : Dquot ID 0x%x (0x%p) BLK TIMER NOT STARTED",
-					str, (int)be32_to_cpu(ddq->d_id), ddq);
-				errs++;
-			}
-		}
-		if (ddq->d_ino_softlimit &&
-		    be64_to_cpu(ddq->d_icount) >
-				be64_to_cpu(ddq->d_ino_softlimit)) {
-			if (!ddq->d_itimer) {
-				if (flags & XFS_QMOPT_DOWARN)
-					xfs_alert(mp,
-			"%s : Dquot ID 0x%x (0x%p) INODE TIMER NOT STARTED",
-					str, (int)be32_to_cpu(ddq->d_id), ddq);
-				errs++;
-			}
-		}
-		if (ddq->d_rtb_softlimit &&
-		    be64_to_cpu(ddq->d_rtbcount) >
-				be64_to_cpu(ddq->d_rtb_softlimit)) {
-			if (!ddq->d_rtbtimer) {
-				if (flags & XFS_QMOPT_DOWARN)
-					xfs_alert(mp,
-			"%s : Dquot ID 0x%x (0x%p) RTBLK TIMER NOT STARTED",
-					str, (int)be32_to_cpu(ddq->d_id), ddq);
-				errs++;
-			}
-		}
-	}
-
-	if (!errs || !(flags & XFS_QMOPT_DQREPAIR))
-		return errs;
-
-	if (flags & XFS_QMOPT_DOWARN)
-		xfs_notice(mp, "Re-initializing dquot ID 0x%x", id);
-
-	/*
-	 * Typically, a repair is only requested by quotacheck.
-	 */
-	ASSERT(id != -1);
-	ASSERT(flags & XFS_QMOPT_DQREPAIR);
-	memset(d, 0, sizeof(xfs_dqblk_t));
-
-	d->dd_diskdq.d_magic = cpu_to_be16(XFS_DQUOT_MAGIC);
-	d->dd_diskdq.d_version = XFS_DQUOT_VERSION;
-	d->dd_diskdq.d_flags = type;
-	d->dd_diskdq.d_id = cpu_to_be32(id);
-
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
-		uuid_copy(&d->dd_uuid, &mp->m_sb.sb_uuid);
-		xfs_update_cksum((char *)d, sizeof(struct xfs_dqblk),
-				 XFS_DQUOT_CRC_OFF);
-	}
-
-	return errs;
-}
-
-/*
  * Perform a dquot buffer recovery.
  * Simple algorithm: if we have found a QUOTAOFF log item of the same type
  * (ie. USR or GRP), then just toss this buffer away; don't recover it.
@@ -3126,7 +2999,7 @@ xlog_recover_dquot_pass2(
 	 */
 	dq_f = item->ri_buf[0].i_addr;
 	ASSERT(dq_f);
-	error = xfs_qm_dqcheck(mp, recddq, dq_f->qlf_id, 0, XFS_QMOPT_DOWARN,
+	error = xfs_dqcheck(mp, recddq, dq_f->qlf_id, 0, XFS_QMOPT_DOWARN,
 			   "xlog_recover_dquot_pass2 (log copy)");
 	if (error)
 		return XFS_ERROR(EIO);
@@ -3146,7 +3019,7 @@ xlog_recover_dquot_pass2(
 	 * was among a chunk of dquots created earlier, and we did some
 	 * minimal initialization then.
 	 */
-	error = xfs_qm_dqcheck(mp, ddq, dq_f->qlf_id, 0, XFS_QMOPT_DOWARN,
+	error = xfs_dqcheck(mp, ddq, dq_f->qlf_id, 0, XFS_QMOPT_DOWARN,
 			   "xlog_recover_dquot_pass2");
 	if (error) {
 		xfs_buf_relse(bp);
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index dc2d4f7..6dfb4e3 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -665,20 +665,6 @@ xfs_qm_dqdetach(
 	}
 }
 
-int
-xfs_qm_calc_dquots_per_chunk(
-	struct xfs_mount	*mp,
-	unsigned int		nbblks)	/* basic block units */
-{
-	unsigned int	ndquots;
-
-	ASSERT(nbblks > 0);
-	ndquots = BBTOB(nbblks);
-	do_div(ndquots, sizeof(xfs_dqblk_t));
-
-	return ndquots;
-}
-
 struct xfs_qm_isolate {
 	struct list_head	buffers;
 	struct list_head	dispose;
@@ -859,7 +845,7 @@ xfs_qm_init_quotainfo(
 
 	/* Precalc some constants */
 	qinf->qi_dqchunklen = XFS_FSB_TO_BB(mp, XFS_DQUOT_CLUSTER_SIZE_FSB);
-	qinf->qi_dqperchunk = xfs_qm_calc_dquots_per_chunk(mp,
+	qinf->qi_dqperchunk = xfs_calc_dquots_per_chunk(mp,
 							qinf->qi_dqchunklen);
 
 	mp->m_qflags |= (mp->m_sb.sb_qflags & XFS_ALL_QUOTA_CHKD);
@@ -1093,10 +1079,10 @@ xfs_qm_reset_dqcounts(
 		/*
 		 * Do a sanity check, and if needed, repair the dqblk. Don't
 		 * output any warnings because it's perfectly possible to
-		 * find uninitialised dquot blks. See comment in xfs_qm_dqcheck.
+		 * find uninitialised dquot blks. See comment in xfs_dqcheck.
 		 */
-		(void) xfs_qm_dqcheck(mp, ddq, id+j, type, XFS_QMOPT_DQREPAIR,
-				      "xfs_quotacheck");
+		xfs_dqcheck(mp, ddq, id+j, type, XFS_QMOPT_DQREPAIR,
+			    "xfs_quotacheck");
 		ddq->d_bcount = 0;
 		ddq->d_icount = 0;
 		ddq->d_rtbcount = 0;
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index 2b602df..a788b66 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -103,8 +103,6 @@ xfs_dq_to_quota_inode(struct xfs_dquot *dqp)
 	return NULL;
 }
 
-extern int	xfs_qm_calc_dquots_per_chunk(struct xfs_mount *mp,
-					     unsigned int nbblks);
 extern void	xfs_trans_mod_dquot(struct xfs_trans *,
 					struct xfs_dquot *, uint, long);
 extern int	xfs_trans_reserve_quota_bydquots(struct xfs_trans *,
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index 84661d4..5376dd4 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -150,8 +150,6 @@ static inline int xfs_trans_reserve_quota_bydquots(struct xfs_trans *tp,
 	xfs_trans_reserve_quota_bydquots(tp, mp, ud, gd, pd, nb, ni, \
 				f | XFS_QMOPT_RES_REGBLKS)
 
-extern int xfs_qm_dqcheck(struct xfs_mount *, xfs_disk_dquot_t *,
-				xfs_dqid_t, uint, uint, char *);
 extern int xfs_mount_reset_sbqflags(struct xfs_mount *);
 
 #endif	/* __XFS_QUOTA_H__ */
diff --git a/fs/xfs/xfs_quota_defs.h b/fs/xfs/xfs_quota_defs.h
index e6b0d6e..b3b2b10 100644
--- a/fs/xfs/xfs_quota_defs.h
+++ b/fs/xfs/xfs_quota_defs.h
@@ -154,4 +154,8 @@ typedef __uint16_t	xfs_qwarncnt_t;
 		(XFS_QMOPT_UQUOTA | XFS_QMOPT_PQUOTA | XFS_QMOPT_GQUOTA)
 #define XFS_QMOPT_RESBLK_MASK	(XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_RES_RTBLKS)
 
+extern int xfs_dqcheck(struct xfs_mount *mp, xfs_disk_dquot_t *ddq,
+		       xfs_dqid_t id, uint type, uint flags, char *str);
+extern int xfs_calc_dquots_per_chunk(struct xfs_mount *mp, unsigned int nbblks);
+
 #endif	/* __XFS_QUOTA_H__ */
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
