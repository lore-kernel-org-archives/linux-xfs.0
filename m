Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F4A9C3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:21:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F27320850
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:21:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Uot2QYTd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727963AbfHZVVY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:21:24 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42434 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbfHZVVX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:21:23 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLDm0x188975;
        Mon, 26 Aug 2019 21:21:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=v86jqC0BSI6oPQZ6E/MnDig+zkg6Tuf1GE8ZHG6Nt38=;
 b=Uot2QYTdxZ9LnznuMUby38GVToPaSEcs+C8OaMrebqti0e+vLrwYA9MwQAkpVv9wsqzB
 uw29dihpJRLmzWOJqw1tUmHGlEsbszMG63RSpH0pO8tqTAZ+traI22xkCVL9i7BvzsZt
 4fXhnYf28R/rY4f6yCVcd4mbFfn5XxG/16WbN8vJ1fvmbgQvZG/lPGZvrZDqAP1PQo7p
 /IzMK1V0RFzkqGT4Ht/D3QAQghgO2Zy7RlfnCLX9YltftAri51Slt1s9XUU0rAt5Qg4D
 jIWstc2CrguH70TKco7w6dY7ti7fZ9P55kmR7rtenbq4tPxYoCuYb4HRTVMsBtUC85dl jQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2ujwvqc4gb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:21:21 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLIda6169770;
        Mon, 26 Aug 2019 21:21:20 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2umhu7wsxh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:21:20 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7QLLKKf030345;
        Mon, 26 Aug 2019 21:21:20 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:21:19 -0700
Subject: [PATCH 1/3] xfs_scrub: refactor queueing of subdir scan work item
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:21:18 -0700
Message-ID: <156685447885.2840069.3132139174368034407.stgit@magnolia>
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

Replace the open-coded process of queueing a subdirectory for scanning
with a single helper function.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/vfs.c |   94 +++++++++++++++++++++++++++++++++--------------------------
 1 file changed, 52 insertions(+), 42 deletions(-)


diff --git a/scrub/vfs.c b/scrub/vfs.c
index 7b0b5bcd..ea2866d9 100644
--- a/scrub/vfs.c
+++ b/scrub/vfs.c
@@ -43,6 +43,49 @@ struct scan_fs_tree_dir {
 	bool			rootdir;
 };
 
+static void scan_fs_dir(struct workqueue *wq, xfs_agnumber_t agno, void *arg);
+
+/* Queue a directory for scanning. */
+static bool
+queue_subdir(
+	struct scrub_ctx	*ctx,
+	struct scan_fs_tree	*sft,
+	struct workqueue	*wq,
+	const char		*path,
+	bool			is_rootdir)
+{
+	struct scan_fs_tree_dir	*new_sftd;
+	int			error;
+
+	new_sftd = malloc(sizeof(struct scan_fs_tree_dir));
+	if (!new_sftd) {
+		str_errno(ctx, _("creating directory scan context"));
+		return false;
+	}
+
+	new_sftd->path = strdup(path);
+	if (!new_sftd->path) {
+		str_errno(ctx, _("creating directory scan path"));
+		free(new_sftd);
+		return false;
+	}
+
+	new_sftd->sft = sft;
+	new_sftd->rootdir = is_rootdir;
+
+	pthread_mutex_lock(&sft->lock);
+	sft->nr_dirs++;
+	pthread_mutex_unlock(&sft->lock);
+	error = workqueue_add(wq, scan_fs_dir, 0, new_sftd);
+	if (error) {
+		str_info(ctx, ctx->mntpoint,
+_("Could not queue subdirectory scan work."));
+		return false;
+	}
+
+	return true;
+}
+
 /* Scan a directory sub tree. */
 static void
 scan_fs_dir(
@@ -56,7 +99,6 @@ scan_fs_dir(
 	DIR			*dir;
 	struct dirent		*dirent;
 	char			newpath[PATH_MAX];
-	struct scan_fs_tree_dir	*new_sftd;
 	struct stat		sb;
 	int			dir_fd;
 	int			error;
@@ -117,25 +159,10 @@ scan_fs_dir(
 		/* If directory, call ourselves recursively. */
 		if (S_ISDIR(sb.st_mode) && strcmp(".", dirent->d_name) &&
 		    strcmp("..", dirent->d_name)) {
-			new_sftd = malloc(sizeof(struct scan_fs_tree_dir));
-			if (!new_sftd) {
-				str_errno(ctx, newpath);
-				sft->moveon = false;
-				break;
-			}
-			new_sftd->path = strdup(newpath);
-			new_sftd->sft = sft;
-			new_sftd->rootdir = false;
-			pthread_mutex_lock(&sft->lock);
-			sft->nr_dirs++;
-			pthread_mutex_unlock(&sft->lock);
-			error = workqueue_add(wq, scan_fs_dir, 0, new_sftd);
-			if (error) {
-				str_info(ctx, ctx->mntpoint,
-_("Could not queue subdirectory scan work."));
-				sft->moveon = false;
+			sft->moveon = queue_subdir(ctx, sft, wq, newpath,
+					false);
+			if (!sft->moveon)
 				break;
-			}
 		}
 	}
 
@@ -165,11 +192,10 @@ scan_fs_tree(
 {
 	struct workqueue	wq;
 	struct scan_fs_tree	sft;
-	struct scan_fs_tree_dir	*sftd;
 	int			ret;
 
 	sft.moveon = true;
-	sft.nr_dirs = 1;
+	sft.nr_dirs = 0;
 	sft.root_sb = ctx->mnt_sb;
 	sft.dir_fn = dir_fn;
 	sft.dirent_fn = dirent_fn;
@@ -177,41 +203,25 @@ scan_fs_tree(
 	pthread_mutex_init(&sft.lock, NULL);
 	pthread_cond_init(&sft.wakeup, NULL);
 
-	sftd = malloc(sizeof(struct scan_fs_tree_dir));
-	if (!sftd) {
-		str_errno(ctx, ctx->mntpoint);
-		return false;
-	}
-	sftd->path = strdup(ctx->mntpoint);
-	sftd->sft = &sft;
-	sftd->rootdir = true;
-
 	ret = workqueue_create(&wq, (struct xfs_mount *)ctx,
 			scrub_nproc_workqueue(ctx));
 	if (ret) {
 		str_info(ctx, ctx->mntpoint, _("Could not create workqueue."));
-		goto out_free;
+		return false;
 	}
-	ret = workqueue_add(&wq, scan_fs_dir, 0, sftd);
-	if (ret) {
-		str_info(ctx, ctx->mntpoint,
-_("Could not queue directory scan work."));
+
+	sft.moveon = queue_subdir(ctx, &sft, &wq, ctx->mntpoint, true);
+	if (!sft.moveon)
 		goto out_wq;
-	}
 
 	pthread_mutex_lock(&sft.lock);
 	pthread_cond_wait(&sft.wakeup, &sft.lock);
 	assert(sft.nr_dirs == 0);
 	pthread_mutex_unlock(&sft.lock);
-	workqueue_destroy(&wq);
 
-	return sft.moveon;
 out_wq:
 	workqueue_destroy(&wq);
-out_free:
-	free(sftd->path);
-	free(sftd);
-	return false;
+	return sft.moveon;
 }
 
 #ifndef FITRIM

