Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 11 Apr 2008 07:44:00 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3BEhodT006154
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 07:43:53 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 931DD780A97
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 07:44:29 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id MiIt9WV9WroG7HrW for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 07:44:29 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id CEF5A180307FA
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 09:44:28 -0500 (CDT)
Message-ID: <47FF794C.4020801@sandeen.net>
Date: Fri, 11 Apr 2008 09:44:28 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] remove INT_GET and friends
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

Thanks to hch's endian work, INT_GET etc are no longer used,
and may as well be removed.  INT_SET is still used in
the acl code, though.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

 xfs_arch.h |   68 ---------------------------------
 1 files changed, 68 deletions(-)



Index: linux-2.6-xfs/fs/xfs/xfs_arch.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_arch.h
+++ linux-2.6-xfs/fs/xfs/xfs_arch.h
@@ -92,16 +92,6 @@
 	((__u8*)(pointer))[1] = (((value)     ) & 0xff); \
     }
 
-/* define generic INT_ macros */
-
-#define INT_GET(reference,arch) \
-    (((arch) == ARCH_NOCONVERT) \
-	? \
-	    (reference) \
-	: \
-	    INT_SWAP((reference),(reference)) \
-    )
-
 /* does not return a value */
 #define INT_SET(reference,arch,valueref) \
     (__builtin_constant_p(valueref) ? \
@@ -112,64 +102,6 @@
 	) \
     )
 
-/* does not return a value */
-#define INT_MOD_EXPR(reference,arch,code) \
-    (((arch) == ARCH_NOCONVERT) \
-	? \
-	    (void)((reference) code) \
-	: \
-	    (void)( \
-		(reference) = INT_GET((reference),arch) , \
-		((reference) code), \
-		INT_SET(reference, arch, reference) \
-	    ) \
-    )
-
-/* does not return a value */
-#define INT_MOD(reference,arch,delta) \
-    (void)( \
-	INT_MOD_EXPR(reference,arch,+=(delta)) \
-    )
-
-/*
- * INT_COPY - copy a value between two locations with the
- *	      _same architecture_ but _potentially different sizes_
- *
- *	    if the types of the two parameters are equal or they are
- *		in native architecture, a simple copy is done
- *
- *	    otherwise, architecture conversions are done
- *
- */
-
-/* does not return a value */
-#define INT_COPY(dst,src,arch) \
-    ( \
-	((sizeof(dst) == sizeof(src)) || ((arch) == ARCH_NOCONVERT)) \
-	    ? \
-		(void)((dst) = (src)) \
-	    : \
-		INT_SET(dst, arch, INT_GET(src, arch)) \
-    )
-
-/*
- * INT_XLATE - copy a value in either direction between two locations
- *	       with different architectures
- *
- *		    dir < 0	- copy from memory to buffer (native to arch)
- *		    dir > 0	- copy from buffer to memory (arch to native)
- */
-
-/* does not return a value */
-#define INT_XLATE(buf,mem,dir,arch) {\
-    ASSERT(dir); \
-    if (dir>0) { \
-	(mem)=INT_GET(buf, arch); \
-    } else { \
-	INT_SET(buf, arch, mem); \
-    } \
-}
-
 static inline void be16_add(__be16 *a, __s16 b)
 {
 	*a = cpu_to_be16(be16_to_cpu(*a) + b);
