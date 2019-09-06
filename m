Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DC7DC43331
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:34:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 433AF206B8
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:34:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XIK4eVI2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392118AbfIFDeI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 23:34:08 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47718 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392128AbfIFDeI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 23:34:08 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863Y1v7109808;
        Fri, 6 Sep 2019 03:34:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=bWhWLK7qg/BuhufbP+WJDZ+OfiQbQL1c9m5+c5+2r9k=;
 b=XIK4eVI2Vky4clfF3d5x36tbRR2JX6dgeIotF3FzUxRaI2CtGyKmUqh4mxqLpHBtDVLR
 SFgrWlV210oG/rs+q/svrqJ2CTXq9g/Sa1E+Upus2VLPjlYQNtKheDEfBCbJ/zz0lqu8
 IFWBDxe1WxPPIKrp79Resxep2fljzGL2XaXIk62wyyxQGKLLeqnu411jcNYE9AGuJYXI
 SDNooeuXQLNj8dc4PfvyuS46oae4NegZ3kRjP4M1En/zuPn+TYH/6CVNiUXJdWsIqW3p
 1yBdcrW7/4Z3OZ3CCaFCF55YX8IXi90zoVystto10y4purn0YKWu99dcEOYfIhqYcPAc mA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2uuf4n033y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:34:05 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863XbVg069127;
        Fri, 6 Sep 2019 03:34:05 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2utvr4js6d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:34:05 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x863Y4wk003594;
        Fri, 6 Sep 2019 03:34:04 GMT
Received: from localhost (/10.159.148.70)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 20:34:03 -0700
Subject: [PATCH 1/3] xfs_scrub: refactor queueing of subdir scan work item
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 Sep 2019 20:34:03 -0700
Message-ID: <156774084332.2643257.12234848325153797756.stgit@magnolia>
In-Reply-To: <156774083707.2643257.15738851266613887341.stgit@magnolia>
References: <156774083707.2643257.15738851266613887341.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060039
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060039
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Replace the open-coded process of queueing a subdirectory for scanning
with a single helper function.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/vfs.c |  109 ++++++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 67 insertions(+), 42 deletions(-)


diff --git a/scrub/vfs.c b/scrub/vfs.c
index b5d54837..add4e815 100644
--- a/scrub/vfs.c
+++ b/scrub/vfs.c
@@ -43,6 +43,57 @@ struct scan_fs_tree_dir {
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
+		goto out_sftd;
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
+		/*
+		 * XXX: need to decrement nr_dirs here; will do that in the
+		 * next patch.
+		 */
+		str_info(ctx, ctx->mntpoint,
+_("Could not queue subdirectory scan work."));
+		goto out_path;
+	}
+
+	return true;
+out_path:
+	free(new_sftd->path);
+out_sftd:
+	free(new_sftd);
+	return false;
+}
+
 /* Scan a directory sub tree. */
 static void
 scan_fs_dir(
@@ -56,7 +107,6 @@ scan_fs_dir(
 	DIR			*dir;
 	struct dirent		*dirent;
 	char			newpath[PATH_MAX];
-	struct scan_fs_tree_dir	*new_sftd;
 	struct stat		sb;
 	int			dir_fd;
 	int			error;
@@ -117,25 +167,10 @@ scan_fs_dir(
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
 
@@ -165,11 +200,10 @@ scan_fs_tree(
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
@@ -177,41 +211,32 @@ scan_fs_tree(
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
 
+	/*
+	 * Wait for the wakeup to trigger, which should only happen when the
+	 * last worker thread decrements nr_dirs to zero.  Once the worker
+	 * triggers the wakeup and unlocks the sft lock, it's no longer safe
+	 * for any worker thread to access sft, as we now own the lock and are
+	 * about to tear everything down.
+	 */
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

