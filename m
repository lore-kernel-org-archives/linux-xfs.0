Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:52344 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753442AbeE3TcK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 May 2018 15:32:10 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w4UJPY3r120233
        for <linux-xfs@vger.kernel.org>; Wed, 30 May 2018 19:32:10 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2j9x4h93b4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 30 May 2018 19:32:10 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w4UJW9M9004631
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 30 May 2018 19:32:09 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w4UJW8CC018730
        for <linux-xfs@vger.kernel.org>; Wed, 30 May 2018 19:32:09 GMT
Subject: [PATCH 13/14] xfs: repair quotas
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 30 May 2018 12:32:01 -0700
Message-ID: <152770872185.11611.1762776552892475089.stgit@magnolia>
In-Reply-To: <152770863951.11611.5866814627357136911.stgit@magnolia>
References: <152770863951.11611.5866814627357136911.stgit@magnolia>
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
 fs/xfs/scrub/common.h       |    8 +
 fs/xfs/scrub/quota.c        |    2 
 fs/xfs/scrub/quota_repair.c |  355 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.c       |   58 +++++++
 fs/xfs/scrub/repair.h       |    8 +
 fs/xfs/scrub/scrub.c        |   11 +
 fs/xfs/scrub/scrub.h        |    1 
 9 files changed, 438 insertions(+), 8 deletions(-)
 create mode 100644 fs/xfs/scrub/quota_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 5bc7e2deacbd..0018ba84944d 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -185,5 +185,6 @@ xfs-y				+= $(addprefix scrub/, \
 				   rmap_repair.o \
 				   symlink_repair.o \
 				   )
+xfs-$(CONFIG_XFS_QUOTA)		+= scrub/quota_repair.o
 endif
 endif
diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
index c7a50fd8f0f5..d66855860b7f 100644
--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -360,7 +360,7 @@ xfs_repair_xattr_recover(
 }
 
 /* Free all the attribute fork blocks and delete the fork. */
-STATIC int
+int
 xfs_repair_xattr_zap(
 	struct xfs_scrub_context	*sc)
 {
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 76bb2d1d808c..235c91065ad5 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -152,6 +152,14 @@ static inline bool xfs_scrub_skip_xref(struct xfs_scrub_metadata *sm)
 			       XFS_SCRUB_OFLAG_XCORRUPT);
 }
 
+/* Do we need to invoke the repair tool? */
+static inline bool xfs_scrub_needs_repair(struct xfs_scrub_metadata *sm)
+{
+	return sm->sm_flags & (XFS_SCRUB_OFLAG_CORRUPT |
+			       XFS_SCRUB_OFLAG_XCORRUPT |
+			       XFS_SCRUB_OFLAG_PREEN);
+}
+
 int xfs_scrub_metadata_inode_forks(struct xfs_scrub_context *sc);
 int xfs_scrub_ilock_inverted(struct xfs_inode *ip, uint lock_mode);
 
diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index 15ae4d23d6ac..64776257fd88 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -43,7 +43,7 @@
 #include "scrub/trace.h"
 
 /* Convert a scrub type code to a DQ flag, or return 0 if error. */
-static inline uint
+uint
 xfs_scrub_quota_to_dqtype(
 	struct xfs_scrub_context	*sc)
 {
diff --git a/fs/xfs/scrub/quota_repair.c b/fs/xfs/scrub/quota_repair.c
new file mode 100644
index 000000000000..68b7082af30a
--- /dev/null
+++ b/fs/xfs/scrub/quota_repair.c
@@ -0,0 +1,355 @@
+/*
+ * Copyright (C) 2018 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
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
+/* Quota repair. */
+
+struct xfs_repair_quota_info {
+	struct xfs_scrub_context	*sc;
+	bool				need_quotacheck;
+};
+
+/* Scrub the fields in an individual quota item. */
+STATIC int
+xfs_repair_quota_item(
+	struct xfs_dquot		*dq,
+	uint				dqtype,
+	void				*priv)
+{
+	struct xfs_repair_quota_info	*rqi = priv;
+	struct xfs_scrub_context	*sc = rqi->sc;
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_disk_dquot		*d = &dq->q_core;
+	unsigned long long		bsoft;
+	unsigned long long		isoft;
+	unsigned long long		rsoft;
+	unsigned long long		bhard;
+	unsigned long long		ihard;
+	unsigned long long		rhard;
+	unsigned long long		bcount;
+	unsigned long long		icount;
+	unsigned long long		rcount;
+	xfs_ino_t			fs_icount;
+	bool				dirty = false;
+	int				error;
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
+xfs_repair_quota_fix_timer(
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
+xfs_repair_quota_block(
+	struct xfs_scrub_context	*sc,
+	struct xfs_buf			*bp,
+	uint				dqtype,
+	xfs_dqid_t			id)
+{
+	struct xfs_dqblk		*d = (struct xfs_dqblk *)bp->b_addr;
+	struct xfs_disk_dquot		*ddq;
+	struct xfs_quotainfo		*qi = sc->mp->m_quotainfo;
+	enum xfs_blft			buftype = 0;
+	int				i;
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
+		xfs_repair_quota_fix_timer(ddq->d_blk_softlimit,
+				ddq->d_bcount, &ddq->d_btimer,
+				qi->qi_btimelimit);
+		xfs_repair_quota_fix_timer(ddq->d_ino_softlimit,
+				ddq->d_icount, &ddq->d_itimer,
+				qi->qi_itimelimit);
+		xfs_repair_quota_fix_timer(ddq->d_rtb_softlimit,
+				ddq->d_rtbcount, &ddq->d_rtbtimer,
+				qi->qi_rtbtimelimit);
+
+		if (xfs_sb_version_hascrc(&sc->mp->m_sb)) {
+			uuid_copy(&d->dd_uuid, &sc->mp->m_sb.sb_meta_uuid);
+			xfs_update_cksum((char *)d, sizeof(struct xfs_dqblk),
+					 XFS_DQUOT_CRC_OFF);
+		} else {
+			memset(&d->dd_uuid, 0, sizeof(d->dd_uuid));
+			d->dd_lsn = 0;
+			d->dd_crc = 0;
+		}
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
+xfs_repair_quota_data_fork(
+	struct xfs_scrub_context	*sc,
+	uint				dqtype)
+{
+	struct xfs_bmbt_irec		irec = { 0 };
+	struct xfs_iext_cursor		icur;
+	struct xfs_scrub_metadata	*real_sm = sc->sm;
+	struct xfs_quotainfo		*qi = sc->mp->m_quotainfo;
+	struct xfs_ifork		*ifp;
+	struct xfs_buf			*bp;
+	struct xfs_dqblk		*d;
+	xfs_dqid_t			id;
+	xfs_fileoff_t			max_dqid_off;
+	xfs_fileoff_t			off;
+	xfs_fsblock_t			fsbno;
+	bool				truncate = false;
+	int				error = 0;
+
+	error = xfs_repair_metadata_inode_forks(sc);
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
+				if (id == be32_to_cpu(d->dd_diskdq.d_id))
+					continue;
+				error = -EFSCORRUPTED;
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
+			error = xfs_repair_quota_block(sc, bp, dqtype, id);
+		}
+	}
+
+out:
+	sc->sm = real_sm;
+	return error;
+}
+
+/* Repair all of a quota type's items. */
+int
+xfs_repair_quota(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_repair_quota_info	rqi;
+	struct xfs_mount		*mp = sc->mp;
+	uint				dqtype;
+	int				error = 0;
+
+	dqtype = xfs_scrub_quota_to_dqtype(sc);
+
+	error = xfs_repair_quota_data_fork(sc, dqtype);
+	if (error)
+		goto out;
+
+	/*
+	 * Go fix anything in the quota items that we could have been mad
+	 * about.  Now that we've checked the quota inode data fork we have to
+	 * drop ILOCK_EXCL to use the regular dquot functions.
+	 */
+	xfs_iunlock(sc->ip, sc->ilock_flags);
+	sc->ilock_flags = 0;
+	rqi.sc = sc;
+	rqi.need_quotacheck = false;
+	error = xfs_qm_dqiterate(mp, dqtype, xfs_repair_quota_item, &rqi);
+	if (error)
+		goto out_relock;
+
+	/* Make a quotacheck happen. */
+	if (rqi.need_quotacheck)
+		xfs_repair_force_quotacheck(sc, dqtype);
+
+out_relock:
+	sc->ilock_flags = XFS_ILOCK_EXCL;
+	xfs_ilock(sc->ip, sc->ilock_flags);
+out:
+	return error;
+}
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 4b5d599d53b9..6143a159da88 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -45,6 +45,8 @@
 #include "xfs_quota.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
+#include "xfs_attr.h"
+#include "xfs_reflink.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -1265,3 +1267,59 @@ xfs_repair_grab_all_ag_headers(
 
 	return error;
 }
+
+/*
+ * Repair the attr/data forks of a metadata inode.  The metadata inode must be
+ * pointed to by sc->ip and the ILOCK must be held.
+ */
+int
+xfs_repair_metadata_inode_forks(
+	struct xfs_scrub_context	*sc)
+{
+	__u32				smtype;
+	__u32				smflags;
+	int				error;
+
+	smtype = sc->sm->sm_type;
+	smflags = sc->sm->sm_flags;
+
+	/* Let's see if the forks need repair. */
+	sc->sm->sm_flags &= ~XFS_SCRUB_FLAGS_OUT;
+	error = xfs_scrub_metadata_inode_forks(sc);
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
+		error = xfs_repair_xattr_zap(sc);
+		if (error)
+			goto out;
+	}
+
+	/* Repair the data fork. */
+	sc->sm->sm_type = XFS_SCRUB_TYPE_BMBTD;
+	error = xfs_repair_bmap_data(sc);
+	sc->sm->sm_type = smtype;
+	if (error)
+		goto out;
+
+	/* Bail out if we still need repairs. */
+	sc->sm->sm_flags &= ~XFS_SCRUB_FLAGS_OUT;
+	error = xfs_scrub_metadata_inode_forks(sc);
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
index 393adfdc255e..88be83752956 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -108,6 +108,8 @@ int xfs_repair_fs_thaw(struct xfs_scrub_context *sc);
 void xfs_repair_frozen_iput(struct xfs_scrub_context *sc, struct xfs_inode *ip);
 int xfs_repair_grab_all_ag_headers(struct xfs_scrub_context *sc);
 int xfs_repair_rmapbt_setup(struct xfs_scrub_context *sc, struct xfs_inode *ip);
+int xfs_repair_xattr_zap(struct xfs_scrub_context *sc);
+int xfs_repair_metadata_inode_forks(struct xfs_scrub_context *sc);
 
 /* Metadata repairers */
 
@@ -125,6 +127,11 @@ int xfs_repair_bmap_data(struct xfs_scrub_context *sc);
 int xfs_repair_bmap_attr(struct xfs_scrub_context *sc);
 int xfs_repair_symlink(struct xfs_scrub_context *sc);
 int xfs_repair_xattr(struct xfs_scrub_context *sc);
+#ifdef CONFIG_XFS_QUOTA
+int xfs_repair_quota(struct xfs_scrub_context *sc);
+#else
+# define xfs_repair_quota		xfs_repair_notsupported
+#endif /* CONFIG_XFS_QUOTA */
 
 #else
 
@@ -180,6 +187,7 @@ static inline int xfs_repair_rmapbt_setup(
 #define xfs_repair_bmap_attr		xfs_repair_notsupported
 #define xfs_repair_symlink		xfs_repair_notsupported
 #define xfs_repair_xattr		xfs_repair_notsupported
+#define xfs_repair_quota		xfs_repair_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index a306a31f46cc..6ca3da5ee2ca 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -349,19 +349,19 @@ static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
 		.type	= ST_FS,
 		.setup	= xfs_scrub_setup_quota,
 		.scrub	= xfs_scrub_quota,
-		.repair	= xfs_repair_notsupported,
+		.repair	= xfs_repair_quota,
 	},
 	[XFS_SCRUB_TYPE_GQUOTA] = {	/* group quota */
 		.type	= ST_FS,
 		.setup	= xfs_scrub_setup_quota,
 		.scrub	= xfs_scrub_quota,
-		.repair	= xfs_repair_notsupported,
+		.repair	= xfs_repair_quota,
 	},
 	[XFS_SCRUB_TYPE_PQUOTA] = {	/* project quota */
 		.type	= ST_FS,
 		.setup	= xfs_scrub_setup_quota,
 		.scrub	= xfs_scrub_quota,
-		.repair	= xfs_repair_notsupported,
+		.repair	= xfs_repair_quota,
 	},
 };
 
@@ -557,9 +557,8 @@ xfs_scrub_metadata(
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
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 50c6d7917f5f..08f10ab36e6b 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -158,5 +158,6 @@ void xfs_scrub_xref_is_used_rt_space(struct xfs_scrub_context *sc,
 
 bool xfs_scrub_xattr_set_map(struct xfs_scrub_context *sc, unsigned long *map,
 		unsigned int start, unsigned int len);
+uint xfs_scrub_quota_to_dqtype(struct xfs_scrub_context *sc);
 
 #endif	/* __XFS_SCRUB_SCRUB_H__ */

