Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49D14C25B06
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Aug 2022 18:06:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238831AbiHDSGh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Aug 2022 14:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239723AbiHDSGg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Aug 2022 14:06:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71DED2A434
        for <linux-xfs@vger.kernel.org>; Thu,  4 Aug 2022 11:06:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FEBD6158F
        for <linux-xfs@vger.kernel.org>; Thu,  4 Aug 2022 18:06:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F87EC433D7;
        Thu,  4 Aug 2022 18:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659636394;
        bh=7nizsB7qYrm5z71+TaXuMhnNcKgCbKNs9H3qGvnt5i4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=aQqa57tbzQ4RsJF0S6t+Y4hr/Yi1QrzF1wCjKqv8fR3mm+kgpxKP98FtN6lNXdqfT
         /EsdIyEVLJ45P+3hnRxcUJvGiNRUXnWua35CgcPg5eCU9L5aydud0rIi5ovk05dgic
         L3RY7pbCt4dB9jxHRQP/E8deuaICO57MPsaJD4wbXHocc/Ki5DO1Hesh3WFwi+a9Nd
         jOGtPAQfYmnkdqwimXPJgRzh8dMR4Yr4nNBtBqFFC1oqM1ZEuHX6tetRqsTFqg9KNI
         btf08Xku1N6bYN6qRLbDqU9NgtxVHIbAnILyPquTmE1SY5QLr4DvZrt4emCUiFLMh8
         zLHO/EVtv/QHw==
Subject: [PATCH 2/2] xfs: fix intermittent hang during quotacheck
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Thu, 04 Aug 2022 11:06:33 -0700
Message-ID: <165963639392.1272632.16910716528071046151.stgit@magnolia>
In-Reply-To: <165963638241.1272632.9852314965190809423.stgit@magnolia>
References: <165963638241.1272632.9852314965190809423.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Every now and then, I see the following hang during mount time
quotacheck when running fstests.  Turning on KASAN seems to make it
happen somewhat more frequently.  I've edited the backtrace for brevity.

XFS (sdd): Quotacheck needed: Please wait.
XFS: Assertion failed: bp->b_flags & _XBF_DELWRI_Q, file: fs/xfs/xfs_buf.c, line: 2411
------------[ cut here ]------------
WARNING: CPU: 0 PID: 1831409 at fs/xfs/xfs_message.c:104 assfail+0x46/0x4a [xfs]
CPU: 0 PID: 1831409 Comm: mount Tainted: G        W         5.19.0-rc6-xfsx #rc6 09911566947b9f737b036b4af85e399e4b9aef64
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1 04/01/2014
RIP: 0010:assfail+0x46/0x4a [xfs]
Code: a0 8f 41 a0 e8 45 fe ff ff 8a 1d 2c 36 10 00 80 fb 01 76 0f 0f b6 f3 48 c7 c7 c0 f0 4f a0 e8 10 f0 02 e1 80 e3 01 74 02 0f 0b <0f> 0b 5b c3 48 8d 45 10 48 89 e2 4c 89 e6 48 89 1c 24 48 89 44 24
RSP: 0018:ffffc900078c7b30 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff8880099ac000 RCX: 000000007fffffff
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffffa0418fa0
RBP: ffff8880197bc1c0 R08: 0000000000000000 R09: 000000000000000a
R10: 000000000000000a R11: f000000000000000 R12: ffffc900078c7d20
R13: 00000000fffffff5 R14: ffffc900078c7d20 R15: 0000000000000000
FS:  00007f0449903800(0000) GS:ffff88803ec00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005610ada631f0 CR3: 0000000014dd8002 CR4: 00000000001706f0
Call Trace:
 <TASK>
 xfs_buf_delwri_pushbuf+0x150/0x160 [xfs 4561f5b32c9bfb874ec98d58d0719464e1f87368]
 xfs_qm_flush_one+0xd6/0x130 [xfs 4561f5b32c9bfb874ec98d58d0719464e1f87368]
 xfs_qm_dquot_walk.isra.0+0x109/0x1e0 [xfs 4561f5b32c9bfb874ec98d58d0719464e1f87368]
 xfs_qm_quotacheck+0x319/0x490 [xfs 4561f5b32c9bfb874ec98d58d0719464e1f87368]
 xfs_qm_mount_quotas+0x65/0x2c0 [xfs 4561f5b32c9bfb874ec98d58d0719464e1f87368]
 xfs_mountfs+0x6b5/0xab0 [xfs 4561f5b32c9bfb874ec98d58d0719464e1f87368]
 xfs_fs_fill_super+0x781/0x990 [xfs 4561f5b32c9bfb874ec98d58d0719464e1f87368]
 get_tree_bdev+0x175/0x280
 vfs_get_tree+0x1a/0x80
 path_mount+0x6f5/0xaa0
 __x64_sys_mount+0x103/0x140
 do_syscall_64+0x2b/0x80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

I /think/ this can happen if xfs_qm_flush_one is racing with
xfs_qm_dquot_isolate (i.e. dquot reclaim) when the second function has
taken the dquot flush lock but xfs_qm_dqflush hasn't yet locked the
dquot buffer, let alone queued it to the delwri list.  In this case,
flush_one will fail to get the dquot flush lock, but it can lock the
incore buffer, but xfs_buf_delwri_pushbuf will then trip over this
ASSERT, which checks that the buffer isn't on a delwri list.  The hang
results because the _delwri_submit_buffers ignores non DELWRI_Q buffers,
which means that xfs_buf_iowait waits forever for an IO that has not yet
been scheduled.

AFAICT, a reasonable solution here is to detect a dquot buffer that is
not on a DELWRI list, drop it, and return -EAGAIN to try the flush
again.  It's not /that/ big of a deal if quotacheck writes the dquot
buffer repeatedly before we even set QUOTA_CHKD.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_qm.c |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 57dd3b722265..95ea99070377 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1234,6 +1234,11 @@ xfs_qm_flush_one(
 		if (error)
 			goto out_unlock;
 
+		if (!(bp->b_flags & _XBF_DELWRI_Q)) {
+			error = -EAGAIN;
+			xfs_buf_relse(bp);
+			goto out_unlock;
+		}
 		xfs_buf_unlock(bp);
 
 		xfs_buf_delwri_pushbuf(bp, buffer_list);

