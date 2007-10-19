Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 18 Oct 2007 22:39:28 -0700 (PDT)
Received: from rwcrmhc12.comcast.net (rwcrmhc12.comcast.net [204.127.192.82])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9J5dBxe019706
	for <xfs@oss.sgi.com>; Thu, 18 Oct 2007 22:39:13 -0700
From: "Craig Rodrigues" <rodrigc@crodrigues.org>
Date: Fri, 19 Oct 2007 01:27:26 -0400
Subject: [PATCH] FreeBSD fix for xfsprogs
Message-ID: <20071019052726.GA2049@crodrigues.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

The attached patch is needed to compile xfsprogs on FreeBSD.
-- 
Craig Rodrigues
rodrigc@crodrigues.org

--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="a.txt"

Index: freebsd.c
===================================================================
RCS file: /cvs/xfs-cmds/xfsprogs/libxfs/freebsd.c,v
retrieving revision 1.17
diff -u -r1.17 freebsd.c
--- freebsd.c	16 Jul 2007 15:55:26 -0000	1.17
+++ freebsd.c	19 Oct 2007 05:26:15 -0000
@@ -21,6 +21,7 @@
 #include <sys/disk.h>
 #include <sys/mount.h>
 #include <sys/ioctl.h>
+#include <sys/sysctl.h>
 
 int platform_has_uuid = 1;
 extern char *progname;

--ikeVEW9yuYc//A+q--
