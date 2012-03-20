Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2LHS1EQ105108 for <xfs@oss.sgi.com>; Wed, 21 Mar 2012 12:28:01 -0500
Message-Id: <20120321172813.301990261@sgi.com>
Date: Tue, 20 Mar 2012 15:43:17 -0500
From: bpm@sgi.com
Subject: [patch 1/1] xfsdump: update summaries in preparation for release
References: <20120320204316.811460772@sgi.com>
Content-Disposition: inline; filename=update-summaries-xfsdump-2
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
Cc: Christoph Hellwig <hch@infradead.org>, Nathan Scott <nathans@debian.org>, bpm@sgi.com

Signed-off-by: Ben Myers <bpm@sgi.com>
---
 VERSION          |    4 ++--
 debian/changelog |    6 ++++++
 doc/CHANGES      |   15 +++++++++++++++
 3 files changed, 23 insertions(+), 2 deletions(-)

Index: b/VERSION
===================================================================
--- a/VERSION	2012-03-20 15:05:19.306958556 -0500
+++ b/VERSION	2012-03-20 15:39:21.606353510 -0500
@@ -2,6 +2,6 @@
 # This file is used by configure to get version information
 #
 PKG_MAJOR=3
-PKG_MINOR=0
-PKG_REVISION=6
+PKG_MINOR=1
+PKG_REVISION=0
 PKG_BUILD=1
Index: b/debian/changelog
===================================================================
--- a/debian/changelog	2012-03-20 15:05:19.227119979 -0500
+++ b/debian/changelog	2012-03-20 15:39:52.546957236 -0500
@@ -1,3 +1,9 @@
+xfsdump (3.1.0) unstable; urgency=low
+
+  * New upstream release
+
+ -- Nathan Scott <nathans@debian.org>  Mon, 19 Mar 2012 15:07:12 +1100
+
 xfsdump (3.0.6) unstable; urgency=low
 
   * New upstream release
Index: b/doc/CHANGES
===================================================================
--- a/doc/CHANGES	2012-03-20 15:05:19.267069696 -0500
+++ b/doc/CHANGES	2012-03-20 15:38:58.486342973 -0500
@@ -1,3 +1,18 @@
+xfsdump-3.1.0 (20 March 2012)
+	- Fix metadata restore on split files.
+	- Add a -D option to skip a recursive scan of the filesystem
+	  when dumping.
+	- Fix a 1 byte overflow with empty lists, thanks to Mike Frysinger.
+	- Enable multi-stream support on Linux using pthreads.
+	- Fix handling of Ctrl-D in prompts.
+	- Obsolete SGI_XFSDUMP_SKIP_FILE extended attribute for excluding
+	  files from dump.
+	- Fix restoration of extended attributes on the root directory.
+	- Use the full 32-bit inode generation number instead of 12-bit
+	  generation number.  Bump the dump format version to 3.
+	- Do not create parent directories for orphaned files during
+	  list-only (-t option) restore.
+
 xfsdump-3.0.6 (14 October 2011)
 	- Unconditionally add checksums to various dump headers in
 	  xfsdump.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
