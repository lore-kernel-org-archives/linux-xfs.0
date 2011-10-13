Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9DGRGxm192006 for <xfs@oss.sgi.com>; Thu, 13 Oct 2011 11:27:17 -0500
Received: from stout.americas.sgi.com (stout.americas.sgi.com [128.162.232.50])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5E3E6AC007
	for <xfs@oss.sgi.com>; Thu, 13 Oct 2011 09:27:16 -0700 (PDT)
Received: from stout.americas.sgi.com (localhost6.localdomain6 [127.0.0.1])
	by stout.americas.sgi.com (8.14.5/8.14.2) with ESMTP id p9DGRF02001892
	for <xfs@oss.sgi.com>; Thu, 13 Oct 2011 11:27:15 -0500
Received: (from aelder@localhost)
	by stout.americas.sgi.com (8.14.5/8.14.5/Submit) id p9DGRF6Y001891
	for xfs@oss.sgi.com; Thu, 13 Oct 2011 11:27:15 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201110131627.p9DGRF6Y001891@stout.americas.sgi.com>
Date: Thu, 13 Oct 2011 11:27:15 -0500
Subject: [PATCH,v2] xfsdump: update summaries in preparation for release 3.0.6
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
Reviewed-by: Bill Kendall <wkendall@sgi.com>

---
Changed for v2:
 - Abbreviated the summary in the CHANGES file

 debian/changelog |    6 ++++++
 doc/CHANGES      |   10 ++++++++++
 2 files changed, 16 insertions(+)

Index: b/debian/changelog
===================================================================
--- a/debian/changelog
+++ b/debian/changelog
@@ -1,3 +1,9 @@
+xfsdump (3.0.6) unstable; urgency=low
+
+  * New upstream release
+
+ -- Nathan Scott <nathans@debian.org>  Wed, 11 Oct 2011 16:46:01 +1100
+
 xfsdump (3.0.5) unstable; urgency=low
 
   * New upstream release
Index: b/doc/CHANGES
===================================================================
--- a/doc/CHANGES
+++ b/doc/CHANGES
@@ -1,3 +1,13 @@
+xfsdump-3.0.6 (13 October 2011)
+	- Unconditionally add checksums to various dump headers in
+	  xfsdump.
+	- Verify dump header checksums if present in xfsrestore.
+	- Convert to using the POSIX signal API.
+	- Remove restriction of 8 options in dialogs.
+	- Various refactoring and internal cleanups to xfsdump and
+	  xfsrestore.
+	- Build system fixes, thanks to Ted Ts'o.
+
 xfsdump-3.0.5 (30 March 2011)
 	- Release tags will now be digitally signed
 	- Quota files will now be dumped, regardless of the maxsize

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
