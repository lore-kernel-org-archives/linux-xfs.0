Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p95MhBW5145667 for <xfs@oss.sgi.com>; Wed, 5 Oct 2011 17:43:11 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201110052243.p95MhBtl015550@stout.americas.sgi.com>
Date: Wed, 05 Oct 2011 17:43:11 -0500
Subject: [PATCH] xfstests: prepare for marking an initial versioned
 release
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

I would like to start marking versioned releases of xfstests.  The
following adds the release script used in the other XFS user space
packages.  I have arbitrarily set the version to 3.0.0 to make it
more in line with the other XFS user space packages as well.  I
created an initial CHANGES file with a simple summary of some
recently-added tests.

Signed-off-by: Alex Elder <aelder@sgi.com>
---
 VERSION     |    2 +-
 doc/CHANGES |   21 +++++++++++++++++++++
 release.sh  |   25 +++++++++++++++++++++++++
 3 files changed, 47 insertions(+), 1 deletion(-)

Index: b/VERSION
===================================================================
--- a/VERSION
+++ b/VERSION
@@ -1,7 +1,7 @@
 #
 # This file is used by configure to get version information
 #
-PKG_MAJOR=1
+PKG_MAJOR=3
 PKG_MINOR=0
 PKG_REVISION=0
 PKG_BUILD=1
Index: b/doc/CHANGES
===================================================================
--- /dev/null
+++ b/doc/CHANGES
@@ -0,0 +1,21 @@
+
+xfstests-3.0.0 (5 October 2011)
+	- This is the first versioned release recorded for the
+	  xfstests suite.  Tests 240-262 have been added to the
+	  suite (to date) in 2011.
+	- Here are some one-line summaries for some recently-added
+	  tests:
+		- 250: bmap BTREE corruption regression
+		- 251: concurrent FITRIM operations
+		- 252: fallocate hole punching
+		- 253: xfs_db metadump filename obfuscation
+		- 254: btrfs subvolume and snapshot
+		- 255: generic fallocate hole punching
+		- 256: full filesystem hole punching
+		- 257: getdents64() returning usable d_off values
+		- 258: file timestamps prior to the epoch
+		- 259: filesystem creation on just under 4TB storage
+		- 260: FITRIM argument handling
+		- 261: libxcmd giving up on bogus mtab entry
+		- 262: quota reporting doubled project quota values
+
Index: b/release.sh
===================================================================
--- /dev/null
+++ b/release.sh
@@ -0,0 +1,25 @@
+#!/bin/bash
+#
+# Automate generation a new release
+#
+
+. ./VERSION
+
+version=${PKG_MAJOR}.${PKG_MINOR}.${PKG_REVISION}
+date=`date +"%-d %B %Y"`
+
+echo "Updating CHANGES"
+sed -e "s/${version}.*/${version} (${date})/" doc/CHANGES > doc/CHANGES.tmp && \
+	mv doc/CHANGES.tmp doc/CHANGES
+
+echo "Commiting CHANGES update to git"
+git commit -s -a -m "${version} release"
+
+echo "Tagging git repository"
+git tag -s -a -m "${version} release" v${version}
+
+# echo "Creating source tarball"
+# make dist
+
+echo "Done."
+echo "Please remember to push out tags using \"git push --tags\""

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
