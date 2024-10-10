Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D28C18F2FF;
	Thu, 10 Oct 2024 04:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728536334; cv=none; b=Lvo7YpxW+9BUPBaQPoYMGfmR6KlVvc3cgA88c+OZ/dXfbsuZ3eXDfhrgPcRTAdAEIwUYeHAW2E+J+K9crKK8mw3RtHKuaXUE3lzA1ZsA/8MjzYP0t9BFlDRXNOdse7yqqF8Hv4nrIa7VHsKUIe2rNoS5AVHE7GAMtFc1NmLPRnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728536334; c=relaxed/simple;
	bh=rvPvWpE0WNaL4hil9zTCJfZ9UGfGvYk05TegTskFXHQ=;
	h=From:Date:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=rIqAdAH/tGQvJs3R25tY3OUQwBWmIahjCyYfyC2zhG5FdR3Dux6iqTCXoWnJ3iMSKdgavq6Q28Cn/gRl9YO8KYCmHB2tEKxQ2Wxa6SmDaIwmV1hrXheNjlFhSCHt4IGGegS007m5VyjUBt3GL8Ku228YiE4fVbUivLLevm2lLnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YfFUKLer; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YfFUKLer"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-71df0dbee46so397349b3a.0;
        Wed, 09 Oct 2024 21:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728536332; x=1729141132; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:date:from
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9e/VPAlIyAZCli/ofmVddbzqeYWWWHaTukcajHAji3A=;
        b=YfFUKLeryAGFC/4v2XD5bWxCujaWW6K6nK3a9L8DPxgkuV2uY1uSLZOTcFz2GJhUAg
         Xiw+K8n0VXPTs6t49mDvC3VMsS2UCqXn/O/ju4w7MK1N1MNDVpcGuGqO4iO73IRUJpdg
         4cfsPfzPNeIm0KDl29nFb+ojbh0ZK/ksG+a2yN+40pzBM3iXXBLcIwHA97wXAz/p83mm
         PCIXUZ4dbkTING2+53X6+418BmdbEAz7EDM5yIXf/Y/h/YLJYlHIYlNYDLxPrIpdhTKs
         NNqNwIYjh2/m9QxUFrltefdUHDVnfkiZ4XNVEcXbEtPrJZGf9qxm9tzVdZQGrZW/KXHR
         sj1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728536332; x=1729141132;
        h=content-disposition:mime-version:message-id:subject:cc:to:date:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9e/VPAlIyAZCli/ofmVddbzqeYWWWHaTukcajHAji3A=;
        b=VvEBWefcq3KHKKT6NuOrepZEbC47AvEzCw71gnMn13zhikXXL1UKt+BvI+V/HXInka
         VxBJtpg5s0ZpsMqtEzyBrIOWXiYhJyB+fhszTAH6nauxkC134Emkw3zCZu7ZynFBUbNF
         LtpfvpMwbiINYBALK/wHvTKKoMMZZLIrHlXWI3f2wKL2iLudxEkT2oWBfB1gfk54X+66
         rtvFWrryxm5T7OjqUM5/+1HIFM8iUkqfQN3A0eRBeZSovh6U2DgoksFK9b7bd9J8FcKO
         SU1+ag+KBKo9x3eLgCp5ai3xRYiUBm83bvfkEbaxmD2/vC5bsDaCL0uIEOjNSUBilf2B
         iZMQ==
X-Forwarded-Encrypted: i=1; AJvYcCWaPTW015YYRlGZjKRa/onu0ARCHes90zvo0oytuvjTf6MdLvHuuVsGx3dZHbG6N3H+pcOiCW2yZfOmxJw=@vger.kernel.org, AJvYcCWc/OACV/Lvzoy0oT5oEqBYc7q4X3C46uWK4bPWaNVeWa8SlvVAsqlwteVIvuA1CFFWIHTsYpkb4IKk@vger.kernel.org
X-Gm-Message-State: AOJu0YxT9cnsiCuf0g09PUhvXjSpArKAnHwS0z6Zdy5RmwxRMA0hKlJ+
	cDSDQjdN+CUS2LNbPCKCirz6NROMcwB42ZnhpGQsV+m0dnlPcTpa5IQcHkn77Pk=
X-Google-Smtp-Source: AGHT+IG2nyCkFOO52IwqGEVeGZFUcEZh6aaC4IsBlYqOzlbxD2W9HXO0B7BsiNtsD8i3f6tY+uFRHg==
X-Received: by 2002:a05:6a00:3e16:b0:71e:14c:8d31 with SMTP id d2e1a72fcca58-71e1db858d1mr8318997b3a.16.1728536332042;
        Wed, 09 Oct 2024 21:58:52 -0700 (PDT)
Received: from gmail.com ([24.130.68.0])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71e2ab0a50dsm262899b3a.195.2024.10.09.21.58.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2024 21:58:49 -0700 (PDT)
From: Guo Xuenan <marcus.yu.56@gmail.com>
X-Google-Original-From: Guo Xuenan <guoxuenan@huawei.com>
Date: Wed, 9 Oct 2024 21:58:46 -0700
To: stable@vger.kernel.org, gregkh@linuxfoundation.org, sashal@kernel.org
Cc: leah.rumancik@gmail.com, djwong@kernel.org, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
	marcus.yu.56@gmail.com
Subject: [PATCH 5.15.y] xfs: fix super block buf log item UAF during force
 shutdown
Message-ID: <ZwdfBhBsMEG2_1Tr@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

commit 575689fc0ffa6c4bb4e72fd18e31a6525a6124e0 upstream.

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
Signed-off-by: Chang Yu <marcus.yu.56@gmail.com>
---

The fix 575689fc0ffa ("xfs: fix super block buf log item UAF
during force shutdown") was first introduced in v6.2-rc1. Syzkaller
reports that the UAF bug is still present in linux-5.15.y
(https://syzkaller.appspot.com/bug?extid=4d9a694803b65e21655b).
I think a backport should be beneficial here.

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
2.46.2

