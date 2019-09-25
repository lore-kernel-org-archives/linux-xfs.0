Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2DBAC432C2
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:34:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77DAC21D82
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:34:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Hf/kXOnZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbfIYVev (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:34:51 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37658 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727537AbfIYVev (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:34:51 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYRMr057966;
        Wed, 25 Sep 2019 21:34:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Yhsh6/l2T2NtO2IcFzcAv62SfLhsKuqqrZpAa8B0+co=;
 b=Hf/kXOnZVrVlqehhL6hG/0Ay3psDi71dcFtgCMYlv3f1AVZHUrGMZ0Hoc4FRUQ6ymCPd
 pUc+f26TMEdmZbwUL6j5k+F2UC/Ell6numAF98bbxQgHAYYrjtyxE+O8KwG2+FjG2F0M
 qR186QefJp8zV9ohy3MtE5/0kcXq2b8xOtjSADlXN2CZjjJu177OtYC51c14YuGNCwW5
 RKWeeUVSsWvKDPKnV7baE5YYDbGdzcmb9xyl6DeO5BJc7h4vhHGC+Ypiqpf5qPsiqWkJ
 JsH4/NcIPTrfpULP30YqTy/tdzg45dUIxp3emXlOuWRj7D2toQFeY7QGKOx00DWOoFLN aA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2v5b9tyh22-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:34:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYOFL023627;
        Wed, 25 Sep 2019 21:34:48 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2v7vnyup0q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:34:47 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8PLYkar014536;
        Wed, 25 Sep 2019 21:34:47 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:34:46 -0700
Subject: [PATCH 13/13] xfs_scrub: fix error handling problems in vfs.c
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Sep 2019 14:34:45 -0700
Message-ID: <156944728540.297677.4918291027551224418.stgit@magnolia>
In-Reply-To: <156944720314.297677.12837037497727069563.stgit@magnolia>
References: <156944720314.297677.12837037497727069563.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250174
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250174
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Fix all the places where we drop or screw up error handling in
scan_fs_tree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/vfs.c |   27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)


diff --git a/scrub/vfs.c b/scrub/vfs.c
index e0bc3ea4..d7c40239 100644
--- a/scrub/vfs.c
+++ b/scrub/vfs.c
@@ -216,6 +216,7 @@ scan_fs_tree(
 {
 	struct workqueue	wq;
 	struct scan_fs_tree	sft;
+	bool			moveon = false;
 	int			ret;
 
 	sft.moveon = true;
@@ -224,14 +225,22 @@ scan_fs_tree(
 	sft.dir_fn = dir_fn;
 	sft.dirent_fn = dirent_fn;
 	sft.arg = arg;
-	pthread_mutex_init(&sft.lock, NULL);
-	pthread_cond_init(&sft.wakeup, NULL);
+	ret = pthread_mutex_init(&sft.lock, NULL);
+	if (ret) {
+		str_liberror(ctx, ret, _("creating directory scan lock"));
+		return false;
+	}
+	ret = pthread_cond_init(&sft.wakeup, NULL);
+	if (ret) {
+		str_liberror(ctx, ret, _("creating directory scan signal"));
+		goto out_mutex;
+	}
 
 	ret = workqueue_create(&wq, (struct xfs_mount *)ctx,
 			scrub_nproc_workqueue(ctx));
 	if (ret) {
-		str_info(ctx, ctx->mntpoint, _("Could not create workqueue."));
-		return false;
+		str_liberror(ctx, ret, _("creating directory scan workqueue"));
+		goto out_cond;
 	}
 
 	ret = queue_subdir(ctx, &sft, &wq, ctx->mntpoint, true);
@@ -255,12 +264,18 @@ scan_fs_tree(
 
 	ret = workqueue_terminate(&wq);
 	if (ret) {
-		sft.moveon = false;
 		str_liberror(ctx, ret, _("finishing directory scan work"));
+		goto out_wq;
 	}
+
+	moveon = sft.moveon;
 out_wq:
 	workqueue_destroy(&wq);
-	return sft.moveon;
+out_cond:
+	pthread_cond_destroy(&sft.wakeup);
+out_mutex:
+	pthread_mutex_destroy(&sft.lock);
+	return moveon;
 }
 
 #ifndef FITRIM

