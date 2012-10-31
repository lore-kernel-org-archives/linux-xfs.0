Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9VJNwAs231039 for <xfs@oss.sgi.com>; Wed, 31 Oct 2012 14:23:58 -0500
Message-Id: <20121031192546.066642460@sgi.com>
Date: Wed, 31 Oct 2012 14:25:24 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [patch 3/4] xfsdump: update version and changelog
References: <20121031192521.163830089@sgi.com>
Content-Disposition: inline; filename=xfsdump-update-version
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
To: xfs@oss.sgi.com
Cc: Nathan Scott <nathans@debian.org>

Update the version and changelogs for xfsdump.

Signed-off-by: Ben Myers <bpm@sgi.com>

---
 VERSION          |    2 +-
 configure.ac     |    2 +-
 debian/changelog |    6 ++++++
 doc/CHANGES      |    8 ++++++++
 4 files changed, 16 insertions(+), 2 deletions(-)

Index: b/VERSION
===================================================================
--- a/VERSION	2012-10-31 13:43:32.341946579 -0500
+++ b/VERSION	2012-10-31 13:43:37.308175271 -0500
@@ -3,5 +3,5 @@
 #
 PKG_MAJOR=3
 PKG_MINOR=1
-PKG_REVISION=0
+PKG_REVISION=1
 PKG_BUILD=1
Index: b/configure.ac
===================================================================
--- a/configure.ac	2012-10-31 12:38:45.091946723 -0500
+++ b/configure.ac	2012-10-31 12:38:50.411340762 -0500
@@ -1,4 +1,4 @@
-AC_INIT([xfsdump], [3.1.0])
+AC_INIT([xfsdump], [3.1.1])
 AC_PREREQ(2.50)
 AC_CONFIG_AUX_DIR([.])
 AC_CONFIG_MACRO_DIR([m4])
Index: b/debian/changelog
===================================================================
--- a/debian/changelog	2012-10-31 12:39:28.991322370 -0500
+++ b/debian/changelog	2012-10-31 12:41:27.522005796 -0500
@@ -1,3 +1,9 @@
+xfsdump (3.1.1) unstable; urgency=low
+
+  * New upstream release
+
+ -- Nathan Scott <nathans@debian.org>  Wed, 31 Oct 2012 12:39:11 +1100
+
 xfsdump (3.1.0) unstable; urgency=low
 
   * New upstream release
Index: b/doc/CHANGES
===================================================================
--- a/doc/CHANGES	2012-10-31 12:39:34.301323054 -0500
+++ b/doc/CHANGES	2012-10-31 12:47:12.751986030 -0500
@@ -1,3 +1,11 @@
+xfsdump-3.1.1 (31 October 2012)
+	- Save and restore 32 bit project ids correctly.
+	- German translation, thanks to Chris Leick.
+	- A few fixups to the German translation, thanks to Stefan Ring.
+	- An initial Polish translation, thanks to Jakub Bogusz.
+	- Various build system cleanups, thanks to Mike Frysinger, and
+	  Jan Engelhardt.
+
 xfsdump-3.1.0 (22 March 2012)
 	- Fix metadata restore on split files.
 	- Add a -D option to skip a recursive scan of the filesystem

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
