Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08469C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:11:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC8FB206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:11:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="An9I/0x4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbgAABL0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:11:26 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:53084 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbgAABL0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:11:26 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011ALvf089850
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:11:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=K7JvRrccH/xH41TpbgdLBR/3+PoOm/CR7h81UFGot8s=;
 b=An9I/0x4QDgi05FvvKti3lc9njnK3Rsli+7dEwvD4ZTqpoL35NHT+lvj1u1RsoIgIZXb
 sWRMdMC5+L69nZ4AfcWGOBUB93M2G0HeHjodmmjv7T+QMAMSTeP4E1StWhso53y81WNA
 4nkkc2ElPPye/gAO8D2VQVtI48/GQD1Bd4Ae2fVRVpWq8O5BLFNO+kcoNbpqi8ykXZaT
 OlTiOn1y55PXBWTpFGE6hYnwsho+ZV0KqkHrc8as5YeBM8RpUUmZqV//bvfrfZOB0vZP
 HjRhcuR4t0tdK/Rd+7BKoQrMq2nTn0WWK53/zicAdKHCkpqFm5hEgtdevrPSxQ5yBm6K bA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2x5y0pjxw6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:11:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118v7N190321
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:11:24 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2x8bsrg15d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:11:24 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0011BOhK032335
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:11:24 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:11:23 -0800
Subject: [PATCH 03/14] xfs: refactor quota exceeded test
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:11:21 -0800
Message-ID: <157784108138.1364230.6221331077843589601.stgit@magnolia>
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

Refactor the open-coded test for whether or not we're over quota.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_dquot.c |   61 +++++++++++++++++++++-------------------------------
 1 file changed, 25 insertions(+), 36 deletions(-)


diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index e50c75d9d788..54e7fdcd1d4d 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -99,6 +99,17 @@ xfs_qm_adjust_dqlimits(
 		xfs_dquot_set_prealloc_limits(dq);
 }
 
+static inline bool
+xfs_quota_exceeded(
+	const __be64		*count,
+	const __be64		*softlimit,
+	const __be64		*hardlimit) {
+
+	if (*softlimit && be64_to_cpup(count) > be64_to_cpup(softlimit))
+		return true;
+	return *hardlimit && be64_to_cpup(count) > be64_to_cpup(hardlimit);
+}
+
 /*
  * Check the limits and timers of a dquot and start or reset timers
  * if necessary.
@@ -117,6 +128,8 @@ xfs_qm_adjust_dqtimers(
 	struct xfs_mount	*mp,
 	struct xfs_disk_dquot	*d)
 {
+	bool			over;
+
 	ASSERT(d->d_id);
 
 #ifdef DEBUG
@@ -131,71 +144,47 @@ xfs_qm_adjust_dqtimers(
 		       be64_to_cpu(d->d_rtb_hardlimit));
 #endif
 
+	over = xfs_quota_exceeded(&d->d_bcount, &d->d_blk_softlimit,
+			&d->d_blk_hardlimit);
 	if (!d->d_btimer) {
-		if ((d->d_blk_softlimit &&
-		     (be64_to_cpu(d->d_bcount) >
-		      be64_to_cpu(d->d_blk_softlimit))) ||
-		    (d->d_blk_hardlimit &&
-		     (be64_to_cpu(d->d_bcount) >
-		      be64_to_cpu(d->d_blk_hardlimit)))) {
+		if (over) {
 			d->d_btimer = cpu_to_be32(get_seconds() +
 					mp->m_quotainfo->qi_btimelimit);
 		} else {
 			d->d_bwarns = 0;
 		}
 	} else {
-		if ((!d->d_blk_softlimit ||
-		     (be64_to_cpu(d->d_bcount) <=
-		      be64_to_cpu(d->d_blk_softlimit))) &&
-		    (!d->d_blk_hardlimit ||
-		    (be64_to_cpu(d->d_bcount) <=
-		     be64_to_cpu(d->d_blk_hardlimit)))) {
+		if (!over) {
 			d->d_btimer = 0;
 		}
 	}
 
+	over = xfs_quota_exceeded(&d->d_icount, &d->d_ino_softlimit,
+			&d->d_ino_hardlimit);
 	if (!d->d_itimer) {
-		if ((d->d_ino_softlimit &&
-		     (be64_to_cpu(d->d_icount) >
-		      be64_to_cpu(d->d_ino_softlimit))) ||
-		    (d->d_ino_hardlimit &&
-		     (be64_to_cpu(d->d_icount) >
-		      be64_to_cpu(d->d_ino_hardlimit)))) {
+		if (over) {
 			d->d_itimer = cpu_to_be32(get_seconds() +
 					mp->m_quotainfo->qi_itimelimit);
 		} else {
 			d->d_iwarns = 0;
 		}
 	} else {
-		if ((!d->d_ino_softlimit ||
-		     (be64_to_cpu(d->d_icount) <=
-		      be64_to_cpu(d->d_ino_softlimit)))  &&
-		    (!d->d_ino_hardlimit ||
-		     (be64_to_cpu(d->d_icount) <=
-		      be64_to_cpu(d->d_ino_hardlimit)))) {
+		if (!over) {
 			d->d_itimer = 0;
 		}
 	}
 
+	over = xfs_quota_exceeded(&d->d_rtbcount, &d->d_rtb_softlimit,
+			&d->d_rtb_hardlimit);
 	if (!d->d_rtbtimer) {
-		if ((d->d_rtb_softlimit &&
-		     (be64_to_cpu(d->d_rtbcount) >
-		      be64_to_cpu(d->d_rtb_softlimit))) ||
-		    (d->d_rtb_hardlimit &&
-		     (be64_to_cpu(d->d_rtbcount) >
-		      be64_to_cpu(d->d_rtb_hardlimit)))) {
+		if (over) {
 			d->d_rtbtimer = cpu_to_be32(get_seconds() +
 					mp->m_quotainfo->qi_rtbtimelimit);
 		} else {
 			d->d_rtbwarns = 0;
 		}
 	} else {
-		if ((!d->d_rtb_softlimit ||
-		     (be64_to_cpu(d->d_rtbcount) <=
-		      be64_to_cpu(d->d_rtb_softlimit))) &&
-		    (!d->d_rtb_hardlimit ||
-		     (be64_to_cpu(d->d_rtbcount) <=
-		      be64_to_cpu(d->d_rtb_hardlimit)))) {
+		if (!over) {
 			d->d_rtbtimer = 0;
 		}
 	}

