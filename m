Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2JK4SnB159673 for <xfs@oss.sgi.com>; Mon, 19 Mar 2012 15:04:28 -0500
Message-Id: <20120319200435.983772174@sgi.com>
Date: Mon, 19 Mar 2012 15:03:26 -0500
From: bpm@sgi.com
Subject: [patch 1/1] xfsprogs: update summaries in preparation for release
	3.1.8
References: <20120319200325.070328663@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7463748941906593409=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Christoph Hellwig <hch@infradead.org>, Nathan Scott <nathans@debian.org>, bpm@sgi.com

--===============7463748941906593409==
Content-Disposition: inline; filename=update-summaries

Signed-off-by: Ben Myers <bpm@sgi.com>

Index: xfsprogs/VERSION
===================================================================
--- xfsprogs.orig/VERSION
+++ xfsprogs/VERSION
@@ -3,5 +3,5 @@
 #
 PKG_MAJOR=3
 PKG_MINOR=1
-PKG_REVISION=7
+PKG_REVISION=8
 PKG_BUILD=1
Index: xfsprogs/debian/changelog
===================================================================
--- xfsprogs.orig/debian/changelog
+++ xfsprogs/debian/changelog
@@ -1,3 +1,10 @@
+xfsprogs (3.1.8) unstable; urgency=low
+
+  * New upstream release
+  * Numerous xfs_repair fixes
+
+ -- Nathan Scott <nathans@debian.org>  Mon, 19 Mar 2012 14:21:00 +1100
+
 xfsprogs (3.1.7) unstable; urgency=low
 
   * New upstream release
Index: xfsprogs/doc/CHANGES
===================================================================
--- xfsprogs.orig/doc/CHANGES
+++ xfsprogs/doc/CHANGES
@@ -1,3 +1,44 @@
+xfsprogs-3.1.8 (19 March 2012)
+	- Fix xfs_repair segfault on a corrupted filesystem by validating the
+	  acl count before reading it.
+	- Avoid xfs_repair deadlocks on prefetched buffers.
+	- Fix various incorrect printf formats, thanks to Jakub Bogusz for
+	  reporting.
+	- Polish translation update, thanks to Jakub Bogusz.
+	- Refuse mkfs.xfs on misaligned devices when using 4k sectors, unless
+	  the -f option is specified, and then force 512b sector size,
+	  thanks to Carlos Maiolino.
+	- Avoid a possible loop on the unlinked inode list in phase 3 of
+	  xfs_repair, thanks to Stefan Pfetzing for reporting.
+	- Allocate inode and free extent records individually in xfs_repair.
+	- Fix a possible deadlock btree nodes in xfs_repair by using recursive
+	  locking, thanks to Arkadiusz Miśkiewicz for reporting and testing.
+	- Fix possible xfs_repair deadlocks in inode prefetching, thanks to
+	  Arkadiusz Miśkiewicz for reporting and testing.
+	- Make xfs_repair handle filesystems with the log in ag 0, thanks to
+	  Sindre Skogen for reporting.
+	- Deprecate the -F foreign flag to xfs_io.
+	- Add debian linux-libc-dev build dependancy.
+	- Add an extended fiemap configure check.
+	- Various cleanups in xfs_repair.
+	- Update xfs_check man page to recommend xfs_repair over xfs_check,
+	  thanks to Arkadiusz Miśkiewicz.
+	- Update the on-disk extent count as part of inode repair when moving
+	  inodes to lost+found to avoid to avoid tripping over a check in
+	  xfs_iformat, thanks to Arkadiusz Miśkiewicz for reporting and
+	  testing.
+	- Check for size parsing errors in xfs_quota, thanks to James Lawrie
+	  for reporting.
+	- Fix fiemap loop continuation in xfs_io.
+	- Make mkfs.xfs properly handle physical sector size.
+	- Fix /proc/mounts parsing in xfs_fsr.
+	- Fix xfs_repair when ag_stride options with attributes and dirv1 code,
+	  thanks to Tom Crane for reporting and testing.
+	- Fix message formats in process_dinode_int.
+	- Fix xfs_repair handling of link counts when the on-disk count
+	  overflows 8 bits.
+	- Fix messages from set_nlinks in xfs_repair.
+
 xfsprogs-3.1.7 (17 November 2011)
 	- Pull in fix for debian/control
 	- Polish translation update, thanks to Jakub Bogusz


--===============7463748941906593409==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7463748941906593409==--
