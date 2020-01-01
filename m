Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E655CC2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:13:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B373E206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:13:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Rqqp5c79"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727206AbgAABNd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:13:33 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:51086 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727134AbgAABNd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:13:33 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011DW1Y093835
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:13:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=hwf9IgfojTd12gSnrnhv4oMGwr8fNBwkjqcDDAj/KOs=;
 b=Rqqp5c79izW6+Qp3IdiFdccqkTqcYRRZXHf8UnCGA9IXc7yHXG+1EC+qujxZg1DFV9Np
 ztJvQRArIJlPnJJNkUJ+ELKaL+t48n3k/Kn7jrTmpzahRpDhzhx34d5PLc59sMxXXuGR
 v1J7IPAo2T9edtR8oc27a2Ehyiw8nlZ+jF8291h7oWBi4JHRd+Gwy+5zgHrliqvU77xh
 6JoI+NbAPVXynfhUupUrp7pgXunaxpPc/MFnwmflB25T42gYTncWq846Bxe1RBBiQqfe
 nEio66cUuOCgQpaKZl8el7820zlMHvlcz7xCMDkeYW2QCC8quC4Vga5rijUd3fNOfxbw jA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2x5ypqjwh0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:13:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118vUF190348
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:11:31 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2x8bsrg17e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:11:31 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0011BU5c032380
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:11:31 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:11:29 -0800
Subject: [PATCH 04/14] xfs: fix quota timer inactivation
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:11:27 -0800
Message-ID: <157784108755.1364230.10581541534925642174.stgit@magnolia>
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

We need to take the inactivated inodes' resource usage into account when
we decide if we're actually over quota.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_dquot.c       |   28 +++++++++++++++++-----------
 fs/xfs/xfs_dquot.h       |    2 +-
 fs/xfs/xfs_qm.c          |    2 +-
 fs/xfs/xfs_qm_syscalls.c |    2 +-
 fs/xfs/xfs_trans_dquot.c |    2 +-
 5 files changed, 21 insertions(+), 15 deletions(-)


diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 54e7fdcd1d4d..ae7bb6361a99 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -101,13 +101,16 @@ xfs_qm_adjust_dqlimits(
 
 static inline bool
 xfs_quota_exceeded(
-	const __be64		*count,
+	const __be64		*dcount,
+	xfs_qcnt_t		ina_count,
 	const __be64		*softlimit,
-	const __be64		*hardlimit) {
+	const __be64		*hardlimit)
+{
+	uint64_t		count = be64_to_cpup(dcount) - ina_count;
 
-	if (*softlimit && be64_to_cpup(count) > be64_to_cpup(softlimit))
+	if (*softlimit && count > be64_to_cpup(softlimit))
 		return true;
-	return *hardlimit && be64_to_cpup(count) > be64_to_cpup(hardlimit);
+	return *hardlimit && count > be64_to_cpup(hardlimit);
 }
 
 /*
@@ -126,8 +129,9 @@ xfs_quota_exceeded(
 void
 xfs_qm_adjust_dqtimers(
 	struct xfs_mount	*mp,
-	struct xfs_disk_dquot	*d)
+	struct xfs_dquot	*dqp)
 {
+	struct xfs_disk_dquot	*d = &dqp->q_core;
 	bool			over;
 
 	ASSERT(d->d_id);
@@ -144,8 +148,8 @@ xfs_qm_adjust_dqtimers(
 		       be64_to_cpu(d->d_rtb_hardlimit));
 #endif
 
-	over = xfs_quota_exceeded(&d->d_bcount, &d->d_blk_softlimit,
-			&d->d_blk_hardlimit);
+	over = xfs_quota_exceeded(&d->d_bcount, dqp->q_ina_bcount,
+			&d->d_blk_softlimit, &d->d_blk_hardlimit);
 	if (!d->d_btimer) {
 		if (over) {
 			d->d_btimer = cpu_to_be32(get_seconds() +
@@ -159,8 +163,8 @@ xfs_qm_adjust_dqtimers(
 		}
 	}
 
-	over = xfs_quota_exceeded(&d->d_icount, &d->d_ino_softlimit,
-			&d->d_ino_hardlimit);
+	over = xfs_quota_exceeded(&d->d_icount, dqp->q_ina_icount,
+			&d->d_ino_softlimit, &d->d_ino_hardlimit);
 	if (!d->d_itimer) {
 		if (over) {
 			d->d_itimer = cpu_to_be32(get_seconds() +
@@ -174,8 +178,8 @@ xfs_qm_adjust_dqtimers(
 		}
 	}
 
-	over = xfs_quota_exceeded(&d->d_rtbcount, &d->d_rtb_softlimit,
-			&d->d_rtb_hardlimit);
+	over = xfs_quota_exceeded(&d->d_rtbcount, dqp->q_ina_rtbcount,
+			&d->d_rtb_softlimit, &d->d_rtb_hardlimit);
 	if (!d->d_rtbtimer) {
 		if (over) {
 			d->d_rtbtimer = cpu_to_be32(get_seconds() +
@@ -1279,6 +1283,8 @@ xfs_dquot_adjust(
 	dqp->q_ina_icount += inodes;
 	dqp->q_ina_bcount += dblocks;
 	dqp->q_ina_rtbcount += rblocks;
+	if (dqp->q_core.d_id)
+		xfs_qm_adjust_dqtimers(dqp->q_mount, dqp);
 	xfs_dqunlock(dqp);
 }
 
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 0d58f4ae8349..d924da98f66a 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -164,7 +164,7 @@ void		xfs_qm_dqdestroy(struct xfs_dquot *dqp);
 int		xfs_qm_dqflush(struct xfs_dquot *dqp, struct xfs_buf **bpp);
 void		xfs_qm_dqunpin_wait(struct xfs_dquot *dqp);
 void		xfs_qm_adjust_dqtimers(struct xfs_mount *mp,
-						struct xfs_disk_dquot *d);
+				       struct xfs_dquot *dqp);
 void		xfs_qm_adjust_dqlimits(struct xfs_mount *mp,
 						struct xfs_dquot *d);
 xfs_dqid_t	xfs_qm_id_for_quotatype(struct xfs_inode *ip, uint type);
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index d4a9765c9502..268e028c9ec8 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1141,7 +1141,7 @@ xfs_qm_quotacheck_dqadjust(
 	 */
 	if (dqp->q_core.d_id) {
 		xfs_qm_adjust_dqlimits(mp, dqp);
-		xfs_qm_adjust_dqtimers(mp, &dqp->q_core);
+		xfs_qm_adjust_dqtimers(mp, dqp);
 	}
 
 	dqp->dq_flags |= XFS_DQ_DIRTY;
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 43ba4e6b5e22..74220948a360 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -593,7 +593,7 @@ xfs_qm_scall_setqlim(
 		 * is on or off. We don't really want to bother with iterating
 		 * over all ondisk dquots and turning the timers on/off.
 		 */
-		xfs_qm_adjust_dqtimers(mp, ddq);
+		xfs_qm_adjust_dqtimers(mp, dqp);
 	}
 	dqp->dq_flags |= XFS_DQ_DIRTY;
 	xfs_trans_log_dquot(tp, dqp);
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index a6fe2d8dc40f..248cfc369efc 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -388,7 +388,7 @@ xfs_trans_apply_dquot_deltas(
 			 */
 			if (d->d_id) {
 				xfs_qm_adjust_dqlimits(tp->t_mountp, dqp);
-				xfs_qm_adjust_dqtimers(tp->t_mountp, d);
+				xfs_qm_adjust_dqtimers(tp->t_mountp, dqp);
 			}
 
 			dqp->dq_flags |= XFS_DQ_DIRTY;

