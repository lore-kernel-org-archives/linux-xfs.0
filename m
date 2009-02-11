Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1BH5hIQ142257 for <xfs@oss.sgi.com>; Wed, 11 Feb 2009 11:05:44 -0600
Received: from sovereign.computergmbh.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D3452191A939
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2009 09:05:07 -0800 (PST)
Received: from sovereign.computergmbh.de (sovereign.computergmbh.de
	[85.214.69.204]) by cuda.sgi.com with ESMTP id tobVKCxnr5igoOIU
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2009 09:05:07 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by sovereign.computergmbh.de (Postfix) with ESMTP id 7A9C7404534D
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2009 18:04:34 +0100 (CET)
Date: Wed, 11 Feb 2009 18:04:34 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
Subject: rfc 2/2: specfile: remove Distribution tag
In-Reply-To: <alpine.LSU.2.00.0902111802320.25232@fbirervta.pbzchgretzou.qr>
Message-ID: <alpine.LSU.2.00.0902111804070.25232@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0902111802320.25232@fbirervta.pbzchgretzou.qr>
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



parent c32f9b41de79a420e0896d2d4321ce74235d26ce (v{3.0.0}-1-gc32f9b4)
commit 4ee2e6de88b43bc9b4e1cc5a59cee264afd14123
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Feb 11 17:54:05 2009 +0100

specfile: remove Distribution tag

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

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 build/rpm/xfsprogs.spec.in |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/build/rpm/xfsprogs.spec.in b/build/rpm/xfsprogs.spec.in
index d9b3f2e..ab773dd 100644
--- a/build/rpm/xfsprogs.spec.in
+++ b/build/rpm/xfsprogs.spec.in
@@ -2,7 +2,6 @@ Summary: Utilities for managing the XFS filesystem.
 Name: @pkg_name@
 Version: @pkg_version@
 Release: @pkg_release@
-Distribution: @pkg_distribution@
 Packager: Silicon Graphics, Inc. <http://www.sgi.com/>
 BuildRoot: @build_root@ 
 Prereq: /sbin/ldconfig
-- 
# Created with git-export-patch

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
