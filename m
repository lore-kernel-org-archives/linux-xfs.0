Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5F6EC432C2
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:34:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B73DF21D80
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:34:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="esqDddYY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbfIYVeL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:34:11 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58158 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727058AbfIYVeL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:34:11 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLT2qT050618;
        Wed, 25 Sep 2019 21:33:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=PLGCz0g+q3R0fzk//ee5GCzfpWRIQI0a75gt/FydX4k=;
 b=esqDddYYXcH4m6sNLfbFBl78gs3iVqTLHLDEXxJRpPHjN/fN334+MNrLXnZzmOGqA3Gk
 BSyueY0sFx7o9O3KYXX0UUZuLpLz/xC1iAef7b6DVmm2vwZa/us0/k8NOa7aypQoeg5G
 WWijU/VPFcBxra6tDmDF/DMn4YMrhfQfayoQltNICmw4+5/f9JCihNQDAXqBBzUavTfh
 XUU8w/xTL4MrUNrvlFVFbM/L43shCPvAHON/onLEGUmzTowaQnaiH/om8z0ogXANFAQq
 UgRyS6HXa6KaOBMY+DSkgnhoV1scGTEC2uhkMYmqlaR7NhZpsBx66bV1TqD85jADbM3L /Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2v5cgr7erq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:33:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLTEuu085297;
        Wed, 25 Sep 2019 21:31:54 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2v82qakn84-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:31:53 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8PLVrN6012891;
        Wed, 25 Sep 2019 21:31:53 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:31:53 -0700
Subject: [PATCH 2/3] xfs_scrub: fix nr_dirs accounting problems
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Date:   Wed, 25 Sep 2019 14:31:51 -0700
Message-ID: <156944711179.296293.18264050783564894159.stgit@magnolia>
In-Reply-To: <156944709972.296293.5229534796146134040.stgit@magnolia>
References: <156944709972.296293.5229534796146134040.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250173
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250173
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When we're scanning the directory tree, we bump nr_dirs every time we
think we're going to queue a new directory to process, and we decrement
it every time we're finished doing something with a directory
(successful or not).  We forgot to undo a counter increment when
workqueue_add fails, so refactor the code into helpers and call them
as necessary for correct operation.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 scrub/vfs.c |   42 +++++++++++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 13 deletions(-)


diff --git a/scrub/vfs.c b/scrub/vfs.c
index add4e815..f8bc98c0 100644
--- a/scrub/vfs.c
+++ b/scrub/vfs.c
@@ -45,6 +45,32 @@ struct scan_fs_tree_dir {
 
 static void scan_fs_dir(struct workqueue *wq, xfs_agnumber_t agno, void *arg);
 
+/* Increment the number of directories that are queued for processing. */
+static void
+inc_nr_dirs(
+	struct scan_fs_tree	*sft)
+{
+	pthread_mutex_lock(&sft->lock);
+	sft->nr_dirs++;
+	pthread_mutex_unlock(&sft->lock);
+}
+
+/*
+ * Decrement the number of directories that are queued for processing and if
+ * we ran out of dirs to process, wake up anyone who was waiting for processing
+ * to finish.
+ */
+static void
+dec_nr_dirs(
+	struct scan_fs_tree	*sft)
+{
+	pthread_mutex_lock(&sft->lock);
+	sft->nr_dirs--;
+	if (sft->nr_dirs == 0)
+		pthread_cond_signal(&sft->wakeup);
+	pthread_mutex_unlock(&sft->lock);
+}
+
 /* Queue a directory for scanning. */
 static bool
 queue_subdir(
@@ -72,15 +98,10 @@ queue_subdir(
 	new_sftd->sft = sft;
 	new_sftd->rootdir = is_rootdir;
 
-	pthread_mutex_lock(&sft->lock);
-	sft->nr_dirs++;
-	pthread_mutex_unlock(&sft->lock);
+	inc_nr_dirs(sft);
 	error = workqueue_add(wq, scan_fs_dir, 0, new_sftd);
 	if (error) {
-		/*
-		 * XXX: need to decrement nr_dirs here; will do that in the
-		 * next patch.
-		 */
+		dec_nr_dirs(sft);
 		str_info(ctx, ctx->mntpoint,
 _("Could not queue subdirectory scan work."));
 		goto out_path;
@@ -180,12 +201,7 @@ scan_fs_dir(
 		str_errno(ctx, sftd->path);
 
 out:
-	pthread_mutex_lock(&sft->lock);
-	sft->nr_dirs--;
-	if (sft->nr_dirs == 0)
-		pthread_cond_signal(&sft->wakeup);
-	pthread_mutex_unlock(&sft->lock);
-
+	dec_nr_dirs(sft);
 	free(sftd->path);
 	free(sftd);
 }

