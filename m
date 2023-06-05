Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24836C7EE24
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jun 2023 07:54:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbjFEHyJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Jun 2023 03:54:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231454AbjFEHxt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jun 2023 03:53:49 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD35310D3;
        Mon,  5 Jun 2023 00:53:09 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-3f603d4bc5bso44731255e9.3;
        Mon, 05 Jun 2023 00:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685951588; x=1688543588;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NMqs9fVxlAA2xfIhTlEnAarhwN2EZOVrUAsaYNMFxHE=;
        b=h4vGWi7UaZhtBW6w3Qc3q8E/DRSKLo1ykt8xmEE/nNcQ1WrK5yn9zIxk8nU/8CiMbH
         lAkuMjBjvt2RTmvcpkGcboCXzeROCOhAAAXQ83l/YeDDJDDM+Xtw7ghTLxpmPQBIbX/c
         Gn8gB4kSuOcxfgPDJfvh3z0oZtekAiV1t12CiX1bVDte8o71AUlNt1CQW7e8phvOZ+iH
         KfM7RvM5DhzN/+Y11nHz7UxhJoMWXRlbrulwv1nQIn0NMH1VV+GwVmL6J9TGBS7ZfPKj
         JTA2uwtvUSBPppEENHFrA0yEIC6mMlt7MG6Epkx8gLpS+wMNAa4gbC9rB9Il8hKoN0rh
         fgxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685951588; x=1688543588;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NMqs9fVxlAA2xfIhTlEnAarhwN2EZOVrUAsaYNMFxHE=;
        b=G/M1Iqo1YnrDeieJtSNTnocopboxsnyKMibdEVOjpFZgP6v0MTA+gL8OyAI//mKn8b
         to7g63AW+DgbJpnG/YDZnefCs2cWEhiwxjV1ZR+cw3Qmm1f7yy6TwfhkYlxVZX5nDEha
         RxGkuIio15DKppDFJ14kNxinhtBY4fz5WRiD+USQBFH0gRMdKmvNo0xOjnYt///7IbEz
         BgZEMQQbwumkvwyvV0yWREeZJ+v9Da7s5x5MyUQOGr9ZPKv4QGOU6Q/e6yLh1WRAyL0X
         QEFJf5tlAVerKDm/5gh9U2JrjFfY/HwJUelNRF1mtka0cb3Nh+4FAmLLpVSF7EKhHqvn
         VH8A==
X-Gm-Message-State: AC+VfDy0/e6YZXowmr1Onhkv69rPtpXKW7PwICoRVo5mkAFAOMz5LbwO
        NFJpPhjJinTZ3S+8/uK+gIhDljUL2vQ=
X-Google-Smtp-Source: ACHHUZ7U/h7APWURDw4fHDGEHwBihv4Kq7fU3G46Kvh9Q1tksJxvYvGbGVwxkXcbTJfFyh/bfhQPfA==
X-Received: by 2002:a05:600c:228e:b0:3f6:496:e240 with SMTP id 14-20020a05600c228e00b003f60496e240mr7323352wmf.27.1685951587887;
        Mon, 05 Jun 2023 00:53:07 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (bzq-166-168-31-246.red.bezeqint.net. [31.168.166.246])
        by smtp.gmail.com with ESMTPSA id n24-20020a1c7218000000b003f4fffccd73sm9945417wmc.9.2023.06.05.00.53.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 00:53:07 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Danila Chernetsov <listdansp@mail.ru>
Subject: [PATCH 6.1] xfs: verify buffer contents when we skip log replay
Date:   Mon,  5 Jun 2023 10:52:58 +0300
Message-Id: <20230605075258.308475-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit 22ed903eee23a5b174e240f1cdfa9acf393a5210 upstream.

syzbot detected a crash during log recovery:

XFS (loop0): Mounting V5 Filesystem bfdc47fc-10d8-4eed-a562-11a831b3f791
XFS (loop0): Torn write (CRC failure) detected at log block 0x180. Truncating head block from 0x200.
XFS (loop0): Starting recovery (logdev: internal)
==================================================================
BUG: KASAN: slab-out-of-bounds in xfs_btree_lookup_get_block+0x15c/0x6d0 fs/xfs/libxfs/xfs_btree.c:1813
Read of size 8 at addr ffff88807e89f258 by task syz-executor132/5074

CPU: 0 PID: 5074 Comm: syz-executor132 Not tainted 6.2.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1b1/0x290 lib/dump_stack.c:106
 print_address_description+0x74/0x340 mm/kasan/report.c:306
 print_report+0x107/0x1f0 mm/kasan/report.c:417
 kasan_report+0xcd/0x100 mm/kasan/report.c:517
 xfs_btree_lookup_get_block+0x15c/0x6d0 fs/xfs/libxfs/xfs_btree.c:1813
 xfs_btree_lookup+0x346/0x12c0 fs/xfs/libxfs/xfs_btree.c:1913
 xfs_btree_simple_query_range+0xde/0x6a0 fs/xfs/libxfs/xfs_btree.c:4713
 xfs_btree_query_range+0x2db/0x380 fs/xfs/libxfs/xfs_btree.c:4953
 xfs_refcount_recover_cow_leftovers+0x2d1/0xa60 fs/xfs/libxfs/xfs_refcount.c:1946
 xfs_reflink_recover_cow+0xab/0x1b0 fs/xfs/xfs_reflink.c:930
 xlog_recover_finish+0x824/0x920 fs/xfs/xfs_log_recover.c:3493
 xfs_log_mount_finish+0x1ec/0x3d0 fs/xfs/xfs_log.c:829
 xfs_mountfs+0x146a/0x1ef0 fs/xfs/xfs_mount.c:933
 xfs_fs_fill_super+0xf95/0x11f0 fs/xfs/xfs_super.c:1666
 get_tree_bdev+0x400/0x620 fs/super.c:1282
 vfs_get_tree+0x88/0x270 fs/super.c:1489
 do_new_mount+0x289/0xad0 fs/namespace.c:3145
 do_mount fs/namespace.c:3488 [inline]
 __do_sys_mount fs/namespace.c:3697 [inline]
 __se_sys_mount+0x2d3/0x3c0 fs/namespace.c:3674
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f89fa3f4aca
Code: 83 c4 08 5b 5d c3 66 2e 0f 1f 84 00 00 00 00 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fffd5fb5ef8 EFLAGS: 00000206 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00646975756f6e2c RCX: 00007f89fa3f4aca
RDX: 0000000020000100 RSI: 0000000020009640 RDI: 00007fffd5fb5f10
RBP: 00007fffd5fb5f10 R08: 00007fffd5fb5f50 R09: 000000000000970d
R10: 0000000000200800 R11: 0000000000000206 R12: 0000000000000004
R13: 0000555556c6b2c0 R14: 0000000000200800 R15: 00007fffd5fb5f50
 </TASK>

The fuzzed image contains an AGF with an obviously garbage
agf_refcount_level value of 32, and a dirty log with a buffer log item
for that AGF.  The ondisk AGF has a higher LSN than the recovered log
item.  xlog_recover_buf_commit_pass2 reads the buffer, compares the
LSNs, and decides to skip replay because the ondisk buffer appears to be
newer.

Unfortunately, the ondisk buffer is corrupt, but recovery just read the
buffer with no buffer ops specified:

	error = xfs_buf_read(mp->m_ddev_targp, buf_f->blf_blkno,
			buf_f->blf_len, buf_flags, &bp, NULL);

Skipping the buffer leaves its contents in memory unverified.  This sets
us up for a kernel crash because xfs_refcount_recover_cow_leftovers
reads the buffer (which is still around in XBF_DONE state, so no read
verification) and creates a refcountbt cursor of height 32.  This is
impossible so we run off the end of the cursor object and crash.

Fix this by invoking the verifier on all skipped buffers and aborting
log recovery if the ondisk buffer is corrupt.  It might be smarter to
force replay the log item atop the buffer and then see if it'll pass the
write verifier (like ext4 does) but for now let's go with the
conservative option where we stop immediately.

Link: https://syzkaller.appspot.com/bug?extid=7e9494b8b399902e994e
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Reported-by: Danila Chernetsov <listdansp@mail.ru>
Link: https://lore.kernel.org/linux-xfs/20230601164439.15404-1-listdansp@mail.ru
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---

Greg,

This is the backport proposed by Danila for 5.10.y.
I've already tested it on 6.1.y as well as 5.10.y, but waiting for Leah to
test 5.15.y before requesting apply to 5.10.y.

Thanks,
Amir.

 fs/xfs/xfs_buf_item_recover.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index ffa94102094d..43167f543afc 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -943,6 +943,16 @@ xlog_recover_buf_commit_pass2(
 	if (lsn && lsn != -1 && XFS_LSN_CMP(lsn, current_lsn) >= 0) {
 		trace_xfs_log_recover_buf_skip(log, buf_f);
 		xlog_recover_validate_buf_type(mp, bp, buf_f, NULLCOMMITLSN);
+
+		/*
+		 * We're skipping replay of this buffer log item due to the log
+		 * item LSN being behind the ondisk buffer.  Verify the buffer
+		 * contents since we aren't going to run the write verifier.
+		 */
+		if (bp->b_ops) {
+			bp->b_ops->verify_read(bp);
+			error = bp->b_error;
+		}
 		goto out_release;
 	}
 
-- 
2.34.1

