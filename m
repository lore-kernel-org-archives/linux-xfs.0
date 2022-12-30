Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A7C6C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:33:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235459AbiL3XdF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:33:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231348AbiL3XdF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:33:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DC7912D20
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:33:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1AD5961C31
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:33:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73B5DC433D2;
        Fri, 30 Dec 2022 23:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672443182;
        bh=JylOnKBx+d7zQWOYwdgjyTfXG24EwcnsvpYC6Zy7gC4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=YqZQ+Z9b6wE2ojlb4/DGwX81TWwT9CR/EsdUW97xaJSiYgQBAFOo/jv+eL46ngLPi
         AKOi/SqtzNq+mXKhXPEFVk4gJnqT9LyKRzrlbONyawfZEpbydFil89h5Wg8oxe/ngN
         nswbxKN62D7m37Et/NjIWCnF+7vmB1RvYd2Ja/zMwSvJqXU6q/4tmhbr+aaN7IOdY2
         kBZoR6ARnEm5El4FwOjI/nWvea/Yjh+uP1CqVEzzIZWnVyl5OgjmfZ3Fsyk0ci9SMB
         IsFOs4OFGP/h5U5iQNDaWxdH8+sdseKPZNOz2eKYFfIQiF+aEBHw86ybzea9NPc/Fd
         CPaqtfiQiYzWA==
Subject: [PATCH 4/4] xfs: repair quotas
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:00 -0800
Message-ID: <167243838049.695277.448001870679816432.stgit@magnolia>
In-Reply-To: <167243837989.695277.12249962882609806700.stgit@magnolia>
References: <167243837989.695277.12249962882609806700.stgit@magnolia>
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
 fs/xfs/scrub/quota.c        |   11 +
 fs/xfs/scrub/quota.h        |   11 +
 fs/xfs/scrub/quota_repair.c |  405 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h       |    7 +
 fs/xfs/scrub/scrub.c        |    6 -
 fs/xfs/scrub/trace.c        |    1 
 fs/xfs/scrub/trace.h        |   28 +++
 8 files changed, 467 insertions(+), 6 deletions(-)
 create mode 100644 fs/xfs/scrub/quota.h
 create mode 100644 fs/xfs/scrub/quota_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 74fcf2b4dc86..5f31a5ee1473 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -191,5 +191,9 @@ xfs-y				+= $(addprefix scrub/, \
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
index 085ff234f6ba..714bd4c0753a 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -17,9 +17,10 @@
 #include "xfs_bmap.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
+#include "scrub/quota.h"
 
 /* Convert a scrub type code to a DQ flag, or return 0 if error. */
-static inline xfs_dqtype_t
+xfs_dqtype_t
 xchk_quota_to_dqtype(
 	struct xfs_scrub	*sc)
 {
@@ -226,7 +227,10 @@ xchk_quota(
 
 	dqtype = xchk_quota_to_dqtype(sc);
 
-	/* Look for problem extents. */
+	/*
+	 * Look for problem extents.  Leave the quota inode ILOCKd if we find
+	 * any.
+	 */
 	error = xchk_quota_data_fork(sc);
 	if (error)
 		goto out;
@@ -239,10 +243,11 @@ xchk_quota(
 	 * functions.
 	 */
 	xchk_iunlock(sc, sc->ilock_flags);
+
+	/* Now look for things that the quota verifiers won't complain about. */
 	sqi.sc = sc;
 	sqi.last_id = 0;
 	error = xfs_qm_dqiterate(mp, dqtype, xchk_quota_item, &sqi);
-	xchk_ilock(sc, XFS_ILOCK_EXCL);
 	if (error == -ECANCELED)
 		error = 0;
 	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK,
diff --git a/fs/xfs/scrub/quota.h b/fs/xfs/scrub/quota.h
new file mode 100644
index 000000000000..1f0dc0b500e3
--- /dev/null
+++ b/fs/xfs/scrub/quota.h
@@ -0,0 +1,11 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_SCRUB_QUOTA_H__
+#define __XFS_SCRUB_QUOTA_H__
+
+xfs_dqtype_t xchk_quota_to_dqtype(struct xfs_scrub *sc);
+
+#endif /* __XFS_SCRUB_QUOTA_H__ */
diff --git a/fs/xfs/scrub/quota_repair.c b/fs/xfs/scrub/quota_repair.c
new file mode 100644
index 000000000000..a150719c2b90
--- /dev/null
+++ b/fs/xfs/scrub/quota_repair.c
@@ -0,0 +1,405 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
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
+/* Scrub the fields in an individual quota item. */
+STATIC int
+xrep_quota_item(
+	struct xfs_dquot	*dqp,
+	xfs_dqtype_t		dqtype,
+	void			*priv)
+{
+	struct xrep_quota_info	*rqi = priv;
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
+	/* Check the limits. */
+	if (dqp->q_blk.softlimit > dqp->q_blk.hardlimit) {
+		dqp->q_blk.softlimit = dqp->q_blk.hardlimit;
+		dirty = true;
+	}
+
+	if (dqp->q_ino.softlimit > dqp->q_ino.hardlimit) {
+		dqp->q_ino.softlimit = dqp->q_ino.hardlimit;
+		dirty = true;
+	}
+
+	if (dqp->q_rtb.softlimit > dqp->q_rtb.hardlimit) {
+		dqp->q_rtb.softlimit = dqp->q_rtb.hardlimit;
+		dirty = true;
+	}
+
+	/*
+	 * Check that usage doesn't exceed physical limits.  However, on
+	 * a reflink filesystem we're allowed to exceed physical space
+	 * if there are no quota limits.  We don't know what the real number
+	 * is, but we can make quotacheck find out for us.
+	 */
+	if (!xfs_has_reflink(mp) && dqp->q_blk.count > mp->m_sb.sb_dblocks) {
+		dqp->q_blk.reserved -= dqp->q_blk.count;
+		dqp->q_blk.reserved += mp->m_sb.sb_dblocks;
+		dqp->q_blk.count = mp->m_sb.sb_dblocks;
+		rqi->need_quotacheck = true;
+		dirty = true;
+	}
+	fs_icount = percpu_counter_sum(&mp->m_icount);
+	if (dqp->q_ino.count > fs_icount) {
+		dqp->q_ino.reserved -= dqp->q_ino.count;
+		dqp->q_ino.reserved += fs_icount;
+		dqp->q_ino.count = fs_icount;
+		rqi->need_quotacheck = true;
+		dirty = true;
+	}
+	if (dqp->q_rtb.count > mp->m_sb.sb_rblocks) {
+		dqp->q_rtb.reserved -= dqp->q_rtb.count;
+		dqp->q_rtb.reserved += mp->m_sb.sb_rblocks;
+		dqp->q_rtb.count = mp->m_sb.sb_rblocks;
+		rqi->need_quotacheck = true;
+		dirty = true;
+	}
+
+	if (!dirty)
+		return 0;
+
+	trace_xrep_dquot_item(sc->mp, dqp->q_type, dqp->q_id);
+
+	dqp->q_flags |= XFS_DQFLAG_DIRTY;
+	xfs_trans_dqjoin(sc->tp, dqp);
+	if (dqp->q_id) {
+		xfs_qm_adjust_dqlimits(dqp);
+		xfs_qm_adjust_dqtimers(dqp);
+	}
+	xfs_trans_log_dquot(sc->tp, dqp);
+	error = xfs_trans_roll(&sc->tp);
+	xfs_dqlock(dqp);
+	return error;
+}
+
+/* Fix a quota timer so that we can pass the verifier. */
+STATIC void
+xrep_quota_fix_timer(
+	struct xfs_mount	*mp,
+	__be64			softlimit,
+	__be64			countnow,
+	__be32			*timer,
+	time64_t		timelimit)
+{
+	uint64_t		soft = be64_to_cpu(softlimit);
+	uint64_t		count = be64_to_cpu(countnow);
+	time64_t		new_timer;
+
+	if (!soft || count <= soft || *timer != 0)
+		return;
+
+	new_timer = xfs_dquot_set_timeout(mp,
+				ktime_get_real_seconds() + timelimit);
+	*timer = cpu_to_be32(new_timer);
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
+		xrep_quota_fix_timer(sc->mp, ddq->d_blk_softlimit,
+				ddq->d_bcount, &ddq->d_btimer,
+				defq->blk.time);
+
+		xrep_quota_fix_timer(sc->mp, ddq->d_ino_softlimit,
+				ddq->d_icount, &ddq->d_itimer,
+				defq->ino.time);
+
+		xrep_quota_fix_timer(sc->mp, ddq->d_rtb_softlimit,
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
+	int			error = 0;
+
+	error = xrep_metadata_inode_forks(sc);
+	if (error)
+		goto out;
+
+	/* Check for data fork problems that apply only to quota files. */
+	max_dqid_off = ((xfs_dqid_t)-1) / qi->qi_dqperchunk;
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
+			xfs_trans_ijoin(sc->tp, sc->ip, 0);
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
+	xfs_trans_ijoin(sc->tp, sc->ip, 0);
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
+	struct xrep_quota_info	rqi;
+	int			error;
+
+	rqi.sc = sc;
+	rqi.need_quotacheck = false;
+	error = xfs_qm_dqiterate(sc->mp, dqtype, xrep_quota_item, &rqi);
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
+		goto out;
+
+	/*
+	 * Roll the transaction to unjoin the quota inode from transaction so
+	 * that we can unlock the quota inode; we play only with dquots from
+	 * now on.
+	 */
+	error = xfs_trans_roll(&sc->tp);
+	if (error)
+		goto out;
+	xchk_iunlock(sc, sc->ilock_flags);
+
+	/* Fix anything the dquot verifiers don't complain about. */
+	error = xrep_quota_problems(sc, dqtype);
+out:
+	return error;
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 74325131f3ca..16047fc42696 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -112,6 +112,12 @@ int xrep_rtbitmap(struct xfs_scrub *sc);
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
 
@@ -179,6 +185,7 @@ static inline int xrep_setup_rtbitmap(struct xfs_scrub *sc, unsigned int *x)
 #define xrep_bmap_attr			xrep_notsupported
 #define xrep_bmap_cow			xrep_notsupported
 #define xrep_rtbitmap			xrep_notsupported
+#define xrep_quota			xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 06da054bf9e4..60875c4ad5d9 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -343,19 +343,19 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
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
index 4a0385c97ea6..6e3395d22824 100644
--- a/fs/xfs/scrub/trace.c
+++ b/fs/xfs/scrub/trace.c
@@ -13,6 +13,7 @@
 #include "xfs_inode.h"
 #include "xfs_btree.h"
 #include "xfs_ag.h"
+#include "xfs_quota_defs.h"
 #include "scrub/scrub.h"
 #include "scrub/xfile.h"
 #include "scrub/xfarray.h"
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index f0618ea849f0..4978548dfbff 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1633,6 +1633,34 @@ TRACE_EVENT(xrep_cow_free_staging,
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
+#endif /* CONFIG_XFS_QUOTA */
+
 #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */
 
 #endif /* _TRACE_XFS_SCRUB_TRACE_H */

