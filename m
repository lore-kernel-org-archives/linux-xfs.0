Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F2516131A;
	Wed,  1 May 2024 18:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714588897; cv=none; b=dhheg546uPLuzX3Cfa7ku1Jp9ok+9q3Y71UfHezxCF08V6TtG1JKLOSvCtBdJ9xrnAsnjI+wGV6yv51x9xrgHTfYXY2URSXOKlZUqnkyb0CTuqM7xPoS1SVPXlTCHx77U57gjveljmH4AqF9yjzKxkXirFvUNvn4rr55hZYkJtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714588897; c=relaxed/simple;
	bh=2T0fbkzaHnXOOPD8b4SnmSyZTj29r0jty5J7t0Fn9s8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nW+bxUbycA9M4w3yiPjFkFQcw3uR0Lfl8wNufDpT0PQhwM5Gv+Ej+amb9OEQ1iaSAZcP3M4s675c4S43yo3job9Rg9Cwr33zHvtO77euX2X1KlwgtbdUNyIXNp86fYGsnBdW3Nib9WB2fzQIE4mwlwqj7OzlyBl/erwNG0aV/tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NvFWVd2r; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NvFWVd2r"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6ece8991654so6484650b3a.3;
        Wed, 01 May 2024 11:41:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714588895; x=1715193695; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iB7OK8S4qlJqB+wkgbtLrKWUHc0F8HhkAM8P1Q2D1Mk=;
        b=NvFWVd2rbU1T71OjOhBDwJ7u7ba1uQcqw1ynYOsimanqIQ4rs+7ROKfLIqPVlKAsGp
         IKX68ii7QawcZ0FJQcQuD1qMj1OC3+klb88Mx8S86xM0Qt0wDVF9ME0g1J1pbMKPXfRX
         0kHmCEIrqwfg0tBE7nj8ZYK3FQIyOmbNdTkDQTQU2231nXM6dvVPoAAEiya2aWCA/+/w
         /FpkUk6b/F7ol8StcKPhomO8gHINiuJ7XXyNTsdMNCrZ0kbGkH5OEL5KaVSUSr0hVo8+
         DnSER6Bo6l3wQTXm2fZ597bR0WWWG1zQP2HPtZ09EhvE7lJGgodxjns03aMENpxqGpQK
         IpCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714588895; x=1715193695;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iB7OK8S4qlJqB+wkgbtLrKWUHc0F8HhkAM8P1Q2D1Mk=;
        b=hq7zv+l47IOjN05LiaZiBD5UvXzloZhniY4SEbbABucUhzGLkDF8k+xPxF3f5w2/Du
         TbMuujA5Q18S5bvPaR9i4S/ZSzCBapsjLDyUuoTnB893YNhUoxtECxDlGvDFq0A8o1lC
         Q3PiBQuvJqwVOrUkIntSJ0Ebtqi1VWctmvT0yer4wHyWqdM8URNqLV4ACVjXeMFhe0n6
         gf2o1dicWH/TlsmQH+AHKvNOOOM1qSWzAz01/e10Qex+X4EBjxjQ2caQCm7vg1D2dpEX
         cxYw8W0VcuPu8Dej4eCIpvI2bOZwiBb47tNCaGCFE1BCpiSK890md7ctASINEbE+v1E1
         P5MQ==
X-Gm-Message-State: AOJu0YyOl44zU/Or+SeWM8q/WYPwua1qHmqtR+XzJMv2PtGadSp/4z1m
	k7+3O0icc3/G4lbTRW3yVvbs3WtKtWTUMxloRHAdmo3K83jacAQ0wlz66cX+
X-Google-Smtp-Source: AGHT+IElfxvbTgDf2R730nQqRtivj/NITfAL9wzemAKsz27MIynpW2Wn/sshnnTL5/ScInArlz+moA==
X-Received: by 2002:a05:6a20:968d:b0:1aa:8fe2:5adf with SMTP id hp13-20020a056a20968d00b001aa8fe25adfmr3914201pzc.15.1714588895288;
        Wed, 01 May 2024 11:41:35 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:9dbc:724d:6e88:fb08])
        by smtp.gmail.com with ESMTPSA id j18-20020a62e912000000b006e681769ee0sm23687369pfh.145.2024.05.01.11.41.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 May 2024 11:41:35 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	chandan.babu@oracle.com,
	fred@cloudflare.com,
	Guo Xuenan <guoxuenan@huawei.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 17/24] xfs: fix super block buf log item UAF during force shutdown
Date: Wed,  1 May 2024 11:41:05 -0700
Message-ID: <20240501184112.3799035-17-leah.rumancik@gmail.com>
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

Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_buf_item.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 522d450a94b1..df7322ed73fa 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -1018,6 +1018,8 @@ xfs_buf_item_relse(
 	trace_xfs_buf_item_relse(bp, _RET_IP_);
 	ASSERT(!test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags));
 
+	if (atomic_read(&bip->bli_refcount))
+		return;
 	bp->b_log_item = NULL;
 	xfs_buf_rele(bp);
 	xfs_buf_item_free(bip);
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog

