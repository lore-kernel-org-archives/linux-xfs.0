Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0O6nd2Z256734 for <xfs@oss.sgi.com>; Sat, 24 Jan 2009 00:49:39 -0600
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A2921B3E2C
	for <xfs@oss.sgi.com>; Fri, 23 Jan 2009 22:48:54 -0800 (PST)
Received: from postoffice2.aconex.com (mail.aconex.com [203.89.202.182]) by
	cuda.sgi.com with ESMTP id tuzGT1kNYgBhauyq for
	<xfs@oss.sgi.com>; Fri, 23 Jan 2009 22:48:54 -0800 (PST)
Received: from postoffice.aconex.com (localhost [127.0.0.1])
	by postoffice2.aconex.com (Spam Firewall) with ESMTP id 5FBF8220EC
	for <xfs@oss.sgi.com>; Sat, 24 Jan 2009 17:17:31 +1100 (EST)
Received: from postoffice.aconex.com (postoffice.yarra.acx [192.168.102.1]) by
	postoffice2.aconex.com with ESMTP id enWxAyLK7BbCB3kq for
	<xfs@oss.sgi.com>; Sat, 24 Jan 2009 17:17:31 +1100 (EST)
Received: from [192.168.0.100] (c220-239-214-222.fernt2.vic.optusnet.com.au
	[220.239.214.222])
	by postoffice.aconex.com (Postfix) with ESMTP id 3C8D292C295
	for <xfs@oss.sgi.com>; Sat, 24 Jan 2009 17:17:31 +1100 (EST)
Subject: [PATCH] xfsprogs spec file update
From: Nathan Scott <nscott@aconex.com>
Date: Sat, 24 Jan 2009 17:14:27 +1100
Message-Id: <1232777667.13684.20.camel@verge.scott.net.au>
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

Since binaries have moved between xfsprogs and xfsdump packages
in version 3.0.0, we need to fix the dependencies in the rpm
specfiles, else rpm will complain.

While in there, remove xfs-cmds Provides/Obsoletes lines, there
is no way anyone is ever going to be requiring those anymore (no
real-world upgrade path having such old skool SGI-released rpms).

diff --git a/build/rpm/xfsprogs.spec.in b/build/rpm/xfsprogs.spec.in
index 2826a37..cf61225 100644
--- a/build/rpm/xfsprogs.spec.in
+++ b/build/rpm/xfsprogs.spec.in
@@ -5,10 +5,8 @@ Release: @pkg_release@
 Distribution: @pkg_distribution@
 Packager: Silicon Graphics, Inc. <http://www.sgi.com/>
 BuildRoot: @build_root@ 
-Provides: xfs-cmds
-Obsoletes: xfs-cmds
 Prereq: /sbin/ldconfig
-Conflicts: xfsdump < 2.0.0
+Conflicts: xfsdump < 3.0.0
 Source: @pkg_name@-@pkg_version@.src.tar.gz
 License: GPL
 Vendor: Silicon Graphics, Inc.
@@ -32,8 +30,8 @@ with the IRIX version of XFS.
 %package devel
 Summary: XFS filesystem-specific static libraries and headers.
 Group: Development/Libraries
-Requires: @pkg_name@ >= 2.0.0
-Conflicts: @pkg_name@ < 2.0.0
+Requires: @pkg_name@ >= 3.0.0
+Conflicts: @pkg_name@ < 3.0.0
 
 %description devel
 xfsprogs-devel contains the libraries and header files needed to


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
