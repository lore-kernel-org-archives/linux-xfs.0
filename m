Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2D5A97F4C
	for <xfs@oss.sgi.com>; Tue, 19 Mar 2013 16:06:23 -0500 (CDT)
Received: from whiskey.americas.sgi.com (eagdhcp-232-197.americas.sgi.com
	[128.162.232.197])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 16E1E8F8066
	for <xfs@oss.sgi.com>; Tue, 19 Mar 2013 14:06:20 -0700 (PDT)
Date: Tue, 19 Mar 2013 16:06:19 -0500
From: Ben Myers <bpm@sgi.com>
Subject: xfsdump: update version numbers and changelog
Message-ID: <20130319210619.GH22182@sgi.com>
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
To: xfs@oss.sgi.com

Update version numbers and changelog.

Signed-off-by: Ben Myers <bpm@sgi.com>

---

Hi Folks,

I have placed a pre-release tarball here:

ftp://oss.sgi.com/projects/xfs/cmd_tars/pre-release/xfsdump-pre-3.1.3-2.tar.gz

Please take a peek and pipe up if you have issues.  Hopefully we can make it
official later this week.

Thanks,
	Ben

 VERSION          |    2 +-
 configure.ac     |    2 +-
 debian/changelog |    6 ++++++
 doc/CHANGES      |    8 ++++++++
 4 files changed, 16 insertions(+), 2 deletions(-)

Index: b/VERSION
===================================================================
--- a/VERSION	2013-02-14 10:54:46.231976798 -0600
+++ b/VERSION	2013-03-19 14:19:12.252027318 -0500
@@ -3,5 +3,5 @@
 #
 PKG_MAJOR=3
 PKG_MINOR=1
-PKG_REVISION=2
+PKG_REVISION=3
 PKG_BUILD=1
Index: b/configure.ac
===================================================================
--- a/configure.ac	2013-02-14 10:54:46.241946565 -0600
+++ b/configure.ac	2013-03-19 14:19:12.282005653 -0500
@@ -1,4 +1,4 @@
-AC_INIT([xfsdump], [3.1.2])
+AC_INIT([xfsdump], [3.1.3])
 AC_PREREQ(2.50)
 AC_CONFIG_AUX_DIR([.])
 AC_CONFIG_MACRO_DIR([m4])
Index: b/debian/changelog
===================================================================
--- a/debian/changelog	2013-03-19 14:19:25.481380914 -0500
+++ b/debian/changelog	2013-03-19 14:21:23.251380965 -0500
@@ -1,3 +1,9 @@
+xfsdump (3.1.3) unstable; urgency=low
+
+  * New updatream release
+
+ -- Nathan Scott <nathans@debian.org>  Tue, 19 Mar 2013 14:20:01 +1100
+
 xfsdump (3.1.1) unstable; urgency=low
 
   * New upstream release
Index: b/doc/CHANGES
===================================================================
--- a/doc/CHANGES	2013-02-14 10:54:46.251945754 -0600
+++ b/doc/CHANGES	2013-03-19 14:19:12.341381012 -0500
@@ -1,3 +1,11 @@
+xfsdump-3.1.3 (1 February 2013)
+	- Fix a segfault in xfsrestore when a path name is too long,
+	  thanks to Nigel Tamplin.
+	- Fix a backward compatability problem.  Dumps created with
+	  version 3.1.2 where extended attributes are in use failed
+	  to restore with v3.1.0 due to file header checksum errors.
+	  Thanks to Fugazzi for reporting.
+
 xfsdump-3.1.2 (13 December 2012)
 	- Update release script to create a source tarball.
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
