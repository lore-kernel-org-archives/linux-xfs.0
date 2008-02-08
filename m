Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Feb 2008 22:13:58 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m186DpKY006351
	for <xfs@oss.sgi.com>; Thu, 7 Feb 2008 22:13:53 -0800
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E582E5B343F
	for <xfs@oss.sgi.com>; Thu,  7 Feb 2008 22:14:07 -0800 (PST)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id 9CfZryBiAClFfMMw for <xfs@oss.sgi.com>; Thu, 07 Feb 2008 22:14:07 -0800 (PST)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m186E2F3018968
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 8 Feb 2008 07:14:02 +0100
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m186E2LK018966
	for xfs@oss.sgi.com; Fri, 8 Feb 2008 07:14:02 +0100
Date: Fri, 8 Feb 2008 07:14:02 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH, mainline-only] allow enabling CONFIG_XFS_DEBUG
Message-ID: <20080208061402.GA18924@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Back when I first submitted XFS for mainline inclusion we made the
decision that the debug code is far to extensive to be accidentally
enabled by users in mainline.  But then again it's often quite useful
to track problems down and hacking the makefile all the time is rather
annoying.  Given all the debug options with even more overhead like
lockdep or DEBUG_PAGE_ALLOC users (or rather developers) should know
by now what they're doing.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/Kconfig
===================================================================
--- linux-2.6.orig/fs/xfs/Kconfig	2008-02-08 07:08:09.000000000 +0100
+++ linux-2.6/fs/xfs/Kconfig	2008-02-08 07:08:38.000000000 +0100
@@ -76,3 +76,16 @@ config XFS_RT
 	  See the xfs man page in section 5 for additional information.
 
 	  If unsure, say N.
+
+config XFS_DEBUG
+	bool "XFS Debugging support (EXPERIMENTAL)"
+	depends on XFS_FS && EXPERIMENTAL
+	help
+	  Say Y here to get an XFS build with many debugging features,
+	  including ASSERT checks, function wrappers around macros,
+	  and extra sanity-checking functions in various code paths.
+
+	  Note that the resulting code will be HUGE and SLOW, and probably
+	  not useful unless you are debugging a particular problem.
+
+	  Say N unless you are an XFS developer, or you play one on TV.
