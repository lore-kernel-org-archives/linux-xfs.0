Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o94MlSjc114975 for <xfs@oss.sgi.com>; Mon, 4 Oct 2010 17:47:29 -0500
Received: from peace.netnation.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4F5D9EBB3EA
	for <xfs@oss.sgi.com>; Mon,  4 Oct 2010 16:02:07 -0700 (PDT)
Received: from peace.netnation.com (newpeace.netnation.com [204.174.223.7]) by
	cuda.sgi.com with ESMTP id rrZPKkAAfrChJanq for
	<xfs@oss.sgi.com>; Mon, 04 Oct 2010 16:02:07 -0700 (PDT)
Date: Mon, 4 Oct 2010 15:48:30 -0700
From: Simon Kirby <sim@hostway.ca>
Subject: 2.6.35.6 XFS: Inconsistent lock state
Message-ID: <20101004224830.GJ30524@hostway.ca>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Out of the blue, while running postfix+mailscanner:

=================================
[ INFO: inconsistent lock state ]
2.6.35.6-hw #1
---------------------------------
inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
MailScanner/28712 [HC0[0]:SC0[0]:HE1:SE1] takes:
 (&(&ip->i_iolock)->mr_lock#2){++++?+}, at: [<ffffffff8129de35>] xfs_ilock+0xf5/0x100
{RECLAIM_FS-ON-W} state was registered at:
  [<ffffffff81083694>] mark_held_locks+0x74/0xa0
  [<ffffffff810837a5>] lockdep_trace_alloc+0xe5/0xf0
  [<ffffffff810cfc77>] __alloc_pages_nodemask+0x77/0x6d0
  [<ffffffff810c97a5>] grab_cache_page_write_begin+0x85/0xd0
  [<ffffffff8112bd4a>] block_write_begin_newtrunc+0x8a/0xe0
  [<ffffffff8112c16e>] block_write_begin+0x3e/0x80
  [<ffffffff812c18a5>] xfs_vm_write_begin+0x25/0x30
  [<ffffffff810c8436>] generic_file_buffered_write+0x106/0x230
  [<ffffffff812c6d62>] xfs_file_aio_write+0x842/0x8c0
  [<ffffffff81100c91>] do_sync_write+0xd1/0x120
  [<ffffffff8110182b>] vfs_write+0xcb/0x1a0
  [<ffffffff811019f0>] sys_write+0x50/0x90
  [<ffffffff81009f82>] system_call_fastpath+0x16/0x1b
irq event stamp: 34471
hardirqs last  enabled at (34471): [<ffffffff81697d8f>] _raw_spin_unlock_irqrestore+0x3f/0x70
hardirqs last disabled at (34470): [<ffffffff816974cd>] _raw_spin_lock_irqsave+0x2d/0x90
softirqs last  enabled at (34314): [<ffffffff810585ff>] __do_softirq+0x19f/0x1f0
softirqs last disabled at (34309): [<ffffffff8100ae9c>] call_softirq+0x1c/0x30

other info that might help us debug this:
2 locks held by MailScanner/28712:
 #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff8169b8c7>] do_page_fault+0xe7/0x430
 #1:  (shrinker_rwsem){++++..}, at: [<ffffffff810d67d8>] shrink_slab+0x38/0x180

stack backtrace:
Pid: 28712, comm: MailScanner Not tainted 2.6.35.6-hw #1
Call Trace:
 [<ffffffff81082f00>] print_usage_bug+0x190/0x1f0
 [<ffffffff81083410>] mark_lock+0x4b0/0x6c0
 [<ffffffff81083e50>] ? check_usage_forwards+0x0/0x120
 [<ffffffff8108520d>] __lock_acquire+0x89d/0x1e20
 [<ffffffff810112f0>] ? native_sched_clock+0x20/0x80
 [<ffffffff81370819>] ? radix_tree_delete+0x1c9/0x2e0
 [<ffffffff81086879>] lock_acquire+0xe9/0x120
 [<ffffffff8129de35>] ? xfs_ilock+0xf5/0x100
 [<ffffffff810811fd>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff81074792>] down_write_nested+0x42/0x90
 [<ffffffff8129de35>] ? xfs_ilock+0xf5/0x100
 [<ffffffff8129de35>] xfs_ilock+0xf5/0x100
 [<ffffffff8129e038>] xfs_ireclaim+0xa8/0xe0
 [<ffffffff812cd14f>] xfs_reclaim_inode+0x18f/0x260
 [<ffffffff812cdf54>] xfs_inode_ag_walk+0x74/0x140
 [<ffffffff812ccfc0>] ? xfs_reclaim_inode+0x0/0x260
 [<ffffffff812ce0a0>] xfs_inode_ag_iterator+0x80/0xd0
 [<ffffffff812ccfc0>] ? xfs_reclaim_inode+0x0/0x260
 [<ffffffff812ce175>] xfs_reclaim_inode_shrink+0x85/0x90
 [<ffffffff810d68c5>] shrink_slab+0x125/0x180
 [<ffffffff810d759e>] try_to_free_pages+0x23e/0x480
 [<ffffffff810cffdb>] __alloc_pages_nodemask+0x3db/0x6d0
 [<ffffffff810e219e>] do_wp_page+0x1ae/0x7f0
 [<ffffffff810e40de>] handle_mm_fault+0x5be/0x840
 [<ffffffff8169b8c7>] ? do_page_fault+0xe7/0x430
 [<ffffffff8169b9cb>] do_page_fault+0x1eb/0x430
 [<ffffffff81697d3b>] ? _raw_spin_unlock_irq+0x2b/0x40
 [<ffffffff810489f4>] ? finish_task_switch+0x74/0xf0
 [<ffffffff81048980>] ? finish_task_switch+0x0/0xf0
 [<ffffffff81694388>] ? schedule+0x4c8/0x820
 [<ffffffff816970e1>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff816983b5>] page_fault+0x25/0x30

Simon-

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
