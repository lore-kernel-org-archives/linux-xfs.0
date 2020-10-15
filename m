Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E171C43457
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 07:22:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFDD722250
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 07:22:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729108AbgJOHWM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 03:22:12 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:35828 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729036AbgJOHWL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 03:22:11 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 47ADE58C540
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 18:21:57 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kSxaG-000hvf-OM
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 18:21:56 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1kSxaG-006qLv-Gj
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 18:21:56 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 12/27] xfsprogs: convert use-once buffer reads to uncached IO
Date:   Thu, 15 Oct 2020 18:21:40 +1100
Message-Id: <20201015072155.1631135-13-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201015072155.1631135-1-david@fromorbit.com>
References: <20201015072155.1631135-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=afefHYAZSVUA:10 a=20KFwNOVAAAA:8 a=PHNv4jrtCEqC_9gO4-YA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/init.c     |  2 +-
 libxfs/init.c | 93 ++++++++++++++++++++++++++++++---------------------
 2 files changed, 55 insertions(+), 40 deletions(-)

diff --git a/db/init.c b/db/init.c
index 19f0900a862b..f797df8a768b 100644
--- a/db/init.c
+++ b/db/init.c
@@ -153,7 +153,7 @@ init(
 	 */
 	if (sbp->sb_rootino != NULLFSINO &&
 	    xfs_sb_version_haslazysbcount(&mp->m_sb)) {
-		int error = -libxfs_initialize_perag_data(mp, sbp->sb_agcount);
+		error = -libxfs_initialize_perag_data(mp, sbp->sb_agcount);
 		if (error) {
 			fprintf(stderr,
 	_("%s: cannot init perag data (%d). Continuing anyway.\n"),
diff --git a/libxfs/init.c b/libxfs/init.c
index fe784940c299..fc30f92d6fb2 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -419,7 +419,7 @@ done:
  */
 static int
 rtmount_init(
-	xfs_mount_t	*mp,	/* file system mount structure */
+	struct xfs_mount *mp,
 	int		flags)
 {
 	struct xfs_buf	*bp;	/* buffer for last block of subvolume */
@@ -473,8 +473,9 @@ rtmount_init(
 			(unsigned long long) mp->m_sb.sb_rblocks);
 		return -1;
 	}
-	error = libxfs_buf_read(mp->m_rtdev, d - XFS_FSB_TO_BB(mp, 1),
-			XFS_FSB_TO_BB(mp, 1), 0, &bp, NULL);
+	error = libxfs_buf_read_uncached(mp->m_rtdev_targp,
+					d - XFS_FSB_TO_BB(mp, 1),
+					XFS_FSB_TO_BB(mp, 1), 0, &bp, NULL);
 	if (error) {
 		fprintf(stderr, _("%s: realtime size check failed\n"),
 			progname);
@@ -657,6 +658,52 @@ libxfs_buftarg_init(
 	mp->m_rtdev_targp = libxfs_buftarg_alloc(mp, rtdev);
 }
 
+/*
+ * Check that the data (and log if separate) is an ok size.
+ *
+ * XXX: copied from kernel, needs to be moved to shared code
+ */
+STATIC int
+xfs_check_sizes(
+        struct xfs_mount *mp)
+{
+	struct xfs_buf	*bp;
+	xfs_daddr_t	d;
+	int		error;
+
+	d = (xfs_daddr_t)XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
+	if (XFS_BB_TO_FSB(mp, d) != mp->m_sb.sb_dblocks) {
+		xfs_warn(mp, "filesystem size mismatch detected");
+		return -EFBIG;
+	}
+	error = libxfs_buf_read_uncached(mp->m_ddev_targp,
+					d - XFS_FSS_TO_BB(mp, 1),
+					XFS_FSS_TO_BB(mp, 1), 0, &bp, NULL);
+	if (error) {
+		xfs_warn(mp, "last sector read failed");
+		return error;
+	}
+	libxfs_buf_relse(bp);
+
+	if (mp->m_logdev_targp == mp->m_ddev_targp)
+		return 0;
+
+	d = (xfs_daddr_t)XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
+	if (XFS_BB_TO_FSB(mp, d) != mp->m_sb.sb_logblocks) {
+		xfs_warn(mp, "log size mismatch detected");
+		return -EFBIG;
+	}
+	error = libxfs_buf_read_uncached(mp->m_logdev_targp,
+					d - XFS_FSB_TO_BB(mp, 1),
+					XFS_FSB_TO_BB(mp, 1), 0, &bp, NULL);
+	if (error) {
+		xfs_warn(mp, "log device read failed");
+		return error;
+	}
+	libxfs_buf_relse(bp);
+	return 0;
+}
+
 /*
  * Mount structure initialization, provides a filled-in xfs_mount_t
  * such that the numerous XFS_* macros can be used.  If dev is zero,
@@ -673,7 +720,6 @@ libxfs_mount(
 {
 	struct xfs_buf		*bp;
 	struct xfs_sb		*sbp;
-	xfs_daddr_t		d;
 	bool			debugger = (flags & LIBXFS_MOUNT_DEBUGGER);
 	int			error;
 
@@ -704,16 +750,6 @@ libxfs_mount(
 	xfs_rmapbt_compute_maxlevels(mp);
 	xfs_refcountbt_compute_maxlevels(mp);
 
-	/*
-	 * Check that the data (and log if separate) are an ok size.
-	 */
-	d = (xfs_daddr_t) XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
-	if (XFS_BB_TO_FSB(mp, d) != mp->m_sb.sb_dblocks) {
-		fprintf(stderr, _("%s: size check failed\n"), progname);
-		if (!(flags & LIBXFS_MOUNT_DEBUGGER))
-			return NULL;
-	}
-
 	/*
 	 * We automatically convert v1 inodes to v2 inodes now, so if
 	 * the NLINK bit is not set we can't operate on the filesystem.
@@ -755,30 +791,9 @@ libxfs_mount(
 		return mp;
 
 	/* device size checks must pass unless we're a debugger. */
-	error = libxfs_buf_read(mp->m_dev, d - XFS_FSS_TO_BB(mp, 1),
-			XFS_FSS_TO_BB(mp, 1), 0, &bp, NULL);
-	if (error) {
-		fprintf(stderr, _("%s: data size check failed\n"), progname);
-		if (!debugger)
-			return NULL;
-	} else
-		libxfs_buf_relse(bp);
-
-	if (mp->m_logdev_targp->bt_bdev &&
-	    mp->m_logdev_targp->bt_bdev != mp->m_ddev_targp->bt_bdev) {
-		d = (xfs_daddr_t) XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
-		if (XFS_BB_TO_FSB(mp, d) != mp->m_sb.sb_logblocks ||
-		    libxfs_buf_read(mp->m_logdev_targp,
-				d - XFS_FSB_TO_BB(mp, 1), XFS_FSB_TO_BB(mp, 1),
-				0, &bp, NULL)) {
-			fprintf(stderr, _("%s: log size checks failed\n"),
-					progname);
-			if (!debugger)
-				return NULL;
-		}
-		if (bp)
-			libxfs_buf_relse(bp);
-	}
+	error = xfs_check_sizes(mp);
+	if (error && !debugger)
+		return NULL;
 
 	/* Initialize realtime fields in the mount structure */
 	if (rtmount_init(mp, flags)) {
@@ -795,7 +810,7 @@ libxfs_mount(
 	 * read the first one and let the user know to check the geometry.
 	 */
 	if (sbp->sb_agcount > 1000000) {
-		error = libxfs_buf_read(mp->m_dev,
+		error = libxfs_buf_read_uncached(mp->m_ddev_targp,
 				XFS_AG_DADDR(mp, sbp->sb_agcount - 1, 0), 1,
 				0, &bp, NULL);
 		if (error) {
-- 
2.28.0

