Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63D40C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jul 2022 09:21:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237906AbiGZJVh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jul 2022 05:21:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237911AbiGZJVg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jul 2022 05:21:36 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A0C112D36;
        Tue, 26 Jul 2022 02:21:34 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id va17so25102800ejb.0;
        Tue, 26 Jul 2022 02:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fRsuzpmsJTmqxEUSle46OYeatOffzA49CzqyNi+9re0=;
        b=gWNrpwwjfbp7sCIwkmM3cBj6t8mahWKGwYCVpSRTCAt8/QHI9arHds2eeqlaQA79pG
         h7EuW5w32+yWSl3qZmISIWqDcPl7KwnfruIohDED7sMGOr29fcPjh2foHLFbKJmsySdQ
         QRZyoqszu6noTuWMnyJYSla9u4sDWEAb6i4CXi3WjqDh377K/FxAojEcZ/xI4D1jt8yP
         8CXxpaDxqS3UmIRBNQChlhE1vytsEDV3H7VXpmdkkAZrhyGxDGKpYwxaN2n49bl1brw/
         XGjpb0kFgwMpcnO13Kf3gG6M/y2Fe3+I2yk1Yv4/DY5Jd+h0Y5Zvg/ZvuLyPRf790AS/
         HHXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fRsuzpmsJTmqxEUSle46OYeatOffzA49CzqyNi+9re0=;
        b=x+dx3BKgKVFmjlbw6mPkK+QexHeiJUfoSRSAKV+i0hkyyXWVti4kJW7ow+OAwt7mWZ
         G3XWvwlcMkNU8I9j/BfjwHtv3ormWboxQas1H9v/RU9cxOBePCVdx38JKtbIT6nhsTLm
         xyEpDSUPf1hmYfYLUHo5xytlLDilwU7L7/jQdNddW5bBeqz83yc9QhxJSYOAuMcFuv/z
         OaTJewnYhDQVSuSMNla4mnInLSt8e0qrsCp+HyVQ1Yu9pmGnLMrvgGrNHD9EEG2LQ1Qp
         d2ftn9D6UaKoSh2SDY7gWxsLKBLUdKfcMEBJylLkuOb6IKJI4mxN9xI/hs28Vhenr+li
         NKCw==
X-Gm-Message-State: AJIora/D6zE8ey1qLyV/xkXM/+EHYBAetkLTAa+Cd8qjCz6PgvELM/Hi
        EXJ5+2iuHoMgkzeF3yrTJu6FWKuJMU6wZQ==
X-Google-Smtp-Source: AGRyM1v2/E+vACHW5P8o+Rb8XWhZo6qyJF5ACs6+SBXuB0lxghiWKSgwUjCNrQFyq7K3tGZ9//XcKw==
X-Received: by 2002:a17:907:75ce:b0:72b:305f:5985 with SMTP id jl14-20020a17090775ce00b0072b305f5985mr13357885ejc.527.1658827293152;
        Tue, 26 Jul 2022 02:21:33 -0700 (PDT)
Received: from amir-ThinkPad-T480.kpn (2a02-a45a-4ae9-1-7aa-6650-a0dd-61a2.fixed6.kpn.net. [2a02:a45a:4ae9:1:7aa:6650:a0dd:61a2])
        by smtp.gmail.com with ESMTPSA id w17-20020a056402071100b0043aa17dc199sm8161528edx.90.2022.07.26.02.21.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 02:21:32 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 5.10 CANDIDATE 3/9] xfs: prevent UAF in xfs_log_item_in_current_chkpt
Date:   Tue, 26 Jul 2022 11:21:19 +0200
Message-Id: <20220726092125.3899077-4-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220726092125.3899077-1-amir73il@gmail.com>
References: <20220726092125.3899077-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit f8d92a66e810acbef6ddbc0bd0cbd9b117ce8acd upstream.

While I was running with KASAN and lockdep enabled, I stumbled upon an
KASAN report about a UAF to a freed CIL checkpoint.  Looking at the
comment for xfs_log_item_in_current_chkpt, it seems pretty obvious to me
that the original patch to xfs_defer_finish_noroll should have done
something to lock the CIL to prevent it from switching the CIL contexts
while the predicate runs.

For upper level code that needs to know if a given log item is new
enough not to need relogging, add a new wrapper that takes the CIL
context lock long enough to sample the current CIL context.  This is
kind of racy in that the CIL can switch the contexts immediately after
sampling, but that's ok because the consequence is that the defer ops
code is a little slow to relog items.

 ==================================================================
 BUG: KASAN: use-after-free in xfs_log_item_in_current_chkpt+0x139/0x160 [xfs]
 Read of size 8 at addr ffff88804ea5f608 by task fsstress/527999

 CPU: 1 PID: 527999 Comm: fsstress Tainted: G      D      5.16.0-rc4-xfsx #rc4
 Call Trace:
  <TASK>
  dump_stack_lvl+0x45/0x59
  print_address_description.constprop.0+0x1f/0x140
  kasan_report.cold+0x83/0xdf
  xfs_log_item_in_current_chkpt+0x139/0x160
  xfs_defer_finish_noroll+0x3bb/0x1e30
  __xfs_trans_commit+0x6c8/0xcf0
  xfs_reflink_remap_extent+0x66f/0x10e0
  xfs_reflink_remap_blocks+0x2dd/0xa90
  xfs_file_remap_range+0x27b/0xc30
  vfs_dedupe_file_range_one+0x368/0x420
  vfs_dedupe_file_range+0x37c/0x5d0
  do_vfs_ioctl+0x308/0x1260
  __x64_sys_ioctl+0xa1/0x170
  do_syscall_64+0x35/0x80
  entry_SYSCALL_64_after_hwframe+0x44/0xae
 RIP: 0033:0x7f2c71a2950b
 Code: 0f 1e fa 48 8b 05 85 39 0d 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff
ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01
f0 ff ff 73 01 c3 48 8b 0d 55 39 0d 00 f7 d8 64 89 01 48
 RSP: 002b:00007ffe8c0e03c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
 RAX: ffffffffffffffda RBX: 00005600862a8740 RCX: 00007f2c71a2950b
 RDX: 00005600862a7be0 RSI: 00000000c0189436 RDI: 0000000000000004
 RBP: 000000000000000b R08: 0000000000000027 R09: 0000000000000003
 R10: 0000000000000000 R11: 0000000000000246 R12: 000000000000005a
 R13: 00005600862804a8 R14: 0000000000016000 R15: 00005600862a8a20
  </TASK>

 Allocated by task 464064:
  kasan_save_stack+0x1e/0x50
  __kasan_kmalloc+0x81/0xa0
  kmem_alloc+0xcd/0x2c0 [xfs]
  xlog_cil_ctx_alloc+0x17/0x1e0 [xfs]
  xlog_cil_push_work+0x141/0x13d0 [xfs]
  process_one_work+0x7f6/0x1380
  worker_thread+0x59d/0x1040
  kthread+0x3b0/0x490
  ret_from_fork+0x1f/0x30

 Freed by task 51:
  kasan_save_stack+0x1e/0x50
  kasan_set_track+0x21/0x30
  kasan_set_free_info+0x20/0x30
  __kasan_slab_free+0xed/0x130
  slab_free_freelist_hook+0x7f/0x160
  kfree+0xde/0x340
  xlog_cil_committed+0xbfd/0xfe0 [xfs]
  xlog_cil_process_committed+0x103/0x1c0 [xfs]
  xlog_state_do_callback+0x45d/0xbd0 [xfs]
  xlog_ioend_work+0x116/0x1c0 [xfs]
  process_one_work+0x7f6/0x1380
  worker_thread+0x59d/0x1040
  kthread+0x3b0/0x490
  ret_from_fork+0x1f/0x30

 Last potentially related work creation:
  kasan_save_stack+0x1e/0x50
  __kasan_record_aux_stack+0xb7/0xc0
  insert_work+0x48/0x2e0
  __queue_work+0x4e7/0xda0
  queue_work_on+0x69/0x80
  xlog_cil_push_now.isra.0+0x16b/0x210 [xfs]
  xlog_cil_force_seq+0x1b7/0x850 [xfs]
  xfs_log_force_seq+0x1c7/0x670 [xfs]
  xfs_file_fsync+0x7c1/0xa60 [xfs]
  __x64_sys_fsync+0x52/0x80
  do_syscall_64+0x35/0x80
  entry_SYSCALL_64_after_hwframe+0x44/0xae

 The buggy address belongs to the object at ffff88804ea5f600
  which belongs to the cache kmalloc-256 of size 256
 The buggy address is located 8 bytes inside of
  256-byte region [ffff88804ea5f600, ffff88804ea5f700)
 The buggy address belongs to the page:
 page:ffffea00013a9780 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff88804ea5ea00 pfn:0x4ea5e
 head:ffffea00013a9780 order:1 compound_mapcount:0
 flags: 0x4fff80000010200(slab|head|node=1|zone=1|lastcpupid=0xfff)
 raw: 04fff80000010200 ffffea0001245908 ffffea00011bd388 ffff888004c42b40
 raw: ffff88804ea5ea00 0000000000100009 00000001ffffffff 0000000000000000
 page dumped because: kasan: bad access detected

 Memory state around the buggy address:
  ffff88804ea5f500: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff88804ea5f580: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 >ffff88804ea5f600: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                       ^
  ffff88804ea5f680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff88804ea5f700: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ==================================================================

Fixes: 4e919af7827a ("xfs: periodically relog deferred intent items")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_log_cil.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 88730883bb70..fbe160d5e9b9 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -1179,9 +1179,9 @@ xlog_cil_force_seq(
  */
 bool
 xfs_log_item_in_current_chkpt(
-	struct xfs_log_item *lip)
+	struct xfs_log_item	*lip)
 {
-	struct xfs_cil_ctx *ctx = lip->li_mountp->m_log->l_cilp->xc_ctx;
+	struct xfs_cil		*cil = lip->li_mountp->m_log->l_cilp;
 
 	if (list_empty(&lip->li_cil))
 		return false;
@@ -1191,7 +1191,7 @@ xfs_log_item_in_current_chkpt(
 	 * first checkpoint it is written to. Hence if it is different to the
 	 * current sequence, we're in a new checkpoint.
 	 */
-	return lip->li_seq == ctx->sequence;
+	return lip->li_seq == READ_ONCE(cil->xc_current_sequence);
 }
 
 /*
-- 
2.25.1

