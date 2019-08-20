Return-Path: <SRS0=kQBn=WQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C4BEC3A59E
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 20:32:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 193232332B
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 20:32:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CbO6kr5j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730501AbfHTUcz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Aug 2019 16:32:55 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44698 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730819AbfHTUcz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Aug 2019 16:32:55 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7KKSs27165894;
        Tue, 20 Aug 2019 20:32:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=gVvXR8f+OwcZozwmQk7It6Hvpz2uL7eV48XVncxlpEI=;
 b=CbO6kr5jflHnFwhDrlkeCnVWh2tG3kteToEVtnJs9fU2dDnbu9d8rQxYvOJGu73sHkgz
 5YkldWAfgfE1taQQUPbzRFVTvHffIlzZzsBi/8n/eDIwCoagDwhsiMenxCPwnJ9LuiGi
 o20pJv0GwObrUatYaR1azP1UTPk/3C8kybF4Dof0co25pQ9OyTz1nqOa4kHXtah9+ySh
 RmkMgzhltIpdBMn3GM/v46ajVeOeF5nbw41QiTolHhQZ5MbPF01nnAElWAkDcDL0J0Gp
 5eroDdfGW/WqzAtvztiQrCUGt92zNWNpba5kM4DwjfZL6/obg8w6nFWHHk30rxPI92E1 Zg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2uea7qs0ty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 20:32:53 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7KKSqNt160357;
        Tue, 20 Aug 2019 20:30:53 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2ug1g9rjmm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 20:30:52 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7KKUqpB028035;
        Tue, 20 Aug 2019 20:30:52 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 20 Aug 2019 13:30:51 -0700
Subject: [PATCH 3/6] libfrog: store more inode and block geometry in struct
 xfs_fd
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 20 Aug 2019 13:30:51 -0700
Message-ID: <156633305101.1215733.5608933964901928679.stgit@magnolia>
In-Reply-To: <156633303230.1215733.4447734852671168748.stgit@magnolia>
References: <156633303230.1215733.4447734852671168748.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9355 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908200183
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9355 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908200183
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the extra AG geometry fields out of scrub and into the libfrog code
so that we can consolidate the geoemtry code in one place.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/xfrog.h    |   12 ++++++++++++
 libfrog/fsgeom.c   |   13 ++++++++++++-
 scrub/fscounters.c |    4 ++--
 scrub/inodes.c     |    4 ++--
 scrub/phase1.c     |    5 -----
 scrub/phase3.c     |    6 +++---
 scrub/phase5.c     |    4 ++--
 scrub/phase6.c     |    2 +-
 scrub/phase7.c     |    6 +++---
 scrub/xfs_scrub.h  |    4 ----
 10 files changed, 37 insertions(+), 23 deletions(-)


diff --git a/include/xfrog.h b/include/xfrog.h
index f3808911..d11317f7 100644
--- a/include/xfrog.h
+++ b/include/xfrog.h
@@ -30,6 +30,18 @@ struct xfs_fd {
 
 	/* filesystem geometry */
 	struct xfs_fsop_geom	fsgeom;
+
+	/* log2 of sb_agblocks (rounded up) */
+	unsigned int		agblklog;
+
+	/* log2 of sb_blocksize */
+	unsigned int		blocklog;
+
+	/* log2 of sb_inodesize */
+	unsigned int		inodelog;
+
+	/* log2 of sb_inopblock */
+	unsigned int		inopblog;
 };
 
 /* Static initializers */
diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index debdece8..bc6158fb 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -5,6 +5,7 @@
 #include "libxfs.h"
 #include "fsgeom.h"
 #include "xfrog.h"
+#include "libfrog.h"
 
 void
 xfs_report_geom(
@@ -94,7 +95,17 @@ int
 xfrog_prepare_geometry(
 	struct xfs_fd		*xfd)
 {
-	return xfrog_geometry(xfd->fd, &xfd->fsgeom);
+	int			ret;
+
+	ret = xfrog_geometry(xfd->fd, &xfd->fsgeom);
+	if (ret)
+		return ret;
+
+	xfd->agblklog = log2_roundup(xfd->fsgeom.agblocks);
+	xfd->blocklog = highbit32(xfd->fsgeom.blocksize);
+	xfd->inodelog = highbit32(xfd->fsgeom.inodesize);
+	xfd->inopblog = xfd->blocklog - xfd->inodelog;
+	return 0;
 }
 
 /* Release any resources associated with this xfrog structure. */
diff --git a/scrub/fscounters.c b/scrub/fscounters.c
index f18d0e19..ac898764 100644
--- a/scrub/fscounters.c
+++ b/scrub/fscounters.c
@@ -91,8 +91,8 @@ xfs_count_ag_inodes(
 				minor(ctx->fsinfo.fs_datadev),
 				agno);
 
-	ag_ino = (__u64)agno << (ctx->inopblog + ctx->agblklog);
-	next_ag_ino = (__u64)(agno + 1) << (ctx->inopblog + ctx->agblklog);
+	ag_ino = (__u64)agno << (ctx->mnt.inopblog + ctx->mnt.agblklog);
+	next_ag_ino = (__u64)(agno + 1) << (ctx->mnt.inopblog + ctx->mnt.agblklog);
 
 	moveon = xfs_count_inodes_range(ctx, descr, ag_ino, next_ag_ino - 1,
 			&ci->counters[agno]);
diff --git a/scrub/inodes.c b/scrub/inodes.c
index 08f3d847..873ad425 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -228,8 +228,8 @@ xfs_scan_ag_inodes(
 				minor(ctx->fsinfo.fs_datadev),
 				agno);
 
-	ag_ino = (__u64)agno << (ctx->inopblog + ctx->agblklog);
-	next_ag_ino = (__u64)(agno + 1) << (ctx->inopblog + ctx->agblklog);
+	ag_ino = (__u64)agno << (ctx->mnt.inopblog + ctx->mnt.agblklog);
+	next_ag_ino = (__u64)(agno + 1) << (ctx->mnt.inopblog + ctx->mnt.agblklog);
 
 	moveon = xfs_iterate_inodes_range(ctx, descr, ctx->fshandle, ag_ino,
 			next_ag_ino - 1, si->fn, si->arg);
diff --git a/scrub/phase1.c b/scrub/phase1.c
index 2b8e69d2..d052a21c 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -140,11 +140,6 @@ _("Does not appear to be an XFS filesystem!"));
 		return false;
 	}
 
-	ctx->agblklog = log2_roundup(ctx->mnt.fsgeom.agblocks);
-	ctx->blocklog = highbit32(ctx->mnt.fsgeom.blocksize);
-	ctx->inodelog = highbit32(ctx->mnt.fsgeom.inodesize);
-	ctx->inopblog = ctx->blocklog - ctx->inodelog;
-
 	error = path_to_fshandle(ctx->mntpoint, &ctx->fshandle,
 			&ctx->fshandle_len);
 	if (error) {
diff --git a/scrub/phase3.c b/scrub/phase3.c
index a42d8213..579e08c3 100644
--- a/scrub/phase3.c
+++ b/scrub/phase3.c
@@ -52,8 +52,8 @@ xfs_scrub_inode_vfs_error(
 	xfs_agino_t		agino;
 	int			old_errno = errno;
 
-	agno = bstat->bs_ino / (1ULL << (ctx->inopblog + ctx->agblklog));
-	agino = bstat->bs_ino % (1ULL << (ctx->inopblog + ctx->agblklog));
+	agno = bstat->bs_ino / (1ULL << (ctx->mnt.inopblog + ctx->mnt.agblklog));
+	agino = bstat->bs_ino % (1ULL << (ctx->mnt.inopblog + ctx->mnt.agblklog));
 	snprintf(descr, DESCR_BUFSZ, _("inode %"PRIu64" (%u/%u)"),
 			(uint64_t)bstat->bs_ino, agno, agino);
 	errno = old_errno;
@@ -77,7 +77,7 @@ xfs_scrub_inode(
 	int			error;
 
 	xfs_action_list_init(&alist);
-	agno = bstat->bs_ino / (1ULL << (ctx->inopblog + ctx->agblklog));
+	agno = bstat->bs_ino / (1ULL << (ctx->mnt.inopblog + ctx->mnt.agblklog));
 	background_sleep();
 
 	/* Try to open the inode to pin it. */
diff --git a/scrub/phase5.c b/scrub/phase5.c
index 748885d4..36ec27b3 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -239,8 +239,8 @@ xfs_scrub_connections(
 	int			fd = -1;
 	int			error;
 
-	agno = bstat->bs_ino / (1ULL << (ctx->inopblog + ctx->agblklog));
-	agino = bstat->bs_ino % (1ULL << (ctx->inopblog + ctx->agblklog));
+	agno = bstat->bs_ino / (1ULL << (ctx->mnt.inopblog + ctx->mnt.agblklog));
+	agino = bstat->bs_ino % (1ULL << (ctx->mnt.inopblog + ctx->mnt.agblklog));
 	snprintf(descr, DESCR_BUFSZ, _("inode %"PRIu64" (%u/%u)"),
 			(uint64_t)bstat->bs_ino, agno, agino);
 	background_sleep();
diff --git a/scrub/phase6.c b/scrub/phase6.c
index e5a0b3c1..48971270 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -547,7 +547,7 @@ xfs_estimate_verify_work(
 	if (!moveon)
 		return moveon;
 
-	*items = ((d_blocks - d_bfree) + (r_blocks - r_bfree)) << ctx->blocklog;
+	*items = ((d_blocks - d_bfree) + (r_blocks - r_bfree)) << ctx->mnt.blocklog;
 	*nr_threads = disk_heads(ctx->datadev);
 	*rshift = 20;
 	return moveon;
diff --git a/scrub/phase7.c b/scrub/phase7.c
index 13959ca8..41a77356 100644
--- a/scrub/phase7.c
+++ b/scrub/phase7.c
@@ -148,11 +148,11 @@ xfs_scan_summary(
 	 * filesystem treats them as "free", but since we scanned
 	 * them, we'll consider them used.
 	 */
-	d_bfree -= totalcount.agbytes >> ctx->blocklog;
+	d_bfree -= totalcount.agbytes >> ctx->mnt.blocklog;
 
 	/* Report on what we found. */
-	used_data = (d_blocks - d_bfree) << ctx->blocklog;
-	used_rt = (r_blocks - r_bfree) << ctx->blocklog;
+	used_data = (d_blocks - d_bfree) << ctx->mnt.blocklog;
+	used_rt = (r_blocks - r_bfree) << ctx->mnt.blocklog;
 	used_files = f_files - f_free;
 	stat_data = totalcount.dbytes;
 	stat_rt = totalcount.rbytes;
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index 28eae6fe..fb34c587 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -63,10 +63,6 @@ struct scrub_ctx {
 
 	/* XFS specific geometry */
 	struct fs_path		fsinfo;
-	unsigned int		agblklog;
-	unsigned int		blocklog;
-	unsigned int		inodelog;
-	unsigned int		inopblog;
 	void			*fshandle;
 	size_t			fshandle_len;
 

