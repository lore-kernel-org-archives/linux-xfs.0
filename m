Return-Path: <SRS0=kQBn=WQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7158FC3A589
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 20:31:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3867E2082F
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 20:31:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qlpg6F9X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730466AbfHTUbB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Aug 2019 16:31:01 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45190 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730430AbfHTUbB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Aug 2019 16:31:01 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7KKT4vX151609;
        Tue, 20 Aug 2019 20:30:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=qpGlK7ga1UnoI/RJlVAygVDhs4+oxxR6/ZqpGgWmlVw=;
 b=qlpg6F9XqkV2XkZ2brURVFIEVFVWi2DN7yK/Vy0B+Je/bWDih49YuuNsR80/I8gXZOgl
 UCFt54Fu/53FyrrCU0VtQzk84p5jsxwzkXqVN4Y8cEi1Oi6Yt0E5QtVbIWkkMbaaLXmE
 12CoT41As9itrEKBRFwRj535uGhJZjBxAmSNFcJtVJSgRXqFILCR4NvB/9B5ZIFDYnED
 gw+OFoHPHcA22yN+m9cLr1zdbgMtMmlIZ66E5WYWsUPJdIoBp/VeR+1tAp7oLZBGV8Mw
 cX1Xp5gkvKNGU3Ynz3Gqn0tL/XY9RMUhdP19AYJST6kMhFDjmZvyzkCrw0UJ8dIqqpFx ng== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2ue90th5qh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 20:30:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7KKTTtq104776;
        Tue, 20 Aug 2019 20:30:59 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2ug26963j0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 20:30:58 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7KKUwJ5021264;
        Tue, 20 Aug 2019 20:30:58 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 20 Aug 2019 13:30:58 -0700
Subject: [PATCH 4/6] libfrog: create online fs geometry converters
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 20 Aug 2019 13:30:57 -0700
Message-ID: <156633305717.1215733.17610092313024714477.stgit@magnolia>
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

Create helper functions to perform unit conversions against a runtime
filesystem, then remove the open-coded versions in scrub.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/xfrog.h    |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
 libfrog/fsgeom.c   |    1 +
 scrub/fscounters.c |    4 ++--
 scrub/inodes.c     |    4 ++--
 scrub/phase3.c     |    6 +++---
 scrub/phase5.c     |    4 ++--
 scrub/phase6.c     |    3 ++-
 scrub/phase7.c     |    6 +++---
 8 files changed, 64 insertions(+), 13 deletions(-)


diff --git a/include/xfrog.h b/include/xfrog.h
index d11317f7..091edebb 100644
--- a/include/xfrog.h
+++ b/include/xfrog.h
@@ -42,6 +42,9 @@ struct xfs_fd {
 
 	/* log2 of sb_inopblock */
 	unsigned int		inopblog;
+
+	/* bits for agino in inum */
+	unsigned int		aginolog;
 };
 
 /* Static initializers */
@@ -51,4 +54,50 @@ struct xfs_fd {
 int xfrog_prepare_geometry(struct xfs_fd *xfd);
 int xfrog_close(struct xfs_fd *xfd);
 
+/* Convert AG number and AG inode number into fs inode number. */
+static inline uint64_t
+xfrog_agino_to_ino(
+	const struct xfs_fd	*xfd,
+	uint32_t		agno,
+	uint32_t		agino)
+{
+	return ((uint64_t)agno << xfd->aginolog) + agino;
+}
+
+/* Convert fs inode number into AG number. */
+static inline uint32_t
+xfrog_ino_to_agno(
+	const struct xfs_fd	*xfd,
+	uint64_t		ino)
+{
+	return ino >> xfd->aginolog;
+}
+
+/* Convert fs inode number into AG inode number. */
+static inline uint32_t
+xfrog_ino_to_agino(
+	const struct xfs_fd	*xfd,
+	uint64_t		ino)
+{
+	return ino & ((1ULL << xfd->aginolog) - 1);
+}
+
+/* Convert fs block number into bytes */
+static inline uint64_t
+xfrog_fsb_to_b(
+	const struct xfs_fd	*xfd,
+	uint64_t		fsb)
+{
+	return fsb << xfd->blocklog;
+}
+
+/* Convert bytes into (rounded down) fs block number */
+static inline uint64_t
+xfrog_b_to_fsbt(
+	const struct xfs_fd	*xfd,
+	uint64_t		bytes)
+{
+	return bytes >> xfd->blocklog;
+}
+
 #endif	/* __XFROG_H__ */
diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index bc6158fb..a3b748f8 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -105,6 +105,7 @@ xfrog_prepare_geometry(
 	xfd->blocklog = highbit32(xfd->fsgeom.blocksize);
 	xfd->inodelog = highbit32(xfd->fsgeom.inodesize);
 	xfd->inopblog = xfd->blocklog - xfd->inodelog;
+	xfd->aginolog = xfd->agblklog + xfd->inopblog;
 	return 0;
 }
 
diff --git a/scrub/fscounters.c b/scrub/fscounters.c
index ac898764..adb79b50 100644
--- a/scrub/fscounters.c
+++ b/scrub/fscounters.c
@@ -91,8 +91,8 @@ xfs_count_ag_inodes(
 				minor(ctx->fsinfo.fs_datadev),
 				agno);
 
-	ag_ino = (__u64)agno << (ctx->mnt.inopblog + ctx->mnt.agblklog);
-	next_ag_ino = (__u64)(agno + 1) << (ctx->mnt.inopblog + ctx->mnt.agblklog);
+	ag_ino = xfrog_agino_to_ino(&ctx->mnt, agno, 0);
+	next_ag_ino = xfrog_agino_to_ino(&ctx->mnt, agno + 1, 0);
 
 	moveon = xfs_count_inodes_range(ctx, descr, ag_ino, next_ag_ino - 1,
 			&ci->counters[agno]);
diff --git a/scrub/inodes.c b/scrub/inodes.c
index 873ad425..a9000218 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -228,8 +228,8 @@ xfs_scan_ag_inodes(
 				minor(ctx->fsinfo.fs_datadev),
 				agno);
 
-	ag_ino = (__u64)agno << (ctx->mnt.inopblog + ctx->mnt.agblklog);
-	next_ag_ino = (__u64)(agno + 1) << (ctx->mnt.inopblog + ctx->mnt.agblklog);
+	ag_ino = xfrog_agino_to_ino(&ctx->mnt, agno, 0);
+	next_ag_ino = xfrog_agino_to_ino(&ctx->mnt, agno + 1, 0);
 
 	moveon = xfs_iterate_inodes_range(ctx, descr, ctx->fshandle, ag_ino,
 			next_ag_ino - 1, si->fn, si->arg);
diff --git a/scrub/phase3.c b/scrub/phase3.c
index 579e08c3..def9a0de 100644
--- a/scrub/phase3.c
+++ b/scrub/phase3.c
@@ -52,8 +52,8 @@ xfs_scrub_inode_vfs_error(
 	xfs_agino_t		agino;
 	int			old_errno = errno;
 
-	agno = bstat->bs_ino / (1ULL << (ctx->mnt.inopblog + ctx->mnt.agblklog));
-	agino = bstat->bs_ino % (1ULL << (ctx->mnt.inopblog + ctx->mnt.agblklog));
+	agno = xfrog_ino_to_agno(&ctx->mnt, bstat->bs_ino);
+	agino = xfrog_ino_to_agino(&ctx->mnt, bstat->bs_ino);
 	snprintf(descr, DESCR_BUFSZ, _("inode %"PRIu64" (%u/%u)"),
 			(uint64_t)bstat->bs_ino, agno, agino);
 	errno = old_errno;
@@ -77,7 +77,7 @@ xfs_scrub_inode(
 	int			error;
 
 	xfs_action_list_init(&alist);
-	agno = bstat->bs_ino / (1ULL << (ctx->mnt.inopblog + ctx->mnt.agblklog));
+	agno = xfrog_ino_to_agno(&ctx->mnt, bstat->bs_ino);
 	background_sleep();
 
 	/* Try to open the inode to pin it. */
diff --git a/scrub/phase5.c b/scrub/phase5.c
index 36ec27b3..2189c9e4 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -239,8 +239,8 @@ xfs_scrub_connections(
 	int			fd = -1;
 	int			error;
 
-	agno = bstat->bs_ino / (1ULL << (ctx->mnt.inopblog + ctx->mnt.agblklog));
-	agino = bstat->bs_ino % (1ULL << (ctx->mnt.inopblog + ctx->mnt.agblklog));
+	agno = xfrog_ino_to_agno(&ctx->mnt, bstat->bs_ino);
+	agino = xfrog_ino_to_agino(&ctx->mnt, bstat->bs_ino);
 	snprintf(descr, DESCR_BUFSZ, _("inode %"PRIu64" (%u/%u)"),
 			(uint64_t)bstat->bs_ino, agno, agino);
 	background_sleep();
diff --git a/scrub/phase6.c b/scrub/phase6.c
index 48971270..630d15b0 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -547,7 +547,8 @@ xfs_estimate_verify_work(
 	if (!moveon)
 		return moveon;
 
-	*items = ((d_blocks - d_bfree) + (r_blocks - r_bfree)) << ctx->mnt.blocklog;
+	*items = xfrog_fsb_to_b(&ctx->mnt,
+			(d_blocks - d_bfree) + (r_blocks - r_bfree));
 	*nr_threads = disk_heads(ctx->datadev);
 	*rshift = 20;
 	return moveon;
diff --git a/scrub/phase7.c b/scrub/phase7.c
index 41a77356..1c459dfc 100644
--- a/scrub/phase7.c
+++ b/scrub/phase7.c
@@ -148,11 +148,11 @@ xfs_scan_summary(
 	 * filesystem treats them as "free", but since we scanned
 	 * them, we'll consider them used.
 	 */
-	d_bfree -= totalcount.agbytes >> ctx->mnt.blocklog;
+	d_bfree -= xfrog_b_to_fsbt(&ctx->mnt, totalcount.agbytes);
 
 	/* Report on what we found. */
-	used_data = (d_blocks - d_bfree) << ctx->mnt.blocklog;
-	used_rt = (r_blocks - r_bfree) << ctx->mnt.blocklog;
+	used_data = xfrog_fsb_to_b(&ctx->mnt, d_blocks - d_bfree);
+	used_rt = xfrog_fsb_to_b(&ctx->mnt, r_blocks - r_bfree);
 	used_files = f_files - f_free;
 	stat_data = totalcount.dbytes;
 	stat_rt = totalcount.rbytes;

