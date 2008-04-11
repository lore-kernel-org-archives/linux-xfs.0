Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 11 Apr 2008 00:29:17 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3B7RsAa008027
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 00:27:56 -0700
Received: from chook.melbourne.sgi.com (chook.melbourne.sgi.com [134.14.54.237]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id RAA27725 for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 17:28:32 +1000
Date: Fri, 11 Apr 2008 17:28:32 +1000
Subject: [REVIEW] Remove unused HAVE_SPLICE macro
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080411072832.98C2C58C4C15@chook.melbourne.sgi.com>
From: donaldd@sgi.com (Donald Douwsma)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Still more 2.4 build remnants to get rid of...

HAVE_SPLICE was part of the infrastructure for building 2.4 and 2.6
kernels out of the same tree. Now we don't build 2.4 kernels this 
way anymore its unused.

Signed-off-by: Donald Douwsma <donaldd@sgi.com>

--- a/fs/xfs/linux-2.6/xfs_linux.h	2008-04-08 13:23:55.000000000 +1000
+++ b/fs/xfs/linux-2.6/xfs_linux.h	2008-04-08 12:09:22.455341741 +1000
@@ -99,7 +99,6 @@
 /*
  * Feature macros (disable/enable)
  */
-#define HAVE_SPLICE	/* a splice(2) exists in 2.6, but not in 2.4 */
 #ifdef CONFIG_SMP
 #define HAVE_PERCPU_SB	/* per cpu superblock counters are a 2.6 feature */
 #else
