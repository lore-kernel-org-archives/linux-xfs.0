Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793815974;
	b=d44u8Sf08LaELgsqBE7hXXYz9Fwg61XAOC5J21sQJs1SkcPoezuHWjQpNUuni1trD/Dj
	 KBg/O7aCSN/54DQjIzGY2aYP3ZgvtnAoMDhATBgk9VoP4slcP3vL9fO6+gJku8DcrYfq6
	 iV0leovSz4CH+wy6zpI/pAQQrzPbdy9T14lo2dETvsJ682e2d8vpkmYHr81+hGkqnmO+k
	 zOSmNeR91BcAePKt/I6W6ATixgrFqyNxK3jdRgJAJ+1z8uyYpO+ni5HjRiZn6ioq7OWsT
	 zFo5PBWECufwuB+RwzszHJ9q2hjc8MtHk2uGWU8fDCv2MIc85v3i7XCxFboL7UQpv7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793815974;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R2y0UZWMl8b8Ruu1xcuIgtqcFQfnkSSgmMRO6i6SuhA=;
	b=Fys+u2xf4NizgZOuXs1vcjg4R1LO92Plz4lzNgzA3mJZ+o7JWswAP3N6m1KV/I6SbLaz
	 wW8a3lVgMX21m6ONd6Dj9RbJ20tc8SEvsuUJbH4FfTQu+txc/3d45q1Wa5VJbVmblzGDm
	 X7mxFNYC0b/XLtWeEtKV9Z6TXC9GMR37EyPU641G3GnKBiNwS4atYEimb1AaUsL2+k6HY
	 bCMTOWUDACHYuoZGBXvxhin/NgdRIQn4TmEAc1xdVzlYVLgvP/8Ksv+aZiQCP7hvKVSS6
	 vJbT1Nc4YvgId8ViFi9yUlOHNlAkBLiQlfZFVlTNSdTFaj13EpIVBMwAuEDVUWZOTYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hodv7Xg5;
	arc=none smtp.remote-ip=209.85.215.176
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3294D606B205
	for <linux-xfs@vger.kernel.org>; Wed,  4 Nov 2026 18:12:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3294D606B205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hodv7Xg5
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-cd6028ff33fso524949a12.0
        for <linux-xfs@vger.kernel.org>; Wed, 04 Nov 2026 10:12:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793815972; x=1794420772; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=R2y0UZWMl8b8Ruu1xcuIgtqcFQfnkSSgmMRO6i6SuhA=;
        b=hodv7Xg5EA8a8s88sKOT/5SzuKFccbpMle0PAbn+W/qKMfDz6ZJ8CjQiH0ejl75Olr
         zxBZj7icWiTR4vVe/19iCOqczVEQKXMugHe6iATD9AFxq6X/zuC/268tyf99vx8Sj/jZ
         a0LOhN2ZSDLrPjEonIVHBOjrk0CNjEvZR+sHcsZ7fuKs9vzj6vyPFuKRRvKXJINDxB9S
         QT8oF/fbZ1mMnPIumAaukByHRqNFrEs0/7sqxCKOy0sFvjKMaoDprCQFMAl20ueOFRrf
         kGpmflPNF16nlbukoxSc2Kq2jOqSonR/ip06n9Af6U7+atnijhcg9hEml7s4MqRiQGRX
         EfOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793815972; x=1794420772;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=R2y0UZWMl8b8Ruu1xcuIgtqcFQfnkSSgmMRO6i6SuhA=;
        b=bArNKh58hRjyKkqNj1MGWurGDhc5XWm4OtBR6jcbgLUs0fnFGFVqqrMYzFlHjsWJZM
         ITPiAfIsB6f387c1I9gjIYpOjvQXaoJCrdGUhZHE/t06aHXrECBBydkfZJ3Cgx+1LIRF
         91poS4cowV4kDGTHcfOlI6peHBXcI9yr0rm4MjMOD6SDgIi+0dtcGDGj+2UkmuUxfxtv
         pfHrBkK448bP9epISgSwopi7g7dpnzXZgoK1jHudHc86SuEZP2X/Q2WKmoE+WfLWwzG9
         rzCJKLvcfyLajyi+VoYeFg/oYGtXTXTBPy2BHZbedvLoqFeSKcsr8QYpYjSGuYSoNAaK
         nbjw==
X-Forwarded-Encrypted: i=1; AKwUvBxM3fsJWni/ediAZnVuxNgOJfeiGYtHI4I/8DKFava2wfMUb+2u6fNyJguiFcF7aRD8JBjHM/uy8m4=@vger.kernel.org
X-Gm-Message-State: APuU4Z9virovj237RCUM0iDeip8QfiHHYv3uhTC2BUEVVyy1W3ZqjFMF
	aAp4MgjANxstUJl+r6SFgRSXbpEW6GKCPk4MbX/l0ik2dPddK6bjkv3/
X-Gm-Gg: AYBFou1Z67pIJ5QFol2uv9aGXkOx/44QyE/gOrbS09PPG3CKy5tDTl/QAYpXtBXG/jX
	u9RuhuatVFHVsDlFZn1JrmyVM5VLrrEhFnpuY60UKCyq7pIk9BjrHeZ5h2RPorFolDt6B7u2mQd
	hGc2cf65ElLW1G37un6Rq8QLsfTHdGAj6W8jUvz9+8TSZFq+XvB05ReHIcMriH2qC5jInqlSH2z
	KXmOBUzeRP5YdnG1WyG5XNsIlVnTS1gK4xCUCXjjF6QNU60aF5STl1AD05gqRO/uuZlw/YPy7Ne
	muQIVEv4Q/x6gk4H3rVTLeoZv+zDrjdlSwlTSkXnjw2aRRjjlG0fvntSm5ysbioPG++NND8VROd
	y4I8FxJDZPfgjqkoIcVhoruD//yy186zsUDp/hrTiWeQb+0+s5rfrfcY8Q+QIjylLag2mZSHKqV
	D1GJBMc7yoPW+UkyAgLTrh7SRj8ud+b2Y4/l+A4ieV8m4xzrRGBlK48ImJbrbx4d7MR9XDiBIp7
	PK+PCHPU9vXs13pcu2GM+ZSpaXSLtm0oHGuToiagcbnSQheednZDYqf0K9mpPCxaqNvfd4wDmHb
	C40vNg5D+l5rv4BIi9Un5XgGGtnf5AT30OhnxuAvgk8rw4WHc1rCIz2lJZ7HkBQZRCLwOYbxNPp
	8PeZQcw==
X-Received: by 2002:a17:90b:390f:b0:3b0:a4bf:b90 with SMTP id 98e67ed59e1d1-3b0a4bf0bb0mr1219817a91.20.1793815972050;
        Wed, 04 Nov 2026 10:12:52 -0800 (PST)
Received: from archlinux.tail3acd4.ts.net ([69.110.143.170])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0b31a3efasm78326a91.9.2026.11.04.10.12.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 10:12:51 -0800 (PST)
From: Vitali Lovich <vlovich@gmail.com>
To: linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Cc: brauner@kernel.org,
	viro@zeniv.linux.org.uk,
	jack@suse.cz,
	cem@kernel.org,
	djwong@kernel.org
Subject: [RFC PATCH 3/6] fs: add KUnit coverage for generation-based DIO draining
Date: Wed,  4 Nov 2026 10:12:43 -0800
Message-ID: <54077f1e45c6de68540e5db7577c38ff235ca864.1793815542.git.vlovich@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1793815542.git.vlovich@gmail.com>
References: <cover.1793815542.git.vlovich@gmail.com>
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

Exercise admission before lazy allocation, rejection of overlapping DIO,
disjoint new-generation requests and cohort rollover. Check that iomap
consumes caller registrations on simple-read fallback and generic early
returns, including an old-generation completion during an active drain.

Keep generation registration inline in normal builds. When
DIO_DRAIN_KUNIT_TEST is enabled, provide an out-of-line definition in
fs/inode.c with a static stub and one function address across translation
units. Keep the KUnit stub headers out of linux/fs.h.

Use the stub to pause the real admission helper after its provisional
increment and before its first pointer load. Publish the first drain
allocation and verify that cutover completes while the reader is paused.
The resumed overlapping admission must reject the request and withdraw
its old-generation registration. Release both threads and any outstanding
DIO count before reporting failures. Skip this race test without two
online CPUs.

Check snapshot reads while a latch writer is interrupted at either copy
update, and exercise repeated cutover and range reuse across both
generations.

Inject iomap allocation and mapping failures with both saved generation
values. Pause filesystem end_io in the real iomap completion path and
verify that it remains in the old cohort while newer disjoint I/O finishes.
Check successful short-read and failed completion accounting.

Exercise real bio-based writes on a hidden test block device, including
a successful partial request, driver completion errors and block-layer
submission rejection. Check both saved generation values, delayed
filesystem completion, newer disjoint progress and exact token release.

Signed-off-by: Vitali Lovich <vlovich@gmail.com>
---
 fs/Kconfig                 |  13 +
 fs/Makefile                |   1 +
 fs/inode.c                 |  13 +
 fs/iomap/direct-io.c       |  20 +-
 fs/tests/dio_drain_kunit.c | 893 +++++++++++++++++++++++++++++++++++++
 include/linux/fs.h         |   5 +
 include/linux/iomap.h      |   4 +
 7 files changed, 948 insertions(+), 1 deletion(-)
 create mode 100644 fs/tests/dio_drain_kunit.c

diff --git a/fs/Kconfig b/fs/Kconfig
index 70a1d0760d28..e004f5a0d6f0 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -428,4 +428,17 @@ config FDTABLE_KUNIT_TEST
 	  This builds the fdtable KUnit tests, which tests various aspects
 	  of the fdtable structure and allocation.
 
+config DIO_DRAIN_KUNIT_TEST
+	tristate "KUnit tests for direct I/O range draining" if !KUNIT_ALL_TESTS
+	depends on KUNIT && BLOCK
+	select FS_IOMAP
+	default KUNIT_ALL_TESTS
+	help
+	  Test direct I/O range admission, generation accounting, and
+	  seqcount_latch range snapshots across cohort cutovers, including
+	  iomap early-return ownership and delayed-admission races.
+	  The concurrent admission test requires at least two online CPUs.
+
+	  If unsure, say N.
+
 endmenu
diff --git a/fs/Makefile b/fs/Makefile
index 16f1108b64e1..8974a3bba893 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -28,6 +28,7 @@ obj-$(CONFIG_SIGNALFD)		+= signalfd.o
 obj-$(CONFIG_TIMERFD)		+= timerfd.o
 obj-$(CONFIG_EVENTFD)		+= eventfd.o
 obj-$(CONFIG_AIO)               += aio.o
+obj-$(CONFIG_DIO_DRAIN_KUNIT_TEST) += tests/dio_drain_kunit.o
 obj-$(CONFIG_FS_DAX)		+= dax.o
 obj-$(CONFIG_FS_ENCRYPTION)	+= crypto/
 obj-$(CONFIG_FS_VERITY)		+= verity/
diff --git a/fs/inode.c b/fs/inode.c
index 7b027547b305..b31d5ac5bb96 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -23,6 +23,9 @@
 #include <linux/rw_hint.h>
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
+#if IS_ENABLED(CONFIG_DIO_DRAIN_KUNIT_TEST)
+#include <kunit/static_stub.h>
+#endif
 #include <trace/events/writeback.h>
 #define CREATE_TRACE_POINTS
 #include <trace/events/timestamp.h>
@@ -2783,6 +2786,16 @@ bool inode_dio_finished(const struct inode *inode)
 }
 EXPORT_SYMBOL(inode_dio_finished);
 
+#if IS_ENABLED(CONFIG_DIO_DRAIN_KUNIT_TEST)
+bool inode_dio_begin_generation(struct inode *inode)
+{
+	KUNIT_STATIC_STUB_REDIRECT(inode_dio_begin_generation, inode);
+	return atomic_fetch_inc(&inode->i_dio_count) &
+		INODE_DIO_GENERATION;
+}
+EXPORT_SYMBOL_GPL(inode_dio_begin_generation);
+#endif
+
 /*
  * Allocated on the first draining operation, never on ordinary DIO. The
  * filesystem owns the pointer and retains the allocation until inode reclaim.
diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index fffe6702c42f..2c840358abc8 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -13,6 +13,9 @@
 #include <linux/init.h>
 #include "internal.h"
 #include "trace.h"
+#if IS_ENABLED(CONFIG_DIO_DRAIN_KUNIT_TEST)
+#include <kunit/static_stub.h>
+#endif
 
 #include "../internal.h"
 
@@ -674,6 +677,21 @@ static int iomap_dio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
 	}
 }
 
+#if IS_ENABLED(CONFIG_DIO_DRAIN_KUNIT_TEST)
+/* Fault injection is scoped to the task running the ownership test. */
+struct iomap_dio *iomap_dio_alloc(void)
+{
+	KUNIT_STATIC_STUB_REDIRECT(iomap_dio_alloc);
+	return kmalloc_obj(struct iomap_dio);
+}
+EXPORT_SYMBOL_GPL(iomap_dio_alloc);
+#else
+static inline struct iomap_dio *iomap_dio_alloc(void)
+{
+	return kmalloc_obj(struct iomap_dio);
+}
+#endif
+
 /*
  * iomap_dio_rw() always completes O_[D]SYNC writes regardless of whether the IO
  * is being issued as AIO or not.  This allows us to optimise pure data writes
@@ -726,7 +744,7 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	if (!iomi.len)
 		goto out_account;
 
-	dio = kmalloc_obj(*dio);
+	dio = iomap_dio_alloc();
 	if (!dio) {
 		ret = -ENOMEM;
 		goto out_account;
diff --git a/fs/tests/dio_drain_kunit.c b/fs/tests/dio_drain_kunit.c
new file mode 100644
index 000000000000..a99581f9edc4
--- /dev/null
+++ b/fs/tests/dio_drain_kunit.c
@@ -0,0 +1,893 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <kunit/static_stub.h>
+#include <kunit/test.h>
+#include <linux/blkdev.h>
+#include <linux/completion.h>
+#include <linux/highmem.h>
+#include <linux/delay.h>
+#include <linux/fs.h>
+#include <linux/iomap.h>
+#include <linux/kthread.h>
+#include <linux/module.h>
+#include <linux/uio.h>
+
+struct dio_drain_race;
+struct dio_test_device;
+
+struct dio_drain_test {
+	struct inode inode;
+	struct super_block sb;
+	struct inode_dio_drain *drain;
+	struct dio_drain_race *race;
+	struct kunit *test;
+	struct completion endio_entered;
+	struct completion endio_release;
+	struct iomap_dio *dio;
+	ssize_t result;
+	int endio_error;
+	struct dio_test_device *device;
+};
+
+static void dio_drain_test_complete(struct inode *inode)
+{
+	struct dio_drain_test *ctx = inode->i_private;
+
+	inode_dio_drain_complete(inode, ctx->drain);
+}
+
+static const struct inode_operations dio_drain_test_iops = {
+	.dio_drain_complete = dio_drain_test_complete,
+};
+
+static int dio_drain_test_init(struct kunit *test)
+{
+	struct dio_drain_test *ctx;
+
+	ctx = kunit_kzalloc(test, sizeof(*ctx), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, ctx);
+	inode_init_once(&ctx->inode);
+	init_rwsem(&ctx->inode.i_rwsem);
+	ctx->inode.i_mapping = &ctx->inode.i_data;
+	ctx->inode.i_data.host = &ctx->inode;
+	ctx->inode.i_sb = &ctx->sb;
+	ctx->inode.i_op = &dio_drain_test_iops;
+	ctx->inode.i_private = ctx;
+	ctx->sb.s_blocksize = 4096;
+	ctx->test = test;
+	init_completion(&ctx->endio_entered);
+	init_completion(&ctx->endio_release);
+	test->priv = ctx;
+	return 0;
+}
+
+static void dio_drain_test_exit(struct kunit *test)
+{
+	struct dio_drain_test *ctx = test->priv;
+
+	if (!IS_ERR(ctx->drain))
+		kfree(ctx->drain);
+}
+
+static void dio_drain_cohort_test(struct kunit *test)
+{
+	struct dio_drain_test *ctx = test->priv;
+	bool old, newer, resumed;
+	int error;
+
+	/* Count a request admitted before the first drain allocation. */
+	KUNIT_ASSERT_TRUE(test, inode_dio_try_begin(&ctx->inode, &ctx->drain,
+			4096, 4096, &old));
+	ctx->drain = inode_dio_drain_get(&ctx->drain);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ctx->drain);
+	mutex_lock(&ctx->drain->lock);
+	inode_lock_shared(&ctx->inode);
+	error = inode_dio_drain_start(&ctx->inode, ctx->drain, 4096, 8191);
+	KUNIT_EXPECT_EQ(test, error, 0);
+	KUNIT_EXPECT_EQ(test, atomic_read(&ctx->drain->pending), 1);
+	KUNIT_EXPECT_FALSE(test, inode_dio_try_begin(&ctx->inode, &ctx->drain,
+			4096, 4096, &resumed));
+	KUNIT_EXPECT_EQ(test, atomic_read(&ctx->inode.i_dio_count) &
+			INODE_DIO_COUNT_MASK, 1);
+	KUNIT_EXPECT_TRUE(test, inode_dio_try_begin(&ctx->inode, &ctx->drain,
+			8192, 4096, &newer));
+	KUNIT_EXPECT_NE(test, newer, old);
+	inode_dio_end_generation(&ctx->inode, old);
+	KUNIT_EXPECT_EQ(test, atomic_read(&ctx->drain->pending), 0);
+	/* The newer request must not extend this wait. */
+	inode_dio_drain_wait(&ctx->inode, ctx->drain);
+	inode_dio_drain_finish(&ctx->inode, ctx->drain);
+	KUNIT_EXPECT_TRUE(test, inode_dio_try_begin(&ctx->inode, &ctx->drain,
+			4096, 4096, &resumed));
+	inode_dio_end_generation(&ctx->inode, resumed);
+
+	/* Start a second drain covering the in-flight request from the previous cohort. */
+	error = inode_dio_drain_start(&ctx->inode, ctx->drain, 8192, 12287);
+	KUNIT_EXPECT_EQ(test, error, 0);
+	KUNIT_EXPECT_EQ(test, atomic_read(&ctx->drain->pending), 1);
+	inode_dio_end_generation(&ctx->inode, newer);
+	inode_dio_drain_wait(&ctx->inode, ctx->drain);
+	inode_dio_drain_finish(&ctx->inode, ctx->drain);
+	KUNIT_EXPECT_FALSE(test, ctx->drain->range[0].active);
+	KUNIT_EXPECT_EQ(test, atomic_read(&ctx->inode.i_dio_count) &
+			INODE_DIO_COUNT_MASK, 0);
+	inode_unlock_shared(&ctx->inode);
+	mutex_unlock(&ctx->drain->lock);
+}
+
+static void dio_drain_iomap_ownership_test(struct kunit *test)
+{
+	struct dio_drain_test *ctx = test->priv;
+	struct file file = {
+		.f_inode = &ctx->inode,
+		.f_mapping = ctx->inode.i_mapping,
+	};
+	struct kiocb iocb = { .ki_filp = &file };
+	struct kvec vec = { .iov_len = 8192 };
+	struct iov_iter iter;
+	unsigned int flags = IOMAP_DIO_ACCOUNTED;
+	bool generation;
+	ssize_t ret;
+
+	KUNIT_ASSERT_TRUE(test, inode_dio_try_begin(&ctx->inode, &ctx->drain,
+			0, vec.iov_len, &generation));
+	iov_iter_kvec(&iter, ITER_DEST, &vec, 1, vec.iov_len);
+	ret = iomap_dio_read_simple(&iocb, &iter, NULL, flags);
+	KUNIT_EXPECT_EQ(test, ret, -ENOTBLK);
+	KUNIT_EXPECT_EQ(test, atomic_read(&ctx->inode.i_dio_count), 0);
+
+	/* Generic fallback re-admits; its EOF early return consumes the token. */
+	KUNIT_ASSERT_TRUE(test, inode_dio_try_begin(&ctx->inode, &ctx->drain,
+			0, vec.iov_len, &generation));
+	ret = iomap_dio_rw(&iocb, &iter, NULL, NULL, flags, NULL, 0);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, atomic_read(&ctx->inode.i_dio_count), 0);
+
+	/* Exercise an early failure carrying a nonzero old-generation token. */
+	ctx->drain = inode_dio_drain_get(&ctx->drain);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ctx->drain);
+	mutex_lock(&ctx->drain->lock);
+	inode_lock_shared(&ctx->inode);
+	KUNIT_EXPECT_EQ(test, inode_dio_drain_start(&ctx->inode, ctx->drain,
+			4096, 8191), 0);
+	inode_dio_drain_wait(&ctx->inode, ctx->drain);
+	inode_dio_drain_finish(&ctx->inode, ctx->drain);
+	KUNIT_EXPECT_TRUE(test, inode_dio_try_begin(&ctx->inode, &ctx->drain,
+			4096, vec.iov_len, &generation));
+	KUNIT_EXPECT_TRUE(test, generation);
+	flags |= IOMAP_DIO_GENERATION;
+	KUNIT_EXPECT_EQ(test, inode_dio_drain_start(&ctx->inode, ctx->drain,
+			4096, 8191), 0);
+	KUNIT_EXPECT_EQ(test, atomic_read(&ctx->drain->pending), 1);
+	iov_iter_kvec(&iter, ITER_DEST, &vec, 1, vec.iov_len);
+	ret = iomap_dio_read_simple(&iocb, &iter, NULL, flags);
+	KUNIT_EXPECT_EQ(test, ret, -ENOTBLK);
+	KUNIT_EXPECT_EQ(test, atomic_read(&ctx->drain->pending), 0);
+	inode_dio_drain_wait(&ctx->inode, ctx->drain);
+	inode_dio_drain_finish(&ctx->inode, ctx->drain);
+	inode_unlock_shared(&ctx->inode);
+	mutex_unlock(&ctx->drain->lock);
+
+	/* An empty request must also release a pre-acquired registration. */
+	iov_iter_kvec(&iter, ITER_DEST, &vec, 1, 0);
+	KUNIT_ASSERT_TRUE(test, inode_dio_try_begin(&ctx->inode, &ctx->drain,
+			0, 0, &generation));
+	flags = IOMAP_DIO_ACCOUNTED |
+		(generation ? IOMAP_DIO_GENERATION : 0);
+	ret = iomap_dio_rw(&iocb, &iter, NULL, NULL, flags, NULL, 0);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, atomic_read(&ctx->inode.i_dio_count), 0);
+}
+
+/* Use real iomap submission/completion with a hole, without a block device. */
+static int dio_drain_map(struct inode *inode, loff_t offset, loff_t length,
+		unsigned int flags, struct iomap *iomap, struct iomap *srcmap)
+{
+	iomap->type = IOMAP_HOLE;
+	iomap->addr = IOMAP_NULL_ADDR;
+	iomap->offset = offset;
+	iomap->length = length;
+	return 0;
+}
+
+static int dio_drain_map_fail(struct inode *inode, loff_t offset, loff_t length,
+		unsigned int flags, struct iomap *iomap, struct iomap *srcmap)
+{
+	return -EAGAIN;
+}
+
+static struct iomap_dio *dio_drain_alloc_fail(void)
+{
+	return NULL;
+}
+
+static const struct iomap_ops dio_drain_map_ops = {
+	.iomap_begin = dio_drain_map,
+};
+
+static const struct iomap_ops dio_drain_map_fail_ops = {
+	.iomap_begin = dio_drain_map_fail,
+};
+
+static void dio_drain_iomap_errors_test(struct kunit *test)
+{
+	struct dio_drain_test *ctx = test->priv;
+	struct file file = { .f_inode = &ctx->inode,
+		.f_mapping = ctx->inode.i_mapping };
+	struct kiocb iocb = { .ki_filp = &file };
+	struct kvec vec = { .iov_len = 4096 };
+	struct iov_iter iter;
+	unsigned int flags;
+	bool generation;
+	int pass;
+
+	vec.iov_base = kunit_kzalloc(test, vec.iov_len, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, vec.iov_base);
+	i_size_write(&ctx->inode, vec.iov_len);
+	ctx->drain = inode_dio_drain_get(&ctx->drain);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ctx->drain);
+	mutex_lock(&ctx->drain->lock);
+	inode_lock_shared(&ctx->inode);
+	/* Repeat with both saved generation values and an armed old cohort. */
+	for (pass = 0; pass < 2; pass++) {
+		KUNIT_EXPECT_TRUE(test, inode_dio_try_begin(&ctx->inode,
+				&ctx->drain, 0, vec.iov_len, &generation));
+		flags = IOMAP_DIO_ACCOUNTED |
+			(generation ? IOMAP_DIO_GENERATION : 0);
+		KUNIT_EXPECT_EQ(test, inode_dio_drain_start(&ctx->inode,
+				ctx->drain, 0, vec.iov_len - 1), 0);
+		iov_iter_kvec(&iter, ITER_DEST, &vec, 1, vec.iov_len);
+		KUNIT_EXPECT_EQ(test, iomap_dio_rw(&iocb, &iter,
+				&dio_drain_map_fail_ops, NULL, flags, NULL, 0),
+				(ssize_t)-EAGAIN);
+		KUNIT_EXPECT_EQ(test, atomic_read(&ctx->drain->pending), 0);
+		inode_dio_drain_finish(&ctx->inode, ctx->drain);
+
+		KUNIT_EXPECT_TRUE(test, inode_dio_try_begin(&ctx->inode,
+				&ctx->drain, 0, vec.iov_len, &generation));
+		flags = IOMAP_DIO_ACCOUNTED |
+			(generation ? IOMAP_DIO_GENERATION : 0);
+		KUNIT_EXPECT_EQ(test, inode_dio_drain_start(&ctx->inode,
+				ctx->drain, 0, vec.iov_len - 1), 0);
+		iov_iter_kvec(&iter, ITER_DEST, &vec, 1, vec.iov_len);
+		KUNIT_EXPECT_EQ(test, iomap_dio_read_simple(&iocb, &iter,
+				dio_drain_map_fail, flags), (ssize_t)-EAGAIN);
+		KUNIT_EXPECT_EQ(test, atomic_read(&ctx->drain->pending), 0);
+		inode_dio_drain_finish(&ctx->inode, ctx->drain);
+
+		KUNIT_EXPECT_TRUE(test, inode_dio_try_begin(&ctx->inode,
+				&ctx->drain, 0, vec.iov_len, &generation));
+		flags = IOMAP_DIO_ACCOUNTED |
+			(generation ? IOMAP_DIO_GENERATION : 0);
+		KUNIT_EXPECT_EQ(test, inode_dio_drain_start(&ctx->inode,
+				ctx->drain, 0, vec.iov_len - 1), 0);
+		kunit_activate_static_stub(test, iomap_dio_alloc,
+				dio_drain_alloc_fail);
+		KUNIT_EXPECT_EQ(test, iomap_dio_rw(&iocb, &iter,
+				&dio_drain_map_ops, NULL, flags, NULL, 0),
+				(ssize_t)-ENOMEM);
+		kunit_deactivate_static_stub(test, iomap_dio_alloc);
+		KUNIT_EXPECT_EQ(test, atomic_read(&ctx->drain->pending), 0);
+		inode_dio_drain_finish(&ctx->inode, ctx->drain);
+	}
+	KUNIT_EXPECT_EQ(test, atomic_read(&ctx->inode.i_dio_count) &
+			INODE_DIO_COUNT_MASK, 0);
+	inode_unlock_shared(&ctx->inode);
+	mutex_unlock(&ctx->drain->lock);
+}
+
+static int dio_drain_endio(struct kiocb *iocb, ssize_t size, int error,
+		unsigned int flags)
+{
+	struct dio_drain_test *ctx = file_inode(iocb->ki_filp)->i_private;
+
+	/* Filesystem completion must still belong to the old cohort. */
+	KUNIT_EXPECT_EQ(ctx->test, atomic_read(&ctx->drain->pending), 1);
+	complete(&ctx->endio_entered);
+	if (!wait_for_completion_timeout(&ctx->endio_release, 5 * HZ))
+		KUNIT_FAIL(ctx->test, "filesystem completion was not released");
+	return ctx->endio_error;
+}
+
+static const struct iomap_dio_ops dio_drain_endio_ops = {
+	.end_io = dio_drain_endio,
+};
+
+static int dio_drain_finish_io(void *data)
+{
+	struct dio_drain_test *ctx = data;
+
+	ctx->result = iomap_dio_complete(ctx->dio);
+	return 0;
+}
+
+static void dio_drain_iomap_endio_check(struct kunit *test, int error)
+{
+	struct dio_drain_test *ctx = test->priv;
+	struct file file = { .f_inode = &ctx->inode,
+		.f_mapping = ctx->inode.i_mapping };
+	struct kiocb iocb = { .ki_filp = &file };
+	struct kvec vec = { .iov_len = 8192 };
+	struct iov_iter iter;
+	struct task_struct *task;
+	unsigned int flags;
+	bool generation, newer;
+	bool entered;
+
+	vec.iov_base = kunit_kmalloc(test, vec.iov_len, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, vec.iov_base);
+	memset(vec.iov_base, 0x5a, vec.iov_len);
+	/* Also check a short read and the iterator/position accounting. */
+	i_size_write(&ctx->inode, 4096);
+	KUNIT_ASSERT_TRUE(test, inode_dio_try_begin(&ctx->inode, &ctx->drain,
+			0, vec.iov_len, &generation));
+	flags = IOMAP_DIO_ACCOUNTED |
+		(generation ? IOMAP_DIO_GENERATION : 0);
+	iov_iter_kvec(&iter, ITER_DEST, &vec, 1, vec.iov_len);
+	ctx->dio = __iomap_dio_rw(&iocb, &iter, &dio_drain_map_ops,
+			&dio_drain_endio_ops, flags, NULL, 0);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ctx->dio);
+	ctx->drain = inode_dio_drain_get(&ctx->drain);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ctx->drain);
+	ctx->endio_error = error;
+	mutex_lock(&ctx->drain->lock);
+	inode_lock_shared(&ctx->inode);
+	KUNIT_EXPECT_EQ(test, inode_dio_drain_start(&ctx->inode, ctx->drain,
+			0, 4095), 0);
+	task = kthread_create(dio_drain_finish_io, ctx, "dio-endio-test");
+	if (IS_ERR(task)) {
+		complete(&ctx->endio_release);
+		ctx->result = iomap_dio_complete(ctx->dio);
+		KUNIT_FAIL(test, "cannot start filesystem completion");
+	} else {
+		get_task_struct(task);
+		wake_up_process(task);
+		entered = wait_for_completion_timeout(&ctx->endio_entered, HZ);
+		KUNIT_EXPECT_TRUE(test, entered);
+		KUNIT_EXPECT_EQ(test, atomic_read(&ctx->drain->pending), 1);
+		KUNIT_EXPECT_TRUE(test, inode_dio_try_begin(&ctx->inode,
+				&ctx->drain, 8192, 4096, &newer));
+		/* New disjoint I/O can finish while old end_io remains blocked. */
+		inode_dio_end_generation(&ctx->inode, newer);
+		KUNIT_EXPECT_EQ(test, atomic_read(&ctx->drain->pending), 1);
+		complete(&ctx->endio_release);
+		kthread_stop_put(task);
+	}
+	KUNIT_EXPECT_EQ(test, atomic_read(&ctx->drain->pending), 0);
+	inode_dio_drain_wait(&ctx->inode, ctx->drain);
+	inode_dio_drain_finish(&ctx->inode, ctx->drain);
+	inode_unlock_shared(&ctx->inode);
+	mutex_unlock(&ctx->drain->lock);
+	KUNIT_EXPECT_EQ(test, ctx->result, error ? (ssize_t)error : (ssize_t)4096);
+	KUNIT_EXPECT_EQ(test, iocb.ki_pos, error ? (loff_t)0 : (loff_t)4096);
+	KUNIT_EXPECT_EQ(test, iov_iter_count(&iter), (size_t)4096);
+	KUNIT_EXPECT_PTR_EQ(test, memchr_inv(vec.iov_base, 0, 4096), NULL);
+	KUNIT_EXPECT_EQ(test, atomic_read(&ctx->inode.i_dio_count) &
+			INODE_DIO_COUNT_MASK, 0);
+}
+
+static void dio_drain_iomap_endio_test(struct kunit *test)
+{
+	dio_drain_iomap_endio_check(test, 0);
+}
+
+static void dio_drain_iomap_endio_error_test(struct kunit *test)
+{
+	dio_drain_iomap_endio_check(test, -EIO);
+}
+
+/*
+ * A real bio-based block device: iomap allocates and submits the bio through
+ * the block layer.  Keeping the bio in the driver gives the test control over
+ * device completion without replacing iomap's submit or end_io callbacks.
+ */
+struct dio_test_device {
+	struct dio_drain_test *ctx;
+	struct gendisk *disk;
+	struct bio *bio;
+	struct completion submitted;
+	struct completion done;
+	struct kiocb iocb;
+	struct file file;
+	struct iov_iter iter;
+	struct kvec vec;
+	u8 *data;
+	unsigned int dio_flags;
+	unsigned int submissions;
+	unsigned int maps;
+	unsigned int endios;
+	ssize_t result;
+	ssize_t endio_size;
+	int endio_error;
+	int pending_at_endio;
+	bool partial;
+	bool beyond_end;
+};
+
+static void dio_test_submit_bio(struct bio *bio)
+{
+	struct dio_test_device *dev = bio->bi_bdev->bd_disk->private_data;
+
+	dev->submissions++;
+	dev->bio = bio;
+	complete(&dev->submitted);
+}
+
+static const struct block_device_operations dio_test_bdev_ops = {
+	.owner = THIS_MODULE,
+	.submit_bio = dio_test_submit_bio,
+};
+
+static void dio_test_free_disk(void *data)
+{
+	struct gendisk *disk = data;
+
+	del_gendisk(disk);
+	put_disk(disk);
+}
+
+static struct dio_test_device *dio_test_alloc_device(struct kunit *test)
+{
+	struct dio_drain_test *ctx = test->priv;
+	struct queue_limits lim = { .logical_block_size = 512 };
+	struct dio_test_device *dev;
+	struct gendisk *disk;
+	int error;
+
+	dev = kunit_kzalloc(test, sizeof(*dev), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, dev);
+	dev->ctx = ctx;
+	dev->data = kunit_kmalloc(test, 2 * PAGE_SIZE, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, dev->data);
+	dev->vec.iov_base = kunit_kmalloc(test, 2 * PAGE_SIZE, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, dev->vec.iov_base);
+	init_completion(&dev->submitted);
+	init_completion(&dev->done);
+	disk = blk_alloc_disk(&lim, NUMA_NO_NODE);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, disk);
+	disk->fops = &dio_test_bdev_ops;
+	disk->private_data = dev;
+	disk->flags |= GENHD_FL_HIDDEN | GENHD_FL_NO_PART;
+	strscpy(disk->disk_name, "dio-kunit", DISK_NAME_LEN);
+	set_capacity(disk, 2 * PAGE_SIZE >> SECTOR_SHIFT);
+	error = add_disk(disk);
+	if (error) {
+		put_disk(disk);
+		KUNIT_FAIL(test, "cannot add block device: %d", error);
+		return NULL;
+	}
+	error = kunit_add_action_or_reset(test, dio_test_free_disk, disk);
+	KUNIT_ASSERT_EQ(test, error, 0);
+	dev->disk = disk;
+	ctx->device = dev;
+	dev->file.f_inode = &ctx->inode;
+	dev->file.f_mapping = ctx->inode.i_mapping;
+	dev->iocb.ki_filp = &dev->file;
+	return dev;
+}
+
+static int dio_test_map(struct inode *inode, loff_t offset, loff_t length,
+		unsigned int flags, struct iomap *iomap, struct iomap *srcmap)
+{
+	struct dio_drain_test *ctx = inode->i_private;
+	struct dio_test_device *dev = ctx->device;
+
+	dev->maps++;
+	/* A second-extent fault after the first page has really been issued. */
+	if (dev->partial && offset >= PAGE_SIZE)
+		return -EFAULT;
+	iomap->type = IOMAP_MAPPED;
+	iomap->offset = offset;
+	iomap->length = PAGE_SIZE;
+	iomap->addr = dev->beyond_end ? 2 * PAGE_SIZE : offset;
+	iomap->bdev = dev->disk->part0;
+	return 0;
+}
+
+static int dio_test_endio(struct kiocb *iocb, ssize_t size, int error,
+		unsigned int flags)
+{
+	struct dio_drain_test *ctx = file_inode(iocb->ki_filp)->i_private;
+	struct dio_test_device *dev = ctx->device;
+
+	dev->endios++;
+	dev->endio_size = size;
+	dev->endio_error = error;
+	dev->pending_at_endio = atomic_read(&ctx->drain->pending);
+	return error;
+}
+
+static const struct iomap_ops dio_test_map_ops = {
+	.iomap_begin = dio_test_map,
+};
+
+static const struct iomap_dio_ops dio_test_endio_ops = {
+	.end_io = dio_test_endio,
+};
+
+static int dio_test_write(void *data)
+{
+	struct dio_test_device *dev = data;
+
+	inode_lock_shared(&dev->ctx->inode);
+	dev->result = iomap_dio_rw(&dev->iocb, &dev->iter,
+			&dio_test_map_ops, &dio_test_endio_ops,
+			dev->dio_flags, NULL, 0);
+	inode_unlock_shared(&dev->ctx->inode);
+	complete(&dev->done);
+	return 0;
+}
+
+static void dio_test_complete_bio(struct dio_test_device *dev, bool error)
+{
+	struct bio *bio = dev->bio;
+	struct bio_vec bvec;
+	struct bvec_iter iter;
+	size_t offset = bio->bi_iter.bi_sector << SECTOR_SHIFT;
+
+	if (!error) {
+		bio_for_each_segment(bvec, bio, iter) {
+			void *source = bvec_kmap_local(&bvec);
+
+			memcpy(dev->data + offset, source, bvec.bv_len);
+			kunmap_local(source);
+			offset += bvec.bv_len;
+		}
+	}
+	dev->bio = NULL;
+	bio_endio_status(bio, error ? BLK_STS_IOERR : BLK_STS_OK);
+}
+
+static void dio_drain_bio_write_check(struct kunit *test, bool partial,
+		bool beyond_end)
+{
+	struct dio_drain_test *ctx = test->priv;
+	struct dio_test_device *dev = dio_test_alloc_device(test);
+	struct task_struct *task;
+	bool generation, newer, admitted;
+	unsigned long waited;
+	int pass;
+
+	KUNIT_ASSERT_NOT_NULL(test, dev);
+	ctx->drain = inode_dio_drain_get(&ctx->drain);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ctx->drain);
+	i_size_write(&ctx->inode, 2 * PAGE_SIZE);
+	dev->partial = partial;
+	dev->beyond_end = beyond_end;
+	/* Both generation tokens must survive successful and failed writes. */
+	for (pass = 0; pass < 2; pass++) {
+		dev->vec.iov_len = partial ? 2 * PAGE_SIZE : PAGE_SIZE;
+		memset(dev->vec.iov_base, 0x5a, dev->vec.iov_len);
+		memset(dev->data, 0xa5, 2 * PAGE_SIZE);
+		dev->iocb.ki_pos = 0;
+		dev->submissions = dev->maps = dev->endios = 0;
+		reinit_completion(&dev->submitted);
+		reinit_completion(&dev->done);
+		iov_iter_kvec(&dev->iter, ITER_SOURCE, &dev->vec, 1,
+				dev->vec.iov_len);
+		KUNIT_ASSERT_TRUE(test, inode_dio_try_begin(&ctx->inode,
+				&ctx->drain, 0, dev->vec.iov_len, &generation));
+		KUNIT_EXPECT_EQ(test, generation, (bool)pass);
+		dev->dio_flags = IOMAP_DIO_ACCOUNTED |
+			(generation ? IOMAP_DIO_GENERATION : 0) |
+			(partial ? IOMAP_DIO_PARTIAL : 0);
+		mutex_lock(&ctx->drain->lock);
+		inode_lock_shared(&ctx->inode);
+		KUNIT_EXPECT_EQ(test, inode_dio_drain_start(&ctx->inode,
+				ctx->drain, 0, 2 * PAGE_SIZE - 1), 0);
+		task = kthread_create(dio_test_write, dev, "dio-bio-test");
+		if (IS_ERR(task)) {
+			inode_dio_end_generation(&ctx->inode, generation);
+			inode_dio_drain_finish(&ctx->inode, ctx->drain);
+			inode_unlock_shared(&ctx->inode);
+			mutex_unlock(&ctx->drain->lock);
+			KUNIT_FAIL(test, "cannot start direct write");
+			break;
+		}
+		get_task_struct(task);
+		wake_up_process(task);
+		if (!beyond_end) {
+			waited = wait_for_completion_timeout(&dev->submitted,
+					5 * HZ);
+			KUNIT_EXPECT_NE(test, waited, 0UL);
+			KUNIT_EXPECT_EQ(test, dev->submissions, 1U);
+			KUNIT_EXPECT_FALSE(test, completion_done(&dev->done));
+			KUNIT_EXPECT_EQ(test,
+					atomic_read(&ctx->drain->pending), 1);
+			admitted = inode_dio_try_begin(&ctx->inode,
+					&ctx->drain, 2 * PAGE_SIZE, PAGE_SIZE,
+					&newer);
+			KUNIT_EXPECT_TRUE(test, admitted);
+			if (admitted)
+				inode_dio_end_generation(&ctx->inode, newer);
+			KUNIT_EXPECT_EQ(test,
+					atomic_read(&ctx->drain->pending), 1);
+			if (dev->bio) {
+				KUNIT_EXPECT_EQ(test, bio_op(dev->bio),
+						REQ_OP_WRITE);
+				KUNIT_EXPECT_EQ(test, dev->bio->bi_iter.bi_size,
+						(unsigned int)PAGE_SIZE);
+				dio_test_complete_bio(dev, !partial);
+			}
+		}
+		waited = wait_for_completion_timeout(&dev->done, 5 * HZ);
+		KUNIT_EXPECT_NE(test, waited, 0UL);
+		kthread_stop_put(task);
+		KUNIT_EXPECT_EQ(test, dev->submissions, beyond_end ? 0U : 1U);
+		KUNIT_EXPECT_EQ(test, dev->maps, partial ? 2U : 1U);
+		KUNIT_EXPECT_EQ(test, dev->endios, 1U);
+		KUNIT_EXPECT_EQ(test, dev->endio_size, (ssize_t)PAGE_SIZE);
+		KUNIT_EXPECT_EQ(test, dev->endio_error, partial ? 0 : -EIO);
+		KUNIT_EXPECT_EQ(test, dev->pending_at_endio, 1);
+		KUNIT_EXPECT_EQ(test, dev->result,
+				partial ? (ssize_t)PAGE_SIZE : (ssize_t)-EIO);
+		KUNIT_EXPECT_EQ(test, dev->iocb.ki_pos,
+				partial ? (loff_t)PAGE_SIZE : (loff_t)0);
+		KUNIT_EXPECT_EQ(test, iov_iter_count(&dev->iter),
+				partial ? (size_t)PAGE_SIZE : (size_t)0);
+		KUNIT_EXPECT_PTR_EQ(test, memchr_inv(dev->data,
+				partial ? 0x5a : 0xa5, PAGE_SIZE), NULL);
+		KUNIT_EXPECT_PTR_EQ(test, memchr_inv(dev->data + PAGE_SIZE,
+				0xa5, PAGE_SIZE), NULL);
+		KUNIT_EXPECT_EQ(test, atomic_read(&ctx->drain->pending), 0);
+		/* No I/O remains; let accounting regressions fail without hanging. */
+		if (atomic_read(&ctx->drain->pending)) {
+			atomic_set(&ctx->drain->pending, 0);
+			wake_up_var(&ctx->inode.i_dio_count);
+		}
+		inode_dio_drain_wait(&ctx->inode, ctx->drain);
+		inode_dio_drain_finish(&ctx->inode, ctx->drain);
+		KUNIT_EXPECT_EQ(test, atomic_read(&ctx->inode.i_dio_count) &
+				INODE_DIO_COUNT_MASK, 0);
+		inode_unlock_shared(&ctx->inode);
+		mutex_unlock(&ctx->drain->lock);
+	}
+}
+
+static void dio_drain_partial_write_test(struct kunit *test)
+{
+	dio_drain_bio_write_check(test, true, false);
+}
+
+static void dio_drain_bio_completion_error_test(struct kunit *test)
+{
+	dio_drain_bio_write_check(test, false, false);
+}
+
+static void dio_drain_bio_submission_error_test(struct kunit *test)
+{
+	/* The block layer rejects this before the device can see the bio. */
+	dio_drain_bio_write_check(test, false, true);
+}
+
+struct dio_drain_race {
+	struct dio_drain_test *ctx;
+	struct kunit *test;
+	struct completion checked;
+	struct completion reader_done;
+	struct completion started;
+	struct completion finish;
+	bool release;
+	bool admitted;
+	bool registered;
+	bool generation;
+	bool timed_out;
+	int error;
+};
+
+static bool dio_drain_delayed_registration(struct inode *inode)
+{
+	struct dio_drain_test *ctx = inode->i_private;
+	struct dio_drain_race *race = ctx->race;
+	unsigned long deadline = jiffies + 5 * HZ;
+	bool generation;
+
+	/* Pause the real helper after registration, before its first pointer load. */
+	generation = atomic_fetch_inc(&inode->i_dio_count) &
+		INODE_DIO_GENERATION;
+
+	race->registered = true;
+	complete(&race->checked);
+	while (!READ_ONCE(race->release) && time_before(jiffies, deadline))
+		cpu_relax();
+	race->timed_out = !READ_ONCE(race->release);
+	return generation;
+}
+
+static int dio_drain_delayed_admission(void *data)
+{
+	struct dio_drain_race *race = data;
+	struct dio_drain_test *ctx = race->ctx;
+
+	/* Static stubs are scoped to the test associated with the current task. */
+	current->kunit_test = race->test;
+	race->admitted = inode_dio_try_begin(&ctx->inode, &ctx->drain,
+			4096, 4096, &race->generation);
+	current->kunit_test = NULL;
+	complete(&race->reader_done);
+	return 0;
+}
+
+static int dio_drain_race_publisher(void *data)
+{
+	struct dio_drain_race *race = data;
+	struct dio_drain_test *ctx = race->ctx;
+
+	mutex_lock(&ctx->drain->lock);
+	inode_lock_shared(&ctx->inode);
+	race->error = inode_dio_drain_start(&ctx->inode, ctx->drain, 4096, 8191);
+	complete(&race->started);
+	wait_for_completion(&race->finish);
+	if (!race->error) {
+		inode_dio_drain_wait(&ctx->inode, ctx->drain);
+		inode_dio_drain_finish(&ctx->inode, ctx->drain);
+	}
+	inode_unlock_shared(&ctx->inode);
+	mutex_unlock(&ctx->drain->lock);
+	return 0;
+}
+
+static void dio_drain_delayed_admission_test(struct kunit *test)
+{
+	struct dio_drain_test *ctx = test->priv;
+	struct dio_drain_race race = { .ctx = ctx, .test = test };
+	struct task_struct *reader, *publisher = NULL;
+	struct inode_dio_drain *drain;
+	unsigned long deadline;
+	bool checked, published = false;
+	int cpu, pending = 0, error = 0;
+
+	if (num_online_cpus() < 2) {
+		kunit_skip(test, "requires two online CPUs");
+		return;
+	}
+	init_completion(&race.checked);
+	init_completion(&race.reader_done);
+	init_completion(&race.started);
+	init_completion(&race.finish);
+	ctx->race = &race;
+	kunit_activate_static_stub(test, inode_dio_begin_generation,
+			dio_drain_delayed_registration);
+	reader = kthread_create(dio_drain_delayed_admission, &race, "dio-admit-test");
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, reader);
+	get_task_struct(reader);
+	cpu = cpumask_any_but(cpu_online_mask, raw_smp_processor_id());
+	kthread_bind(reader, cpu);
+	wake_up_process(reader);
+	checked = wait_for_completion_timeout(&race.checked, HZ);
+	if (!checked)
+		goto out_reader;
+	/* First publication occurs while a registered admission is paused. */
+	drain = inode_dio_drain_get(&ctx->drain);
+	if (IS_ERR(drain)) {
+		error = PTR_ERR(drain);
+		goto out_reader;
+	}
+	publisher = kthread_create(dio_drain_race_publisher, &race, "dio-drain-test");
+	if (IS_ERR(publisher)) {
+		error = PTR_ERR(publisher);
+		publisher = NULL;
+		goto out_reader;
+	}
+	get_task_struct(publisher);
+	wake_up_process(publisher);
+	deadline = jiffies + HZ;
+	/* Cutover must complete while the old registration remains paused. */
+	while (!completion_done(&race.started) &&
+	       time_before(jiffies, deadline))
+		usleep_range(1000, 2000);
+	/* A timeout must not turn this into an admission before publication. */
+	published = completion_done(&race.started);
+out_reader:
+	WRITE_ONCE(race.release, true);
+	wait_for_completion(&race.reader_done);
+	kthread_stop_put(reader);
+	if (publisher) {
+		wait_for_completion(&race.started);
+		pending = atomic_read(&ctx->drain->pending);
+	}
+	if (race.admitted)
+		inode_dio_end_generation(&ctx->inode, race.generation);
+	if (publisher) {
+		complete(&race.finish);
+		kthread_stop_put(publisher);
+	}
+	kunit_deactivate_static_stub(test, inode_dio_begin_generation);
+	ctx->race = NULL;
+
+	/* Report failures only after releasing both tasks and their DIO count. */
+	KUNIT_ASSERT_TRUE_MSG(test, checked, "reader did not reach registration");
+	KUNIT_ASSERT_EQ_MSG(test, error, 0, "cannot start publisher");
+	KUNIT_ASSERT_TRUE_MSG(test, published, "publisher did not publish exclusion");
+	KUNIT_EXPECT_FALSE(test, race.admitted);
+	KUNIT_EXPECT_TRUE(test, race.registered);
+	KUNIT_EXPECT_FALSE(test, race.timed_out);
+	KUNIT_EXPECT_FALSE(test, race.generation);
+	KUNIT_EXPECT_EQ(test, race.error, 0);
+	KUNIT_EXPECT_EQ(test, pending, 0);
+}
+
+/* Even when a publisher is suspended, the selected copy remains readable. */
+static void dio_drain_latch_interrupted_writer_test(struct kunit *test)
+{
+	struct dio_drain_test *ctx = test->priv;
+	struct inode_dio_drain *drain;
+
+	drain = inode_dio_drain_get(&ctx->drain);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, drain);
+	mutex_lock(&drain->lock);
+	write_seqcount_latch_begin(&drain->range_seq);
+	drain->range[0].active = true;
+	drain->range[0].start = 4096;
+	drain->range[0].last = 8191;
+	/* Odd copy is still inactive while the even copy is being replaced. */
+	KUNIT_EXPECT_FALSE(test, inode_dio_drain_overlap(&ctx->inode, drain,
+			4096, 4096));
+	write_seqcount_latch(&drain->range_seq);
+	/* Even copy is now complete while the odd copy is being replaced. */
+	KUNIT_EXPECT_TRUE(test, inode_dio_drain_overlap(&ctx->inode, drain,
+			4096, 4096));
+	KUNIT_EXPECT_FALSE(test, inode_dio_drain_overlap(&ctx->inode, drain,
+			8192, 4096));
+	drain->range[1] = drain->range[0];
+	write_seqcount_latch_end(&drain->range_seq);
+	mutex_unlock(&drain->lock);
+}
+
+static void dio_drain_repeated_cutover_test(struct kunit *test)
+{
+	struct dio_drain_test *ctx = test->priv;
+	bool old, rejected;
+	int i;
+
+	ctx->drain = inode_dio_drain_get(&ctx->drain);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ctx->drain);
+	mutex_lock(&ctx->drain->lock);
+	inode_lock_shared(&ctx->inode);
+	for (i = 0; i < 128; i++) {
+		loff_t pos = (i & 1) ? 4096 : 8192;
+
+		KUNIT_EXPECT_TRUE(test, inode_dio_try_begin(&ctx->inode,
+				&ctx->drain, pos, 4096, &old));
+		KUNIT_EXPECT_EQ(test, inode_dio_drain_start(&ctx->inode,
+				ctx->drain, pos, pos + 4095), 0);
+		KUNIT_EXPECT_FALSE(test, inode_dio_try_begin(&ctx->inode,
+				&ctx->drain, pos, 4096, &rejected));
+		KUNIT_EXPECT_EQ(test, atomic_read(&ctx->drain->pending), 1);
+		inode_dio_end_generation(&ctx->inode, old);
+		KUNIT_EXPECT_EQ(test, atomic_read(&ctx->drain->pending), 0);
+		inode_dio_drain_wait(&ctx->inode, ctx->drain);
+		inode_dio_drain_finish(&ctx->inode, ctx->drain);
+		KUNIT_EXPECT_FALSE(test, inode_dio_drain_overlap(&ctx->inode,
+				ctx->drain, pos, 4096));
+	}
+	KUNIT_EXPECT_EQ(test, atomic_read(&ctx->inode.i_dio_count) &
+			INODE_DIO_COUNT_MASK, 0);
+	inode_unlock_shared(&ctx->inode);
+	mutex_unlock(&ctx->drain->lock);
+}
+
+static struct kunit_case dio_drain_test_cases[] = {
+	KUNIT_CASE(dio_drain_cohort_test),
+	KUNIT_CASE(dio_drain_iomap_ownership_test),
+	KUNIT_CASE(dio_drain_iomap_errors_test),
+	KUNIT_CASE(dio_drain_iomap_endio_test),
+	KUNIT_CASE(dio_drain_iomap_endio_error_test),
+	KUNIT_CASE(dio_drain_partial_write_test),
+	KUNIT_CASE(dio_drain_bio_completion_error_test),
+	KUNIT_CASE(dio_drain_bio_submission_error_test),
+	KUNIT_CASE(dio_drain_delayed_admission_test),
+	KUNIT_CASE(dio_drain_latch_interrupted_writer_test),
+	KUNIT_CASE(dio_drain_repeated_cutover_test),
+	{}
+};
+
+static struct kunit_suite dio_drain_test_suite = {
+	.name = "inode-dio-drain",
+	.init = dio_drain_test_init,
+	.exit = dio_drain_test_exit,
+	.test_cases = dio_drain_test_cases,
+};
+
+kunit_test_suite(dio_drain_test_suite);
+MODULE_DESCRIPTION("KUnit tests for generation-based direct I/O draining");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 016f621345af..3eb62a40ea21 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3222,11 +3222,16 @@ static inline bool inode_dio_drain_overlap(struct inode *inode,
 	return range.active && last >= range.start && pos <= range.last;
 }
 
+/* Test builds need a single function address for the registration stub. */
+#if IS_ENABLED(CONFIG_DIO_DRAIN_KUNIT_TEST)
+bool inode_dio_begin_generation(struct inode *inode);
+#else
 static inline bool inode_dio_begin_generation(struct inode *inode)
 {
 	return atomic_fetch_inc(&inode->i_dio_count) &
 		INODE_DIO_GENERATION;
 }
+#endif
 
 static inline void inode_dio_end_generation(struct inode *inode, bool generation)
 {
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 611c37c19f82..f6652f5d8ac5 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -723,6 +723,10 @@ struct iomap_dio_ops {
 ssize_t iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 		const struct iomap_ops *ops, const struct iomap_dio_ops *dops,
 		unsigned int dio_flags, void *private, size_t done_before);
+#if IS_ENABLED(CONFIG_DIO_DRAIN_KUNIT_TEST)
+struct iomap_dio *iomap_dio_alloc(void);
+#endif
+
 struct iomap_dio *__iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 		const struct iomap_ops *ops, const struct iomap_dio_ops *dops,
 		unsigned int dio_flags, void *private, size_t done_before);
-- 
2.56.0

