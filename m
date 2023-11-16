Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92E76C072A2
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Nov 2023 02:28:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344509AbjKPC2r (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Nov 2023 21:28:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344494AbjKPC2q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Nov 2023 21:28:46 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71CCE127;
        Wed, 15 Nov 2023 18:28:43 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1cc37fb1310so3272095ad.1;
        Wed, 15 Nov 2023 18:28:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700101723; x=1700706523; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LWm//3IC9RmX2JUc1s/fqU/2hspLkb/iezhraGazfGU=;
        b=Z+f7uFic6EiLmMLJW/TMFZQWIDSLecSQ4wkanjFvvpXK6JZ7DOyMQlo64nsh0a+QA6
         tjlEnz4Q2QlUPHosHZpukjXT+9uvFlF8odBnS/wjUccCYML7UanHQLCnyZRtVa9x5sGJ
         53iAuBQKyDrzar2MSLwpXT4sqUf9cjdDqsIz7zxWT93ES2bcE6ujookixFiT+HGysUHo
         O87wJCx5mZyF9xNwIZ5peSkmH3h3AoERvbwyXSMMwJzbcFHAMc1vLBXUgPRNhtw+o6cT
         C4VT/vRRGyeiRWkcoGQElvHoh0SWSFoC60sBBW70Pqd3z3tOonrsKNW9bXtWj1MJuKcd
         8QVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700101723; x=1700706523;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LWm//3IC9RmX2JUc1s/fqU/2hspLkb/iezhraGazfGU=;
        b=UChe7eM/Z0MXLyghCr/lUCq+PoJBJ01KW0loR/Q2bLysn//Gl0aTLVPXhfKkZ0zZ1z
         oSueRDiYAk5XAbnCs4w7tR1PC0DGsphwDW6yX6wbDGO4bIXRuOd1X1ztTaP01LrQjxbO
         7OsnOy0c1DmfEeRRpeSvaapIp7Fy2GDlbFjp4Vm4Pt/vfXJzVVw9H0ayk3AidrlKHLUR
         GRtjd5VgTPNZCtYsOsP2yoHDQFiD/KOJg1ib7IBdBay1EPgqFExw2Ec70B3q6JioZSM3
         afNPMgYFofxt0VPqGHxTusUFzSRdsDXFilLSIyiCquMiQpKrYUL5eGBF5zLD9gRyUf34
         jQjQ==
X-Gm-Message-State: AOJu0YyYLvLC3phIvJlHgwRt4n97aXDM+Oi0sWnDQeiVE9eWY/P3bh5S
        cIvCCkLks9a2Y/ttIbMq+1bgv2sFE0gTbw==
X-Google-Smtp-Source: AGHT+IGS3yE8eipNajb37EfcOA1STsttDvacRjSet6Kqu0LEzWdiJDuJ1ow0b6Le92bSqaxMCFaEeg==
X-Received: by 2002:a17:902:f7d6:b0:1cc:385b:456a with SMTP id h22-20020a170902f7d600b001cc385b456amr6225515plw.44.1700101722734;
        Wed, 15 Nov 2023 18:28:42 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:25ea:d6bb:623c:d6a0])
        by smtp.gmail.com with ESMTPSA id j9-20020a170903024900b001b8b1f6619asm8087072plh.75.2023.11.15.18.28.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Nov 2023 18:28:42 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        chandan.babu@oracle.com, fred@cloudflare.com,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 5.15 05/17] xfs: prevent a UAF when log IO errors race with unmount
Date:   Wed, 15 Nov 2023 18:28:21 -0800
Message-ID: <20231116022833.121551-5-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
In-Reply-To: <20231116022833.121551-1-leah.rumancik@gmail.com>
References: <20231116022833.121551-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 7561cea5dbb97fecb952548a0fb74fb105bf4664 ]

KASAN reported the following use after free bug when running
generic/475:

 XFS (dm-0): Mounting V5 Filesystem
 XFS (dm-0): Starting recovery (logdev: internal)
 XFS (dm-0): Ending recovery (logdev: internal)
 Buffer I/O error on dev dm-0, logical block 20639616, async page read
 Buffer I/O error on dev dm-0, logical block 20639617, async page read
 XFS (dm-0): log I/O error -5
 XFS (dm-0): Filesystem has been shut down due to log error (0x2).
 XFS (dm-0): Unmounting Filesystem
 XFS (dm-0): Please unmount the filesystem and rectify the problem(s).
 ==================================================================
 BUG: KASAN: use-after-free in do_raw_spin_lock+0x246/0x270
 Read of size 4 at addr ffff888109dd84c4 by task 3:1H/136

 CPU: 3 PID: 136 Comm: 3:1H Not tainted 5.19.0-rc4-xfsx #rc4 8e53ab5ad0fddeb31cee5e7063ff9c361915a9c4
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1 04/01/2014
 Workqueue: xfs-log/dm-0 xlog_ioend_work [xfs]
 Call Trace:
  <TASK>
  dump_stack_lvl+0x34/0x44
  print_report.cold+0x2b8/0x661
  ? do_raw_spin_lock+0x246/0x270
  kasan_report+0xab/0x120
  ? do_raw_spin_lock+0x246/0x270
  do_raw_spin_lock+0x246/0x270
  ? rwlock_bug.part.0+0x90/0x90
  xlog_force_shutdown+0xf6/0x370 [xfs 4ad76ae0d6add7e8183a553e624c31e9ed567318]
  xlog_ioend_work+0x100/0x190 [xfs 4ad76ae0d6add7e8183a553e624c31e9ed567318]
  process_one_work+0x672/0x1040
  worker_thread+0x59b/0xec0
  ? __kthread_parkme+0xc6/0x1f0
  ? process_one_work+0x1040/0x1040
  ? process_one_work+0x1040/0x1040
  kthread+0x29e/0x340
  ? kthread_complete_and_exit+0x20/0x20
  ret_from_fork+0x1f/0x30
  </TASK>

 Allocated by task 154099:
  kasan_save_stack+0x1e/0x40
  __kasan_kmalloc+0x81/0xa0
  kmem_alloc+0x8d/0x2e0 [xfs]
  xlog_cil_init+0x1f/0x540 [xfs]
  xlog_alloc_log+0xd1e/0x1260 [xfs]
  xfs_log_mount+0xba/0x640 [xfs]
  xfs_mountfs+0xf2b/0x1d00 [xfs]
  xfs_fs_fill_super+0x10af/0x1910 [xfs]
  get_tree_bdev+0x383/0x670
  vfs_get_tree+0x7d/0x240
  path_mount+0xdb7/0x1890
  __x64_sys_mount+0x1fa/0x270
  do_syscall_64+0x2b/0x80
  entry_SYSCALL_64_after_hwframe+0x46/0xb0

 Freed by task 154151:
  kasan_save_stack+0x1e/0x40
  kasan_set_track+0x21/0x30
  kasan_set_free_info+0x20/0x30
  ____kasan_slab_free+0x110/0x190
  slab_free_freelist_hook+0xab/0x180
  kfree+0xbc/0x310
  xlog_dealloc_log+0x1b/0x2b0 [xfs]
  xfs_unmountfs+0x119/0x200 [xfs]
  xfs_fs_put_super+0x6e/0x2e0 [xfs]
  generic_shutdown_super+0x12b/0x3a0
  kill_block_super+0x95/0xd0
  deactivate_locked_super+0x80/0x130
  cleanup_mnt+0x329/0x4d0
  task_work_run+0xc5/0x160
  exit_to_user_mode_prepare+0xd4/0xe0
  syscall_exit_to_user_mode+0x1d/0x40
  entry_SYSCALL_64_after_hwframe+0x46/0xb0

This appears to be a race between the unmount process, which frees the
CIL and waits for in-flight iclog IO; and the iclog IO completion.  When
generic/475 runs, it starts fsstress in the background, waits a few
seconds, and substitutes a dm-error device to simulate a disk falling
out of a machine.  If the fsstress encounters EIO on a pure data write,
it will exit but the filesystem will still be online.

The next thing the test does is unmount the filesystem, which tries to
clean the log, free the CIL, and wait for iclog IO completion.  If an
iclog was being written when the dm-error switch occurred, it can race
with log unmounting as follows:

Thread 1				Thread 2

					xfs_log_unmount
					xfs_log_clean
					xfs_log_quiesce
xlog_ioend_work
<observe error>
xlog_force_shutdown
test_and_set_bit(XLOG_IOERROR)
					xfs_log_force
					<log is shut down, nop>
					xfs_log_umount_write
					<log is shut down, nop>
					xlog_dealloc_log
					xlog_cil_destroy
					<wait for iclogs>
spin_lock(&log->l_cilp->xc_push_lock)
<KABOOM>

Therefore, free the CIL after waiting for the iclogs to complete.  I
/think/ this race has existed for quite a few years now, though I don't
remember the ~2014 era logging code well enough to know if it was a real
threat then or if the actual race was exposed only more recently.

Fixes: ac983517ec59 ("xfs: don't sleep in xlog_cil_force_lsn on shutdown")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
---
 fs/xfs/xfs_log.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 0fb7d05ca308..eba295f666ac 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2061,8 +2061,6 @@ xlog_dealloc_log(
 	xlog_in_core_t	*iclog, *next_iclog;
 	int		i;
 
-	xlog_cil_destroy(log);
-
 	/*
 	 * Cycle all the iclogbuf locks to make sure all log IO completion
 	 * is done before we tear down these buffers.
@@ -2074,6 +2072,13 @@ xlog_dealloc_log(
 		iclog = iclog->ic_next;
 	}
 
+	/*
+	 * Destroy the CIL after waiting for iclog IO completion because an
+	 * iclog EIO error will try to shut down the log, which accesses the
+	 * CIL to wake up the waiters.
+	 */
+	xlog_cil_destroy(log);
+
 	iclog = log->l_iclog;
 	for (i = 0; i < log->l_iclog_bufs; i++) {
 		next_iclog = iclog->ic_next;
-- 
2.43.0.rc0.421.g78406f8d94-goog

