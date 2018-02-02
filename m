Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:47688 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751544AbeBBVgh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Feb 2018 16:36:37 -0500
Subject: [PATCH 2/4] xfs_scrub: close dir_fd if we don't get a DIR pointer
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 02 Feb 2018 13:36:33 -0800
Message-ID: <151760739333.29371.879810257810332609.stgit@magnolia>
In-Reply-To: <151760738102.29371.13542858379823064383.stgit@magnolia>
References: <151760738102.29371.13542858379823064383.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If we don't get a directory pointer, close dir_fd before jumping out.

Fixes-coverity-id: 1428799
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/vfs.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/scrub/vfs.c b/scrub/vfs.c
index e3c8e62..573a2d0 100644
--- a/scrub/vfs.c
+++ b/scrub/vfs.c
@@ -88,6 +88,7 @@ scan_fs_dir(
 	/* Caller-specific directory checks. */
 	if (!sft->dir_fn(ctx, sftd->path, dir_fd, sft->arg)) {
 		sft->moveon = false;
+		close(dir_fd);
 		goto out;
 	}
 
@@ -95,6 +96,7 @@ scan_fs_dir(
 	dir = fdopendir(dir_fd);
 	if (!dir) {
 		str_errno(ctx, sftd->path);
+		close(dir_fd);
 		goto out;
 	}
 	rewinddir(dir);

