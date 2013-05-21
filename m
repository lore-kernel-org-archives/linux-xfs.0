Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E74A929DF8
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 11:21:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C46528F8040
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 09:21:39 -0700 (PDT)
Received: from mail-ie0-f181.google.com (mail-ie0-f181.google.com
	[209.85.223.181]) by cuda.sgi.com with ESMTP id
	jgdOwv4EiRvHOQvP (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 21 May 2013 09:21:35 -0700 (PDT)
Received: by mail-ie0-f181.google.com with SMTP id x12so2232973ief.12
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 09:21:35 -0700 (PDT)
Received: from [192.168.1.2] ([184.52.11.124])
	by mx.google.com with ESMTPSA id qr3sm26301123igb.1.2013.05.21.09.21.28
	for <xfs@oss.sgi.com>
	(version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
	Tue, 21 May 2013 09:21:34 -0700 (PDT)
Message-ID: <519B9EF5.5060809@gmail.com>
Date: Tue, 21 May 2013 12:21:09 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Lockdep message on 3.9.3 (already fixed?)...
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi!  I'm beginning to lose track of lockdep messages and feel like a new 
message is sneaking in there.

This lockdep comes from kernel 3.9.3, which I was asked to use in order 
to gather DRM info.  The PC was booted to a console and left to do a 
long 24kB/s download and default distro cron duties (slocate and such), 
in hopes that console inactivity, console blanking, and monitor sleep 
would kick up a soft oops from DRM like it does on 3.10.0-rc.

This may also apply to the devel kernels, but the PC needs to be left 
alone for me to verify this.

I've read the Dave Chinner position on stable kernels but don't know if 
they apply to the first stable kernel out of mainline...especially 
because that kernel has a lifespan of a housefly nowadays...

As always, thanks for reading!

Michael

=================================
[ INFO: inconsistent lock state ]
3.9.3 #1 Not tainted
---------------------------------
inconsistent {RECLAIM_FS-ON-R} -> {IN-RECLAIM_FS-W} usage.
kswapd0/18 [HC0[0]:SC0[0]:HE1:SE1] takes:
  (&(&ip->i_lock)->mr_lock){++++-?}, at: [<c120e2ea>] xfs_ilock+0xff/0x15e
{RECLAIM_FS-ON-R} state was registered at:
   [<c10638e7>] mark_held_locks+0x80/0xcb
   [<c1063e18>] lockdep_trace_alloc+0x59/0x9d
   [<c10a9846>] __alloc_pages_nodemask+0x70/0x6f2
   [<c10a9ee4>] __get_free_pages+0x1c/0x3d
   [<c1025644>] pte_alloc_one_kernel+0x14/0x16
   [<c10beb1b>] __pte_alloc_kernel+0x16/0x71
   [<c10c8380>] vmap_page_range_noflush+0x12e/0x13c
   [<c10c9480>] vm_map_ram+0x3b9/0x46c
   [<c11c0739>] _xfs_buf_map_pages+0x5b/0xe7
   [<c11c1372>] xfs_buf_get_map+0x67/0x13a
   [<c11c1ff2>] xfs_buf_read_map+0x1f/0xc0
   [<c11c20da>] xfs_buf_readahead_map+0x47/0x57
   [<c11ffc18>] xfs_da_reada_buf+0xaf/0xbd
   [<c120276c>] xfs_dir2_data_readahead+0x2f/0x36
   [<c11c4a22>] xfs_dir_open+0x7b/0x8e
   [<c10d3e77>] do_dentry_open.isra.16+0xf8/0x1d7
   [<c10d4bcf>] finish_open+0x1b/0x27
   [<c10e004c>] do_last+0x44d/0xc68
   [<c10e090b>] path_openat+0xa4/0x3cb
   [<c10e0c5d>] do_filp_open+0x2b/0x70
   [<c10d4fa2>] do_sys_open+0xf5/0x1b5
   [<c10d50b2>] sys_openat+0x26/0x28
   [<c158d678>] syscall_call+0x7/0xb
irq event stamp: 266081
hardirqs last  enabled at (266081): [<c158cf19>] 
_raw_spin_unlock_irq+0x27/0x2b
hardirqs last disabled at (266080): [<c158ce0c>] 
_raw_spin_lock_irq+0x14/0x4b
softirqs last  enabled at (264480): [<c1031e7b>] __do_softirq+0x125/0x1bc
softirqs last disabled at (264455): [<c1032025>] irq_exit+0x63/0x65

other info that might help us debug this:
  Possible unsafe locking scenario:

        CPU0
        ----
   lock(&(&ip->i_lock)->mr_lock);
   <Interrupt>
     lock(&(&ip->i_lock)->mr_lock);

  *** DEADLOCK ***

3 locks held by kswapd0/18:
  #0:  (shrinker_rwsem){++++..}, at: [<c10afe9b>] shrink_slab+0x2f/0x29b
  #1:  (&type->s_umount_key#18){++++.+}, at: [<c10d72ba>] 
grab_super_passive+0x38/0x72
  #2:  (&pag->pag_ici_reclaim_lock){+.+...}, at: [<c11ca176>] 
xfs_reclaim_inodes_ag+0xb4/0x37f

stack backtrace:
Pid: 18, comm: kswapd0 Not tainted 3.9.3 #1
Call Trace:
  [<c1584cd9>] print_usage_bug+0x1dc/0x1e6
  [<c1062f8a>] ? check_usage_backwards+0xea/0xea
  [<c1063850>] mark_lock+0x245/0x25c
  [<c1064f50>] __lock_acquire+0x5da/0x1557
  [<c104fce4>] ? finish_task_switch.constprop.80+0x3b/0xb9
  [<c158b73d>] ? __schedule+0x2ae/0x5e5
  [<c10664bc>] lock_acquire+0x7f/0xdc
  [<c120e2ea>] ? xfs_ilock+0xff/0x15e
  [<c104abf0>] down_write_nested+0x41/0x61
  [<c120e2ea>] ? xfs_ilock+0xff/0x15e
  [<c120e2ea>] xfs_ilock+0xff/0x15e
  [<c11c9ea8>] xfs_reclaim_inode+0xf4/0x30e
  [<c11ca32c>] xfs_reclaim_inodes_ag+0x26a/0x37f
  [<c11ca19f>] ? xfs_reclaim_inodes_ag+0xdd/0x37f
  [<c1063a1a>] ? trace_hardirqs_on_caller+0xe8/0x160
  [<c1063a9d>] ? trace_hardirqs_on+0xb/0xd
  [<c1051124>] ? try_to_wake_up+0xe1/0x122
  [<c10511ac>] ? wake_up_process+0x1f/0x33
  [<c12275e3>] ? xfs_ail_push+0x68/0x6f
  [<c122763d>] ? xfs_ail_push_all+0x53/0x6a
  [<c11ca4bf>] xfs_reclaim_inodes_nr+0x2d/0x33
  [<c11d1bbe>] xfs_fs_free_cached_objects+0x13/0x15
  [<c10d73c5>] prune_super+0xd1/0x15c
  [<c10affaf>] shrink_slab+0x143/0x29b
  [<c10b2671>] kswapd+0x54b/0x794
  [<c10b2126>] ? try_to_free_pages+0x61f/0x61f
  [<c1046a1b>] kthread+0x9e/0xa0
  [<c158dcb7>] ret_from_kernel_thread+0x1b/0x28
  [<c104697d>] ? __kthread_parkme+0x5b/0x5b

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
