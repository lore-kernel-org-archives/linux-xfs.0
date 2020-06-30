Return-Path: <SRS0=3PXQ=AL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AA49C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 15:43:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB2A420760
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 15:43:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CRikhRuA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389651AbgF3PnS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Jun 2020 11:43:18 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45220 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389647AbgF3PnS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jun 2020 11:43:18 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UFgMXP007099
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:43:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=6wsJg6qblgLlmjXAy1K2C0pln5DvS5UWaIXblb0XdOU=;
 b=CRikhRuAbOqCRwT1BJqsQ1LXOeDL/p9+nzZqmOiYmZSbhh8Sg9ydZ2i6NZru2dRX45h/
 YyzwoaI+EbVyJSzWbtuWs0kYdBa+5rPgkWVDpf+NdRxeiJX87efVCfpCGs8lXutvRS86
 WlemS//vOt4E8sHOjGEJR0XenLg8zBBbC3TNNoGKnlWixPKCZudTxKmLYvYWZQ8TIbsc
 6KFDK9gCXi+V1rrQuGNJ5VIn/hsbUSTvDp09KSFZxLEBN9fWktMxhb31q6XOAY3TZxTl
 1wvP6ZfjxUum0CLpJRtcYKR41wdQFyQJHjm1VcmXx7whQz9oaaKFfFSUrC7pZN/6pcX6 WQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 31wxrn59yr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:43:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UFgxLW084119
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:43:16 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 31xg13qmkx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:43:16 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05UFhF5H017361
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:43:15 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 30 Jun 2020 15:43:14 +0000
Subject: [PATCH 13/18] xfs: remove unnecessary arguments from quota adjust
 functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 30 Jun 2020 08:43:13 -0700
Message-ID: <159353179380.2864738.11917531841285726141.stgit@magnolia>
In-Reply-To: <159353170983.2864738.16885438169173786208.stgit@magnolia>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9667 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=1 bulkscore=0 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006300113
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9667 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 adultscore=0 cotscore=-2147483648
 lowpriorityscore=0 suspectscore=1 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300113
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

struct xfs_dquot already has a pointer to the xfs mount, so remove the
redundant parameter from xfs_qm_adjust_dq*.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_dquot.c       |    4 ++--
 fs/xfs/xfs_dquot.h       |    6 ++----
 fs/xfs/xfs_qm.c          |    4 ++--
 fs/xfs/xfs_qm_syscalls.c |    2 +-
 fs/xfs/xfs_trans_dquot.c |    4 ++--
 5 files changed, 9 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 6975c27145fc..35a113d1b42b 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -66,9 +66,9 @@ xfs_qm_dqdestroy(
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
@@ -112,9 +112,9 @@ xfs_qm_adjust_dqlimits(
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
index 62b0fc6e0133..e37b4bebc1ea 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -181,10 +181,8 @@ void xfs_dquot_to_disk(struct xfs_disk_dquot *ddqp, struct xfs_dquot *dqp);
 void		xfs_qm_dqdestroy(struct xfs_dquot *dqp);
 int		xfs_qm_dqflush(struct xfs_dquot *dqp, struct xfs_buf **bpp);
 void		xfs_qm_dqunpin_wait(struct xfs_dquot *dqp);
-void		xfs_qm_adjust_dqtimers(struct xfs_mount *mp,
-						struct xfs_dquot *d);
-void		xfs_qm_adjust_dqlimits(struct xfs_mount *mp,
-						struct xfs_dquot *d);
+void		xfs_qm_adjust_dqtimers(struct xfs_dquot *d);
+void		xfs_qm_adjust_dqlimits(struct xfs_dquot *d);
 xfs_dqid_t	xfs_qm_id_for_quotatype(struct xfs_inode *ip, uint type);
 int		xfs_qm_dqget(struct xfs_mount *mp, xfs_dqid_t id,
 					uint type, bool can_alloc,
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 28326a6264a8..30deb6cf6a7a 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1107,8 +1107,8 @@ xfs_qm_quotacheck_dqadjust(
 	 * There are no timers for the default values set in the root dquot.
 	 */
 	if (dqp->q_id) {
-		xfs_qm_adjust_dqlimits(mp, dqp);
-		xfs_qm_adjust_dqtimers(mp, dqp);
+		xfs_qm_adjust_dqlimits(dqp);
+		xfs_qm_adjust_dqtimers(dqp);
 	}
 
 	dqp->dq_flags |= XFS_DQ_DIRTY;
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 393b88612cc8..5423e02f9837 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -594,7 +594,7 @@ xfs_qm_scall_setqlim(
 		 * is on or off. We don't really want to bother with iterating
 		 * over all ondisk dquots and turning the timers on/off.
 		 */
-		xfs_qm_adjust_dqtimers(mp, dqp);
+		xfs_qm_adjust_dqtimers(dqp);
 	}
 	dqp->dq_flags |= XFS_DQ_DIRTY;
 	xfs_trans_log_dquot(tp, dqp);
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 392e51baad6f..2712814d696d 100644
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
 
 			dqp->dq_flags |= XFS_DQ_DIRTY;

