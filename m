Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0B0407F3F
	for <xfs@oss.sgi.com>; Mon, 16 Sep 2013 15:56:41 -0500 (CDT)
Date: Mon, 16 Sep 2013 15:56:37 -0500
From: Ben Myers <bpm@sgi.com>
Subject: xfsprogs: update version for 3.2.0-alpha1
Message-ID: <20130916205637.GD1935@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, sandeen@sandeen.net, rjohnston@sgi.com

xfsprogs: update version for 3.2.0-alpha1

Update the VERSION and doc/CHANGES file for alpha release, 3.2.0-alpha1

Signed-off-by: Ben Myers <bpm@sgi.com>
Reviewed-by: Rich Johnston <rjohnston@sgi.com>

---
 VERSION      |    4 ++--
 configure.ac |    2 +-
 doc/CHANGES  |    4 ++++
 3 files changed, 7 insertions(+), 3 deletions(-)

Index: b/VERSION
===================================================================
--- a/VERSION	2013-09-16 15:50:29.544368912 -0500
+++ b/VERSION	2013-09-16 15:50:37.993732514 -0500
@@ -2,6 +2,6 @@
 # This file is used by configure to get version information
 #
 PKG_MAJOR=3
-PKG_MINOR=1
-PKG_REVISION=11
+PKG_MINOR=2
+PKG_REVISION=0-alpha1
 PKG_BUILD=1
Index: b/configure.ac
===================================================================
--- a/configure.ac	2013-09-16 15:54:14.394338104 -0500
+++ b/configure.ac	2013-09-16 15:54:37.154377546 -0500
@@ -1,4 +1,4 @@
-AC_INIT([xfsprogs], [3.1.11])
+AC_INIT([xfsprogs], [3.2.0-alpha1])
 AC_PREREQ(2.50)
 AC_CONFIG_AUX_DIR([.])
 AC_CONFIG_MACRO_DIR([m4])
Index: b/doc/CHANGES
===================================================================
--- a/doc/CHANGES	2013-09-16 15:50:13.683773140 -0500
+++ b/doc/CHANGES	2013-09-16 15:55:58.379446313 -0500
@@ -1,3 +1,7 @@
+xfsprogs-3.2.0-alpha1 (16 Sep 2013)
+	- Alpha release for the purpose of testing the CRC feature during the
+	  v3.12 kernel -rc series.
+
 xfsprogs-3.1.11 (8 May 2013)
 	- Support for relative paths in xfs_quota thanks to Satoru Takeuchi.
 	- mkfs.xfs will always go into multidisk mode when filesystem

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
