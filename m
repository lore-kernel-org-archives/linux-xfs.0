Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51841 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751378AbdB0SwW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Feb 2017 13:52:22 -0500
Date: Mon, 27 Feb 2017 10:50:45 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs_io: support shutdown command on foreign fses
Message-ID: <20170227185045.GA5297@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

Since f2fs and ext4 support the shutdown ioctl, enable them here.

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
