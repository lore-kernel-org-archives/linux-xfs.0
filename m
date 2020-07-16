Return-Path: <SRS0=b91c=A3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2A06C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 06:47:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A7E7206F5
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 06:47:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MwaA+n2+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728102AbgGPGrn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jul 2020 02:47:43 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43308 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728036AbgGPGrm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jul 2020 02:47:42 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06G6l2RC167325
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:47:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=j1dd8A2qTuvJUEpQSHJqlrMAp8+CI1a9pkf8yOKxCaI=;
 b=MwaA+n2+ewxUEpKih+MUtvmwr1qcp6erTcsbrkx/lj3bHm9Oq+5YbMFtuOUqajMxTxCW
 uOAb+u10in1P3t6HQ5xiFihYqVSmjsnejf+kACQEyJXo8HLUVsZ/Tj+W8a8K7ArX0avW
 G2q7EhK+SGTR5R098IFB9IQmUiBynEGw9+jR7YS6gegJaRy6SJ2CjW5+kjmk7vjHFgAX
 vXNIestpLtt3djQJXHELpnxuMiuhYcjZIAablsYwoC74wVpZPSpIjBblz4xX1zYkpiXv
 GXeZ1G7wPVAnhlaG7e4jpYkcXSAY7ON7qkChqxaRi7haRSWVwB/8IVM2KWsAbp+CyIW/ 9A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 3275cmff5e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:47:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06G6gieL024544
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:45:41 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 327qc2jqwq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:45:40 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06G6jeIW011432
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:45:40 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jul 2020 23:45:40 -0700
Subject: [PATCH 03/11] xfs: refactor testing if a particular dquot is being
 enforced
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 15 Jul 2020 23:45:39 -0700
Message-ID: <159488193887.3813063.5488114906141814243.stgit@magnolia>
In-Reply-To: <159488191927.3813063.6443979621452250872.stgit@magnolia>
References: <159488191927.3813063.6443979621452250872.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 spamscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007160050
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007160051
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a small helper to test if enforcement is enabled for a
given incore dquot and replace the open-code logic testing.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_dquot.h       |   17 +++++++++++++++++
 fs/xfs/xfs_qm_syscalls.c |    9 ++-------
 fs/xfs/xfs_trans_dquot.c |    4 +---
 3 files changed, 20 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 17a21677723f..fcf9bd676615 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -156,6 +156,23 @@ static inline struct xfs_dquot *xfs_inode_dquot(struct xfs_inode *ip, int type)
 	}
 }
 
+/* Decide if the dquot's limits are actually being enforced. */
+static inline bool
+xfs_dquot_is_enforced(
+	const struct xfs_dquot	*dqp)
+{
+	switch (dqp->dq_flags & XFS_DQTYPE_REC_MASK) {
+	case XFS_DQTYPE_USER:
+		return XFS_IS_UQUOTA_ENFORCED(dqp->q_mount);
+	case XFS_DQTYPE_GROUP:
+		return XFS_IS_GQUOTA_ENFORCED(dqp->q_mount);
+	case XFS_DQTYPE_PROJ:
+		return XFS_IS_PQUOTA_ENFORCED(dqp->q_mount);
+	}
+	ASSERT(0);
+	return false;
+}
+
 /*
  * Check whether a dquot is under low free space conditions. We assume the quota
  * is enabled and enforced.
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 119c3d7d5f51..f7dbc702e4d6 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -660,19 +660,14 @@ xfs_qm_scall_getquota_fill_qc(
 	 * gets turned off. No need to confuse the user level code,
 	 * so return zeroes in that case.
 	 */
-	if ((!XFS_IS_UQUOTA_ENFORCED(mp) && type == XFS_DQTYPE_USER) ||
-	    (!XFS_IS_GQUOTA_ENFORCED(mp) && type == XFS_DQTYPE_GROUP) ||
-	    (!XFS_IS_PQUOTA_ENFORCED(mp) && type == XFS_DQTYPE_PROJ)) {
+	if (!xfs_dquot_is_enforced(dqp)) {
 		dst->d_spc_timer = 0;
 		dst->d_ino_timer = 0;
 		dst->d_rt_spc_timer = 0;
 	}
 
 #ifdef DEBUG
-	if (((XFS_IS_UQUOTA_ENFORCED(mp) && type == XFS_DQTYPE_USER) ||
-	     (XFS_IS_GQUOTA_ENFORCED(mp) && type == XFS_DQTYPE_GROUP) ||
-	     (XFS_IS_PQUOTA_ENFORCED(mp) && type == XFS_DQTYPE_PROJ)) &&
-	    dqp->q_id != 0) {
+	if (xfs_dquot_is_enforced(dqp) && dqp->q_id != 0) {
 		if ((dst->d_space > dst->d_spc_softlimit) &&
 		    (dst->d_spc_softlimit > 0)) {
 			ASSERT(dst->d_spc_timer != 0);
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index ea61e279f831..d7d710d25bbd 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -650,9 +650,7 @@ xfs_trans_dqresv(
 	}
 
 	if ((flags & XFS_QMOPT_FORCE_RES) == 0 && dqp->q_id &&
-	    ((XFS_IS_UQUOTA_ENFORCED(dqp->q_mount) && XFS_QM_ISUDQ(dqp)) ||
-	     (XFS_IS_GQUOTA_ENFORCED(dqp->q_mount) && XFS_QM_ISGDQ(dqp)) ||
-	     (XFS_IS_PQUOTA_ENFORCED(dqp->q_mount) && XFS_QM_ISPDQ(dqp)))) {
+	    xfs_dquot_is_enforced(dqp)) {
 		int		quota_nl;
 		bool		fatal;
 

