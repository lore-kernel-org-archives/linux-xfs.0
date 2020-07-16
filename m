Return-Path: <SRS0=b91c=A3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D73A8C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 06:45:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB576206F5
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 06:45:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ln64vizW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbgGPGpa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jul 2020 02:45:30 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:55606 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbgGPGpa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jul 2020 02:45:30 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06G6ftT0160371
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:45:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=SsL9upHv1fiU7UR5u309JVjO9e6lfRe7YcbpJGNChDs=;
 b=ln64vizW/TczGoR8fJfNbj56/K8mRFpieIA+yaOM+9PwNZko/IVCzKNjOMlD8Ao7l5bx
 cEouDIfJQu8lB07x27EUr4mNlq9l6aF4VNbAQdHfCDLI9cE5aVBYHTcm+ZiIWqIHAJo4
 33LOcwhFfeIL/DKWzBVQMmeAiL55SGLZ4KXqleKu8WXpYPIqIkEgGf67ya7Y9dwyaf8r
 pgoRXgaGKSarkWXmN8qi+7Y8zZIqZXyZ73V6RjwfyVQhQx5dS0bEXzYUeYd9neVFXH9z
 pzMhes0oDENMjzoUjVozLD3ri57kvEAMb+6/YnDIvaUAO4WQFpfkFgaN3x5pfp0V1lys Bg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 327s65nrfv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:45:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06G6hfqL143008
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:45:28 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 327qba736b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:45:28 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06G6jRpk007073
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:45:27 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jul 2020 23:45:27 -0700
Subject: [PATCH 01/11] xfs: drop the type parameter from xfs_dquot_verify
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 15 Jul 2020 23:45:25 -0700
Message-ID: <159488192588.3813063.14434497860489645794.stgit@magnolia>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxscore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 impostorscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007160050
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

xfs_qm_reset_dqcounts (i.e. quotacheck) is the only xfs_dqblk_verify
caller that actually knows the specific quota type that it's looking
for.  Since everything else just pass in type==0 (including the buffer
verifier), drop the parameter and open-code the check like
xfs_dquot_from_disk already does.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dquot_buf.c   |   12 ++++--------
 fs/xfs/libxfs/xfs_quota_defs.h  |    4 ++--
 fs/xfs/xfs_buf_item_recover.c   |    3 +--
 fs/xfs/xfs_dquot_item_recover.c |    2 +-
 fs/xfs/xfs_qm.c                 |    5 ++---
 5 files changed, 10 insertions(+), 16 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index bedc1e752b60..eb2412e13f30 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -37,8 +37,7 @@ xfs_failaddr_t
 xfs_dquot_verify(
 	struct xfs_mount	*mp,
 	struct xfs_disk_dquot	*ddq,
-	xfs_dqid_t		id,
-	uint			type)	/* used only during quotacheck */
+	xfs_dqid_t		id)	/* used only during quotacheck */
 {
 	/*
 	 * We can encounter an uninitialized dquot buffer for 2 reasons:
@@ -60,8 +59,6 @@ xfs_dquot_verify(
 	if (ddq->d_version != XFS_DQUOT_VERSION)
 		return __this_address;
 
-	if (type && ddq->d_flags != type)
-		return __this_address;
 	if (ddq->d_flags != XFS_DQ_USER &&
 	    ddq->d_flags != XFS_DQ_PROJ &&
 	    ddq->d_flags != XFS_DQ_GROUP)
@@ -95,14 +92,13 @@ xfs_failaddr_t
 xfs_dqblk_verify(
 	struct xfs_mount	*mp,
 	struct xfs_dqblk	*dqb,
-	xfs_dqid_t	 	id,
-	uint		 	type)	/* used only during quotacheck */
+	xfs_dqid_t		id)	/* used only during quotacheck */
 {
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
 	    !uuid_equal(&dqb->dd_uuid, &mp->m_sb.sb_meta_uuid))
 		return __this_address;
 
-	return xfs_dquot_verify(mp, &dqb->dd_diskdq, id, type);
+	return xfs_dquot_verify(mp, &dqb->dd_diskdq, id);
 }
 
 /*
@@ -205,7 +201,7 @@ xfs_dquot_buf_verify(
 		if (i == 0)
 			id = be32_to_cpu(ddq->d_id);
 
-		fa = xfs_dqblk_verify(mp, &dqb[i], id + i, 0);
+		fa = xfs_dqblk_verify(mp, &dqb[i], id + i);
 		if (fa) {
 			if (!readahead)
 				xfs_buf_verifier_error(bp, -EFSCORRUPTED,
diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
index e2da08055e6b..d2245f375719 100644
--- a/fs/xfs/libxfs/xfs_quota_defs.h
+++ b/fs/xfs/libxfs/xfs_quota_defs.h
@@ -137,9 +137,9 @@ typedef uint16_t	xfs_qwarncnt_t;
 #define XFS_QMOPT_RESBLK_MASK	(XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_RES_RTBLKS)
 
 extern xfs_failaddr_t xfs_dquot_verify(struct xfs_mount *mp,
-		struct xfs_disk_dquot *ddq, xfs_dqid_t id, uint type);
+		struct xfs_disk_dquot *ddq, xfs_dqid_t id);
 extern xfs_failaddr_t xfs_dqblk_verify(struct xfs_mount *mp,
-		struct xfs_dqblk *dqb, xfs_dqid_t id, uint type);
+		struct xfs_dqblk *dqb, xfs_dqid_t id);
 extern int xfs_calc_dquots_per_chunk(unsigned int nbblks);
 extern void xfs_dqblk_repair(struct xfs_mount *mp, struct xfs_dqblk *dqb,
 		xfs_dqid_t id, uint type);
diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 74c851f60eee..8bee582cf66a 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -493,8 +493,7 @@ xlog_recover_do_reg_buffer(
 					item->ri_buf[i].i_len, __func__);
 				goto next;
 			}
-			fa = xfs_dquot_verify(mp, item->ri_buf[i].i_addr,
-					       -1, 0);
+			fa = xfs_dquot_verify(mp, item->ri_buf[i].i_addr, -1);
 			if (fa) {
 				xfs_alert(mp,
 	"dquot corrupt at %pS trying to replay into block 0x%llx",
diff --git a/fs/xfs/xfs_dquot_item_recover.c b/fs/xfs/xfs_dquot_item_recover.c
index f9ea9f55aa7c..9f64162ca300 100644
--- a/fs/xfs/xfs_dquot_item_recover.c
+++ b/fs/xfs/xfs_dquot_item_recover.c
@@ -108,7 +108,7 @@ xlog_recover_dquot_commit_pass2(
 	 */
 	dq_f = item->ri_buf[0].i_addr;
 	ASSERT(dq_f);
-	fa = xfs_dquot_verify(mp, recddq, dq_f->qlf_id, 0);
+	fa = xfs_dquot_verify(mp, recddq, dq_f->qlf_id);
 	if (fa) {
 		xfs_alert(mp, "corrupt dquot ID 0x%x in log at %pS",
 				dq_f->qlf_id, fa);
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 7d83c1623cb2..bf94c1bbda16 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -830,7 +830,6 @@ xfs_qm_reset_dqcounts(
 {
 	struct xfs_dqblk	*dqb;
 	int			j;
-	xfs_failaddr_t		fa;
 
 	trace_xfs_reset_dqcounts(bp, _RET_IP_);
 
@@ -855,8 +854,8 @@ xfs_qm_reset_dqcounts(
 		 * find uninitialised dquot blks. See comment in
 		 * xfs_dquot_verify.
 		 */
-		fa = xfs_dqblk_verify(mp, &dqb[j], id + j, type);
-		if (fa)
+		if (xfs_dqblk_verify(mp, &dqb[j], id + j) ||
+		    (dqb[j].dd_diskdq.d_flags & XFS_DQ_ALLTYPES) != type)
 			xfs_dqblk_repair(mp, &dqb[j], id + j, type);
 
 		/*

