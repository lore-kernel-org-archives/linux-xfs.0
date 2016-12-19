Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.polytechnique.org ([129.104.30.34]:38242 "EHLO
        mx1.polytechnique.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755607AbcLSNli (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Dec 2016 08:41:38 -0500
From: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Subject: [PATCH 1/1] xfs: silent -Wformat-security warning
Date: Mon, 19 Dec 2016 14:41:11 +0100
Message-Id: <20161219134111.5267-1-nicolas.iooss_linux@m4x.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Nicolas Iooss <nicolas.iooss_linux@m4x.org>

When building the XFS driver with clang, the compiler reports a
-Wformat-security warning in xlog_recover_validate_buf_type() because
xfs_warn() is being called with a non-literal string. Even though
variable warnmsg is always initialized as a constant string without any
'%' character, silent the warning by calling xfs_warn with "%s" format
string.

Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
---
 fs/xfs/xfs_log_recover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 4a98762ec8b4..9208296e9f15 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2572,7 +2572,7 @@ xlog_recover_validate_buf_type(
 		return;
 
 	if (warnmsg) {
-		xfs_warn(mp, warnmsg);
+		xfs_warn(mp, "%s", warnmsg);
 		ASSERT(0);
 	}
 
-- 
2.11.0

