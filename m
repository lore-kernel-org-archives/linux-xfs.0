Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9DGV5Ah192187 for <xfs@oss.sgi.com>; Thu, 13 Oct 2011 11:31:05 -0500
Received: from stout.americas.sgi.com (stout.americas.sgi.com [128.162.232.50])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D2979AC007
	for <xfs@oss.sgi.com>; Thu, 13 Oct 2011 09:31:04 -0700 (PDT)
Received: from stout.americas.sgi.com (localhost6.localdomain6 [127.0.0.1])
	by stout.americas.sgi.com (8.14.5/8.14.2) with ESMTP id p9DGV4f1002217
	for <xfs@oss.sgi.com>; Thu, 13 Oct 2011 11:31:04 -0500
Received: (from aelder@localhost)
	by stout.americas.sgi.com (8.14.5/8.14.5/Submit) id p9DGV4oE002216
	for xfs@oss.sgi.com; Thu, 13 Oct 2011 11:31:04 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201110131631.p9DGV4oE002216@stout.americas.sgi.com>
Date: Thu, 13 Oct 2011 11:31:04 -0500
Subject: [PATCH,v2] xfstests: prepare for marking an initial versioned release
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

The following adds the release script used in the other XFS user
space packages.  The version is arbitrarily set to 3.0.0, aligning
it roughly with the current version of the Linux kernel as well as
to the other XFS user space packages.

Signed-off-by: Alex Elder <aelder@sgi.com>
---
Changed for v2:
 - Dropped recent test summaries from the CHANGES file

 VERSION     |    2 +-
 doc/CHANGES |    4 ++++
 release.sh  |   25 +++++++++++++++++++++++++
 3 files changed, 30 insertions(+), 1 deletion(-)

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
@@ -0,0 +1,4 @@
+xfstests-3.0.0 (13 October 2011)
+	- This is the first versioned release recorded for the
+	  xfstests suite.  Tests 240-263 have been added to the
+	  suite (to date) in 2011.
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
