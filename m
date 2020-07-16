Return-Path: <SRS0=b91c=A3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61FB3C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 06:46:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A124206F5
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 06:46:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="U839cEAJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbgGPGqB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jul 2020 02:46:01 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42256 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727883AbgGPGqB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jul 2020 02:46:01 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06G6h1Ad163965
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:46:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=lJrcysAh8wV5uz4SKgSw3e+NC+RWgh20xnJbuJMKVvE=;
 b=U839cEAJgZhVGlllsKa8jjqS1SdAbJHER5RSygU+jlBqaL91auE33+3YfQ2Q6zDInnwK
 9aXDa6HksO5hlX2N8mr5QhJ4RcML8C31UcAvoVzZBTlq/zIgjIBWzKH6gmfdvF0RNiCn
 7PVXLzS/EkhPzDGWPQuxo4wgPih2ddtAihb4WmPpSf80l3n0fPiOdMT+8sm0+dgY0q+F
 SlIBs4ltfIgratYRUhevYXm17m9Zpv4rKTS2Ks/dh4AQBVev9EyzSVrgI9m83hk1lVVz
 HWcesqtqPdrUVZsYZluVMaiXd0VD8l0wL2Hpx67ie/DJOIovilyCeZCpStYz/Iuf+cQ0 Qw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 3275cmff0b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:46:00 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06G6hj2q040122
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:45:59 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 32a4cs375r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:45:59 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06G6jwQ0011584
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:45:59 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jul 2020 23:45:58 -0700
Subject: [PATCH 06/11] xfs: always use xfs_dquot_type when extracting type
 from a dquot
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 15 Jul 2020 23:45:57 -0700
Message-ID: <159488195772.3813063.4337415651120546350.stgit@magnolia>
In-Reply-To: <159488191927.3813063.6443979621452250872.stgit@magnolia>
References: <159488191927.3813063.6443979621452250872.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 suspectscore=1 bulkscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007160050
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007160050
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Always use the xfs_dquot_type helper to extract the quota type from an
incore dquot.  This moves responsibility for filtering internal state
information and whatnot to anybody passing around a dquot.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_dquot.c |   15 ++++++++-------
 fs/xfs/xfs_dquot.h |    2 +-
 2 files changed, 9 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index ce946d53bb61..b46a9e63b286 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -273,14 +273,15 @@ xfs_dquot_disk_alloc(
 	struct xfs_trans	*tp = *tpp;
 	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_buf		*bp;
-	struct xfs_inode	*quotip = xfs_quota_inode(mp, dqp->dq_flags);
+	uint			qtype = xfs_dquot_type(dqp);
+	struct xfs_inode	*quotip = xfs_quota_inode(mp, qtype);
 	int			nmaps = 1;
 	int			error;
 
 	trace_xfs_dqalloc(dqp);
 
 	xfs_ilock(quotip, XFS_ILOCK_EXCL);
-	if (!xfs_this_quota_on(dqp->q_mount, dqp->dq_flags)) {
+	if (!xfs_this_quota_on(dqp->q_mount, qtype)) {
 		/*
 		 * Return if this type of quotas is turned off while we didn't
 		 * have an inode lock
@@ -317,8 +318,7 @@ xfs_dquot_disk_alloc(
 	 * Make a chunk of dquots out of this buffer and log
 	 * the entire thing.
 	 */
-	xfs_qm_init_dquot_blk(tp, mp, dqp->q_id,
-			      dqp->dq_flags & XFS_DQTYPE_REC_MASK, bp);
+	xfs_qm_init_dquot_blk(tp, mp, dqp->q_id, xfs_dquot_type(dqp), bp);
 	xfs_buf_set_ref(bp, XFS_DQUOT_REF);
 
 	/*
@@ -365,13 +365,14 @@ xfs_dquot_disk_read(
 {
 	struct xfs_bmbt_irec	map;
 	struct xfs_buf		*bp;
-	struct xfs_inode	*quotip = xfs_quota_inode(mp, dqp->dq_flags);
+	uint			qtype = xfs_dquot_type(dqp);
+	struct xfs_inode	*quotip = xfs_quota_inode(mp, qtype);
 	uint			lock_mode;
 	int			nmaps = 1;
 	int			error;
 
 	lock_mode = xfs_ilock_data_map_shared(quotip);
-	if (!xfs_this_quota_on(mp, dqp->dq_flags)) {
+	if (!xfs_this_quota_on(mp, qtype)) {
 		/*
 		 * Return if this type of quotas is turned off while we
 		 * didn't have the quota inode lock.
@@ -487,7 +488,7 @@ xfs_dquot_from_disk(
 	 * Ensure that we got the type and ID we were looking for.
 	 * Everything else was checked by the dquot buffer verifier.
 	 */
-	if ((ddqp->d_flags & XFS_DQTYPE_REC_MASK) != dqp->dq_flags ||
+	if ((ddqp->d_flags & XFS_DQTYPE_REC_MASK) != xfs_dquot_type(dqp) ||
 	    be32_to_cpu(ddqp->d_id) != dqp->q_id) {
 		xfs_alert_tag(bp->b_mount, XFS_PTAG_VERIFIER_ERROR,
 			  "Metadata corruption detected at %pS, quota %u",
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 60bccb5f7435..07e18ce33560 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -167,7 +167,7 @@ static inline bool
 xfs_dquot_is_enforced(
 	const struct xfs_dquot	*dqp)
 {
-	switch (dqp->dq_flags & XFS_DQTYPE_REC_MASK) {
+	switch (xfs_dquot_type(dqp)) {
 	case XFS_DQTYPE_USER:
 		return XFS_IS_UQUOTA_ENFORCED(dqp->q_mount);
 	case XFS_DQTYPE_GROUP:

