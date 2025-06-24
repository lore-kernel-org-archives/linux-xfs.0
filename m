Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7FA3FB1B;
	Tue, 24 Jun 2025 13:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750772933; cv=none; b=RZXD3qFZlKUGeCUOQR9ptxtKTcJ5IS0rCXmEEo4nL7PSbvALJBMPDcPWfBjYMzP/unS+8P1Fq8+oDgs3NMJN/BJywPgHmyTQaXryTCCCDSzP7UAEY6IinXPL4l7D4dEm26N4+lJcm8hueXN1Oq/hW52Xhj0Pj2lUvEA+mbJgTd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750772933; c=relaxed/simple;
	bh=xGrATvnsr2No50uFgmrozZRPjRz6yymAT4fJabipdgA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VW5jEznIe1ihcxs14Z7eRYDWcffelF55bA92oXmsYfA8M8a2TbmtZGMQvDl1UJf5uPs7CWIEpaEulwYwA2qQZmgZHQ24umdzUcZ7VUPRb3XL5AMbC9kFU9KhV64NsCHDjgvhfG275b2oRXp0gBZS46Pl5jqVCqnf777msTaKtZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i1IPhwkK; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i1IPhwkK"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-234fcadde3eso74447355ad.0;
        Tue, 24 Jun 2025 06:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750772929; x=1751377729; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Hk6pB62R8/rFBBcS2uuP0R5gJUE79987GNhPqNjMRo8=;
        b=i1IPhwkK9mwyu6TEcCvAvAE9lJxIyPzJ3p6KXhlbkGhYr4rVBUyEIYKfUOq5iEcFl8
         msYHqZkTwWr47gHiG13WM9E+CyGTUBiSuIYVLEdfxzclEU6KwzirqwQH9YB1h4B31TL4
         h5A6ZVENJmLTY0mVRLz2hzWGr/aV1iKJXbcqPVgbQ2j0nAuN2+6LBkp0Li6MXFZVMdme
         4mcc7tW22Q+K8USeFyCakVVuEoqbo/Z/ATFGg2CHbURCdcdDMydH5wCrVpau9EUoPUyZ
         sdEyRp+jxnSJJLXMfg5vJYHKUp10Ts9mA4zFz1xy7n26rPgqCPgMwnKS8L3mSGTPbap9
         5G9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750772929; x=1751377729;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Hk6pB62R8/rFBBcS2uuP0R5gJUE79987GNhPqNjMRo8=;
        b=fWHjXppvqeQsosI+fDIj/3zZ1+xsvCJIx/5ZPGEAaTlV0SpP3t4WflHY0aX7DhhHpe
         ozsqZZ5d70i2t+YMUJTrW6Z4ubhk0lqcWZ0mvzuoaQoPOBj6cwncXyNXleaOAppHCj4d
         4s6lvErzn7gOdPncpisWSRVtXV2h404m0aGSA+TT+cTkrqHDJ0XrV1hwV0To7aM2BG91
         Qr93aujPu3mecxMjj+AhJIVDVBUqyuCA+wvwT/nARkD4AW9dhAFSMCd+XUvTKUvmk5YI
         B2SAEp53U7k39Yr3gDuAz6YPm7ZflJgri1w8PZGetfviq23Ym+sMMVKcQ5WNW5B1zWtM
         gudg==
X-Forwarded-Encrypted: i=1; AJvYcCW/e1t059AXH9vnfkkC88LuiNhL4FQD6y7rYS9/CuZcSBUfCS79cI1oQG2juJWSbJsNNJPvCQ5U@vger.kernel.org, AJvYcCXqZm3NMkEjLLLfXCuPrk5D9KaoOKkIXJdjsCWCZiG2NuqXpTG8kQQ9r+ujgm+x3P8IQ4yBR24sixbpToM=@vger.kernel.org
X-Gm-Message-State: AOJu0YytNz9JRyu6NGbKOv+utuyF7N8BYZAXKvSAdiiIT7OpLYXdCqhL
	zJIpJd9y3WyJOM4qJpX3vplAX0hg4kfV/ekfAN0shpHEPCUwUPd7GNcuJeSQSf5X
X-Gm-Gg: ASbGnctQjet29JN1r4541cZiRvSeOpyWzIgORX/4AeyTbjY734J2FxRkybR8XTVjkzK
	x1v1TqsiRthPowH3Q9ZGZag9YB2p0SWEnUeUVsrirDM98HJ7iATHT9uLxKWU26UFQslX6fkIcXP
	wBs+7DCKbZeL1xsnsAmLMZ032pgaE6AH62TlapyORbRA7NOGBTtsBpCsFpoI/UHHQP3KmRyt/Ie
	OS/l43515h7fZSbVMTvLX4cxI+gH+/CU1XLQOh0NV1NNWU3asZkenJgaPHn86CdoK0VmJk4hvf9
	CydquybKj3bqA8aq7Jh3qJ3+i2c+w191DAZ/uZF93i0eDqTBJSCWKFfnw8K9BSLixbs5yDx8lzB
	RpPAyycs=
X-Google-Smtp-Source: AGHT+IElliQeDtJFb0sxRL7fqhBF58Qku40qz2wb/HqE9C6if71wyFRvz5Gor/lVluwB88KvtwlGPg==
X-Received: by 2002:a17:903:94b:b0:234:d292:be83 with SMTP id d9443c01a7336-237d9778c65mr279303895ad.10.1750772929068;
        Tue, 24 Jun 2025 06:48:49 -0700 (PDT)
Received: from manjaro.domain.name ([2401:4900:1c67:6116:afb5:b6ab:2dc8:4a21])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-237d8729490sm114526515ad.236.2025.06.24.06.48.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 06:48:48 -0700 (PDT)
From: Pranav Tyagi <pranav.tyagi03@gmail.com>
To: linux-xfs@vger.kernel.org,
	stable@vger.kernel.org
Cc: djwong@kernel.org,
	leah.rumancik@gmail.com,
	gregkh@linuxfoundation.org,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	linux-kernel-mentees@lists.linux.dev,
	Guo Xuenan <guoxuenan@huawei.com>,
	Pranav Tyagi <pranav.tyagi03@gmail.com>
Subject: [PATCH 5.15.y] xfs: fix super block buf log item UAF during force shutdown
Date: Tue, 24 Jun 2025 19:18:40 +0530
Message-ID: <20250624134840.47853-1-pranav.tyagi03@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Guo Xuenan <guoxuenan@huawei.com>

[ Upstream commit 575689fc0ffa6c4bb4e72fd18e31a6525a6124e0 ]

xfs log io error will trigger xlog shut down, and end_io worker call
xlog_state_shutdown_callbacks to unpin and release the buf log item.
The race condition is that when there are some thread doing transaction
commit and happened not to be intercepted by xlog_is_shutdown, then,
these log item will be insert into CIL, when unpin and release these
buf log item, UAF will occur. BTW, add delay before `xlog_cil_commit`
can increase recurrence probability.

The following call graph actually encountered this bad situation.
fsstress                    io end worker kworker/0:1H-216
                            xlog_ioend_work
                              ->xlog_force_shutdown
                                ->xlog_state_shutdown_callbacks
                                  ->xlog_cil_process_committed
                                    ->xlog_cil_committed
                                      ->xfs_trans_committed_bulk
->xfs_trans_apply_sb_deltas             ->li_ops->iop_unpin(lip, 1);
  ->xfs_trans_getsb
    ->_xfs_trans_bjoin
      ->xfs_buf_item_init
        ->if (bip) { return 0;} //relog
->xlog_cil_commit
  ->xlog_cil_insert_items //insert into CIL
                                           ->xfs_buf_ioend_fail(bp);
                                             ->xfs_buf_ioend
                                               ->xfs_buf_item_done
                                                 ->xfs_buf_item_relse
                                                   ->xfs_buf_item_free

when cil push worker gather percpu cil and insert super block buf log item
into ctx->log_items then uaf occurs.

==================================================================
BUG: KASAN: use-after-free in xlog_cil_push_work+0x1c8f/0x22f0
Write of size 8 at addr ffff88801800f3f0 by task kworker/u4:4/105

CPU: 0 PID: 105 Comm: kworker/u4:4 Tainted: G W
6.1.0-rc1-00001-g274115149b42 #136
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
Workqueue: xfs-cil/sda xlog_cil_push_work
Call Trace:
 <TASK>
 dump_stack_lvl+0x4d/0x66
 print_report+0x171/0x4a6
 kasan_report+0xb3/0x130
 xlog_cil_push_work+0x1c8f/0x22f0
 process_one_work+0x6f9/0xf70
 worker_thread+0x578/0xf30
 kthread+0x28c/0x330
 ret_from_fork+0x1f/0x30
 </TASK>

Allocated by task 2145:
 kasan_save_stack+0x1e/0x40
 kasan_set_track+0x21/0x30
 __kasan_slab_alloc+0x54/0x60
 kmem_cache_alloc+0x14a/0x510
 xfs_buf_item_init+0x160/0x6d0
 _xfs_trans_bjoin+0x7f/0x2e0
 xfs_trans_getsb+0xb6/0x3f0
 xfs_trans_apply_sb_deltas+0x1f/0x8c0
 __xfs_trans_commit+0xa25/0xe10
 xfs_symlink+0xe23/0x1660
 xfs_vn_symlink+0x157/0x280
 vfs_symlink+0x491/0x790
 do_symlinkat+0x128/0x220
 __x64_sys_symlink+0x7a/0x90
 do_syscall_64+0x35/0x80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Freed by task 216:
 kasan_save_stack+0x1e/0x40
 kasan_set_track+0x21/0x30
 kasan_save_free_info+0x2a/0x40
 __kasan_slab_free+0x105/0x1a0
 kmem_cache_free+0xb6/0x460
 xfs_buf_ioend+0x1e9/0x11f0
 xfs_buf_item_unpin+0x3d6/0x840
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

The buggy address belongs to the object at ffff88801800f388
 which belongs to the cache xfs_buf_item of size 272
The buggy address is located 104 bytes inside of
 272-byte region [ffff88801800f388, ffff88801800f498)

The buggy address belongs to the physical page:
page:ffffea0000600380 refcount:1 mapcount:0 mapping:0000000000000000
index:0xffff88801800f208 pfn:0x1800e
head:ffffea0000600380 order:1 compound_mapcount:0 compound_pincount:0
flags: 0x1fffff80010200(slab|head|node=0|zone=1|lastcpupid=0x1fffff)
raw: 001fffff80010200 ffffea0000699788 ffff88801319db50 ffff88800fb50640
raw: ffff88801800f208 000000000015000a 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88801800f280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88801800f300: fb fb fb fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88801800f380: fc fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                             ^
 ffff88801800f400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88801800f480: fb fb fb fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================
Disabling lock debugging due to kernel taint

[ Backport to 5.15: context cleanly applied with no semantic changes.
Build-tested. ]

Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Pranav Tyagi <pranav.tyagi03@gmail.com>
---
 fs/xfs/xfs_buf_item.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index b1ab100c09e1..ffe318eb897f 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -1017,6 +1017,8 @@ xfs_buf_item_relse(
 	trace_xfs_buf_item_relse(bp, _RET_IP_);
 	ASSERT(!test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags));
 
+	if (atomic_read(&bip->bli_refcount))
+		return;
 	bp->b_log_item = NULL;
 	xfs_buf_rele(bp);
 	xfs_buf_item_free(bip);
-- 
2.49.0

