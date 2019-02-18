Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:51038 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732601AbfBRSOF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Feb 2019 13:14:05 -0500
Date: Mon, 18 Feb 2019 10:13:59 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] t_open_tmpfiles: flush log when shutting down filesystem
Message-ID: <20190218181359.GG6477@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

If the caller of t_open_tmpfiles wants to shut down the filesystem, be
sure to flush the log when we shut down so that log recovery will have
to process all the unlinked temporary files.

This is apparently needed to force ext4 to flush updated inode blocks
through the journal at all.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 src/t_open_tmpfiles.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/src/t_open_tmpfiles.c b/src/t_open_tmpfiles.c
index 9e70fbaa..da9390fd 100644
--- a/src/t_open_tmpfiles.c
+++ b/src/t_open_tmpfiles.c
@@ -70,7 +70,11 @@ void die(void)
 		fflush(stdout);
 
 		if (shutdown_fs) {
-			int flag = XFS_FSOP_GOING_FLAGS_NOLOGFLUSH;
+			/*
+			 * Flush the log so that we have to process the
+			 * unlinked inodes the next time we mount.
+			 */
+			int flag = XFS_FSOP_GOING_FLAGS_LOGFLUSH;
 			int ret;
 
 			ret = ioctl(min_fd, XFS_IOC_GOINGDOWN, &flag);
