Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15B7AC5AE4B
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Nov 2023 02:28:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344547AbjKPC25 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Nov 2023 21:28:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344552AbjKPC24 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Nov 2023 21:28:56 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9B8A19F;
        Wed, 15 Nov 2023 18:28:52 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id 41be03b00d2f7-5b9a456798eso243505a12.3;
        Wed, 15 Nov 2023 18:28:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700101732; x=1700706532; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CdFk9eIySVqz8jF212z+4yPHAq3bvZXC7KQruR4NT58=;
        b=SoO98iZwnSrrhzsidKSwYHhKWE5fKSbrlpRp4oDMEQ07eLmMjpHcU7Efuc9m5S8WYo
         T6ljs3HkyuJmSEyjoiNUnlEotjCEUpTXrX0bH75f01qSyL08c/aDbPA758rD5DM3DELF
         rLemp5qaF2Lq7K4HXuOG4OGGYW7z9Uu2UjLW7zRThJKyqZZ0V8+1SUXufXSgxqhvpeFK
         yHfC5wNjKTQLs4zjOMdgZ94plApGxaxld2U5LnouN9B6hkYFSRsbJ3ojkTZWULOPLvrl
         QgPGf12jveYjBzvN9C/PAUjT1NwkHQIglmckEkJwyv6nek64oPoRsrDZMiEmaKy1U3eE
         6Aaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700101732; x=1700706532;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CdFk9eIySVqz8jF212z+4yPHAq3bvZXC7KQruR4NT58=;
        b=fmhRFzHmuvh0tqoUqMtEVCL8qiA6N3ihIEe/vCe7hej8OCNnPqxFzkbye+g3WIrj4Z
         Hnu88FBgmadlmjoei86R/r5XFnlgyvPwwUFnCWjUGv2kIWSRe0pTFlW3ptKtB/HNS6CZ
         5aHBDeSg8sti/9jkRuuyo3FCYq4VICt1SKU0XY3FkFcGp3i90bvNw95FJhxmCS5tI/j7
         C6lj6DCKqI0sw694Kb9yszER737Kq3Pfkjh4LlymunMIH3z6QXBlsY+1zLxfpdqOUXyW
         gmk91kA4y7sqeqS0aZG0Xd3U1OxKQYZDRMBMvSJA80u7SBjah4oA8rlEGa7gFiSCcqOh
         2paA==
X-Gm-Message-State: AOJu0Yx6H+swpgcYenM5JlfGZ74MQkmQT6ddro9KGY8PBQ3P+a4al65T
        HqyKIXiqWM6Qop7UBEJZoJhEJz1NNmS5WA==
X-Google-Smtp-Source: AGHT+IGBDSyQWYJGVcdbyp2oXmbSdXx8dwC6NtrvIlL6AMtKN5sJJQbVKtoLtA5tfLdIapW5254Atw==
X-Received: by 2002:a05:6a20:8408:b0:180:f9c4:a796 with SMTP id c8-20020a056a20840800b00180f9c4a796mr13757230pzd.54.1700101731979;
        Wed, 15 Nov 2023 18:28:51 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:25ea:d6bb:623c:d6a0])
        by smtp.gmail.com with ESMTPSA id j9-20020a170903024900b001b8b1f6619asm8087072plh.75.2023.11.15.18.28.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Nov 2023 18:28:51 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        chandan.babu@oracle.com, fred@cloudflare.com,
        "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 5.15 14/17] xfs: avoid a UAF when log intent item recovery fails
Date:   Wed, 15 Nov 2023 18:28:30 -0800
Message-ID: <20231116022833.121551-14-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
In-Reply-To: <20231116022833.121551-1-leah.rumancik@gmail.com>
References: <20231116022833.121551-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 97cf79677ecb50a38517253ae2fd705849a7e51a ]

KASAN reported a UAF bug when I was running xfs/235:

 BUG: KASAN: use-after-free in xlog_recover_process_intents+0xa77/0xae0 [xfs]
 Read of size 8 at addr ffff88804391b360 by task mount/5680

 CPU: 2 PID: 5680 Comm: mount Not tainted 6.0.0-xfsx #6.0.0 77e7b52a4943a975441e5ac90a5ad7748b7867f6
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1 04/01/2014
 Call Trace:
  <TASK>
  dump_stack_lvl+0x34/0x44
  print_report.cold+0x2cc/0x682
  kasan_report+0xa3/0x120
  xlog_recover_process_intents+0xa77/0xae0 [xfs fb841c7180aad3f8359438576e27867f5795667e]
  xlog_recover_finish+0x7d/0x970 [xfs fb841c7180aad3f8359438576e27867f5795667e]
  xfs_log_mount_finish+0x2d7/0x5d0 [xfs fb841c7180aad3f8359438576e27867f5795667e]
  xfs_mountfs+0x11d4/0x1d10 [xfs fb841c7180aad3f8359438576e27867f5795667e]
  xfs_fs_fill_super+0x13d5/0x1a80 [xfs fb841c7180aad3f8359438576e27867f5795667e]
  get_tree_bdev+0x3da/0x6e0
  vfs_get_tree+0x7d/0x240
  path_mount+0xdd3/0x17d0
  __x64_sys_mount+0x1fa/0x270
  do_syscall_64+0x2b/0x80
  entry_SYSCALL_64_after_hwframe+0x46/0xb0
 RIP: 0033:0x7ff5bc069eae
 Code: 48 8b 0d 85 1f 0f 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 52 1f 0f 00 f7 d8 64 89 01 48
 RSP: 002b:00007ffe433fd448 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
 RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007ff5bc069eae
 RDX: 00005575d7213290 RSI: 00005575d72132d0 RDI: 00005575d72132b0
 RBP: 00005575d7212fd0 R08: 00005575d7213230 R09: 00005575d7213fe0
 R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
 R13: 00005575d7213290 R14: 00005575d72132b0 R15: 00005575d7212fd0
  </TASK>

 Allocated by task 5680:
  kasan_save_stack+0x1e/0x40
  __kasan_slab_alloc+0x66/0x80
  kmem_cache_alloc+0x152/0x320
  xfs_rui_init+0x17a/0x1b0 [xfs]
  xlog_recover_rui_commit_pass2+0xb9/0x2e0 [xfs]
  xlog_recover_items_pass2+0xe9/0x220 [xfs]
  xlog_recover_commit_trans+0x673/0x900 [xfs]
  xlog_recovery_process_trans+0xbe/0x130 [xfs]
  xlog_recover_process_data+0x103/0x2a0 [xfs]
  xlog_do_recovery_pass+0x548/0xc60 [xfs]
  xlog_do_log_recovery+0x62/0xc0 [xfs]
  xlog_do_recover+0x73/0x480 [xfs]
  xlog_recover+0x229/0x460 [xfs]
  xfs_log_mount+0x284/0x640 [xfs]
  xfs_mountfs+0xf8b/0x1d10 [xfs]
  xfs_fs_fill_super+0x13d5/0x1a80 [xfs]
  get_tree_bdev+0x3da/0x6e0
  vfs_get_tree+0x7d/0x240
  path_mount+0xdd3/0x17d0
  __x64_sys_mount+0x1fa/0x270
  do_syscall_64+0x2b/0x80
  entry_SYSCALL_64_after_hwframe+0x46/0xb0

 Freed by task 5680:
  kasan_save_stack+0x1e/0x40
  kasan_set_track+0x21/0x30
  kasan_set_free_info+0x20/0x30
  ____kasan_slab_free+0x144/0x1b0
  slab_free_freelist_hook+0xab/0x180
  kmem_cache_free+0x1f1/0x410
  xfs_rud_item_release+0x33/0x80 [xfs]
  xfs_trans_free_items+0xc3/0x220 [xfs]
  xfs_trans_cancel+0x1fa/0x590 [xfs]
  xfs_rui_item_recover+0x913/0xd60 [xfs]
  xlog_recover_process_intents+0x24e/0xae0 [xfs]
  xlog_recover_finish+0x7d/0x970 [xfs]
  xfs_log_mount_finish+0x2d7/0x5d0 [xfs]
  xfs_mountfs+0x11d4/0x1d10 [xfs]
  xfs_fs_fill_super+0x13d5/0x1a80 [xfs]
  get_tree_bdev+0x3da/0x6e0
  vfs_get_tree+0x7d/0x240
  path_mount+0xdd3/0x17d0
  __x64_sys_mount+0x1fa/0x270
  do_syscall_64+0x2b/0x80
  entry_SYSCALL_64_after_hwframe+0x46/0xb0

 The buggy address belongs to the object at ffff88804391b300
  which belongs to the cache xfs_rui_item of size 688
 The buggy address is located 96 bytes inside of
  688-byte region [ffff88804391b300, ffff88804391b5b0)

 The buggy address belongs to the physical page:
 page:ffffea00010e4600 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff888043919320 pfn:0x43918
 head:ffffea00010e4600 order:2 compound_mapcount:0 compound_pincount:0
 flags: 0x4fff80000010200(slab|head|node=1|zone=1|lastcpupid=0xfff)
 raw: 04fff80000010200 0000000000000000 dead000000000122 ffff88807f0eadc0
 raw: ffff888043919320 0000000080140010 00000001ffffffff 0000000000000000
 page dumped because: kasan: bad access detected

 Memory state around the buggy address:
  ffff88804391b200: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff88804391b280: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 >ffff88804391b300: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                        ^
  ffff88804391b380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff88804391b400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ==================================================================

The test fuzzes an rmap btree block and starts writer threads to induce
a filesystem shutdown on the corrupt block.  When the filesystem is
remounted, recovery will try to replay the committed rmap intent item,
but the corruption problem causes the recovery transaction to fail.
Cancelling the transaction frees the RUD, which frees the RUI that we
recovered.

When we return to xlog_recover_process_intents, @lip is now a dangling
pointer, and we cannot use it to find the iop_recover method for the
tracepoint.  Hence we must store the item ops before calling
->iop_recover if we want to give it to the tracepoint so that the trace
data will tell us exactly which intent item failed.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
---
 fs/xfs/xfs_log_recover.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 04961ebf16ea..3d844a250b71 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2560,6 +2560,7 @@ xlog_recover_process_intents(
 	for (lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
 	     lip != NULL;
 	     lip = xfs_trans_ail_cursor_next(ailp, &cur)) {
+		const struct xfs_item_ops	*ops;
 		/*
 		 * We're done when we see something other than an intent.
 		 * There should be no intents left in the AIL now.
@@ -2584,13 +2585,17 @@ xlog_recover_process_intents(
 		 * deferred ops, you /must/ attach them to the capture list in
 		 * the recover routine or else those subsequent intents will be
 		 * replayed in the wrong order!
+		 *
+		 * The recovery function can free the log item, so we must not
+		 * access lip after it returns.
 		 */
 		spin_unlock(&ailp->ail_lock);
-		error = lip->li_ops->iop_recover(lip, &capture_list);
+		ops = lip->li_ops;
+		error = ops->iop_recover(lip, &capture_list);
 		spin_lock(&ailp->ail_lock);
 		if (error) {
 			trace_xlog_intent_recovery_failed(log->l_mp, error,
-					lip->li_ops->iop_recover);
+					ops->iop_recover);
 			break;
 		}
 	}
-- 
2.43.0.rc0.421.g78406f8d94-goog

