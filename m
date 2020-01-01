Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42C9AC2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:11:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B188206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:11:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="T9KxoFCC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727154AbgAABLq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:11:46 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:54416 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbgAABLq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:11:46 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118xcb109438
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:11:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=IKybvFOU1NMxnG4Ebbe9s3IXvASDXW0zlhgNasGoYcM=;
 b=T9KxoFCCJqoJMC8pio0xZGDBue4g/qPKmTso3EpqyHGNg+u6k4OrmyVHiomTYRoeqtHr
 47McCLxuFwRxBU1WZf+XXB5pCk6CEKzVJFyb51u6M9Qmp6DLXP+J9GnMPITsfpsQ+C3Q
 LO+59ygj+JJHmjzUvPNvapHKLVz4z45OD0VwOMD3S+/+rAsY+nkr++Q3C2kd//XWgie/
 YJmzydLglFK+5SKRIRMaHpEstbMvMEWw5qloGAXKt0XAgzvuIFZHzmEGiMgO1cbwBkCo
 K/T0OU6Ue2O/hKaUhBhxMijig7RlrTthqkHOXI3hNAzHhLr+dg/4wjAPrw3pQCPhTRSQ Gg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2x5xftk2fj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:11:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118xH8012506
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:11:44 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2x8gueew0n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:11:43 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0011BgcL012055
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:11:42 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:11:42 -0800
Subject: [PATCH 06/14] xfs: refactor default quota grace period setting code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:11:40 -0800
Message-ID: <157784110016.1364230.5024129406313355261.stgit@magnolia>
In-Reply-To: <157784106066.1364230.569420432829402226.stgit@magnolia>
References: <157784106066.1364230.569420432829402226.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor the code that sets the default quota grace period into a helper
function so that we can override the ondisk behavior later.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h |    8 ++++++++
 fs/xfs/xfs_ondisk.h        |    2 ++
 fs/xfs/xfs_qm_syscalls.c   |   35 +++++++++++++++++++++++------------
 fs/xfs/xfs_trans_dquot.c   |   16 ++++++++++++----
 4 files changed, 45 insertions(+), 16 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 95761b38fe86..557db5e51eec 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1188,6 +1188,10 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
  * time zero is the Unix epoch, Jan  1 00:00:01 UTC 1970.  An expiration value
  * of zero means that the quota limit has not been reached, and therefore no
  * expiration has been set.
+ *
+ * The length of quota grace periods are unsigned 32-bit quantities in units of
+ * seconds (which are stored in the root dquot).  A value of zero means to use
+ * the default period.
  */
 
 /*
@@ -1202,6 +1206,10 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
  */
 #define XFS_DQ_TIMEOUT_MAX	((int64_t)U32_MAX)
 
+/* Quota grace periods, ranging from zero (use the defaults) to ~136 years. */
+#define XFS_DQ_GRACE_MIN	((int64_t)0)
+#define XFS_DQ_GRACE_MAX	((int64_t)U32_MAX)
+
 /*
  * This is the main portion of the on-disk representation of quota
  * information for a user. This is the q_core of the struct xfs_dquot that
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 52dc5326b7bf..b8811f927a3c 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -27,6 +27,8 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_VALUE(XFS_INO_TIME_MAX,			2147483647LL);
 	XFS_CHECK_VALUE(XFS_DQ_TIMEOUT_MIN,			1LL);
 	XFS_CHECK_VALUE(XFS_DQ_TIMEOUT_MAX,			4294967295LL);
+	XFS_CHECK_VALUE(XFS_DQ_GRACE_MIN,			0LL);
+	XFS_CHECK_VALUE(XFS_DQ_GRACE_MAX,			4294967295LL);
 
 	/* ag/file structures */
 	XFS_CHECK_STRUCT_SIZE(struct xfs_acl,			4);
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 74220948a360..20a6d304d1be 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -438,6 +438,20 @@ xfs_qm_scall_quotaon(
 	return 0;
 }
 
+/* Set a new quota grace period. */
+static inline void
+xfs_qm_set_grace(
+	time_t			*qi_limit,
+	__be32			*dtimer,
+	const s64		grace)
+{
+	time64_t		new_grace;
+
+	new_grace = clamp_t(time64_t, grace, XFS_DQ_GRACE_MIN,
+					     XFS_DQ_GRACE_MAX);
+	*dtimer = cpu_to_be32(new_grace);
+}
+
 #define XFS_QC_MASK \
 	(QC_LIMIT_MASK | QC_TIMER_MASK | QC_WARNS_MASK)
 
@@ -567,18 +581,15 @@ xfs_qm_scall_setqlim(
 		 * soft and hard limit values (already done, above), and
 		 * for warnings.
 		 */
-		if (newlim->d_fieldmask & QC_SPC_TIMER) {
-			q->qi_btimelimit = newlim->d_spc_timer;
-			ddq->d_btimer = cpu_to_be32(newlim->d_spc_timer);
-		}
-		if (newlim->d_fieldmask & QC_INO_TIMER) {
-			q->qi_itimelimit = newlim->d_ino_timer;
-			ddq->d_itimer = cpu_to_be32(newlim->d_ino_timer);
-		}
-		if (newlim->d_fieldmask & QC_RT_SPC_TIMER) {
-			q->qi_rtbtimelimit = newlim->d_rt_spc_timer;
-			ddq->d_rtbtimer = cpu_to_be32(newlim->d_rt_spc_timer);
-		}
+		if (newlim->d_fieldmask & QC_SPC_TIMER)
+			xfs_qm_set_grace(&q->qi_btimelimit, &ddq->d_btimer,
+					newlim->d_spc_timer);
+		if (newlim->d_fieldmask & QC_INO_TIMER)
+			xfs_qm_set_grace(&q->qi_itimelimit, &ddq->d_itimer,
+					newlim->d_ino_timer);
+		if (newlim->d_fieldmask & QC_RT_SPC_TIMER)
+			xfs_qm_set_grace(&q->qi_rtbtimelimit, &ddq->d_rtbtimer,
+					newlim->d_rt_spc_timer);
 		if (newlim->d_fieldmask & QC_SPC_WARNS)
 			q->qi_bwarnlimit = newlim->d_spc_warns;
 		if (newlim->d_fieldmask & QC_INO_WARNS)
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 248cfc369efc..7a2a3bd11db9 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -563,6 +563,14 @@ xfs_quota_warn(
 			   mp->m_super->s_dev, type);
 }
 
+/* Has a quota grace period expired? */
+static inline bool
+xfs_quota_timer_exceeded(
+	time64_t		timer)
+{
+	return timer != 0 && get_seconds() > timer;
+}
+
 /*
  * This reserves disk blocks and inodes against a dquot.
  * Flags indicate if the dquot is to be locked here and also
@@ -580,7 +588,7 @@ xfs_trans_dqresv(
 {
 	xfs_qcnt_t		hardlimit;
 	xfs_qcnt_t		softlimit;
-	time_t			timer;
+	time64_t		timer;
 	xfs_qwarncnt_t		warns;
 	xfs_qwarncnt_t		warnlimit;
 	xfs_qcnt_t		total_count;
@@ -635,7 +643,7 @@ xfs_trans_dqresv(
 				goto error_return;
 			}
 			if (softlimit && total_count > softlimit) {
-				if ((timer != 0 && get_seconds() > timer) ||
+				if (xfs_quota_timer_exceeded(timer) ||
 				    (warns != 0 && warns >= warnlimit)) {
 					xfs_quota_warn(mp, dqp,
 						       QUOTA_NL_BSOFTLONGWARN);
@@ -662,8 +670,8 @@ xfs_trans_dqresv(
 				goto error_return;
 			}
 			if (softlimit && total_count > softlimit) {
-				if  ((timer != 0 && get_seconds() > timer) ||
-				     (warns != 0 && warns >= warnlimit)) {
+				if (xfs_quota_timer_exceeded(timer) ||
+				    (warns != 0 && warns >= warnlimit)) {
 					xfs_quota_warn(mp, dqp,
 						       QUOTA_NL_ISOFTLONGWARN);
 					goto error_return;

