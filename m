Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D214E7F14A
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Sep 2023 00:22:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234035AbjI0AWl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Sep 2023 20:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233036AbjI0AUk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Sep 2023 20:20:40 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC8E421107
        for <linux-xfs@vger.kernel.org>; Tue, 26 Sep 2023 16:40:32 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4555FC433C7;
        Tue, 26 Sep 2023 23:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695771632;
        bh=j6p09fxdBNpSS5fjrrOO6Xyd3hM5SMZDHMSXImJ8RiM=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=iP2DddwERbj4jrnT35PndgD84i7jujDEM3K13EL4vAL92xoZZvZF2pHx1CqamRqzM
         O+BYmDZGeIvrbQQP7L8US2I5X1e/F+PqLh9mga6D1Z0k6jcOL9WtLsUSGJAhcL7C+p
         eLKgIab/zx8XC/tBP696BMHbLFiLKe4sj0nWjD/r/RW1ElzS81NFddjIoCic4iBrMt
         D6Pl1b5hAH7M0VXPZWDxUlHm9DeQan7QwERNosBRd8JOztZ6CmHktIimDPk6fEdyJ+
         18uKMYKKDYKCCGK9HQojM+iCAm+mB/bro0pLBiQW5fGo3s3JuduazmnmBEsDRQmjD0
         a7mpq4N1pv4Jg==
Date:   Tue, 26 Sep 2023 16:40:31 -0700
Subject: [PATCH 5/5] xfs: repair quotas
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <169577061649.3315644.8041115780953661478.stgit@frogsfrogsfrogs>
In-Reply-To: <169577061571.3315644.2567541587400012629.stgit@frogsfrogsfrogs>
References: <169577061571.3315644.2567541587400012629.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Fix anything that causes the quota verifiers to fail.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile             |    4 
 fs/xfs/scrub/quota.c        |    3 
 fs/xfs/scrub/quota.h        |    2 
 fs/xfs/scrub/quota_repair.c |  572 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h       |    7 +
 fs/xfs/scrub/scrub.c        |    6 
 fs/xfs/scrub/trace.c        |    1 
 fs/xfs/scrub/trace.h        |   29 ++
 fs/xfs/xfs_dquot.c          |    6 
 fs/xfs/xfs_dquot.h          |    3 
 10 files changed, 625 insertions(+), 8 deletions(-)
 create mode 100644 fs/xfs/scrub/quota_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 91008db406fb2..8d10fe02054db 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -198,5 +198,9 @@ xfs-y				+= $(addprefix scrub/, \
 xfs-$(CONFIG_XFS_RT)		+= $(addprefix scrub/, \
 				   rtbitmap_repair.o \
 				   )
+
+xfs-$(CONFIG_XFS_QUOTA)		+= $(addprefix scrub/, \
+				   quota_repair.o \
+				   )
 endif
 endif
diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index 1a65a75025276..183d531875eae 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -21,7 +21,7 @@
 #include "scrub/quota.h"
 
 /* Convert a scrub type code to a DQ flag, or return 0 if error. */
-static inline xfs_dqtype_t
+xfs_dqtype_t
 xchk_quota_to_dqtype(
 	struct xfs_scrub	*sc)
 {
@@ -328,7 +328,6 @@ xchk_quota(
 		if (error)
 			break;
 	}
-	xchk_ilock(sc, XFS_ILOCK_EXCL);
 	if (error == -ECANCELED)
 		error = 0;
 	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK,
diff --git a/fs/xfs/scrub/quota.h b/fs/xfs/scrub/quota.h
index 5056b7766c4a2..6c7134ce2385e 100644
--- a/fs/xfs/scrub/quota.h
+++ b/fs/xfs/scrub/quota.h
@@ -6,6 +6,8 @@
 #ifndef __XFS_SCRUB_QUOTA_H__
 #define __XFS_SCRUB_QUOTA_H__
 
+xfs_dqtype_t xchk_quota_to_dqtype(struct xfs_scrub *sc);
+
 /* dquot iteration code */
 
 struct xchk_dqiter {
diff --git a/fs/xfs/scrub/quota_repair.c b/fs/xfs/scrub/quota_repair.c
new file mode 100644
index 0000000000000..8e9f62a6f406f
--- /dev/null
+++ b/fs/xfs/scrub/quota_repair.c
@@ -0,0 +1,572 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2018-2023 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_btree.h"
+#include "xfs_bit.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_inode.h"
+#include "xfs_inode_fork.h"
+#include "xfs_alloc.h"
+#include "xfs_bmap.h"
+#include "xfs_quota.h"
+#include "xfs_qm.h"
+#include "xfs_dquot.h"
+#include "xfs_dquot_item.h"
+#include "xfs_reflink.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_trans_space.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/quota.h"
+#include "scrub/trace.h"
+#include "scrub/repair.h"
+
+/*
+ * Quota Repair
+ * ============
+ *
+ * Quota repairs are fairly simplistic; we fix everything that the dquot
+ * verifiers complain about, cap any counters or limits that make no sense,
+ * and schedule a quotacheck if we had to fix anything.  We also repair any
+ * data fork extent records that don't apply to metadata files.
+ */
+
+struct xrep_quota_info {
+	struct xfs_scrub	*sc;
+	bool			need_quotacheck;
+};
+
+/*
+ * Allocate a new block into a sparse hole in the quota file backing this
+ * dquot, initialize the block, and commit the whole mess.
+ */
+STATIC int
+xrep_quota_item_fill_bmap_hole(
+	struct xfs_scrub	*sc,
+	struct xfs_dquot	*dq,
+	struct xfs_bmbt_irec	*irec)
+{
+	struct xfs_buf		*bp;
+	struct xfs_mount	*mp = sc->mp;
+	int			nmaps = 1;
+	int			error;
+
+	xfs_trans_ijoin(sc->tp, sc->ip, 0);
+
+	/* Map a block into the file. */
+	error = xfs_trans_reserve_more(sc->tp, XFS_QM_DQALLOC_SPACE_RES(mp),
+			0);
+	if (error)
+		return error;
+
+	error = xfs_bmapi_write(sc->tp, sc->ip, dq->q_fileoffset,
+			XFS_DQUOT_CLUSTER_SIZE_FSB, XFS_BMAPI_METADATA, 0,
+			irec, &nmaps);
+	if (error)
+		return error;
+	if (nmaps != 1)
+		return -ENOSPC;
+
+	dq->q_blkno = XFS_FSB_TO_DADDR(mp, irec->br_startblock);
+
+	trace_xrep_dquot_item_fill_bmap_hole(sc->mp, dq->q_type, dq->q_id);
+
+	/* Initialize the new block. */
+	error = xfs_trans_get_buf(sc->tp, mp->m_ddev_targp, dq->q_blkno,
+			mp->m_quotainfo->qi_dqchunklen, 0, &bp);
+	if (error)
+		return error;
+	bp->b_ops = &xfs_dquot_buf_ops;
+
+	xfs_qm_init_dquot_blk(sc->tp, dq->q_id, dq->q_type, bp);
+	xfs_buf_set_ref(bp, XFS_DQUOT_REF);
+
+	/*
+	 * Finish the mapping transactions and roll one more time to
+	 * disconnect sc->ip from sc->tp.
+	 */
+	error = xrep_defer_finish(sc);
+	if (error)
+		return error;
+	return xfs_trans_roll(&sc->tp);
+}
+
+/* Make sure there's a written block backing this dquot */
+STATIC int
+xrep_quota_item_bmap(
+	struct xfs_scrub	*sc,
+	struct xfs_dquot	*dq,
+	bool			*dirty)
+{
+	struct xfs_bmbt_irec	irec;
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_quotainfo	*qi = mp->m_quotainfo;
+	xfs_fileoff_t		offset = dq->q_id / qi->qi_dqperchunk;
+	int			nmaps = 1;
+	int			error;
+
+	/* The computed file offset should always be valid. */
+	if (!xfs_verify_fileoff(mp, offset)) {
+		ASSERT(xfs_verify_fileoff(mp, offset));
+		return -EFSCORRUPTED;
+	}
+	dq->q_fileoffset = offset;
+
+	error = xfs_bmapi_read(sc->ip, offset, 1, &irec, &nmaps, 0);
+	if (error)
+		return error;
+
+	if (nmaps < 1 || !xfs_bmap_is_real_extent(&irec)) {
+		/* Hole/delalloc extent; allocate a real block. */
+		error = xrep_quota_item_fill_bmap_hole(sc, dq, &irec);
+		if (error)
+			return error;
+	} else if (irec.br_state != XFS_EXT_NORM) {
+		/* Unwritten extent, which we already took care of? */
+		ASSERT(irec.br_state == XFS_EXT_NORM);
+		return -EFSCORRUPTED;
+	} else if (dq->q_blkno != XFS_FSB_TO_DADDR(mp, irec.br_startblock)) {
+		/*
+		 * If the cached daddr is incorrect, repair probably punched a
+		 * hole out of the quota file and filled it back in with a new
+		 * block.  Update the block mapping in the dquot.
+		 */
+		dq->q_blkno = XFS_FSB_TO_DADDR(mp, irec.br_startblock);
+	}
+
+	*dirty = true;
+	return 0;
+}
+
+/* Reset quota timers if incorrectly set. */
+static inline void
+xrep_quota_item_timer(
+	struct xfs_scrub		*sc,
+	const struct xfs_dquot_res	*res,
+	bool				*dirty)
+{
+	if ((res->softlimit && res->count > res->softlimit) ||
+	    (res->hardlimit && res->count > res->hardlimit)) {
+		if (!res->timer)
+			*dirty = true;
+	} else {
+		if (res->timer)
+			*dirty = true;
+	}
+}
+
+/* Scrub the fields in an individual quota item. */
+STATIC int
+xrep_quota_item(
+	struct xrep_quota_info	*rqi,
+	struct xfs_dquot	*dq)
+{
+	struct xfs_scrub	*sc = rqi->sc;
+	struct xfs_mount	*mp = sc->mp;
+	xfs_ino_t		fs_icount;
+	bool			dirty = false;
+	int			error = 0;
+
+	/* Last chance to abort before we start committing fixes. */
+	if (xchk_should_terminate(sc, &error))
+		return error;
+
+	/*
+	 * We might need to fix holes in the bmap record for the storage
+	 * backing this dquot, so we need to lock the dquot and the quota file.
+	 * dqiterate gave us a locked dquot, so drop the dquot lock to get the
+	 * ILOCK_EXCL.
+	 */
+	xfs_dqunlock(dq);
+	xchk_ilock(sc, XFS_ILOCK_EXCL);
+	xfs_dqlock(dq);
+
+	error = xrep_quota_item_bmap(sc, dq, &dirty);
+	xchk_iunlock(sc, XFS_ILOCK_EXCL);
+	if (error)
+		return error;
+
+	/* Check the limits. */
+	if (dq->q_blk.softlimit > dq->q_blk.hardlimit) {
+		dq->q_blk.softlimit = dq->q_blk.hardlimit;
+		dirty = true;
+	}
+
+	if (dq->q_ino.softlimit > dq->q_ino.hardlimit) {
+		dq->q_ino.softlimit = dq->q_ino.hardlimit;
+		dirty = true;
+	}
+
+	if (dq->q_rtb.softlimit > dq->q_rtb.hardlimit) {
+		dq->q_rtb.softlimit = dq->q_rtb.hardlimit;
+		dirty = true;
+	}
+
+	/*
+	 * Check that usage doesn't exceed physical limits.  However, on
+	 * a reflink filesystem we're allowed to exceed physical space
+	 * if there are no quota limits.  We don't know what the real number
+	 * is, but we can make quotacheck find out for us.
+	 */
+	if (!xfs_has_reflink(mp) && dq->q_blk.count > mp->m_sb.sb_dblocks) {
+		dq->q_blk.reserved -= dq->q_blk.count;
+		dq->q_blk.reserved += mp->m_sb.sb_dblocks;
+		dq->q_blk.count = mp->m_sb.sb_dblocks;
+		rqi->need_quotacheck = true;
+		dirty = true;
+	}
+	fs_icount = percpu_counter_sum(&mp->m_icount);
+	if (dq->q_ino.count > fs_icount) {
+		dq->q_ino.reserved -= dq->q_ino.count;
+		dq->q_ino.reserved += fs_icount;
+		dq->q_ino.count = fs_icount;
+		rqi->need_quotacheck = true;
+		dirty = true;
+	}
+	if (dq->q_rtb.count > mp->m_sb.sb_rblocks) {
+		dq->q_rtb.reserved -= dq->q_rtb.count;
+		dq->q_rtb.reserved += mp->m_sb.sb_rblocks;
+		dq->q_rtb.count = mp->m_sb.sb_rblocks;
+		rqi->need_quotacheck = true;
+		dirty = true;
+	}
+
+	xrep_quota_item_timer(sc, &dq->q_blk, &dirty);
+	xrep_quota_item_timer(sc, &dq->q_ino, &dirty);
+	xrep_quota_item_timer(sc, &dq->q_rtb, &dirty);
+
+	if (!dirty)
+		return 0;
+
+	trace_xrep_dquot_item(sc->mp, dq->q_type, dq->q_id);
+
+	dq->q_flags |= XFS_DQFLAG_DIRTY;
+	xfs_trans_dqjoin(sc->tp, dq);
+	if (dq->q_id) {
+		xfs_qm_adjust_dqlimits(dq);
+		xfs_qm_adjust_dqtimers(dq);
+	}
+	xfs_trans_log_dquot(sc->tp, dq);
+	error = xfs_trans_roll(&sc->tp);
+	xfs_dqlock(dq);
+	return error;
+}
+
+/* Fix a quota timer so that we can pass the verifier. */
+STATIC void
+xrep_quota_fix_timer(
+	struct xfs_mount	*mp,
+	const struct xfs_disk_dquot *ddq,
+	__be64			softlimit,
+	__be64			countnow,
+	__be32			*timer,
+	time64_t		timelimit)
+{
+	uint64_t		soft = be64_to_cpu(softlimit);
+	uint64_t		count = be64_to_cpu(countnow);
+	time64_t		new_timer;
+	uint32_t		t;
+
+	if (!soft || count <= soft || *timer != 0)
+		return;
+
+	new_timer = xfs_dquot_set_timeout(mp,
+				ktime_get_real_seconds() + timelimit);
+	if (ddq->d_type & XFS_DQTYPE_BIGTIME)
+		t = xfs_dq_unix_to_bigtime(new_timer);
+	else
+		t = new_timer;
+
+	*timer = cpu_to_be32(t);
+}
+
+/* Fix anything the verifiers complain about. */
+STATIC int
+xrep_quota_block(
+	struct xfs_scrub	*sc,
+	xfs_daddr_t		daddr,
+	xfs_dqtype_t		dqtype,
+	xfs_dqid_t		id)
+{
+	struct xfs_dqblk	*dqblk;
+	struct xfs_disk_dquot	*ddq;
+	struct xfs_quotainfo	*qi = sc->mp->m_quotainfo;
+	struct xfs_def_quota	*defq = xfs_get_defquota(qi, dqtype);
+	struct xfs_buf		*bp = NULL;
+	enum xfs_blft		buftype = 0;
+	int			i;
+	int			error;
+
+	error = xfs_trans_read_buf(sc->mp, sc->tp, sc->mp->m_ddev_targp, daddr,
+			qi->qi_dqchunklen, 0, &bp, &xfs_dquot_buf_ops);
+	switch (error) {
+	case -EFSBADCRC:
+	case -EFSCORRUPTED:
+		/* Failed verifier, retry read with no ops. */
+		error = xfs_trans_read_buf(sc->mp, sc->tp,
+				sc->mp->m_ddev_targp, daddr, qi->qi_dqchunklen,
+				0, &bp, NULL);
+		if (error)
+			return error;
+		break;
+	case 0:
+		dqblk = bp->b_addr;
+		ddq = &dqblk[0].dd_diskdq;
+
+		/*
+		 * If there's nothing that would impede a dqiterate, we're
+		 * done.
+		 */
+		if ((ddq->d_type & XFS_DQTYPE_REC_MASK) != dqtype ||
+		    id == be32_to_cpu(ddq->d_id)) {
+			xfs_trans_brelse(sc->tp, bp);
+			return 0;
+		}
+		break;
+	default:
+		return error;
+	}
+
+	/* Something's wrong with the block, fix the whole thing. */
+	dqblk = bp->b_addr;
+	bp->b_ops = &xfs_dquot_buf_ops;
+	for (i = 0; i < qi->qi_dqperchunk; i++, dqblk++) {
+		ddq = &dqblk->dd_diskdq;
+
+		trace_xrep_disk_dquot(sc->mp, dqtype, id + i);
+
+		ddq->d_magic = cpu_to_be16(XFS_DQUOT_MAGIC);
+		ddq->d_version = XFS_DQUOT_VERSION;
+		ddq->d_type = dqtype;
+		ddq->d_id = cpu_to_be32(id + i);
+
+		if (xfs_has_bigtime(sc->mp) && ddq->d_id)
+			ddq->d_type |= XFS_DQTYPE_BIGTIME;
+
+		xrep_quota_fix_timer(sc->mp, ddq, ddq->d_blk_softlimit,
+				ddq->d_bcount, &ddq->d_btimer,
+				defq->blk.time);
+
+		xrep_quota_fix_timer(sc->mp, ddq, ddq->d_ino_softlimit,
+				ddq->d_icount, &ddq->d_itimer,
+				defq->ino.time);
+
+		xrep_quota_fix_timer(sc->mp, ddq, ddq->d_rtb_softlimit,
+				ddq->d_rtbcount, &ddq->d_rtbtimer,
+				defq->rtb.time);
+
+		/* We only support v5 filesystems so always set these. */
+		uuid_copy(&dqblk->dd_uuid, &sc->mp->m_sb.sb_meta_uuid);
+		xfs_update_cksum((char *)dqblk, sizeof(struct xfs_dqblk),
+				 XFS_DQUOT_CRC_OFF);
+		dqblk->dd_lsn = 0;
+	}
+	switch (dqtype) {
+	case XFS_DQTYPE_USER:
+		buftype = XFS_BLFT_UDQUOT_BUF;
+		break;
+	case XFS_DQTYPE_GROUP:
+		buftype = XFS_BLFT_GDQUOT_BUF;
+		break;
+	case XFS_DQTYPE_PROJ:
+		buftype = XFS_BLFT_PDQUOT_BUF;
+		break;
+	}
+	xfs_trans_buf_set_type(sc->tp, bp, buftype);
+	xfs_trans_log_buf(sc->tp, bp, 0, BBTOB(bp->b_length) - 1);
+	return xrep_roll_trans(sc);
+}
+
+/*
+ * Repair a quota file's data fork.  The function returns with the inode
+ * joined.
+ */
+STATIC int
+xrep_quota_data_fork(
+	struct xfs_scrub	*sc,
+	xfs_dqtype_t		dqtype)
+{
+	struct xfs_bmbt_irec	irec = { 0 };
+	struct xfs_iext_cursor	icur;
+	struct xfs_quotainfo	*qi = sc->mp->m_quotainfo;
+	struct xfs_ifork	*ifp;
+	xfs_fileoff_t		max_dqid_off;
+	xfs_fileoff_t		off;
+	xfs_fsblock_t		fsbno;
+	bool			truncate = false;
+	bool			joined = false;
+	int			error = 0;
+
+	error = xrep_metadata_inode_forks(sc);
+	if (error)
+		goto out;
+
+	/* Check for data fork problems that apply only to quota files. */
+	max_dqid_off = XFS_DQ_ID_MAX / qi->qi_dqperchunk;
+	ifp = xfs_ifork_ptr(sc->ip, XFS_DATA_FORK);
+	for_each_xfs_iext(ifp, &icur, &irec) {
+		if (isnullstartblock(irec.br_startblock)) {
+			error = -EFSCORRUPTED;
+			goto out;
+		}
+
+		if (irec.br_startoff > max_dqid_off ||
+		    irec.br_startoff + irec.br_blockcount - 1 > max_dqid_off) {
+			truncate = true;
+			break;
+		}
+
+		/* Convert unwritten extents to real ones. */
+		if (irec.br_state == XFS_EXT_UNWRITTEN) {
+			struct xfs_bmbt_irec	nrec;
+			int			nmap = 1;
+
+			if (!joined) {
+				xfs_trans_ijoin(sc->tp, sc->ip, 0);
+				joined = true;
+			}
+
+			error = xfs_bmapi_write(sc->tp, sc->ip,
+					irec.br_startoff, irec.br_blockcount,
+					XFS_BMAPI_CONVERT, 0, &nrec, &nmap);
+			if (error)
+				goto out;
+			ASSERT(nmap == 1);
+			ASSERT(nrec.br_startoff == irec.br_startoff);
+			ASSERT(nrec.br_blockcount == irec.br_blockcount);
+
+			error = xfs_defer_finish(&sc->tp);
+			if (error)
+				goto out;
+		}
+	}
+
+	if (!joined) {
+		xfs_trans_ijoin(sc->tp, sc->ip, 0);
+		joined = true;
+	}
+
+	if (truncate) {
+		/* Erase everything after the block containing the max dquot */
+		error = xfs_bunmapi_range(&sc->tp, sc->ip, 0,
+				max_dqid_off * sc->mp->m_sb.sb_blocksize,
+				XFS_MAX_FILEOFF);
+		if (error)
+			goto out;
+
+		/* Remove all CoW reservations. */
+		error = xfs_reflink_cancel_cow_blocks(sc->ip, &sc->tp, 0,
+				XFS_MAX_FILEOFF, true);
+		if (error)
+			goto out;
+		sc->ip->i_diflags2 &= ~XFS_DIFLAG2_REFLINK;
+
+		/*
+		 * Always re-log the inode so that our permanent transaction
+		 * can keep on rolling it forward in the log.
+		 */
+		xfs_trans_log_inode(sc->tp, sc->ip, XFS_ILOG_CORE);
+	}
+
+	/* Now go fix anything that fails the verifiers. */
+	for_each_xfs_iext(ifp, &icur, &irec) {
+		for (fsbno = irec.br_startblock, off = irec.br_startoff;
+		     fsbno < irec.br_startblock + irec.br_blockcount;
+		     fsbno += XFS_DQUOT_CLUSTER_SIZE_FSB,
+				off += XFS_DQUOT_CLUSTER_SIZE_FSB) {
+			error = xrep_quota_block(sc,
+					XFS_FSB_TO_DADDR(sc->mp, fsbno),
+					dqtype, off * qi->qi_dqperchunk);
+			if (error)
+				goto out;
+		}
+	}
+
+out:
+	return error;
+}
+
+/*
+ * Go fix anything in the quota items that we could have been mad about.  Now
+ * that we've checked the quota inode data fork we have to drop ILOCK_EXCL to
+ * use the regular dquot functions.
+ */
+STATIC int
+xrep_quota_problems(
+	struct xfs_scrub	*sc,
+	xfs_dqtype_t		dqtype)
+{
+	struct xchk_dqiter	cursor = { };
+	struct xrep_quota_info	rqi = { .sc = sc };
+	struct xfs_dquot	*dq;
+	int			error;
+
+	xchk_dqiter_init(&cursor, sc, dqtype);
+	while ((error = xchk_dquot_iter(&cursor, &dq)) == 1) {
+		error = xrep_quota_item(&rqi, dq);
+		xfs_qm_dqput(dq);
+		if (error)
+			break;
+	}
+	if (error)
+		return error;
+
+	/* Make a quotacheck happen. */
+	if (rqi.need_quotacheck)
+		xrep_force_quotacheck(sc, dqtype);
+	return 0;
+}
+
+/* Repair all of a quota type's items. */
+int
+xrep_quota(
+	struct xfs_scrub	*sc)
+{
+	xfs_dqtype_t		dqtype;
+	int			error;
+
+	dqtype = xchk_quota_to_dqtype(sc);
+
+	/*
+	 * Re-take the ILOCK so that we can fix any problems that we found
+	 * with the data fork mappings, or with the dquot bufs themselves.
+	 */
+	if (!(sc->ilock_flags & XFS_ILOCK_EXCL))
+		xchk_ilock(sc, XFS_ILOCK_EXCL);
+	error = xrep_quota_data_fork(sc, dqtype);
+	if (error)
+		return error;
+
+	/*
+	 * Finish deferred items and roll the transaction to unjoin the quota
+	 * inode from transaction so that we can unlock the quota inode; we
+	 * play only with dquots from now on.
+	 */
+	error = xrep_defer_finish(sc);
+	if (error)
+		return error;
+	error = xfs_trans_roll(&sc->tp);
+	if (error)
+		return error;
+	xchk_iunlock(sc, sc->ilock_flags);
+
+	/* Fix anything the dquot verifiers don't complain about. */
+	error = xrep_quota_problems(sc, dqtype);
+	if (error)
+		return error;
+
+	return xrep_trans_commit(sc);
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 4b9fe3d47bb24..55c5f30c9bac7 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -122,6 +122,12 @@ int xrep_rtbitmap(struct xfs_scrub *sc);
 # define xrep_rtbitmap			xrep_notsupported
 #endif /* CONFIG_XFS_RT */
 
+#ifdef CONFIG_XFS_QUOTA
+int xrep_quota(struct xfs_scrub *sc);
+#else
+# define xrep_quota			xrep_notsupported
+#endif /* CONFIG_XFS_QUOTA */
+
 int xrep_reinit_pagf(struct xfs_scrub *sc);
 int xrep_reinit_pagi(struct xfs_scrub *sc);
 
@@ -190,6 +196,7 @@ static inline int xrep_setup_rtbitmap(struct xfs_scrub *sc, unsigned int *x)
 #define xrep_bmap_attr			xrep_notsupported
 #define xrep_bmap_cow			xrep_notsupported
 #define xrep_rtbitmap			xrep_notsupported
+#define xrep_quota			xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 9982b626bfc33..0fbfed522d656 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -342,19 +342,19 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.type	= ST_FS,
 		.setup	= xchk_setup_quota,
 		.scrub	= xchk_quota,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_quota,
 	},
 	[XFS_SCRUB_TYPE_GQUOTA] = {	/* group quota */
 		.type	= ST_FS,
 		.setup	= xchk_setup_quota,
 		.scrub	= xchk_quota,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_quota,
 	},
 	[XFS_SCRUB_TYPE_PQUOTA] = {	/* project quota */
 		.type	= ST_FS,
 		.setup	= xchk_setup_quota,
 		.scrub	= xchk_quota,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_quota,
 	},
 	[XFS_SCRUB_TYPE_FSCOUNTERS] = {	/* fs summary counters */
 		.type	= ST_FS,
diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
index 7762e504e6013..a6a0f9d4500d8 100644
--- a/fs/xfs/scrub/trace.c
+++ b/fs/xfs/scrub/trace.c
@@ -14,6 +14,7 @@
 #include "xfs_btree.h"
 #include "xfs_ag.h"
 #include "xfs_quota.h"
+#include "xfs_quota_defs.h"
 #include "scrub/scrub.h"
 #include "scrub/xfile.h"
 #include "scrub/xfarray.h"
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 8d1b022f5d40b..f9f16e1212d9e 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1731,6 +1731,35 @@ TRACE_EVENT(xrep_cow_free_staging,
 		  __entry->blockcount)
 );
 
+#ifdef CONFIG_XFS_QUOTA
+DECLARE_EVENT_CLASS(xrep_dquot_class,
+	TP_PROTO(struct xfs_mount *mp, uint8_t type, uint32_t id),
+	TP_ARGS(mp, type, id),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(uint8_t, type)
+		__field(uint32_t, id)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->id = id;
+		__entry->type = type;
+	),
+	TP_printk("dev %d:%d type %s id 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __print_flags(__entry->type, "|", XFS_DQTYPE_STRINGS),
+		  __entry->id)
+);
+
+#define DEFINE_XREP_DQUOT_EVENT(name) \
+DEFINE_EVENT(xrep_dquot_class, name, \
+	TP_PROTO(struct xfs_mount *mp, uint8_t type, uint32_t id), \
+	TP_ARGS(mp, type, id))
+DEFINE_XREP_DQUOT_EVENT(xrep_dquot_item);
+DEFINE_XREP_DQUOT_EVENT(xrep_disk_dquot);
+DEFINE_XREP_DQUOT_EVENT(xrep_dquot_item_fill_bmap_hole);
+#endif /* CONFIG_XFS_QUOTA */
+
 #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */
 
 #endif /* _TRACE_XFS_SCRUB_TRACE_H */
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 83647e2f04527..653f888c2687f 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -172,14 +172,14 @@ xfs_qm_adjust_dqtimers(
 /*
  * initialize a buffer full of dquots and log the whole thing
  */
-STATIC void
+void
 xfs_qm_init_dquot_blk(
 	struct xfs_trans	*tp,
-	struct xfs_mount	*mp,
 	xfs_dqid_t		id,
 	xfs_dqtype_t		type,
 	struct xfs_buf		*bp)
 {
+	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_quotainfo	*q = mp->m_quotainfo;
 	struct xfs_dqblk	*d;
 	xfs_dqid_t		curid;
@@ -353,7 +353,7 @@ xfs_dquot_disk_alloc(
 	 * Make a chunk of dquots out of this buffer and log
 	 * the entire thing.
 	 */
-	xfs_qm_init_dquot_blk(tp, mp, dqp->q_id, qtype, bp);
+	xfs_qm_init_dquot_blk(tp, dqp->q_id, qtype, bp);
 	xfs_buf_set_ref(bp, XFS_DQUOT_REF);
 
 	/*
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 8d9d4b0d979d0..956272d9b302f 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -237,4 +237,7 @@ static inline struct xfs_dquot *xfs_qm_dqhold(struct xfs_dquot *dqp)
 time64_t xfs_dquot_set_timeout(struct xfs_mount *mp, time64_t timeout);
 time64_t xfs_dquot_set_grace_period(time64_t grace);
 
+void xfs_qm_init_dquot_blk(struct xfs_trans *tp, xfs_dqid_t id, xfs_dqtype_t
+		type, struct xfs_buf *bp);
+
 #endif /* __XFS_DQUOT_H__ */

