Return-Path: <SRS0=oQKh=AZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FBE4C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 01:35:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E82C217BA
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 01:35:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vAu8Ssns"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbgGNBfi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Jul 2020 21:35:38 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60136 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbgGNBfi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jul 2020 21:35:38 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06E1WwGJ127992;
        Tue, 14 Jul 2020 01:33:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=W6Cp4UbnNyCLoOigZWfj9/APjCVD0I0it3UpLvkyXv8=;
 b=vAu8SsnsdU8upk2Blw3GuHihnm/jz6PuAu5prct2TiBK/7SzOGKMBPPZS1/U4xZlrVPs
 nkfAyBbhxf+wce1+8nZVgKjiqjSkJLyvaeBcZ0Iw/+almaFOxt7WUrWXmFuAkDnlUuU1
 UCynqJWjFVvEAu88ut7a5wpK2zHBZbVk41d6UhI9pCvK2rbqzVBgx60VQ1Xnhu2O8p0+
 AfE+iJex0NIhGar+X3Uqp+/43fb+VnimpitFtwLfm3/3UjrIxRdw/7ylCMzQ3fXFetfG
 oOtYe4jZUqFaMByWNAp2iyNREoA6BT696+m10Li4mTHLYu7sZ8kASs9u05VdU3D5ffY5 yA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 32762naa05-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 14 Jul 2020 01:33:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06E1XWlb153797;
        Tue, 14 Jul 2020 01:33:32 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 327qb28mek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 01:33:32 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06E1XUxO010592;
        Tue, 14 Jul 2020 01:33:30 GMT
Received: from localhost (/10.159.128.100)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jul 2020 18:33:30 -0700
Subject: [PATCH 19/26] xfs: remove unnecessary arguments from quota adjust
 functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Mon, 13 Jul 2020 18:33:29 -0700
Message-ID: <159469040969.2914673.15978249157939197734.stgit@magnolia>
In-Reply-To: <159469028734.2914673.17856142063205791176.stgit@magnolia>
References: <159469028734.2914673.17856142063205791176.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 phishscore=0 suspectscore=1 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 clxscore=1015 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 bulkscore=0 suspectscore=1 phishscore=0 adultscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

struct xfs_dquot already has a pointer to the xfs mount, so remove the
redundant parameter from xfs_qm_adjust_dq*.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_dquot.c       |    4 ++--
 fs/xfs/xfs_dquot.h       |    6 ++----
 fs/xfs/xfs_qm.c          |    4 ++--
 fs/xfs/xfs_qm_syscalls.c |    2 +-
 fs/xfs/xfs_trans_dquot.c |    4 ++--
 5 files changed, 9 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 9b924743eea7..4e19aac586f4 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -67,9 +67,9 @@ xfs_qm_dqdestroy(
  */
 void
 xfs_qm_adjust_dqlimits(
-	struct xfs_mount	*mp,
 	struct xfs_dquot	*dq)
 {
+	struct xfs_mount	*mp = dq->q_mount;
 	struct xfs_quotainfo	*q = mp->m_quotainfo;
 	struct xfs_def_quota	*defq;
 	int			prealloc = 0;
@@ -113,9 +113,9 @@ xfs_qm_adjust_dqlimits(
  */
 void
 xfs_qm_adjust_dqtimers(
-	struct xfs_mount	*mp,
 	struct xfs_dquot	*dq)
 {
+	struct xfs_mount	*mp = dq->q_mount;
 	struct xfs_quotainfo	*qi = mp->m_quotainfo;
 	struct xfs_def_quota	*defq;
 
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 9bcfa3330f25..f55e40dfb9ed 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -188,10 +188,8 @@ void xfs_dquot_to_disk(struct xfs_disk_dquot *ddqp, struct xfs_dquot *dqp);
 void		xfs_qm_dqdestroy(struct xfs_dquot *dqp);
 int		xfs_qm_dqflush(struct xfs_dquot *dqp, struct xfs_buf **bpp);
 void		xfs_qm_dqunpin_wait(struct xfs_dquot *dqp);
-void		xfs_qm_adjust_dqtimers(struct xfs_mount *mp,
-						struct xfs_dquot *d);
-void		xfs_qm_adjust_dqlimits(struct xfs_mount *mp,
-						struct xfs_dquot *d);
+void		xfs_qm_adjust_dqtimers(struct xfs_dquot *d);
+void		xfs_qm_adjust_dqlimits(struct xfs_dquot *d);
 xfs_dqid_t	xfs_qm_id_for_quotatype(struct xfs_inode *ip,
 				xfs_dqtype_t type);
 int		xfs_qm_dqget(struct xfs_mount *mp, xfs_dqid_t id,
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 19e37749d8f5..96171f4406e9 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1101,8 +1101,8 @@ xfs_qm_quotacheck_dqadjust(
 	 * There are no timers for the default values set in the root dquot.
 	 */
 	if (dqp->q_id) {
-		xfs_qm_adjust_dqlimits(mp, dqp);
-		xfs_qm_adjust_dqtimers(mp, dqp);
+		xfs_qm_adjust_dqlimits(dqp);
+		xfs_qm_adjust_dqtimers(dqp);
 	}
 
 	dqp->q_flags |= XFS_DQFLAG_DIRTY;
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index b0c932086d59..aea4be4da424 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -594,7 +594,7 @@ xfs_qm_scall_setqlim(
 		 * is on or off. We don't really want to bother with iterating
 		 * over all ondisk dquots and turning the timers on/off.
 		 */
-		xfs_qm_adjust_dqtimers(mp, dqp);
+		xfs_qm_adjust_dqtimers(dqp);
 	}
 	dqp->q_flags |= XFS_DQFLAG_DIRTY;
 	xfs_trans_log_dquot(tp, dqp);
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index f08d37747e7e..53c133fd4f18 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -382,8 +382,8 @@ xfs_trans_apply_dquot_deltas(
 			 * Start/reset the timer(s) if needed.
 			 */
 			if (dqp->q_id) {
-				xfs_qm_adjust_dqlimits(tp->t_mountp, dqp);
-				xfs_qm_adjust_dqtimers(tp->t_mountp, dqp);
+				xfs_qm_adjust_dqlimits(dqp);
+				xfs_qm_adjust_dqtimers(dqp);
 			}
 
 			dqp->q_flags |= XFS_DQFLAG_DIRTY;

