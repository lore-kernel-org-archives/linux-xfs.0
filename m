Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2JKhdY1161788 for <xfs@oss.sgi.com>; Mon, 19 Mar 2012 15:43:39 -0500
Message-Id: <20120319204350.149959363@sgi.com>
Date: Mon, 19 Mar 2012 15:42:57 -0500
From: bpm@sgi.com
Subject: [patch 1/1] xfsdump: update summaries in preparation for release
References: <20120319204256.762648511@sgi.com>
Content-Disposition: inline; filename=update-summaries-xfsdump
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
Cc: Christoph Hellwig <hch@infradead.org>, Nathan Scott <nathans@debian.org>

Signed-off-by: Ben Myers <bpm@sgi.com>
Index: xfsdump-dev/debian/changelog
===================================================================
--- xfsdump-dev.orig/debian/changelog
+++ xfsdump-dev/debian/changelog
@@ -1,3 +1,9 @@
+xfsdump (3.0.7) unstable; urgency=low
+
+  * New upstream release
+
+ -- Nathan Scott <nathans@debian.org>  Mon, 19 Mar 2012 15:07:12 +1100
+
 xfsdump (3.0.6) unstable; urgency=low
 
   * New upstream release
Index: xfsdump-dev/doc/CHANGES
===================================================================
--- xfsdump-dev.orig/doc/CHANGES
+++ xfsdump-dev/doc/CHANGES
@@ -1,3 +1,10 @@
+xfsdump-3.0.7 (19 March 2012)
+	- Fix metadata restore on split files.
+	- Add a -D option to skip a recursive scan of the filesystem
+	  when dumping.
+	- Fix a 1 byte overflow with empty lists, thanks to Mike Frysinger
+	- Enable multi-stream support on Linux using pthreads.
+
 xfsdump-3.0.6 (14 October 2011)
 	- Unconditionally add checksums to various dump headers in
 	  xfsdump.
Index: xfsdump-dev/VERSION
===================================================================
--- xfsdump-dev.orig/VERSION
+++ xfsdump-dev/VERSION
@@ -3,5 +3,5 @@
 #
 PKG_MAJOR=3
 PKG_MINOR=0
-PKG_REVISION=6
+PKG_REVISION=7
 PKG_BUILD=1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
