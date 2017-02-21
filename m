Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31053 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932155AbdBUSFf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Feb 2017 13:05:35 -0500
Date: Tue, 21 Feb 2017 10:05:25 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] include: don't collide __bitwise definitions in 4.10
Message-ID: <20170221180525.GG5846@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

Linux 4.10 changed the definition of __bitwise in such a way that
xfsprogs' definition is no longer a strict match for it.  This causes
gcc to complain, so only #define it here if the system hasn't already
done it for us.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/xfs_arch.h |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/xfs_arch.h b/include/xfs_arch.h
index 6e3172c..12cd43e 100644
--- a/include/xfs_arch.h
+++ b/include/xfs_arch.h
@@ -25,10 +25,14 @@
 #endif
 
 #ifdef __CHECKER__
-#define __bitwise		__attribute__((bitwise))
+# ifndef __bitwise
+#  define __bitwise		__attribute__((bitwise))
+# endif
 #define __force			__attribute__((force))
 #else
-#define __bitwise
+# ifndef __bitwise
+#  define __bitwise
+# endif
 #define __force
 #endif
 
