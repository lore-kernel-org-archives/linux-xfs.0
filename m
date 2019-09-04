Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1707C3A59E
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:37:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E90722DBF
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:37:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NhHn9Q/P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbfIDEh3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 00:37:29 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58618 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbfIDEh2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 00:37:28 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x844axxp040821;
        Wed, 4 Sep 2019 04:37:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=79Rpi4NTeJrVVsaGImPQUnMj/+o7rxWWnupMGhrBXGA=;
 b=NhHn9Q/PDYiedfQUU8O0KFUrAGJoOC3EZaBdVBMFnVxWwuTO3i2OucIrZ9AM9nnc2w6Q
 iH2Wfh7oyBgV02P43Qldvad813S0JTOU7hFB8cgPWCCHGdtDDAOmmH+JPWSpyr10wcDT
 vFnNVYMfJrosFleFK3yUEN25kkALKchYrDpwa/sM+jdNSZmjW6AymFJxv9Kb2tZLd2/1
 xiu04ASA44bo/yS2GpMMp/Z1aVilN29rv4NQYGmstlYRgye5RImqqilScVYq4GGYHUso
 18sSdp6Wkx5XATNEQCEaPUogEU8NFNlA4R7WXucKVP+hNP+gCeUOjQFFoAUc8zSGABYZ LQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2ut6d1r02x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 04:37:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x844XFik027419;
        Wed, 4 Sep 2019 04:35:12 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2ut1hmtu2x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 04:35:12 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x844ZBTR029909;
        Wed, 4 Sep 2019 04:35:11 GMT
Received: from localhost (/10.159.228.126)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Sep 2019 21:35:11 -0700
Subject: [PATCH 4/8] libfrog: store more inode and block geometry in struct
 xfs_fd
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        Dave Chinner <dchinner@redhat.com>
Date:   Tue, 03 Sep 2019 21:35:10 -0700
Message-ID: <156757171006.1836891.1714495152057141839.stgit@magnolia>
In-Reply-To: <156757168368.1836891.15043200811666785244.stgit@magnolia>
References: <156757168368.1836891.15043200811666785244.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909040047
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909040047
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the extra AG geometry fields out of scrub and into the libfrog code
so that we can consolidate the geoemtry code in one place.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
---
 include/fsgeom.h   |   12 ++++++++++++
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


diff --git a/include/fsgeom.h b/include/fsgeom.h
index 26f93b3c..7837c700 100644
--- a/include/fsgeom.h
+++ b/include/fsgeom.h
@@ -20,6 +20,18 @@ struct xfs_fd {
 
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
index 9513faf5..b7e2b2f8 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -4,6 +4,7 @@
  */
 #include "libxfs.h"
 #include "fsgeom.h"
+#include "libfrog.h"
 
 void
 xfs_report_geom(
@@ -101,7 +102,17 @@ int
 xfd_prepare_geometry(
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
 
 /*
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
index 10dde8e8..6879cc33 100644
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
index 2af106ea..6178f324 100644
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
 

