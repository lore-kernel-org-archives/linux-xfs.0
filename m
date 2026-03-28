Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F855433AD
	for <linux-xfs@vger.kernel.org>; Sat, 28 Mar 2026 07:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774681986; cv=none; b=NXkxuxgii+OH52OrNyF2/vEWjuY95tVotAyoipwzb3w68kn/FJyx3r84MEwCYLotWdHOblu8MxgXOdzO5raqn6u92tDjZP1Ho7H90rLA0UgL2OvIujba9fARmdVOE6/2j8V8kdAViGPw7GlUI9SiEx+abBnGedVYGuuANGNNeG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774681986; c=relaxed/simple;
	bh=Zl40lDMRXbaVcmxrfhwFmjA3aXPPuygFwS4xWPJ9joo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tyy+yirqaAWeD3AWZD1MnNYpWe1wlXuolNGxMbM1VpxE7L3tAQ73am82Lsr92c1OKVk9eYMeE3RhXdCQbLbvZOm13YCK42N8GhuVPWbXVscCd1vn/ZBoxwLqy6Pm6e4iosbz4B0pgB7lRtQuBkX/4OEM+IC7nBcKeQnYoLjsOCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WSd1yIA2; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WSd1yIA2"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2b07069e2efso17483725ad.3
        for <linux-xfs@vger.kernel.org>; Sat, 28 Mar 2026 00:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774681983; x=1775286783; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=baCNZxwB/rQKt0J2IHHt1Ov73f0fjFyvK7XU44fQQWw=;
        b=WSd1yIA2Y8FuLMLKByVUNkIG5xV9YhWJ0DM8GPlPWMFAzmJLNitLz2vc/LtR9gVsLc
         /E4PUQhdbY6iD3OIiFTpC/xZHe5RDiAeRAMtrclKYUWE6dcCLeWMHaHTUzR5h1LhSbmb
         kI6xXLSF57K1MFqY22jmGPvKEYEHz3n5X2nRzlv0vkyaInZ0r/6+dywv2ZzsuZD01LJt
         xo0xzupwKbjX84CewRzsBsruXp3S+pCmnqM71w7OR7c00RB7pYQJ1mAzv/ZnTp6MEPRm
         s4lEyoSr2nw4ev+KbXCQcpBUTSdkljIPFMCmbyPClvQEzV7SGhLAgarixW09JYzJu+3O
         6ylw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774681983; x=1775286783;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=baCNZxwB/rQKt0J2IHHt1Ov73f0fjFyvK7XU44fQQWw=;
        b=nrX4pYkQfv1NVyBQ2u0zuBbkUuVxYxGHYEfR3JJXd+MDcrq4HuuJnLIMZDvoD1/q4x
         c0kD+wPW+meLK7/x+HOKu30arbS40UYM0PaVmiQQvJmtHoMNWrKriSR+ki3hEl5jnF2V
         uSYSfoJCd7xFEp4p/QeACm/soJcHh4EIrPENzaaWCe5nWaMJ6Rvzxij9RTzW3h0Q93+1
         g6Q4IKZ//DCam7sHWtYUGUqKxGnmmbTiPIgDRypym9lNLunDpEPyiQIH4SroLXd+pkLX
         x9bqlasNu8KL0f1rVQb6slCGoQ4MCmmORn/pw+3Iaub1IBVin4t1iW1/E+eZTmcpqmRs
         lswQ==
X-Gm-Message-State: AOJu0YyvNMsA7xb/UXMd/dmGq+jAdtzRHl1MEnnVFHXVginXgO59UBPI
	V28FWpeBkSTMDE6RAYFRjDhRY0tvHGrcN76B3LiEQ1vFLtsXiRQG6X2q
X-Gm-Gg: ATEYQzx4zrS47tfpHIlHhc/G+Oq4Zcb7dw/80MbwJZS+NcsZrt0TseSPQRlo0iR1og5
	VLarq6caGAWKYn1X4tBRc5X2UVojr0WFcGSsdGxUR9G30CiftUVjEOnbpcDIFDExgSZj9+sA7c0
	xsVYdDKFePQk1fAV/IDzYdTxVPfzzzk05cuSiyT3+1YoBfXS/+615mkcl7tQ36vm/jEHTdNVAwt
	6O4f0mKNs1vsMdEKm2nm8U+uuNPmBYGXey13hP7G1zA/mo+s9UaIJ8Wp/6Jy5rFfU4YdZiHC4er
	ZU9jfY5mE2HIUdfZfgO4K+KnvHjgtDqn9zi/awLgLqyR9LlfTnFUWFhQSs2DIwcc2QiyJSfsIU9
	gvRKne0L69quBOHXdzSGOAfoB1QEPYp+hLLgl7lFLVXhZS1lw2MTYrq0dFbDe/BaG3DYvNzEEx4
	mXCCCdIjazDtKyvaHl7VH+9JfehikflnMA4nQpocy26PBe1EZaU1d1w5EIeP+iyTRK5zi5jYo=
X-Received: by 2002:a17:902:cf04:b0:2b2:41a9:8e0c with SMTP id d9443c01a7336-2b241a99045mr23205865ad.17.1774681983158;
        Sat, 28 Mar 2026 00:13:03 -0700 (PDT)
Received: from kernel-fuzz.. ([103.172.182.26])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2427b1ef0sm17083905ad.74.2026.03.28.00.12.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Mar 2026 00:13:02 -0700 (PDT)
From: ZhengYuan Huang <gality369@gmail.com>
To: cem@kernel.org,
	dchinner@redhat.com,
	djwong@kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	r33s3n6@gmail.com,
	zzzccc427@gmail.com,
	ZhengYuan Huang <gality369@gmail.com>
Subject: [PATCH] xfs: avoid inodegc worker flush deadlock
Date: Sat, 28 Mar 2026 15:12:51 +0800
Message-ID: <20260328071252.3936506-1-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[BUG]
WARNING: possible recursive locking detected
--------------------------------------------
kworker/0:1/10 is trying to acquire lock:
ffff88801621fd48 ((wq_completion)xfs-inodegc/ublkb1){+.+.}-{0:0}, at: touch_wq_lockdep_map+0x99/0x1c0 kernel/workqueue.c:3936

but task is already holding lock:
ffff88801621fd48 ((wq_completion)xfs-inodegc/ublkb1){+.+.}-{0:0}, at: process_one_work+0x1188/0x1980 kernel/workqueue.c:3238

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock((wq_completion)xfs-inodegc/ublkb1);
  lock((wq_completion)xfs-inodegc/ublkb1);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

2 locks held by kworker/0:1/10:
 #0: ffff88801621fd48 ((wq_completion)xfs-inodegc/ublkb1){+.+.}-{0:0}, at: process_one_work+0x1188/0x1980 kernel/workqueue.c:3238
 #1: ffff888009dafce8 ((work_completion)(&(&gc->work)->work)){+.+.}-{0:0}, at: process_one_work+0x865/0x1980 kernel/workqueue.c:3239

stack backtrace:
Workqueue: xfs-inodegc/ublkb1 xfs_inodegc_worker
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0xbe/0x130 lib/dump_stack.c:120
 dump_stack+0x15/0x20 lib/dump_stack.c:129
 print_deadlock_bug+0x23f/0x320 kernel/locking/lockdep.c:3041
 check_deadlock kernel/locking/lockdep.c:3093 [inline]
 validate_chain kernel/locking/lockdep.c:3895 [inline]
 __lock_acquire+0x1317/0x21e0 kernel/locking/lockdep.c:5237
 lock_acquire kernel/locking/lockdep.c:5868 [inline]
 lock_acquire+0x169/0x2f0 kernel/locking/lockdep.c:5825
 touch_wq_lockdep_map+0xab/0x1c0 kernel/workqueue.c:3936
 __flush_workqueue+0x117/0x1010 kernel/workqueue.c:3978
 xfs_inodegc_wait_all fs/xfs/xfs_icache.c:495 [inline]
 xfs_inodegc_flush+0x9a/0x390 fs/xfs/xfs_icache.c:2020
 xfs_blockgc_flush_all+0x106/0x250 fs/xfs/xfs_icache.c:1614
 xfs_trans_alloc+0x5e4/0xc10 fs/xfs/xfs_trans.c:268
 xfs_inactive_ifree+0x329/0x3c0 fs/xfs/xfs_inode.c:1224
 xfs_inactive+0x590/0xb60 fs/xfs/xfs_inode.c:1485
 xfs_inodegc_inactivate fs/xfs/xfs_icache.c:1942 [inline]
 xfs_inodegc_worker+0x241/0x650 fs/xfs/xfs_icache.c:1988
 process_one_work+0x8e0/0x1980 kernel/workqueue.c:3263
 process_scheduled_works kernel/workqueue.c:3346 [inline]
 worker_thread+0x683/0xf80 kernel/workqueue.c:3427
 kthread+0x3f0/0x850 kernel/kthread.c:463
 ret_from_fork+0x50f/0x610 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

[CAUSE]

If xfs_trans_alloc() hits -ENOSPC while xfs_inodegc_worker() is
inactivating an unlinked inode, the retry path runs
xfs_blockgc_flush_all() and recurses into xfs_inodegc_flush().
xfs_inodegc_wait_all() then calls flush_workqueue() on m_inodegc_wq
from an inodegc worker, which waits for the current in-flight work
item and deadlocks.

[FIX]

Detect when xfs_inodegc_wait_all() is running from an inodegc worker
and flush every other per-cpu inodegc work item directly instead of
flushing the whole workqueue. This preserves the intent of waiting
for background inodegc reclaim while avoiding recursion on the current
worker. Also collect inodegc errors from all possible CPUs because
running workers clear their cpumask bit before processing inodes.

Fixes: d4d12c02bf5f ("xfs: collect errors from inodegc for unlinked inode recovery")
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
 fs/xfs/xfs_icache.c | 50 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 49 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index e44040206851..cdb707332b4b 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -484,16 +484,64 @@ xfs_inodegc_queue_all(
 	return ret;
 }
 
+/*
+ * flush_workqueue() waits for all in-flight work items, including the current
+ * one.  If xfs_trans_alloc() hits ENOSPC while an inodegc worker is freeing an
+ * unlinked inode, xfs_blockgc_flush_all() recurses into xfs_inodegc_flush().
+ * Waiting for the current worker there deadlocks because the flush cannot
+ * complete until this work function returns.
+ */
+static struct xfs_inodegc *
+xfs_inodegc_current(struct xfs_mount *mp)
+{
+	struct work_struct	*work = current_work();
+	int			cpu;
+
+	if (!work)
+		return NULL;
+
+	for_each_possible_cpu(cpu) {
+		struct xfs_inodegc	*gc = per_cpu_ptr(mp->m_inodegc, cpu);
+
+		if (work == &gc->work.work)
+			return gc;
+	}
+
+	return NULL;
+}
+
 /* Wait for all queued work and collect errors */
 static int
 xfs_inodegc_wait_all(
 	struct xfs_mount	*mp)
 {
+	struct xfs_inodegc	*current_gc = xfs_inodegc_current(mp);
 	int			cpu;
 	int			error = 0;
 
+	if (current_gc) {
+		/*
+		 * current_gc is already in flight, so waiting for the whole
+		 * workqueue would recurse on ourselves.  Flush every other
+		 * per-cpu work item instead so that ENOSPC retries still wait
+		 * for the rest of the inodegc work to finish.
+		 */
+		for_each_possible_cpu(cpu) {
+			struct xfs_inodegc	*gc;
+
+			gc = per_cpu_ptr(mp->m_inodegc, cpu);
+			if (gc == current_gc)
+				continue;
+			flush_delayed_work(&gc->work);
+			if (gc->error && !error)
+				error = gc->error;
+			gc->error = 0;
+		}
+		return error;
+	}
+
 	flush_workqueue(mp->m_inodegc_wq);
-	for_each_cpu(cpu, &mp->m_inodegc_cpumask) {
+	for_each_possible_cpu(cpu) {
 		struct xfs_inodegc	*gc;
 
 		gc = per_cpu_ptr(mp->m_inodegc, cpu);
-- 
2.43.0

