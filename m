Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 21 May 2008 01:07:14 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4L87AAZ032282
	for <xfs@oss.sgi.com>; Wed, 21 May 2008 01:07:11 -0700
Received: from pc-bnaujok.melbourne.sgi.com (pc-bnaujok.melbourne.sgi.com [134.14.55.58]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id SAA03334 for <xfs@oss.sgi.com>; Wed, 21 May 2008 18:08:00 +1000
Subject: REVIEW: Remove kmem_free build warnings
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <20080521080648.82DCF58C4C29@chook.melbourne.sgi.com>
Date: Wed, 21 May 2008 18:10:08 +1000
Message-ID: <op.ubhvm6ax3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <20080521080648.82DCF58C4C29@chook.melbourne.sgi.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>



===========================================================================
fs/xfs/linux-2.6/kmem.c
===========================================================================

--- a/fs/xfs/linux-2.6/kmem.c	2008-05-21 18:06:48.000000000 +1000
+++ b/fs/xfs/linux-2.6/kmem.c	2008-05-21 18:04:44.400231547 +1000
@@ -90,7 +90,7 @@ kmem_zalloc_greedy(size_t *size, size_t
  }

  void
-kmem_free(void *ptr)
+kmem_free(const void *ptr)
  {
  	if (((unsigned long)ptr < VMALLOC_START) ||
  	    ((unsigned long)ptr >= VMALLOC_END)) {

===========================================================================
fs/xfs/linux-2.6/kmem.h
===========================================================================

--- a/fs/xfs/linux-2.6/kmem.h	2008-05-21 18:06:48.000000000 +1000
+++ b/fs/xfs/linux-2.6/kmem.h	2008-05-21 18:05:33.673925302 +1000
@@ -58,7 +58,7 @@ extern void *kmem_alloc(size_t, unsigned
  extern void *kmem_zalloc(size_t, unsigned int __nocast);
  extern void *kmem_zalloc_greedy(size_t *, size_t, size_t, unsigned int  
__nocast);
  extern void *kmem_realloc(void *, size_t, size_t, unsigned int __nocast);
-extern void  kmem_free(void *);
+extern void  kmem_free(const void *);

  /*
   * Zone interfaces
