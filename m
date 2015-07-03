Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BD5917FB6
	for <xfs@oss.sgi.com>; Fri,  3 Jul 2015 05:14:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8D00B8F8050
	for <xfs@oss.sgi.com>; Fri,  3 Jul 2015 03:14:46 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id A5RBW8C3roLJH4E4 (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 03 Jul 2015 03:14:44 -0700 (PDT)
Received: from [88.128.80.19] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1ZAxzX-0002TS-5L
	for xfs@oss.sgi.com; Fri, 03 Jul 2015 10:14:44 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/13] xfsprogs: remove swab.h
Date: Fri,  3 Jul 2015 12:12:11 +0200
Message-Id: <1435918341-10128-4-git-send-email-hch@lst.de>
In-Reply-To: <1435918341-10128-1-git-send-email-hch@lst.de>
References: <1435918341-10128-1-git-send-email-hch@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

The macros in swab.h are only used to implement those in xfs_arch.h, so let's
consolidate the two headers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/Makefile      |   1 -
 include/gnukfreebsd.h |   1 -
 include/libxfs.h      |   1 -
 include/swab.h        | 194 --------------------------------------------------
 include/xfs_arch.h    | 191 +++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/crc32.c        |   1 -
 libxfs/libxfs_priv.h  |   1 -
 7 files changed, 191 insertions(+), 199 deletions(-)
 delete mode 100644 include/swab.h

diff --git a/include/Makefile b/include/Makefile
index 91b33b0..f033245 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -28,7 +28,6 @@ QAHFILES = libxfs.h \
 	list.h \
 	parent.h \
 	radix-tree.h \
-	swab.h \
 	xfs_arch.h \
 	xfs_btree_trace.h \
 	xfs_inode.h \
diff --git a/include/gnukfreebsd.h b/include/gnukfreebsd.h
index f2e1bf5..b83c144 100644
--- a/include/gnukfreebsd.h
+++ b/include/gnukfreebsd.h
@@ -31,7 +31,6 @@
 #include <ctype.h>
 #include <libgen.h>
 #include <paths.h>
-#include "xfs/swab.h"
 
 #define constpp	char * const *
 
diff --git a/include/libxfs.h b/include/libxfs.h
index ab4cc9a..eda664f 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -28,7 +28,6 @@
 #include "xfs/bitops.h"
 #include "xfs/kmem.h"
 #include "xfs/radix-tree.h"
-#include "xfs/swab.h"
 #include "xfs/atomic.h"
 
 #include "xfs/xfs_types.h"
diff --git a/include/swab.h b/include/swab.h
deleted file mode 100644
index b06346c..0000000
--- a/include/swab.h
+++ /dev/null
@@ -1,194 +0,0 @@
-#ifndef SWAB_H
-#define SWAB_H
-
-/* casts are necessary for constants, because we never know how for sure
- * how U/UL/ULL map to __u16, __u32, __u64. At least not in a portable way.
- */
-#define ___swab16(x) \
-({ \
-	__u16 __x = (x); \
-	((__u16)( \
-		(((__u16)(__x) & (__u16)0x00ffU) << 8) | \
-		(((__u16)(__x) & (__u16)0xff00U) >> 8) )); \
-})
-
-#define ___swab32(x) \
-({ \
-	__u32 __x = (x); \
-	((__u32)( \
-		(((__u32)(__x) & (__u32)0x000000ffUL) << 24) | \
-		(((__u32)(__x) & (__u32)0x0000ff00UL) <<  8) | \
-		(((__u32)(__x) & (__u32)0x00ff0000UL) >>  8) | \
-		(((__u32)(__x) & (__u32)0xff000000UL) >> 24) )); \
-})
-
-#define ___swab64(x) \
-({ \
-	__u64 __x = (x); \
-	((__u64)( \
-		(__u64)(((__u64)(__x) & (__u64)0x00000000000000ffULL) << 56) | \
-		(__u64)(((__u64)(__x) & (__u64)0x000000000000ff00ULL) << 40) | \
-		(__u64)(((__u64)(__x) & (__u64)0x0000000000ff0000ULL) << 24) | \
-		(__u64)(((__u64)(__x) & (__u64)0x00000000ff000000ULL) <<  8) | \
-		(__u64)(((__u64)(__x) & (__u64)0x000000ff00000000ULL) >>  8) | \
-		(__u64)(((__u64)(__x) & (__u64)0x0000ff0000000000ULL) >> 24) | \
-		(__u64)(((__u64)(__x) & (__u64)0x00ff000000000000ULL) >> 40) | \
-		(__u64)(((__u64)(__x) & (__u64)0xff00000000000000ULL) >> 56) )); \
-})
-
-#define ___constant_swab16(x) \
-	((__u16)( \
-		(((__u16)(x) & (__u16)0x00ffU) << 8) | \
-		(((__u16)(x) & (__u16)0xff00U) >> 8) ))
-#define ___constant_swab32(x) \
-	((__u32)( \
-		(((__u32)(x) & (__u32)0x000000ffUL) << 24) | \
-		(((__u32)(x) & (__u32)0x0000ff00UL) <<  8) | \
-		(((__u32)(x) & (__u32)0x00ff0000UL) >>  8) | \
-		(((__u32)(x) & (__u32)0xff000000UL) >> 24) ))
-#define ___constant_swab64(x) \
-	((__u64)( \
-		(__u64)(((__u64)(x) & (__u64)0x00000000000000ffULL) << 56) | \
-		(__u64)(((__u64)(x) & (__u64)0x000000000000ff00ULL) << 40) | \
-		(__u64)(((__u64)(x) & (__u64)0x0000000000ff0000ULL) << 24) | \
-		(__u64)(((__u64)(x) & (__u64)0x00000000ff000000ULL) <<  8) | \
-		(__u64)(((__u64)(x) & (__u64)0x000000ff00000000ULL) >>  8) | \
-		(__u64)(((__u64)(x) & (__u64)0x0000ff0000000000ULL) >> 24) | \
-		(__u64)(((__u64)(x) & (__u64)0x00ff000000000000ULL) >> 40) | \
-		(__u64)(((__u64)(x) & (__u64)0xff00000000000000ULL) >> 56) ))
-
-/*
- * provide defaults when no architecture-specific optimization is detected
- */
-#ifndef __arch__swab16
-#  define __arch__swab16(x) ({ __u16 __tmp = (x) ; ___swab16(__tmp); })
-#endif
-#ifndef __arch__swab32
-#  define __arch__swab32(x) ({ __u32 __tmp = (x) ; ___swab32(__tmp); })
-#endif
-#ifndef __arch__swab64
-#  define __arch__swab64(x) ({ __u64 __tmp = (x) ; ___swab64(__tmp); })
-#endif
-
-#ifndef __arch__swab16p
-#  define __arch__swab16p(x) __arch__swab16(*(x))
-#endif
-#ifndef __arch__swab32p
-#  define __arch__swab32p(x) __arch__swab32(*(x))
-#endif
-#ifndef __arch__swab64p
-#  define __arch__swab64p(x) __arch__swab64(*(x))
-#endif
-
-#ifndef __arch__swab16s
-#  define __arch__swab16s(x) do { *(x) = __arch__swab16p((x)); } while (0)
-#endif
-#ifndef __arch__swab32s
-#  define __arch__swab32s(x) do { *(x) = __arch__swab32p((x)); } while (0)
-#endif
-#ifndef __arch__swab64s
-#  define __arch__swab64s(x) do { *(x) = __arch__swab64p((x)); } while (0)
-#endif
-
-
-/*
- * Allow constant folding
- */
-#  define __swab16(x) \
-(__builtin_constant_p((__u16)(x)) ? \
- ___constant_swab16((x)) : \
- __fswab16((x)))
-#  define __swab32(x) \
-(__builtin_constant_p((__u32)(x)) ? \
- ___constant_swab32((x)) : \
- __fswab32((x)))
-#  define __swab64(x) \
-(__builtin_constant_p((__u64)(x)) ? \
- ___constant_swab64((x)) : \
- __fswab64((x)))
-
-
-static __inline__ __u16 __fswab16(__u16 x)
-{
-	return (__extension__ __arch__swab16(x));
-}
-static __inline__ __u16 __swab16p(__u16 *x)
-{
-	return (__extension__ __arch__swab16p(x));
-}
-static __inline__ void __swab16s(__u16 *addr)
-{
-	(__extension__ ({__arch__swab16s(addr);}));
-}
-
-static __inline__ __u32 __fswab32(__u32 x)
-{
-	return (__extension__ __arch__swab32(x));
-}
-static __inline__ __u32 __swab32p(__u32 *x)
-{
-	return (__extension__ __arch__swab32p(x));
-}
-static __inline__ void __swab32s(__u32 *addr)
-{
-	(__extension__ ({__arch__swab32s(addr);}));
-}
-
-static __inline__ __u64 __fswab64(__u64 x)
-{
-#  ifdef __SWAB_64_THRU_32__
-	__u32 h = x >> 32;
-	__u32 l = x & ((1ULL<<32)-1);
-	return (((__u64)__swab32(l)) << 32) | ((__u64)(__swab32(h)));
-#  else
-	return (__extension__ __arch__swab64(x));
-#  endif
-}
-static __inline__ __u64 __swab64p(__u64 *x)
-{
-	return (__extension__ __arch__swab64p(x));
-}
-static __inline__ void __swab64s(__u64 *addr)
-{
-	(__extension__ ({__arch__swab64s(addr);}));
-}
-
-static inline __uint16_t get_unaligned_be16(void *p)
-{
-	__uint8_t *__p = p;
-	return __p[0] << 8 | __p[1];
-}
-
-static inline __uint32_t get_unaligned_be32(void *p)
-{
-	__uint8_t *__p = p;
-        return __p[0] << 24 | __p[1] << 16 | __p[2] << 8 | __p[3];
-}
-
-static inline __uint64_t get_unaligned_be64(void *p)
-{
-	return (__uint64_t)get_unaligned_be32(p) << 32 |
-			   get_unaligned_be32(p + 4);
-}
-
-static inline void put_unaligned_be16(__uint16_t val, void *p)
-{
-	__uint8_t *__p = p;
-	*__p++ = val >> 8;
-	*__p++ = val;
-}
-
-static inline void put_unaligned_be32(__uint32_t val, void *p)
-{
-	__uint8_t *__p = p;
-	put_unaligned_be16(val >> 16, __p);
-	put_unaligned_be16(val, __p + 2);
-}
-
-static inline void put_unaligned_be64(__uint64_t val, void *p)
-{
-	put_unaligned_be32(val >> 32, p);
-	put_unaligned_be32(val, p + 4);
-}
-
-#endif /* SWAB_H */
diff --git a/include/xfs_arch.h b/include/xfs_arch.h
index 903b02a..310a17e 100644
--- a/include/xfs_arch.h
+++ b/include/xfs_arch.h
@@ -24,6 +24,159 @@
 #undef XFS_NATIVE_HOST
 #endif
 
+/*
+ * Casts are necessary for constants, because we never know how for sure
+ * how U/UL/ULL map to __u16, __u32, __u64. At least not in a portable way.
+ */
+#define ___swab16(x) \
+({ \
+	__u16 __x = (x); \
+	((__u16)( \
+		(((__u16)(__x) & (__u16)0x00ffU) << 8) | \
+		(((__u16)(__x) & (__u16)0xff00U) >> 8) )); \
+})
+
+#define ___swab32(x) \
+({ \
+	__u32 __x = (x); \
+	((__u32)( \
+		(((__u32)(__x) & (__u32)0x000000ffUL) << 24) | \
+		(((__u32)(__x) & (__u32)0x0000ff00UL) <<  8) | \
+		(((__u32)(__x) & (__u32)0x00ff0000UL) >>  8) | \
+		(((__u32)(__x) & (__u32)0xff000000UL) >> 24) )); \
+})
+
+#define ___swab64(x) \
+({ \
+	__u64 __x = (x); \
+	((__u64)( \
+		(__u64)(((__u64)(__x) & (__u64)0x00000000000000ffULL) << 56) | \
+		(__u64)(((__u64)(__x) & (__u64)0x000000000000ff00ULL) << 40) | \
+		(__u64)(((__u64)(__x) & (__u64)0x0000000000ff0000ULL) << 24) | \
+		(__u64)(((__u64)(__x) & (__u64)0x00000000ff000000ULL) <<  8) | \
+		(__u64)(((__u64)(__x) & (__u64)0x000000ff00000000ULL) >>  8) | \
+		(__u64)(((__u64)(__x) & (__u64)0x0000ff0000000000ULL) >> 24) | \
+		(__u64)(((__u64)(__x) & (__u64)0x00ff000000000000ULL) >> 40) | \
+		(__u64)(((__u64)(__x) & (__u64)0xff00000000000000ULL) >> 56) )); \
+})
+
+#define ___constant_swab16(x) \
+	((__u16)( \
+		(((__u16)(x) & (__u16)0x00ffU) << 8) | \
+		(((__u16)(x) & (__u16)0xff00U) >> 8) ))
+#define ___constant_swab32(x) \
+	((__u32)( \
+		(((__u32)(x) & (__u32)0x000000ffUL) << 24) | \
+		(((__u32)(x) & (__u32)0x0000ff00UL) <<  8) | \
+		(((__u32)(x) & (__u32)0x00ff0000UL) >>  8) | \
+		(((__u32)(x) & (__u32)0xff000000UL) >> 24) ))
+#define ___constant_swab64(x) \
+	((__u64)( \
+		(__u64)(((__u64)(x) & (__u64)0x00000000000000ffULL) << 56) | \
+		(__u64)(((__u64)(x) & (__u64)0x000000000000ff00ULL) << 40) | \
+		(__u64)(((__u64)(x) & (__u64)0x0000000000ff0000ULL) << 24) | \
+		(__u64)(((__u64)(x) & (__u64)0x00000000ff000000ULL) <<  8) | \
+		(__u64)(((__u64)(x) & (__u64)0x000000ff00000000ULL) >>  8) | \
+		(__u64)(((__u64)(x) & (__u64)0x0000ff0000000000ULL) >> 24) | \
+		(__u64)(((__u64)(x) & (__u64)0x00ff000000000000ULL) >> 40) | \
+		(__u64)(((__u64)(x) & (__u64)0xff00000000000000ULL) >> 56) ))
+
+/*
+ * provide defaults when no architecture-specific optimization is detected
+ */
+#ifndef __arch__swab16
+#  define __arch__swab16(x) ({ __u16 __tmp = (x) ; ___swab16(__tmp); })
+#endif
+#ifndef __arch__swab32
+#  define __arch__swab32(x) ({ __u32 __tmp = (x) ; ___swab32(__tmp); })
+#endif
+#ifndef __arch__swab64
+#  define __arch__swab64(x) ({ __u64 __tmp = (x) ; ___swab64(__tmp); })
+#endif
+
+#ifndef __arch__swab16p
+#  define __arch__swab16p(x) __arch__swab16(*(x))
+#endif
+#ifndef __arch__swab32p
+#  define __arch__swab32p(x) __arch__swab32(*(x))
+#endif
+#ifndef __arch__swab64p
+#  define __arch__swab64p(x) __arch__swab64(*(x))
+#endif
+
+#ifndef __arch__swab16s
+#  define __arch__swab16s(x) do { *(x) = __arch__swab16p((x)); } while (0)
+#endif
+#ifndef __arch__swab32s
+#  define __arch__swab32s(x) do { *(x) = __arch__swab32p((x)); } while (0)
+#endif
+#ifndef __arch__swab64s
+#  define __arch__swab64s(x) do { *(x) = __arch__swab64p((x)); } while (0)
+#endif
+
+
+/*
+ * Allow constant folding
+ */
+#  define __swab16(x) \
+(__builtin_constant_p((__u16)(x)) ? \
+ ___constant_swab16((x)) : \
+ __fswab16((x)))
+#  define __swab32(x) \
+(__builtin_constant_p((__u32)(x)) ? \
+ ___constant_swab32((x)) : \
+ __fswab32((x)))
+#  define __swab64(x) \
+(__builtin_constant_p((__u64)(x)) ? \
+ ___constant_swab64((x)) : \
+ __fswab64((x)))
+
+
+static __inline__ __u16 __fswab16(__u16 x)
+{
+	return (__extension__ __arch__swab16(x));
+}
+static __inline__ __u16 __swab16p(__u16 *x)
+{
+	return (__extension__ __arch__swab16p(x));
+}
+static __inline__ void __swab16s(__u16 *addr)
+{
+	(__extension__ ({__arch__swab16s(addr);}));
+}
+
+static __inline__ __u32 __fswab32(__u32 x)
+{
+	return (__extension__ __arch__swab32(x));
+}
+static __inline__ __u32 __swab32p(__u32 *x)
+{
+	return (__extension__ __arch__swab32p(x));
+}
+static __inline__ void __swab32s(__u32 *addr)
+{
+	(__extension__ ({__arch__swab32s(addr);}));
+}
+
+static __inline__ __u64 __fswab64(__u64 x)
+{
+#  ifdef __SWAB_64_THRU_32__
+	__u32 h = x >> 32;
+	__u32 l = x & ((1ULL<<32)-1);
+	return (((__u64)__swab32(l)) << 32) | ((__u64)(__swab32(h)));
+#  else
+	return (__extension__ __arch__swab64(x));
+#  endif
+}
+static __inline__ __u64 __swab64p(__u64 *x)
+{
+	return (__extension__ __arch__swab64p(x));
+}
+static __inline__ void __swab64s(__u64 *addr)
+{
+	(__extension__ ({__arch__swab64s(addr);}));
+}
+
 #ifdef XFS_NATIVE_HOST
 #define cpu_to_be16(val)	((__force __be16)(__u16)(val))
 #define cpu_to_be32(val)	((__force __be32)(__u32)(val))
@@ -71,4 +224,42 @@ static inline void be64_add_cpu(__be64 *a, __s64 b)
 	*a = cpu_to_be64(be64_to_cpu(*a) + b);
 }
 
+static inline __uint16_t get_unaligned_be16(void *p)
+{
+	__uint8_t *__p = p;
+	return __p[0] << 8 | __p[1];
+}
+
+static inline __uint32_t get_unaligned_be32(void *p)
+{
+	__uint8_t *__p = p;
+        return __p[0] << 24 | __p[1] << 16 | __p[2] << 8 | __p[3];
+}
+
+static inline __uint64_t get_unaligned_be64(void *p)
+{
+	return (__uint64_t)get_unaligned_be32(p) << 32 |
+			   get_unaligned_be32(p + 4);
+}
+
+static inline void put_unaligned_be16(__uint16_t val, void *p)
+{
+	__uint8_t *__p = p;
+	*__p++ = val >> 8;
+	*__p++ = val;
+}
+
+static inline void put_unaligned_be32(__uint32_t val, void *p)
+{
+	__uint8_t *__p = p;
+	put_unaligned_be16(val >> 16, __p);
+	put_unaligned_be16(val, __p + 2);
+}
+
+static inline void put_unaligned_be64(__uint64_t val, void *p)
+{
+	put_unaligned_be32(val >> 32, p);
+	put_unaligned_be32(val, p + 4);
+}
+
 #endif	/* __XFS_ARCH_H__ */
diff --git a/libxfs/crc32.c b/libxfs/crc32.c
index bc1fc98..63b1467 100644
--- a/libxfs/crc32.c
+++ b/libxfs/crc32.c
@@ -34,7 +34,6 @@
  */
 
 #include "xfs/platform_defs.h"
-#include "xfs/swab.h"
 #include "xfs/xfs_arch.h"
 #include "crc32defs.h"
 
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 72e124b..445a6dc 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -66,7 +66,6 @@
 #include "xfs/bitops.h"
 #include "xfs/kmem.h"
 #include "xfs/radix-tree.h"
-#include "xfs/swab.h"
 #include "xfs/atomic.h"
 
 #include "xfs/xfs_types.h"
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
