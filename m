Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1935DC2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:11:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF58A206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:11:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fWy/wKQ1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbgAABLV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:11:21 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:49844 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbgAABLV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:11:21 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011BJhH092847
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:11:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=9T/JfTkOY32oiB+laAV6aPy1lNZdF2smDWi12ApUl/8=;
 b=fWy/wKQ1Zd/8klokktUDtGPF/ukhmHQqVen7BLtgWuQIAgQ+VNBF0+ToXcF952jJ3eEl
 2ycMhdsBKO+lg1DW8syzCstU7oE14xRPfyqadsLRziHTkECmL7X2gwm7WpwWLBQMB1O6
 gutBCyXj9HlnjNIMvxqgYOwJvh7XC3HI09SMKE8Gs1KrZ+iDtORHOIreemXAwQ6pujqy
 uO2WumY0r5+ArQanrUyz7f2N++1kLYmkPsQCwh9uJnjc5wl+DhMmJu9WPg7tTSfCvL8M
 EZtVmxCL0dtV9nfozBWBMJ+qOzhKxUPnAryLhrb+klB+EnzdREkoTmoHZF4tWWmYQ4FL ZQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2x5ypqjwes-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:11:19 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118u9r045259
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:11:19 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2x7medfceg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:11:18 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0011BHEF011829
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:11:17 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:11:17 -0800
Subject: [PATCH 02/14] xfs: preserve default grace interval during quotacheck
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:11:15 -0800
Message-ID: <157784107520.1364230.49128863919644273.stgit@magnolia>
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

When quotacheck runs, it zeroes all the timer fields in every dquot.
Unfortunately, it also does this to the root dquot, which erases any
preconfigured grace interval that the administrator may have set.  Worse
yet, the incore copies of those variables remain set.  This cache
coherence problem manifests itself as the grace interval mysteriously
being reset back to the defaults at the /next/ mount.

Fix it by resetting the root disk dquot's timer fields to the incore
values.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_qm.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)


diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 0ce334c51d73..d4a9765c9502 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -842,6 +842,23 @@ xfs_qm_qino_alloc(
 	return error;
 }
 
+/* Save the grace period intervals when zeroing dquots for quotacheck. */
+static inline void
+xfs_qm_reset_dqintervals(
+	struct xfs_mount	*mp,
+	struct xfs_disk_dquot	*ddq)
+{
+	struct xfs_quotainfo	*qinf = mp->m_quotainfo;
+
+	if (qinf->qi_btimelimit != XFS_QM_BTIMELIMIT)
+		ddq->d_btimer = cpu_to_be32(qinf->qi_btimelimit);
+
+	if (qinf->qi_itimelimit != XFS_QM_ITIMELIMIT)
+		ddq->d_itimer = cpu_to_be32(qinf->qi_itimelimit);
+
+	if (qinf->qi_rtbtimelimit != XFS_QM_RTBTIMELIMIT)
+		ddq->d_rtbtimer = cpu_to_be32(qinf->qi_rtbtimelimit);
+}
 
 STATIC void
 xfs_qm_reset_dqcounts(
@@ -895,6 +912,8 @@ xfs_qm_reset_dqcounts(
 		ddq->d_bwarns = 0;
 		ddq->d_iwarns = 0;
 		ddq->d_rtbwarns = 0;
+		if (!ddq->d_id)
+			xfs_qm_reset_dqintervals(mp, ddq);
 
 		if (xfs_sb_version_hascrc(&mp->m_sb)) {
 			xfs_update_cksum((char *)&dqb[j],

