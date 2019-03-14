Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:51296 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727366AbfCNVFd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Mar 2019 17:05:33 -0400
Subject: [PATCH 16/36] xfs_scrub: don't close mnt_fd when mnt_fd open fails
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 14 Mar 2019 14:05:29 -0700
Message-ID: <155259752927.31886.10173767197190539382.stgit@magnolia>
In-Reply-To: <155259742281.31886.17157720770696604377.stgit@magnolia>
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If we fail to open the mountpoint during phase 1 of scrub, don't bother
trying to close the file descriptor since it's silly to spray error
messages about that.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/phase1.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)


diff --git a/scrub/phase1.c b/scrub/phase1.c
index 6b472147..04a5f4a9 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -59,9 +59,11 @@ xfs_cleanup_fs(
 	if (ctx->datadev)
 		disk_close(ctx->datadev);
 	fshandle_destroy();
-	error = close(ctx->mnt_fd);
-	if (error)
-		str_errno(ctx, _("closing mountpoint fd"));
+	if (ctx->mnt_fd >= 0) {
+		error = close(ctx->mnt_fd);
+		if (error)
+			str_errno(ctx, _("closing mountpoint fd"));
+	}
 	fs_table_destroy();
 
 	return true;
