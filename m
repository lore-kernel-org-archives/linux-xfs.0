Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 30 Jan 2007 14:00:57 -0800 (PST)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0UM0nqw008903
	for <xfs@oss.sgi.com>; Tue, 30 Jan 2007 14:00:52 -0800
Subject: [PATCH] bump xfsprogs version for xfs_quota(8) update
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
Content-Type: multipart/mixed; boundary="=-rORJjqAxnrUzuSF4hvNr"
Date: Wed, 31 Jan 2007 08:59:43 +1100
Message-Id: <1170194383.18017.293.camel@edge>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: bnaujok@sgi.com, donaldd@sgi.com
Cc: xfs@oss.sgi.com

--=-rORJjqAxnrUzuSF4hvNr
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi guys,

Those xfs_quota(8) errors were reported as a Debian bug today -
could you guys bump the version & update the docs (as in this
patch) for me?

thanks.

-- 
Nathan


--=-rORJjqAxnrUzuSF4hvNr
Content-Disposition: attachment; filename=bump-debian
Content-Type: text/x-patch; name=bump-debian; charset=UTF-8
Content-Transfer-Encoding: 7bit

Index: xfsprogs/VERSION
===================================================================
--- xfsprogs.orig/VERSION	2007-01-31 08:53:02.371648250 +1100
+++ xfsprogs/VERSION	2007-01-31 08:53:10.748171750 +1100
@@ -3,5 +3,5 @@
 #
 PKG_MAJOR=2
 PKG_MINOR=8
-PKG_REVISION=18
+PKG_REVISION=19
 PKG_BUILD=1
Index: xfsprogs/debian/changelog
===================================================================
--- xfsprogs.orig/debian/changelog	2007-01-31 08:52:38.182136500 +1100
+++ xfsprogs/debian/changelog	2007-01-31 08:54:18.016375750 +1100
@@ -1,3 +1,9 @@
+xfsprogs (2.8.19-1) unstable; urgency=low
+
+  * New upstream release (closes: #409063)
+
+ -- Nathan Scott <nathans@debian.org>  Wed, 31 Jan 2007 08:53:32 +1100
+
 xfsprogs (2.8.18-1) unstable; urgency=low
 
   * New upstream release (closes: #399888)
Index: xfsprogs/doc/CHANGES
===================================================================
--- xfsprogs.orig/doc/CHANGES	2007-01-31 08:52:38.202137750 +1100
+++ xfsprogs/doc/CHANGES	2007-01-31 08:55:09.939620750 +1100
@@ -1,8 +1,9 @@
-xfsprogs-2.8.x (25 January 2007)
+xfsprogs-2.8.19 (31 January 2007)
 	- Fix pthread stack size setting in xfs_repair.
 	- Fix xfs_bmap -n option displaying a truncated extent.
 	- Fix xfs_io mwrite segfault. Thanks to Utako Kusaka for these two
 	  fixes.
+	- Fix errors in xfs_quota(8) man page.
 
 xfsprogs-2.8.18 (8 December 2006)
  	- <xfs/list.h> is an installed file, we cannot simply rename it,

--=-rORJjqAxnrUzuSF4hvNr--
