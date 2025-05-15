Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA7677111
	for <linux-xfs@vger.kernel.org>; Thu, 15 May 2025 02:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747277798; cv=none; b=sTvp5K77FGKsK6ICxmKeeb5rShcMW7ya28UDxdqbdP8XZxDTdD134lpPPKxodi3sHSBoMx8fVJ5549i/IqLeVOCmtPQ1I8qQOiVzXXhj+7QrZqc9SeNFAdXs2L/X3j4ICnpuxMmPSWe7N6N67gKvYgRhwP+8WGsYl1ORQtF18sQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747277798; c=relaxed/simple;
	bh=ll8XOTL3wThmEeChGVNgdPMuTt6bXZ7nAA88YlIKLSU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XbH3UCjWdaYdVqgRVl+5KjYNsSUw0MSpCKq7NQdjb4lnxKK/tPO0B2ZAMNPpwUczsp4AeZaHbl2PLoh+Xq54OJ6LEgclrPDPA3RdnEtNfj1oIUCTUy4lC8ZVW4fmw61MeSAafxSfpcxDu9wM3lMBb+WYpeNMbOkQhhOJEMZMaDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=qVnPWl49; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="qVnPWl49"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-22e033a3a07so5076635ad.0
        for <linux-xfs@vger.kernel.org>; Wed, 14 May 2025 19:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1747277795; x=1747882595; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7QY4fXrKB3k9Aqevg1zItqmV88Zq6N/8uXP+ZEwwIpI=;
        b=qVnPWl4963Ynz6bSz9idrF5FTtN6XSpHtzRpvZNvnCAFZGiUBfKgLQ6U4OhwvnfsT6
         NMCVE/Lx1tIiUvcwltGaabWpOReca0zZLhZZIWIroljLpeEJOBCQHNkRU8uK95+RQ2TJ
         Famb9/IfhjbcKkPq7v/9bE/MrHyIt+O3KVM+eG2N4JcbU7uaENT4KuX80GCSwtLoDN60
         oNgiNg/HjgS/fyACQgmnSPm4EBBwrgieeI1VXYok9mEOCl5Vt5E62i6DxY7xzMwwRMua
         lQcMgoNtzKlb+73/Uokx3SHNRMAQTQrMv2W7NcHgwlJfSjd1namXoD22uyAkSnASiBqS
         fgow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747277795; x=1747882595;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7QY4fXrKB3k9Aqevg1zItqmV88Zq6N/8uXP+ZEwwIpI=;
        b=vOCL3ecf1qaFVm7m4GbIWDOnaEnhBqiSneZjyVUCAkLTJ+gsn6Aak3qHJiGDqmwnXe
         u8japKthyT9nTh4/z2GUSKcvZEElqkhTOBv40/j0aU09QcbjPB5lPaNhDLIvT0d01wKJ
         5X1M156FDK6M1y5LBiAC/ujTjYrZlrtDa6kuy0B8MOZZW1CPM1eh6g15oY6DUl65GNrY
         QqMn2uvooaJHiFQvDBtsLE4ojrtzVAP7l+X4Qo5b36fSO7jBmBL7mF6h+z/rGGdVF5fw
         aeIvUBGSy+eZ3mSPN1jmxXp1eJMEgzsv7XesADotYlkUG3gwq7mSFSoVUMVM+goxnEpW
         8luA==
X-Gm-Message-State: AOJu0Yy/rov60UHdD0H8VApvlq5MXXCyXdq51A5da9ixgm1qKFZkMACy
	YupKNUyRy6/iZXh3Xlu29XR0m4W9II/i+RjA+OkOySqnhlF3+aWXWR7jSwCFhUQtTfNL2xACgML
	p
X-Gm-Gg: ASbGnctuI4kx63dyreiZjlDBFB/GcWhqqVXOokmZaPUUw3bb4jifyAgbq1l/FUo6VSP
	W1je4xfy5n0pjjDBMtbQe8OK+DI9Cr00JHPQS/gSs8wsvVEvUr7YMxxKVFIRxkWAYS0eR19TDmB
	b/mepF6xhwKGVOzRT5Qb47PMBR0OUe8T66aSolmyod7wp0HHEp+Ft3MhSYWvVZrfNkoSaoB8nHe
	3gjQKoDEF9P4kOxu0TetoGhAJJChENBSDhwXKvVbdhPSUweNffPIBY2KTgn9eBQU4Z25pKMYKZs
	MxVGH7cYRFO/LiJ75D/ykkPdLQ5FYeL703i4P2CsaSz1ig/kzqz5km8PxbOgOiLReHzJflQ2phI
	8mhd8ZivItkpz/VvfS2V+BLKnuQ==
X-Google-Smtp-Source: AGHT+IG7WVhEUnA3P8kkJNm3RMd7up4DSw1Nv4oUGf2pR7UKMUbVd42ZXXi+HmDxnm7sBs0saZ9IRA==
X-Received: by 2002:a17:902:d4d1:b0:22c:33b2:e40e with SMTP id d9443c01a7336-231980cdd3amr76488185ad.2.1747277794376;
        Wed, 14 May 2025 19:56:34 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-184-88.pa.nsw.optusnet.com.au. [49.180.184.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22fc75468besm106535895ad.3.2025.05.14.19.56.32
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 May 2025 19:56:33 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.98.2)
	(envelope-from <dave@fromorbit.com>)
	id 1uFOlq-00000003f4l-0G7b
	for linux-xfs@vger.kernel.org;
	Thu, 15 May 2025 12:56:30 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.98)
	(envelope-from <dave@devoid.disaster.area>)
	id 1uFOlq-0000000ENhy-05i1
	for linux-xfs@vger.kernel.org;
	Thu, 15 May 2025 12:56:30 +1000
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] [RFC] xfs: fix unmount hang with unflushable inodes stuck in the AIL
Date: Thu, 15 May 2025 12:42:10 +1000
Message-ID: <20250515025628.3425734-3-david@fromorbit.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250515025628.3425734-1-david@fromorbit.com>
References: <20250515025628.3425734-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

	"The most effective debugging tool is still careful
	thought, coupled with judiciously placed print statements."

	- Brian Kernighan

I've been chasing an occasional unmount hangs when running
check-parallel for a couple of months now:

[95964.140623] Call Trace:
[95964.144641]  __schedule+0x699/0xb70
[95964.154003]  schedule+0x64/0xd0
[95964.156851]  xfs_ail_push_all_sync+0x9b/0xf0
[95964.164816]  xfs_unmount_flush_inodes+0x41/0x70
[95964.168698]  xfs_unmountfs+0x7f/0x170
[95964.171846]  xfs_fs_put_super+0x3b/0x90
[95964.175216]  generic_shutdown_super+0x77/0x160
[95964.178060]  kill_block_super+0x1b/0x40
[95964.180553]  xfs_kill_sb+0x12/0x30
[95964.182796]  deactivate_locked_super+0x38/0x100
[95964.185735]  deactivate_super+0x41/0x50
[95964.188245]  cleanup_mnt+0x9f/0x160
[95964.190519]  __cleanup_mnt+0x12/0x20
[95964.192899]  task_work_run+0x89/0xb0
[95964.195221]  resume_user_mode_work+0x4f/0x60
[95964.197931]  syscall_exit_to_user_mode+0x76/0xb0
[95964.201003]  do_syscall_64+0x74/0x130

$ pstree -N mnt |grep umount
	     |-check-parallel---nsexec---run_test.sh---753---umount

It always seems to be generic/753 that triggers this, and repeating
a quick group test run triggers it every 10-15 iterations. Hence it
generally triggers once up every 30-40 minutes of test time. just
running generic/753 by itself or concurrently with a limited group
of tests doesn't reproduce this issue at all.

Tracing on a hung system shows the AIL repeating every 50ms a log
force followed by an attempt to push pinned, aborted inodes from the
AIL (trimmed for brevity):

 xfs_log_force:   lsn 0x1c caller xfsaild+0x18e
 xfs_log_force:   lsn 0x0 caller xlog_cil_flush+0xbd
 xfs_log_force:   lsn 0x1c caller xfs_log_force+0x77
 xfs_ail_pinned:  lip 0xffff88826014afa0 lsn 1/37472 type XFS_LI_INODE flags IN_AIL|ABORTED
 xfs_ail_pinned:  lip 0xffff88814000a708 lsn 1/37472 type XFS_LI_INODE flags IN_AIL|ABORTED
 xfs_ail_pinned:  lip 0xffff88810b850c80 lsn 1/37472 type XFS_LI_INODE flags IN_AIL|ABORTED
 xfs_ail_pinned:  lip 0xffff88810b850af0 lsn 1/37472 type XFS_LI_INODE flags IN_AIL|ABORTED
 xfs_ail_pinned:  lip 0xffff888165cf0a28 lsn 1/37472 type XFS_LI_INODE flags IN_AIL|ABORTED
 xfs_ail_pinned:  lip 0xffff88810b850bb8 lsn 1/37472 type XFS_LI_INODE flags IN_AIL|ABORTED
 ....

The inode log items are marked as aborted, which means that either:

a) a transaction commit has occurred, seen an error or shutdown, and
called xfs_trans_free_items() to abort the items. This should happen
before any pinning of log items occurs.

or

b) a dirty transaction has been cancelled. This should also happen
before any pinning of log items occurs.

or

c) AIL insertion at journal IO completion is marked as aborted. In
this case, the log item is pinned by the CIL until journal IO
completes and hence needs to be unpinned. This is then done after
the ->iop_committed() callback is run, so the pin count should be
balanced correctly.

There are no other cases that set XFS_LI_ABORTED for inodes are set,
so it's not at all obvious why the item is pinned in the AIL.  I
added tracing to indicate why the inode item push is returning a
XFS_ITEM_PINNED value:

 xfs_log_force:         lsn 0x5e caller xfsaild+0x18e
 xfs_log_force:         lsn 0x0 caller xlog_cil_flush+0xbd
 xfs_log_force:         lsn 0x5e caller xfs_log_force+0x77
 xfs_inode_push_stale:  ino 0xc4 count 0 pincount 0 iflags 0x86 caller xfsaild+0x432
 xfs_ail_pinned:        lip 0xffff8882a20d5900 lsn 1/40853 type XFS_LI_INODE flags IN_AIL|ABORTED
 xfs_inode_push_stale:  ino 0xc1 count 0 pincount 0 iflags 0x86 caller xfsaild+0x432
 xfs_ail_pinned:        lip 0xffff8882a20d5518 lsn 1/40853 type XFS_LI_INODE flags IN_AIL

The inode flags are XFS_ISTALE | XFS_IRECLAIMABLE | XFS_IFLUSHING,
and this means xfs_inode_push_item() is triggering this code:

        if (!bp || (ip->i_flags & XFS_ISTALE)) {
                /*
                 * Inode item/buffer is being aborted due to cluster
                 * buffer deletion. Trigger a log force to have that operation
                 * completed and items removed from the AIL before the next push
                 * attempt.
                 */
>>>>>>          trace_xfs_inode_push_stale(ip, _RET_IP_);
                return XFS_ITEM_PINNED;
        }

XFS_IFLUSHING is set, so there should have been a buffer IO
completion that cleared that and removed the inode from the AIL.
Inode cluster freeing marks the inode XFS_ISTALE | XFS_IFLUSHING,
so this is a valid state for the inode to be in.

The inode cluster buffer is not in the AIL, so these inodes should
have been removed from the AIL when the inode cluster buffer was
aborted and unpinned.

However, I'm unclear on how the XFS_LI_ABORTED state is getting set
- there are a couple of places this can occur, and both should be
triggering the inode cluster buffer to remove the attached inodes
from the AIL and drop them. More tracing....

... and that was unexpected:

    xfsaild/dm-3-1747912 [047] ...1.   604.344253: xfs_inode_push_pinned: dev 251:3 ino 0x2020082 count 0 pincount 10 iflags 0x4 caller xfsaild+0x432
    xfsaild/dm-3-1747912 [047] ...1.   604.344253: xfs_ail_pinned:       dev 251:3 lip 0xffff88907a7a9838 lsn 1/4199 type XFS_LI_INODE flags IN_AIL
   kworker/u259:14-391   [019] .....   604.366776: xlog_ail_insert_abort: dev 251:3 lip 0xffff88907a7a9838 lsn 1/4199 type XFS_LI_INODE flags IN_AIL
   kworker/16:1H-1600438 [016] .....   604.366802: xlog_ail_insert_abort: dev 251:3 lip 0xffff88907a7a9838 lsn 1/4199 type XFS_LI_INODE flags IN_AIL|ABORTED
             <...>-382   [021] .....   604.366849: xlog_ail_insert_abort: dev 251:3 lip 0xffff88907a7a9838 lsn 1/4199 type XFS_LI_INODE flags IN_AIL|ABORTED
   kworker/16:1H-1600438 [016] .....   604.366866: xlog_ail_insert_abort: dev 251:3 lip 0xffff88907a7a9838 lsn 1/4199 type XFS_LI_INODE flags IN_AIL|ABORTED
   kworker/16:1H-1600438 [016] .....   604.366969: xlog_ail_insert_abort: dev 251:3 lip 0xffff88907a7a9838 lsn 1/4199 type XFS_LI_INODE flags IN_AIL|ABORTED
   kworker/16:1H-1600438 [016] .....   604.367005: xlog_ail_insert_abort: dev 251:3 lip 0xffff88907a7a9838 lsn 1/4199 type XFS_LI_INODE flags IN_AIL|ABORTED
 kworker/u258:32-1245394 [021] .....   604.367054: xlog_ail_insert_abort: dev 251:3 lip 0xffff88907a7a9838 lsn 1/4199 type XFS_LI_INODE flags IN_AIL|ABORTED
  kworker/u259:9-1580996 [023] .....   604.367109: xlog_ail_insert_abort: dev 251:3 lip 0xffff88907a7a9838 lsn 1/4199 type XFS_LI_INODE flags IN_AIL|ABORTED
             <...>-356   [028] .....   604.367163: xlog_ail_insert_abort: dev 251:3 lip 0xffff88907a7a9838 lsn 1/4199 type XFS_LI_INODE flags IN_AIL|ABORTED
           <...>-1245384 [028] .....   604.367213: xlog_ail_insert_abort: dev 251:3 lip 0xffff88907a7a9838 lsn 1/4199 type XFS_LI_INODE flags IN_AIL|ABORTED
    xfsaild/dm-3-1747912 [047] ...1.   604.396155: xfs_inode_push_stale: dev 251:3 ino 0x2020082 count 0 pincount 0 iflags 0x86 caller xfsaild+0x432
    xfsaild/dm-3-1747912 [047] ...1.   604.396156: xfs_ail_pinned:       dev 251:3 lip 0xffff88907a7a9838 lsn 1/4199 type XFS_LI_INODE flags IN_AIL|ABORTED

There are *10* log item aborts for the inode in question in about
500us. It's one for every pin count, so at least that adds up, but
we can only have 4 checkpoints in flight at once because we only
have 4 workers, right?

Ah - we are limited to *building* 4 checkpoints at once. As soon as
the worker commits a checkpoint and releases the iclog, it can start
working on the next checkpoint.  So we've got 4 checkpoint
completions doing insert aborts from journal IO completion
(kworker/16:1H-1600438). There are 3 traces that are clearly unbound
CIL push kworkers (kworker/u259:14-391 and the like). There are also
3 that are truncated names, but the -XXX is very close to the PIDs
of the other unbound push kworkers, so that's probably what they
were.

This means that during a shutdown we clearly have racing calls to
xlog_cil_committed() rather than having them completely serialised
by journal IO completion. This means that we may still have a
transaction commit in flight that holds a reference to a
xfs_buf_log_item (BLI) after CIL insertion. e.g. a synchronous
transaction will flush the CIL before the transaction is torn down.

The concurrent CIL push then aborts insertion it and drops the
commit/AIL reference to the BLI. This can leave the transaction
commit context with the last reference to the BLI.

The abort of the inode buffer is supposed to abort all the inodes
attached to it on journal IO completion. This is done by the
xfs_buf_item_unpin() call, but if the last unpin doesn't drop the
last reference to the BLI, it doesn't complete the stale inodes
attached to it - it leaves that for the last reference.

Then when the last reference is released from transaction context
(xfs_trans_commit() or xfs_trans_cancel()), we end up here:

xfs_trans_free_items()
  ->iop_release
    xfs_buf_item_release
      xfs_buf_item_put
        if (XFS_LI_ABORTED)
	  xfs_trans_ail_delete
	xfs_buf_item_relse()

And we do not process the inode objects attached to the buffer, even
though we've checked if this is an aborted log item on last release.

Hence in this case, it would seem that we've released a stale inode
buffer with stale inodes attached and in the AIL and haven't aborted
the inodes....

OK, let's add an assert:

	ASSERT(list_empty(&bip->bli_buf->b_li_list));

to the abort case in xfs_buf_item_put()....

 XFS: Assertion failed: list_empty(&bip->bli_buf->b_li_list), file: fs/xfs/xfs_buf_item.c, line: 561
 ------------[ cut here ]------------
 kernel BUG at fs/xfs/xfs_message.c:102!
 Oops: invalid opcode: 0000 [#1] SMP NOPTI
 CPU: 12 UID: 0 PID: 816468 Comm: kworker/12:53 Not tainted 6.15.0-rc5-dgc+ #326 PREEMPT(full)
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
 Workqueue: xfs-inodegc/dm-1 xfs_inodegc_worker
 RIP: 0010:assfail+0x3a/0x40
 Code: 89 f1 48 89 fe 48 c7 c7 cf c7 ed 82 48 c7 c2 86 56 e8 82 e8 c8 fc ff ff 80 3d d1 d3 50 03 01 74 09 0f 0b 5d c3 cc cc cc cc cc <0f> 0b 0f 1f 40 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90
 RSP: 0018:ffffc900184e3b40 EFLAGS: 00010246
 RAX: a79ae1118c7fdd00 RBX: ffff88812b04ba80 RCX: a79ae1118c7fdd00
 RDX: ffffc900184e3a08 RSI: 000000000000000a RDI: ffffffff82edc7cf
 RBP: ffffc900184e3b40 R08: 0000000000000000 R09: 000000000000000a
 R10: 0000000000000000 R11: 0000000000000021 R12: 0000000000000024
 R13: 0000000000000000 R14: ffff88816a67a750 R15: 000000000000006c
 FS:  0000000000000000(0000) GS:ffff88889a78a000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007fbe8536d3dc CR3: 00000008471e7000 CR4: 0000000000350ef0
 Call Trace:
  <TASK>
  xfs_buf_item_release+0x22c/0x280
  xfs_trans_free_items+0x94/0x140
  __xfs_trans_commit+0x1e4/0x320
  xfs_trans_roll+0x4d/0xe0
  xfs_defer_trans_roll+0x83/0x160
  xfs_defer_finish_noroll+0x1d1/0x440
  xfs_trans_commit+0x46/0x90
  xfs_inactive_ifree+0x1b6/0x230
  xfs_inactive+0x30e/0x3b0
  xfs_inodegc_worker+0xaa/0x180
  process_scheduled_works+0x1d6/0x400
  worker_thread+0x202/0x2e0
  kthread+0x20c/0x240
  ret_from_fork+0x3e/0x50
  ret_from_fork_asm+0x1a/0x30
  </TASK>
 Modules linked in:
 ---[ end trace 0000000000000000 ]---

And there's the smoking gun - the transaction commit holds the last
reference to the BLI that still has stale inodes attached to the
buffer.

-----

The fix for this is not immediately clear. Let's talk to the dog for
a bit...

We first need to observe that xfs_buf_item_release() must be
called with the buffer still locked as one of it's functions is to
unlock the buffer after the transaction is committed. Hence we can
run operations IO completion/failure routines that require the
buffer to be locked from xfs_buf_item_release() context if
necessary.

However, the locking for stale buffers is different and quite
complicated. Stale buffers cover freed metadata extents, so we can't
allow them to be accessed for anything until the metadata related to
the freeing operation is on stable storage. i.e. the buffer has to
remained stale and locked until journal IO completion, not just
transaction commit completion. This is what allows metadata freeing
transactions to run asynchronously and avoid needing a log force
during xfs_trans_commit() context....

This means that the buffer lock context needs to be passed to the
last BLI reference. For stale buffers, this is normally the last BLI
unpin on journal IO completion. The unpin then processes the stale
buffer completion and releases the buffer lock.  However, if the
unpin from journal IO completion does not hold the last reference,
there -must- still be a transaction context that references the BLI,
and so the buffer must remain locked until that transaction context
is torn down.

IOWs, there is an inherent race between journal IO completion and
transaction freeing dropping the last reference to a stale buffer.

In normal runtime situations, this isn't a problem because because
we can't use the reallocated block until the buffer lock has been
dropped. Hence we serialise on transaction commit completion rather
than journal IO completion.

However, in the case of stale inode buffers, this race condition
implies we failed to clean up stale inodes attached to the buffer
at journal IO completion.

This race condition generally doesn't occur because the BLI has
already been logged multiple times for unlinked inode list
modifications prior to the invalidation. Hence at inode cluster
freeing time it often has an elevated pin count because it is in the
CIL (and potentially other checkpoints in flight) already. This
results in the transaction commit context almost always dropping
it's reference first due to how long CIL checkpoint submission and
completion takes.

Further, xfs_buf_item_release() has an ASSERT that checks the
transaction context cleanup is not dropping the last reference to a
stale buffer -except- in the case where the BLI has been aborted:

        /*
         * Unref the item and unlock the buffer unless held or stale. Stale
         * buffers remain locked until final unpin unless the bli is freed by
         * the unref call. The latter implies shutdown because buffer
         * invalidation dirties the bli and transaction.
         */
        released = xfs_buf_item_put(bip);
        if (hold || (stale && !released))
                return;
>>>>>   ASSERT(!stale || aborted);
        xfs_buf_relse(bp);

I've never seen that ASSERT trip at runtime for stale && !aborted
buffers, so it seems pretty clear that the unpin race only manifests
during shutdown conditions when abort conditions are asserted.

That's part of the problem - this code acknowledges that a race
condition can occur during shutdown, but then asserts that it is
benign. This may once have been true, but we've attached inodes
being flushed to the buffer for a long time under the guise that
buffer IO completion or stale buffer teardown will also complete or
abort attached inodes appropriately.

The debug ASSERT I added above catches this exact condition - a
stale buffer being released from transaction context with stale
inodes still attached to it.

Hence the way we are processing the last BLI reference in
xfs_buf_item_release() needs fixing. xfs_buf_item_put() is
needed, but it should not be doing any handling of dirty/stale
state. There are only 3 callers, and two of them explicitly only
pass clean BLIs to xfs_buf_item_put() to remove them from a
transaction context and do not check the return value.

These cases do not care if the item is in the AIL or not; buffers
that are in the AIL on shutdown will be cleared from the AIL by
pushing them. They will get queued for IO, then the IO will get
failed and IO completion will remove them from the AIL. Hence
these transaction removal cases do not need to care about whether
the item is aborted or not - they just need to check if it is in the
AIL or not. This state is protected by the buffer lock the
caller holds...

Hence I think that xfs_buf_item_release needs to look an awful lot
like xfs_buf_item_unpin()....

<hack hack hack>

generic/753 again:

 XFS: Assertion failed: !(bip->bli_flags & XFS_BLI_DIRTY), file: fs/xfs/xfs_buf_item.c, line: 616
  xfs_buf_item_put+0x97/0xf0
  xfs_trans_brelse+0x9b/0x1d0
  xfs_btree_del_cursor+0x2f/0xc0
  xfs_alloc_ag_vextent_near+0x359/0x470
  xfs_alloc_vextent_near_bno+0xbc/0x180
  xfs_ialloc_ag_alloc+0x6dd/0x7a0
  xfs_dialloc+0x38e/0x8e0
  xfs_create+0x1d4/0x430
  xfs_generic_create+0x141/0x3e0
  xfs_vn_mkdir+0x1a/0x30
  vfs_mkdir+0xe6/0x190
  do_mkdirat+0xaa/0x260
  __x64_sys_mkdir+0x2b/0x40
  x64_sys_call+0x228f/0x2f60
  do_syscall_64+0x68/0x130

But wait, there's more!

This is trying to free a buffer that is not dirty in the transaction
(XFS_LI_DIRTY on the log item is not set), but the BLI is marked
dirty but isn't in the AIL. That, I think, is another shutdown
race where an item is in a committing checkpoint (not locked, has a
bli reference) at the same time as something reads and then releases
the buffer. A shutdown occurs and the committing checkpoint
completes, aborts the log item instead of inserting it into the ail,
and because it's not the last bli reference is then does nothing
else.

At this point, the only remaining bli reference is owned by the
btree cursor, the BLI is dirty and not stale, and we call
xfs_trans_brelse() -> xfs_buf_item_put() to drop the buffer which
then would free the BLI directly, even though it is dirty. That
triggers the aobve ASSERT.

So, in a shutdown state, we can be freeing dirty BLIs from
xfs_buf_item_put() via xfs_trans_brelse() and xfs_trans_bdetach().
Yes, the existing code handles this case by considering shutdown
state as "aborted", but that's one of the confusions that masks the
original bug from the xfs_buf_item_release() path - the buffer may
be considered "aborted" in the shutdown case, but we still may have
to do cleanup work on it regardless of whether it is in the AIL or
not.

The question is whether we can get this state occurring with stale
inode buffers that have attached stale inodes. It can't happen
with xfs_trans_brelse(), as it keeps the buffer attached to the
transaction if XFS_BLI_STALE is set. xfs_trans_bdetach() also has
an assert that would fire if it was called on a XFS_BLI_DIRTY
or XFS_BLI_STALE buffer. Hence I don't think that we can get
races with stale buffers here, and so all that needs doing is
changing the assert....

Ok, it has survived check-parallel for an hour, so I think that the
problem is fixed.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf_item.c   | 296 ++++++++++++++++++++++++----------------
 fs/xfs/xfs_buf_item.h   |   3 +-
 fs/xfs/xfs_inode_item.c |   5 +-
 fs/xfs/xfs_log_cil.c    |   4 +-
 fs/xfs/xfs_trace.h      |   9 +-
 fs/xfs/xfs_trans.c      |   4 +-
 6 files changed, 199 insertions(+), 122 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 90139e0f3271..83bff1b04b46 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -32,6 +32,61 @@ static inline struct xfs_buf_log_item *BUF_ITEM(struct xfs_log_item *lip)
 	return container_of(lip, struct xfs_buf_log_item, bli_item);
 }
 
+static void
+xfs_buf_item_get_format(
+	struct xfs_buf_log_item	*bip,
+	int			count)
+{
+	ASSERT(bip->bli_formats == NULL);
+	bip->bli_format_count = count;
+
+	if (count == 1) {
+		bip->bli_formats = &bip->__bli_format;
+		return;
+	}
+
+	bip->bli_formats = kzalloc(count * sizeof(struct xfs_buf_log_format),
+				GFP_KERNEL | __GFP_NOFAIL);
+}
+
+static void
+xfs_buf_item_free_format(
+	struct xfs_buf_log_item	*bip)
+{
+	if (bip->bli_formats != &bip->__bli_format) {
+		kfree(bip->bli_formats);
+		bip->bli_formats = NULL;
+	}
+}
+
+static void
+xfs_buf_item_free(
+	struct xfs_buf_log_item	*bip)
+{
+	xfs_buf_item_free_format(bip);
+	kvfree(bip->bli_item.li_lv_shadow);
+	kmem_cache_free(xfs_buf_item_cache, bip);
+}
+
+/*
+ * xfs_buf_item_relse() is called when the buf log item is no longer needed.
+ */
+static void
+xfs_buf_item_relse(
+	struct xfs_buf_log_item	*bip)
+{
+	struct xfs_buf		*bp = bip->bli_buf;
+
+	trace_xfs_buf_item_relse(bp, _RET_IP_);
+
+	ASSERT(!test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags));
+	ASSERT(atomic_read(&bip->bli_refcount) == 0);
+
+	bp->b_log_item = NULL;
+	xfs_buf_rele(bp);
+	xfs_buf_item_free(bip);
+}
+
 /* Is this log iovec plausibly large enough to contain the buffer log format? */
 bool
 xfs_buf_log_check_iovec(
@@ -389,6 +444,44 @@ xfs_buf_item_pin(
 	atomic_inc(&bip->bli_buf->b_pin_count);
 }
 
+/*
+ * For a stale BLI, process all the necessary completions that must be
+ * performed when the final BLI reference goes away. The buffer will be
+ * referenced and locked here - we return to the caller with it still referenced
+ * and locked so that the caller can release and unlock the buffer as required.
+ */
+static void
+xfs_buf_item_finish_stale(
+	struct xfs_buf		*bp)
+{
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
+	struct xfs_log_item	*lip = &bip->bli_item;
+
+	ASSERT(bip->bli_flags & XFS_BLI_STALE);
+	ASSERT(xfs_buf_islocked(bp));
+	ASSERT(bp->b_flags & XBF_STALE);
+	ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
+	ASSERT(list_empty(&lip->li_trans));
+	ASSERT(!bp->b_transp);
+
+	/*
+	 * If we get called here because of an IO error, we may or may
+	 * not have the item on the AIL. xfs_trans_ail_delete() will
+	 * take care of that situation. xfs_trans_ail_delete() drops
+	 * the AIL lock.
+	 */
+	if (bip->bli_flags & XFS_BLI_STALE_INODE) {
+		xfs_buf_item_done(bp);
+		xfs_buf_inode_iodone(bp);
+		ASSERT(list_empty(&bp->b_li_list));
+	} else {
+		xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
+		xfs_buf_item_relse(bp->b_log_item);
+		ASSERT(bp->b_log_item == NULL);
+	}
+	return;
+}
+
 /*
  * This is called to unpin the buffer associated with the buf log item which was
  * previously pinned with a call to xfs_buf_item_pin().  We enter this function
@@ -438,13 +531,6 @@ xfs_buf_item_unpin(
 	}
 
 	if (stale) {
-		ASSERT(bip->bli_flags & XFS_BLI_STALE);
-		ASSERT(xfs_buf_islocked(bp));
-		ASSERT(bp->b_flags & XBF_STALE);
-		ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
-		ASSERT(list_empty(&lip->li_trans));
-		ASSERT(!bp->b_transp);
-
 		trace_xfs_buf_item_unpin_stale(bip);
 
 		/*
@@ -455,22 +541,7 @@ xfs_buf_item_unpin(
 		 * processing is complete.
 		 */
 		xfs_buf_rele(bp);
-
-		/*
-		 * If we get called here because of an IO error, we may or may
-		 * not have the item on the AIL. xfs_trans_ail_delete() will
-		 * take care of that situation. xfs_trans_ail_delete() drops
-		 * the AIL lock.
-		 */
-		if (bip->bli_flags & XFS_BLI_STALE_INODE) {
-			xfs_buf_item_done(bp);
-			xfs_buf_inode_iodone(bp);
-			ASSERT(list_empty(&bp->b_li_list));
-		} else {
-			xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
-			xfs_buf_item_relse(bp);
-			ASSERT(bp->b_log_item == NULL);
-		}
+		xfs_buf_item_finish_stale(bp);
 		xfs_buf_relse(bp);
 		return;
 	}
@@ -543,43 +614,42 @@ xfs_buf_item_push(
  * Drop the buffer log item refcount and take appropriate action. This helper
  * determines whether the bli must be freed or not, since a decrement to zero
  * does not necessarily mean the bli is unused.
- *
- * Return true if the bli is freed, false otherwise.
  */
-bool
+void
 xfs_buf_item_put(
 	struct xfs_buf_log_item	*bip)
 {
-	struct xfs_log_item	*lip = &bip->bli_item;
-	bool			aborted;
-	bool			dirty;
+
+	ASSERT(xfs_buf_islocked(bip->bli_buf));
 
 	/* drop the bli ref and return if it wasn't the last one */
 	if (!atomic_dec_and_test(&bip->bli_refcount))
-		return false;
+		return;
 
-	/*
-	 * We dropped the last ref and must free the item if clean or aborted.
-	 * If the bli is dirty and non-aborted, the buffer was clean in the
-	 * transaction but still awaiting writeback from previous changes. In
-	 * that case, the bli is freed on buffer writeback completion.
-	 */
-	aborted = test_bit(XFS_LI_ABORTED, &lip->li_flags) ||
-			xlog_is_shutdown(lip->li_log);
-	dirty = bip->bli_flags & XFS_BLI_DIRTY;
-	if (dirty && !aborted)
-		return false;
+	/* If the BLI is in the AIL, then it is still dirty and in use */
+	if (test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags)) {
+		ASSERT(bip->bli_flags & XFS_BLI_DIRTY);
+		return;
+	}
 
 	/*
-	 * The bli is aborted or clean. An aborted item may be in the AIL
-	 * regardless of dirty state.  For example, consider an aborted
-	 * transaction that invalidated a dirty bli and cleared the dirty
-	 * state.
+	 * In shutdown conditions, we can be asked to free a dirty BLI that
+	 * isn't in the AIL. This can occur due to a checkpoint aborting a BLI
+	 * instead of inserting it into the AIL at checkpoint IO completion. If
+	 * there's another bli reference (e.g. a btree cursor holds a clean
+	 * reference) and it is released via xfs_trans_brelse(), we can get here
+	 * with that aborted, dirty BLI. In this case, it is safe to free the
+	 * dirty BLI immediately, as it is not in the AIL and there are no
+	 * other references to it.
+	 *
+	 * We should never get here with a stale BLI via that path as
+	 * xfs_trans_brelse() specifically holds onto stale buffers rather than
+	 * releasing them.
 	 */
-	if (aborted)
-		xfs_trans_ail_delete(lip, 0);
-	xfs_buf_item_relse(bip->bli_buf);
-	return true;
+	ASSERT(!(bip->bli_flags & XFS_BLI_DIRTY) ||
+			test_bit(XFS_LI_ABORTED, &bip->bli_item.li_flags));
+	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
+	xfs_buf_item_relse(bip);
 }
 
 /*
@@ -600,6 +670,15 @@ xfs_buf_item_put(
  * if necessary but do not unlock the buffer.  This is for support of
  * xfs_trans_bhold(). Make sure the XFS_BLI_HOLD field is cleared if we don't
  * free the item.
+ *
+ * If the XFS_BLI_STALE flag is set, the last reference to the BLI *must*
+ * perform a completion abort of any objects attached to the buffer for IO
+ * tracking purposes. This generally only happens in shutdown situations,
+ * normally xfs_buf_item_unpin() will drop the last BLI reference and perform
+ * completion processing. However, because transaction completion can race with
+ * checkpoint completion during a shutdown, this release context may end up
+ * being the last active reference to the BLI and so needs to perform this
+ * cleanup.
  */
 STATIC void
 xfs_buf_item_release(
@@ -607,18 +686,19 @@ xfs_buf_item_release(
 {
 	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
 	struct xfs_buf		*bp = bip->bli_buf;
-	bool			released;
 	bool			hold = bip->bli_flags & XFS_BLI_HOLD;
 	bool			stale = bip->bli_flags & XFS_BLI_STALE;
-#if defined(DEBUG) || defined(XFS_WARN)
-	bool			ordered = bip->bli_flags & XFS_BLI_ORDERED;
-	bool			dirty = bip->bli_flags & XFS_BLI_DIRTY;
 	bool			aborted = test_bit(XFS_LI_ABORTED,
 						   &lip->li_flags);
+	bool			dirty = bip->bli_flags & XFS_BLI_DIRTY;
+#if defined(DEBUG) || defined(XFS_WARN)
+	bool			ordered = bip->bli_flags & XFS_BLI_ORDERED;
 #endif
 
 	trace_xfs_buf_item_release(bip);
 
+	ASSERT(xfs_buf_islocked(bp));
+
 	/*
 	 * The bli dirty state should match whether the blf has logged segments
 	 * except for ordered buffers, where only the bli should be dirty.
@@ -635,15 +715,54 @@ xfs_buf_item_release(
 	bip->bli_flags &= ~(XFS_BLI_LOGGED | XFS_BLI_HOLD | XFS_BLI_ORDERED);
 
 	/*
-	 * Unref the item and unlock the buffer unless held or stale. Stale
-	 * buffers remain locked until final unpin unless the bli is freed by
-	 * the unref call. The latter implies shutdown because buffer
-	 * invalidation dirties the bli and transaction.
+	 * If this is the last reference to the BLI, we must clean it up
+	 * before freeing it and releasing the buffer attached to it.
 	 */
-	released = xfs_buf_item_put(bip);
-	if (hold || (stale && !released))
+	if (atomic_dec_and_test(&bip->bli_refcount)) {
+		if (stale) {
+			/*
+			 * Stale buffer completion frees the BLI, unlocks and
+			 * releases the buffer. Neither the BLI or buffer are
+			 * safe to reference after this call, so there's nothing
+			 * more we need to do here.
+			 */
+			xfs_buf_item_finish_stale(bp);
+			return;
+		} else if (aborted || xlog_is_shutdown(lip->li_log)) {
+			/*
+			 * Dirty or clean, aborted items are done and need to be
+			 * removed from the AIL and released. This frees the
+			 * BLI, but leaves the buffer locked and referenced.
+			 */
+			ASSERT(list_empty(&bip->bli_buf->b_li_list));
+			xfs_buf_item_done(bp);
+		} else if (!dirty) {
+			/*
+			 * Clean, unreferenced BLIs can be immediately freed,
+			 * leaving the buffer locked and referenced.
+			 */
+			xfs_buf_item_relse(bip);
+		} else {
+			/*
+			 * Dirty, unreferenced BLIs *must* be in the AIL
+			 * awaiting writeback.
+			 */
+			ASSERT(test_bit(XFS_LI_IN_AIL, &lip->li_flags));
+		}
+	}
+
+	/* Not safe to reference the BLI from here */
+
+	/*
+	 * If we get here with a stale buffer, there are references to the BLI
+	 * still remaining. We mus tnot unlock the buffer in this case as we've
+	 * handed the lock context to the last BLI reference to process.
+	 *
+	 * Hence if the buffer is stale or the transaction owner wants the
+	 * buffer to remain locked across the commit call, do not release it.
+	 */
+	if (hold || stale)
 		return;
-	ASSERT(!stale || aborted);
 	xfs_buf_relse(bp);
 }
 
@@ -729,33 +848,6 @@ static const struct xfs_item_ops xfs_buf_item_ops = {
 	.iop_push	= xfs_buf_item_push,
 };
 
-STATIC void
-xfs_buf_item_get_format(
-	struct xfs_buf_log_item	*bip,
-	int			count)
-{
-	ASSERT(bip->bli_formats == NULL);
-	bip->bli_format_count = count;
-
-	if (count == 1) {
-		bip->bli_formats = &bip->__bli_format;
-		return;
-	}
-
-	bip->bli_formats = kzalloc(count * sizeof(struct xfs_buf_log_format),
-				GFP_KERNEL | __GFP_NOFAIL);
-}
-
-STATIC void
-xfs_buf_item_free_format(
-	struct xfs_buf_log_item	*bip)
-{
-	if (bip->bli_formats != &bip->__bli_format) {
-		kfree(bip->bli_formats);
-		bip->bli_formats = NULL;
-	}
-}
-
 /*
  * Allocate a new buf log item to go with the given buffer.
  * Set the buffer's b_log_item field to point to the new
@@ -976,34 +1068,6 @@ xfs_buf_item_dirty_format(
 	return false;
 }
 
-STATIC void
-xfs_buf_item_free(
-	struct xfs_buf_log_item	*bip)
-{
-	xfs_buf_item_free_format(bip);
-	kvfree(bip->bli_item.li_lv_shadow);
-	kmem_cache_free(xfs_buf_item_cache, bip);
-}
-
-/*
- * xfs_buf_item_relse() is called when the buf log item is no longer needed.
- */
-void
-xfs_buf_item_relse(
-	struct xfs_buf	*bp)
-{
-	struct xfs_buf_log_item	*bip = bp->b_log_item;
-
-	trace_xfs_buf_item_relse(bp, _RET_IP_);
-	ASSERT(!test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags));
-
-	if (atomic_read(&bip->bli_refcount))
-		return;
-	bp->b_log_item = NULL;
-	xfs_buf_rele(bp);
-	xfs_buf_item_free(bip);
-}
-
 void
 xfs_buf_item_done(
 	struct xfs_buf		*bp)
@@ -1023,5 +1087,5 @@ xfs_buf_item_done(
 	xfs_trans_ail_delete(&bp->b_log_item->bli_item,
 			     (bp->b_flags & _XBF_LOGRECOVERY) ? 0 :
 			     SHUTDOWN_CORRUPT_INCORE);
-	xfs_buf_item_relse(bp);
+	xfs_buf_item_relse(bp->b_log_item);
 }
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index e10e324cd245..66f65eaba8c3 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -49,8 +49,7 @@ struct xfs_buf_log_item {
 
 int	xfs_buf_item_init(struct xfs_buf *, struct xfs_mount *);
 void	xfs_buf_item_done(struct xfs_buf *bp);
-void	xfs_buf_item_relse(struct xfs_buf *);
-bool	xfs_buf_item_put(struct xfs_buf_log_item *);
+void	xfs_buf_item_put(struct xfs_buf_log_item *);
 void	xfs_buf_item_log(struct xfs_buf_log_item *, uint, uint);
 bool	xfs_buf_item_dirty_format(struct xfs_buf_log_item *);
 void	xfs_buf_inode_iodone(struct xfs_buf *);
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index c6cb0b6b9e46..285e27ff89e2 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -758,11 +758,14 @@ xfs_inode_item_push(
 		 * completed and items removed from the AIL before the next push
 		 * attempt.
 		 */
+		trace_xfs_inode_push_stale(ip, _RET_IP_);
 		return XFS_ITEM_PINNED;
 	}
 
-	if (xfs_ipincount(ip) > 0 || xfs_buf_ispinned(bp))
+	if (xfs_ipincount(ip) > 0 || xfs_buf_ispinned(bp)) {
+		trace_xfs_inode_push_pinned(ip, _RET_IP_);
 		return XFS_ITEM_PINNED;
+	}
 
 	if (xfs_iflags_test(ip, XFS_IFLUSHING))
 		return XFS_ITEM_FLUSHING;
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index f66d2d430e4f..a80cb6b9969a 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -793,8 +793,10 @@ xlog_cil_ail_insert(
 		struct xfs_log_item	*lip = lv->lv_item;
 		xfs_lsn_t		item_lsn;
 
-		if (aborted)
+		if (aborted) {
+			trace_xlog_ail_insert_abort(lip);
 			set_bit(XFS_LI_ABORTED, &lip->li_flags);
+		}
 
 		if (lip->li_ops->flags & XFS_ITEM_RELEASE_WHEN_COMMITTED) {
 			lip->li_ops->iop_release(lip);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 01d284a1c759..54597b4060ff 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1147,6 +1147,7 @@ DECLARE_EVENT_CLASS(xfs_iref_class,
 		__field(xfs_ino_t, ino)
 		__field(int, count)
 		__field(int, pincount)
+		__field(unsigned long, iflags)
 		__field(unsigned long, caller_ip)
 	),
 	TP_fast_assign(
@@ -1154,13 +1155,15 @@ DECLARE_EVENT_CLASS(xfs_iref_class,
 		__entry->ino = ip->i_ino;
 		__entry->count = atomic_read(&VFS_I(ip)->i_count);
 		__entry->pincount = atomic_read(&ip->i_pincount);
+		__entry->iflags = ip->i_flags;
 		__entry->caller_ip = caller_ip;
 	),
-	TP_printk("dev %d:%d ino 0x%llx count %d pincount %d caller %pS",
+	TP_printk("dev %d:%d ino 0x%llx count %d pincount %d iflags 0x%lx caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->count,
 		  __entry->pincount,
+		  __entry->iflags,
 		  (char *)__entry->caller_ip)
 )
 
@@ -1250,6 +1253,8 @@ DEFINE_IREF_EVENT(xfs_irele);
 DEFINE_IREF_EVENT(xfs_inode_pin);
 DEFINE_IREF_EVENT(xfs_inode_unpin);
 DEFINE_IREF_EVENT(xfs_inode_unpin_nowait);
+DEFINE_IREF_EVENT(xfs_inode_push_pinned);
+DEFINE_IREF_EVENT(xfs_inode_push_stale);
 
 DECLARE_EVENT_CLASS(xfs_namespace_class,
 	TP_PROTO(struct xfs_inode *dp, const struct xfs_name *name),
@@ -1654,6 +1659,8 @@ DEFINE_LOG_ITEM_EVENT(xfs_ail_flushing);
 DEFINE_LOG_ITEM_EVENT(xfs_cil_whiteout_mark);
 DEFINE_LOG_ITEM_EVENT(xfs_cil_whiteout_skip);
 DEFINE_LOG_ITEM_EVENT(xfs_cil_whiteout_unpin);
+DEFINE_LOG_ITEM_EVENT(xlog_ail_insert_abort);
+DEFINE_LOG_ITEM_EVENT(xfs_trans_free_abort);
 
 DECLARE_EVENT_CLASS(xfs_ail_class,
 	TP_PROTO(struct xfs_log_item *lip, xfs_lsn_t old_lsn, xfs_lsn_t new_lsn),
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index c6657072361a..b4a07af513ba 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -742,8 +742,10 @@ xfs_trans_free_items(
 
 	list_for_each_entry_safe(lip, next, &tp->t_items, li_trans) {
 		xfs_trans_del_item(lip);
-		if (abort)
+		if (abort) {
+			trace_xfs_trans_free_abort(lip);
 			set_bit(XFS_LI_ABORTED, &lip->li_flags);
+		}
 		if (lip->li_ops->iop_release)
 			lip->li_ops->iop_release(lip);
 	}
-- 
2.45.2

