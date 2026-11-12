Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.126.103.232
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794457007;
	b=pLwLXgECWdwSPAlfzijTZOY16AgzOcw7pgMwCUtMbit8tTrF/kxgVKJzzYqBE2RqlD1I
	 vuPCcTD0xOidNxaojtMdz3kh+aCmkvVe2ejKcEEdtjFRH3UM8PnJsCaKw+b+YLBfv3i4n
	 ddGY4+gtXpYgZvUx8BIadBLXz4F6dLnj857q3+NtPVreLcgcCu0DMWoNweli065c/nYdu
	 tGm2ymnXNyXOdd1QZF/5nJ8K5ed/OBJemIDbveswlZf2p9IYr4rGKjAVwFMwCY6j6cB+T
	 WPSgHZzVKWFKERFhRIHjlkiXya/ChC6SkdYKA0AEus1RyVo5cxyh9TCqspPQX8ubXNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794457007;
	h=DMARC-Filter:X-UUID:X-CID-P-RULE:X-CID-O-INFO:X-CID-META:X-CID-BVR:
	 X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:X-User:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=BsZO+1RVeH5doFwoTRD/KHs/F2eep1D1rYS1LfvymNY=;
	b=Zw6oOoaqzzhYjILTd5y9Rw7IvDRJfzL41p7MJ9+Eq7qxjK4xFnF++5mcmp1qYkpk7lF4
	 SnzCxDAe+4tJBz5Gtfr+zFVB99webZSXCRYQoYMm87H9AVeiUMz30j/Y8c8XPQWQhrlSY
	 alNdzZn8k2rMTLme74lti6VhDAQK0oL/wxIgmj9wjcsh6A8HNW/JS82KaticdG9/aniwm
	 W+0zhiOK4dAC3WmL1E1wBWMAC21Kq1lSaQL5z3pMG67oQMzyMifWSTtEdR+9G/X3qYtNp
	 7Ij2rNJcTJUOQ+sUekhCfhs1vID4JWtO6y8VRv6tlbyGn+i1OiJP0W8IIe1VDthrsKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=kylinos.cn;
	arc=none smtp.remote-ip=124.126.103.232
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3B6606A32A;
	Thu, 12 Nov 2026 04:16:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6E3B6606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: d8ccc794de4f11f19a56ed5b684f684d-20261112
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:2937a81e-9cf4-4ff5-849f-96d17cfbb508,IP:0,U
	RL:0,TC:0,Content:-25,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:c01ab926920651db921389c469eedcd0,BulkI
	D:nil,BulkQuantity:0,SF:102|850|865|898,TC:nil,Content:0|15|50|99,EDM:5,IP
	:nil,URL:1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,
	LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d8ccc794de4f11f19a56ed5b684f684d-20261112
X-User: wangyibo@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <wangyibo@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1935902012; Thu, 12 Nov 2026 12:16:34 +0800
From: Wang Yibo <wangyibo@kylinos.cn>
To: arlos Maiolino <cem@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: convert the dahash test to KUnit
Date: Thu, 12 Nov 2026 12:16:31 +0800
Message-Id: <20261112041631.2792545-1-wangyibo@kylinos.cn>
X-Mailer: git-send-email 2.25.1
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs_dahash_test() runs from init_xfs_fs() and only counts mismatches: a
failure prints a single total, which says nothing about which test
vector or which of the two hash functions was wrong, and the test can
only be exercised by building XFS into the kernel and watching the
console at boot.

Report the vectors through KUnit instead.  Split them into one case per
hash function so that a failure names both the function and the vector
index, and KUnit prints the expected and actual values next to it.  The
results then come out in TAP format, so the suite can be run with
kunit.py or under QEMU without rebooting the machine, and every case is
reported on its own.

Put the test behind CONFIG_XFS_DAHASH_KUNIT_TEST so that it is no
longer built into every kernel, and drop the now unused header.  The
vector table and test_buf can no longer live in __initdata, because
KUnit keeps the data around for the lifetime of the suite; mark them
const since nothing writes to them.

No change to the hash functions themselves.

Signed-off-by: Wang Yibo <wangyibo@kylinos.cn>
---
 fs/xfs/Kconfig           | 14 +++++++++
 fs/xfs/Makefile          |  2 +-
 fs/xfs/xfs_dahash_test.c | 64 ++++++++++++++++++++++++----------------
 fs/xfs/xfs_dahash_test.h | 12 --------
 fs/xfs/xfs_super.c       |  5 ----
 5 files changed, 54 insertions(+), 43 deletions(-)
 delete mode 100644 fs/xfs/xfs_dahash_test.h

diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index b99da294e9a3..5b36adea933b 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -241,3 +241,17 @@ config XFS_ASSERT_FATAL
 	  result in warnings.
 
 	  This behavior can be modified at runtime via sysfs.
+
+config XFS_DAHASH_KUNIT_TEST
+	bool "KUnit tests for XFS dir/attr name hashes" if !KUNIT_ALL_TESTS
+	depends on XFS_FS && KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  This builds the XFS directory and attribute name hash KUnit test.
+
+	  KUnit tests run during boot (or module load) and output the results
+	  to the debug log in TAP format (https://testanything.org/).  Only
+	  useful for kernel devs running the KUnit test harness and are not
+	  for inclusion into a production build.
+
+	  If unsure, say N.
diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 399a207f2d0e..c95a57c5ca98 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -74,7 +74,6 @@ xfs-y				+= xfs_aops.o \
 				   xfs_bmap_util.o \
 				   xfs_bio_io.o \
 				   xfs_buf.o \
-				   xfs_dahash_test.o \
 				   xfs_dir2_readdir.o \
 				   xfs_discard.o \
 				   xfs_error.o \
@@ -160,6 +159,7 @@ xfs-$(CONFIG_XFS_DRAIN_INTENTS)	+= xfs_drain.o
 xfs-$(CONFIG_XFS_LIVE_HOOKS)	+= xfs_hooks.o
 xfs-$(CONFIG_XFS_MEMORY_BUFS)	+= xfs_buf_mem.o
 xfs-$(CONFIG_XFS_BTREE_IN_MEM)	+= libxfs/xfs_btree_mem.o
+xfs-$(CONFIG_XFS_DAHASH_KUNIT_TEST)	+= xfs_dahash_test.o
 
 # online scrub/repair
 ifeq ($(CONFIG_XFS_ONLINE_SCRUB),y)
diff --git a/fs/xfs/xfs_dahash_test.c b/fs/xfs/xfs_dahash_test.c
index f1ee2643b948..4c7d7e12f1ba 100644
--- a/fs/xfs/xfs_dahash_test.c
+++ b/fs/xfs/xfs_dahash_test.c
@@ -1,8 +1,11 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
+ * KUnit tests for XFS dir/attr name hash functions.
+ *
  * Copyright (C) 2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
+#include <kunit/test.h>
 #include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
@@ -12,10 +15,9 @@
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
 #include "xfs_dir2_priv.h"
-#include "xfs_dahash_test.h"
 
 /* 4096 random bytes */
-static uint8_t __initdata __attribute__((__aligned__(8))) test_buf[] =
+static const uint8_t test_buf[] __aligned(8) =
 {
 	0x5b, 0x85, 0x21, 0xcb, 0x09, 0x68, 0x7d, 0x30,
 	0xc7, 0x69, 0xd7, 0x30, 0x92, 0xde, 0x59, 0xe4,
@@ -532,12 +534,12 @@ static uint8_t __initdata __attribute__((__aligned__(8))) test_buf[] =
 };
 
 /* 100 test cases */
-static struct dahash_test {
+static const struct dahash_test {
 	uint16_t	start;	/* random 12 bit offset in buf */
 	uint16_t	length;	/* random 8 bit length of test */
 	xfs_dahash_t	dahash;	/* expected dahash result */
 	xfs_dahash_t	ascii_ci_dahash; /* expected ascii-ci dahash result */
-} test[] __initdata =
+} dahash_test_vecs[] =
 {
 	{0x0567, 0x0097, 0x96951389, 0xc153aa0d},
 	{0x0869, 0x0055, 0x6455ab4f, 0xd07f69bf},
@@ -641,33 +643,45 @@ static struct dahash_test {
 	{0x05b5, 0x00da, 0x8e52f0e2, 0x98531012},
 };
 
-int __init
-xfs_dahash_test(void)
+static void xfs_da_hashname_case(struct kunit *test)
 {
 	unsigned int	i;
-	unsigned int	errors = 0;
 
-	for (i = 0; i < ARRAY_SIZE(test); i++) {
-		struct xfs_name	xname = { };
-		xfs_dahash_t	hash;
+	for (i = 0; i < ARRAY_SIZE(dahash_test_vecs); i++) {
+		const struct dahash_test	*tv = &dahash_test_vecs[i];
+		xfs_dahash_t			hash;
 
-		hash = xfs_da_hashname(test_buf + test[i].start,
-				test[i].length);
-		if (hash != test[i].dahash)
-			errors++;
+		hash = xfs_da_hashname(test_buf + tv->start, tv->length);
+		KUNIT_EXPECT_EQ_MSG(test, hash, tv->dahash, "case %u", i);
+	}
+}
+
+static void xfs_ascii_ci_hashname_case(struct kunit *test)
+{
+	unsigned int	i;
+
+	for (i = 0; i < ARRAY_SIZE(dahash_test_vecs); i++) {
+		const struct dahash_test	*tv = &dahash_test_vecs[i];
+		struct xfs_name			xname = { };
+		xfs_dahash_t			hash;
 
-		xname.name = test_buf + test[i].start;
-		xname.len = test[i].length;
+		xname.name = test_buf + tv->start;
+		xname.len = tv->length;
 		hash = xfs_ascii_ci_hashname(&xname);
-		if (hash != test[i].ascii_ci_dahash)
-			errors++;
+		KUNIT_EXPECT_EQ_MSG(test, hash, tv->ascii_ci_dahash,
+				    "case %u", i);
 	}
+}
 
-	if (errors) {
-		printk(KERN_ERR "xfs dir/attr hash test failed %u times!",
-				errors);
-		return -ERANGE;
-	}
+static struct kunit_case xfs_dahash_test_cases[] = {
+	KUNIT_CASE(xfs_da_hashname_case),
+	KUNIT_CASE(xfs_ascii_ci_hashname_case),
+	{}
+};
 
-	return 0;
-}
+static struct kunit_suite xfs_dahash_test_suite = {
+	.name = "xfs_dahash",
+	.test_cases = xfs_dahash_test_cases,
+};
+
+kunit_test_suites(&xfs_dahash_test_suite);
diff --git a/fs/xfs/xfs_dahash_test.h b/fs/xfs/xfs_dahash_test.h
deleted file mode 100644
index 1a05bf4bd9e1..000000000000
--- a/fs/xfs/xfs_dahash_test.h
+++ /dev/null
@@ -1,12 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * Copyright (C) 2023 Oracle.  All Rights Reserved.
- * Author: Darrick J. Wong <djwong@kernel.org>
- */
-#ifndef __XFS_DAHASH_TEST_H__
-#define __XFS_DAHASH_TEST_H__
-
-int xfs_dahash_test(void);
-
-#endif /* __XFS_DAHASH_TEST_H__ */
-
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 5a06132aa384..75bc05801e4a 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -43,7 +43,6 @@
 #include "xfs_error.h"
 #include "xfs_errortag.h"
 #include "xfs_iunlink_item.h"
-#include "xfs_dahash_test.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_exchmaps_item.h"
 #include "xfs_parent.h"
@@ -2647,10 +2646,6 @@ init_xfs_fs(void)
 
 	xfs_check_ondisk_structs();
 
-	error = xfs_dahash_test();
-	if (error)
-		return error;
-
 	printk(KERN_INFO XFS_VERSION_STRING " with "
 			 XFS_BUILD_OPTIONS " enabled\n");
 
-- 
2.25.1

