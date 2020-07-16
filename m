Return-Path: <SRS0=b91c=A3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1B2FC433E4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 06:45:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63A80206F5
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 06:45:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qfzF+OlE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbgGPGpk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jul 2020 02:45:40 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:55666 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbgGPGpj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jul 2020 02:45:39 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06G6g5lA160524
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:45:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=b+7ZUAUdW/8mdbB95e+CP4wqu5o7q1Hec0yDoj5xL14=;
 b=qfzF+OlEapFYIAxZWnxt2TstxqxUOjM+0QN/2T3HFNYp5ebXpADeKDUoErkTOquHWzuI
 jSqRCS0OmjEQKuAq+9Dpi6cxvlN0Xh+E4l+vr4GJRhmfDw6yu1LQr+VevpYM4RzgqU2U
 Ai6QJsxYy2DsfuBdr6VeF3fRDH/DJ6q3e3BgwY18ELFN+jBIGSJFO5MzAdZALbi2G1zH
 jFtTSvqWK9qk482db+lrdhpq5oAWMwNfa4vFhAjKHZPQB4IjffhR6VQebFeqmjEf6NOt
 jn1rOUqQrJO0fsyp4tf6gyUIL4v6AGnf80s6W1cZ1/cxSmWINRjK7aEDikR6gc6DUx03 kg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 327s65nrgd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:45:35 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06G6hfrD061348
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:45:35 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 327q0srfnf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:45:35 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06G6jXfF007103
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:45:34 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jul 2020 23:45:33 -0700
Subject: [PATCH 02/11] xfs: rename XFS_DQ_{USER,GROUP,PROJ} to XFS_DQTYPE_*
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 15 Jul 2020 23:45:32 -0700
Message-ID: <159488193224.3813063.12478435320438781308.stgit@magnolia>
In-Reply-To: <159488191927.3813063.6443979621452250872.stgit@magnolia>
References: <159488191927.3813063.6443979621452250872.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007160050
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxscore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 impostorscore=0 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007160050
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

We're going to split up the incore dquot state flags from the ondisk
dquot flags (eventually renaming this "type") so start by renaming the
three flags and the bitmask that are going to participate in this.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dquot_buf.c   |    6 ++---
 fs/xfs/libxfs/xfs_format.h      |    2 +-
 fs/xfs/libxfs/xfs_quota_defs.h  |   16 +++++++-----
 fs/xfs/scrub/quota.c            |    6 ++---
 fs/xfs/scrub/repair.c           |    6 ++---
 fs/xfs/xfs_buf_item_recover.c   |    6 ++---
 fs/xfs/xfs_dquot.c              |   36 ++++++++++++++-------------
 fs/xfs/xfs_dquot.h              |   22 ++++++++---------
 fs/xfs/xfs_dquot_item_recover.c |   10 ++++----
 fs/xfs/xfs_icache.c             |    4 ++-
 fs/xfs/xfs_iomap.c              |   12 +++++----
 fs/xfs/xfs_qm.c                 |   52 ++++++++++++++++++++-------------------
 fs/xfs/xfs_qm.h                 |   26 ++++++++++----------
 fs/xfs/xfs_qm_bhv.c             |    2 +-
 fs/xfs/xfs_qm_syscalls.c        |   12 +++++----
 fs/xfs/xfs_quota.h              |    6 ++---
 fs/xfs/xfs_quotaops.c           |    6 ++---
 fs/xfs/xfs_trans_dquot.c        |    4 ++-
 18 files changed, 118 insertions(+), 116 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index eb2412e13f30..450147df3042 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -59,9 +59,9 @@ xfs_dquot_verify(
 	if (ddq->d_version != XFS_DQUOT_VERSION)
 		return __this_address;
 
-	if (ddq->d_flags != XFS_DQ_USER &&
-	    ddq->d_flags != XFS_DQ_PROJ &&
-	    ddq->d_flags != XFS_DQ_GROUP)
+	if (ddq->d_flags != XFS_DQTYPE_USER &&
+	    ddq->d_flags != XFS_DQTYPE_PROJ &&
+	    ddq->d_flags != XFS_DQTYPE_GROUP)
 		return __this_address;
 
 	if (id != -1 && id != be32_to_cpu(ddq->d_id))
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index a534ebee92b9..5d5e0f5eda97 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1157,7 +1157,7 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 struct xfs_disk_dquot {
 	__be16		d_magic;	/* dquot magic = XFS_DQUOT_MAGIC */
 	__u8		d_version;	/* dquot version */
-	__u8		d_flags;	/* XFS_DQ_USER/PROJ/GROUP */
+	__u8		d_flags;	/* XFS_DQTYPE_USER/PROJ/GROUP */
 	__be32		d_id;		/* user,project,group id */
 	__be64		d_blk_hardlimit;/* absolute limit on disk blks */
 	__be64		d_blk_softlimit;/* preferred limit on disk blks */
diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
index d2245f375719..baf6c4ad88af 100644
--- a/fs/xfs/libxfs/xfs_quota_defs.h
+++ b/fs/xfs/libxfs/xfs_quota_defs.h
@@ -21,18 +21,20 @@ typedef uint16_t	xfs_qwarncnt_t;
 /*
  * flags for q_flags field in the dquot.
  */
-#define XFS_DQ_USER		0x0001		/* a user quota */
-#define XFS_DQ_PROJ		0x0002		/* project quota */
-#define XFS_DQ_GROUP		0x0004		/* a group quota */
+#define XFS_DQTYPE_USER		0x0001		/* a user quota */
+#define XFS_DQTYPE_PROJ		0x0002		/* project quota */
+#define XFS_DQTYPE_GROUP	0x0004		/* a group quota */
 #define XFS_DQFLAG_DIRTY	0x0008		/* dquot is dirty */
 #define XFS_DQFLAG_FREEING	0x0010		/* dquot is being torn down */
 
-#define XFS_DQ_ALLTYPES		(XFS_DQ_USER|XFS_DQ_PROJ|XFS_DQ_GROUP)
+#define XFS_DQTYPE_REC_MASK	(XFS_DQTYPE_USER | \
+				 XFS_DQTYPE_PROJ | \
+				 XFS_DQTYPE_GROUP)
 
 #define XFS_DQFLAG_STRINGS \
-	{ XFS_DQ_USER,		"USER" }, \
-	{ XFS_DQ_PROJ,		"PROJ" }, \
-	{ XFS_DQ_GROUP,		"GROUP" }, \
+	{ XFS_DQTYPE_USER,	"USER" }, \
+	{ XFS_DQTYPE_PROJ,	"PROJ" }, \
+	{ XFS_DQTYPE_GROUP,	"GROUP" }, \
 	{ XFS_DQFLAG_DIRTY,	"DIRTY" }, \
 	{ XFS_DQFLAG_FREEING,	"FREEING" }
 
diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index f4aad5b00188..1db07485f148 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -24,11 +24,11 @@ xchk_quota_to_dqtype(
 {
 	switch (sc->sm->sm_type) {
 	case XFS_SCRUB_TYPE_UQUOTA:
-		return XFS_DQ_USER;
+		return XFS_DQTYPE_USER;
 	case XFS_SCRUB_TYPE_GQUOTA:
-		return XFS_DQ_GROUP;
+		return XFS_DQTYPE_GROUP;
 	case XFS_SCRUB_TYPE_PQUOTA:
-		return XFS_DQ_PROJ;
+		return XFS_DQTYPE_PROJ;
 	default:
 		return 0;
 	}
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index db3cfd12803d..074651896586 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -939,11 +939,11 @@ xrep_ino_dqattach(
 "inode %llu repair encountered quota error %d, quotacheck forced.",
 				(unsigned long long)sc->ip->i_ino, error);
 		if (XFS_IS_UQUOTA_ON(sc->mp) && !sc->ip->i_udquot)
-			xrep_force_quotacheck(sc, XFS_DQ_USER);
+			xrep_force_quotacheck(sc, XFS_DQTYPE_USER);
 		if (XFS_IS_GQUOTA_ON(sc->mp) && !sc->ip->i_gdquot)
-			xrep_force_quotacheck(sc, XFS_DQ_GROUP);
+			xrep_force_quotacheck(sc, XFS_DQTYPE_GROUP);
 		if (XFS_IS_PQUOTA_ON(sc->mp) && !sc->ip->i_pdquot)
-			xrep_force_quotacheck(sc, XFS_DQ_PROJ);
+			xrep_force_quotacheck(sc, XFS_DQTYPE_PROJ);
 		/* fall through */
 	case -ESRCH:
 		error = 0;
diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 8bee582cf66a..d480f11e6b00 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -546,11 +546,11 @@ xlog_recover_do_dquot_buffer(
 
 	type = 0;
 	if (buf_f->blf_flags & XFS_BLF_UDQUOT_BUF)
-		type |= XFS_DQ_USER;
+		type |= XFS_DQTYPE_USER;
 	if (buf_f->blf_flags & XFS_BLF_PDQUOT_BUF)
-		type |= XFS_DQ_PROJ;
+		type |= XFS_DQTYPE_PROJ;
 	if (buf_f->blf_flags & XFS_BLF_GDQUOT_BUF)
-		type |= XFS_DQ_GROUP;
+		type |= XFS_DQTYPE_GROUP;
 	/*
 	 * This type of quotas was turned off, so ignore this buffer
 	 */
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 8e84623cc331..4053e7e390f1 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -190,10 +190,10 @@ xfs_qm_init_dquot_blk(
 		}
 	}
 
-	if (type & XFS_DQ_USER) {
+	if (type & XFS_DQTYPE_USER) {
 		qflag = XFS_UQUOTA_CHKD;
 		blftype = XFS_BLF_UDQUOT_BUF;
-	} else if (type & XFS_DQ_PROJ) {
+	} else if (type & XFS_DQTYPE_PROJ) {
 		qflag = XFS_PQUOTA_CHKD;
 		blftype = XFS_BLF_PDQUOT_BUF;
 	} else {
@@ -311,7 +311,7 @@ xfs_dquot_disk_alloc(
 	 * the entire thing.
 	 */
 	xfs_qm_init_dquot_blk(tp, mp, dqp->q_id,
-			      dqp->dq_flags & XFS_DQ_ALLTYPES, bp);
+			      dqp->dq_flags & XFS_DQTYPE_REC_MASK, bp);
 	xfs_buf_set_ref(bp, XFS_DQUOT_REF);
 
 	/*
@@ -448,13 +448,13 @@ xfs_dquot_alloc(
 	 * quotas.
 	 */
 	switch (type) {
-	case XFS_DQ_USER:
+	case XFS_DQTYPE_USER:
 		/* uses the default lock class */
 		break;
-	case XFS_DQ_GROUP:
+	case XFS_DQTYPE_GROUP:
 		lockdep_set_class(&dqp->q_qlock, &xfs_dquot_group_class);
 		break;
-	case XFS_DQ_PROJ:
+	case XFS_DQTYPE_PROJ:
 		lockdep_set_class(&dqp->q_qlock, &xfs_dquot_project_class);
 		break;
 	default:
@@ -480,7 +480,7 @@ xfs_dquot_from_disk(
 	 * Ensure that we got the type and ID we were looking for.
 	 * Everything else was checked by the dquot buffer verifier.
 	 */
-	if ((ddqp->d_flags & XFS_DQ_ALLTYPES) != dqp->dq_flags ||
+	if ((ddqp->d_flags & XFS_DQTYPE_REC_MASK) != dqp->dq_flags ||
 	    be32_to_cpu(ddqp->d_id) != dqp->q_id) {
 		xfs_alert_tag(bp->b_mount, XFS_PTAG_VERIFIER_ERROR,
 			  "Metadata corruption detected at %pS, quota %u",
@@ -530,7 +530,7 @@ xfs_dquot_to_disk(
 {
 	ddqp->d_magic = cpu_to_be16(XFS_DQUOT_MAGIC);
 	ddqp->d_version = XFS_DQUOT_VERSION;
-	ddqp->d_flags = dqp->dq_flags & XFS_DQ_ALLTYPES;
+	ddqp->d_flags = dqp->dq_flags & XFS_DQTYPE_REC_MASK;
 	ddqp->d_id = cpu_to_be32(dqp->q_id);
 	ddqp->d_pad0 = 0;
 	ddqp->d_pad = 0;
@@ -779,15 +779,15 @@ xfs_qm_dqget_checks(
 		return -ESRCH;
 
 	switch (type) {
-	case XFS_DQ_USER:
+	case XFS_DQTYPE_USER:
 		if (!XFS_IS_UQUOTA_ON(mp))
 			return -ESRCH;
 		return 0;
-	case XFS_DQ_GROUP:
+	case XFS_DQTYPE_GROUP:
 		if (!XFS_IS_GQUOTA_ON(mp))
 			return -ESRCH;
 		return 0;
-	case XFS_DQ_PROJ:
+	case XFS_DQTYPE_PROJ:
 		if (!XFS_IS_PQUOTA_ON(mp))
 			return -ESRCH;
 		return 0;
@@ -874,11 +874,11 @@ xfs_qm_id_for_quotatype(
 	uint			type)
 {
 	switch (type) {
-	case XFS_DQ_USER:
+	case XFS_DQTYPE_USER:
 		return i_uid_read(VFS_I(ip));
-	case XFS_DQ_GROUP:
+	case XFS_DQTYPE_GROUP:
 		return i_gid_read(VFS_I(ip));
-	case XFS_DQ_PROJ:
+	case XFS_DQTYPE_PROJ:
 		return ip->i_d.di_projid;
 	}
 	ASSERT(0);
@@ -1114,11 +1114,11 @@ static xfs_failaddr_t
 xfs_qm_dqflush_check(
 	struct xfs_dquot	*dqp)
 {
-	__u8			type = dqp->dq_flags & XFS_DQ_ALLTYPES;
+	__u8			type = dqp->dq_flags & XFS_DQTYPE_REC_MASK;
 
-	if (type != XFS_DQ_USER &&
-	    type != XFS_DQ_GROUP &&
-	    type != XFS_DQ_PROJ)
+	if (type != XFS_DQTYPE_USER &&
+	    type != XFS_DQTYPE_GROUP &&
+	    type != XFS_DQTYPE_PROJ)
 		return __this_address;
 
 	if (dqp->q_id == 0)
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 9e44da522684..17a21677723f 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -130,12 +130,12 @@ static inline void xfs_dqunlock(struct xfs_dquot *dqp)
 
 static inline int xfs_this_quota_on(struct xfs_mount *mp, int type)
 {
-	switch (type & XFS_DQ_ALLTYPES) {
-	case XFS_DQ_USER:
+	switch (type & XFS_DQTYPE_REC_MASK) {
+	case XFS_DQTYPE_USER:
 		return XFS_IS_UQUOTA_ON(mp);
-	case XFS_DQ_GROUP:
+	case XFS_DQTYPE_GROUP:
 		return XFS_IS_GQUOTA_ON(mp);
-	case XFS_DQ_PROJ:
+	case XFS_DQTYPE_PROJ:
 		return XFS_IS_PQUOTA_ON(mp);
 	default:
 		return 0;
@@ -144,12 +144,12 @@ static inline int xfs_this_quota_on(struct xfs_mount *mp, int type)
 
 static inline struct xfs_dquot *xfs_inode_dquot(struct xfs_inode *ip, int type)
 {
-	switch (type & XFS_DQ_ALLTYPES) {
-	case XFS_DQ_USER:
+	switch (type & XFS_DQTYPE_REC_MASK) {
+	case XFS_DQTYPE_USER:
 		return ip->i_udquot;
-	case XFS_DQ_GROUP:
+	case XFS_DQTYPE_GROUP:
 		return ip->i_gdquot;
-	case XFS_DQ_PROJ:
+	case XFS_DQTYPE_PROJ:
 		return ip->i_pdquot;
 	default:
 		return NULL;
@@ -175,9 +175,9 @@ void xfs_dquot_to_disk(struct xfs_disk_dquot *ddqp, struct xfs_dquot *dqp);
 
 #define XFS_DQ_IS_LOCKED(dqp)	(mutex_is_locked(&((dqp)->q_qlock)))
 #define XFS_DQ_IS_DIRTY(dqp)	((dqp)->q_flags & XFS_DQFLAG_DIRTY)
-#define XFS_QM_ISUDQ(dqp)	((dqp)->dq_flags & XFS_DQ_USER)
-#define XFS_QM_ISPDQ(dqp)	((dqp)->dq_flags & XFS_DQ_PROJ)
-#define XFS_QM_ISGDQ(dqp)	((dqp)->dq_flags & XFS_DQ_GROUP)
+#define XFS_QM_ISUDQ(dqp)	((dqp)->dq_flags & XFS_DQTYPE_USER)
+#define XFS_QM_ISPDQ(dqp)	((dqp)->dq_flags & XFS_DQTYPE_PROJ)
+#define XFS_QM_ISGDQ(dqp)	((dqp)->dq_flags & XFS_DQTYPE_GROUP)
 
 void		xfs_qm_dqdestroy(struct xfs_dquot *dqp);
 int		xfs_qm_dqflush(struct xfs_dquot *dqp, struct xfs_buf **bpp);
diff --git a/fs/xfs/xfs_dquot_item_recover.c b/fs/xfs/xfs_dquot_item_recover.c
index 9f64162ca300..d7eb85c7d394 100644
--- a/fs/xfs/xfs_dquot_item_recover.c
+++ b/fs/xfs/xfs_dquot_item_recover.c
@@ -39,7 +39,7 @@ xlog_recover_dquot_ra_pass2(
 	if (item->ri_buf[1].i_len < sizeof(struct xfs_disk_dquot))
 		return;
 
-	type = recddq->d_flags & (XFS_DQ_USER | XFS_DQ_PROJ | XFS_DQ_GROUP);
+	type = recddq->d_flags & (XFS_DQTYPE_USER | XFS_DQTYPE_PROJ | XFS_DQTYPE_GROUP);
 	ASSERT(type);
 	if (log->l_quotaoffs_flag & type)
 		return;
@@ -91,7 +91,7 @@ xlog_recover_dquot_commit_pass2(
 	/*
 	 * This type of quotas was turned off, so ignore this record.
 	 */
-	type = recddq->d_flags & (XFS_DQ_USER | XFS_DQ_PROJ | XFS_DQ_GROUP);
+	type = recddq->d_flags & (XFS_DQTYPE_USER | XFS_DQTYPE_PROJ | XFS_DQTYPE_GROUP);
 	ASSERT(type);
 	if (log->l_quotaoffs_flag & type)
 		return 0;
@@ -185,11 +185,11 @@ xlog_recover_quotaoff_commit_pass1(
 	 * group/project quotaoff or both.
 	 */
 	if (qoff_f->qf_flags & XFS_UQUOTA_ACCT)
-		log->l_quotaoffs_flag |= XFS_DQ_USER;
+		log->l_quotaoffs_flag |= XFS_DQTYPE_USER;
 	if (qoff_f->qf_flags & XFS_PQUOTA_ACCT)
-		log->l_quotaoffs_flag |= XFS_DQ_PROJ;
+		log->l_quotaoffs_flag |= XFS_DQTYPE_PROJ;
 	if (qoff_f->qf_flags & XFS_GQUOTA_ACCT)
-		log->l_quotaoffs_flag |= XFS_DQ_GROUP;
+		log->l_quotaoffs_flag |= XFS_DQTYPE_GROUP;
 
 	return 0;
 }
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 58a750ce689c..3c6e936d2f99 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1424,7 +1424,7 @@ __xfs_inode_free_quota_eofblocks(
 	eofb.eof_flags = XFS_EOF_FLAGS_UNION|XFS_EOF_FLAGS_SYNC;
 
 	if (XFS_IS_UQUOTA_ENFORCED(ip->i_mount)) {
-		dq = xfs_inode_dquot(ip, XFS_DQ_USER);
+		dq = xfs_inode_dquot(ip, XFS_DQTYPE_USER);
 		if (dq && xfs_dquot_lowsp(dq)) {
 			eofb.eof_uid = VFS_I(ip)->i_uid;
 			eofb.eof_flags |= XFS_EOF_FLAGS_UID;
@@ -1433,7 +1433,7 @@ __xfs_inode_free_quota_eofblocks(
 	}
 
 	if (XFS_IS_GQUOTA_ENFORCED(ip->i_mount)) {
-		dq = xfs_inode_dquot(ip, XFS_DQ_GROUP);
+		dq = xfs_inode_dquot(ip, XFS_DQTYPE_GROUP);
 		if (dq && xfs_dquot_lowsp(dq)) {
 			eofb.eof_gid = VFS_I(ip)->i_gid;
 			eofb.eof_flags |= XFS_EOF_FLAGS_GID;
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index f60a6e44363b..d3dc4106a35c 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -450,14 +450,14 @@ xfs_iomap_prealloc_size(
 	 * Check each quota to cap the prealloc size, provide a shift value to
 	 * throttle with and adjust amount of available space.
 	 */
-	if (xfs_quota_need_throttle(ip, XFS_DQ_USER, alloc_blocks))
-		xfs_quota_calc_throttle(ip, XFS_DQ_USER, &qblocks, &qshift,
+	if (xfs_quota_need_throttle(ip, XFS_DQTYPE_USER, alloc_blocks))
+		xfs_quota_calc_throttle(ip, XFS_DQTYPE_USER, &qblocks, &qshift,
 					&freesp);
-	if (xfs_quota_need_throttle(ip, XFS_DQ_GROUP, alloc_blocks))
-		xfs_quota_calc_throttle(ip, XFS_DQ_GROUP, &qblocks, &qshift,
+	if (xfs_quota_need_throttle(ip, XFS_DQTYPE_GROUP, alloc_blocks))
+		xfs_quota_calc_throttle(ip, XFS_DQTYPE_GROUP, &qblocks, &qshift,
 					&freesp);
-	if (xfs_quota_need_throttle(ip, XFS_DQ_PROJ, alloc_blocks))
-		xfs_quota_calc_throttle(ip, XFS_DQ_PROJ, &qblocks, &qshift,
+	if (xfs_quota_need_throttle(ip, XFS_DQTYPE_PROJ, alloc_blocks))
+		xfs_quota_calc_throttle(ip, XFS_DQTYPE_PROJ, &qblocks, &qshift,
 					&freesp);
 
 	/*
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index bf94c1bbda16..47d4b6937c84 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -189,11 +189,11 @@ xfs_qm_dqpurge_all(
 	uint			flags)
 {
 	if (flags & XFS_QMOPT_UQUOTA)
-		xfs_qm_dquot_walk(mp, XFS_DQ_USER, xfs_qm_dqpurge, NULL);
+		xfs_qm_dquot_walk(mp, XFS_DQTYPE_USER, xfs_qm_dqpurge, NULL);
 	if (flags & XFS_QMOPT_GQUOTA)
-		xfs_qm_dquot_walk(mp, XFS_DQ_GROUP, xfs_qm_dqpurge, NULL);
+		xfs_qm_dquot_walk(mp, XFS_DQTYPE_GROUP, xfs_qm_dqpurge, NULL);
 	if (flags & XFS_QMOPT_PQUOTA)
-		xfs_qm_dquot_walk(mp, XFS_DQ_PROJ, xfs_qm_dqpurge, NULL);
+		xfs_qm_dquot_walk(mp, XFS_DQTYPE_PROJ, xfs_qm_dqpurge, NULL);
 }
 
 /*
@@ -331,7 +331,7 @@ xfs_qm_dqattach_locked(
 
 	if (XFS_IS_UQUOTA_ON(mp) && !ip->i_udquot) {
 		error = xfs_qm_dqattach_one(ip, i_uid_read(VFS_I(ip)),
-				XFS_DQ_USER, doalloc, &ip->i_udquot);
+				XFS_DQTYPE_USER, doalloc, &ip->i_udquot);
 		if (error)
 			goto done;
 		ASSERT(ip->i_udquot);
@@ -339,14 +339,14 @@ xfs_qm_dqattach_locked(
 
 	if (XFS_IS_GQUOTA_ON(mp) && !ip->i_gdquot) {
 		error = xfs_qm_dqattach_one(ip, i_gid_read(VFS_I(ip)),
-				XFS_DQ_GROUP, doalloc, &ip->i_gdquot);
+				XFS_DQTYPE_GROUP, doalloc, &ip->i_gdquot);
 		if (error)
 			goto done;
 		ASSERT(ip->i_gdquot);
 	}
 
 	if (XFS_IS_PQUOTA_ON(mp) && !ip->i_pdquot) {
-		error = xfs_qm_dqattach_one(ip, ip->i_d.di_projid, XFS_DQ_PROJ,
+		error = xfs_qm_dqattach_one(ip, ip->i_d.di_projid, XFS_DQTYPE_PROJ,
 				doalloc, &ip->i_pdquot);
 		if (error)
 			goto done;
@@ -664,16 +664,16 @@ xfs_qm_init_quotainfo(
 
 	mp->m_qflags |= (mp->m_sb.sb_qflags & XFS_ALL_QUOTA_CHKD);
 
-	xfs_qm_init_timelimits(mp, XFS_DQ_USER);
-	xfs_qm_init_timelimits(mp, XFS_DQ_GROUP);
-	xfs_qm_init_timelimits(mp, XFS_DQ_PROJ);
+	xfs_qm_init_timelimits(mp, XFS_DQTYPE_USER);
+	xfs_qm_init_timelimits(mp, XFS_DQTYPE_GROUP);
+	xfs_qm_init_timelimits(mp, XFS_DQTYPE_PROJ);
 
 	if (XFS_IS_UQUOTA_RUNNING(mp))
-		xfs_qm_set_defquota(mp, XFS_DQ_USER, qinf);
+		xfs_qm_set_defquota(mp, XFS_DQTYPE_USER, qinf);
 	if (XFS_IS_GQUOTA_RUNNING(mp))
-		xfs_qm_set_defquota(mp, XFS_DQ_GROUP, qinf);
+		xfs_qm_set_defquota(mp, XFS_DQTYPE_GROUP, qinf);
 	if (XFS_IS_PQUOTA_RUNNING(mp))
-		xfs_qm_set_defquota(mp, XFS_DQ_PROJ, qinf);
+		xfs_qm_set_defquota(mp, XFS_DQTYPE_PROJ, qinf);
 
 	qinf->qi_shrinker.count_objects = xfs_qm_shrink_count;
 	qinf->qi_shrinker.scan_objects = xfs_qm_shrink_scan;
@@ -855,7 +855,7 @@ xfs_qm_reset_dqcounts(
 		 * xfs_dquot_verify.
 		 */
 		if (xfs_dqblk_verify(mp, &dqb[j], id + j) ||
-		    (dqb[j].dd_diskdq.d_flags & XFS_DQ_ALLTYPES) != type)
+		    (dqb[j].dd_diskdq.d_flags & XFS_DQTYPE_REC_MASK) != type)
 			xfs_dqblk_repair(mp, &dqb[j], id + j, type);
 
 		/*
@@ -1176,21 +1176,21 @@ xfs_qm_dqusage_adjust(
 	 * and quotaoffs don't race. (Quotachecks happen at mount time only).
 	 */
 	if (XFS_IS_UQUOTA_ON(mp)) {
-		error = xfs_qm_quotacheck_dqadjust(ip, XFS_DQ_USER, nblks,
+		error = xfs_qm_quotacheck_dqadjust(ip, XFS_DQTYPE_USER, nblks,
 				rtblks);
 		if (error)
 			goto error0;
 	}
 
 	if (XFS_IS_GQUOTA_ON(mp)) {
-		error = xfs_qm_quotacheck_dqadjust(ip, XFS_DQ_GROUP, nblks,
+		error = xfs_qm_quotacheck_dqadjust(ip, XFS_DQTYPE_GROUP, nblks,
 				rtblks);
 		if (error)
 			goto error0;
 	}
 
 	if (XFS_IS_PQUOTA_ON(mp)) {
-		error = xfs_qm_quotacheck_dqadjust(ip, XFS_DQ_PROJ, nblks,
+		error = xfs_qm_quotacheck_dqadjust(ip, XFS_DQTYPE_PROJ, nblks,
 				rtblks);
 		if (error)
 			goto error0;
@@ -1281,7 +1281,7 @@ xfs_qm_quotacheck(
 	 * We don't log our changes till later.
 	 */
 	if (uip) {
-		error = xfs_qm_reset_dqcounts_buf(mp, uip, XFS_DQ_USER,
+		error = xfs_qm_reset_dqcounts_buf(mp, uip, XFS_DQTYPE_USER,
 					 &buffer_list);
 		if (error)
 			goto error_return;
@@ -1289,7 +1289,7 @@ xfs_qm_quotacheck(
 	}
 
 	if (gip) {
-		error = xfs_qm_reset_dqcounts_buf(mp, gip, XFS_DQ_GROUP,
+		error = xfs_qm_reset_dqcounts_buf(mp, gip, XFS_DQTYPE_GROUP,
 					 &buffer_list);
 		if (error)
 			goto error_return;
@@ -1297,7 +1297,7 @@ xfs_qm_quotacheck(
 	}
 
 	if (pip) {
-		error = xfs_qm_reset_dqcounts_buf(mp, pip, XFS_DQ_PROJ,
+		error = xfs_qm_reset_dqcounts_buf(mp, pip, XFS_DQTYPE_PROJ,
 					 &buffer_list);
 		if (error)
 			goto error_return;
@@ -1314,17 +1314,17 @@ xfs_qm_quotacheck(
 	 * down to disk buffers if everything was updated successfully.
 	 */
 	if (XFS_IS_UQUOTA_ON(mp)) {
-		error = xfs_qm_dquot_walk(mp, XFS_DQ_USER, xfs_qm_flush_one,
+		error = xfs_qm_dquot_walk(mp, XFS_DQTYPE_USER, xfs_qm_flush_one,
 					  &buffer_list);
 	}
 	if (XFS_IS_GQUOTA_ON(mp)) {
-		error2 = xfs_qm_dquot_walk(mp, XFS_DQ_GROUP, xfs_qm_flush_one,
+		error2 = xfs_qm_dquot_walk(mp, XFS_DQTYPE_GROUP, xfs_qm_flush_one,
 					   &buffer_list);
 		if (!error)
 			error = error2;
 	}
 	if (XFS_IS_PQUOTA_ON(mp)) {
-		error2 = xfs_qm_dquot_walk(mp, XFS_DQ_PROJ, xfs_qm_flush_one,
+		error2 = xfs_qm_dquot_walk(mp, XFS_DQTYPE_PROJ, xfs_qm_flush_one,
 					   &buffer_list);
 		if (!error)
 			error = error2;
@@ -1662,7 +1662,7 @@ xfs_qm_vop_dqalloc(
 			 */
 			xfs_iunlock(ip, lockflags);
 			error = xfs_qm_dqget(mp, from_kuid(user_ns, uid),
-					XFS_DQ_USER, true, &uq);
+					XFS_DQTYPE_USER, true, &uq);
 			if (error) {
 				ASSERT(error != -ENOENT);
 				return error;
@@ -1686,7 +1686,7 @@ xfs_qm_vop_dqalloc(
 		if (!gid_eq(inode->i_gid, gid)) {
 			xfs_iunlock(ip, lockflags);
 			error = xfs_qm_dqget(mp, from_kgid(user_ns, gid),
-					XFS_DQ_GROUP, true, &gq);
+					XFS_DQTYPE_GROUP, true, &gq);
 			if (error) {
 				ASSERT(error != -ENOENT);
 				goto error_rele;
@@ -1702,8 +1702,8 @@ xfs_qm_vop_dqalloc(
 	if ((flags & XFS_QMOPT_PQUOTA) && XFS_IS_PQUOTA_ON(mp)) {
 		if (ip->i_d.di_projid != prid) {
 			xfs_iunlock(ip, lockflags);
-			error = xfs_qm_dqget(mp, (xfs_dqid_t)prid, XFS_DQ_PROJ,
-					true, &pq);
+			error = xfs_qm_dqget(mp, (xfs_dqid_t)prid,
+					XFS_DQTYPE_PROJ, true, &pq);
 			if (error) {
 				ASSERT(error != -ENOENT);
 				goto error_rele;
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index 11c28ff0298c..21bc67d4962c 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -73,11 +73,11 @@ xfs_dquot_tree(
 	int			type)
 {
 	switch (type) {
-	case XFS_DQ_USER:
+	case XFS_DQTYPE_USER:
 		return &qi->qi_uquota_tree;
-	case XFS_DQ_GROUP:
+	case XFS_DQTYPE_GROUP:
 		return &qi->qi_gquota_tree;
-	case XFS_DQ_PROJ:
+	case XFS_DQTYPE_PROJ:
 		return &qi->qi_pquota_tree;
 	default:
 		ASSERT(0);
@@ -88,12 +88,12 @@ xfs_dquot_tree(
 static inline struct xfs_inode *
 xfs_quota_inode(xfs_mount_t *mp, uint dq_flags)
 {
-	switch (dq_flags & XFS_DQ_ALLTYPES) {
-	case XFS_DQ_USER:
+	switch (dq_flags & XFS_DQTYPE_REC_MASK) {
+	case XFS_DQTYPE_USER:
 		return mp->m_quotainfo->qi_uquotaip;
-	case XFS_DQ_GROUP:
+	case XFS_DQTYPE_GROUP:
 		return mp->m_quotainfo->qi_gquotaip;
-	case XFS_DQ_PROJ:
+	case XFS_DQTYPE_PROJ:
 		return mp->m_quotainfo->qi_pquotaip;
 	default:
 		ASSERT(0);
@@ -105,11 +105,11 @@ static inline int
 xfs_dquot_type(struct xfs_dquot *dqp)
 {
 	if (XFS_QM_ISUDQ(dqp))
-		return XFS_DQ_USER;
+		return XFS_DQTYPE_USER;
 	if (XFS_QM_ISGDQ(dqp))
-		return XFS_DQ_GROUP;
+		return XFS_DQTYPE_GROUP;
 	ASSERT(XFS_QM_ISPDQ(dqp));
-	return XFS_DQ_PROJ;
+	return XFS_DQTYPE_PROJ;
 }
 
 extern void	xfs_trans_mod_dquot(struct xfs_trans *tp, struct xfs_dquot *dqp,
@@ -166,11 +166,11 @@ static inline struct xfs_def_quota *
 xfs_get_defquota(struct xfs_quotainfo *qi, int type)
 {
 	switch (type) {
-	case XFS_DQ_USER:
+	case XFS_DQTYPE_USER:
 		return &qi->qi_usr_default;
-	case XFS_DQ_GROUP:
+	case XFS_DQTYPE_GROUP:
 		return &qi->qi_grp_default;
-	case XFS_DQ_PROJ:
+	case XFS_DQTYPE_PROJ:
 		return &qi->qi_prj_default;
 	default:
 		ASSERT(0);
diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index 0993217e5ac8..639398091ad6 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -60,7 +60,7 @@ xfs_qm_statvfs(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_dquot	*dqp;
 
-	if (!xfs_qm_dqget(mp, ip->i_d.di_projid, XFS_DQ_PROJ, false, &dqp)) {
+	if (!xfs_qm_dqget(mp, ip->i_d.di_projid, XFS_DQTYPE_PROJ, false, &dqp)) {
 		xfs_fill_statvfs_from_dquot(statp, dqp);
 		xfs_qm_dqput(dqp);
 	}
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index cbe352187d32..119c3d7d5f51 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -660,18 +660,18 @@ xfs_qm_scall_getquota_fill_qc(
 	 * gets turned off. No need to confuse the user level code,
 	 * so return zeroes in that case.
 	 */
-	if ((!XFS_IS_UQUOTA_ENFORCED(mp) && type == XFS_DQ_USER) ||
-	    (!XFS_IS_GQUOTA_ENFORCED(mp) && type == XFS_DQ_GROUP) ||
-	    (!XFS_IS_PQUOTA_ENFORCED(mp) && type == XFS_DQ_PROJ)) {
+	if ((!XFS_IS_UQUOTA_ENFORCED(mp) && type == XFS_DQTYPE_USER) ||
+	    (!XFS_IS_GQUOTA_ENFORCED(mp) && type == XFS_DQTYPE_GROUP) ||
+	    (!XFS_IS_PQUOTA_ENFORCED(mp) && type == XFS_DQTYPE_PROJ)) {
 		dst->d_spc_timer = 0;
 		dst->d_ino_timer = 0;
 		dst->d_rt_spc_timer = 0;
 	}
 
 #ifdef DEBUG
-	if (((XFS_IS_UQUOTA_ENFORCED(mp) && type == XFS_DQ_USER) ||
-	     (XFS_IS_GQUOTA_ENFORCED(mp) && type == XFS_DQ_GROUP) ||
-	     (XFS_IS_PQUOTA_ENFORCED(mp) && type == XFS_DQ_PROJ)) &&
+	if (((XFS_IS_UQUOTA_ENFORCED(mp) && type == XFS_DQTYPE_USER) ||
+	     (XFS_IS_GQUOTA_ENFORCED(mp) && type == XFS_DQTYPE_GROUP) ||
+	     (XFS_IS_PQUOTA_ENFORCED(mp) && type == XFS_DQTYPE_PROJ)) &&
 	    dqp->q_id != 0) {
 		if ((dst->d_space > dst->d_spc_softlimit) &&
 		    (dst->d_spc_softlimit > 0)) {
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index c92ae5e02ce8..0ae35fb5cb89 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -42,11 +42,11 @@ xfs_quota_chkd_flag(
 	uint		dqtype)
 {
 	switch (dqtype) {
-	case XFS_DQ_USER:
+	case XFS_DQTYPE_USER:
 		return XFS_UQUOTA_CHKD;
-	case XFS_DQ_GROUP:
+	case XFS_DQTYPE_GROUP:
 		return XFS_GQUOTA_CHKD;
-	case XFS_DQ_PROJ:
+	case XFS_DQTYPE_PROJ:
 		return XFS_PQUOTA_CHKD;
 	default:
 		return 0;
diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index 299695a068f3..ba69906edecf 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -90,11 +90,11 @@ xfs_quota_type(int type)
 {
 	switch (type) {
 	case USRQUOTA:
-		return XFS_DQ_USER;
+		return XFS_DQTYPE_USER;
 	case GRPQUOTA:
-		return XFS_DQ_GROUP;
+		return XFS_DQTYPE_GROUP;
 	default:
-		return XFS_DQ_PROJ;
+		return XFS_DQTYPE_PROJ;
 	}
 }
 
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index a8f480e5401f..ea61e279f831 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -553,9 +553,9 @@ xfs_quota_warn(
 {
 	enum quota_type qtype;
 
-	if (dqp->dq_flags & XFS_DQ_PROJ)
+	if (dqp->dq_flags & XFS_DQTYPE_PROJ)
 		qtype = PRJQUOTA;
-	else if (dqp->dq_flags & XFS_DQ_USER)
+	else if (dqp->dq_flags & XFS_DQTYPE_USER)
 		qtype = USRQUOTA;
 	else
 		qtype = GRPQUOTA;

