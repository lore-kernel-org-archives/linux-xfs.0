Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DF75C636D7
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:10:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbjBPVK5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:10:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230221AbjBPVKy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:10:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 679E653803
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:10:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E634C60C71
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:10:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F862C433EF;
        Thu, 16 Feb 2023 21:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581843;
        bh=9gJZbMMW5ZJIJR8UmSRWis5M/4CKpyvfvQXBrlSzWak=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=kqPMr2Umpd8FgldW5h0jQZ6OKSSK0Jrp4YrIQUTQu65sv8/KUbsdtGYzyvLraMsLB
         xqe1jzpE/UqLFmHCidvKB3O1xslqOmthDxxf4CteXre5A4pEvHOymYtz+1hPNJ7FJt
         KYSKs1tbMYUVxuivtT+GSAEBQaD0+YZyDBaChfBmCOmzafPWtKNZjyGTgFpFFjvhKP
         X47yIiPG2tB5yOOpxRf7O/H3/I4JPMd3/e+navwOYn4hSM94GSWehvbLHlqymxYJYG
         340+ek6DSm09iJ+mPBvxfZ/sG00RfvUXOpVeQNAeXQTVPC5Fvc+CTPgM1V3EdR71Nz
         gBDsKii9h0iqA==
Date:   Thu, 16 Feb 2023 13:10:42 -0800
Subject: [PATCH 1/6] libfrog: support the sha512 hash algorithm
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657882386.3478037.16358738957215343985.stgit@magnolia>
In-Reply-To: <167657882371.3478037.12485693506644718323.stgit@magnolia>
References: <167657882371.3478037.12485693506644718323.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add a generic implementation of this hash algorithm.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/libxfs.h         |    1 
 io/crc32cselftest.c      |   22 ++++
 libfrog/Makefile         |   10 +-
 libfrog/sha512.c         |  249 ++++++++++++++++++++++++++++++++++++++++++++++
 libfrog/sha512.h         |   33 ++++++
 libfrog/sha512selftest.h |   86 ++++++++++++++++
 man/man8/xfs_io.8        |    4 +
 mkfs/xfs_mkfs.c          |    8 +
 repair/init.c            |    5 +
 9 files changed, 416 insertions(+), 2 deletions(-)
 create mode 100644 libfrog/sha512.c
 create mode 100644 libfrog/sha512.h
 create mode 100644 libfrog/sha512selftest.h


diff --git a/include/libxfs.h b/include/libxfs.h
index a38d78a1..23756f27 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -38,6 +38,7 @@ extern uint32_t crc32c_le(uint32_t crc, unsigned char const *p, size_t len);
 /* fake up kernel's iomap, (not) used in xfs_bmap.[ch] */
 struct iomap;
 #include "xfs_cksum.h"
+#include "libfrog/sha512.h"
 
 #define __round_mask(x, y) ((__typeof__(x))((y)-1))
 #define round_up(x, y) ((((x)-1) | __round_mask(x, y))+1)
diff --git a/io/crc32cselftest.c b/io/crc32cselftest.c
index 49eb5b6d..ebef6fe0 100644
--- a/io/crc32cselftest.c
+++ b/io/crc32cselftest.c
@@ -10,6 +10,8 @@
 #include "io.h"
 #include "libfrog/crc32c.h"
 #include "libfrog/crc32cselftest.h"
+#include "libfrog/sha512.h"
+#include "libfrog/sha512selftest.h"
 
 static int
 crc32cselftest_f(
@@ -30,8 +32,28 @@ static const cmdinfo_t	crc32cselftest_cmd = {
 	.oneline	= N_("self test of crc32c implementation"),
 };
 
+static int
+sha512selftest_f(
+	int		argc,
+	char		**argv)
+{
+	return sha512_test(0) != 0;
+}
+
+static const cmdinfo_t	sha512selftest_cmd = {
+	.name		= "sha512selftest",
+	.cfunc		= sha512selftest_f,
+	.argmin		= 0,
+	.argmax		= 0,
+	.canpush	= 0,
+	.flags		= CMD_FLAG_ONESHOT | CMD_FLAG_FOREIGN_OK |
+			  CMD_NOFILE_OK | CMD_NOMAP_OK,
+	.oneline	= N_("self test of sha512 implementation"),
+};
+
 void
 crc32cselftest_init(void)
 {
 	add_command(&crc32cselftest_cmd);
+	add_command(&sha512selftest_cmd);
 }
diff --git a/libfrog/Makefile b/libfrog/Makefile
index 5622ab9b..752fb9c7 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -28,6 +28,7 @@ projects.c \
 ptvar.c \
 radix-tree.c \
 scrub.c \
+sha512.c \
 util.c \
 workqueue.c
 
@@ -48,6 +49,7 @@ projects.h \
 ptvar.h \
 radix-tree.h \
 scrub.h \
+sha512.h \
 workqueue.h
 
 LSRCFILES += gen_crc32table.c
@@ -56,9 +58,9 @@ ifeq ($(HAVE_GETMNTENT),yes)
 LCFLAGS += -DHAVE_GETMNTENT
 endif
 
-LDIRT = gen_crc32table crc32table.h crc32selftest
+LDIRT = gen_crc32table crc32table.h crc32selftest sha512selftest
 
-default: crc32selftest ltdepend $(LTLIBRARY)
+default: crc32selftest sha512selftest ltdepend $(LTLIBRARY)
 
 crc32table.h: gen_crc32table.c crc32defs.h
 	@echo "    [CC]     gen_crc32table"
@@ -75,6 +77,10 @@ crc32selftest: gen_crc32table.c crc32table.h crc32.c crc32defs.h
 	@echo "    [TEST]    CRC32"
 	$(Q) $(BUILD_CC) $(BUILD_CFLAGS) -D CRC32_SELFTEST=1 crc32.c -o $@
 	$(Q) ./$@
+sha512selftest: sha512.h sha512selftest.h sha512.c
+	@echo "    [TEST]    SHA512"
+	$(Q) $(BUILD_CC) $(BUILD_CFLAGS) -D SHA512_SELFTEST=1 sha512.c -o $@
+	$(Q) ./$@
 
 include $(BUILDRULES)
 
diff --git a/libfrog/sha512.c b/libfrog/sha512.c
new file mode 100644
index 00000000..741e03be
--- /dev/null
+++ b/libfrog/sha512.c
@@ -0,0 +1,249 @@
+/*
+ * sha512.c --- The sha512 algorithm
+ *
+ * Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>
+ * (copied from libtomcrypt and then relicensed under GPLv2)
+ * (and later copied from e2fsprogs)
+ *
+ * %Begin-Header%
+ * This file may be redistributed under the terms of the GNU Library
+ * General Public License, version 2.
+ * %End-Header%
+ */
+#include <string.h>
+#include "xfs.h"
+#include "libfrog/sha512.h"
+
+/* the K array */
+#define CONST64(n) n
+static const __u64 K[80] = {
+	CONST64(0x428a2f98d728ae22), CONST64(0x7137449123ef65cd),
+	CONST64(0xb5c0fbcfec4d3b2f), CONST64(0xe9b5dba58189dbbc),
+	CONST64(0x3956c25bf348b538), CONST64(0x59f111f1b605d019),
+	CONST64(0x923f82a4af194f9b), CONST64(0xab1c5ed5da6d8118),
+	CONST64(0xd807aa98a3030242), CONST64(0x12835b0145706fbe),
+	CONST64(0x243185be4ee4b28c), CONST64(0x550c7dc3d5ffb4e2),
+	CONST64(0x72be5d74f27b896f), CONST64(0x80deb1fe3b1696b1),
+	CONST64(0x9bdc06a725c71235), CONST64(0xc19bf174cf692694),
+	CONST64(0xe49b69c19ef14ad2), CONST64(0xefbe4786384f25e3),
+	CONST64(0x0fc19dc68b8cd5b5), CONST64(0x240ca1cc77ac9c65),
+	CONST64(0x2de92c6f592b0275), CONST64(0x4a7484aa6ea6e483),
+	CONST64(0x5cb0a9dcbd41fbd4), CONST64(0x76f988da831153b5),
+	CONST64(0x983e5152ee66dfab), CONST64(0xa831c66d2db43210),
+	CONST64(0xb00327c898fb213f), CONST64(0xbf597fc7beef0ee4),
+	CONST64(0xc6e00bf33da88fc2), CONST64(0xd5a79147930aa725),
+	CONST64(0x06ca6351e003826f), CONST64(0x142929670a0e6e70),
+	CONST64(0x27b70a8546d22ffc), CONST64(0x2e1b21385c26c926),
+	CONST64(0x4d2c6dfc5ac42aed), CONST64(0x53380d139d95b3df),
+	CONST64(0x650a73548baf63de), CONST64(0x766a0abb3c77b2a8),
+	CONST64(0x81c2c92e47edaee6), CONST64(0x92722c851482353b),
+	CONST64(0xa2bfe8a14cf10364), CONST64(0xa81a664bbc423001),
+	CONST64(0xc24b8b70d0f89791), CONST64(0xc76c51a30654be30),
+	CONST64(0xd192e819d6ef5218), CONST64(0xd69906245565a910),
+	CONST64(0xf40e35855771202a), CONST64(0x106aa07032bbd1b8),
+	CONST64(0x19a4c116b8d2d0c8), CONST64(0x1e376c085141ab53),
+	CONST64(0x2748774cdf8eeb99), CONST64(0x34b0bcb5e19b48a8),
+	CONST64(0x391c0cb3c5c95a63), CONST64(0x4ed8aa4ae3418acb),
+	CONST64(0x5b9cca4f7763e373), CONST64(0x682e6ff3d6b2b8a3),
+	CONST64(0x748f82ee5defb2fc), CONST64(0x78a5636f43172f60),
+	CONST64(0x84c87814a1f0ab72), CONST64(0x8cc702081a6439ec),
+	CONST64(0x90befffa23631e28), CONST64(0xa4506cebde82bde9),
+	CONST64(0xbef9a3f7b2c67915), CONST64(0xc67178f2e372532b),
+	CONST64(0xca273eceea26619c), CONST64(0xd186b8c721c0c207),
+	CONST64(0xeada7dd6cde0eb1e), CONST64(0xf57d4f7fee6ed178),
+	CONST64(0x06f067aa72176fba), CONST64(0x0a637dc5a2c898a6),
+	CONST64(0x113f9804bef90dae), CONST64(0x1b710b35131c471b),
+	CONST64(0x28db77f523047d84), CONST64(0x32caab7b40c72493),
+	CONST64(0x3c9ebe0a15c9bebc), CONST64(0x431d67c49c100d4c),
+	CONST64(0x4cc5d4becb3e42b6), CONST64(0x597f299cfc657e2a),
+	CONST64(0x5fcb6fab3ad6faec), CONST64(0x6c44198c4a475817)
+};
+#define Ch(x,y,z)       (z ^ (x & (y ^ z)))
+#define Maj(x,y,z)      (((x | y) & z) | (x & y))
+#define S(x, n)         ROR64c(x, n)
+#define R(x, n)         (((x)&CONST64(0xFFFFFFFFFFFFFFFF))>>((__u64)n))
+#define Sigma0(x)       (S(x, 28) ^ S(x, 34) ^ S(x, 39))
+#define Sigma1(x)       (S(x, 14) ^ S(x, 18) ^ S(x, 41))
+#define Gamma0(x)       (S(x, 1) ^ S(x, 8) ^ R(x, 7))
+#define Gamma1(x)       (S(x, 19) ^ S(x, 61) ^ R(x, 6))
+#define RND(a,b,c,d,e,f,g,h,i)\
+		t0 = h + Sigma1(e) + Ch(e, f, g) + K[i] + W[i];\
+		t1 = Sigma0(a) + Maj(a, b, c);\
+		d += t0;\
+		h  = t0 + t1;
+#define STORE64H(x, y) \
+	do { \
+		(y)[0] = (unsigned char)(((x)>>56)&255);\
+		(y)[1] = (unsigned char)(((x)>>48)&255);\
+		(y)[2] = (unsigned char)(((x)>>40)&255);\
+		(y)[3] = (unsigned char)(((x)>>32)&255);\
+		(y)[4] = (unsigned char)(((x)>>24)&255);\
+		(y)[5] = (unsigned char)(((x)>>16)&255);\
+		(y)[6] = (unsigned char)(((x)>>8)&255);\
+		(y)[7] = (unsigned char)((x)&255); } while(0)
+
+#define LOAD64H(x, y)\
+	do {x = \
+		(((__u64)((y)[0] & 255)) << 56) |\
+		(((__u64)((y)[1] & 255)) << 48) |\
+		(((__u64)((y)[2] & 255)) << 40) |\
+		(((__u64)((y)[3] & 255)) << 32) |\
+		(((__u64)((y)[4] & 255)) << 24) |\
+		(((__u64)((y)[5] & 255)) << 16) |\
+		(((__u64)((y)[6] & 255)) << 8) |\
+		(((__u64)((y)[7] & 255)));\
+	} while(0)
+
+#define ROR64c(x, y) \
+    ( ((((x)&CONST64(0xFFFFFFFFFFFFFFFF))>>((__u64)(y)&CONST64(63))) | \
+      ((x)<<((__u64)(64-((y)&CONST64(63)))))) & CONST64(0xFFFFFFFFFFFFFFFF))
+
+static void sha512_compress(struct sha512_state * md, const unsigned char *buf)
+{
+	__u64 S[8], W[80], t0, t1;
+	int i;
+
+	/* copy state into S */
+	for (i = 0; i < 8; i++) {
+		S[i] = md->state[i];
+	}
+
+	/* copy the state into 1024-bits into W[0..15] */
+	for (i = 0; i < 16; i++) {
+		LOAD64H(W[i], buf + (8*i));
+	}
+
+	/* fill W[16..79] */
+	for (i = 16; i < 80; i++) {
+		W[i] = Gamma1(W[i - 2]) + W[i - 7] +
+			Gamma0(W[i - 15]) + W[i - 16];
+	}
+
+	for (i = 0; i < 80; i += 8) {
+		RND(S[0],S[1],S[2],S[3],S[4],S[5],S[6],S[7],i+0);
+		RND(S[7],S[0],S[1],S[2],S[3],S[4],S[5],S[6],i+1);
+		RND(S[6],S[7],S[0],S[1],S[2],S[3],S[4],S[5],i+2);
+		RND(S[5],S[6],S[7],S[0],S[1],S[2],S[3],S[4],i+3);
+		RND(S[4],S[5],S[6],S[7],S[0],S[1],S[2],S[3],i+4);
+		RND(S[3],S[4],S[5],S[6],S[7],S[0],S[1],S[2],i+5);
+		RND(S[2],S[3],S[4],S[5],S[6],S[7],S[0],S[1],i+6);
+		RND(S[1],S[2],S[3],S[4],S[5],S[6],S[7],S[0],i+7);
+	}
+
+	 /* feedback */
+	for (i = 0; i < 8; i++) {
+		md->state[i] = md->state[i] + S[i];
+	}
+}
+
+int sha512_init(struct sha512_state * md)
+{
+	md->curlen = 0;
+	md->length = 0;
+	md->state[0] = CONST64(0x6a09e667f3bcc908);
+	md->state[1] = CONST64(0xbb67ae8584caa73b);
+	md->state[2] = CONST64(0x3c6ef372fe94f82b);
+	md->state[3] = CONST64(0xa54ff53a5f1d36f1);
+	md->state[4] = CONST64(0x510e527fade682d1);
+	md->state[5] = CONST64(0x9b05688c2b3e6c1f);
+	md->state[6] = CONST64(0x1f83d9abfb41bd6b);
+	md->state[7] = CONST64(0x5be0cd19137e2179);
+	return 0;
+}
+
+int sha512_done(struct sha512_state * md, unsigned char *out)
+{
+	int i;
+
+	/* increase the length of the message */
+	md->length += md->curlen * CONST64(8);
+
+	/* append the '1' bit */
+	md->buf[md->curlen++] = (unsigned char)0x80;
+
+	/* if the length is currently above 112 bytes we append zeros then
+	 * compress. Then we can fall back to padding zeros and length encoding
+	 * like normal. */
+	if (md->curlen > 112) {
+		while (md->curlen < 128) {
+			md->buf[md->curlen++] = (unsigned char)0;
+		}
+		sha512_compress(md, md->buf);
+		md->curlen = 0;
+	}
+
+	/* pad up to 120 bytes of zeroes note: that from 112 to 120 is the 64 MSB
+	 * of the length. We assume that you won't hash > 2^64 bits of data. */
+	while (md->curlen < 120) {
+		md->buf[md->curlen++] = (unsigned char)0;
+	}
+
+	/* store length */
+	STORE64H(md->length, md->buf + 120);
+	sha512_compress(md, md->buf);
+
+	/* copy output */
+	for (i = 0; i < 8; i++) {
+		STORE64H(md->state[i], out+(8 * i));
+	}
+
+	return 0;
+}
+
+#define SHA512_BLOCKSIZE 128
+int sha512_process(struct sha512_state * md,
+		   const unsigned char *in,
+		   unsigned long inlen)
+{
+	unsigned long n;
+
+	while (inlen > 0) {
+		if (md->curlen == 0 && inlen >= SHA512_BLOCKSIZE) {
+			sha512_compress(md, in);
+			md->length += SHA512_BLOCKSIZE * 8;
+			in += SHA512_BLOCKSIZE;
+			inlen -= SHA512_BLOCKSIZE;
+		} else {
+			n = MIN(inlen, (SHA512_BLOCKSIZE - md->curlen));
+			memcpy(md->buf + md->curlen,
+			       in, (size_t)n);
+			md->curlen += n;
+			in += n;
+			inlen -= n;
+			if (md->curlen == SHA512_BLOCKSIZE) {
+				sha512_compress(md, md->buf);
+				md->length += SHA512_BLOCKSIZE * 8;
+				md->curlen = 0;
+			}
+		}
+	}
+
+	return 0;
+}
+
+void sha512(const unsigned char *in, unsigned long in_size, unsigned char *out)
+{
+	struct sha512_state md;
+
+	sha512_init(&md);
+	sha512_process(&md, in, in_size);
+	sha512_done(&md, out);
+}
+
+#ifdef SHA512_SELFTEST
+# include "sha512selftest.h"
+
+/*
+ * make sure we always return 0 for a successful test run, and non-zero for a
+ * failed run. The build infrastructure is looking for this information to
+ * determine whether to allow the build to proceed.
+ */
+int main(int argc, char **argv)
+{
+	int errors;
+
+	errors = sha512_test(0);
+
+	return errors != 0;
+}
+#endif /* SHA512_SELFTEST */
diff --git a/libfrog/sha512.h b/libfrog/sha512.h
new file mode 100644
index 00000000..28ff5284
--- /dev/null
+++ b/libfrog/sha512.h
@@ -0,0 +1,33 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2023 Oracle, Inc.
+ * All Rights Reserved.
+ */
+#ifndef __LIBFROG_SHA512_H__
+#define __LIBFROG_SHA512_H__
+
+struct sha512_state {
+	__u64		length;
+	__u64		state[8];
+	unsigned long	curlen;
+	unsigned char	buf[128];
+};
+
+#define SHA512_DESC_ON_STACK(mp, name) \
+	struct sha512_state name
+
+#define SHA512_DIGEST_SIZE	64
+
+void sha512(const unsigned char *in, unsigned long in_size, unsigned char *out);
+
+int sha512_init(struct sha512_state *md);
+int sha512_done(struct sha512_state *md, unsigned char *out);
+int sha512_process(struct sha512_state *md, const unsigned char *in,
+		unsigned long inlen);
+
+static inline void sha512_erase(struct sha512_state *md)
+{
+	memset(md, 0, sizeof(*md));
+}
+
+#endif	/* __LIBFROG_SHA512_H__ */
diff --git a/libfrog/sha512selftest.h b/libfrog/sha512selftest.h
new file mode 100644
index 00000000..9f4edeb0
--- /dev/null
+++ b/libfrog/sha512selftest.h
@@ -0,0 +1,86 @@
+/*
+ * sha512.c --- The sha512 algorithm self tests
+ *
+ * Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>
+ * (copied from libtomcrypt and then relicensed under GPLv2)
+ * (and later copied from e2fsprogs)
+ *
+ * %Begin-Header%
+ * This file may be redistributed under the terms of the GNU Library
+ * General Public License, version 2.
+ * %End-Header%
+ */
+#ifndef __LIBFROG_SHA512SELFTEST_H__
+#define __LIBFROG_SHA512SELFTEST_H__
+
+static const struct {
+	char *msg;
+	unsigned char hash[64];
+} sha512_tests[] = {
+	{ "",
+	  { 0xcf, 0x83, 0xe1, 0x35, 0x7e, 0xef, 0xb8, 0xbd,
+	    0xf1, 0x54, 0x28, 0x50, 0xd6, 0x6d, 0x80, 0x07,
+	    0xd6, 0x20, 0xe4, 0x05, 0x0b, 0x57, 0x15, 0xdc,
+	    0x83, 0xf4, 0xa9, 0x21, 0xd3, 0x6c, 0xe9, 0xce,
+	    0x47, 0xd0, 0xd1, 0x3c, 0x5d, 0x85, 0xf2, 0xb0,
+	    0xff, 0x83, 0x18, 0xd2, 0x87, 0x7e, 0xec, 0x2f,
+	    0x63, 0xb9, 0x31, 0xbd, 0x47, 0x41, 0x7a, 0x81,
+	    0xa5, 0x38, 0x32, 0x7a, 0xf9, 0x27, 0xda, 0x3e }
+	},
+	{ "abc",
+	  { 0xdd, 0xaf, 0x35, 0xa1, 0x93, 0x61, 0x7a, 0xba,
+	    0xcc, 0x41, 0x73, 0x49, 0xae, 0x20, 0x41, 0x31,
+	    0x12, 0xe6, 0xfa, 0x4e, 0x89, 0xa9, 0x7e, 0xa2,
+	    0x0a, 0x9e, 0xee, 0xe6, 0x4b, 0x55, 0xd3, 0x9a,
+	    0x21, 0x92, 0x99, 0x2a, 0x27, 0x4f, 0xc1, 0xa8,
+	    0x36, 0xba, 0x3c, 0x23, 0xa3, 0xfe, 0xeb, 0xbd,
+	    0x45, 0x4d, 0x44, 0x23, 0x64, 0x3c, 0xe8, 0x0e,
+	    0x2a, 0x9a, 0xc9, 0x4f, 0xa5, 0x4c, 0xa4, 0x9f }
+	},
+	{ "abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu",
+	  { 0x8e, 0x95, 0x9b, 0x75, 0xda, 0xe3, 0x13, 0xda,
+	    0x8c, 0xf4, 0xf7, 0x28, 0x14, 0xfc, 0x14, 0x3f,
+	    0x8f, 0x77, 0x79, 0xc6, 0xeb, 0x9f, 0x7f, 0xa1,
+	    0x72, 0x99, 0xae, 0xad, 0xb6, 0x88, 0x90, 0x18,
+	    0x50, 0x1d, 0x28, 0x9e, 0x49, 0x00, 0xf7, 0xe4,
+	    0x33, 0x1b, 0x99, 0xde, 0xc4, 0xb5, 0x43, 0x3a,
+	    0xc7, 0xd3, 0x29, 0xee, 0xb6, 0xdd, 0x26, 0x54,
+	    0x5e, 0x96, 0xe5, 0x5b, 0x87, 0x4b, 0xe9, 0x09 }
+	},
+	{ "The quick brown fox jumps over the lazy dog.\n",
+	  { 0x02, 0x0d, 0xa0, 0xf4, 0xd8, 0xa4, 0xc8, 0xbf,
+	    0xbc, 0x98, 0x27, 0x40, 0x27, 0x74, 0x00, 0x61,
+	    0xd7, 0xdf, 0x52, 0xee, 0x07, 0x09, 0x1e, 0xd6,
+	    0x59, 0x5a, 0x08, 0x3e, 0x0f, 0x45, 0x32, 0x7b,
+	    0xbe, 0x59, 0x42, 0x43, 0x12, 0xd8, 0x6f, 0x21,
+	    0x8b, 0x74, 0xed, 0x2e, 0x25, 0x50, 0x7a, 0xba,
+	    0xf5, 0xc7, 0xa5, 0xfc, 0xf4, 0xca, 0xfc, 0xf9,
+	    0x53, 0x8b, 0x70, 0x58, 0x08, 0xfd, 0x55, 0xec }
+	},
+};
+
+/* Don't print anything to stdout. */
+#define SHA512TEST_QUIET	(1U << 0)
+
+static int sha512_test(unsigned int flags)
+{
+	int i;
+	int errors = 0;
+	unsigned char tmp[64];
+
+	for (i = 0; i < (int)(sizeof(sha512_tests) / sizeof(sha512_tests[0])); i++) {
+		unsigned char *msg = (unsigned char *) sha512_tests[i].msg;
+		int len = strlen(sha512_tests[i].msg);
+
+		sha512(msg, len, tmp);
+		if (memcmp(tmp, sha512_tests[i].hash, 64) != 0)
+			errors++;
+	}
+
+	if (!(flags & SHA512TEST_QUIET) && errors)
+		printf("sha512: %d self tests failed\n", errors);
+
+	return errors;
+}
+
+#endif /* __LIBFROG_SHA512SELFTEST_H__ */
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index ef7087b3..dc10c8f6 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -1506,6 +1506,10 @@ command.
 .B crc32cselftest
 Test the internal crc32c implementation to make sure that it computes results
 correctly.
+.TP
+.B sha512selftest
+Test the internal sha512 implementation to make sure that it computes results
+correctly.
 .SH SEE ALSO
 .BR mkfs.xfs (8),
 .BR xfsctl (3),
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index dffee9e2..d3f34ef8 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -11,6 +11,7 @@
 #include "libfrog/fsgeom.h"
 #include "libfrog/convert.h"
 #include "libfrog/crc32cselftest.h"
+#include "libfrog/sha512selftest.h"
 #include "proto.h"
 #include <ini.h>
 
@@ -4287,6 +4288,13 @@ main(
 		return 1;
 	}
 
+	/* Make sure our checksum algorithm really works. */
+	if (sha512_test(SHA512TEST_QUIET) != 0) {
+		fprintf(stderr,
+ _("sha512 self-test failed, will not create a filesystem here.\n"));
+		return 1;
+	}
+
 	/*
 	 * All values have been validated, discard the old device layout.
 	 */
diff --git a/repair/init.c b/repair/init.c
index 3a320b4f..46b4dbef 100644
--- a/repair/init.c
+++ b/repair/init.c
@@ -15,6 +15,7 @@
 #include "incore.h"
 #include "prefetch.h"
 #include "libfrog/crc32cselftest.h"
+#include "libfrog/sha512selftest.h"
 #include <sys/resource.h>
 
 static void
@@ -105,4 +106,8 @@ _("Unmount or use the dangerous (-d) option to repair a read-only mounted filesy
 	if (crc32c_test(CRC32CTEST_QUIET) != 0)
 		do_error(
  _("crc32c self-test failed, will not examine filesystem.\n"));
+
+	if (sha512_test(SHA512TEST_QUIET) != 0)
+		do_error(
+ _("sha512 self-test failed, will not examine filesystem.\n"));
 }

