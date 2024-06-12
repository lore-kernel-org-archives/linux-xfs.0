Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E380A34
	for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2024 22:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718232715; cv=none; b=ZFGWnZgEUV00aMRekeUGZO4cojxAEjxvsT8LanKEfGtB0dsV1ycBhsVA5k6atwIQkQIKkym1ff1Jeijso58MkXmZ9uSA5deFN23grRcxrCJRtMHkBMSydBcmlFe0t+e4afjTVpMcz2zoUmuww4wIkJ+zX/Qkmh+GoS6sW4BTlDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718232715; c=relaxed/simple;
	bh=j+7WWTxB3DWN3W0J1QiPAAfjf0XykOCnJ1GyYJ77PE4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Ikd8fAhFqFClTbB1jTdo9HbEAt22bagoI9osBo1DczzaJ7RgYyMejZnjlNZcO2Dv3H1/3oCMn5SV0EzTrGWf6LIFvP+bTtp0oaJ53dDP/ob1E1xeLCL1DTYrNkS1EOHbqU48/yUo2Pt+DVmbSyZyz9OazwC0GTwOSHrOPNH429o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=nDgo1XLA; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="nDgo1XLA"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-6f8ec7e054dso244513b3a.2
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2024 15:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1718232712; x=1718837512; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=3WPet2QcfxN2s49jN9Tpg7q1vnD3NjCpgWIH0MVUM3I=;
        b=nDgo1XLApsZPesHzPQmYuZAv05dxr5Sk5+diW5NTEn0cj2v46kdRcsDpmFRYErkmqr
         kSEHHQpyVn/4MLxzE8g4DLuFr3cd3tyV4gIj5AUq1W9CK9Oz084/9fmtMnB1DdkXS/4/
         70gGY4Eqj3c+RP40BjbA46h8KCqiJm+nYvj8vsu5fuhQ/2iSQlDjwfdBxCaYBr2jttMT
         kANsdLxmNv91unJhM/rh22bAqsaLj9treooFfs0ydbYIyxqRogbGqBsEX4FGcFu4iVs0
         6FJLZm+PPwfDQa0UlamYQfMoBlsEZQ3K5SUzCjjG6jlYxIuOBhZ4h6YTmYyalRsZVMR3
         ZLDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718232712; x=1718837512;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3WPet2QcfxN2s49jN9Tpg7q1vnD3NjCpgWIH0MVUM3I=;
        b=FQTdCbCQbKstq8XVyyQoTQoFzLYuqo0m7os29lrWtY1hitsc+RFcmnpb7DD3OcsY1r
         9xx7qOgkCiqSYSr+qrvWIKz0tta247DfAqgT7PIqw4IaI5GjnuAtOyDPBnDdz1w/cucW
         /s279kkYFM1ydXqj3LtincWRZFtZ+7iVJvZBO3KwgaYtyFtu+GozQVPRgxMTYAgAVL0Y
         yFowiBwJhB2+s3FuZ11FhIOGtu5soJiWlAvQQXSnb99JWfUxBKLhMuYf/zHB7EKN1ZNR
         4SAGQMSXPd3RXeZxvPnYZT9Kg1MzG0U8dIBRpfPuDiY86DvN2W5FlT/tR1xsWPM4yJC3
         Ezmg==
X-Gm-Message-State: AOJu0YyaGZm9rvFkfcUAZ3Fs9RF+AvvIRZn7eYG1t0Zm6J2j3rOEmqJ3
	ZeI2km5qvo4j7FH+CDlDZ3e3J5vxI5i6Uq2tMOg7bGuilOQGLp2wFzbD6COgXzhEhd604b/rzCD
	A
X-Google-Smtp-Source: AGHT+IGo02t3kmhVivr16s14XF05FC2JpgSlJLOuwAxwrKp4/IE42tEe5XD+x1lsMdw0OVGSBD2r3w==
X-Received: by 2002:aa7:8893:0:b0:705:ac54:2dd0 with SMTP id d2e1a72fcca58-705bce62858mr3997327b3a.18.1718232711920;
        Wed, 12 Jun 2024 15:51:51 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-705ccb3bfc8sm73738b3a.123.2024.06.12.15.51.51
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jun 2024 15:51:51 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1sHWom-00Dq4E-2T
	for linux-xfs@vger.kernel.org;
	Thu, 13 Jun 2024 08:51:48 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1sHWom-0000000GjuQ-13Dv
	for linux-xfs@vger.kernel.org;
	Thu, 13 Jun 2024 08:51:48 +1000
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: fix unlink vs cluster buffer instantiation race
Date: Thu, 13 Jun 2024 08:51:48 +1000
Message-ID: <20240612225148.3989713-1-david@fromorbit.com>
X-Mailer: git-send-email 2.45.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

Luis has been reporting an assert failure when freeing an inode
cluster during inode inactivation for a while. The assert looks
like:

 XFS: Assertion failed: bp->b_flags & XBF_DONE, file: fs/xfs/xfs_trans_buf.c, line: 241
 ------------[ cut here ]------------
 kernel BUG at fs/xfs/xfs_message.c:102!
 Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
 CPU: 4 PID: 73 Comm: kworker/4:1 Not tainted 6.10.0-rc1 #4
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
 Workqueue: xfs-inodegc/loop5 xfs_inodegc_worker [xfs]
 RIP: 0010:assfail (fs/xfs/xfs_message.c:102) xfs
 RSP: 0018:ffff88810188f7f0 EFLAGS: 00010202
 RAX: 0000000000000000 RBX: ffff88816e748250 RCX: 1ffffffff844b0e7
 RDX: 0000000000000004 RSI: ffff88810188f558 RDI: ffffffffc2431fa0
 RBP: 1ffff11020311f01 R08: 0000000042431f9f R09: ffffed1020311e9b
 R10: ffff88810188f4df R11: ffffffffac725d70 R12: ffff88817a3f4000
 R13: ffff88812182f000 R14: ffff88810188f998 R15: ffffffffc2423f80
 FS:  0000000000000000(0000) GS:ffff8881c8400000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 000055fe9d0f109c CR3: 000000014426c002 CR4: 0000000000770ef0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe07f0 DR7: 0000000000000400
 PKRU: 55555554
 Call Trace:
  <TASK>
 xfs_trans_read_buf_map (fs/xfs/xfs_trans_buf.c:241 (discriminator 1)) xfs
 xfs_imap_to_bp (fs/xfs/xfs_trans.h:210 fs/xfs/libxfs/xfs_inode_buf.c:138) xfs
 xfs_inode_item_precommit (fs/xfs/xfs_inode_item.c:145) xfs
 xfs_trans_run_precommits (fs/xfs/xfs_trans.c:931) xfs
 __xfs_trans_commit (fs/xfs/xfs_trans.c:966) xfs
 xfs_inactive_ifree (fs/xfs/xfs_inode.c:1811) xfs
 xfs_inactive (fs/xfs/xfs_inode.c:2013) xfs
 xfs_inodegc_worker (fs/xfs/xfs_icache.c:1841 fs/xfs/xfs_icache.c:1886) xfs
 process_one_work (kernel/workqueue.c:3231)
 worker_thread (kernel/workqueue.c:3306 (discriminator 2) kernel/workqueue.c:3393 (discriminator 2))
 kthread (kernel/kthread.c:389)
 ret_from_fork (arch/x86/kernel/process.c:147)
 ret_from_fork_asm (arch/x86/entry/entry_64.S:257)
  </TASK>

And occurs when the the inode precommit handlers is attempt to look
up the inode cluster buffer to attach the inode for writeback.

The trail of logic that I can reconstruct is as follows.

	1. the inode is clean when inodegc runs, so it is not
	   attached to a cluster buffer when precommit runs.

	2. #1 implies the inode cluster buffer may be clean and not
	   pinned by dirty inodes when inodegc runs.

	3. #2 implies that the inode cluster buffer can be reclaimed
	   by memory pressure at any time.

	4. The assert failure implies that the cluster buffer was
	   attached to the transaction, but not marked done. It had
	   been accessed earlier in the transaction, but not marked
	   done.

	5. #4 implies the cluster buffer has been invalidated (i.e.
	   marked stale).

	6. #5 implies that the inode cluster buffer was instantiated
	   uninitialised in the transaction in xfs_ifree_cluster(),
	   which only instantiates the buffers to invalidate them
	   and never marks them as done.

Given factors 1-3, this issue is highly dependent on timing and
environmental factors. Hence the issue can be very difficult to
reproduce in some situations, but highly reliable in others. Luis
has an environment where it can be reproduced easily by g/531 but,
OTOH, I've reproduced it only once in ~2000 cycles of g/531.

I think the fix is to have xfs_ifree_cluster() set the XBF_DONE flag
on the cluster buffers, even though they may not be initialised. The
reasons why I think this is safe are:

	1. A buffer cache lookup hit on a XBF_STALE buffer will
	   clear the XBF_DONE flag. Hence all future users of the
	   buffer know they have to re-initialise the contents
	   before use and mark it done themselves.

	2. xfs_trans_binval() sets the XFS_BLI_STALE flag, which
	   means the buffer remains locked until the journal commit
	   completes and the buffer is unpinned. Hence once marked
	   XBF_STALE/XFS_BLI_STALE by xfs_ifree_cluster(), the only
	   context that can access the freed buffer is the currently
	   running transaction.

	3. #2 implies that future buffer lookups in the currently
	   running transaction will hit the transaction match code
	   and not the buffer cache. Hence XBF_STALE and
	   XFS_BLI_STALE will not be cleared unless the transaction
	   initialises and logs the buffer with valid contents
	   again. At which point, the buffer will be marked marked
	   XBF_DONE again, so having XBF_DONE already set on the
	   stale buffer is a moot point.

	4. #2 also implies that any concurrent access to that
	   cluster buffer will block waiting on the buffer lock
	   until the inode cluster has been fully freed and is no
	   longer an active inode cluster buffer.

	5. #4 + #1 means that any future user of the disk range of
	   that buffer will always see the range of disk blocks
	   covered by the cluster buffer as not done, and hence must
	   initialise the contents themselves.

	6. Setting XBF_DONE in xfs_ifree_cluster() then means the
	   unlinked inode precommit code will see a XBF_DONE buffer
	   from the transaction match as it expects. It can then
	   attach the stale but newly dirtied inode to the stale
	   but newly dirtied cluster buffer without unexpected
	   failures. The stale buffer will then sail through the
	   journal and do the right thing with the attached stale
	   inode during unpin.

Hence the fix is just one line of extra code. The explanation of
why we have to set XBF_DONE in xfs_ifree_cluster, OTOH, is long and
complex....

Fixes: 82842fee6e59 ("xfs: fix AGF vs inode cluster buffer deadlock")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Tested-by: Luis Chamberlain <mcgrof@kernel.org>
---
 fs/xfs/xfs_inode.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 58fb7a5062e1..f36091e1e7f5 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2548,11 +2548,26 @@ xfs_ifree_cluster(
 		 * This buffer may not have been correctly initialised as we
 		 * didn't read it from disk. That's not important because we are
 		 * only using to mark the buffer as stale in the log, and to
-		 * attach stale cached inodes on it. That means it will never be
-		 * dispatched for IO. If it is, we want to know about it, and we
-		 * want it to fail. We can acheive this by adding a write
-		 * verifier to the buffer.
+		 * attach stale cached inodes on it.
+		 *
+		 * For the inode that triggered the cluster freeing, this
+		 * attachment may occur in xfs_inode_item_precommit() after we
+		 * have marked this buffer stale.  If this buffer was not in
+		 * memory before xfs_ifree_cluster() started, it will not be
+		 * marked XBF_DONE and this will cause problems later in
+		 * xfs_inode_item_precommit() when we trip over a (stale, !done)
+		 * buffer to attached to the transaction.
+		 *
+		 * Hence we have to mark the buffer as XFS_DONE here. This is
+		 * safe because we are also marking the buffer as XBF_STALE and
+		 * XFS_BLI_STALE. That means it will never be dispatched for
+		 * IO and it won't be unlocked until the cluster freeing has
+		 * been committed to the journal and the buffer unpinned. If it
+		 * is written, we want to know about it, and we want it to
+		 * fail. We can acheive this by adding a write verifier to the
+		 * buffer.
 		 */
+		bp->b_flags |= XBF_DONE;
 		bp->b_ops = &xfs_inode_buf_ops;
 
 		/*
-- 
2.45.1

