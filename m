Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D8CA77F51
	for <xfs@oss.sgi.com>; Fri,  1 Feb 2013 17:30:24 -0600 (CST)
Received: from whiskey.americas.sgi.com (eagdhcp-232-197.americas.sgi.com
	[128.162.232.197])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2045DAC001
	for <xfs@oss.sgi.com>; Fri,  1 Feb 2013 15:30:21 -0800 (PST)
Date: Fri, 1 Feb 2013 17:30:20 -0600
From: Ben Myers <bpm@sgi.com>
Subject: xfsdump: update version numbers and changelog
Message-ID: <20130201233020.GO30652@sgi.com>
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

This xfsdump release is to release the backward compatability problems
reported by Fugazzi here: http://oss.sgi.com/archives/xfs/2013-01/msg00083.html

I have placed a pre-release tarball here:

ftp://oss.sgi.com/projects/xfs/cmd_tars/pre-release/xfsdump-pre-3.1.3.tar.gz

Please take a look and report any issues before next Wednesday.

Thanks,
	Ben

 VERSION      |    2 +-
 configure.ac |    2 +-
 doc/CHANGES  |    8 ++++++++
 3 files changed, 10 insertions(+), 2 deletions(-)

Index: b/VERSION
===================================================================
--- a/VERSION	2013-02-01 17:01:57.151945732 -0600
+++ b/VERSION	2013-02-01 17:02:34.341985827 -0600
@@ -3,5 +3,5 @@
 #
 PKG_MAJOR=3
 PKG_MINOR=1
-PKG_REVISION=2
+PKG_REVISION=3
 PKG_BUILD=1
Index: b/configure.ac
===================================================================
--- a/configure.ac	2013-02-01 17:02:07.701946330 -0600
+++ b/configure.ac	2013-02-01 17:02:40.341965107 -0600
@@ -1,4 +1,4 @@
-AC_INIT([xfsdump], [3.1.2])
+AC_INIT([xfsdump], [3.1.3])
 AC_PREREQ(2.50)
 AC_CONFIG_AUX_DIR([.])
 AC_CONFIG_MACRO_DIR([m4])
Index: b/doc/CHANGES
===================================================================
--- a/doc/CHANGES	2013-02-01 17:02:17.651945928 -0600
+++ b/doc/CHANGES	2013-02-01 17:25:13.971985822 -0600
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
