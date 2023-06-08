Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EAA9C7EE37
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Jun 2023 22:17:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232448AbjFHWRI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Jun 2023 18:17:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjFHWRH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Jun 2023 18:17:07 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E4BE1FEC;
        Thu,  8 Jun 2023 15:17:06 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1b2439e9004so1713805ad.3;
        Thu, 08 Jun 2023 15:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686262625; x=1688854625;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HX1IQ1/HEFBoXGJYXsygQh2evXU1wFhphVslFZWBOwU=;
        b=Gl0OM6PtgAIwYEGOPoR24i0pngrNH+OuDeMEk/teeSzN7dlL2Co868qf5xS02hpOZ0
         O23P64tyqOTkqjYUyeZbFgAIoyNZdcR60EzxP6Y7HeHh74+d0mgU+Ctd7OEapFFcqU57
         KUBO28haBvwQwVJq0jjQ/lImhbLiTK0ILgDdnipbbfgpyWx8KDFLTmD2V2DTg3UkQGsR
         vbtGvS+fzn0QtKnFoXY2AVNm8jpOWVqfmxEhlbw6Qr72FoqoTgZKv1RRrYjffBAuEN68
         scnvFTJRp1XvGVeaInotG0irEJD6JDvrbt2t0J6t8pIZPbTsyJqGdDU5eMLOJWCvkBFQ
         2uuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686262625; x=1688854625;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HX1IQ1/HEFBoXGJYXsygQh2evXU1wFhphVslFZWBOwU=;
        b=L/mg44jZAFBeXrWeNYK51IOqQDLh6f5/1+k0Si+Kr7ZbEDjVOlH7XyrAasg65ZBP1n
         aeeq0oqRVOTqhnh6yEo3RdL/kh/PSZKMvogLFD0H6m2z1SdlPf6f08b9lZIT/boUVk7J
         gWFM+BEe+qwO1Oc5yFsRB/EJKxXabX035FofDTncH6ydD/H//ABAW8yqfglXX2EjLBaM
         NMB6l1szUZ8Zil+DPn4jlzLp0x3F/mtizjuTK0Bql6UypMHYjUcm/wl9CKp4XJNLoWbF
         JMD03ggp9Y/cO03X/9Df2eisdBnPGSNJ0w4fAYwTnJ2ZLoseGlJx7q8ulzs18s6rtskG
         nopQ==
X-Gm-Message-State: AC+VfDwYgGLnw9tsGTL8CATJgVtuOy4hohH1IxxnPK2UuKhWlGmV92WS
        6M36Yyv4VLMzbfNRTUEj2DghVO3uZomREavo
X-Google-Smtp-Source: ACHHUZ5O/E+ELH6LZSjnlRFmmYM1etVENDWKdiQfkk4cz9RVHgrJI+VnIx1hT5moTWVHJ5kTlXmo1A==
X-Received: by 2002:a17:903:32ce:b0:1b0:4883:2e03 with SMTP id i14-20020a17090332ce00b001b048832e03mr6333143plr.40.1686262625214;
        Thu, 08 Jun 2023 15:17:05 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:b463:9de:46ef:7f35])
        by smtp.gmail.com with ESMTPSA id jf22-20020a170903269600b001b00a44e557sm1892052plb.94.2023.06.08.15.17.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 15:17:04 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     amir73il@gmail.com, chandan.babu@oracle.com,
        linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15] xfs: verify buffer contents when we skip log replay
Date:   Thu,  8 Jun 2023 15:16:59 -0700
Message-ID: <20230608221659.3708315-1-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 22ed903eee23a5b174e240f1cdfa9acf393a5210 ]

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
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---

Hi,

Tested and good to go for 5.15.y.

Thanks,
Leah

 fs/xfs/xfs_buf_item_recover.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 991fbf1eb564..e04e44ef14c6 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -934,6 +934,16 @@ xlog_recover_buf_commit_pass2(
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
2.41.0.162.gfafddb0af9-goog

