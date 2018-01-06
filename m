Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:44709 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752619AbeAFADZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Jan 2018 19:03:25 -0500
Date: Fri, 5 Jan 2018 16:03:16 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfsprogs: update dead urls
Message-ID: <20180106000316.GO5602@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Since oss.sgi.com is dead and xfs.org is slowly migrating to
xfs.wiki.kernel.org, update all the documentation links to point to the
current landing pads.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 README           |    2 +-
 debian/control   |    6 +++---
 debian/copyright |    2 +-
 debian/watch     |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/README b/README
index 123af50..2936ee1 100644
--- a/README
+++ b/README
@@ -9,4 +9,4 @@ and references to other XFS manual pages.
 
 For more information and details on how to contribute to the
 XFS project see the web pages at:
-	http://xfs.org/
+	https://xfs.wiki.kernel.org/
diff --git a/debian/control b/debian/control
index 5c26e3d..f5980b2 100644
--- a/debian/control
+++ b/debian/control
@@ -5,7 +5,7 @@ Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
 Uploaders: Nathan Scott <nathans@debian.org>, Anibal Monsalve Salazar <anibal@debian.org>
 Build-Depends: uuid-dev, dh-autoreconf, debhelper (>= 5), gettext, libtool, libreadline-gplv2-dev | libreadline5-dev, libblkid-dev (>= 2.17), linux-libc-dev, libdevmapper-dev
 Standards-Version: 3.9.1
-Homepage: http://xfs.org/
+Homepage: https://xfs.wiki.kernel.org/
 
 Package: xfsprogs
 Depends: ${shlibs:Depends}, ${misc:Depends}
@@ -24,7 +24,7 @@ Description: Utilities for managing the XFS filesystem
  Btrees (directories, extents, free space) to aid both performance
  and scalability.
  .
- Refer to the documentation at http://oss.sgi.com/projects/xfs/
+ Refer to the documentation at https://xfs.wiki.kernel.org/
  for complete details.
 
 Package: xfslibs-dev
@@ -44,7 +44,7 @@ Description: XFS filesystem-specific static libraries and headers
  Btrees (directories, extents, free space) to aid both performance
  and scalability.
  .
- Refer to the documentation at http://xfs.org/
+ Refer to the documentation at https://xfs.wiki.kernel.org/
  for complete details.
 
 Package: xfsprogs-udeb
diff --git a/debian/copyright b/debian/copyright
index b677c25..74f4c89 100644
--- a/debian/copyright
+++ b/debian/copyright
@@ -1,7 +1,7 @@
 This package was debianized by Nathan Scott nathans@debian.org on
 Sun, 19 Nov 2000 07:37:09 -0500.
 
-It can be downloaded from ftp://oss.sgi.com/projects/xfs/download/
+It can be downloaded from https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/
 
 Copyright:
 
diff --git a/debian/watch b/debian/watch
index 0aa3e8d..88f6a0f 100644
--- a/debian/watch
+++ b/debian/watch
@@ -1,3 +1,3 @@
 version=3
 opts=uversionmangle=s/(\d)[_\.\-\+]?((RC|rc|pre|dev|beta|alpha)\d*)$/$1~$2/ \
-ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsprogs-(.+)\.tar\.gz
+https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-(.+)\.tar\.xz
