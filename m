Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 21 May 2008 01:05:48 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4L85j9u031827
	for <xfs@oss.sgi.com>; Wed, 21 May 2008 01:05:45 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5A5BE1B30712
	for <xfs@oss.sgi.com>; Wed, 21 May 2008 01:06:34 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id sIkWZvnx4zox1D9h for <xfs@oss.sgi.com>; Wed, 21 May 2008 01:06:34 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m4L86RF3001774
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 21 May 2008 10:06:27 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m4L86R15001772
	for xfs@oss.sgi.com; Wed, 21 May 2008 10:06:27 +0200
Date: Wed, 21 May 2008 10:06:27 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] mark kmem_free / kmem_realloc argument as const
Message-ID: <20080521080627.GA1605@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Otherwise we get warnings when trying to free const pointers, as done
in the CI code.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/kmem.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/kmem.h	2008-05-21 10:00:42.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/kmem.h	2008-05-21 10:02:17.000000000 +0200
@@ -57,8 +57,8 @@ kmem_flags_convert(unsigned int __nocast
 extern void *kmem_alloc(size_t, unsigned int __nocast);
 extern void *kmem_zalloc(size_t, unsigned int __nocast);
 extern void *kmem_zalloc_greedy(size_t *, size_t, size_t, unsigned int __nocast);
-extern void *kmem_realloc(void *, size_t, size_t, unsigned int __nocast);
-extern void  kmem_free(void *);
+extern void *kmem_realloc(const void *, size_t, size_t, unsigned int __nocast);
+extern void  kmem_free(const void *);
 
 /*
  * Zone interfaces
Index: linux-2.6-xfs/fs/xfs/linux-2.6/kmem.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/kmem.c	2008-05-21 10:02:21.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/kmem.c	2008-05-21 10:02:33.000000000 +0200
@@ -90,7 +90,7 @@ kmem_zalloc_greedy(size_t *size, size_t 
 }
 
 void
-kmem_free(void *ptr)
+kmem_free(const void *ptr)
 {
 	if (((unsigned long)ptr < VMALLOC_START) ||
 	    ((unsigned long)ptr >= VMALLOC_END)) {
@@ -101,7 +101,7 @@ kmem_free(void *ptr)
 }
 
 void *
-kmem_realloc(void *ptr, size_t newsize, size_t oldsize,
+kmem_realloc(const void *ptr, size_t newsize, size_t oldsize,
 	     unsigned int __nocast flags)
 {
 	void	*new;
