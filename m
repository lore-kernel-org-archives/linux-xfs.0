Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73437C3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:29:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 434C62186A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:29:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VKQykjsP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728642AbfHZV3p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:29:45 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49216 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728431AbfHZV3p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:29:45 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLF21J162110;
        Mon, 26 Aug 2019 21:29:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=erF9vdrhnDc2pNoqPof9RSDP0oFJvL/4GO3ePgBkysc=;
 b=VKQykjsPagXyly0s8VOh9sXgzN5eniOHihPpDVjcSXKhNyXnPhorjkiijlmQ/7PtWCCr
 /S1wdGxNjyCI/jEgr9VRL2ZyQ8JKxG1m1C4XAmhuW5/qT2Xz1gM154OoIDpzv9a1kPq4
 +4gkcHX2gWJgHaydEwuF4Jz+qCWNUMH5saJ7S8DEP9/o7ziSYyRgSUJ8Byjon7xcekrk
 Ck9frdkdX4Z1Wo2Q4V6ltap0iezwAPfZd/oCy0FBheXy18vbn9k93oyqlXXwouvbNAZx
 i3GjGy2e1QsHuk5CRGoAT7QFmSOqxdf3NPll9GEsKGClqvnBTp8VwTqh0Kj9apmex1O+ XA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2umq5t824u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:29:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLIJpU169960;
        Mon, 26 Aug 2019 21:29:43 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2umj27875s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:29:42 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7QLTf6U006288;
        Mon, 26 Aug 2019 21:29:42 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:29:41 -0700
Subject: [PATCH 12/13] xfs_scrub: move all the queue_subdir error reporting
 to callers
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:29:40 -0700
Message-ID: <156685498062.2841546.15534699593624208130.stgit@magnolia>
In-Reply-To: <156685489821.2841546.10616502094098044568.stgit@magnolia>
References: <156685489821.2841546.10616502094098044568.stgit@magnolia>
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

Change queue_subdir to return a positive error code to callers and move
the error reporting to the callers.  This continues the process of
changing internal functions to return error codes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/vfs.c |   44 +++++++++++++++++++++++++-------------------
 1 file changed, 25 insertions(+), 19 deletions(-)


diff --git a/scrub/vfs.c b/scrub/vfs.c
index 8aa58d6e..7053dbd6 100644
--- a/scrub/vfs.c
+++ b/scrub/vfs.c
@@ -72,7 +72,7 @@ dec_nr_dirs(
 }
 
 /* Queue a directory for scanning. */
-static bool
+static int
 queue_subdir(
 	struct scrub_ctx	*ctx,
 	struct scan_fs_tree	*sft,
@@ -81,33 +81,34 @@ queue_subdir(
 	bool			is_rootdir)
 {
 	struct scan_fs_tree_dir	*new_sftd;
-	int			error;
+	int			ret;
 
 	new_sftd = malloc(sizeof(struct scan_fs_tree_dir));
-	if (!new_sftd) {
-		str_errno(ctx, _("creating directory scan context"));
-		return false;
-	}
+	if (!new_sftd)
+		return errno;
 
 	new_sftd->path = strdup(path);
 	if (!new_sftd->path) {
-		str_errno(ctx, _("creating directory scan path"));
-		free(new_sftd);
-		return false;
+		ret = errno;
+		goto out_dir;
 	}
 
 	new_sftd->sft = sft;
 	new_sftd->rootdir = is_rootdir;
 
 	inc_nr_dirs(sft);
-	error = workqueue_add(wq, scan_fs_dir, 0, new_sftd);
-	if (error) {
+	ret = workqueue_add(wq, scan_fs_dir, 0, new_sftd);
+	if (ret) {
 		dec_nr_dirs(sft);
-		str_liberror(ctx, error, _("queueing directory scan work"));
-		return false;
+		goto out_path;
 	}
 
-	return true;
+	return 0;
+out_path:
+	free(new_sftd->path);
+out_dir:
+	free(new_sftd);
+	return ret;
 }
 
 /* Scan a directory sub tree. */
@@ -183,10 +184,13 @@ scan_fs_dir(
 		/* If directory, call ourselves recursively. */
 		if (S_ISDIR(sb.st_mode) && strcmp(".", dirent->d_name) &&
 		    strcmp("..", dirent->d_name)) {
-			sft->moveon = queue_subdir(ctx, sft, wq, newpath,
-					false);
-			if (!sft->moveon)
+			error = queue_subdir(ctx, sft, wq, newpath, false);
+			if (error) {
+				str_liberror(ctx, error,
+_("queueing subdirectory scan"));
+				sft->moveon = false;
 				break;
+			}
 		}
 	}
 
@@ -229,9 +233,11 @@ scan_fs_tree(
 		return false;
 	}
 
-	sft.moveon = queue_subdir(ctx, &sft, &wq, ctx->mntpoint, true);
-	if (!sft.moveon)
+	ret = queue_subdir(ctx, &sft, &wq, ctx->mntpoint, true);
+	if (ret) {
+		str_liberror(ctx, ret, _("queueing directory scan"));
 		goto out_wq;
+	}
 
 	pthread_mutex_lock(&sft.lock);
 	if (sft.nr_dirs)

