Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1BH4foK142198 for <xfs@oss.sgi.com>; Wed, 11 Feb 2009 11:04:42 -0600
Received: from sovereign.computergmbh.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E4AB710A9A3
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2009 09:04:05 -0800 (PST)
Received: from sovereign.computergmbh.de (sovereign.computergmbh.de
	[85.214.69.204]) by cuda.sgi.com with ESMTP id HbZjjTaJWqY4d2Id
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2009 09:04:05 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by sovereign.computergmbh.de (Postfix) with ESMTP id 29AB5404534D
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2009 18:04:04 +0100 (CET)
Date: Wed, 11 Feb 2009 18:04:04 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
Subject: rfc 1/2: specfile: use rpm macros where possible
Message-ID: <alpine.LSU.2.00.0902111802320.25232@fbirervta.pbzchgretzou.qr>
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


parent d8a0f148be5b5ea67ee84c61201e98d345c14eda (v{3.0.0})
commit c32f9b41de79a420e0896d2d4321ce74235d26ce
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Feb 11 17:52:53 2009 +0100

specfile: use rpm macros where possible

This way less places need to be changes (when a developer decides
to change it..) after the placeholders have been substituted.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 build/rpm/xfsprogs.spec.in |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/build/rpm/xfsprogs.spec.in b/build/rpm/xfsprogs.spec.in
index cf61225..d9b3f2e 100644
--- a/build/rpm/xfsprogs.spec.in
+++ b/build/rpm/xfsprogs.spec.in
@@ -7,7 +7,7 @@ Packager: Silicon Graphics, Inc. <http://www.sgi.com/>
 BuildRoot: @build_root@ 
 Prereq: /sbin/ldconfig
 Conflicts: xfsdump < 3.0.0
-Source: @pkg_name@-@pkg_version@.src.tar.gz
+Source: %name-%version.src.tar.gz
 License: GPL
 Vendor: Silicon Graphics, Inc.
 URL: http://oss.sgi.com/projects/xfs/
@@ -30,8 +30,8 @@ with the IRIX version of XFS.
 %package devel
 Summary: XFS filesystem-specific static libraries and headers.
 Group: Development/Libraries
-Requires: @pkg_name@ >= 3.0.0
-Conflicts: @pkg_name@ < 3.0.0
+Requires: %name >= 3.0.0
+Conflicts: %name < 3.0.0
 
 %description devel
 xfsprogs-devel contains the libraries and header files needed to
-- 
# Created with git-export-patch

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
