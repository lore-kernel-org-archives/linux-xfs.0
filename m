Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 216AB7F51
	for <xfs@oss.sgi.com>; Sat, 13 Jul 2013 19:34:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0EE6C304032
	for <xfs@oss.sgi.com>; Sat, 13 Jul 2013 17:34:10 -0700 (PDT)
Received: from mail-yh0-f45.google.com (mail-yh0-f45.google.com
	[209.85.213.45]) by cuda.sgi.com with ESMTP id 6AVvDzV0P8ooRDCi
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 13 Jul 2013 17:34:10 -0700 (PDT)
Received: by mail-yh0-f45.google.com with SMTP id b20so4196545yha.32
	for <xfs@oss.sgi.com>; Sat, 13 Jul 2013 17:34:09 -0700 (PDT)
Received: from [192.168.0.129] (rrcs-97-78-60-146.se.biz.rr.com.
	[97.78.60.146])
	by mx.google.com with ESMTPSA id s29sm76014973yhf.6.2013.07.13.17.34.08
	for <xfs@oss.sgi.com>
	(version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
	Sat, 13 Jul 2013 17:34:08 -0700 (PDT)
Message-ID: <51E1F1F4.40500@gmail.com>
Date: Sat, 13 Jul 2013 20:33:56 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Lockdep for 3.10.0+ for rm of kernel git...
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi!  Here's a lockdep that happened while executing an `rm -r linux` to 
remove an old kernel git directory.  This is for a git 3.10.0+ kernel 
on a non-CRC XFS filesystem that's less than a week old.

I'm not getting lockdep reports like this unless I'm minding my own 
business.  xfstests could be running until there's a faint burning 
electrical smell in the room, and this won't show up.  But if all I'm 
doing is removing things to prepare for the next xfstests session or 
git activity, then this lockdep will show up.  I'm not sure if I get 
the same lockdep every time, but it's related to deletes somehow, and 
it's newer than the production 3.10 kernel, AFAIK.

For the lockdeps, this pattern is prominent...

       CPU0
       ----
  lock(&(&ip->i_lock)->mr_lock);
  <Interrupt>
    lock(&(&ip->i_lock)->mr_lock);

...and lockdep hasn't suggested the SMP scenario on XFS in some time.

There does seem to be some new lockdep work in the kernel, so maybe 
it's not a regression but something else.

Thanks!

Michael

=================================
[ INFO: inconsistent lock state ]
3.10.0+ #1 Not tainted
---------------------------------
inconsistent {IN-RECLAIM_FS-W} -> {RECLAIM_FS-ON-R} usage.
rm/30139 [HC0[0]:SC0[0]:HE1:SE1] takes:
 (&(&ip->i_lock)->mr_lock){++++-?}, at: [<c11c5b16>] xfs_ilock+0xb9/0x174
{IN-RECLAIM_FS-W} state was registered at:
  [<c1062521>] __lock_acquire+0x5e8/0x101c
  [<c1063591>] lock_acquire+0x7f/0xf2
  [<c104ba0a>] down_write_nested+0x4c/0x67
  [<c11c5b5c>] xfs_ilock+0xff/0x174
  [<c117bda0>] xfs_reclaim_inode+0xf4/0x30a
  [<c117c239>] xfs_reclaim_inodes_ag+0x283/0x3b2
  [<c117c3e6>] xfs_reclaim_inodes_nr+0x2d/0x33
  [<c1184934>] xfs_fs_free_cached_objects+0x13/0x15
  [<c10d06a5>] prune_super+0xd1/0x15c
  [<c10a94fe>] shrink_slab+0x14a/0x2ce
  [<c10abe8a>] kswapd+0x45f/0x74d
  [<c1047a5b>] kthread+0x9e/0xa0
  [<c1478e37>] ret_from_kernel_thread+0x1b/0x28
irq event stamp: 3593819
hardirqs last  enabled at (3593819): [<c1235ded>] __raw_spin_lock_init+0x19/0x4f
hardirqs last disabled at (3593818): [<c1235ded>] __raw_spin_lock_init+0x19/0x4f
softirqs last  enabled at (3593802): [<c10320b9>] __do_softirq+0x132/0x1e5
softirqs last disabled at (3593795): [<c103228b>] irq_exit+0x60/0x67

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&(&ip->i_lock)->mr_lock);
  <Interrupt>
    lock(&(&ip->i_lock)->mr_lock);

 *** DEADLOCK ***

1 lock held by rm/30139:
 #0:  (&(&ip->i_lock)->mr_lock){++++-?}, at: [<c11c5b16>] xfs_ilock+0xb9/0x174

stack backtrace:
CPU: 0 PID: 30139 Comm: rm Not tainted 3.10.0+ #1
Hardware name: Dell Computer Corporation Dimension 2350/07W080, BIOS A01 12/17/2002
 eeb99140 eeb99140 ee457b34 c1471697 ee457b70 c146ee29 c15ac23e c15ac5c8
 000075bb 00000000 00000000 00000000 00000000 00000001 00000001 c15ac5c8
 0000000b eeb99484 00000800 ee457ba4 c1060c4a 0000000b c147cd14 ee456000
Call Trace:
 [<c1471697>] dump_stack+0x16/0x18
 [<c146ee29>] print_usage_bug+0x1dc/0x1e6
 [<c1060c4a>] mark_lock+0x1fb/0x27c
 [<c105fa58>] ? print_shortest_lock_dependencies+0x190/0x190
 [<c1060d54>] mark_held_locks+0x89/0xe9
 [<c100b05e>] ? save_stack_trace+0x2f/0x4b
 [<c1061355>] lockdep_trace_alloc+0x5c/0xb8
 [<c10a3653>] __alloc_pages_nodemask+0x70/0x745
 [<c1060d54>] ? mark_held_locks+0x89/0xe9
 [<c10a3d44>] __get_free_pages+0x1c/0x37
 [<c1025dc4>] pte_alloc_one_kernel+0x14/0x16
 [<c10b7716>] __pte_alloc_kernel+0x16/0x71
 [<c10c0f27>] vmap_page_range_noflush+0x12c/0x13a
 [<c10c1fdb>] vm_map_ram+0x32c/0x3d7
 [<c10c1d21>] ? vm_map_ram+0x72/0x3d7
 [<c1171d3b>] _xfs_buf_map_pages+0x5b/0xe1
 [<c1172a28>] xfs_buf_get_map+0x67/0x154
 [<c11737b2>] xfs_buf_read_map+0x1f/0xd6
 [<c11738b0>] xfs_buf_readahead_map+0x47/0x57
 [<c11b50c4>] xfs_da_reada_buf+0xaf/0xcb
 [<c11b8049>] xfs_dir3_data_readahead+0x2f/0x36
 [<c11763f2>] xfs_dir_open+0x7b/0x8e
 [<c1176377>] ? xfs_file_fallocate+0x123/0x123
 [<c10cce37>] do_dentry_open.isra.18+0xf8/0x1d7
 [<c1176377>] ? xfs_file_fallocate+0x123/0x123
 [<c10cdbef>] finish_open+0x1b/0x27
 [<c10d9617>] do_last+0x43f/0xbf8
 [<c10d7e2e>] ? link_path_walk+0x54/0x6c2
 [<c10d9e7f>] path_openat+0xaf/0x513
 [<c10da314>] do_filp_open+0x31/0x72
 [<c10d7182>] ? getname_flags+0x90/0x124
 [<c10ce055>] do_sys_open+0x107/0x1d8
 [<c147861b>] ? restore_all+0xf/0xf
 [<c10ce16a>] SyS_openat+0x20/0x22
 [<c14785e8>] syscall_call+0x7/0xb
 [<c1470000>] ? pcpu_dump_alloc_info+0x26/0x1ee

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
