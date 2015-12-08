Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BB66D7F55
	for <xfs@oss.sgi.com>; Tue,  8 Dec 2015 13:18:58 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9A584304062
	for <xfs@oss.sgi.com>; Tue,  8 Dec 2015 11:18:58 -0800 (PST)
Received: from mga01.intel.com ([192.55.52.88]) by cuda.sgi.com with ESMTP id
	bPeGF2JCArmEKS7i for <xfs@oss.sgi.com>;
	Tue, 08 Dec 2015 11:18:54 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v3 1/7] pmem: add wb_cache_pmem() to the PMEM API
Date: Tue,  8 Dec 2015 12:18:39 -0700
Message-Id: <1449602325-20572-2-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1449602325-20572-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1449602325-20572-1-git-send-email-ross.zwisler@linux.intel.com>
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
To: linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave.hansen@linux.intel.com>, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, "H. Peter Anvin" <hpa@zytor.com>, Jeff Layton <jlayton@poochiereds.net>, Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org, x86@kernel.org, Ingo Molnar <mingo@redhat.com>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, Alexander Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew.r.wilcox@intel.com>

The function __arch_wb_cache_pmem() was already an internal implementation
detail of the x86 PMEM API, but this functionality needs to be exported as
part of the general PMEM API to handle the fsync/msync case for DAX mmaps.

One thing worth noting is that we really do want this to be part of the
PMEM API as opposed to a stand-alone function like clflush_cache_range()
because of ordering restrictions.  By having wb_cache_pmem() as part of the
PMEM API we can leave it unordered, call it multiple times to write back
large amounts of memory, and then order the multiple calls with a single
wmb_pmem().

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 arch/x86/include/asm/pmem.h | 11 ++++++-----
 include/linux/pmem.h        | 22 +++++++++++++++++++++-
 2 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/pmem.h b/arch/x86/include/asm/pmem.h
index d8ce3ec..6c7ade0 100644
--- a/arch/x86/include/asm/pmem.h
+++ b/arch/x86/include/asm/pmem.h
@@ -67,18 +67,19 @@ static inline void arch_wmb_pmem(void)
 }
 
 /**
- * __arch_wb_cache_pmem - write back a cache range with CLWB
+ * arch_wb_cache_pmem - write back a cache range with CLWB
  * @vaddr:	virtual start address
  * @size:	number of bytes to write back
  *
  * Write back a cache range using the CLWB (cache line write back)
  * instruction.  This function requires explicit ordering with an
- * arch_wmb_pmem() call.  This API is internal to the x86 PMEM implementation.
+ * arch_wmb_pmem() call.
  */
-static inline void __arch_wb_cache_pmem(void *vaddr, size_t size)
+static inline void arch_wb_cache_pmem(void __pmem *addr, size_t size)
 {
 	u16 x86_clflush_size = boot_cpu_data.x86_clflush_size;
 	unsigned long clflush_mask = x86_clflush_size - 1;
+	void *vaddr = (void __force *)addr;
 	void *vend = vaddr + size;
 	void *p;
 
@@ -115,7 +116,7 @@ static inline size_t arch_copy_from_iter_pmem(void __pmem *addr, size_t bytes,
 	len = copy_from_iter_nocache(vaddr, bytes, i);
 
 	if (__iter_needs_pmem_wb(i))
-		__arch_wb_cache_pmem(vaddr, bytes);
+		arch_wb_cache_pmem(addr, bytes);
 
 	return len;
 }
@@ -138,7 +139,7 @@ static inline void arch_clear_pmem(void __pmem *addr, size_t size)
 	else
 		memset(vaddr, 0, size);
 
-	__arch_wb_cache_pmem(vaddr, size);
+	arch_wb_cache_pmem(addr, size);
 }
 
 static inline bool __arch_has_wmb_pmem(void)
diff --git a/include/linux/pmem.h b/include/linux/pmem.h
index acfea8c..7c3d11a 100644
--- a/include/linux/pmem.h
+++ b/include/linux/pmem.h
@@ -53,12 +53,18 @@ static inline void arch_clear_pmem(void __pmem *addr, size_t size)
 {
 	BUG();
 }
+
+static inline void arch_wb_cache_pmem(void __pmem *addr, size_t size)
+{
+	BUG();
+}
 #endif
 
 /*
  * Architectures that define ARCH_HAS_PMEM_API must provide
  * implementations for arch_memcpy_to_pmem(), arch_wmb_pmem(),
- * arch_copy_from_iter_pmem(), arch_clear_pmem() and arch_has_wmb_pmem().
+ * arch_copy_from_iter_pmem(), arch_clear_pmem(), arch_wb_cache_pmem()
+ * and arch_has_wmb_pmem().
  */
 static inline void memcpy_from_pmem(void *dst, void __pmem const *src, size_t size)
 {
@@ -178,4 +184,18 @@ static inline void clear_pmem(void __pmem *addr, size_t size)
 	else
 		default_clear_pmem(addr, size);
 }
+
+/**
+ * wb_cache_pmem - write back processor cache for PMEM memory range
+ * @addr:	virtual start address
+ * @size:	number of bytes to write back
+ *
+ * Write back the processor cache range starting at 'addr' for 'size' bytes.
+ * This function requires explicit ordering with a wmb_pmem() call.
+ */
+static inline void wb_cache_pmem(void __pmem *addr, size_t size)
+{
+	if (arch_has_pmem_api())
+		arch_wb_cache_pmem(addr, size);
+}
 #endif /* __PMEM_H__ */
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
