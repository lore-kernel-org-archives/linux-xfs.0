Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305FB2F3C02
	for <linux-xfs@vger.kernel.org>; Wed, 25 Jun 2025 22:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750891808; cv=none; b=GzptJoB86ywKa+Ugarg4+85QXKCNin2RgnSEgMOKj6IHOIKyelfFssYO9xxEHQTnIc7NnZKfLyrzv4CxbGqoHuTz7QmlUfQ5DxPEiUCjCsXMoAVVFqfABwePY434P1oGpyhgd5eDczP01bz6pGyH6aHlx4B3j8pnQFk2zjMqRto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750891808; c=relaxed/simple;
	bh=a6r0A2DyYobioo9f8rNJ/l6di05j0HHJTZBySsvbsbI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=YQodZI4R2SnPdkhErEqW2ezEltSqSaIB4CWvlDZQX3uhz4uKboLSN2P2T3nNwUx7jqbHhWjj8emPkb+VOZ/+m3vzUfhfvlUTFDHO/26c9WX8iORMc6RoaRAkLcjkxadPYvkYNIoNbJv8bvvuqWovIlVYwNYojYKp34rE3sYRjpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=D24jQImp; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="D24jQImp"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-235d6de331fso6098625ad.3
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jun 2025 15:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1750891805; x=1751496605; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=0c6gxvrio/s6qwQXbHIEQAy+hYfG/bjOUItZigXpStE=;
        b=D24jQImp3Bzi0hR0GrugOHUNQKpyay+x0zqL8QsBQXtXG/ZymEP629wWa5Ji9j/OZ6
         hUbm6GnixYX/CMlWUQ0huVSG9NzthLofwo6IfrAS0hi0saDouXWKWNpuohlxnR4EDy5g
         paaDhaeLkMZVRTrc0XPFV2XvQpWvU0WIocC9pX8/iVDlZxzvBnPASk6JD4OLGWSK9Tlu
         h6W0Rw7hgeCypPbBr9gtCOL6PACD2FneFn3CVM+63V3di3i5dvtbF2ewmASUk+OUcN4+
         iKXYsxnsUbxPpfTdvdhrCFuTM/oY9gt78pZUFiPt7hj18FDGqaRe7tXv5Zckt4RpV6z3
         yc4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750891805; x=1751496605;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0c6gxvrio/s6qwQXbHIEQAy+hYfG/bjOUItZigXpStE=;
        b=B9KUTj31efcocxGLOY+ly4wFKAiWZSSvyfKQUss9NRZ9UJsp+BkpB8Jcqkt53r5mJs
         1W4G/HPxMKv2vX8zAcM7z0iY0bk+proDNwCDEbMkp9cTWoGXIBErcgIn2xvywIL/Ulwt
         56K5NtQfTDvbSYwMdIGB9cdTO+yBgSIIQ3co8NuMHeiPQMScEJvi0Ud/fhKYL12Uf7X7
         RkxR/uXO8DGH8+pJPA7X9s+fVLXCMvQ7KsfUXK8+dGqQAxl8ppP+k5yTnWCLQwAkelwf
         3vB0QCKkOkoJqLU9Quu2xn1eTpgmczM3JHoL1lOciHcid9hwVvecGWQp6V1NJonCipWG
         99oQ==
X-Gm-Message-State: AOJu0YxC5ihWtg2PT4QZxJapLkloHk76obEbY7faWhujkr5yTV/fMgAa
	1oiJct3GpUltcPHkniqbiM52AZcK9b8XkmrQ6NMLHhJPXXab7XBlOSARIMpane57qQ932ChKXNW
	7JoAs
X-Gm-Gg: ASbGncvKnR94a67nd6CiOZ2SDit+fjCim2VgOmRnw/3v3ya1ZPXoUpU8b0RUoqxajeZ
	f5LA8IflxEAe1ChGv4nJaaBpI0mEKLVTPvRXpND2g6e0WxlGKAv1pabwOrYI6FXQ25O7KG8oJ+e
	Q/vhdLme3MbM8VBNHWwmLAzJr1FCEe/gMm0EX5vm6XbTCuseug+BCJsWdZbXIQidH7w2tfGq8q0
	T0jLY5fJxWSu81di1BTNfPjhflDpOsSYIqpx6iEFqlH++vIqyTwuQl0DyBUOeUTKncDIwY07z+w
	E2R5GQnzlu+9zUjsxyNvWU6diTpan/GyRMunzgvFp2EZ4ZJS4+ZT628vTkOAYDIB9nJozb+AZ2x
	hcx5l8xjR+iyZWt6kbdDLzQ1fpnCcvfmn97wA
X-Google-Smtp-Source: AGHT+IFgF34ym9YI/JQMmudpiVdOguE9t4ae3gEcuV4WjphrUNRaei8lIIP7iLdCUKBRoH68jXtbwA==
X-Received: by 2002:a17:902:ef07:b0:234:9092:9dda with SMTP id d9443c01a7336-2382403c738mr101227395ad.24.1750891805166;
        Wed, 25 Jun 2025 15:50:05 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-184-88.pa.nsw.optusnet.com.au. [49.180.184.88])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-315f539e6e5sm2793450a91.14.2025.06.25.15.50.03
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jun 2025 15:50:04 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.98.2)
	(envelope-from <dave@fromorbit.com>)
	id 1uUYwK-00000003FO3-0BIU
	for linux-xfs@vger.kernel.org;
	Thu, 26 Jun 2025 08:50:00 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.98)
	(envelope-from <dave@devoid.disaster.area>)
	id 1uUYwJ-000000061eD-3eH5
	for linux-xfs@vger.kernel.org;
	Thu, 26 Jun 2025 08:49:59 +1000
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Subject: 
Date: Thu, 26 Jun 2025 08:48:53 +1000
Message-ID: <20250625224957.1436116-1-david@fromorbit.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[PATCH 0/7 V2] xfs: various unmount hang fixes

These are a fixes to bugs that often manifest as unmount hanging during
check-parallel runs and then everything else backing up on the s_umount lock
(e.g. sync() syscalls). check-parallel has been tripping over these
semi-regularly.

The first patch fixes a shutdown/unmount hange that is relatively straight
forward.

The second patch catches a corruption condition caused by storage lying about
write completion (i.e. dm-flakey) and racing with memory reclaim of, and other
accesses to, the metadata buffer that dm-flakey lied about. On debug kernels,
this triggers assert failures that then cause unmount to hang on leaked inode
locks.

The third patch address a deadlock condition during shutdown when dquot flushing
encounters a pinned dquot and tries to force the log to unpin it. It runs this
log force with the dquot buffer locked, but that buffer may be in the CIL due to
the dquot chunk just being allocated. At this point, the CIL push shutdown
cleanup tries to error out the buffer log item by locking it, and it blocks
waiting on the dquot flush that holds the buffer locked. The log force that the
dquot flush has issued now blocks waiting for the blocked CIL push to complete.
i.e. ABBA deadlock. This is fixed by promoting dquot unpinning to before the
dquot buffer is locked. To do so, we also need to remove dquot flushing from
memory reclaim so that we can do the unpin promoting in the quotacheck context.
This removes the need for the workaround for reclaim preventing quotacheck from
flushing the dquot, so we can also remove all that code.

The final bug fix for a deadlock in stale inode buffer handling on shutdown is
spread across the remaining patches in the patch set. There is additional
tracepoints, code movement and factoring that is done before the final patch
that fixes the bug.  I've kept the entire original commit message this fix below
- the new commit message captures the critical information and drops much of the
unnecessary commentary.

Comments welcome!

Version 2:
- rebase on v6.16-rc3
- added AGI/AGF stale read handling failure patch.
- added dquot shutdown/reclaim/flush deadlock fix.
- split stale buffer item fix into multiple patches
- folded Christoph's cleanups into the patches at the appropriate
  place
- rewrote the commit message for the smaller stale buf item hang
  patch
- small tweaks to function parameters to pass BLIs rather than
  buffers.

Version 1:
- https://lore.kernel.org/linux-xfs/20250515025628.3425734-1-david@fromorbit.com/T/

---------

Original description of stale inode buffer unmount hang fix:

xfs: fix unmount hang with unflushable inodes stuck in the AIL

	"The most effective debugging tool is still careful
	thought, coupled with judiciously placed print statements."

	- Brian Kernighan

This is still true - the modern version of "print statements" are tracepoints,
trace_printk() and the trace-cmd utility to capture the trace. Then think....

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


