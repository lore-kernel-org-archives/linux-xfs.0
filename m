Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33308 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933331AbdCHAbo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Mar 2017 19:31:44 -0500
Subject: [PATCH 3/3] xfs_io: support shutdown command on foreign fses
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 07 Mar 2017 16:30:23 -0800
Message-ID: <148893302305.23674.11901575444165562002.stgit@birch.djwong.org>
In-Reply-To: <148893300446.23674.6348172768180643163.stgit@birch.djwong.org>
References: <148893300446.23674.6348172768180643163.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Since f2fs and ext4 support the shutdown ioctl, enable it there.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 io/shutdown.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/io/shutdown.c b/io/shutdown.c
index d9cd520..022a0e9 100644
--- a/io/shutdown.c
+++ b/io/shutdown.c
@@ -54,7 +54,7 @@ shutdown_init(void)
 	shutdown_cmd.cfunc = shutdown_f;
 	shutdown_cmd.argmin = 0;
 	shutdown_cmd.argmax = 1;
-	shutdown_cmd.flags = CMD_NOMAP_OK | CMD_FLAG_ONESHOT;
+	shutdown_cmd.flags = CMD_NOMAP_OK | CMD_FLAG_ONESHOT | CMD_FLAG_FOREIGN_OK;
 	shutdown_cmd.args = _("[-f]");
 	shutdown_cmd.oneline =
 		_("shuts down the filesystem where the current file resides");

