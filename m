Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47506 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751314AbdEOQXP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 May 2017 12:23:15 -0400
Date: Mon, 15 May 2017 09:23:08 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2] libxfs: use crc32c slice-by-8 variant by default
Message-ID: <20170515162308.GN4519@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, xfs <linux-xfs@vger.kernel.org>

The crc32c code used in xfsprogs was copied directly from the Linux
kernel.  However, that code selects slice-by-4 by default, which isn't
the fastest -- that's slice-by-8, which trades table size for speed.
Fix some makefile dependency problems and explicitly select the
algorithm we want.  With this patch applied, I see about a 10% drop in
CPU time running xfs_repair.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/Makefile    |    4 ++--
 libxfs/crc32defs.h |   34 ++++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/libxfs/Makefile b/libxfs/Makefile
index 0f3759e..c5dc382 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -124,7 +124,7 @@ LDIRT = gen_crc32table crc32table.h crc32selftest
 
 default: crc32selftest ltdepend $(LTLIBRARY)
 
-crc32table.h: gen_crc32table.c
+crc32table.h: gen_crc32table.c crc32defs.h
 	@echo "    [CC]     gen_crc32table"
 	$(Q) $(BUILD_CC) $(BUILD_CFLAGS) -o gen_crc32table $<
 	@echo "    [GENERATE] $@"
@@ -135,7 +135,7 @@ crc32table.h: gen_crc32table.c
 # systems/architectures. Hence we make sure that xfsprogs will never use a
 # busted CRC calculation at build time and hence avoid putting bad CRCs down on
 # disk.
-crc32selftest: gen_crc32table.c crc32table.h crc32.c
+crc32selftest: gen_crc32table.c crc32table.h crc32.c crc32defs.h
 	@echo "    [TEST]    CRC32"
 	$(Q) $(BUILD_CC) $(BUILD_CFLAGS) -D CRC32_SELFTEST=1 crc32.c -o $@
 	$(Q) ./$@
diff --git a/libxfs/crc32defs.h b/libxfs/crc32defs.h
index 64cba2c..2999782 100644
--- a/libxfs/crc32defs.h
+++ b/libxfs/crc32defs.h
@@ -1,4 +1,38 @@
 /*
+ * Use slice-by-8, which is the fastest variant.
+ *
+ * Calculate checksum 8 bytes at a time with a clever slicing algorithm.
+ * This is the fastest algorithm, but comes with a 8KiB lookup table.
+ * Most modern processors have enough cache to hold this table without
+ * thrashing the cache.
+ *
+ * The Linux kernel uses this as the default implementation "unless you
+ * have a good reason not to".  The reason why Kconfig urges you to pick
+ * SLICEBY8 is because people challenged the assertion that we should
+ * always use slice by 8, so Darrick wrote a crc microbenchmark utility
+ * and ran it on as many machines as he could get his hands on to show
+ * that sb8 was the fastest.
+ *
+ * Every 64-bit machine (and most of the 32-bit ones too) saw the best
+ * results with sb8.  Any machine with more than 4K of cache saw better
+ * results.  The spreadsheet still exists today[1]; note that
+ * 'crc32-kern-le' corresponds to the slice by 4 algorithm which is the
+ * default unless CRC_LE_BITS is defined explicitly.
+ *
+ * FWIW, there are a handful of board defconfigs in the kernel that
+ * don't pick sliceby8.  These are all embedded 32-bit mips/ppc systems
+ * with very small cache sizes which experience cache thrashing with the
+ * slice by 8 algorithm, and therefore chose to pick defaults that are
+ * saner for their particular board configuration.  For nearly all of
+ * XFS' perceived userbase (which we assume are 32 and 64-bit machines
+ * with sufficiently large CPU cache and largeish storage devices) slice
+ * by 8 is the right choice.
+ *
+ * [1] https://goo.gl/0LSzsG ("crc32c_bench")
+ */
+#define CRC_LE_BITS 64
+
+/*
  * There are multiple 16-bit CRC polynomials in common use, but this is
  * *the* standard CRC-32 polynomial, first popularized by Ethernet.
  * x^32+x^26+x^23+x^22+x^16+x^12+x^11+x^10+x^8+x^7+x^5+x^4+x^2+x^1+x^0
