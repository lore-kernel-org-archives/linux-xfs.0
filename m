Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3SNC3o8027341 for <xfs@oss.sgi.com>; Thu, 28 Apr 2011 18:12:04 -0500
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 08D8E41EE91
	for <xfs@oss.sgi.com>; Thu, 28 Apr 2011 16:15:35 -0700 (PDT)
Received: from postoffice2.aconex.com (mail.aconex.com [203.166.49.3]) by
	cuda.sgi.com with ESMTP id sXceOGIvTboVdZPr for
	<xfs@oss.sgi.com>; Thu, 28 Apr 2011 16:15:35 -0700 (PDT)
Received: from postoffice.aconex.com (postoffice.yarra.acx [192.168.35.100])
	by postoffice2.aconex.com with ESMTP id gd4P0hfczhmQzRkz for
	<xfs@oss.sgi.com>; Fri, 29 Apr 2011 09:15:33 +1000 (EST)
Received: from gatekeeper.aconex.com (gatekeeper.yarra.acx [192.168.35.102])
	by postoffice.aconex.com (Postfix) with ESMTP id 00A21A503CB
	for <xfs@oss.sgi.com>; Fri, 29 Apr 2011 09:15:33 +1000 (EST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by gatekeeper.aconex.com (Postfix) with ESMTP id A3F50A00006
	for <xfs@oss.sgi.com>; Fri, 29 Apr 2011 08:56:14 +1000 (EST)
Received: from gatekeeper.aconex.com ([127.0.0.1])
	by localhost (gatekeeper.aconex.com [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id ZhUEP-eA+7p2 for <xfs@oss.sgi.com>;
	Fri, 29 Apr 2011 08:56:12 +1000 (EST)
Received: from acxmail-au2.aconex.com (acxmail-au2.aconex.com [192.168.35.104])
	by gatekeeper.aconex.com (Postfix) with ESMTP id 2FBF6A00003
	for <xfs@oss.sgi.com>; Fri, 29 Apr 2011 08:56:12 +1000 (EST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by acxmail-au2.aconex.com (Postfix) with ESMTP id 4338B3B20002
	for <xfs@oss.sgi.com>; Fri, 29 Apr 2011 09:15:30 +1000 (EST)
Received: from acxmail-au2.aconex.com ([127.0.0.1])
	by localhost (acxmail-au2.aconex.com [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id Xjo-9udTxk9W for <xfs@oss.sgi.com>;
	Fri, 29 Apr 2011 09:15:30 +1000 (EST)
Received: from acxmail-au2.aconex.com (acxmail-au2.aconex.com [192.168.35.104])
	by acxmail-au2.aconex.com (Postfix) with ESMTP id 2155F3B20001
	for <xfs@oss.sgi.com>; Fri, 29 Apr 2011 09:15:30 +1000 (EST)
Date: Fri, 29 Apr 2011 09:15:30 +1000 (EST)
From: Nathan Scott <nathans@aconex.com>
Message-ID: <360436721.31453.1304032530041.JavaMail.root@acxmail-au2.aconex.com>
In-Reply-To: <55785369.30597.1303960403663.JavaMail.root@acxmail-au2.aconex.com>
Subject: [PATCH] xfsprogs - resolve Debian readline build issue
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

Address the recently reported build issue with libreadline5/6, via
the gplv2 route.  Since this appears to be a relatively recent pkg,
I made its use conditional so the deb build continues to work for
everyone not running a bleeding edge distro.  Works For Me (tm).

This addresses Debian bug 553875: libreadline5-dev removal pending

Signed-off-by: Nathan Scott <nathans@debian.org>

diff --git a/debian/control b/debian/control
index 401cdab..f813a43 100644
--- a/debian/control
+++ b/debian/control
@@ -3,7 +3,7 @@ Section: admin
 Priority: optional
 Maintainer: XFS Development Team <xfs@oss.sgi.com>
 Uploaders: Nathan Scott <nathans@debian.org>, Anibal Monsalve Salazar <anibal@debian.org>
-Build-Depends: uuid-dev, autoconf, debhelper (>= 5), gettext, libtool, libreadline5-dev, libblkid-dev (>= 2.17)
+Build-Depends: uuid-dev, autoconf, debhelper (>= 5), gettext, libtool, libreadline5-dev | libreadline-gplv2-dev, libblkid-dev (>= 2.17)
 Standards-Version: 3.9.1
 Homepage: http://oss.sgi.com/projects/xfs/
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
