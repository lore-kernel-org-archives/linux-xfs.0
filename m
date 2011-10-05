Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p95MAaDL144036 for <xfs@oss.sgi.com>; Wed, 5 Oct 2011 17:10:36 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201110052210.p95MAXGI012463@stout.americas.sgi.com>
Date: Wed, 05 Oct 2011 17:10:33 -0500
Subject: [PATCH] xfsdump: update summaries in preparation for release
 3.0.6
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

The following is a draft of summaries to be included in the next
release of xfsdump.

Signed-off-by: Alex Elder <alder@sgi.com>
---
 debian/changelog |    6 ++++++
 doc/CHANGES      |   26 ++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

Index: b/debian/changelog
===================================================================
--- a/debian/changelog
+++ b/debian/changelog
@@ -1,3 +1,9 @@
+xfsdump (3.0.6) unstable; urgency=low
+
+  * New upstream release
+
+ -- Nathan Scott <nathans@debian.org>  Wed,  5 Oct 2011 16:46:01 +1100
+
 xfsdump (3.0.5) unstable; urgency=low
 
   * New upstream release
Index: b/doc/CHANGES
===================================================================
--- a/doc/CHANGES
+++ b/doc/CHANGES
@@ -1,3 +1,29 @@
+xfsdump-3.0.6 (5 October 2011)
+	- Checksums available in various dump headers have now been
+	  enabled--unconditionally.  Previous Linux versions never
+	  appeared to have generated these.  A bug in generating the
+	  checksum for extended attributes was fixed, and the
+	  presence of this fix is now recorded with a different flag
+	  bit in the attribute header.
+	- Signal handling has been reworked to use a common signal
+	  handler and the POSIX signal API.  It has also been
+	  restructured a bit to be more amenable to a future
+	  conversion to using pthread model.
+	- A number of other changes have been implemented in
+	  preparation for support for multi-threaded dump and
+	  restore.
+	- Exit status for an individual restore stream is now
+	  properly reported to its parent process.
+	- Some areas of code have been refactored and cleaned up
+	  considerably.  Some dead code (always #ifdef'd) code has
+	  been eliminated.  Some other conditionally compiled
+	  code--always included--has been changed to be built
+	  unconditionally.
+	- Some dialogs, which were previously restricted to at most
+	  8 options, are now able to present up to 99.
+	- Ted Ts'o provided some improvements in support of building
+	  in a "hermetic" environment.
+
 xfsdump-3.0.5 (30 March 2011)
 	- Release tags will now be digitally signed
 	- Quota files will now be dumped, regardless of the maxsize

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
