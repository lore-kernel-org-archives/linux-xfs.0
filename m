Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39643C4363D
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 07:22:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E02102224D
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 07:22:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728032AbgJOHWK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 03:22:10 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:60705 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728885AbgJOHWE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 03:22:04 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 456163AB147
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 18:21:57 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kSxaG-000hvl-RB
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 18:21:56 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1kSxaG-006qM1-JG
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 18:21:56 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 14/27] xfs: rename libxfs_buftarg_init to libxfs_open_devices()
Date:   Thu, 15 Oct 2020 18:21:42 +1100
Message-Id: <20201015072155.1631135-15-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201015072155.1631135-1-david@fromorbit.com>
References: <20201015072155.1631135-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=afefHYAZSVUA:10 a=20KFwNOVAAAA:8 a=Fu86X8x2k18z7pChqt8A:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

This matches the kernel function for allocating the buftargs for
each device. The userspace function takes a bunch of devices, so
the new name matches what it does much more closely.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 copy/xfs_copy.c     | 2 +-
 db/init.c           | 2 +-
 db/sb.c             | 2 +-
 libxfs/init.c       | 4 ++--
 libxfs/libxfs_io.h  | 2 +-
 logprint/logprint.c | 2 +-
 mkfs/xfs_mkfs.c     | 2 +-
 7 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index f5eff96976d7..5d72e6451650 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -733,7 +733,7 @@ main(int argc, char **argv)
 	memset(&mbuf, 0, sizeof(xfs_mount_t));
 
 	/* We don't yet know the sector size, so read maximal size */
-	libxfs_buftarg_init(&mbuf, xargs.ddev, xargs.logdev, xargs.rtdev);
+	libxfs_open_devices(&mbuf, xargs.ddev, xargs.logdev, xargs.rtdev);
 	error = -libxfs_buf_read_uncached(mbuf.m_ddev_targp, XFS_SB_DADDR,
 			1 << (XFS_MAX_SECTORSIZE_LOG - BBSHIFT), 0, &sbp, NULL);
 	if (error) {
diff --git a/db/init.c b/db/init.c
index f797df8a768b..f45e34401069 100644
--- a/db/init.c
+++ b/db/init.c
@@ -109,7 +109,7 @@ init(
 	 * tool and so need to be able to mount busted filesystems.
 	 */
 	memset(&xmount, 0, sizeof(struct xfs_mount));
-	libxfs_buftarg_init(&xmount, x.ddev, x.logdev, x.rtdev);
+	libxfs_open_devices(&xmount, x.ddev, x.logdev, x.rtdev);
 	error = -libxfs_buf_read_uncached(xmount.m_ddev_targp, XFS_SB_DADDR,
 			1 << (XFS_MAX_SECTORSIZE_LOG - BBSHIFT), 0, &bp, NULL);
 	if (error) {
diff --git a/db/sb.c b/db/sb.c
index 8a303422b427..82f989606ba2 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -233,7 +233,7 @@ sb_logcheck(void)
 		}
 	}
 
-	libxfs_buftarg_init(mp, x.ddev, x.logdev, x.rtdev);
+	libxfs_open_devices(mp, x.ddev, x.logdev, x.rtdev);
 
 	dirty = xlog_is_dirty(mp, mp->m_log, &x, 0);
 	if (dirty == -1) {
diff --git a/libxfs/init.c b/libxfs/init.c
index 3ab622e9ee3b..59c0f9df586b 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -591,7 +591,7 @@ out_unwind:
 }
 
 void
-libxfs_buftarg_init(
+libxfs_open_devices(
 	struct xfs_mount	*mp,
 	dev_t			dev,
 	dev_t			logdev,
@@ -715,7 +715,7 @@ libxfs_mount(
 	bool			debugger = (flags & LIBXFS_MOUNT_DEBUGGER);
 	int			error;
 
-	libxfs_buftarg_init(mp, dev, logdev, rtdev);
+	libxfs_open_devices(mp, dev, logdev, rtdev);
 
 	mp->m_finobt_nores = true;
 	mp->m_flags = (LIBXFS_MOUNT_32BITINODES|LIBXFS_MOUNT_32BITINOOPT);
diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index eeca8895b1d3..0f9630e8e17a 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -16,7 +16,7 @@ struct xfs_mount;
 struct xfs_perag;
 struct xfs_buftarg;
 
-void libxfs_buftarg_init(struct xfs_mount *mp, dev_t ddev,
+void libxfs_open_devices(struct xfs_mount *mp, dev_t ddev,
 			dev_t logdev, dev_t rtdev);
 int libxfs_blkdev_issue_flush(struct xfs_buftarg *btp);
 
diff --git a/logprint/logprint.c b/logprint/logprint.c
index e882c5d44397..0e8512f6a854 100644
--- a/logprint/logprint.c
+++ b/logprint/logprint.c
@@ -212,7 +212,7 @@ main(int argc, char **argv)
 		exit(1);
 
 	logstat(&mount);
-	libxfs_buftarg_init(&mount, x.ddev, x.logdev, x.rtdev);
+	libxfs_open_devices(&mount, x.ddev, x.logdev, x.rtdev);
 
 	logfd = (x.logfd < 0) ? x.dfd : x.logfd;
 
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index e094c82f86b7..794955a9624c 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3986,7 +3986,7 @@ main(
 	/*
 	 * we need the libxfs buffer cache from here on in.
 	 */
-	libxfs_buftarg_init(mp, xi.ddev, xi.logdev, xi.rtdev);
+	libxfs_open_devices(mp, xi.ddev, xi.logdev, xi.rtdev);
 
 	/*
 	 * Before we mount the filesystem we need to make sure the devices have
-- 
2.28.0

