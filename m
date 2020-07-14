Return-Path: <SRS0=oQKh=AZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E75DC433E7
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 01:32:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58AE62192A
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 01:32:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iI/BaZQM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbgGNBcY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Jul 2020 21:32:24 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38214 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726630AbgGNBcX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jul 2020 21:32:23 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06E1W1fR096105
        for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2020 01:32:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=py2r969/COB+YKKxEWgWtnYKpRcLRQQX1rb10NyK7bI=;
 b=iI/BaZQMUooZeA4yJbdG1uYZ7Ib7oh7nuyhR1cTZu3Eu9A9kS8FcuXhi1LcHy5WZU394
 V5sbp2H6D3/uiJ5BqKQJQTFbzKSnNaWAbD5QnZ80sCT2otxeAybq0qUJRPf2/EoFRRnl
 cnUBfoEGnjzJHxHLoTPFDBrBsggIWPgs6EVuVc5iIOxNXmjX20T334BeEyfm6pdGFW3q
 Iz1uXT6ea9mVnFLWUEdiqFQHVi2z/nvHfixgLDFpYhK/NkkUVWobxYWB/qncG/+pw0x3
 JaJo7xf7t9GOI3F8nP1cQQHv0Ny//5oFZRCC/X1kXoJgv8O05rJtjDNqc+FBMyvWx9fV EA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 3274ur2ews-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2020 01:32:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06E1TZ65107337
        for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2020 01:32:20 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 327q6r5a6v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2020 01:32:20 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06E1WJ4C012342
        for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2020 01:32:19 GMT
Received: from localhost (/10.159.128.100)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jul 2020 18:32:19 -0700
Subject: [PATCH 08/26] xfs: move the ondisk dquot flags to their own namespace
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 13 Jul 2020 18:32:19 -0700
Message-ID: <159469033930.2914673.6332873477280477365.stgit@magnolia>
In-Reply-To: <159469028734.2914673.17856142063205791176.stgit@magnolia>
References: <159469028734.2914673.17856142063205791176.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=3
 phishscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 suspectscore=3 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

For the ondisk dquot records, rename the field to "d_type", and then
create a separate XFS_DDQTYPE_ namespace for those flags.  Since we now
have a verifier that will spot dquots with unknown flags or invalid
quota types, we can drop the corresponding checks from the online
scrubber.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dquot_buf.c   |   12 +++++++-----
 fs/xfs/libxfs/xfs_format.h      |   13 ++++++++++++-
 fs/xfs/libxfs/xfs_quota_defs.h  |   34 +++++++++++++---------------------
 fs/xfs/scrub/quota.c            |    4 ----
 fs/xfs/xfs_buf_item_recover.c   |    6 +++---
 fs/xfs/xfs_dquot.c              |    4 ++--
 fs/xfs/xfs_dquot_item_recover.c |   10 +++++-----
 fs/xfs/xfs_qm.c                 |    2 +-
 8 files changed, 43 insertions(+), 42 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index 910c4066d11b..889e34b1a033 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -62,13 +62,15 @@ xfs_dquot_verify(
 	if (ddq->d_version != XFS_DQUOT_VERSION)
 		return __this_address;
 
-	ddq_type = ddq->d_flags & XFS_DQ_ALLTYPES;
+	if (ddq->d_type & ~XFS_DDQTYPE_ANY)
+		return __this_address;
+	ddq_type = ddq->d_type & XFS_DDQTYPE_REC_MASK;
 	if (type != XFS_DQTYPE_NONE &&
 	    ddq_type != xfs_dquot_type_to_disk(type))
 		return __this_address;
-	if (ddq_type != XFS_DQ_USER &&
-	    ddq_type != XFS_DQ_PROJ &&
-	    ddq_type != XFS_DQ_GROUP)
+	if (ddq_type != XFS_DDQTYPE_USER &&
+	    ddq_type != XFS_DDQTYPE_PROJ &&
+	    ddq_type != XFS_DDQTYPE_GROUP)
 		return __this_address;
 
 	if (id != -1 && id != be32_to_cpu(ddq->d_id))
@@ -127,7 +129,7 @@ xfs_dqblk_repair(
 
 	dqb->dd_diskdq.d_magic = cpu_to_be16(XFS_DQUOT_MAGIC);
 	dqb->dd_diskdq.d_version = XFS_DQUOT_VERSION;
-	dqb->dd_diskdq.d_flags = xfs_dquot_type_to_disk(type);
+	dqb->dd_diskdq.d_type = xfs_dquot_type_to_disk(type);
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
index 5a8f5c973495..0650fa71fa2b 100644
--- a/fs/xfs/libxfs/xfs_quota_defs.h
+++ b/fs/xfs/libxfs/xfs_quota_defs.h
@@ -31,41 +31,33 @@ typedef uint8_t		xfs_dqtype_t;
 	{ XFS_DQTYPE_PROJ,	"PROJ" }, \
 	{ XFS_DQTYPE_GROUP,	"GROUP" }
 
-/*
- * flags for q_flags field in the dquot.
- */
-#define XFS_DQ_USER		0x0001		/* a user quota */
-#define XFS_DQ_PROJ		0x0002		/* project quota */
-#define XFS_DQ_GROUP		0x0004		/* a group quota */
-#define XFS_DQFLAG_DIRTY	0x0008		/* dquot is dirty */
-#define XFS_DQFLAG_FREEING	0x0010		/* dquot is being torn down */
-
-#define XFS_DQ_ALLTYPES		(XFS_DQ_USER|XFS_DQ_PROJ|XFS_DQ_GROUP)
-
-#define XFS_DQFLAG_STRINGS \
-	{ XFS_DQ_USER,		"USER" }, \
-	{ XFS_DQ_PROJ,		"PROJ" }, \
-	{ XFS_DQ_GROUP,		"GROUP" }, \
-	{ XFS_DQFLAG_DIRTY,	"DIRTY" }, \
-	{ XFS_DQFLAG_FREEING,	"FREEING" }
-
 static inline __u8
 xfs_dquot_type_to_disk(
 	xfs_dqtype_t		type)
 {
 	switch (type) {
 	case XFS_DQTYPE_USER:
-		return XFS_DQ_USER;
+		return XFS_DDQTYPE_USER;
 	case XFS_DQTYPE_GROUP:
-		return XFS_DQ_GROUP;
+		return XFS_DDQTYPE_GROUP;
 	case XFS_DQTYPE_PROJ:
-		return XFS_DQ_PROJ;
+		return XFS_DDQTYPE_PROJ;
 	default:
 		ASSERT(0);
 		return 0;
 	}
 }
 
+/*
+ * flags for q_flags field in the dquot.
+ */
+#define XFS_DQFLAG_DIRTY	0x0008		/* dquot is dirty */
+#define XFS_DQFLAG_FREEING	0x0010		/* dquot is being torn down */
+
+#define XFS_DQFLAG_STRINGS \
+	{ XFS_DQFLAG_DIRTY,	"DIRTY" }, \
+	{ XFS_DQFLAG_FREEING,	"FREEING" }
+
 /*
  * We have the possibility of all three quota types being active at once, and
  * hence free space modification requires modification of all three current
diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index b665b62c43fe..023820d45a50 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -109,10 +109,6 @@ xchk_quota_item(
 
 	sqi->last_id = id;
 
-	/* Did we get the dquot type we wanted? */
-	if (d->d_flags != xfs_dquot_type_to_disk(dqtype))
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
index 98a83c2fe1d3..3e4a57c04caa 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -238,7 +238,7 @@ xfs_qm_init_dquot_blk(
 		d->dd_diskdq.d_magic = cpu_to_be16(XFS_DQUOT_MAGIC);
 		d->dd_diskdq.d_version = XFS_DQUOT_VERSION;
 		d->dd_diskdq.d_id = cpu_to_be32(curid);
-		d->dd_diskdq.d_flags = xfs_dquot_type_to_disk(type);
+		d->dd_diskdq.d_type = xfs_dquot_type_to_disk(type);
 		if (xfs_sb_version_hascrc(&mp->m_sb)) {
 			uuid_copy(&d->dd_uuid, &mp->m_sb.sb_meta_uuid);
 			xfs_update_cksum((char *)d, sizeof(struct xfs_dqblk),
@@ -544,7 +544,7 @@ xfs_dquot_from_disk(
 	 * Ensure that we got the type and ID we were looking for.
 	 * Everything else was checked by the dquot buffer verifier.
 	 */
-	if ((ddqp->d_flags & XFS_DQ_ALLTYPES) != ddq_type ||
+	if ((ddqp->d_type & XFS_DDQTYPE_REC_MASK) != ddq_type ||
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
index 9786acec4076..bb05a006b8f9 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -869,7 +869,7 @@ xfs_qm_reset_dqcounts(
 		 * Reset type in case we are reusing group quota file for
 		 * project quotas or vice versa
 		 */
-		ddq->d_flags = xfs_dquot_type_to_disk(type);
+		ddq->d_type = xfs_dquot_type_to_disk(type);
 		ddq->d_bcount = 0;
 		ddq->d_icount = 0;
 		ddq->d_rtbcount = 0;

