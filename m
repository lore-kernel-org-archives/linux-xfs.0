Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:37168 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfBZCfk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Feb 2019 21:35:40 -0500
Subject: [PATCH 2/2] t_attr_corruption: fix this yet again
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 25 Feb 2019 18:35:35 -0800
Message-ID: <155114853550.9683.11298191063436471344.stgit@magnolia>
In-Reply-To: <155114852926.9683.4048206997940455508.stgit@magnolia>
References: <155114852926.9683.4048206997940455508.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Jeff Moyer pointed out that 'security.evm' actually has an expected
value format, which breaks the test if EVM is enabled.  It turns out
that the 'security.evm' setxattr call in the original syzkaller report
was a total red herring, as this bug can be reproduced without it.

Fix the test case to do the minimum amount of work needed to reproduce
the corruption.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 src/t_attr_corruption.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)


diff --git a/src/t_attr_corruption.c b/src/t_attr_corruption.c
index f26611f9..9101024e 100644
--- a/src/t_attr_corruption.c
+++ b/src/t_attr_corruption.c
@@ -3,17 +3,21 @@
  * Copyright (C) 2019 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  *
- * Test program to tickle a use-after-free bug in xfs.
+ * XFS had a memory corruption bug in its handling of the POSIX ACL attribute
+ * names during a listxattr call.
  *
- * XFS had a use-after-free bug when xfs_xattr_put_listent runs out of
- * listxattr buffer space while trying to store the name
- * "system.posix_acl_access" and then corrupts memory by not checking the
- * seen_enough state and then trying to shove "trusted.SGI_ACL_FILE" into the
- * buffer as well.
+ * On IRIX, file ACLs were stored under the name "trusted.SGI_ACL_FILE",
+ * whereas on Linux the name is "system.posix_acl_access".  In order to
+ * maintain compatibility with old filesystems, XFS internally continues to
+ * use the old SGI_ACL_FILE name on disk and remap the new name whenever it
+ * sees it.
  *
- * In order to tickle the bug in a user visible way we must have already put a
- * name in the buffer, so we take advantage of the fact that "security.evm"
- * sorts before "system.posix_acl_access" to make sure this happens.
+ * In order to make this magic happen, XFS' listxattr implementation will emit
+ * first the Linux name and then the on-disk name.  Unfortunately, it doesn't
+ * correctly check the buffer length, so if the buffer is large enough to fit
+ * the on-disk name but not large enough to fit the Linux name, we screw up
+ * the buffer position accounting while trying to emit the Linux name and then
+ * corrupt memory when we try to emit the on-disk name.
  *
  * If we trigger the bug, the program will print the garbled string
  * "rusted.SGI_ACL_FILE".  If the bug is fixed, the flistxattr call returns
@@ -76,11 +80,7 @@ int main(int argc, char *argv[])
 	if (ret)
 		die("set posix acl");
 
-	ret = fsetxattr(fd, "security.evm", buf, 1, 1);
-	if (ret)
-		die("set evm");
-
-	sz = flistxattr(fd, buf, 30);
+	sz = flistxattr(fd, buf, 20);
 	if (sz < 0)
 		die("list attr");
 
