Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3697C433E4
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 01:54:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFCBC2071B
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 01:54:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Np9CVHDw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbgGOByr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jul 2020 21:54:47 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40688 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726828AbgGOByr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jul 2020 21:54:47 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06F1lIY5101718;
        Wed, 15 Jul 2020 01:52:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=9PnjhKEWl1Yb5Wz3pH7qM2SG8j9GVbs/CDdO0eEjB3Q=;
 b=Np9CVHDw/cw7KwaaDwSE/QVHFlvyo4219wLnK+lif3cyndF73vIZKd+M/G3jLjSyTPOG
 MYgz2ttKwKaYkBQCuCbHvCZLi9Enucuk1y7FxW5Qi3zfVEWru3wEop9Ww4L+X/+HEZxX
 o6TgwcSZf2z+F64pSHRFnyIenfAgf/8rSh5fCe0AvOhBZ+SsG0+nT7XHPs5/l+fF68Pm
 ptvFdubN5ljkf4kRXeiJStJuVSafXMcyCbSB7SZo9UuK4kF78OG8joABX/8Q9OlTUqCi
 5PTdR7E5+qfU6E3Dfp5ISVKXtqctTN5+Ct13+rEp8cBu1MkiFiTLiLJY8X1tZZZndM8Z xg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 32762nggjs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 Jul 2020 01:52:42 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06F1laN8184500;
        Wed, 15 Jul 2020 01:52:42 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 327qb5wt61-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jul 2020 01:52:41 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06F1qeh9023925;
        Wed, 15 Jul 2020 01:52:40 GMT
Received: from localhost (/10.159.237.234)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Jul 2020 18:52:40 -0700
Subject: [PATCH 19/26] xfs: remove unnecessary arguments from quota adjust
 functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Tue, 14 Jul 2020 18:52:39 -0700
Message-ID: <159477795941.3263162.2072767139135568322.stgit@magnolia>
In-Reply-To: <159477783164.3263162.2564345443708779029.stgit@magnolia>
References: <159477783164.3263162.2564345443708779029.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 phishscore=0 suspectscore=1 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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
index 8107bb094641..648fecd959a1 100644
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
index 6ebf5bed65a7..c0680bd1a148 100644
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

