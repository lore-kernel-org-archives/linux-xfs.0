Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD881607B2;
	Wed,  1 May 2024 18:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714588896; cv=none; b=YivKKcSeWChz91lv4hrGguqVt2+hbfaIFC42ycvg7yid7p7hQIAcH4poVHI/ZRY1mSud/g+l8NurvU0CMzFpaeYyK2u3r5QOcI9KSanZBAEEYYDF4iTBQu61STMHywm4Nwbz+6iDU4Xq/1Vvbk2OPwekXghSc1ensMwhb8C5VtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714588896; c=relaxed/simple;
	bh=6+hrjg81qrAIO9cTvm/Y+R1pMVYG303SCYDZl3Ffr00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nqny8FvJaNOO1alna6GtSPnwmPw16CJkxWwqeYi/IM6sGSCsBhV4ceqsQ9GfF0pp6rQTzjib759FleXbQxusGYMmYCbGronIa/XlEn1CnRqLL7CjUUGIPmeENVs0uXwBOCWlQ5MqwfT+rfFcCfpsG9bhu3UjE9pwdFSM0uw6mUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ipGKe0si; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ipGKe0si"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-6f074520c8cso6758135b3a.0;
        Wed, 01 May 2024 11:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714588894; x=1715193694; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0QwCxkiidm1+UTwX4UdpCI7EfB4mPKiuL9ct1Q2HPwE=;
        b=ipGKe0siqR8rfySknG9JsFRyR98E4ZCA3aRl0dxPyU/DIeRIzKLqjXtRxjiuhRJLyY
         3hQpLFTq32nzPIagyuKBfbBGjEIswDcRVhJr1hJwd+g7hr6aO9VyjAM/umgPQGm/RAip
         BJVZHTeOBVa1Nc0Xavv8WYQ9DvrfzlF48Y4H9BWfeL/ZQbwwato3//O4IYbpHPOBQf1p
         bDj+uKh+5hS7ykrV2RtFH5r/NYhz6lOgTzO5uAyUclGTM3CHq2qj7/ka4PpHPqPRd8bI
         lwTNJ/OqInJJGRcP+b767B22RRabMoMxwIz771f3IKUfvR4apYkVgkmHg2MgovPV6Cb8
         DFzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714588894; x=1715193694;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0QwCxkiidm1+UTwX4UdpCI7EfB4mPKiuL9ct1Q2HPwE=;
        b=KWJZd9vcmos9LBQVBrpxnZc+mSRLMZ7zyf5xnjE8b/uo38XKnw1w8tlXsV6RXjqXxB
         l/G/DZ61qrvJ0AbN1PuW8XBN59AZ5Kx7O5oTX0fjhTq8KIZmz7/x56YYCvuV0o9niQ1Y
         glUyigo2f6Q/Cs3Fx1dIgIKJJrYbW2wRgtahbV0wZayXFiNu3rreZIJ1j9AcESg3w3CQ
         LzcBbdlbc5DWv3ZdjYf67BHkqOCi5XnYBIQLgJgTQpVeg8UabD18fXnsyPzHjQe9iIHM
         1fVGTyFkuXOkAM1x71gEhVu3sVD0ndY7pTYsqTqE3Bf5DUJtwA0GHZ2AatjD4c3rFGEB
         bVoA==
X-Gm-Message-State: AOJu0YxTSgk9Lm8VRL6/1HPY7z3ruPQGJBlWmLaJeagmwjZGSdc5wjp2
	FO/XTMwLR9yvy5i0q/Fx6TQUBACB4xLEId/xZdazfWpXs8t6NMvwZSlhRS88
X-Google-Smtp-Source: AGHT+IF3UvVeXASZo52c08/+1ntnQ2sJxHAzyHZY/AwNtf1qBgpEAOjP84sxY5PGMJRggUJwk0BatA==
X-Received: by 2002:a05:6a20:560c:b0:1ad:89e:21b5 with SMTP id ir12-20020a056a20560c00b001ad089e21b5mr3716369pzc.15.1714588892212;
        Wed, 01 May 2024 11:41:32 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:9dbc:724d:6e88:fb08])
        by smtp.gmail.com with ESMTPSA id j18-20020a62e912000000b006e681769ee0sm23687369pfh.145.2024.05.01.11.41.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 May 2024 11:41:31 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	chandan.babu@oracle.com,
	fred@cloudflare.com,
	Guo Xuenan <guoxuenan@huawei.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 16/24] xfs: wait iclog complete before tearing down AIL
Date: Wed,  1 May 2024 11:41:04 -0700
Message-ID: <20240501184112.3799035-16-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
In-Reply-To: <20240501184112.3799035-1-leah.rumancik@gmail.com>
References: <20240501184112.3799035-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Guo Xuenan <guoxuenan@huawei.com>

[ Upstream commit 1eb52a6a71981b80f9acbd915acd6a05a5037196 ]

Fix uaf in xfs_trans_ail_delete during xlog force shutdown.
In commit cd6f79d1fb32 ("xfs: run callbacks before waking waiters in
xlog_state_shutdown_callbacks") changed the order of running callbacks
and wait for iclog completion to avoid unmount path untimely destroy AIL.
But which seems not enough to ensue this, adding mdelay in
`xfs_buf_item_unpin` can prove that.

The reproduction is as follows. To ensure destroy AIL safely,
we should wait all xlog ioend workers done and sync the AIL.

==================================================================
BUG: KASAN: use-after-free in xfs_trans_ail_delete+0x240/0x2a0
Read of size 8 at addr ffff888023169400 by task kworker/1:1H/43

CPU: 1 PID: 43 Comm: kworker/1:1H Tainted: G        W
6.1.0-rc1-00002-gc28266863c4a #137
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
Workqueue: xfs-log/sda xlog_ioend_work
Call Trace:
 <TASK>
 dump_stack_lvl+0x4d/0x66
 print_report+0x171/0x4a6
 kasan_report+0xb3/0x130
 xfs_trans_ail_delete+0x240/0x2a0
 xfs_buf_item_done+0x7b/0xa0
 xfs_buf_ioend+0x1e9/0x11f0
 xfs_buf_item_unpin+0x4c8/0x860
 xfs_trans_committed_bulk+0x4c2/0x7c0
 xlog_cil_committed+0xab6/0xfb0
 xlog_cil_process_committed+0x117/0x1e0
 xlog_state_shutdown_callbacks+0x208/0x440
 xlog_force_shutdown+0x1b3/0x3a0
 xlog_ioend_work+0xef/0x1d0
 process_one_work+0x6f9/0xf70
 worker_thread+0x578/0xf30
 kthread+0x28c/0x330
 ret_from_fork+0x1f/0x30
 </TASK>

Allocated by task 9606:
 kasan_save_stack+0x1e/0x40
 kasan_set_track+0x21/0x30
 __kasan_kmalloc+0x7a/0x90
 __kmalloc+0x59/0x140
 kmem_alloc+0xb2/0x2f0
 xfs_trans_ail_init+0x20/0x320
 xfs_log_mount+0x37e/0x690
 xfs_mountfs+0xe36/0x1b40
 xfs_fs_fill_super+0xc5c/0x1a70
 get_tree_bdev+0x3c5/0x6c0
 vfs_get_tree+0x85/0x250
 path_mount+0xec3/0x1830
 do_mount+0xef/0x110
 __x64_sys_mount+0x150/0x1f0
 do_syscall_64+0x35/0x80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Freed by task 9662:
 kasan_save_stack+0x1e/0x40
 kasan_set_track+0x21/0x30
 kasan_save_free_info+0x2a/0x40
 __kasan_slab_free+0x105/0x1a0
 __kmem_cache_free+0x99/0x2d0
 kvfree+0x3a/0x40
 xfs_log_unmount+0x60/0xf0
 xfs_unmountfs+0xf3/0x1d0
 xfs_fs_put_super+0x78/0x300
 generic_shutdown_super+0x151/0x400
 kill_block_super+0x9a/0xe0
 deactivate_locked_super+0x82/0xe0
 deactivate_super+0x91/0xb0
 cleanup_mnt+0x32a/0x4a0
 task_work_run+0x15f/0x240
 exit_to_user_mode_prepare+0x188/0x190
 syscall_exit_to_user_mode+0x12/0x30
 do_syscall_64+0x42/0x80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

The buggy address belongs to the object at ffff888023169400
 which belongs to the cache kmalloc-128 of size 128
The buggy address is located 0 bytes inside of
 128-byte region [ffff888023169400, ffff888023169480)

The buggy address belongs to the physical page:
page:ffffea00008c5a00 refcount:1 mapcount:0 mapping:0000000000000000
index:0xffff888023168f80 pfn:0x23168
head:ffffea00008c5a00 order:1 compound_mapcount:0 compound_pincount:0
flags: 0x1fffff80010200(slab|head|node=0|zone=1|lastcpupid=0x1fffff)
raw: 001fffff80010200 ffffea00006b3988 ffffea0000577a88 ffff88800f842ac0
raw: ffff888023168f80 0000000000150007 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888023169300: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888023169380: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff888023169400: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff888023169480: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888023169500: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================
Disabling lock debugging due to kernel taint

Fixes: cd6f79d1fb32 ("xfs: run callbacks before waking waiters in xlog_state_shutdown_callbacks")
Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log.c | 36 +++++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index f02a0dd522b3..60b19f6d7077 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -886,6 +886,23 @@ xlog_force_iclog(
 	return xlog_state_release_iclog(iclog->ic_log, iclog, NULL);
 }
 
+/*
+ * Cycle all the iclogbuf locks to make sure all log IO completion
+ * is done before we tear down these buffers.
+ */
+static void
+xlog_wait_iclog_completion(struct xlog *log)
+{
+	int		i;
+	struct xlog_in_core	*iclog = log->l_iclog;
+
+	for (i = 0; i < log->l_iclog_bufs; i++) {
+		down(&iclog->ic_sema);
+		up(&iclog->ic_sema);
+		iclog = iclog->ic_next;
+	}
+}
+
 /*
  * Wait for the iclog and all prior iclogs to be written disk as required by the
  * log force state machine. Waiting on ic_force_wait ensures iclog completions
@@ -1111,6 +1128,14 @@ xfs_log_unmount(
 {
 	xfs_log_clean(mp);
 
+	/*
+	 * If shutdown has come from iclog IO context, the log
+	 * cleaning will have been skipped and so we need to wait
+	 * for the iclog to complete shutdown processing before we
+	 * tear anything down.
+	 */
+	xlog_wait_iclog_completion(mp->m_log);
+
 	xfs_buftarg_drain(mp->m_ddev_targp);
 
 	xfs_trans_ail_destroy(mp);
@@ -2113,17 +2138,6 @@ xlog_dealloc_log(
 	xlog_in_core_t	*iclog, *next_iclog;
 	int		i;
 
-	/*
-	 * Cycle all the iclogbuf locks to make sure all log IO completion
-	 * is done before we tear down these buffers.
-	 */
-	iclog = log->l_iclog;
-	for (i = 0; i < log->l_iclog_bufs; i++) {
-		down(&iclog->ic_sema);
-		up(&iclog->ic_sema);
-		iclog = iclog->ic_next;
-	}
-
 	/*
 	 * Destroy the CIL after waiting for iclog IO completion because an
 	 * iclog EIO error will try to shut down the log, which accesses the
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog

