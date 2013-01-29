Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 97ACC7F4E
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2013 14:41:59 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7782F304032
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2013 12:41:59 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 8CemN2FJV1q2F0iY for
	<xfs@oss.sgi.com>; Tue, 29 Jan 2013 12:41:58 -0800 (PST)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0TKfuYM002243
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2013 15:41:58 -0500
Received: from bfoster.bfoster (dhcp-191-48.bos.redhat.com [10.16.191.48])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id r0TKftB7020738
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2013 15:41:56 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH RFC 0/2] fix spinlock recursion on xa_lock in xfs_buf_item_push
Date: Tue, 29 Jan 2013 15:42:35 -0500
Message-Id: <1359492157-30521-1-git-send-email-bfoster@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi all,

This patchset fixes a spinlock recursion we've reproduced initially on RHEL
kernels[1]. The problem is that we issue an xfs_log_force() via
xfs_buf_trylock() with the xa_lock held and ultimately drive down into
xlog_assign_tail_lsn(), which attempts to reacquire xa_lock[2].

Note that this lockup was difficult to reproduce and I was not able to
reproduce on an upstream kernel without a hack to comment out the pinned buf
check in xfs_buf_item_push() (presumably because the log force itself only
happens when the buf is pinned, so the window here is tight).

This patchset is what I'm testing to avoid the lockup, but I'm posting this RFC
to get some early thoughts:

- Patch 1 - Creates a flag to conditionally force the log in xfs_buf_trylock().
  The alternative I considered is to pull out the check and log force and
  sprinkle that code amongst the trylock callers.
- Patch 2 - Utilizes the flag created in patch 1 and duplicates the log force
  in xfs_buf_item_push() after dropping xa_lock.

The change in patch 2 makes me wonder how important the immediate flush is in
the context of xfsaild_push(), where we already pend up a flush if the item is
pinned. IOWs, I wonder if replacing what I have now with something like the
following would be acceptable and cleaner:

	if (!__xfs_buf_trylock(bp, false)) {
		if (xfs_buf_ispinned(bp)
			return XFS_ITEM_PINNED;
		return XFS_ITEM_LOCKED;
	}

Thoughts appreciated.

Brian

[1] - http://bugzilla.redhat.com/show_bug.cgi?id=896224
[2] - stacktrace:

BUG: spinlock recursion on CPU#5, xfsaild/dm-3/2690
Pid: 2690, comm: xfsaild/dm-3 Not tainted 3.8.0-rc1+ #46
Call Trace: 
 [<ffffffff8163211c>] spin_dump+0x8a/0x8f
 [<ffffffff81632142>] spin_bug+0x21/0x26
 [<ffffffff812f66a1>] do_raw_spin_lock+0x101/0x150
 [<ffffffff816378ce>] _raw_spin_lock+0xe/0x10
 [<ffffffffa0522c85>] xlog_assign_tail_lsn+0x25/0x50 [xfs]
 [<ffffffffa0523286>] xlog_state_release_iclog+0x86/0xd0 [xfs]
 [<ffffffffa0523c89>] xlog_write+0x569/0x710 [xfs]
 [<ffffffffa052555c>] xlog_cil_push+0x29c/0x3c0 [xfs]
 [<ffffffffa04cbfe2>] ? xfs_buf_get_map+0xf2/0x1b0 [xfs]
 [<ffffffffa0525d17>] xlog_cil_force_lsn+0x157/0x160 [xfs]
 [<ffffffffa04cced1>] ? xfs_buf_read_map+0x31/0x130 [xfs]
 [<ffffffffa0529e99>] ? xfs_trans_read_buf_map+0x279/0x4b0 [xfs]
 [<ffffffff8117e45d>] ? __kmalloc+0x15d/0x1b0
 [<ffffffffa0523f7d>] _xfs_log_force+0x6d/0x290 [xfs]
 [<ffffffffa051450f>] ? xfs_iflush_cluster+0x25f/0x3d0 [xfs]
 [<ffffffffa05241d9>] xfs_log_force+0x39/0xc0 [xfs]
 [<ffffffffa04cbaa0>] xfs_buf_trylock+0xd0/0xe0 [xfs]
 [<ffffffffa0526369>] xfs_buf_item_push+0x39/0xd0 [xfs]
 [<ffffffffa0527bdf>] ? xfs_inode_item_push+0x8f/0x140 [xfs]
 [<ffffffffa0528c01>] xfsaild+0x2e1/0x6e0 [xfs]
 [<ffffffff8108aa08>] ? __wake_up_common+0x58/0x90
 [<ffffffffa0528920>] ? xfs_trans_ail_cursor_first+0xc0/0xc0 [xfs]
 [<ffffffff81081708>] kthread+0xd8/0xe0
 [<ffffffff81081630>] ? flush_kthread_work+0x150/0x150
 [<ffffffff816400ac>] ret_from_fork+0x7c/0xb0
 [<ffffffff81081630>] ? flush_kthread_work+0x150/0x150

Brian Foster (2):
  xfs: conditionally force log on trylock failure of pinned/stale buf
  xfs: drop xa_lock around log force in xfs_buf_item push

 fs/xfs/xfs_buf.c      |    8 +++++---
 fs/xfs/xfs_buf.h      |    3 ++-
 fs/xfs/xfs_buf_item.c |   10 +++++++++-
 3 files changed, 16 insertions(+), 5 deletions(-)

-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
