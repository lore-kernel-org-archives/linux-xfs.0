Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A964C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 01:51:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 321DC2071B
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 01:51:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NnOmFcpt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728084AbgGOBvb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jul 2020 21:51:31 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38992 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726356AbgGOBvb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jul 2020 21:51:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06F1lbgx101791
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2020 01:51:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=b3EI1CnWEnRhn4DoBBB0ja8rq10boEvPePcytKsBX+E=;
 b=NnOmFcptz6Ohs79yZas/2wXlSaNqLoRs+V879mVgIwKZPzszpWcP7qogCeSvDUFE096h
 AQfVoGQszwCF7ua09RFw3azfe7YgHba+S0Cu5RJ3NbLP251sw9XO2x68qkLwBtybx7uE
 iCPR3lk4TXbf6Z++CaKyKiv7FDXavFwxIvBXHLg3+nXPgUe7HqWIpTbx25fyzXLQJDF/
 ehU5h//nRqUXSTBwhQPc2cV3n1uDwQpW5BQi9UeC1j/1HT9Wdnd711TlZc4rovyPW3OK
 cM0VlKQcRHWR5HEc91x03M3s4bW8AQg0XfuoBNfCuAwmYOYpudyVWTxcoTikYVTy8pLZ uw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 32762nggg5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2020 01:51:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06F1lcaa125443
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2020 01:51:29 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 327q6tefpr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2020 01:51:29 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06F1pSr3028116
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2020 01:51:28 GMT
Received: from localhost (/10.159.237.234)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Jul 2020 18:51:28 -0700
Subject: [PATCH 08/26] xfs: move the ondisk dquot flags to their own namespace
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 14 Jul 2020 18:51:27 -0700
Message-ID: <159477788696.3263162.17867616158391052475.stgit@magnolia>
In-Reply-To: <159477783164.3263162.2564345443708779029.stgit@magnolia>
References: <159477783164.3263162.2564345443708779029.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=1
 phishscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007150013
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 clxscore=1015 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 bulkscore=0 suspectscore=1 phishscore=0 adultscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150013
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

For the ondisk dquot records, rename the d_flags field to d_type, and
then create a separate XFS_DDQTYPE_ namespace for those flags.  Since we
now have a verifier that will spot dquots with unknown flags or invalid
quota types, we can drop the corresponding checks from the online
scrubber.

Note that we can also move the incore XFS_DQFLAG_ values lower in the
bitmask now that the separation is complete.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dquot_buf.c   |   12 +++++++-----
 fs/xfs/libxfs/xfs_format.h      |   13 ++++++++++++-
 fs/xfs/libxfs/xfs_quota_defs.h  |   18 +++++-------------
 fs/xfs/scrub/quota.c            |    4 ----
 fs/xfs/xfs_buf_item_recover.c   |    6 +++---
 fs/xfs/xfs_dquot.c              |    4 ++--
 fs/xfs/xfs_dquot_item_recover.c |   10 +++++-----
 fs/xfs/xfs_qm.c                 |    2 +-
 8 files changed, 35 insertions(+), 34 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index 3b20b82a775b..a2ea40677069 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -62,12 +62,14 @@ xfs_dquot_verify(
 	if (ddq->d_version != XFS_DQUOT_VERSION)
 		return __this_address;
 
-	ddq_type = ddq->d_flags & XFS_DQ_ALLTYPES;
+	if (ddq->d_type & ~XFS_DDQTYPE_ANY)
+		return __this_address;
+	ddq_type = ddq->d_type & XFS_DDQTYPE_REC_MASK;
 	if (type != XFS_DQTYPE_NONE && ddq_type != type)
 		return __this_address;
-	if (ddq_type != XFS_DQ_USER &&
-	    ddq_type != XFS_DQ_PROJ &&
-	    ddq_type != XFS_DQ_GROUP)
+	if (ddq_type != XFS_DDQTYPE_USER &&
+	    ddq_type != XFS_DDQTYPE_PROJ &&
+	    ddq_type != XFS_DDQTYPE_GROUP)
 		return __this_address;
 
 	if (id != -1 && id != be32_to_cpu(ddq->d_id))
@@ -126,7 +128,7 @@ xfs_dqblk_repair(
 
 	dqb->dd_diskdq.d_magic = cpu_to_be16(XFS_DQUOT_MAGIC);
 	dqb->dd_diskdq.d_version = XFS_DQUOT_VERSION;
-	dqb->dd_diskdq.d_flags = type;
+	dqb->dd_diskdq.d_type = type;
 	dqb->dd_diskdq.d_id = cpu_to_be32(id);
 
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index b42a52bfa1e9..79fbabeb476c 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1149,6 +1149,17 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 #define XFS_DQUOT_MAGIC		0x4451		/* 'DQ' */
 #define XFS_DQUOT_VERSION	(uint8_t)0x01	/* latest version number */
 
+#define XFS_DDQTYPE_USER	0x01		/* user dquot record */
+#define XFS_DDQTYPE_PROJ	0x02		/* project dquot record */
+#define XFS_DDQTYPE_GROUP	0x04		/* group dquot record */
+
+/* bitmask to determine if this is a user/group/project dquot */
+#define XFS_DDQTYPE_REC_MASK	(XFS_DDQTYPE_USER | \
+				 XFS_DDQTYPE_PROJ | \
+				 XFS_DDQTYPE_GROUP)
+
+#define XFS_DDQTYPE_ANY		(XFS_DDQTYPE_REC_MASK)
+
 /*
  * This is the main portion of the on-disk representation of quota
  * information for a user. This is the q_core of the struct xfs_dquot that
@@ -1158,7 +1169,7 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 struct xfs_disk_dquot {
 	__be16		d_magic;	/* dquot magic = XFS_DQUOT_MAGIC */
 	__u8		d_version;	/* dquot version */
-	__u8		d_flags;	/* XFS_DQ_USER/PROJ/GROUP */
+	__u8		d_type;		/* XFS_DDQTYPE_* */
 	__be32		d_id;		/* user,project,group id */
 	__be64		d_blk_hardlimit;/* absolute limit on disk blks */
 	__be64		d_blk_softlimit;/* preferred limit on disk blks */
diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
index 2109fe621e1f..d4b81645cd3f 100644
--- a/fs/xfs/libxfs/xfs_quota_defs.h
+++ b/fs/xfs/libxfs/xfs_quota_defs.h
@@ -21,9 +21,9 @@ typedef uint16_t	xfs_qwarncnt_t;
 typedef uint8_t		xfs_dqtype_t;
 
 #define XFS_DQTYPE_NONE		(0)
-#define XFS_DQTYPE_USER		(XFS_DQ_USER)
-#define XFS_DQTYPE_PROJ		(XFS_DQ_PROJ)
-#define XFS_DQTYPE_GROUP	(XFS_DQ_GROUP)
+#define XFS_DQTYPE_USER		(XFS_DDQTYPE_USER)
+#define XFS_DQTYPE_PROJ		(XFS_DDQTYPE_PROJ)
+#define XFS_DQTYPE_GROUP	(XFS_DDQTYPE_GROUP)
 
 #define XFS_DQTYPE_STRINGS \
 	{ XFS_DQTYPE_NONE,	"NONE" }, \
@@ -34,18 +34,10 @@ typedef uint8_t		xfs_dqtype_t;
 /*
  * flags for q_flags field in the dquot.
  */
-#define XFS_DQ_USER		0x0001		/* a user quota */
-#define XFS_DQ_PROJ		0x0002		/* project quota */
-#define XFS_DQ_GROUP		0x0004		/* a group quota */
-#define XFS_DQFLAG_DIRTY	0x0008		/* dquot is dirty */
-#define XFS_DQFLAG_FREEING	0x0010		/* dquot is being torn down */
-
-#define XFS_DQ_ALLTYPES		(XFS_DQ_USER|XFS_DQ_PROJ|XFS_DQ_GROUP)
+#define XFS_DQFLAG_DIRTY	(1 << 0)	/* dquot is dirty */
+#define XFS_DQFLAG_FREEING	(1 << 1)	/* dquot is being torn down */
 
 #define XFS_DQFLAG_STRINGS \
-	{ XFS_DQ_USER,		"USER" }, \
-	{ XFS_DQ_PROJ,		"PROJ" }, \
-	{ XFS_DQ_GROUP,		"GROUP" }, \
 	{ XFS_DQFLAG_DIRTY,	"DIRTY" }, \
 	{ XFS_DQFLAG_FREEING,	"FREEING" }
 
diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index cece9f69bbfb..023820d45a50 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -109,10 +109,6 @@ xchk_quota_item(
 
 	sqi->last_id = id;
 
-	/* Did we get the dquot type we wanted? */
-	if (d->d_flags != dqtype)
-		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
-
 	if (d->d_pad0 != cpu_to_be32(0) || d->d_pad != cpu_to_be16(0))
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
 
diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 682d1ed78894..bc9f58a71fa0 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -547,11 +547,11 @@ xlog_recover_do_dquot_buffer(
 
 	type = 0;
 	if (buf_f->blf_flags & XFS_BLF_UDQUOT_BUF)
-		type |= XFS_DQ_USER;
+		type |= XFS_DDQTYPE_USER;
 	if (buf_f->blf_flags & XFS_BLF_PDQUOT_BUF)
-		type |= XFS_DQ_PROJ;
+		type |= XFS_DDQTYPE_PROJ;
 	if (buf_f->blf_flags & XFS_BLF_GDQUOT_BUF)
-		type |= XFS_DQ_GROUP;
+		type |= XFS_DDQTYPE_GROUP;
 	/*
 	 * This type of quotas was turned off, so ignore this buffer
 	 */
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 91d81a346801..6fcea0d3989e 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -238,7 +238,7 @@ xfs_qm_init_dquot_blk(
 		d->dd_diskdq.d_magic = cpu_to_be16(XFS_DQUOT_MAGIC);
 		d->dd_diskdq.d_version = XFS_DQUOT_VERSION;
 		d->dd_diskdq.d_id = cpu_to_be32(curid);
-		d->dd_diskdq.d_flags = type;
+		d->dd_diskdq.d_type = type;
 		if (xfs_sb_version_hascrc(&mp->m_sb)) {
 			uuid_copy(&d->dd_uuid, &mp->m_sb.sb_meta_uuid);
 			xfs_update_cksum((char *)d, sizeof(struct xfs_dqblk),
@@ -543,7 +543,7 @@ xfs_dquot_from_disk(
 	 * Ensure that we got the type and ID we were looking for.
 	 * Everything else was checked by the dquot buffer verifier.
 	 */
-	if ((ddqp->d_flags & XFS_DQ_ALLTYPES) != dqp->q_type ||
+	if ((ddqp->d_type & XFS_DDQTYPE_REC_MASK) != dqp->q_type ||
 	    ddqp->d_id != dqp->q_core.d_id) {
 		xfs_alert_tag(bp->b_mount, XFS_PTAG_VERIFIER_ERROR,
 			  "Metadata corruption detected at %pS, quota %u",
diff --git a/fs/xfs/xfs_dquot_item_recover.c b/fs/xfs/xfs_dquot_item_recover.c
index a39708879874..6709ea324778 100644
--- a/fs/xfs/xfs_dquot_item_recover.c
+++ b/fs/xfs/xfs_dquot_item_recover.c
@@ -39,7 +39,7 @@ xlog_recover_dquot_ra_pass2(
 	if (item->ri_buf[1].i_len < sizeof(struct xfs_disk_dquot))
 		return;
 
-	type = recddq->d_flags & (XFS_DQ_USER | XFS_DQ_PROJ | XFS_DQ_GROUP);
+	type = recddq->d_type & XFS_DDQTYPE_REC_MASK;
 	ASSERT(type);
 	if (log->l_quotaoffs_flag & type)
 		return;
@@ -91,7 +91,7 @@ xlog_recover_dquot_commit_pass2(
 	/*
 	 * This type of quotas was turned off, so ignore this record.
 	 */
-	type = recddq->d_flags & (XFS_DQ_USER | XFS_DQ_PROJ | XFS_DQ_GROUP);
+	type = recddq->d_type & XFS_DDQTYPE_REC_MASK;
 	ASSERT(type);
 	if (log->l_quotaoffs_flag & type)
 		return 0;
@@ -185,11 +185,11 @@ xlog_recover_quotaoff_commit_pass1(
 	 * group/project quotaoff or both.
 	 */
 	if (qoff_f->qf_flags & XFS_UQUOTA_ACCT)
-		log->l_quotaoffs_flag |= XFS_DQ_USER;
+		log->l_quotaoffs_flag |= XFS_DDQTYPE_USER;
 	if (qoff_f->qf_flags & XFS_PQUOTA_ACCT)
-		log->l_quotaoffs_flag |= XFS_DQ_PROJ;
+		log->l_quotaoffs_flag |= XFS_DDQTYPE_PROJ;
 	if (qoff_f->qf_flags & XFS_GQUOTA_ACCT)
-		log->l_quotaoffs_flag |= XFS_DQ_GROUP;
+		log->l_quotaoffs_flag |= XFS_DDQTYPE_GROUP;
 
 	return 0;
 }
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index aabb08e85cd7..f6c18cc0c970 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -869,7 +869,7 @@ xfs_qm_reset_dqcounts(
 		 * Reset type in case we are reusing group quota file for
 		 * project quotas or vice versa
 		 */
-		ddq->d_flags = type;
+		ddq->d_type = type;
 		ddq->d_bcount = 0;
 		ddq->d_icount = 0;
 		ddq->d_rtbcount = 0;

