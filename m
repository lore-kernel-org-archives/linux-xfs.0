Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6LNojVO049912 for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 18:50:45 -0500
Received: from test.thunk.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E13C48C50B
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 16:50:44 -0700 (PDT)
Received: from test.thunk.org (li9-11.members.linode.com [67.18.176.11]) by
	cuda.sgi.com with ESMTP id GhJCCCOG2TaicWb8 for
	<xfs@oss.sgi.com>; Thu, 21 Jul 2011 16:50:44 -0700 (PDT)
From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH XFSPROGS 2/3] Build without enabling DEBUG by default
Date: Thu, 21 Jul 2011 19:50:36 -0400
Message-Id: <1311292237-4155-2-git-send-email-tytso@mit.edu>
In-Reply-To: <1311292237-4155-1-git-send-email-tytso@mit.edu>
References: <1311292237-4155-1-git-send-email-tytso@mit.edu>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com
Cc: Theodore Ts'o <tytso@mit.edu>

The tree currently will blow out with a build failure if -DDEBUG is
specified.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 m4/package_globals.m4 |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/m4/package_globals.m4 b/m4/package_globals.m4
index e469671..d2a3e2f 100644
--- a/m4/package_globals.m4
+++ b/m4/package_globals.m4
@@ -17,7 +17,7 @@ AC_DEFUN([AC_PACKAGE_GLOBALS],
     test -z "$BUILD_VERSION" || pkg_release="$BUILD_VERSION"
     AC_SUBST(pkg_release)
 
-    DEBUG=${DEBUG:-'-DDEBUG'}		dnl  -DNDEBUG
+    DEBUG=${DEBUG:-'-DNDEBUG'}		dnl  -DNDEBUG
     debug_build="$DEBUG"
     AC_SUBST(debug_build)
 
-- 
1.7.4.1.22.gec8e1.dirty

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
