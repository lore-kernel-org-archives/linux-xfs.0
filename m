Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0O6Jtw2254730 for <xfs@oss.sgi.com>; Sat, 24 Jan 2009 00:19:57 -0600
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 18114B3F06
	for <xfs@oss.sgi.com>; Fri, 23 Jan 2009 22:19:11 -0800 (PST)
Received: from postoffice2.aconex.com (mail.aconex.com [203.89.202.182]) by
	cuda.sgi.com with ESMTP id 585mSxG454YKu3ud for
	<xfs@oss.sgi.com>; Fri, 23 Jan 2009 22:19:11 -0800 (PST)
Received: from postoffice.aconex.com (localhost [127.0.0.1])
	by postoffice2.aconex.com (Spam Firewall) with ESMTP id 12BC722105
	for <xfs@oss.sgi.com>; Sat, 24 Jan 2009 17:19:10 +1100 (EST)
Received: from postoffice.aconex.com (postoffice.yarra.acx [192.168.102.1]) by
	postoffice2.aconex.com with ESMTP id h1hKUnI03cdWho1y for
	<xfs@oss.sgi.com>; Sat, 24 Jan 2009 17:19:10 +1100 (EST)
Received: from [192.168.0.100] (c220-239-214-222.fernt2.vic.optusnet.com.au
	[220.239.214.222])
	by postoffice.aconex.com (Postfix) with ESMTP id E77A992C34B
	for <xfs@oss.sgi.com>; Sat, 24 Jan 2009 17:19:09 +1100 (EST)
Subject: [PATCH] xfsdump spec file & version update
From: Nathan Scott <nscott@aconex.com>
Date: Sat, 24 Jan 2009 17:16:06 +1100
Message-Id: <1232777766.13684.22.camel@verge.scott.net.au>
Mime-Version: 1.0
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

Update xfsdump version to 3.0.0 to denote the slightly
different relationship with xfsprogs now (moved files,
removed libxfs.h dependencies).

diff --git a/VERSION b/VERSION
index 68ec770..665924b 100644
--- a/VERSION
+++ b/VERSION
@@ -1,7 +1,7 @@
 #
 # This file is used by configure to get version information
 #
-PKG_MAJOR=2
-PKG_MINOR=2
-PKG_REVISION=49
+PKG_MAJOR=3
+PKG_MINOR=0
+PKG_REVISION=0
 PKG_BUILD=1
diff --git a/build/rpm/xfsdump.spec.in b/build/rpm/xfsdump.spec.in
index 3f7a3e0..417dd84 100644
--- a/build/rpm/xfsdump.spec.in
+++ b/build/rpm/xfsdump.spec.in
@@ -5,7 +5,7 @@ Release: @pkg_release@
 Distribution: @pkg_distribution@
 Packager: Silicon Graphics, Inc. <http://www.sgi.com/>
 BuildRoot: @build_root@ 
-Requires: xfsprogs >= 2.6.30, attr >= 2.0.0
+Requires: xfsprogs >= 3.0.0, attr >= 2.0.0
 Source: @pkg_name@-@pkg_version@.src.tar.gz
 License: GPL
 Vendor: Silicon Graphics, Inc.
diff --git a/doc/CHANGES b/doc/CHANGES
index c1287b2..6f72397 100644
--- a/doc/CHANGES
+++ b/doc/CHANGES
@@ -1,3 +1,12 @@
+xfsdump-3.0.0 (24 Jan 2009)
+	- Bump major package version number to signify changed
+	  dependencies and moved binaries (xfs_fsr and estimate
+	  have moved into xfsprogs).
+	- xfsdump should no longer make use of internal XFS
+	  headers and libraries, in particular no use of libxfs
+	  is permitted in this package anymore (such detailed
+	  on-disk format knowledge is the realm of xfsprogs).
+
 xfsdump-2.2.49 (17 Feb 2008)
 	- Fix up error handling in _rmt_open in librmt.
 	  Warnings reported by Michal Marek <mmarek@novell.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
