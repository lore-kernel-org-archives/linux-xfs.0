Return-Path: <SRS0=b91c=A3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E6C8C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 06:47:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB328206F5
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 06:47:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iXYdppdr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728115AbgGPGrt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jul 2020 02:47:49 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43362 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728036AbgGPGrt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jul 2020 02:47:49 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06G6lAn5167363
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:47:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=bMdahKgd+2x1pbvpfxSvQ9wBmALTHeIHcJ+2IEVr+RY=;
 b=iXYdppdrFE4eX1CnaLd6/NGF+fPMGMrvnmwds0ejNASjyy810P8iExWxc2kv5fLgPs0O
 Eh+kruBbyTvxG8fUgJGsV4myOg8ig5eu8NkeWIY0yU/u6Jnjm8swSpZOXSl0XAfmxWP/
 obHNNRB5/+Q111m3Z4clz0JDeQhfaTCptBFfwzdATFRTufJMRS6nQPi9LOvGlkqJZq5n
 fH+8D/zfubRFsgVqpoM4O9BrEFmGwc4eIE5VvxiexC9J8nB/RxsMOsnnPaHxt8BQm1Qo
 oAcF7x2WCRpIHE7aZpfrJG6aV0A3PU3+gjHQzi83nQsVsYXNBF8+DRhIn4CC7R++NFMi /Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 3275cmff5v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:47:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06G6hfRY142964
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:45:47 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 327qba7403-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:45:47 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06G6jkkf011553
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:45:46 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jul 2020 23:45:46 -0700
Subject: [PATCH 04/11] xfs: remove the XFS_QM_IS[UGP]DQ macros
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 15 Jul 2020 23:45:45 -0700
Message-ID: <159488194524.3813063.1536581067461068233.stgit@magnolia>
In-Reply-To: <159488191927.3813063.6443979621452250872.stgit@magnolia>
References: <159488191927.3813063.6443979621452250872.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 phishscore=0 suspectscore=1 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007160050
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007160051
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Remove these macros and use xfs_dquot_type() for everything.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_dquot.h       |    9 ++++++---
 fs/xfs/xfs_qm.h          |   11 -----------
 fs/xfs/xfs_trans_dquot.c |   15 ++++++++++-----
 3 files changed, 16 insertions(+), 19 deletions(-)


diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index fcf9bd676615..60bccb5f7435 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -128,6 +128,12 @@ static inline void xfs_dqunlock(struct xfs_dquot *dqp)
 	mutex_unlock(&dqp->q_qlock);
 }
 
+static inline int
+xfs_dquot_type(const struct xfs_dquot *dqp)
+{
+	return dqp->dq_flags & XFS_DQTYPE_REC_MASK;
+}
+
 static inline int xfs_this_quota_on(struct xfs_mount *mp, int type)
 {
 	switch (type & XFS_DQTYPE_REC_MASK) {
@@ -192,9 +198,6 @@ void xfs_dquot_to_disk(struct xfs_disk_dquot *ddqp, struct xfs_dquot *dqp);
 
 #define XFS_DQ_IS_LOCKED(dqp)	(mutex_is_locked(&((dqp)->q_qlock)))
 #define XFS_DQ_IS_DIRTY(dqp)	((dqp)->q_flags & XFS_DQFLAG_DIRTY)
-#define XFS_QM_ISUDQ(dqp)	((dqp)->dq_flags & XFS_DQTYPE_USER)
-#define XFS_QM_ISPDQ(dqp)	((dqp)->dq_flags & XFS_DQTYPE_PROJ)
-#define XFS_QM_ISGDQ(dqp)	((dqp)->dq_flags & XFS_DQTYPE_GROUP)
 
 void		xfs_qm_dqdestroy(struct xfs_dquot *dqp);
 int		xfs_qm_dqflush(struct xfs_dquot *dqp, struct xfs_buf **bpp);
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index 21bc67d4962c..f04af35349d7 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -101,17 +101,6 @@ xfs_quota_inode(xfs_mount_t *mp, uint dq_flags)
 	return NULL;
 }
 
-static inline int
-xfs_dquot_type(struct xfs_dquot *dqp)
-{
-	if (XFS_QM_ISUDQ(dqp))
-		return XFS_DQTYPE_USER;
-	if (XFS_QM_ISGDQ(dqp))
-		return XFS_DQTYPE_GROUP;
-	ASSERT(XFS_QM_ISPDQ(dqp));
-	return XFS_DQTYPE_PROJ;
-}
-
 extern void	xfs_trans_mod_dquot(struct xfs_trans *tp, struct xfs_dquot *dqp,
 				    uint field, int64_t delta);
 extern void	xfs_trans_dqjoin(struct xfs_trans *, struct xfs_dquot *);
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index d7d710d25bbd..19d3e283aafa 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -156,14 +156,19 @@ xfs_trans_get_dqtrx(
 	int			i;
 	struct xfs_dqtrx	*qa;
 
-	if (XFS_QM_ISUDQ(dqp))
+	switch (xfs_dquot_type(dqp)) {
+	case XFS_DQTYPE_USER:
 		qa = tp->t_dqinfo->dqs[XFS_QM_TRANS_USR];
-	else if (XFS_QM_ISGDQ(dqp))
+		break;
+	case XFS_DQTYPE_GROUP:
 		qa = tp->t_dqinfo->dqs[XFS_QM_TRANS_GRP];
-	else if (XFS_QM_ISPDQ(dqp))
+		break;
+	case XFS_DQTYPE_PROJ:
 		qa = tp->t_dqinfo->dqs[XFS_QM_TRANS_PRJ];
-	else
+		break;
+	default:
 		return NULL;
+	}
 
 	for (i = 0; i < XFS_QM_TRANS_MAXDQS; i++) {
 		if (qa[i].qt_dquot == NULL ||
@@ -713,7 +718,7 @@ xfs_trans_dqresv(
 
 error_return:
 	xfs_dqunlock(dqp);
-	if (XFS_QM_ISPDQ(dqp))
+	if (xfs_dquot_type(dqp) == XFS_DQTYPE_PROJ)
 		return -ENOSPC;
 	return -EDQUOT;
 }

