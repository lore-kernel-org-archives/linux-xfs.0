Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2UHoCvr063944 for <xfs@oss.sgi.com>; Wed, 30 Mar 2011 12:50:12 -0500
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 620DD8F809B
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2011 10:53:21 -0700 (PDT)
Subject: xfsprogs: update CHANGES file for release
From: Alex Elder <aelder@sgi.com>
Date: Wed, 30 Mar 2011 12:53:20 -0500
Message-ID: <1301507600.2953.13.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

Update the CHANGES file, in preparation for releasing xfsprogs 3.1.5.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 doc/CHANGES |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

Index: b/doc/CHANGES
===================================================================
--- a/doc/CHANGES
+++ b/doc/CHANGES
@@ -1,3 +1,18 @@
+xfsprogs-3.1.5 (30 March 2011)
+	- Polish translation update
+	- xfs_repair now warns if running in low memory mode
+	- Phase 2 of xfs_repair is now multithreaded
+	- xfs_quota no longer attempts to get quota information if
+	  not enabled
+	- Inode flags are now properly validated by xfs_repair
+	- Metadump now obfuscates all file names reliably
+	- xfs_io now supports the "fiemap" command, a more generic
+	  form of the "bmap" command
+	- xfs_io now supports the "fpunch" command, as well as a
+	  "-p" flag to the "fallocate command.  Both implement hole
+	  punching.
+	- A number of other bug fixes
+
 xfsprogs-3.1.4 (9 November 2010)
 	- Add projid32bit handling to userspace, resolving type
 	  sizing issues when dealing with 32 bit project ids.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
