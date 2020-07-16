Return-Path: <SRS0=b91c=A3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08BEBC433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 06:48:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8CAD2070E
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 06:48:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GPh6up9A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725921AbgGPGsY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jul 2020 02:48:24 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:55684 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728036AbgGPGsX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jul 2020 02:48:23 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06G6mFVK084288
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:48:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=EpQL1UV45baZXiItoB/BBaMs2xbK881YQRm+sQD14b0=;
 b=GPh6up9Azug0xH2f5oHlvO5W6/gnJDFZoBd6xDUrxUhQGOutxnZ9r4oK0CJ6+ZyuiLLt
 jBAP39PqafnvXUpM+RXUXyJEKIAQ/bMfGlYDU9FVt/pKmfKwILbDxJtcy0G/QWHvUc+M
 SIatPlek5TukW21qhZHRJIS+b8YzHjl/siqE4NsHKdOtX6Ve4GGP7PLnpQxDUtt/tQOU
 +k8ZtytIDJk2biMkpU5eCGviCavNr8chSnkeVuEfmOMXRIHKESdz3ek/fURtz+pHUXT8
 LQ9av7zM9zDyLuI3R/UDfS6rlX9Hv7TO1BGRLOXudbC7wfEZYKKOaGFEimwK5MPJrgGH XQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3274urfhm2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:48:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06G6giTT024530
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:46:19 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 327qc2jrkx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:46:18 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06G6kIGZ028817
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:46:18 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jul 2020 23:46:17 -0700
Subject: [PATCH 09/11] xfs: create xfs_dqtype_t to represent quota types
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 15 Jul 2020 23:46:16 -0700
Message-ID: <159488197642.3813063.4673664984532713595.stgit@magnolia>
In-Reply-To: <159488191927.3813063.6443979621452250872.stgit@magnolia>
References: <159488191927.3813063.6443979621452250872.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 spamscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007160050
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 suspectscore=1 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007160051
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a new type (xfs_dqtype_t) to represent the type of an incore
dquot (user, group, project, or none).  Rename the incore dquot's
dq_flags field to q_type.

This allows us to replace all the "uint type" arguments to the quota
functions with "xfs_dqtype_t type", to make it obvious when we're
passing a quota type argument into a function.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dquot_buf.c  |    2 +-
 fs/xfs/libxfs/xfs_format.h     |    9 +++++++++
 fs/xfs/libxfs/xfs_quota_defs.h |   27 ++++++++++++---------------
 fs/xfs/scrub/quota.c           |    8 ++++----
 fs/xfs/scrub/repair.c          |    4 ++--
 fs/xfs/scrub/repair.h          |    4 +++-
 fs/xfs/xfs_dquot.c             |   37 +++++++++++++++++++------------------
 fs/xfs/xfs_dquot.h             |   33 +++++++++++++++++----------------
 fs/xfs/xfs_iomap.c             |   24 ++++++++++++------------
 fs/xfs/xfs_qm.c                |   22 +++++++++++-----------
 fs/xfs/xfs_qm.h                |   26 ++++++++++++++++----------
 fs/xfs/xfs_qm_syscalls.c       |    8 ++++----
 fs/xfs/xfs_quota.h             |    4 ++--
 fs/xfs/xfs_quotaops.c          |    2 +-
 fs/xfs/xfs_trace.h             |   21 +++++++++++++++------
 15 files changed, 128 insertions(+), 103 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index 450147df3042..75c164ed141c 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -109,7 +109,7 @@ xfs_dqblk_repair(
 	struct xfs_mount	*mp,
 	struct xfs_dqblk	*dqb,
 	xfs_dqid_t		id,
-	uint			type)
+	xfs_dqtype_t		type)
 {
 	/*
 	 * Typically, a repair is only requested by quotacheck.
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 5d5e0f5eda97..0fa969f6202c 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1149,6 +1149,15 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 #define XFS_DQUOT_MAGIC		0x4451		/* 'DQ' */
 #define XFS_DQUOT_VERSION	(uint8_t)0x01	/* latest version number */
 
+#define XFS_DQTYPE_USER		0x01		/* user dquot record */
+#define XFS_DQTYPE_PROJ		0x02		/* project dquot record */
+#define XFS_DQTYPE_GROUP	0x04		/* group dquot record */
+
+/* bitmask to determine if this is a user/group/project dquot */
+#define XFS_DQTYPE_REC_MASK	(XFS_DQTYPE_USER | \
+				 XFS_DQTYPE_PROJ | \
+				 XFS_DQTYPE_GROUP)
+
 /*
  * This is the main portion of the on-disk representation of quota information
  * for a user.  We pad this with some more expansion room to construct the on
diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
index baf6c4ad88af..076bdc7037ee 100644
--- a/fs/xfs/libxfs/xfs_quota_defs.h
+++ b/fs/xfs/libxfs/xfs_quota_defs.h
@@ -18,23 +18,20 @@
 typedef uint64_t	xfs_qcnt_t;
 typedef uint16_t	xfs_qwarncnt_t;
 
-/*
- * flags for q_flags field in the dquot.
- */
-#define XFS_DQTYPE_USER		0x0001		/* a user quota */
-#define XFS_DQTYPE_PROJ		0x0002		/* project quota */
-#define XFS_DQTYPE_GROUP	0x0004		/* a group quota */
-#define XFS_DQFLAG_DIRTY	0x0008		/* dquot is dirty */
-#define XFS_DQFLAG_FREEING	0x0010		/* dquot is being torn down */
+typedef uint8_t		xfs_dqtype_t;
 
-#define XFS_DQTYPE_REC_MASK	(XFS_DQTYPE_USER | \
-				 XFS_DQTYPE_PROJ | \
-				 XFS_DQTYPE_GROUP)
-
-#define XFS_DQFLAG_STRINGS \
+#define XFS_DQTYPE_STRINGS \
 	{ XFS_DQTYPE_USER,	"USER" }, \
 	{ XFS_DQTYPE_PROJ,	"PROJ" }, \
-	{ XFS_DQTYPE_GROUP,	"GROUP" }, \
+	{ XFS_DQTYPE_GROUP,	"GROUP" }
+
+/*
+ * flags for q_flags field in the dquot.
+ */
+#define XFS_DQFLAG_DIRTY	(1 << 0)	/* dquot is dirty */
+#define XFS_DQFLAG_FREEING	(1 << 1)	/* dquot is being torn down */
+
+#define XFS_DQFLAG_STRINGS \
 	{ XFS_DQFLAG_DIRTY,	"DIRTY" }, \
 	{ XFS_DQFLAG_FREEING,	"FREEING" }
 
@@ -144,6 +141,6 @@ extern xfs_failaddr_t xfs_dqblk_verify(struct xfs_mount *mp,
 		struct xfs_dqblk *dqb, xfs_dqid_t id);
 extern int xfs_calc_dquots_per_chunk(unsigned int nbblks);
 extern void xfs_dqblk_repair(struct xfs_mount *mp, struct xfs_dqblk *dqb,
-		xfs_dqid_t id, uint type);
+		xfs_dqid_t id, xfs_dqtype_t type);
 
 #endif	/* __XFS_QUOTA_H__ */
diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index 1db07485f148..e34ca20ae8e4 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -18,7 +18,7 @@
 #include "scrub/common.h"
 
 /* Convert a scrub type code to a DQ flag, or return 0 if error. */
-static inline uint
+static inline xfs_dqtype_t
 xchk_quota_to_dqtype(
 	struct xfs_scrub	*sc)
 {
@@ -40,7 +40,7 @@ xchk_setup_quota(
 	struct xfs_scrub	*sc,
 	struct xfs_inode	*ip)
 {
-	uint			dqtype;
+	xfs_dqtype_t		dqtype;
 	int			error;
 
 	if (!XFS_IS_QUOTA_RUNNING(sc->mp) || !XFS_IS_QUOTA_ON(sc->mp))
@@ -73,7 +73,7 @@ struct xchk_quota_info {
 STATIC int
 xchk_quota_item(
 	struct xfs_dquot	*dq,
-	uint			dqtype,
+	xfs_dqtype_t		dqtype,
 	void			*priv)
 {
 	struct xchk_quota_info	*sqi = priv;
@@ -214,7 +214,7 @@ xchk_quota(
 	struct xchk_quota_info	sqi;
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_quotainfo	*qi = mp->m_quotainfo;
-	uint			dqtype;
+	xfs_dqtype_t		dqtype;
 	int			error = 0;
 
 	dqtype = xchk_quota_to_dqtype(sc);
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 074651896586..25e86c71e7b9 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -899,11 +899,11 @@ xrep_find_ag_btree_roots(
 void
 xrep_force_quotacheck(
 	struct xfs_scrub	*sc,
-	uint			dqtype)
+	xfs_dqtype_t		type)
 {
 	uint			flag;
 
-	flag = xfs_quota_chkd_flag(dqtype);
+	flag = xfs_quota_chkd_flag(type);
 	if (!(flag & sc->mp->m_qflags))
 		return;
 
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 04a47d45605b..fe77de01abe0 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -6,6 +6,8 @@
 #ifndef __XFS_SCRUB_REPAIR_H__
 #define __XFS_SCRUB_REPAIR_H__
 
+#include "xfs_quota_defs.h"
+
 static inline int xrep_notsupported(struct xfs_scrub *sc)
 {
 	return -EOPNOTSUPP;
@@ -49,7 +51,7 @@ struct xrep_find_ag_btree {
 
 int xrep_find_ag_btree_roots(struct xfs_scrub *sc, struct xfs_buf *agf_bp,
 		struct xrep_find_ag_btree *btree_info, struct xfs_buf *agfl_bp);
-void xrep_force_quotacheck(struct xfs_scrub *sc, uint dqtype);
+void xrep_force_quotacheck(struct xfs_scrub *sc, xfs_dqtype_t type);
 int xrep_ino_dqattach(struct xfs_scrub *sc);
 
 /* Metadata repairers */
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index b46a9e63b286..c37110c09423 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -158,7 +158,7 @@ xfs_qm_init_dquot_blk(
 	struct xfs_trans	*tp,
 	struct xfs_mount	*mp,
 	xfs_dqid_t		id,
-	uint			type,
+	xfs_dqtype_t		type,
 	struct xfs_buf		*bp)
 {
 	struct xfs_quotainfo	*q = mp->m_quotainfo;
@@ -273,7 +273,7 @@ xfs_dquot_disk_alloc(
 	struct xfs_trans	*tp = *tpp;
 	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_buf		*bp;
-	uint			qtype = xfs_dquot_type(dqp);
+	xfs_dqtype_t		qtype = xfs_dquot_type(dqp);
 	struct xfs_inode	*quotip = xfs_quota_inode(mp, qtype);
 	int			nmaps = 1;
 	int			error;
@@ -365,7 +365,7 @@ xfs_dquot_disk_read(
 {
 	struct xfs_bmbt_irec	map;
 	struct xfs_buf		*bp;
-	uint			qtype = xfs_dquot_type(dqp);
+	xfs_dqtype_t		qtype = xfs_dquot_type(dqp);
 	struct xfs_inode	*quotip = xfs_quota_inode(mp, qtype);
 	uint			lock_mode;
 	int			nmaps = 1;
@@ -424,13 +424,13 @@ STATIC struct xfs_dquot *
 xfs_dquot_alloc(
 	struct xfs_mount	*mp,
 	xfs_dqid_t		id,
-	uint			type)
+	xfs_dqtype_t		type)
 {
 	struct xfs_dquot	*dqp;
 
 	dqp = kmem_zone_zalloc(xfs_qm_dqzone, 0);
 
-	dqp->dq_flags = type;
+	dqp->q_type = type;
 	dqp->q_id = id;
 	dqp->q_mount = mp;
 	INIT_LIST_HEAD(&dqp->q_lru);
@@ -498,6 +498,7 @@ xfs_dquot_from_disk(
 	}
 
 	/* copy everything from disk dquot to the incore dquot */
+	dqp->q_type = ddqp->d_flags;
 	dqp->q_blk.hardlimit = be64_to_cpu(ddqp->d_blk_hardlimit);
 	dqp->q_blk.softlimit = be64_to_cpu(ddqp->d_blk_softlimit);
 	dqp->q_ino.hardlimit = be64_to_cpu(ddqp->d_ino_hardlimit);
@@ -538,7 +539,7 @@ xfs_dquot_to_disk(
 {
 	ddqp->d_magic = cpu_to_be16(XFS_DQUOT_MAGIC);
 	ddqp->d_version = XFS_DQUOT_VERSION;
-	ddqp->d_flags = dqp->dq_flags & XFS_DQTYPE_REC_MASK;
+	ddqp->d_flags = dqp->q_type;
 	ddqp->d_id = cpu_to_be32(dqp->q_id);
 	ddqp->d_pad0 = 0;
 	ddqp->d_pad = 0;
@@ -609,7 +610,7 @@ static int
 xfs_qm_dqread(
 	struct xfs_mount	*mp,
 	xfs_dqid_t		id,
-	uint			type,
+	xfs_dqtype_t		type,
 	bool			can_alloc,
 	struct xfs_dquot	**dqpp)
 {
@@ -657,7 +658,7 @@ xfs_qm_dqread(
 static int
 xfs_dq_get_next_id(
 	struct xfs_mount	*mp,
-	uint			type,
+	xfs_dqtype_t		type,
 	xfs_dqid_t		*id)
 {
 	struct xfs_inode	*quotip = xfs_quota_inode(mp, type);
@@ -781,7 +782,7 @@ xfs_qm_dqget_cache_insert(
 static int
 xfs_qm_dqget_checks(
 	struct xfs_mount	*mp,
-	uint			type)
+	xfs_dqtype_t		type)
 {
 	if (WARN_ON_ONCE(!XFS_IS_QUOTA_RUNNING(mp)))
 		return -ESRCH;
@@ -813,7 +814,7 @@ int
 xfs_qm_dqget(
 	struct xfs_mount	*mp,
 	xfs_dqid_t		id,
-	uint			type,
+	xfs_dqtype_t		type,
 	bool			can_alloc,
 	struct xfs_dquot	**O_dqpp)
 {
@@ -863,7 +864,7 @@ int
 xfs_qm_dqget_uncached(
 	struct xfs_mount	*mp,
 	xfs_dqid_t		id,
-	uint			type,
+	xfs_dqtype_t		type,
 	struct xfs_dquot	**dqpp)
 {
 	int			error;
@@ -879,7 +880,7 @@ xfs_qm_dqget_uncached(
 xfs_dqid_t
 xfs_qm_id_for_quotatype(
 	struct xfs_inode	*ip,
-	uint			type)
+	xfs_dqtype_t		type)
 {
 	switch (type) {
 	case XFS_DQTYPE_USER:
@@ -901,7 +902,7 @@ xfs_qm_id_for_quotatype(
 int
 xfs_qm_dqget_inode(
 	struct xfs_inode	*ip,
-	uint			type,
+	xfs_dqtype_t		type,
 	bool			can_alloc,
 	struct xfs_dquot	**O_dqpp)
 {
@@ -987,7 +988,7 @@ int
 xfs_qm_dqget_next(
 	struct xfs_mount	*mp,
 	xfs_dqid_t		id,
-	uint			type,
+	xfs_dqtype_t		type,
 	struct xfs_dquot	**dqpp)
 {
 	struct xfs_dquot	*dqp;
@@ -1122,7 +1123,7 @@ static xfs_failaddr_t
 xfs_qm_dqflush_check(
 	struct xfs_dquot	*dqp)
 {
-	__u8			type = dqp->dq_flags & XFS_DQTYPE_REC_MASK;
+	xfs_dqtype_t		type = xfs_dquot_type(dqp);
 
 	if (type != XFS_DQTYPE_USER &&
 	    type != XFS_DQTYPE_GROUP &&
@@ -1317,7 +1318,7 @@ xfs_qm_exit(void)
 int
 xfs_qm_dqiterate(
 	struct xfs_mount	*mp,
-	uint			dqtype,
+	xfs_dqtype_t		type,
 	xfs_qm_dqiterate_fn	iter_fn,
 	void			*priv)
 {
@@ -1326,13 +1327,13 @@ xfs_qm_dqiterate(
 	int			error;
 
 	do {
-		error = xfs_qm_dqget_next(mp, id, dqtype, &dq);
+		error = xfs_qm_dqget_next(mp, id, type, &dq);
 		if (error == -ENOENT)
 			return 0;
 		if (error)
 			return error;
 
-		error = iter_fn(dq, dqtype, priv);
+		error = iter_fn(dq, type, priv);
 		id = dq->q_id;
 		xfs_qm_dqput(dq);
 	} while (error == 0 && id != 0);
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 81ba614439bd..282a65da93c7 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -60,7 +60,7 @@ struct xfs_dquot_res {
 struct xfs_dquot {
 	struct list_head	q_lru;
 	struct xfs_mount	*q_mount;
-	uint8_t			dq_flags;
+	xfs_dqtype_t		q_type;
 	uint16_t		q_flags;
 	xfs_dqid_t		q_id;
 	uint			q_nrefs;
@@ -131,10 +131,10 @@ static inline void xfs_dqunlock(struct xfs_dquot *dqp)
 static inline int
 xfs_dquot_type(const struct xfs_dquot *dqp)
 {
-	return dqp->dq_flags & XFS_DQTYPE_REC_MASK;
+	return dqp->q_type & XFS_DQTYPE_REC_MASK;
 }
 
-static inline int xfs_this_quota_on(struct xfs_mount *mp, int type)
+static inline int xfs_this_quota_on(struct xfs_mount *mp, xfs_dqtype_t type)
 {
 	switch (type) {
 	case XFS_DQTYPE_USER:
@@ -148,7 +148,9 @@ static inline int xfs_this_quota_on(struct xfs_mount *mp, int type)
 	}
 }
 
-static inline struct xfs_dquot *xfs_inode_dquot(struct xfs_inode *ip, int type)
+static inline struct xfs_dquot *xfs_inode_dquot(
+	struct xfs_inode	*ip,
+	xfs_dqtype_t		type)
 {
 	switch (type) {
 	case XFS_DQTYPE_USER:
@@ -205,18 +207,17 @@ void		xfs_qm_dqunpin_wait(struct xfs_dquot *dqp);
 void		xfs_qm_adjust_dqtimers(struct xfs_dquot *d);
 void		xfs_qm_adjust_dqlimits(struct xfs_dquot *d);
 xfs_dqid_t	xfs_qm_id_for_quotatype(struct xfs_inode *ip,
-				uint type);
+				xfs_dqtype_t type);
 int		xfs_qm_dqget(struct xfs_mount *mp, xfs_dqid_t id,
-					uint type, bool can_alloc,
-					struct xfs_dquot **dqpp);
-int		xfs_qm_dqget_inode(struct xfs_inode *ip, uint type,
-						bool can_alloc,
-						struct xfs_dquot **dqpp);
+				xfs_dqtype_t type, bool can_alloc,
+				struct xfs_dquot **dqpp);
+int		xfs_qm_dqget_inode(struct xfs_inode *ip, xfs_dqtype_t type,
+				bool can_alloc, struct xfs_dquot **dqpp);
 int		xfs_qm_dqget_next(struct xfs_mount *mp, xfs_dqid_t id,
-					uint type, struct xfs_dquot **dqpp);
+				xfs_dqtype_t type, struct xfs_dquot **dqpp);
 int		xfs_qm_dqget_uncached(struct xfs_mount *mp,
-						xfs_dqid_t id, uint type,
-						struct xfs_dquot **dqpp);
+				xfs_dqid_t id, xfs_dqtype_t type,
+				struct xfs_dquot **dqpp);
 void		xfs_qm_dqput(struct xfs_dquot *dqp);
 
 void		xfs_dqlock2(struct xfs_dquot *, struct xfs_dquot *);
@@ -231,9 +232,9 @@ static inline struct xfs_dquot *xfs_qm_dqhold(struct xfs_dquot *dqp)
 	return dqp;
 }
 
-typedef int (*xfs_qm_dqiterate_fn)(struct xfs_dquot *dq, uint dqtype,
-		void *priv);
-int xfs_qm_dqiterate(struct xfs_mount *mp, uint dqtype,
+typedef int (*xfs_qm_dqiterate_fn)(struct xfs_dquot *dq,
+		xfs_dqtype_t type, void *priv);
+int xfs_qm_dqiterate(struct xfs_mount *mp, xfs_dqtype_t type,
 		xfs_qm_dqiterate_fn iter_fn, void *priv);
 
 #endif /* __XFS_DQUOT_H__ */
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index d3dc4106a35c..0e3f62cde375 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -293,11 +293,11 @@ xfs_iomap_write_direct(
 
 STATIC bool
 xfs_quota_need_throttle(
-	struct xfs_inode *ip,
-	int type,
-	xfs_fsblock_t alloc_blocks)
+	struct xfs_inode	*ip,
+	xfs_dqtype_t		type,
+	xfs_fsblock_t		alloc_blocks)
 {
-	struct xfs_dquot *dq = xfs_inode_dquot(ip, type);
+	struct xfs_dquot	*dq = xfs_inode_dquot(ip, type);
 
 	if (!dq || !xfs_this_quota_on(ip->i_mount, type))
 		return false;
@@ -315,15 +315,15 @@ xfs_quota_need_throttle(
 
 STATIC void
 xfs_quota_calc_throttle(
-	struct xfs_inode *ip,
-	int type,
-	xfs_fsblock_t *qblocks,
-	int *qshift,
-	int64_t	*qfreesp)
+	struct xfs_inode	*ip,
+	xfs_dqtype_t		type,
+	xfs_fsblock_t		*qblocks,
+	int			*qshift,
+	int64_t			*qfreesp)
 {
-	int64_t freesp;
-	int shift = 0;
-	struct xfs_dquot *dq = xfs_inode_dquot(ip, type);
+	struct xfs_dquot	*dq = xfs_inode_dquot(ip, type);
+	int64_t			freesp;
+	int			shift = 0;
 
 	/* no dq, or over hi wmark, squash the prealloc completely */
 	if (!dq || dq->q_blk.reserved >= dq->q_prealloc_hi_wmark) {
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 47d4b6937c84..123757717e21 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -47,7 +47,7 @@ STATIC void	xfs_qm_dqfree_one(struct xfs_dquot *dqp);
 STATIC int
 xfs_qm_dquot_walk(
 	struct xfs_mount	*mp,
-	int			type,
+	xfs_dqtype_t		type,
 	int			(*execute)(struct xfs_dquot *dqp, void *data),
 	void			*data)
 {
@@ -250,7 +250,7 @@ STATIC int
 xfs_qm_dqattach_one(
 	struct xfs_inode	*ip,
 	xfs_dqid_t		id,
-	uint			type,
+	xfs_dqtype_t		type,
 	bool			doalloc,
 	struct xfs_dquot	**IO_idqpp)
 {
@@ -545,7 +545,7 @@ xfs_qm_shrink_count(
 STATIC void
 xfs_qm_set_defquota(
 	struct xfs_mount	*mp,
-	uint			type,
+	xfs_dqtype_t		type,
 	struct xfs_quotainfo	*qinf)
 {
 	struct xfs_dquot	*dqp;
@@ -575,7 +575,7 @@ xfs_qm_set_defquota(
 static void
 xfs_qm_init_timelimits(
 	struct xfs_mount	*mp,
-	uint			type)
+	xfs_dqtype_t		type)
 {
 	struct xfs_quotainfo	*qinf = mp->m_quotainfo;
 	struct xfs_def_quota	*defq;
@@ -823,10 +823,10 @@ xfs_qm_qino_alloc(
 
 STATIC void
 xfs_qm_reset_dqcounts(
-	xfs_mount_t	*mp,
-	xfs_buf_t	*bp,
-	xfs_dqid_t	id,
-	uint		type)
+	struct xfs_mount	*mp,
+	struct xfs_buf		*bp,
+	xfs_dqid_t		id,
+	xfs_dqtype_t		type)
 {
 	struct xfs_dqblk	*dqb;
 	int			j;
@@ -895,7 +895,7 @@ xfs_qm_reset_dqcounts_all(
 	xfs_dqid_t		firstid,
 	xfs_fsblock_t		bno,
 	xfs_filblks_t		blkcnt,
-	uint			type,
+	xfs_dqtype_t		type,
 	struct list_head	*buffer_list)
 {
 	struct xfs_buf		*bp;
@@ -961,7 +961,7 @@ STATIC int
 xfs_qm_reset_dqcounts_buf(
 	struct xfs_mount	*mp,
 	struct xfs_inode	*qip,
-	uint			type,
+	xfs_dqtype_t		type,
 	struct list_head	*buffer_list)
 {
 	struct xfs_bmbt_irec	*map;
@@ -1059,7 +1059,7 @@ xfs_qm_reset_dqcounts_buf(
 STATIC int
 xfs_qm_quotacheck_dqadjust(
 	struct xfs_inode	*ip,
-	uint			type,
+	xfs_dqtype_t		type,
 	xfs_qcnt_t		nblks,
 	xfs_qcnt_t		rtblks)
 {
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index fac6fa81f1fa..9c078c35d924 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -70,7 +70,7 @@ struct xfs_quotainfo {
 static inline struct radix_tree_root *
 xfs_dquot_tree(
 	struct xfs_quotainfo	*qi,
-	int			type)
+	xfs_dqtype_t		type)
 {
 	switch (type) {
 	case XFS_DQTYPE_USER:
@@ -86,9 +86,9 @@ xfs_dquot_tree(
 }
 
 static inline struct xfs_inode *
-xfs_quota_inode(xfs_mount_t *mp, uint dq_flags)
+xfs_quota_inode(struct xfs_mount *mp, xfs_dqtype_t type)
 {
-	switch (dq_flags) {
+	switch (type) {
 	case XFS_DQTYPE_USER:
 		return mp->m_quotainfo->qi_uquotaip;
 	case XFS_DQTYPE_GROUP:
@@ -142,17 +142,23 @@ extern void		xfs_qm_dqrele_all_inodes(struct xfs_mount *, uint);
 
 /* quota ops */
 extern int		xfs_qm_scall_trunc_qfiles(struct xfs_mount *, uint);
-extern int		xfs_qm_scall_getquota(struct xfs_mount *, xfs_dqid_t,
-					uint, struct qc_dqblk *);
-extern int		xfs_qm_scall_getquota_next(struct xfs_mount *,
-					xfs_dqid_t *, uint, struct qc_dqblk *);
-extern int		xfs_qm_scall_setqlim(struct xfs_mount *, xfs_dqid_t, uint,
-					struct qc_dqblk *);
+extern int		xfs_qm_scall_getquota(struct xfs_mount *mp,
+					xfs_dqid_t id,
+					xfs_dqtype_t type,
+					struct qc_dqblk *dst);
+extern int		xfs_qm_scall_getquota_next(struct xfs_mount *mp,
+					xfs_dqid_t *id,
+					xfs_dqtype_t type,
+					struct qc_dqblk *dst);
+extern int		xfs_qm_scall_setqlim(struct xfs_mount *mp,
+					xfs_dqid_t id,
+					xfs_dqtype_t type,
+					struct qc_dqblk *newlim);
 extern int		xfs_qm_scall_quotaon(struct xfs_mount *, uint);
 extern int		xfs_qm_scall_quotaoff(struct xfs_mount *, uint);
 
 static inline struct xfs_def_quota *
-xfs_get_defquota(struct xfs_quotainfo *qi, int type)
+xfs_get_defquota(struct xfs_quotainfo *qi, xfs_dqtype_t type)
 {
 	switch (type) {
 	case XFS_DQTYPE_USER:
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index f7dbc702e4d6..1c542b4a5220 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -495,7 +495,7 @@ int
 xfs_qm_scall_setqlim(
 	struct xfs_mount	*mp,
 	xfs_dqid_t		id,
-	uint			type,
+	xfs_dqtype_t		type,
 	struct qc_dqblk		*newlim)
 {
 	struct xfs_quotainfo	*q = mp->m_quotainfo;
@@ -634,7 +634,7 @@ xfs_qm_scall_setqlim(
 static void
 xfs_qm_scall_getquota_fill_qc(
 	struct xfs_mount	*mp,
-	uint			type,
+	xfs_dqtype_t		type,
 	const struct xfs_dquot	*dqp,
 	struct qc_dqblk		*dst)
 {
@@ -685,7 +685,7 @@ int
 xfs_qm_scall_getquota(
 	struct xfs_mount	*mp,
 	xfs_dqid_t		id,
-	uint			type,
+	xfs_dqtype_t		type,
 	struct qc_dqblk		*dst)
 {
 	struct xfs_dquot	*dqp;
@@ -723,7 +723,7 @@ int
 xfs_qm_scall_getquota_next(
 	struct xfs_mount	*mp,
 	xfs_dqid_t		*id,
-	uint			type,
+	xfs_dqtype_t		type,
 	struct qc_dqblk		*dst)
 {
 	struct xfs_dquot	*dqp;
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index 0ae35fb5cb89..06b22e35fc90 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -39,9 +39,9 @@ struct xfs_buf;
 
 static inline uint
 xfs_quota_chkd_flag(
-	uint		dqtype)
+	xfs_dqtype_t		type)
 {
-	switch (dqtype) {
+	switch (type) {
 	case XFS_DQTYPE_USER:
 		return XFS_UQUOTA_CHKD;
 	case XFS_DQTYPE_GROUP:
diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index ba69906edecf..d27c0e852c0b 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -85,7 +85,7 @@ xfs_fs_get_quota_state(
 	return 0;
 }
 
-STATIC int
+STATIC xfs_dqtype_t
 xfs_quota_type(int type)
 {
 	switch (type) {
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 81534095f52b..e9b2ce0948b6 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -865,6 +865,7 @@ DECLARE_EVENT_CLASS(xfs_dquot_class,
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(u32, id)
+		__field(xfs_dqtype_t, type)
 		__field(unsigned, flags)
 		__field(unsigned, nrefs)
 		__field(unsigned long long, res_bcount)
@@ -885,7 +886,8 @@ DECLARE_EVENT_CLASS(xfs_dquot_class,
 	TP_fast_assign(
 		__entry->dev = dqp->q_mount->m_super->s_dev;
 		__entry->id = dqp->q_id;
-		__entry->flags = dqp->dq_flags | dqp->q_flags;
+		__entry->type = dqp->q_type;
+		__entry->flags = dqp->q_flags;
 		__entry->nrefs = dqp->q_nrefs;
 
 		__entry->res_bcount = dqp->q_blk.reserved;
@@ -903,13 +905,14 @@ DECLARE_EVENT_CLASS(xfs_dquot_class,
 		__entry->ino_hardlimit = dqp->q_ino.hardlimit;
 		__entry->ino_softlimit = dqp->q_ino.softlimit;
 	),
-	TP_printk("dev %d:%d id 0x%x flags %s nrefs %u "
+	TP_printk("dev %d:%d id 0x%x type %s flags %s nrefs %u "
 		  "res_bc 0x%llx res_rtbc 0x%llx res_ic 0x%llx "
 		  "bcnt 0x%llx bhardlimit 0x%llx bsoftlimit 0x%llx "
 		  "rtbcnt 0x%llx rtbhardlimit 0x%llx rtbsoftlimit 0x%llx "
 		  "icnt 0x%llx ihardlimit 0x%llx isoftlimit 0x%llx]",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->id,
+		  __print_flags(__entry->type, "|", XFS_DQTYPE_STRINGS),
 		  __print_flags(__entry->flags, "|", XFS_DQFLAG_STRINGS),
 		  __entry->nrefs,
 		  __entry->res_bcount,
@@ -976,6 +979,7 @@ TRACE_EVENT(xfs_trans_mod_dquot,
 	TP_ARGS(tp, dqp, field, delta),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__field(xfs_dqtype_t, type)
 		__field(unsigned int, flags)
 		__field(unsigned int, dqid)
 		__field(unsigned int, field)
@@ -983,14 +987,16 @@ TRACE_EVENT(xfs_trans_mod_dquot,
 	),
 	TP_fast_assign(
 		__entry->dev = tp->t_mountp->m_super->s_dev;
-		__entry->flags = dqp->dq_flags | dqp->q_flags;
+		__entry->type = dqp->q_type;
+		__entry->flags = dqp->q_flags;
 		__entry->dqid = dqp->q_id;
 		__entry->field = field;
 		__entry->delta = delta;
 	),
-	TP_printk("dev %d:%d dquot id 0x%x flags %s field %s delta %lld",
+	TP_printk("dev %d:%d dquot id 0x%x type %s flags %s field %s delta %lld",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->dqid,
+		  __print_flags(__entry->type, "|", XFS_DQTYPE_STRINGS),
 		  __print_flags(__entry->flags, "|", XFS_DQFLAG_STRINGS),
 		  __print_flags(__entry->field, "|", XFS_QMOPT_FLAGS),
 		  __entry->delta)
@@ -1001,6 +1007,7 @@ DECLARE_EVENT_CLASS(xfs_dqtrx_class,
 	TP_ARGS(qtrx),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__field(xfs_dqtype_t, type)
 		__field(unsigned int, flags)
 		__field(u32, dqid)
 
@@ -1019,7 +1026,8 @@ DECLARE_EVENT_CLASS(xfs_dqtrx_class,
 	),
 	TP_fast_assign(
 		__entry->dev = qtrx->qt_dquot->q_mount->m_super->s_dev;
-		__entry->flags = qtrx->qt_dquot->dq_flags | qtrx->qt_dquot->q_flags;
+		__entry->type = qtrx->qt_dquot->q_type;
+		__entry->flags = qtrx->qt_dquot->q_flags;
 		__entry->dqid = qtrx->qt_dquot->q_id;
 
 		__entry->blk_res = qtrx->qt_blk_res;
@@ -1035,12 +1043,13 @@ DECLARE_EVENT_CLASS(xfs_dqtrx_class,
 		__entry->ino_res_used = qtrx->qt_ino_res_used;
 		__entry->icount_delta = qtrx->qt_icount_delta;
 	),
-	TP_printk("dev %d:%d dquot id 0x%x flags %s"
+	TP_printk("dev %d:%d dquot id 0x%x type %s flags %s"
 		  "blk_res %llu bcount_delta %lld delbcnt_delta %lld "
 		  "rtblk_res %llu rtblk_res_used %llu rtbcount_delta %lld delrtb_delta %lld "
 		  "ino_res %llu ino_res_used %llu icount_delta %lld",
 		MAJOR(__entry->dev), MINOR(__entry->dev),
 		__entry->dqid,
+		  __print_flags(__entry->type, "|", XFS_DQTYPE_STRINGS),
 		  __print_flags(__entry->flags, "|", XFS_DQFLAG_STRINGS),
 
 		__entry->blk_res,

