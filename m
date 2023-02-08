Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84907C636CC
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Feb 2023 17:52:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbjBHRww (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Feb 2023 12:52:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjBHRwv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Feb 2023 12:52:51 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0D81768D
        for <linux-xfs@vger.kernel.org>; Wed,  8 Feb 2023 09:52:50 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id mi9so19128402pjb.4
        for <linux-xfs@vger.kernel.org>; Wed, 08 Feb 2023 09:52:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rARtIHdQe5IIw3Wd0wifRnJtnfPDfUqMH4bk9/jyx9Q=;
        b=A5dkN+qlx4Ljo0KCbPHMyfg7Em8bph+LjB/V0H+B7+T+bFN/AmQ34RasDCdWjcS92B
         HEQvp3HB2oMfdSr+6t2UGp38L/w7ouPGO7eKDm80j7z+fjanj4bUkZssLVlOFM04k/t1
         SBNuDXXyxOEa9E8KNAxxPWOZL5avwfqDZ1m78QgeqRqNC7WqTsKT02ajSsPXl9qhqODP
         kcaGv4kKU7qLKyo4QuFXZDQBkjj8zMlm1BNUGwA+QGfm1FR8+hdRd8rVwBVTVy6WXZvK
         dj3aUituKvQjKuxNEbNhFfGgKcY8r2SPI1tTBrot8PWKQnMtat2MvbIATKHDCOQWnxFg
         l3EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rARtIHdQe5IIw3Wd0wifRnJtnfPDfUqMH4bk9/jyx9Q=;
        b=ccVI/3IyaA4PDl/Q3CG+8QUEJh0QQCLVebST5jT/cU8hcw/5qddUo2iOf9k6j+GOdu
         2UzagyWvbIHHzokKkzsYrv7Ctd13sozxzl41lm3OYoHnkpvlBEOfLQUbztukSkX2Gzm+
         6T7SVrpzenjxIqoyRjNwb3nEkNNR1iwQWaP5h0tZRx9IPAounQnWlG8JIvXlP2KFhZo9
         RaCW7qDCwO+/nEFumAwuLwGEM5SYRXDMfmrOtDJj5RA8lT4qzxPu2ntNNlw+zwj6bcNk
         a0UGBoSUNch1FpnjMasd/xpfbm5bpz0KcpsfzQHgjaoe1NVgpWyTdVxNJESs6L77BQsc
         B/Gg==
X-Gm-Message-State: AO0yUKXV3pm3vr/ZTPmAtavu+bgovvz9Ki2SSUboFdwNB/x3zfvfsJfj
        /UF5eMaszLWFSr8X6aiyfJK07oMvSMkLPg==
X-Google-Smtp-Source: AK7set9tqx9CPvisVULrw7JSKsJ2vauGYZoHbRF+dXA0UxX0C6hjKppZ99mPIXJStsoP14YD67S4Bw==
X-Received: by 2002:a05:6a21:6d9f:b0:bc:bf86:660 with SMTP id wl31-20020a056a216d9f00b000bcbf860660mr10023073pzb.45.1675878769870;
        Wed, 08 Feb 2023 09:52:49 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:726:5e6d:fcde:4245])
        by smtp.gmail.com with ESMTPSA id y17-20020a170902d65100b00198e397994bsm10911452plh.136.2023.02.08.09.52.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 09:52:49 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, chandan.babu@oracle.com,
        "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 09/10] xfs: purge dquots after inode walk fails during quotacheck
Date:   Wed,  8 Feb 2023 09:52:27 -0800
Message-Id: <20230208175228.2226263-10-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
In-Reply-To: <20230208175228.2226263-1-leah.rumancik@gmail.com>
References: <20230208175228.2226263-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 86d40f1e49e9a909d25c35ba01bea80dbcd758cb ]

xfs/434 and xfs/436 have been reporting occasional memory leaks of
xfs_dquot objects.  These tests themselves were the messenger, not the
culprit, since they unload the xfs module, which trips the slub
debugging code while tearing down all the xfs slab caches:

=============================================================================
BUG xfs_dquot (Tainted: G        W        ): Objects remaining in xfs_dquot on __kmem_cache_shutdown()
-----------------------------------------------------------------------------

Slab 0xffffea000606de00 objects=30 used=5 fp=0xffff888181b78a78 flags=0x17ff80000010200(slab|head|node=0|zone=2|lastcpupid=0xfff)
CPU: 0 PID: 3953166 Comm: modprobe Tainted: G        W         5.18.0-rc6-djwx #rc6 d5824be9e46a2393677bda868f9b154d917ca6a7
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20171121_152543-x86-ol7-builder-01.us.oracle.com-4.el7.1 04/01/2014

Since we don't generally rmmod the xfs module between fstests, this
means that xfs/434 is really just the canary in the coal mine --
something leaked a dquot, but we don't know who.  After days of pounding
on fstests with kmemleak enabled, I finally got it to spit this out:

unreferenced object 0xffff8880465654c0 (size 536):
  comm "u10:4", pid 88, jiffies 4294935810 (age 29.512s)
  hex dump (first 32 bytes):
    60 4a 56 46 80 88 ff ff 58 ea e4 5c 80 88 ff ff  `JVF....X..\....
    00 e0 52 49 80 88 ff ff 01 00 01 00 00 00 00 00  ..RI............
  backtrace:
    [<ffffffffa0740f6c>] xfs_dquot_alloc+0x2c/0x530 [xfs]
    [<ffffffffa07443df>] xfs_qm_dqread+0x6f/0x330 [xfs]
    [<ffffffffa07462a2>] xfs_qm_dqget+0x132/0x4e0 [xfs]
    [<ffffffffa0756bb0>] xfs_qm_quotacheck_dqadjust+0xa0/0x3e0 [xfs]
    [<ffffffffa075724d>] xfs_qm_dqusage_adjust+0x35d/0x4f0 [xfs]
    [<ffffffffa06c9068>] xfs_iwalk_ag_recs+0x348/0x5d0 [xfs]
    [<ffffffffa06c95d3>] xfs_iwalk_run_callbacks+0x273/0x540 [xfs]
    [<ffffffffa06c9e8d>] xfs_iwalk_ag+0x5ed/0x890 [xfs]
    [<ffffffffa06ca22f>] xfs_iwalk_ag_work+0xff/0x170 [xfs]
    [<ffffffffa06d22c9>] xfs_pwork_work+0x79/0x130 [xfs]
    [<ffffffff81170bb2>] process_one_work+0x672/0x1040
    [<ffffffff81171b1b>] worker_thread+0x59b/0xec0
    [<ffffffff8118711e>] kthread+0x29e/0x340
    [<ffffffff810032bf>] ret_from_fork+0x1f/0x30

Now we know that quotacheck is at fault, but even this report was
canaryish -- it was triggered by xfs/494, which doesn't actually mount
any filesystems.  (kmemleak can be a little slow to notice leaks, even
with fstests repeatedly whacking it to look for them.)  Looking at the
*previous* fstest, however, showed that the test run before xfs/494 was
xfs/117.  The tipoff to the problem is in this excerpt from dmesg:

XFS (sda4): Quotacheck needed: Please wait.
XFS (sda4): Metadata corruption detected at xfs_dinode_verify.part.0+0xdb/0x7b0 [xfs], inode 0x119 dinode
XFS (sda4): Unmount and run xfs_repair
XFS (sda4): First 128 bytes of corrupted metadata buffer:
00000000: 49 4e 81 a4 03 02 00 00 00 00 00 00 00 00 00 00  IN..............
00000010: 00 00 00 01 00 00 00 00 00 90 57 54 54 1a 4c 68  ..........WTT.Lh
00000020: 81 f9 7d e1 6d ee 16 00 34 bd 7d e1 6d ee 16 00  ..}.m...4.}.m...
00000030: 34 bd 7d e1 6d ee 16 00 00 00 00 00 00 00 00 00  4.}.m...........
00000040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000050: 00 00 00 02 00 00 00 00 00 00 00 00 96 80 f3 ab  ................
00000060: ff ff ff ff da 57 7b 11 00 00 00 00 00 00 00 03  .....W{.........
00000070: 00 00 00 01 00 00 00 10 00 00 00 00 00 00 00 08  ................
XFS (sda4): Quotacheck: Unsuccessful (Error -117): Disabling quotas.

The dinode verifier decided that the inode was corrupt, which causes
iget to return with EFSCORRUPTED.  Since this happened during
quotacheck, it is obvious that the kernel aborted the inode walk on
account of the corruption error and disabled quotas.  Unfortunately, we
neglect to purge the dquot cache before doing that, which is how the
dquots leaked.

The problems started 10 years ago in commit b84a3a, when the dquot lists
were converted to a radix tree, but the error handling behavior was not
correctly preserved -- in that commit, if the bulkstat failed and
usrquota was enabled, the bulkstat failure code would be overwritten by
the result of flushing all the dquots to disk.  As long as that
succeeds, we'd continue the quota mount as if everything were ok, but
instead we're now operating with a corrupt inode and incorrect quota
usage counts.  I didn't notice this bug in 2019 when I wrote commit
ebd126a, which changed quotacheck to skip the dqflush when the scan
doesn't complete due to inode walk failures.

Introduced-by: b84a3a96751f ("xfs: remove the per-filesystem list of dquots")
Fixes: ebd126a651f8 ("xfs: convert quotacheck to use the new iwalk functions")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_qm.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 5608066d6e53..623244650a2f 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1317,8 +1317,15 @@ xfs_qm_quotacheck(
 
 	error = xfs_iwalk_threaded(mp, 0, 0, xfs_qm_dqusage_adjust, 0, true,
 			NULL);
-	if (error)
+	if (error) {
+		/*
+		 * The inode walk may have partially populated the dquot
+		 * caches.  We must purge them before disabling quota and
+		 * tearing down the quotainfo, or else the dquots will leak.
+		 */
+		xfs_qm_dqpurge_all(mp);
 		goto error_return;
+	}
 
 	/*
 	 * We've made all the changes that we need to make incore.  Flush them
-- 
2.39.1.519.gcb327c4b5f-goog

