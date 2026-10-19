Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792434395;
	b=u0Ome7XscBvZmndiWnuQjfiSbtD+ZIRRJtcai/4Msi3qu0rDyKLCCy9qaOdJpgMdiDcK
	 GsSfOeLKTLFg4MdoYAaLSORo4TxVNUCUCd/gXqnIDhhRsp/arAfwSs/jEohlLrBiNtZl+
	 fPJdWt76KaJ27Dtsee0027j5Y/D9fxqhpxnkrMoKVWTvWxG6thrS6ZJoaWqK+miu7Jcs0
	 EaY/nDDGABNyPJjqmHwL6sjryxEwQXy0kLHmAhy33wuDFzfiyZGX5a7Qz7uZ2BLPwynl+
	 0+hm1erTyCWkC3gwyismsrUg5yyC5PlZgtTmjfMkzSr9XSo8Y0v195l6SfPs3MI4jeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792434395;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=aZEzc877oy/TNdXlByP4My2ZSkAN5TmErJJ9Zokx+6Q=;
	b=JtbfkohcE8OP2uMoci7lK74Jk4tA3L/5DFe5HPejkIKQYPc40Old5b8kbdDpjW/BRoEe
	 I5pabNWXOyumZx0zY9S+xYs5BvESAruue3aGfb8IVIgWrJ6c7r1nwg3ps7UfFMSXBO6NE
	 /X1kUxNj5d5LlNLNu0auUd0Coa7RTR4VB3dadqywASclMMemxz+fgtdQoM198W2DP2eTn
	 WjJV2IaXyV8uG9DgSKgYBI6kJDFav2584Q7VQiD6Ed1xqGZc7EzDUKjWiifR+UVup8VQG
	 NQC+BaqnqAmnPr2dcRIg4EfAwagXD2LE8EOcMb5/EnrNhrcR9K5pyK13ABz/2lOOxnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=XoNJqSM8;
	arc=none smtp.remote-ip=209.85.214.181
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72519606A336
	for <linux-xfs@vger.kernel.org>; Mon, 19 Oct 2026 18:26:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 72519606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=XoNJqSM8
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2e96502e447so17587955ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 19 Oct 2026 11:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792434394; x=1793039194; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=aZEzc877oy/TNdXlByP4My2ZSkAN5TmErJJ9Zokx+6Q=;
        b=XoNJqSM8uvbr7c2HW5ucpfblF8CJEP5D3XILrDOzhnCetvtCXQ2oeGR1xh01DQsQds
         Ty5akiGZpGKxe2lLaRiEcyrKu6fyzjCgXNZvPH7cYfLbEol6R76Wm4W6AI55FUr23Lea
         Ry9FWBm9wTMXOQF4bQBLJRO41a48VebMldfAWpFvjVA6vcWo09rFADLMwXJtXftef3en
         7nHOV1gsv7aBZvI2fzkDJ8rvn8761GVIZZJr3Hc9ZPWZmT1vaYf1zx0CpW0IeyAT5/Rh
         Cans8W1zVKc6+mfDjfhBEwEPgcd1oacFIbZNPvQxlCPFxlntjTsFObtthD/ZH2UP9hpO
         LlmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792434394; x=1793039194;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=aZEzc877oy/TNdXlByP4My2ZSkAN5TmErJJ9Zokx+6Q=;
        b=nl2+9mevzKBQuP3jx4e1PBNJ0+NZl+szqebH9mqIdKPUeMpRVlwCTUhInyGziBLjpp
         mqzXZR9DXSkKz59GleOWtzt3HKyyWtaqU7kxDe/ZUbJganQYpguBbHLa0cvxHbXYLdPO
         yrm3cHSdv8tLR5bc4nzbzm/V16vF1KaQPR8RMLvHwB37wVJc5DG3Kc1S5wNZrTbGTUjO
         gLIFtns/8ggnAj53elkwJIhCH7xlc10To1/eBo21+HQVnEm6QDpebyOJq5lHpT4GhhXg
         MCL/uWrasL13PUjdTPYOUlCUvIb94faT4i+mSSfOpM6Wf9bQK4X8c9N6HJYY4ikRr4rb
         iIlQ==
X-Gm-Message-State: AFq9FYIf3vYNzQZ6SntkTUlwtCYDfeF2gVM+MBmhp69tpLDGeJ0c3YZt
	ysxkk9UnvUliaTbSgRwJ8iqBkJYbpY/xn13bbDJPPrOaacrQr2n6q3kBEV614W6v
X-Gm-Gg: AYBFou1TEa3f+hduFTIq0Xwi7ojftgfbY/mhd2U99RZDajn2a2Wfzl/ixzY48er5cy7
	qAQk/iQoLRM5JZWmQLJ21uBUevURxx0VUrPrcHAkLmCXGh0jkQJb9yvcZoUnbOh7pnsT46U1jlc
	AIa3lZIKyKuovoridhoVRCti/ueqUO2iiAbAJ/m07cCqAPIkSixTVyigweSF4YxDMnX3XkBmZ+V
	Y8c0g0U469bLZVE9Q1KNMLY+ZD2XLKBMaOUgqVOZKvQKJZoUUAgkaHzoy1V+l+UXutFWcnxQh1X
	g79Itht2ys9j/7B4RoHZUukGmQMOcKjY0GTRW3MRCZEzv1dTtVQCPRz7SEo/gM4irF0A9rqoxKs
	Bgz3sYSWd6npUmT9OBmgkCxOY8BS/gk2OWQUU4ujJLmxRI61SD0aHG+I1bQn2cY2YY2LWrxMBT3
	8Dl4ecu71QnNeiZ0bYJCcCQE9bj+BwigHaVaKk5rfF38TErcIS8CJnTc2LKmk/YB79b6viUPoQG
	QRIoH1UOpZSaBLUQdQGdR9bz6eTxDNQLrMAJtRT0dMiE9a3kg==
X-Received: by 2002:a17:902:d506:b0:2e9:5ed2:c39d with SMTP id d9443c01a7336-2e9a6f528a8mr78958125ad.36.1792434393330;
        Mon, 19 Oct 2026 11:26:33 -0700 (PDT)
Received: from archlinux.tail3acd4.ts.net ([69.110.143.170])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea1517e7cfsm4156375ad.58.2026.10.19.11.26.32
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 11:26:32 -0700 (PDT)
From: Vitali Lovich <vlovich@gmail.com>
To: linux-xfs@vger.kernel.org
Subject: [RFC PATCH v1 3/6] fs: add KUnit coverage for generation-based DIO draining
Date: Mon, 19 Oct 2026 11:26:17 -0700
Message-ID: <20261019182620.1527591-4-vlovich@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261019182620.1527591-1-vlovich@gmail.com>
References: <20261019182620.1527591-1-vlovich@gmail.com>
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

Signed-off-by: Vitali Lovich <vlovich@gmail.com>
---
 fs/Kconfig                 |  13 ++
 fs/Makefile                |   1 +
 fs/inode.c                 |  13 ++
 fs/tests/dio_drain_kunit.c | 393 +++++++++++++++++++++++++++++++++++++
 include/linux/fs.h         |   5 +
 5 files changed, 425 insertions(+)
 create mode 100644 fs/tests/dio_drain_kunit.c

diff --git a/fs/Kconfig b/fs/Kconfig
index e05917adcd60..4d4fff6e217b 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -421,4 +421,17 @@ source "fs/unicode/Kconfig"
 config IO_WQ
 	bool
 
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
index 055dfc23d82b..55714a15a8d1 100644
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
index cb35eefe0d40..4642a1977c01 100644
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
@@ -2772,6 +2775,16 @@ bool inode_dio_finished(const struct inode *inode)
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
diff --git a/fs/tests/dio_drain_kunit.c b/fs/tests/dio_drain_kunit.c
new file mode 100644
index 000000000000..7681b1e7c534
--- /dev/null
+++ b/fs/tests/dio_drain_kunit.c
@@ -0,0 +1,393 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <kunit/static_stub.h>
+#include <kunit/test.h>
+#include <linux/completion.h>
+#include <linux/delay.h>
+#include <linux/fs.h>
+#include <linux/iomap.h>
+#include <linux/kthread.h>
+#include <linux/module.h>
+#include <linux/uio.h>
+
+struct dio_drain_race;
+
+struct dio_drain_test {
+	struct inode inode;
+	struct super_block sb;
+	struct inode_dio_drain *drain;
+	struct dio_drain_race *race;
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
index e5c2e857e530..02a33ed754b7 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3216,11 +3216,16 @@ static inline bool inode_dio_drain_overlap(struct inode *inode,
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
-- 
2.56.0

