Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 314477F51
	for <xfs@oss.sgi.com>; Tue, 30 Apr 2013 15:01:09 -0500 (CDT)
Message-Id: <20130430193734.216401872@sgi.com>
Date: Tue, 30 Apr 2013 14:37:34 -0500
From: rjohnston@sgi.com
Subject: [PATCH] xfsprogs: 3.1.11 release
Content-Disposition: inline; filename=xfsprogs-update-version-to-3.1.11.patch
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Nathan Scott <nathans@debian.org>

Signed-off-by: Rich Johnston <rjohnston@sgi.com>

---
 VERSION          |    2 +-
 configure.ac     |    2 +-
 debian/changelog |    6 ++++++
 doc/CHANGES      |   37 +++++++++++++++++++++++++++++++++++++
 4 files changed, 45 insertions(+), 2 deletions(-)

Index: b/VERSION
===================================================================
--- a/VERSION
+++ b/VERSION
@@ -3,5 +3,5 @@
 #
 PKG_MAJOR=3
 PKG_MINOR=1
-PKG_REVISION=10
+PKG_REVISION=11
 PKG_BUILD=1
Index: b/configure.ac
===================================================================
--- a/configure.ac
+++ b/configure.ac
@@ -1,4 +1,4 @@
-AC_INIT([xfsprogs], [3.1.10])
+AC_INIT([xfsprogs], [3.1.11])
 AC_PREREQ(2.50)
 AC_CONFIG_AUX_DIR([.])
 AC_CONFIG_MACRO_DIR([m4])
Index: b/debian/changelog
===================================================================
--- a/debian/changelog
+++ b/debian/changelog
@@ -1,3 +1,9 @@
+xfsprogs (3.1.11) unstable; urgency=low
+
+  * New upstream release
+
+ -- Nathan Scott <nathans@debian.org>  Tue, 19 Mar 2013 14:25:00 +1100
+
 xfsprogs (3.1.9) unstable; urgency=low
 
   * New upstream release
Index: b/doc/CHANGES
===================================================================
--- a/doc/CHANGES
+++ b/doc/CHANGES
@@ -1,3 +1,40 @@
+xfsprogs-3.1.11 (30 April 2013)
+	- Support for relative paths in xfs_quota thanks to Satoru Takeuchi.
+	- mkfs.xfs will always go into multidisk mode when filesystem
+	  geometry is specified on the command line.
+	- Document all commands in xfs_io.
+	- Remove setfl command from xfs_io.
+	- xfs_metadump will obfuscate symlinks by path component.
+	- mkfs.xfs no longer accepts geometry settings smaller than the
+	  physical sector size.
+	- xfs_logprint now supports multiply-logged inode fields and
+	  handles continued inode transactions correctly.
+	- kill XLOG_SET
+	- Update release scripts to use git archive to address a
+	  missing source file reported by Arkadiusz Mi?kiewicz
+	- Fix a build error with -Werror=format-security, reported
+	  by Arkadiusz Mi?kiewicz
+	- mkfs.xfs no longer attempts to discard when -N option is used.
+	- Update 'make deb' to use tarball
+	- Sync up with log reservation changes in the kernel.
+	- Fix possible unallocated memory access in fiemap.
+	- Guard against string overflow in path_to_fspath.
+	- Fix setup_cursor array allocation.
+	- Fix free of unintialized pointer in xfs_acl_valid error path.
+	- Guard against path string overflows.
+	- Check strdup results properly in initallfs().
+	- Fix attribute no_change_count logic.
+	- Remove extraneous close() in fsrallfs().
+	- xfs_repair now skips the freelist scan of a corrupt agf
+	  when in no-modify mode.
+	- xfs_db now skips freelist scans of corrupt agfs.
+	- Remove unconditional ASSERT(0) in xfs_repair.
+	- Reduce bb_numrecs in bno/cnt btrees when log consumes all agf space.
+	- Add depraction message for xfs_check.
+	- xfs_quota allow user or group names beginning with digits reported by
+	  James Carter.
+	- Fix manpages and usage() spelling, errors and omissions.
+
 xfsprogs-3.1.10 (13 December 2012)
 	- Update release script to make a source tarball.
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
