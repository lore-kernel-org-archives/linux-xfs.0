Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1PAIaFo199462 for <xfs@oss.sgi.com>; Wed, 25 Feb 2009 04:18:36 -0600
Received: from sovereign.computergmbh.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D2296151BCC
	for <xfs@oss.sgi.com>; Wed, 25 Feb 2009 02:18:05 -0800 (PST)
Received: from sovereign.computergmbh.de (sovereign.computergmbh.de
	[85.214.69.204]) by cuda.sgi.com with ESMTP id omXEUcV6Q01unWEv
	for <xfs@oss.sgi.com>; Wed, 25 Feb 2009 02:18:05 -0800 (PST)
Date: Wed, 25 Feb 2009 11:18:04 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
Subject: dmapi: specfile: remove Distribution/Packager tag
In-Reply-To: <alpine.LSU.2.00.0902251114250.20946@fbirervta.pbzchgretzou.qr>
Message-ID: <alpine.LSU.2.00.0902251117470.20946@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0902111802320.25232@fbirervta.pbzchgretzou.qr>
	<20090215172417.GA20256@infradead.org>
	<alpine.LSU.2.00.0902191625070.20437@fbirervta.pbzchgretzou.qr>
	<20090224190731.GA22910@infradead.org>
	<alpine.LSU.2.00.0902251114250.20946@fbirervta.pbzchgretzou.qr>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com


parent e88a1b61f0258b51a1d0c99991cc25b28fddd1a8 ()
commit 9db3ece5fd5dc3265f28869140be262f16ef95ac
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Feb 25 11:15:51 2009 +0100

specfile: remove Distribution/Packager tag; use rpm macros

There exist a number of rpm specfile tags that make it possible to
mislead users of the produced RPM package, because its presence
overrides anything that has been specified in ~/.rpmmacros (or the
configuration files of the build system used). Such is especially
annoying when Packager:/Vendor: is put in specfiles, because it is
then almost impossible to get the name/email of the person who
_really_ did the packaging (assuming s/he set it in their
.rpmmacros).

Such similarly applies to the Distribution: tag, which is why I
suggest its removal and let the build systems provide the proper
string instead.

Also make use of rpm macros in one place.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 build/rpm/dmapi.spec.in |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/build/rpm/dmapi.spec.in b/build/rpm/dmapi.spec.in
index a0c5de6..22832da 100644
--- a/build/rpm/dmapi.spec.in
+++ b/build/rpm/dmapi.spec.in
@@ -2,8 +2,6 @@ Summary: Data Management API runtime environment.
 Name: @pkg_name@
 Version: @pkg_version@
 Release: @pkg_release@
-Distribution: @pkg_distribution@
-Packager: Silicon Graphics, Inc. <http://www.sgi.com/>
 BuildRoot: @build_root@
 Prereq: /sbin/ldconfig
 Conflicts: xfsdump < 2.0.0
@@ -23,7 +21,7 @@ by the libdm library.
 %package devel
 Summary: Data Management API static libraries and headers.
 Group: Development/Libraries
-Requires: @pkg_name@ >= 2.0.4 xfsprogs-devel
+Requires: %name >= 2.0.4 xfsprogs-devel
 
 %description devel
 dmapi-devel contains the libraries and header files needed to
-- 
# Created with git-export-patch

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
