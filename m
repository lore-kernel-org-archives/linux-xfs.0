Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15299C3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:23:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA07D21872
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:23:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gJvgwMcW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbfHZVX3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:23:29 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53902 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727064AbfHZVX3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:23:29 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLDl8o000864;
        Mon, 26 Aug 2019 21:23:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=lFamiozB9yXJZ0dwCxWhGK3NobfGC6xPM3xAKZqKttM=;
 b=gJvgwMcWyrqgk0UoTqXknCTwqtbgUEgUOUntqCdT+BbMINXP6n24xzNHJACHE/DJkHCb
 isElR6XrldOGk7qGVixs31ManSFfXc6z4LZqJuS5xMILtsbJktzkb3P2UnMUOJ6nWvVR
 emYliNxx+a24zS4J5nGS+7ZBa13RrXny79sN6N6OzL5pbuaeSoJwEhlnyPbP0IzRBFqX
 9o1vOBbAcFBE+3Q3rswkydVKaKVRKB6hVY3GKYOHoK8DhaIfjdhxHvpV35q/C8bVuk7u
 nhFb9r5xLXC6i9gna3z2GmrqHqpqNS4Gomkia1OJ/RFGuCqMlYPqbtzpPA9sVVFzF3a4 xw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2umpxx04gj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:23:27 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLIcYu169604;
        Mon, 26 Aug 2019 21:21:27 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2umhu7wt0u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:21:26 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7QLLQKB001854;
        Mon, 26 Aug 2019 21:21:26 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:21:26 -0700
Subject: [PATCH 2/3] xfs_scrub: fix nr_dirs accounting problems
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:21:25 -0700
Message-ID: <156685448524.2840069.582566075645213965.stgit@magnolia>
In-Reply-To: <156685447255.2840069.707517725113377305.stgit@magnolia>
References: <156685447255.2840069.707517725113377305.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260198
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260198
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
---
 scrub/vfs.c |   38 +++++++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 9 deletions(-)


diff --git a/scrub/vfs.c b/scrub/vfs.c
index ea2866d9..b358ab4a 100644
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
@@ -73,11 +99,10 @@ queue_subdir(
 	new_sftd->sft = sft;
 	new_sftd->rootdir = is_rootdir;
 
-	pthread_mutex_lock(&sft->lock);
-	sft->nr_dirs++;
-	pthread_mutex_unlock(&sft->lock);
+	inc_nr_dirs(sft);
 	error = workqueue_add(wq, scan_fs_dir, 0, new_sftd);
 	if (error) {
+		dec_nr_dirs(sft);
 		str_info(ctx, ctx->mntpoint,
 _("Could not queue subdirectory scan work."));
 		return false;
@@ -172,12 +197,7 @@ scan_fs_dir(
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

