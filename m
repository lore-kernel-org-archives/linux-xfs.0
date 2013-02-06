Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DF5FF7F56
	for <xfs@oss.sgi.com>; Wed,  6 Feb 2013 06:41:53 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CEC25304051
	for <xfs@oss.sgi.com>; Wed,  6 Feb 2013 04:41:50 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id IlnMflE8LElRfZzC for
	<xfs@oss.sgi.com>; Wed, 06 Feb 2013 04:41:47 -0800 (PST)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r16Cfjdx008048
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 6 Feb 2013 07:41:45 -0500
Received: from bfoster.bfoster (dhcp-191-48.bos.redhat.com [10.16.191.48])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r16CfjIw030477
	for <xfs@oss.sgi.com>; Wed, 6 Feb 2013 07:41:45 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 0/2] fix spinlock recursion on xa_lock in xfs_buf_item_push
Date: Wed,  6 Feb 2013 07:44:39 -0500
Message-Id: <1360154681-28246-1-git-send-email-bfoster@redhat.com>
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

Here is v2 of the xa_lock recursion fix[1]. This has survived several days of the
reproduction workload and an xfstests run shows no regressions. Thoughts
appreciated.

Brian

v2:
- Patch 2 is reworked to detect the potential race and defer the log force to
  xfsaild by returning XFS_ITEM_PINNED.

[1] - recursion stack trace

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
  xfs: disable log force in xfs_buf_item_push() to avoid xa_lock
    recursion

 fs/xfs/xfs_buf.c      |    8 +++++---
 fs/xfs/xfs_buf.h      |    3 ++-
 fs/xfs/xfs_buf_item.c |   14 +++++++++++++-
 3 files changed, 20 insertions(+), 5 deletions(-)

-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
