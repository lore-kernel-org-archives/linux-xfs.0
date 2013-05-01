Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 342797F52
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 15:11:49 -0500 (CDT)
Message-Id: <20130501195229.468657797@sgi.com>
Date: Wed, 01 May 2013 14:52:29 -0500
From: rjohnston@sgi.com
Subject: xfsdump: Release 3.1.3
References: <20130501195229.468657797@sgi.com>
Content-Disposition: inline;
	filename=v3-xfsdump-update-version-numbers-and-changelog.patch
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
Cc: nathans@debian.org

Update version numbers and changelog.

Signed-off-by: Rich Johnston <rjohnston@sgi.com>

---
v3: Updated doc/CHANGES since v2
v2: fix spelling errors reported by Nathan.  my goodness!

 VERSION          |    2 +-
 configure.ac     |    2 +-
 debian/changelog |    6 ++++++
 doc/CHANGES      |   11 +++++++++++
 4 files changed, 19 insertions(+), 2 deletions(-)

Index: b/VERSION
===================================================================
--- a/VERSION
+++ b/VERSION
@@ -3,5 +3,5 @@
 #
 PKG_MAJOR=3
 PKG_MINOR=1
-PKG_REVISION=2
+PKG_REVISION=3
 PKG_BUILD=1
Index: b/configure.ac
===================================================================
--- a/configure.ac
+++ b/configure.ac
@@ -1,4 +1,4 @@
-AC_INIT([xfsdump], [3.1.2])
+AC_INIT([xfsdump], [3.1.3])
 AC_PREREQ(2.50)
 AC_CONFIG_AUX_DIR([.])
 AC_CONFIG_MACRO_DIR([m4])
Index: b/debian/changelog
===================================================================
--- a/debian/changelog
+++ b/debian/changelog
@@ -1,3 +1,9 @@
+xfsdump (3.1.3) unstable; urgency=low
+
+  * New upstream release
+
+ -- Nathan Scott <nathans@debian.org>  Tue, 19 Mar 2013 14:20:01 +1100
+
 xfsdump (3.1.1) unstable; urgency=low
 
   * New upstream release
Index: b/doc/CHANGES
===================================================================
--- a/doc/CHANGES
+++ b/doc/CHANGES
@@ -1,3 +1,14 @@
+xfsdump-3.1.3 (1 May 2013)
+	- Fix a segfault in xfsrestore when a path name is too long,
+	  thanks to Nigel Tamplin.
+	- Fix a backward compatibility problem.  Dumps created with
+	  version 3.1.2 where extended attributes are in use failed
+	  to restore with v3.1.0 due to file header checksum errors.
+	  Thanks to Fugazzi for reporting.
+	- Refactored release scripts to conform to using git archive.
+	- Changed the build process so that 'make deb' uses the same
+	  process of creating a source tree as the release script.
+
 xfsdump-3.1.2 (13 December 2012)
 	- Update release script to create a source tarball.
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
