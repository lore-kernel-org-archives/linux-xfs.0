Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41497 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754593AbdEMTdu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 13 May 2017 15:33:50 -0400
Date: Sat, 13 May 2017 12:33:44 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] libxfs: use crc32c slice-by-8 variant by default
Message-ID: <20170513193344.GK4519@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

The crc32c code used in xfsprogs was copied directly from the Linux
kernel.  However, that code selects slice-by-4 by default, which isn't
the fastest -- that's slice-by-8, which trades table size for speed.
Fix some makefile dependency problems and explicitly select the
algorithm we want.  With this patch applied, I see about a 10% drop in
CPU time running xfs_repair.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/Makefile    |    4 ++--
 libxfs/crc32defs.h |    3 +++
 2 files changed, 5 insertions(+), 2 deletions(-)

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
index 64cba2c..153f44c 100644
--- a/libxfs/crc32defs.h
+++ b/libxfs/crc32defs.h
@@ -1,3 +1,6 @@
+/* Use slice-by-8, which is the fastest variant. */
+# define CRC_LE_BITS 64
+
 /*
  * There are multiple 16-bit CRC polynomials in common use, but this is
  * *the* standard CRC-32 polynomial, first popularized by Ethernet.
