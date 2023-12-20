Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675DD4777A
	for <linux-xfs@vger.kernel.org>; Wed, 20 Dec 2023 17:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oluB0Q2S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E09D9C433C7;
	Wed, 20 Dec 2023 17:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703092301;
	bh=NRvTy90fb0KkN6FPvoZYfxHW1O3HHGQxPz+TfWAXPwE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oluB0Q2SXpPQ8JGXgRyWApEFydgQU0QeIahh7ombamo0Gkh4hnVvXqzAO4HZuRIbl
	 cwptsAXrFDiSmgGvV918TLiGdNWNyMhLPjsHIfOkQ9/jS7KRwD9XUOLhAwpVN+VkjN
	 t8NS2ltZKcJBp7O7srp2KRq4AcQpKSftX94qqwUSFwoH83G+XUZ1EsooGAZWc8bwY8
	 1C4jc160yt/j/FgFIBlCksmEt3wxdVz/fiZKcqLFkui1YwJjaYa0d0+59TDXPpT2mY
	 IfToYz65fmZE9iW4b/3EGs4UIFHy03W/vXdJqoe4oOsve9uwB9DzcqcwjhiDQc0IBR
	 /rTKVPhnlg97w==
Date: Wed, 20 Dec 2023 09:11:41 -0800
Subject: [PATCH 1/5] libfrog: move 64-bit division wrappers to libfrog
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 linux-xfs@vger.kernel.org
Message-ID: <170309218377.1607770.12132572713649925666.stgit@frogsfrogsfrogs>
In-Reply-To: <170309218362.1607770.1848898546436984000.stgit@frogsfrogsfrogs>
References: <170309218362.1607770.1848898546436984000.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

We want to keep the rtgroup unit conversion functions as static inlines,
so share the div64 functions via libfrog instead of libxfs_priv.h.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chandan Babu R <chandanbabu@kernel.org>
---
 include/libxfs.h     |    1 +
 libfrog/Makefile     |    1 +
 libfrog/div64.h      |   96 ++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/libxfs_priv.h |   77 +---------------------------------------
 4 files changed, 99 insertions(+), 76 deletions(-)
 create mode 100644 libfrog/div64.h


diff --git a/include/libxfs.h b/include/libxfs.h
index b28781d1..a6a5f66f 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -18,6 +18,7 @@
 #include "kmem.h"
 #include "libfrog/radix-tree.h"
 #include "libfrog/bitmask.h"
+#include "libfrog/div64.h"
 #include "atomic.h"
 #include "spinlock.h"
 
diff --git a/libfrog/Makefile b/libfrog/Makefile
index 8cde97d4..dcfd1fb8 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -41,6 +41,7 @@ crc32cselftest.h \
 crc32defs.h \
 crc32table.h \
 dahashselftest.h \
+div64.h \
 fsgeom.h \
 logging.h \
 paths.h \
diff --git a/libfrog/div64.h b/libfrog/div64.h
new file mode 100644
index 00000000..673b01cb
--- /dev/null
+++ b/libfrog/div64.h
@@ -0,0 +1,96 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+#ifndef LIBFROG_DIV64_H_
+#define LIBFROG_DIV64_H_
+
+static inline int __do_div(unsigned long long *n, unsigned base)
+{
+	int __res;
+	__res = (int)(((unsigned long) *n) % (unsigned) base);
+	*n = ((unsigned long) *n) / (unsigned) base;
+	return __res;
+}
+
+#define do_div(n,base)	(__do_div((unsigned long long *)&(n), (base)))
+#define do_mod(a, b)		((a) % (b))
+#define rol32(x,y)		(((x) << (y)) | ((x) >> (32 - (y))))
+
+/**
+ * div_u64_rem - unsigned 64bit divide with 32bit divisor with remainder
+ * @dividend: unsigned 64bit dividend
+ * @divisor: unsigned 32bit divisor
+ * @remainder: pointer to unsigned 32bit remainder
+ *
+ * Return: sets ``*remainder``, then returns dividend / divisor
+ *
+ * This is commonly provided by 32bit archs to provide an optimized 64bit
+ * divide.
+ */
+static inline uint64_t
+div_u64_rem(uint64_t dividend, uint32_t divisor, uint32_t *remainder)
+{
+	*remainder = dividend % divisor;
+	return dividend / divisor;
+}
+
+/**
+ * div_u64 - unsigned 64bit divide with 32bit divisor
+ * @dividend: unsigned 64bit dividend
+ * @divisor: unsigned 32bit divisor
+ *
+ * This is the most common 64bit divide and should be used if possible,
+ * as many 32bit archs can optimize this variant better than a full 64bit
+ * divide.
+ */
+static inline uint64_t div_u64(uint64_t dividend, uint32_t divisor)
+{
+	uint32_t remainder;
+	return div_u64_rem(dividend, divisor, &remainder);
+}
+
+/**
+ * div64_u64_rem - unsigned 64bit divide with 64bit divisor and remainder
+ * @dividend: unsigned 64bit dividend
+ * @divisor: unsigned 64bit divisor
+ * @remainder: pointer to unsigned 64bit remainder
+ *
+ * Return: sets ``*remainder``, then returns dividend / divisor
+ */
+static inline uint64_t
+div64_u64_rem(uint64_t dividend, uint64_t divisor, uint64_t *remainder)
+{
+	*remainder = dividend % divisor;
+	return dividend / divisor;
+}
+
+static inline uint64_t rounddown_64(uint64_t x, uint32_t y)
+{
+	do_div(x, y);
+	return x * y;
+}
+
+static inline bool isaligned_64(uint64_t x, uint32_t y)
+{
+	return do_div(x, y) == 0;
+}
+
+static inline uint64_t
+roundup_64(uint64_t x, uint32_t y)
+{
+	x += y - 1;
+	do_div(x, y);
+	return x * y;
+}
+
+static inline uint64_t
+howmany_64(uint64_t x, uint32_t y)
+{
+	x += y - 1;
+	do_div(x, y);
+	return x;
+}
+
+#endif /* LIBFROG_DIV64_H_ */
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 2729241b..5a7decf9 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -48,6 +48,7 @@
 #include "kmem.h"
 #include "libfrog/radix-tree.h"
 #include "libfrog/bitmask.h"
+#include "libfrog/div64.h"
 #include "atomic.h"
 #include "spinlock.h"
 #include "linux-err.h"
@@ -215,66 +216,6 @@ static inline bool WARN_ON(bool expr) {
 	(inode)->i_version = (version);	\
 } while (0)
 
-static inline int __do_div(unsigned long long *n, unsigned base)
-{
-	int __res;
-	__res = (int)(((unsigned long) *n) % (unsigned) base);
-	*n = ((unsigned long) *n) / (unsigned) base;
-	return __res;
-}
-
-#define do_div(n,base)	(__do_div((unsigned long long *)&(n), (base)))
-#define do_mod(a, b)		((a) % (b))
-#define rol32(x,y)		(((x) << (y)) | ((x) >> (32 - (y))))
-
-/**
- * div_u64_rem - unsigned 64bit divide with 32bit divisor with remainder
- * @dividend: unsigned 64bit dividend
- * @divisor: unsigned 32bit divisor
- * @remainder: pointer to unsigned 32bit remainder
- *
- * Return: sets ``*remainder``, then returns dividend / divisor
- *
- * This is commonly provided by 32bit archs to provide an optimized 64bit
- * divide.
- */
-static inline uint64_t
-div_u64_rem(uint64_t dividend, uint32_t divisor, uint32_t *remainder)
-{
-	*remainder = dividend % divisor;
-	return dividend / divisor;
-}
-
-/**
- * div_u64 - unsigned 64bit divide with 32bit divisor
- * @dividend: unsigned 64bit dividend
- * @divisor: unsigned 32bit divisor
- *
- * This is the most common 64bit divide and should be used if possible,
- * as many 32bit archs can optimize this variant better than a full 64bit
- * divide.
- */
-static inline uint64_t div_u64(uint64_t dividend, uint32_t divisor)
-{
-	uint32_t remainder;
-	return div_u64_rem(dividend, divisor, &remainder);
-}
-
-/**
- * div64_u64_rem - unsigned 64bit divide with 64bit divisor and remainder
- * @dividend: unsigned 64bit dividend
- * @divisor: unsigned 64bit divisor
- * @remainder: pointer to unsigned 64bit remainder
- *
- * Return: sets ``*remainder``, then returns dividend / divisor
- */
-static inline uint64_t
-div64_u64_rem(uint64_t dividend, uint64_t divisor, uint64_t *remainder)
-{
-	*remainder = dividend % divisor;
-	return dividend / divisor;
-}
-
 #define min_t(type,x,y) \
 	({ type __x = (x); type __y = (y); __x < __y ? __x: __y; })
 #define max_t(type,x,y) \
@@ -380,22 +321,6 @@ roundup_pow_of_two(uint v)
 	return 0;
 }
 
-static inline uint64_t
-roundup_64(uint64_t x, uint32_t y)
-{
-	x += y - 1;
-	do_div(x, y);
-	return x * y;
-}
-
-static inline uint64_t
-howmany_64(uint64_t x, uint32_t y)
-{
-	x += y - 1;
-	do_div(x, y);
-	return x;
-}
-
 /* buffer management */
 #define XBF_TRYLOCK			0
 #define XBF_UNMAPPED			0

