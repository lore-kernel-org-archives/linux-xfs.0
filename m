Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2UJXrHH073711 for <xfs@oss.sgi.com>; Wed, 30 Mar 2011 14:33:53 -0500
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9B10CAC006
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2011 12:37:01 -0700 (PDT)
Subject: [PATCH v2] xfsprogs: update CHANGES file for release
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1301507600.2953.13.camel@doink>
References: <1301507600.2953.13.camel@doink>
Date: Wed, 30 Mar 2011 14:37:00 -0500
Message-ID: <1301513820.2953.23.camel@doink>
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

Update the CHANGES file, in preparation for releasing xfsprogs
3.1.5.  Updated to modify debian/changelog, and to give appropriate
credit to contributors.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 debian/changelog |    4 ++++
 doc/CHANGES      |   15 +++++++++++++++
 2 files changed, 19 insertions(+)

Index: b/debian/changelog
===================================================================
--- a/debian/changelog
+++ b/debian/changelog
@@ -1,3 +1,7 @@
+xfsprogs (3.1.5) unstable; urgency=low
+  * New upstream release
+  * No more xfsquota error message for non-quota mounts (closes:
#618730)
+
 xfsprogs (3.1.4) unstable; urgency=low
 
   * New upstream release (32 projid resolution, fsr uses /proc/mounts)
Index: b/doc/CHANGES
===================================================================
--- a/doc/CHANGES
+++ b/doc/CHANGES
@@ -1,3 +1,18 @@
+xfsprogs-3.1.5 (11 March 2011)
+       - Polish translation update, provided by Jakub Bogusz
+       - xfs_repair now warns if running in low memory mode
+       - Phase 2 of xfs_repair is now multithreaded
+       - xfs_quota no longer attempts to get quota information if
+         not enabled
+       - Inode flags are now properly validated by xfs_repair
+       - Metadump now obfuscates all file names reliably
+       - xfs_io now supports the "fiemap" command, a more generic
+         form of the "bmap" command
+       - xfs_io now supports the "fpunch" command, as well as a
+         "-p" flag to the "fallocate command.  Both implement hole
+         punching.  Provided by Josef Bacik
+       - A number of other bug fixes provided by Ajeet Yadav
+
 xfsprogs-3.1.4 (9 November 2010)
        - Add projid32bit handling to userspace, resolving type
          sizing issues when dealing with 32 bit project ids.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
