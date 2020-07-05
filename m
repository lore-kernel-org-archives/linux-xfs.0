Return-Path: <SRS0=iu4H=AQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CCBFC433DF
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Jul 2020 22:14:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24F7F212CC
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Jul 2020 22:14:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GOX0H1Ni"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbgGEWOR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 5 Jul 2020 18:14:17 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56978 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728103AbgGEWOR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Jul 2020 18:14:17 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 065MCS1r080644;
        Sun, 5 Jul 2020 22:14:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=+2BvtjE0hOqcv933cP3kSUBf+qR/k+OhG8OW2dvix3k=;
 b=GOX0H1Ni87Big5ki5ZDup/KFitnQLcv3QpX9AnpfYB4AxNLHM2Kdejj2U40PTRx2L4nQ
 VhloerWbwLhcJYUlIWImkCeTNWlstVBebHFt5+/zSd3zq6r+FkDXAQ7s7oUKm2+S2PkU
 HHJlEW1JJ35ukV6/U8J1vMX7G2VZAeYJynHiU0TcFz00V6lYkgExpJBujsIstrGpmcVd
 MhJWmu6Sc4Bsd9+Kg6rV+VK7KKrJ+R9tQdRn4KRcKamIYEWkdPKM3GmeGozUqOCFShod
 LaoxVJ88goIUpJCyMjUkZT7out2zr7KWy1zRSmKfIlw812UmOX7gUUi+FNFf6TuRHV+b aw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 322kv63b0a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 05 Jul 2020 22:14:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 065ME6VR101228;
        Sun, 5 Jul 2020 22:14:13 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 3233pubk5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 05 Jul 2020 22:14:13 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 065MECSG003348;
        Sun, 5 Jul 2020 22:14:12 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 05 Jul 2020 15:14:12 -0700
Subject: [PATCH 15/22] xfs: remove unnecessary arguments from quota adjust
 functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Sun, 05 Jul 2020 15:14:11 -0700
Message-ID: <159398725105.425236.13152856439428115354.stgit@magnolia>
In-Reply-To: <159398715269.425236.15910213189856396341.stgit@magnolia>
References: <159398715269.425236.15910213189856396341.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9673 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007050172
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9673 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 malwarescore=0 suspectscore=1 mlxlogscore=999 phishscore=0 spamscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 mlxscore=0 adultscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007050172
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
index 78dafaca6fee..3c3f2ab5ebd3 100644
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
index e2b218ffc7c8..9b715719e7fc 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1110,8 +1110,8 @@ xfs_qm_quotacheck_dqadjust(
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
index 791b6ae27b6c..580546f3ab40 100644
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
index 4eee634f40d1..130d97871a3d 100644
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

