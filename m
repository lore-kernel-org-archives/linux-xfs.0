Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9VJNsMZ231009 for <xfs@oss.sgi.com>; Wed, 31 Oct 2012 14:23:54 -0500
Message-Id: <20121031192545.866697061@sgi.com>
Date: Wed, 31 Oct 2012 14:25:23 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [patch 2/4] xfsprogs: update version and changelog
References: <20121031192521.163830089@sgi.com>
Content-Disposition: inline; filename=xfsprogs-update-version
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

Update the version and changelogs for xfsprogs.

Signed-off-by: Ben Myers <bpm@sgi.com>

---
 VERSION          |    2 +-
 configure.ac     |    2 +-
 debian/changelog |    6 ++++++
 doc/CHANGES      |   13 +++++++++++++
 4 files changed, 21 insertions(+), 2 deletions(-)

Index: b/VERSION
===================================================================
--- a/VERSION	2012-10-31 13:28:44.911985637 -0500
+++ b/VERSION	2012-10-31 13:29:10.262026762 -0500
@@ -3,5 +3,5 @@
 #
 PKG_MAJOR=3
 PKG_MINOR=1
-PKG_REVISION=8
+PKG_REVISION=9
 PKG_BUILD=1
Index: b/configure.ac
===================================================================
--- a/configure.ac	2012-10-31 13:28:48.461946409 -0500
+++ b/configure.ac	2012-10-31 13:29:00.112026489 -0500
@@ -1,4 +1,4 @@
-AC_INIT([xfsprogs], [3.1.8])
+AC_INIT([xfsprogs], [3.1.9])
 AC_PREREQ(2.50)
 AC_CONFIG_AUX_DIR([.])
 AC_CONFIG_MACRO_DIR([m4])
Index: b/debian/changelog
===================================================================
--- a/debian/changelog	2012-10-31 13:29:42.571323127 -0500
+++ b/debian/changelog	2012-10-31 13:30:43.452005833 -0500
@@ -1,3 +1,9 @@
+xfsprogs (3.1.9) unstable; urgency=low
+
+  * New upstream release
+
+ -- Nathan Scott <nathans@debian.org>  Wed, 31 Oct 2012 13:29:00 +1100
+
 xfsprogs (3.1.8) unstable; urgency=low
 
   * New upstream release
Index: b/doc/CHANGES
===================================================================
--- a/doc/CHANGES	2012-10-31 13:29:34.521946743 -0500
+++ b/doc/CHANGES	2012-10-31 13:42:41.711835438 -0500
@@ -1,3 +1,16 @@
+xfsprogs-3.1.9 (31 October 2012)
+	- Print nice details if agsize is out of bounds in mkfs.xfs.
+	- Various fixes for fragmented multi-block dir2 handling in
+	  xfs_repair.
+	- Fix extent record printing in xfs_db on big endian arches.
+	- Use the correct macros when dumping block maps in extent
+	  form in xfs_db, thanks to Peter Watkins.
+	- Add sync file range support to xfs_io.
+	- Implement preadv/pwritev in xfs_io.
+	- Link against libreadline for libxcmd, thanks to Mike Frysinger.
+	- Clean up mkfs.xfs output on invalid inode size.
+	- Various build fixes, thanks to Mike Frysinger and Jan Engelhardt.
+
 xfsprogs-3.1.8 (20 March 2012)
 	- Fix xfs_repair segfault on a corrupted filesystem by validating the
 	  acl count before reading it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
