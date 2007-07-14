Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 14 Jul 2007 09:07:41 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6EG7Zbm016467
	for <xfs@oss.sgi.com>; Sat, 14 Jul 2007 09:07:37 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l6EG7bNM008517
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sat, 14 Jul 2007 18:07:37 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l6EG4XJl008262
	for xfs@oss.sgi.com; Sat, 14 Jul 2007 18:04:33 +0200
Date: Sat, 14 Jul 2007 18:04:21 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fix ASSERT and ASSERT_ALWAYS
Message-ID: <20070714160418.GA7768@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

 - remove the != 0 inside the unlikely in ASSERT_ALWAYS because sparse now
   complains about comparisms between pointers and 0
 - add a standalone ASSERT implementation because defining it to
   ASSERT_ALWAYS means the string is expanded before the #token passing
   stringification.  This way we get the actual content of the
   assertatio in the assfail message and don't overflow sparse's
   strinification buffer leading to sparse error messages.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/support/debug.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/support/debug.h	2007-07-14 15:55:12.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/support/debug.h	2007-07-14 15:55:46.000000000 +0200
@@ -34,10 +34,10 @@ extern void cmn_err(int, char *, ...)
 extern void assfail(char *expr, char *f, int l);
 
 #define ASSERT_ALWAYS(expr)	\
-	(unlikely((expr) != 0) ? (void)0 : assfail(#expr, __FILE__, __LINE__))
+	(unlikely(expr) ? (void)0 : assfail(#expr, __FILE__, __LINE__))
 
 #ifndef DEBUG
-# define ASSERT(expr)	((void)0)
+#define ASSERT(expr)	((void)0)
 
 #ifndef STATIC
 # define STATIC static noinline
@@ -49,8 +49,10 @@ extern void assfail(char *expr, char *f,
 
 #else /* DEBUG */
 
-# define ASSERT(expr)	ASSERT_ALWAYS(expr)
-# include <linux/random.h>
+#include <linux/random.h>
+
+#define ASSERT(expr)	\
+	(unlikely(expr) ? (void)0 : assfail(#expr, __FILE__, __LINE__))
 
 #ifndef STATIC
 # define STATIC noinline
