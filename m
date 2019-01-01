Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:38686 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727945AbfAACLw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:11:52 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0129WQV016155
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:11:49 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2pp0btp733-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:11:49 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x012Bmxl010096
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:11:49 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x012Bmhd020848
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:11:48 GMT
Subject: [PATCH 16/17] xfs: repair quotas
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:11:47 -0800
Message-ID: <154630870731.15625.13436447485660247315.stgit@magnolia>
In-Reply-To: <154630859850.15625.17640302184521917854.stgit@magnolia>
References: <154630859850.15625.17640302184521917854.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Fix anything that causes the quota verifiers to fail.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile             |    1 
 fs/xfs/scrub/attr_repair.c  |    2 
 fs/xfs/scrub/common.h       |    9 +
 fs/xfs/scrub/quota.c        |    2 
 fs/xfs/scrub/quota_repair.c |  363 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.c       |   56 +++++++
 fs/xfs/scrub/repair.h       |    8 +
 fs/xfs/scrub/scrub.c        |   11 +
 8 files changed, 444 insertions(+), 8 deletions(-)
 create mode 100644 fs/xfs/scrub/quota_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 980f2a15a5c2..4d4006a8f59e 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -177,5 +177,6 @@ xfs-y				+= $(addprefix scrub/, \
 				   repair.o \
 				   symlink_repair.o \
 				   )
+xfs-$(CONFIG_XFS_QUOTA)		+= scrub/quota_repair.o
 endif
 endif
diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
index 9f80de95b3df..d21ebfdc396c 100644
--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -393,7 +393,7 @@ xrep_xattr_recover(
 }
 
 /* Free all the attribute fork blocks and delete the fork. */
-STATIC int
+int
 xrep_xattr_reset_btree(
 	struct xfs_scrub	*sc)
 {
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index e26a430bd466..8646ee27d667 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -138,4 +138,13 @@ static inline bool xchk_skip_xref(struct xfs_scrub_metadata *sm)
 int xchk_metadata_inode_forks(struct xfs_scrub *sc);
 int xchk_ilock_inverted(struct xfs_inode *ip, uint lock_mode);
 
+/* Do we need to invoke the repair tool? */
+static inline bool xfs_scrub_needs_repair(struct xfs_scrub_metadata *sm)
+{
+	return sm->sm_flags & (XFS_SCRUB_OFLAG_CORRUPT |
+			       XFS_SCRUB_OFLAG_XCORRUPT |
+			       XFS_SCRUB_OFLAG_PREEN);
+}
+uint xchk_quota_to_dqtype(struct xfs_scrub *sc);
+
 #endif	/* __XFS_SCRUB_COMMON_H__ */
diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index 06cf5850ba07..12644785bd99 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -29,7 +29,7 @@
 #include "scrub/trace.h"
 
 /* Convert a scrub type code to a DQ flag, or return 0 if error. */
-static inline uint
+uint
 xchk_quota_to_dqtype(
 	struct xfs_scrub	*sc)
 {
diff --git a/fs/xfs/scrub/quota_repair.c b/fs/xfs/scrub/quota_repair.c
new file mode 100644
index 000000000000..36635f7ca217
--- /dev/null
+++ b/fs/xfs/scrub/quota_repair.c
@@ -0,0 +1,363 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (C) 2018 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
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
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
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
+	struct xfs_dquot	*dq,
+	uint			dqtype,
+	void			*priv)
+{
+	struct xrep_quota_info	*rqi = priv;
+	struct xfs_scrub	*sc = rqi->sc;
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_disk_dquot	*d = &dq->q_core;
+	unsigned long long	bsoft;
+	unsigned long long	isoft;
+	unsigned long long	rsoft;
+	unsigned long long	bhard;
+	unsigned long long	ihard;
+	unsigned long long	rhard;
+	unsigned long long	bcount;
+	unsigned long long	icount;
+	unsigned long long	rcount;
+	xfs_ino_t		fs_icount;
+	bool			dirty = false;
+	int			error;
+
+	/* Did we get the dquot type we wanted? */
+	if (dqtype != (d->d_flags & XFS_DQ_ALLTYPES)) {
+		d->d_flags = dqtype;
+		dirty = true;
+	}
+
+	if (d->d_pad0 || d->d_pad) {
+		d->d_pad0 = 0;
+		d->d_pad = 0;
+		dirty = true;
+	}
+
+	/* Check the limits. */
+	bhard = be64_to_cpu(d->d_blk_hardlimit);
+	ihard = be64_to_cpu(d->d_ino_hardlimit);
+	rhard = be64_to_cpu(d->d_rtb_hardlimit);
+
+	bsoft = be64_to_cpu(d->d_blk_softlimit);
+	isoft = be64_to_cpu(d->d_ino_softlimit);
+	rsoft = be64_to_cpu(d->d_rtb_softlimit);
+
+	if (bsoft > bhard) {
+		d->d_blk_softlimit = d->d_blk_hardlimit;
+		dirty = true;
+	}
+
+	if (isoft > ihard) {
+		d->d_ino_softlimit = d->d_ino_hardlimit;
+		dirty = true;
+	}
+
+	if (rsoft > rhard) {
+		d->d_rtb_softlimit = d->d_rtb_hardlimit;
+		dirty = true;
+	}
+
+	/* Check the resource counts. */
+	bcount = be64_to_cpu(d->d_bcount);
+	icount = be64_to_cpu(d->d_icount);
+	rcount = be64_to_cpu(d->d_rtbcount);
+	fs_icount = percpu_counter_sum(&mp->m_icount);
+
+	/*
+	 * Check that usage doesn't exceed physical limits.  However, on
+	 * a reflink filesystem we're allowed to exceed physical space
+	 * if there are no quota limits.  We don't know what the real number
+	 * is, but we can make quotacheck find out for us.
+	 */
+	if (!xfs_sb_version_hasreflink(&mp->m_sb) &&
+	    mp->m_sb.sb_dblocks < bcount) {
+		dq->q_res_bcount -= be64_to_cpu(dq->q_core.d_bcount);
+		dq->q_res_bcount += mp->m_sb.sb_dblocks;
+		d->d_bcount = cpu_to_be64(mp->m_sb.sb_dblocks);
+		rqi->need_quotacheck = true;
+		dirty = true;
+	}
+	if (icount > fs_icount) {
+		dq->q_res_icount -= be64_to_cpu(dq->q_core.d_icount);
+		dq->q_res_icount += fs_icount;
+		d->d_icount = cpu_to_be64(fs_icount);
+		rqi->need_quotacheck = true;
+		dirty = true;
+	}
+	if (rcount > mp->m_sb.sb_rblocks) {
+		dq->q_res_rtbcount -= be64_to_cpu(dq->q_core.d_rtbcount);
+		dq->q_res_rtbcount += mp->m_sb.sb_rblocks;
+		d->d_rtbcount = cpu_to_be64(mp->m_sb.sb_rblocks);
+		rqi->need_quotacheck = true;
+		dirty = true;
+	}
+
+	if (!dirty)
+		return 0;
+
+	dq->dq_flags |= XFS_DQ_DIRTY;
+	xfs_trans_dqjoin(sc->tp, dq);
+	xfs_trans_log_dquot(sc->tp, dq);
+	error = xfs_trans_roll(&sc->tp);
+	xfs_dqlock(dq);
+	return error;
+}
+
+/* Fix a quota timer so that we can pass the verifier. */
+STATIC void
+xrep_quota_fix_timer(
+	__be64			softlimit,
+	__be64			countnow,
+	__be32			*timer,
+	time_t			timelimit)
+{
+	uint64_t		soft = be64_to_cpu(softlimit);
+	uint64_t		count = be64_to_cpu(countnow);
+
+	if (soft && count > soft && *timer == 0)
+		*timer = cpu_to_be32(get_seconds() + timelimit);
+}
+
+/* Fix anything the verifiers complain about. */
+STATIC int
+xrep_quota_block(
+	struct xfs_scrub	*sc,
+	struct xfs_buf		*bp,
+	uint			dqtype,
+	xfs_dqid_t		id)
+{
+	struct xfs_dqblk	*d = (struct xfs_dqblk *)bp->b_addr;
+	struct xfs_disk_dquot	*ddq;
+	struct xfs_quotainfo	*qi = sc->mp->m_quotainfo;
+	enum xfs_blft		buftype = 0;
+	int			i;
+
+	bp->b_ops = &xfs_dquot_buf_ops;
+	for (i = 0; i < qi->qi_dqperchunk; i++) {
+		ddq = &d[i].dd_diskdq;
+
+		ddq->d_magic = cpu_to_be16(XFS_DQUOT_MAGIC);
+		ddq->d_version = XFS_DQUOT_VERSION;
+		ddq->d_flags = dqtype;
+		ddq->d_id = cpu_to_be32(id + i);
+
+		xrep_quota_fix_timer(ddq->d_blk_softlimit,
+				ddq->d_bcount, &ddq->d_btimer,
+				qi->qi_btimelimit);
+		xrep_quota_fix_timer(ddq->d_ino_softlimit,
+				ddq->d_icount, &ddq->d_itimer,
+				qi->qi_itimelimit);
+		xrep_quota_fix_timer(ddq->d_rtb_softlimit,
+				ddq->d_rtbcount, &ddq->d_rtbtimer,
+				qi->qi_rtbtimelimit);
+
+		/* We only support v5 filesystems so always set these. */
+		uuid_copy(&d->dd_uuid, &sc->mp->m_sb.sb_meta_uuid);
+		xfs_update_cksum((char *)d, sizeof(struct xfs_dqblk),
+				 XFS_DQUOT_CRC_OFF);
+		d->dd_lsn = 0;
+	}
+	switch (dqtype) {
+	case XFS_DQ_USER:
+		buftype = XFS_BLFT_UDQUOT_BUF;
+		break;
+	case XFS_DQ_GROUP:
+		buftype = XFS_BLFT_GDQUOT_BUF;
+		break;
+	case XFS_DQ_PROJ:
+		buftype = XFS_BLFT_PDQUOT_BUF;
+		break;
+	}
+	xfs_trans_buf_set_type(sc->tp, bp, buftype);
+	xfs_trans_log_buf(sc->tp, bp, 0, BBTOB(bp->b_length) - 1);
+	return xfs_trans_roll(&sc->tp);
+}
+
+/* Repair quota's data fork. */
+STATIC int
+xrep_quota_data_fork(
+	struct xfs_scrub	*sc,
+	uint			dqtype)
+{
+	struct xfs_bmbt_irec	irec = { 0 };
+	struct xfs_iext_cursor	icur;
+	struct xfs_quotainfo	*qi = sc->mp->m_quotainfo;
+	struct xfs_ifork	*ifp;
+	struct xfs_buf		*bp;
+	struct xfs_dqblk	*d;
+	xfs_dqid_t		id;
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
+	ifp = XFS_IFORK_PTR(sc->ip, XFS_DATA_FORK);
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
+	}
+	if (truncate) {
+		error = xfs_itruncate_extents(&sc->tp, sc->ip, XFS_DATA_FORK,
+				max_dqid_off * sc->mp->m_sb.sb_blocksize);
+		if (error)
+			goto out;
+	}
+
+	/* Now go fix anything that fails the verifiers. */
+	for_each_xfs_iext(ifp, &icur, &irec) {
+		for (fsbno = irec.br_startblock, off = irec.br_startoff;
+		     fsbno < irec.br_startblock + irec.br_blockcount;
+		     fsbno += XFS_DQUOT_CLUSTER_SIZE_FSB,
+				off += XFS_DQUOT_CLUSTER_SIZE_FSB) {
+			id = off * qi->qi_dqperchunk;
+			error = xfs_trans_read_buf(sc->mp, sc->tp,
+					sc->mp->m_ddev_targp,
+					XFS_FSB_TO_DADDR(sc->mp, fsbno),
+					qi->qi_dqchunklen,
+					0, &bp, &xfs_dquot_buf_ops);
+			if (error == 0) {
+				d = (struct xfs_dqblk *)bp->b_addr;
+				if (id == be32_to_cpu(d->dd_diskdq.d_id)) {
+					xfs_trans_brelse(sc->tp, bp);
+					continue;
+				}
+				error = -EFSCORRUPTED;
+				xfs_trans_brelse(sc->tp, bp);
+			}
+			if (error != -EFSBADCRC && error != -EFSCORRUPTED)
+				goto out;
+
+			/* Failed verifier, try again. */
+			error = xfs_trans_read_buf(sc->mp, sc->tp,
+					sc->mp->m_ddev_targp,
+					XFS_FSB_TO_DADDR(sc->mp, fsbno),
+					qi->qi_dqchunklen,
+					0, &bp, NULL);
+			if (error)
+				goto out;
+
+			/*
+			 * Fix the quota block, which will roll our transaction
+			 * and release bp.
+			 */
+			error = xrep_quota_block(sc, bp, dqtype, id);
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
+	uint			dqtype)
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
+	uint			dqtype;
+	int			error;
+
+	dqtype = xchk_quota_to_dqtype(sc);
+
+	/* Fix problematic data fork mappings. */
+	error = xrep_quota_data_fork(sc, dqtype);
+	if (error)
+		goto out;
+
+	/* Unlock quota inode; we play only with dquots from now on. */
+	xfs_iunlock(sc->ip, sc->ilock_flags);
+	sc->ilock_flags = 0;
+
+	/* Fix anything the dquot verifiers complain about. */
+	error = xrep_quota_problems(sc, dqtype);
+out:
+	return error;
+}
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 77b337fd9ba9..eb37829bc001 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -984,3 +984,59 @@ xrep_reset_perag_resv(
 out:
 	return error;
 }
+
+/*
+ * Repair the attr/data forks of a metadata inode.  The metadata inode must be
+ * pointed to by sc->ip and the ILOCK must be held.
+ */
+int
+xrep_metadata_inode_forks(
+	struct xfs_scrub	*sc)
+{
+	__u32			smtype;
+	__u32			smflags;
+	int			error;
+
+	smtype = sc->sm->sm_type;
+	smflags = sc->sm->sm_flags;
+
+	/* Let's see if the forks need repair. */
+	sc->sm->sm_flags &= ~XFS_SCRUB_FLAGS_OUT;
+	error = xchk_metadata_inode_forks(sc);
+	if (error || !xfs_scrub_needs_repair(sc->sm))
+		goto out;
+
+	xfs_trans_ijoin(sc->tp, sc->ip, 0);
+
+	/* Clear the reflink flag & attr forks that we shouldn't have. */
+	if (xfs_is_reflink_inode(sc->ip)) {
+		error = xfs_reflink_clear_inode_flag(sc->ip, &sc->tp);
+		if (error)
+			goto out;
+	}
+
+	if (xfs_inode_hasattr(sc->ip)) {
+		error = xrep_xattr_reset_btree(sc);
+		if (error)
+			goto out;
+	}
+
+	/* Repair the data fork. */
+	sc->sm->sm_type = XFS_SCRUB_TYPE_BMBTD;
+	error = xrep_bmap_data(sc);
+	sc->sm->sm_type = smtype;
+	if (error)
+		goto out;
+
+	/* Bail out if we still need repairs. */
+	sc->sm->sm_flags &= ~XFS_SCRUB_FLAGS_OUT;
+	error = xchk_metadata_inode_forks(sc);
+	if (error)
+		goto out;
+	if (xfs_scrub_needs_repair(sc->sm))
+		error = -EFSCORRUPTED;
+out:
+	sc->sm->sm_type = smtype;
+	sc->sm->sm_flags = smflags;
+	return error;
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index bd80770fb3c5..ba31c703cf19 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -55,6 +55,8 @@ int xrep_find_ag_btree_roots(struct xfs_scrub *sc, struct xfs_buf *agf_bp,
 void xrep_force_quotacheck(struct xfs_scrub *sc, uint dqtype);
 int xrep_ino_dqattach(struct xfs_scrub *sc);
 int xrep_reset_perag_resv(struct xfs_scrub *sc);
+int xrep_xattr_reset_btree(struct xfs_scrub *sc);
+int xrep_metadata_inode_forks(struct xfs_scrub *sc);
 
 /* Metadata repairers */
 
@@ -71,6 +73,11 @@ int xrep_bmap_data(struct xfs_scrub *sc);
 int xrep_bmap_attr(struct xfs_scrub *sc);
 int xrep_symlink(struct xfs_scrub *sc);
 int xrep_xattr(struct xfs_scrub *sc);
+#ifdef CONFIG_XFS_QUOTA
+int xrep_quota(struct xfs_scrub *sc);
+#else
+# define xrep_quota			xrep_notsupported
+#endif /* CONFIG_XFS_QUOTA */
 
 #else
 
@@ -113,6 +120,7 @@ xrep_reset_perag_resv(
 #define xrep_bmap_attr			xrep_notsupported
 #define xrep_symlink			xrep_notsupported
 #define xrep_xattr			xrep_notsupported
+#define xrep_quota			xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index b93b03e4dfca..e08f588d518f 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -333,19 +333,19 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
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
 };
 
@@ -526,9 +526,8 @@ xfs_scrub_metadata(
 		if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_FORCE_SCRUB_REPAIR))
 			sc.sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
 
-		needs_fix = (sc.sm->sm_flags & (XFS_SCRUB_OFLAG_CORRUPT |
-						XFS_SCRUB_OFLAG_XCORRUPT |
-						XFS_SCRUB_OFLAG_PREEN));
+		needs_fix = xfs_scrub_needs_repair(sc.sm);
+
 		/*
 		 * If userspace asked for a repair but it wasn't necessary,
 		 * report that back to userspace.
