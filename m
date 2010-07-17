Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6H3wF2R046728 for <xfs@oss.sgi.com>; Fri, 16 Jul 2010 22:58:15 -0500
Received: from mail-vw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D0AF915ECC76
	for <xfs@oss.sgi.com>; Fri, 16 Jul 2010 21:01:12 -0700 (PDT)
Received: from mail-vw0-f53.google.com (mail-vw0-f53.google.com
	[209.85.212.53]) by cuda.sgi.com with ESMTP id AXDvaGAFaoosGWlS
	for <xfs@oss.sgi.com>; Fri, 16 Jul 2010 21:01:12 -0700 (PDT)
Received: by vws15 with SMTP id 15so3215976vws.26
	for <xfs@oss.sgi.com>; Fri, 16 Jul 2010 21:01:11 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 17 Jul 2010 00:01:11 -0400
Message-ID: <AANLkTilX3l8TbUztLStj_u9OqOZnBrsNQxmeV4DuBmYJ@mail.gmail.com>
Subject: XFS hung on 2.6.33.3 kernel
From: Ilia Mirkin <imirkin@alum.mit.edu>
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
To: xfs@oss.sgi.com

Hi XFS developers,

I ended up getting this on a 2.6.33.3 kernel. I realize this is not
the latest, but I've only gotten this once, so it will not be possible
to easily determine whether this is gone in the latest release or not.

The details of the situation is that there is an XFS filesystem on a
hardware RAID10 array (directly on the device, no partition table),
and it exclusively houses a mysql (5.0) database. The database gets
backed up nightly, which is basically a glorified tar'ing of most of
the partition. The non-mysql process you see there are related to a
mysql backup program (which coincidentally triggers WARN's in xfs
code, as per http://marc.info/?l=linux-xfs&m=127632333825584&w=2;
however it sounded like those WARN's were not warning about an
in-kernel problems; curiously, the last WARN's in the kernel log
appear to have been from the prior day's backup run, not the one that
triggered the hang). There's also a sync that I ran as a last-ditch
effort at saving the system. On reboot, everything came back up OK.

[

For reference, the warns look like this:

[5444728.784257] ------------[ cut here ]------------
[5444728.784269] WARNING: at fs/xfs/linux-2.6/xfs_lrw.c:651
xfs_write+0x3dc/0x784()
[5444728.784272] Hardware name: PowerEdge R710
[5444728.784275] Modules linked in: nfsd cifs iTCO_wdt iTCO_vendor_support
[5444728.784286] Pid: 7765, comm: mysqld Tainted: G        W
2.6.33-gentoo-r2 #1
[5444728.784287] Call Trace:
[5444728.784291]  [<ffffffff8120da46>] ? xfs_write+0x3dc/0x784
[5444728.784295]  [<ffffffff81038733>] warn_slowpath_common+0x77/0xa4
[5444728.784297]  [<ffffffff8103876f>] warn_slowpath_null+0xf/0x11
[5444728.784299]  [<ffffffff8120da46>] xfs_write+0x3dc/0x784
[5444728.784303]  [<ffffffff8120a51a>] xfs_file_aio_write+0x5a/0x5c
[5444728.784306]  [<ffffffff810d7cbe>] do_sync_write+0xc0/0x106
[5444728.784310]  [<ffffffff81032879>] ? finish_task_switch+0x43/0xac
[5444728.784312]  [<ffffffff810d8624>] vfs_write+0xab/0x105
[5444728.784314]  [<ffffffff810d86da>] sys_pwrite64+0x5c/0x7d
[5444728.784319]  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
[5444728.784321] ---[ end trace 8b0c2a6e5e867a01 ]---

]

While the system was stuck, vmstat did not report any block-in/out on
the device. I have rrd's of those if necessary. Let me know if I might
be able to provide any other useful info, or if you think that this
sort of thing should be fixed in the latest linux kernel release. I
saw that there have been a lot of XFS updates since 2.6.33, but none
stood out as addressing this type of situation.

Here is the output of "echo w > /proc/sysrq-trigger":

 SysRq : Show Blocked State
   task                        PC stack   pid father
 xfsdatad/7    D ffff88123885d3e0  6792   772      2 0x00000000
  ffff88123887fd90 0000000000000046 0000000000000000 ffff88123887fd5c
  0000000000000000 000000000000de78 ffff88123887ffd8 0000000000013c00
  ffff88123887ffd8 0000000000013c00 ffff88123885d3e0 ffff881239d23d00
 Call Trace:
  [<ffffffff81045f9c>] ? __mod_timer+0x13d/0x14f
  [<ffffffff814eb81c>] schedule_timeout+0x98/0xbf
  [<ffffffff81045b27>] ? process_timeout+0x0/0xb
  [<ffffffff814eb85c>] schedule_timeout_uninterruptible+0x19/0x1b
  [<ffffffff81206512>] xfs_end_io+0x7d/0x8c
  [<ffffffff8104de65>] worker_thread+0x18d/0x222
  [<ffffffff81206495>] ? xfs_end_io+0x0/0x8c
  [<ffffffff810517ab>] ? autoremove_wake_function+0x0/0x38
  [<ffffffff8104dcd8>] ? worker_thread+0x0/0x222
  [<ffffffff81051336>] kthread+0x7d/0x85
  [<ffffffff81003814>] kernel_thread_helper+0x4/0x10
  [<ffffffff810512b9>] ? kthread+0x0/0x85
  [<ffffffff81003810>] ? kernel_thread_helper+0x0/0x10
 mysqld        D ffff880938821380  4696  7750      1 0x00000000
  ffff880650e01cb8 0000000000000082 00715f4f00000001 0000000000000000
  ffff88090a0bd3e0 000000000000de78 ffff880650e01fd8 0000000000013c00
  ffff880650e01fd8 0000000000013c00 ffff88090a0bd3e0 ffff88090a0bf260
 Call Trace:
  [<ffffffff814ebc5a>] __mutex_lock_common+0x139/0x1a2
  [<ffffffff814ebcd7>] __mutex_lock_slowpath+0x14/0x16
  [<ffffffff814ebda5>] mutex_lock+0x1e/0x35
  [<ffffffff8120e1bf>] xfs_read+0x100/0x1f9
  [<ffffffff8120a574>] xfs_file_aio_read+0x58/0x5c
  [<ffffffff810d7dc4>] do_sync_read+0xc0/0x106
  [<ffffffff8102832b>] ? pick_next_task+0x22/0x3e
  [<ffffffff810d8813>] vfs_read+0xa8/0x102
  [<ffffffff810d88c9>] sys_pread64+0x5c/0x7d
  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
 mysqld        D ffff880938821380  4760  7751      1 0x00000000
  ffff880650e6bcb8 0000000000000082 007cd91100000001 ffff88090a0bcc78
  ffff88095fc13c00 000000000000de78 ffff880650e6bfd8 0000000000013c00
  ffff880650e6bfd8 0000000000013c00 ffff88090a0bf260 ffff88090a0b8000
 Call Trace:
  [<ffffffff814ebc5a>] __mutex_lock_common+0x139/0x1a2
  [<ffffffff814ebcd7>] __mutex_lock_slowpath+0x14/0x16
  [<ffffffff814ebda5>] mutex_lock+0x1e/0x35
  [<ffffffff8120e1bf>] xfs_read+0x100/0x1f9
  [<ffffffff8120a574>] xfs_file_aio_read+0x58/0x5c
  [<ffffffff810d7dc4>] do_sync_read+0xc0/0x106
  [<ffffffff810d8813>] vfs_read+0xa8/0x102
  [<ffffffff810d88c9>] sys_pread64+0x5c/0x7d
  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
 mysqld        D ffff880938821380  4768  7752      1 0x00000000
  ffff880650e6dcb8 0000000000000082 0085722500000001 ffff88090a0b8038
  ffff880028273c00 000000000000de78 ffff880650e6dfd8 0000000000013c00
  ffff880650e6dfd8 0000000000013c00 ffff88090a0bcc40 ffff88090a0b96e0
 Call Trace:
  [<ffffffff81027beb>] ? activate_task+0x28/0x31
  [<ffffffff814ebc5a>] __mutex_lock_common+0x139/0x1a2
  [<ffffffff814ebcd7>] __mutex_lock_slowpath+0x14/0x16
  [<ffffffff814ebda5>] mutex_lock+0x1e/0x35
  [<ffffffff8120e1bf>] xfs_read+0x100/0x1f9
  [<ffffffff8120a574>] xfs_file_aio_read+0x58/0x5c
  [<ffffffff810d7dc4>] do_sync_read+0xc0/0x106
  [<ffffffff81032879>] ? finish_task_switch+0x43/0xac
  [<ffffffff810d8813>] vfs_read+0xa8/0x102
  [<ffffffff810d88c9>] sys_pread64+0x5c/0x7d
  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
 mysqld        D 0000000000000000  4768  7755      1 0x00000000
  ffff88029a60fcb8 0000000000000082 0000000000000000 ffff88090a0b9718
  ffff88095fc13c00 000000000000de78 ffff88029a60ffd8 0000000000013c00
  ffff88029a60ffd8 0000000000013c00 ffff88090a0b8000 ffff881239d23d00
 Call Trace:
  [<ffffffff81027beb>] ? activate_task+0x28/0x31
  [<ffffffff814ebc5a>] __mutex_lock_common+0x139/0x1a2
  [<ffffffff814ebcd7>] __mutex_lock_slowpath+0x14/0x16
  [<ffffffff814ebda5>] mutex_lock+0x1e/0x35
  [<ffffffff8120e1bf>] xfs_read+0x100/0x1f9
  [<ffffffff8120a574>] xfs_file_aio_read+0x58/0x5c
  [<ffffffff810d7dc4>] do_sync_read+0xc0/0x106
  [<ffffffff8102832b>] ? pick_next_task+0x22/0x3e
  [<ffffffff810d8813>] vfs_read+0xa8/0x102
  [<ffffffff810d88c9>] sys_pread64+0x5c/0x7d
  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
 mysqld        D ffff880938821380  4696  7756      1 0x00000000
  ffff88029a633cb8 0000000000000082 0091c4f90a0b9718 ffff88090a0bf298
  ffff880028273c00 000000000000de78 ffff88029a633fd8 0000000000013c00
  ffff88029a633fd8 0000000000013c00 ffff88090a0be320 ffff8812384c8000
 Call Trace:
  [<ffffffff81027beb>] ? activate_task+0x28/0x31
  [<ffffffff814ebc5a>] __mutex_lock_common+0x139/0x1a2
  [<ffffffff814ebcd7>] __mutex_lock_slowpath+0x14/0x16
  [<ffffffff814ebda5>] mutex_lock+0x1e/0x35
  [<ffffffff8120e1bf>] xfs_read+0x100/0x1f9
  [<ffffffff8120a574>] xfs_file_aio_read+0x58/0x5c
  [<ffffffff810d7dc4>] do_sync_read+0xc0/0x106
  [<ffffffff8102832b>] ? pick_next_task+0x22/0x3e
  [<ffffffff810d8813>] vfs_read+0xa8/0x102
  [<ffffffff810d88c9>] sys_pread64+0x5c/0x7d
  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
 mysqld        D 0000000000000000  4696  7757      1 0x00000000
  ffff8801b4fdfcb8 0000000000000082 0000000000000000 ffff88090a0beaf8
  ffff88095fc33c00 000000000000de78 ffff8801b4fdffd8 0000000000013c00
  ffff8801b4fdffd8 0000000000013c00 ffff88090a0b9e80 ffff880939c9adc0
 Call Trace:
  [<ffffffff81027beb>] ? activate_task+0x28/0x31
  [<ffffffff814ebc5a>] __mutex_lock_common+0x139/0x1a2
  [<ffffffff814ebcd7>] __mutex_lock_slowpath+0x14/0x16
  [<ffffffff814ebda5>] mutex_lock+0x1e/0x35
  [<ffffffff8120e1bf>] xfs_read+0x100/0x1f9
  [<ffffffff8120a574>] xfs_file_aio_read+0x58/0x5c
  [<ffffffff810d7dc4>] do_sync_read+0xc0/0x106
  [<ffffffff8102832b>] ? pick_next_task+0x22/0x3e
  [<ffffffff810d8813>] vfs_read+0xa8/0x102
  [<ffffffff810d88c9>] sys_pread64+0x5c/0x7d
  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
 mysqld        D 0000000000000000  4648  7758      1 0x00000000
  ffff8801b4f1bc08 0000000000000082 0000000000000000 ffffffff8102cbe0
  ffff8801b4f1bb88 000000000000de78 ffff8801b4f1bfd8 0000000000013c00
  ffff8801b4f1bfd8 0000000000013c00 ffff88090a0bb560 ffff880939ce8000
 Call Trace:
  [<ffffffff8102cbe0>] ? check_preempt_wakeup+0xde/0x15d
  [<ffffffff814ec6ac>] ? rwsem_down_failed_common+0x96/0xc8
  [<ffffffff814ebc5a>] __mutex_lock_common+0x139/0x1a2
  [<ffffffff814ebcd7>] __mutex_lock_slowpath+0x14/0x16
  [<ffffffff814ebda5>] mutex_lock+0x1e/0x35
  [<ffffffff8120d922>] xfs_write+0x2b8/0x784
  [<ffffffff8120a51a>] xfs_file_aio_write+0x5a/0x5c
  [<ffffffff810d7cbe>] do_sync_write+0xc0/0x106
  [<ffffffff810d8624>] vfs_write+0xab/0x105
  [<ffffffff810d86da>] sys_pwrite64+0x5c/0x7d
  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
 mysqld        D ffff880938821380  4648  7759      1 0x00000000
  ffff88029a627c08 0000000000000082 000000009a627b88 ffffffff8102cbe0
  ffff88029a627b88 000000000000de78 ffff88029a627fd8 0000000000013c00
  ffff88029a627fd8 0000000000013c00 ffff88090a0ba620 ffff8812116787a0
 Call Trace:
  [<ffffffff8102cbe0>] ? check_preempt_wakeup+0xde/0x15d
  [<ffffffff814ec6ac>] ? rwsem_down_failed_common+0x96/0xc8
  [<ffffffff814ebc5a>] __mutex_lock_common+0x139/0x1a2
  [<ffffffff814ebcd7>] __mutex_lock_slowpath+0x14/0x16
  [<ffffffff814ebda5>] mutex_lock+0x1e/0x35
  [<ffffffff8120d922>] xfs_write+0x2b8/0x784
  [<ffffffff81034825>] ? wake_up_state+0xb/0xd
  [<ffffffff814ecb8e>] ? common_interrupt+0xe/0x13
  [<ffffffff8120a51a>] xfs_file_aio_write+0x5a/0x5c
  [<ffffffff810d7cbe>] do_sync_write+0xc0/0x106
  [<ffffffff810ff862>] ? __fsnotify_parent+0xc7/0xd3
  [<ffffffff810d8624>] vfs_write+0xab/0x105
  [<ffffffff810d86da>] sys_pwrite64+0x5c/0x7d
  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
 mysqld        D 0000000000000000  4648  7760      1 0x00000000
  ffff88029a611c08 0000000000000082 0000000000000000 ffffffff8102cbe0
  ffff88029a611b88 000000000000de78 ffff88029a611fd8 0000000000013c00
  ffff88029a611fd8 0000000000013c00 ffff88090a0badc0 ffff880939ce8000
 Call Trace:
  [<ffffffff8102cbe0>] ? check_preempt_wakeup+0xde/0x15d
  [<ffffffff814ec6ac>] ? rwsem_down_failed_common+0x96/0xc8
  [<ffffffff814ebc5a>] __mutex_lock_common+0x139/0x1a2
  [<ffffffff814ebcd7>] __mutex_lock_slowpath+0x14/0x16
  [<ffffffff814ebda5>] mutex_lock+0x1e/0x35
  [<ffffffff8120d922>] xfs_write+0x2b8/0x784
  [<ffffffff81034825>] ? wake_up_state+0xb/0xd
  [<ffffffff810033ce>] ? apic_timer_interrupt+0xe/0x20
  [<ffffffff8120a51a>] xfs_file_aio_write+0x5a/0x5c
  [<ffffffff810d7cbe>] do_sync_write+0xc0/0x106
  [<ffffffff810d8624>] vfs_write+0xab/0x105
  [<ffffffff810d86da>] sys_pwrite64+0x5c/0x7d
  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
 mysqld        D 0000000000000000  4648  7761      1 0x00000000
  ffff88029a60bc08 0000000000000082 0000000000000000 ffff88002826de78
  0000000249c7788e 000000000000de78 ffff88029a60bfd8 0000000000013c00
  ffff88029a60bfd8 0000000000013c00 ffff88090a0bdb80 ffff881239d23d00
 Call Trace:
  [<ffffffff814ec6ac>] ? rwsem_down_failed_common+0x96/0xc8
  [<ffffffff814ebc5a>] __mutex_lock_common+0x139/0x1a2
  [<ffffffff814ebcd7>] __mutex_lock_slowpath+0x14/0x16
  [<ffffffff814ebda5>] mutex_lock+0x1e/0x35
  [<ffffffff8120d922>] xfs_write+0x2b8/0x784
  [<ffffffff81034825>] ? wake_up_state+0xb/0xd
  [<ffffffff814ecb8e>] ? common_interrupt+0xe/0x13
  [<ffffffff8120a51a>] xfs_file_aio_write+0x5a/0x5c
  [<ffffffff810d7cbe>] do_sync_write+0xc0/0x106
  [<ffffffff81101c00>] ? inotify_dentry_parent_queue_event+0x80/0x8c
  [<ffffffff810d8624>] vfs_write+0xab/0x105
  [<ffffffff810d86da>] sys_pwrite64+0x5c/0x7d
  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
 mysqld        D 0000000000000000  4648  7762      1 0x00000000
  ffff8806357d5c08 0000000000000082 0000000000000000 ffffffff8102cbe0
  ffff8806357d5b88 000000000000de78 ffff8806357d5fd8 0000000000013c00
  ffff8806357d5fd8 0000000000013c00 ffff88090a0bc4a0 ffff880939ce8000
 Call Trace:
  [<ffffffff8102cbe0>] ? check_preempt_wakeup+0xde/0x15d
  [<ffffffff814ec6ac>] ? rwsem_down_failed_common+0x96/0xc8
  [<ffffffff814ebc5a>] __mutex_lock_common+0x139/0x1a2
  [<ffffffff814ebcd7>] __mutex_lock_slowpath+0x14/0x16
  [<ffffffff814ebda5>] mutex_lock+0x1e/0x35
  [<ffffffff8120d922>] xfs_write+0x2b8/0x784
  [<ffffffff814ecb8e>] ? common_interrupt+0xe/0x13
  [<ffffffff8120a51a>] xfs_file_aio_write+0x5a/0x5c
  [<ffffffff810d7cbe>] do_sync_write+0xc0/0x106
  [<ffffffff81101c00>] ? inotify_dentry_parent_queue_event+0x80/0x8c
  [<ffffffff810d8624>] vfs_write+0xab/0x105
  [<ffffffff810d86da>] sys_pwrite64+0x5c/0x7d
  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
 mysqld        D ffff880938821380  4648  7763      1 0x00000000
  ffff8801b4febbb8 0000000000000082 ffff8801b4febb58 ffff880937ea2df8
  000000000000de78 000000000000de78 ffff8801b4febfd8 0000000000013c00
  ffff8801b4febfd8 0000000000013c00 ffff880937ea6ac0 ffff8812116787a0
 Call Trace:
  [<ffffffff81027beb>] ? activate_task+0x28/0x31
  [<ffffffff814ec6ac>] rwsem_down_failed_common+0x96/0xc8
  [<ffffffff814ec6fe>] rwsem_down_write_failed+0x20/0x2a
  [<ffffffff812504b3>] call_rwsem_down_write_failed+0x13/0x20
  [<ffffffff814ec005>] ? down_write+0x2d/0x31
  [<ffffffff811ebd14>] xfs_ilock+0x23/0x94
  [<ffffffff8120d92f>] xfs_write+0x2c5/0x784
  [<ffffffff81034825>] ? wake_up_state+0xb/0xd
  [<ffffffff814ecb8e>] ? common_interrupt+0xe/0x13
  [<ffffffff8120a51a>] xfs_file_aio_write+0x5a/0x5c
  [<ffffffff810d7cbe>] do_sync_write+0xc0/0x106
  [<ffffffff810d8624>] vfs_write+0xab/0x105
  [<ffffffff810d86da>] sys_pwrite64+0x5c/0x7d
  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
 mysqld        D 0000000000000000  4648  7764      1 0x00000000
  ffff880287b4dc08 0000000000000082 0000000000000000 ffff880287b4dec8
  ffff880287b4db78 000000000000de78 ffff880287b4dfd8 0000000000013c00
  ffff880287b4dfd8 0000000000013c00 ffff880937ea4c40 ffff880939ce8000
 Call Trace:
  [<ffffffff814ec6ac>] ? rwsem_down_failed_common+0x96/0xc8
  [<ffffffff814ebc5a>] __mutex_lock_common+0x139/0x1a2
  [<ffffffff814ebcd7>] __mutex_lock_slowpath+0x14/0x16
  [<ffffffff814ebda5>] mutex_lock+0x1e/0x35
  [<ffffffff8120d922>] xfs_write+0x2b8/0x784
  [<ffffffff81034825>] ? wake_up_state+0xb/0xd
  [<ffffffff814ecb8e>] ? common_interrupt+0xe/0x13
  [<ffffffff8120a51a>] xfs_file_aio_write+0x5a/0x5c
  [<ffffffff810d7cbe>] do_sync_write+0xc0/0x106
  [<ffffffff814ecb8e>] ? common_interrupt+0xe/0x13
  [<ffffffff810d8624>] vfs_write+0xab/0x105
  [<ffffffff810d86da>] sys_pwrite64+0x5c/0x7d
  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
 mysqld        D 0000000000000002  4648  7765      1 0x00000000
  ffff880287b4ba78 0000000000000082 0000000000000000 0000000000000001
  0000000000000096 000000000000de78 ffff880287b4bfd8 0000000000013c00
  ffff880287b4bfd8 0000000000013c00 ffff880937ea2dc0 ffff88123885d3e0
 Call Trace:
  [<ffffffff8104e062>] ? insert_work+0x92/0x9e
  [<ffffffff8105945a>] ? ktime_get_ts+0xb1/0xbe
  [<ffffffff814eb4b9>] io_schedule+0x7b/0xc1
  [<ffffffff8109fc02>] sync_page+0x41/0x45
  [<ffffffff814eb8d9>] __wait_on_bit_lock+0x45/0x8c
  [<ffffffff8109fbc1>] ? sync_page+0x0/0x45
  [<ffffffff8109fb84>] __lock_page+0x63/0x6a
  [<ffffffff810517e3>] ? wake_bit_function+0x0/0x2a
  [<ffffffff810a82de>] lock_page+0x24/0x28
  [<ffffffff810a8364>] invalidate_inode_pages2_range+0x82/0x2af
  [<ffffffff8120646a>] ? xfs_vm_direct_IO+0x90/0xbb
  [<ffffffff812066a8>] ? xfs_get_blocks_direct+0x0/0x17
  [<ffffffff812062c8>] ? xfs_end_io_direct+0x0/0x4e
  [<ffffffff810a085d>] generic_file_direct_write+0xf5/0x14b
  [<ffffffff8120db02>] xfs_write+0x498/0x784
  [<ffffffff81034825>] ? wake_up_state+0xb/0xd
  [<ffffffff8120a51a>] xfs_file_aio_write+0x5a/0x5c
  [<ffffffff810d7cbe>] do_sync_write+0xc0/0x106
  [<ffffffff810d8624>] vfs_write+0xab/0x105
  [<ffffffff810d86da>] sys_pwrite64+0x5c/0x7d
  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
 mysqld        D 0000000000000000  4240  7787      1 0x00000000
  ffff8801b4f67cb8 0000000000000082 0000000000000000 0000000000000296
  ffff8801b4f67c58 000000000000de78 ffff8801b4f67fd8 0000000000013c00
  ffff8801b4f67fd8 0000000000013c00 ffff8809388d6320 ffff880939ce8000
 Call Trace:
  [<ffffffff8105ee38>] ? wake_futex+0x3b/0x57
  [<ffffffff814ebc5a>] __mutex_lock_common+0x139/0x1a2
  [<ffffffff814ebcd7>] __mutex_lock_slowpath+0x14/0x16
  [<ffffffff814ebda5>] mutex_lock+0x1e/0x35
  [<ffffffff8120e1bf>] xfs_read+0x100/0x1f9
  [<ffffffff8120a574>] xfs_file_aio_read+0x58/0x5c
  [<ffffffff810d7dc4>] do_sync_read+0xc0/0x106
  [<ffffffff811f6f46>] ? xfs_log_reserve+0x101/0x10a
  [<ffffffff81204b5c>] ? xfs_fsync+0x135/0x16a
  [<ffffffff810d8813>] vfs_read+0xa8/0x102
  [<ffffffff810d88c9>] sys_pread64+0x5c/0x7d
  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
 mysqld        D 0000000000000000  3776 22038      1 0x00000000
  ffff880da3973cb8 0000000000000082 0000000000000000 ffffffff813fc68a
  ffff880da3973c28 000000000000de78 ffff880da3973fd8 0000000000013c00
  ffff880da3973fd8 0000000000013c00 ffff88097f63c4a0 ffff881239d20f40
 Call Trace:
  [<ffffffff813fc68a>] ? release_sock+0xb2/0xba
  [<ffffffff814ebc5a>] __mutex_lock_common+0x139/0x1a2
  [<ffffffff814ebcd7>] __mutex_lock_slowpath+0x14/0x16
  [<ffffffff814ebda5>] mutex_lock+0x1e/0x35
  [<ffffffff8120e1bf>] xfs_read+0x100/0x1f9
  [<ffffffff8120a574>] xfs_file_aio_read+0x58/0x5c
  [<ffffffff810d7dc4>] do_sync_read+0xc0/0x106
  [<ffffffff810d7dc4>] ? do_sync_read+0xc0/0x106
  [<ffffffff810d8813>] vfs_read+0xa8/0x102
  [<ffffffff810d88c9>] sys_pread64+0x5c/0x7d
  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
 mysqld        D 0000000000000000  3776 29433      1 0x00000000
  ffff881236b49cb8 0000000000000082 0000000000000000 ffffffff813fc68a
  ffff881236b49c28 000000000000de78 ffff881236b49fd8 0000000000013c00
  ffff881236b49fd8 0000000000013c00 ffff880dc6e244a0 ffff881239d20f40
 Call Trace:
  [<ffffffff813fc68a>] ? release_sock+0xb2/0xba
  [<ffffffff814ebc5a>] __mutex_lock_common+0x139/0x1a2
  [<ffffffff814ebcd7>] __mutex_lock_slowpath+0x14/0x16
  [<ffffffff814ebda5>] mutex_lock+0x1e/0x35
  [<ffffffff8120e1bf>] xfs_read+0x100/0x1f9
  [<ffffffff8120a574>] xfs_file_aio_read+0x58/0x5c
  [<ffffffff810d7dc4>] do_sync_read+0xc0/0x106
  [<ffffffff810d7dc4>] ? do_sync_read+0xc0/0x106
  [<ffffffff810d8813>] vfs_read+0xa8/0x102
  [<ffffffff810d88c9>] sys_pread64+0x5c/0x7d
  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
 mysqld        D 0000000000000000  4544  5673      1 0x00000000
  ffff880fa9189cb8 0000000000000082 0000000000000000 ffffffff813fc68a
  ffff880d751f0d00 000000000000de78 ffff880fa9189fd8 0000000000013c00
  ffff880fa9189fd8 0000000000013c00 ffff880bf12c2620 ffff880939c9c4a0
 Call Trace:
  [<ffffffff813fc68a>] ? release_sock+0xb2/0xba
  [<ffffffff814ebc5a>] __mutex_lock_common+0x139/0x1a2
  [<ffffffff814ebcd7>] __mutex_lock_slowpath+0x14/0x16
  [<ffffffff814ebda5>] mutex_lock+0x1e/0x35
  [<ffffffff8120e1bf>] xfs_read+0x100/0x1f9
  [<ffffffff8120a574>] xfs_file_aio_read+0x58/0x5c
  [<ffffffff810d7dc4>] do_sync_read+0xc0/0x106
  [<ffffffff810d7dc4>] ? do_sync_read+0xc0/0x106
  [<ffffffff8102832b>] ? pick_next_task+0x22/0x3e
  [<ffffffff810d8813>] vfs_read+0xa8/0x102
  [<ffffffff810d88c9>] sys_pread64+0x5c/0x7d
  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
 mysqld        D 0000000000000000  3632  6093      1 0x00000000
  ffff880e39e61cb8 0000000000000082 0000000000000000 ffffffff813fc68a
  ffff880e39e61c28 000000000000de78 ffff880e39e61fd8 0000000000013c00
  ffff880e39e61fd8 0000000000013c00 ffff8811f78d1e80 ffff880939c9c4a0
 Call Trace:
  [<ffffffff813fc68a>] ? release_sock+0xb2/0xba
  [<ffffffff814ebc5a>] __mutex_lock_common+0x139/0x1a2
  [<ffffffff814ebcd7>] __mutex_lock_slowpath+0x14/0x16
  [<ffffffff814ebda5>] mutex_lock+0x1e/0x35
  [<ffffffff8120e1bf>] xfs_read+0x100/0x1f9
  [<ffffffff8120a574>] xfs_file_aio_read+0x58/0x5c
  [<ffffffff810d7dc4>] do_sync_read+0xc0/0x106
  [<ffffffff810d7dc4>] ? do_sync_read+0xc0/0x106
  [<ffffffff810d8813>] vfs_read+0xa8/0x102
  [<ffffffff810d88c9>] sys_pread64+0x5c/0x7d
  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
 mysqld        D 0000000000000000  5336  6840      1 0x00000000
  ffff880e3d89fcb8 0000000000000082 0000000000000000 ffffffff813fc68a
  ffff880e3d89fc28 000000000000de78 ffff880e3d89ffd8 0000000000013c00
  ffff880e3d89ffd8 0000000000013c00 ffff8809aba6f260 ffff880939c9c4a0
 Call Trace:
  [<ffffffff813fc68a>] ? release_sock+0xb2/0xba
  [<ffffffff814ebc5a>] __mutex_lock_common+0x139/0x1a2
  [<ffffffff814ebcd7>] __mutex_lock_slowpath+0x14/0x16
  [<ffffffff814ebda5>] mutex_lock+0x1e/0x35
  [<ffffffff8120e1bf>] xfs_read+0x100/0x1f9
  [<ffffffff8120a574>] xfs_file_aio_read+0x58/0x5c
  [<ffffffff810d7dc4>] do_sync_read+0xc0/0x106
  [<ffffffff810d7dc4>] ? do_sync_read+0xc0/0x106
  [<ffffffff810d8813>] vfs_read+0xa8/0x102
  [<ffffffff810d88c9>] sys_pread64+0x5c/0x7d
  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
 mysqld        D 0000000000000000  5336  6841      1 0x00000000
  ffff8803f0d73cb8 0000000000000082 0000000000000000 ffffffff813fc68a
  ffff8803f0d73c28 000000000000de78 ffff8803f0d73fd8 0000000000013c00
  ffff8803f0d73fd8 0000000000013c00 ffff8807c98444a0 ffff880939c9f260
 Call Trace:
  [<ffffffff813fc68a>] ? release_sock+0xb2/0xba
  [<ffffffff814ebc5a>] __mutex_lock_common+0x139/0x1a2
  [<ffffffff814ebcd7>] __mutex_lock_slowpath+0x14/0x16
  [<ffffffff814ebda5>] mutex_lock+0x1e/0x35
  [<ffffffff8120e1bf>] xfs_read+0x100/0x1f9
  [<ffffffff8120a574>] xfs_file_aio_read+0x58/0x5c
  [<ffffffff810d7dc4>] do_sync_read+0xc0/0x106
  [<ffffffff810d7dc4>] ? do_sync_read+0xc0/0x106
  [<ffffffff810d8813>] vfs_read+0xa8/0x102
  [<ffffffff810d88c9>] sys_pread64+0x5c/0x7d
  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
 mysqld        D 0000000000000000  5328  6883      1 0x00000000
  ffff880a3994fcb8 0000000000000082 0000000000000000 ffffffff813fc68a
  0000000000000005 000000000000de78 ffff880a3994ffd8 0000000000013c00
  ffff880a3994ffd8 0000000000013c00 ffff8811567cdb80 ffffffff81a0e020
 Call Trace:
  [<ffffffff813fc68a>] ? release_sock+0xb2/0xba
  [<ffffffff814ebc5a>] __mutex_lock_common+0x139/0x1a2
  [<ffffffff810ed26a>] ? mntput_no_expire+0x24/0xe0
  [<ffffffff814ebcd7>] __mutex_lock_slowpath+0x14/0x16
  [<ffffffff814ebda5>] mutex_lock+0x1e/0x35
  [<ffffffff8120e1bf>] xfs_read+0x100/0x1f9
  [<ffffffff8120a574>] xfs_file_aio_read+0x58/0x5c
  [<ffffffff810d7dc4>] do_sync_read+0xc0/0x106
  [<ffffffff810d8813>] vfs_read+0xa8/0x102
  [<ffffffff810d88c9>] sys_pread64+0x5c/0x7d
  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
 mysqld        D 0000000000000000  5312  6887      1 0x00000000
  ffff880fb56c9cb8 0000000000000082 0000000000000000 ffffffff813fc68a
  ffff881039c8a080 000000000000de78 ffff880fb56c9fd8 0000000000013c00
  ffff880fb56c9fd8 0000000000013c00 ffff880e3659cc40 ffffffff81a0e020
 Call Trace:
  [<ffffffff813fc68a>] ? release_sock+0xb2/0xba
  [<ffffffff814ebc5a>] __mutex_lock_common+0x139/0x1a2
  [<ffffffff814ebcd7>] __mutex_lock_slowpath+0x14/0x16
  [<ffffffff814ebda5>] mutex_lock+0x1e/0x35
  [<ffffffff8120e1bf>] xfs_read+0x100/0x1f9
  [<ffffffff8120a574>] xfs_file_aio_read+0x58/0x5c
  [<ffffffff810d7dc4>] do_sync_read+0xc0/0x106
  [<ffffffff810d7dc4>] ? do_sync_read+0xc0/0x106
  [<ffffffff810d8813>] vfs_read+0xa8/0x102
  [<ffffffff810d88c9>] sys_pread64+0x5c/0x7d
  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
 mysqld        D 0000000000000000  5336  6888      1 0x00000000
  ffff88030d555cb8 0000000000000082 0000000000000000 ffffffff813fc68a
  ffff880671892d80 000000000000de78 ffff88030d555fd8 0000000000013c00
  ffff88030d555fd8 0000000000013c00 ffff88071109d3e0 ffff880939c9adc0
 Call Trace:
  [<ffffffff813fc68a>] ? release_sock+0xb2/0xba
  [<ffffffff814ebc5a>] __mutex_lock_common+0x139/0x1a2
  [<ffffffff814ebcd7>] __mutex_lock_slowpath+0x14/0x16
  [<ffffffff814ebda5>] mutex_lock+0x1e/0x35
  [<ffffffff8120e1bf>] xfs_read+0x100/0x1f9
  [<ffffffff8120a574>] xfs_file_aio_read+0x58/0x5c
  [<ffffffff810d7dc4>] do_sync_read+0xc0/0x106
  [<ffffffff810d7dc4>] ? do_sync_read+0xc0/0x106
  [<ffffffff810d8813>] vfs_read+0xa8/0x102
  [<ffffffff810d88c9>] sys_pread64+0x5c/0x7d
  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
 mysqld        D 0000000000000000  5336  6890      1 0x00000000
  ffff880690c15cb8 0000000000000082 0000000000000000 ffff8812116787d8
  ffff88095fc93c00 000000000000de78 ffff880690c15fd8 0000000000013c00
  ffff880690c15fd8 0000000000013c00 ffff8808b9585b80 ffffffff81a0e020
 Call Trace:
  [<ffffffff81027beb>] ? activate_task+0x28/0x31
  [<ffffffff814ebc5a>] __mutex_lock_common+0x139/0x1a2
  [<ffffffff814ebcd7>] __mutex_lock_slowpath+0x14/0x16
  [<ffffffff814ebda5>] mutex_lock+0x1e/0x35
  [<ffffffff8120e1bf>] xfs_read+0x100/0x1f9
  [<ffffffff8120a574>] xfs_file_aio_read+0x58/0x5c
  [<ffffffff810d7dc4>] do_sync_read+0xc0/0x106
  [<ffffffff810d7dc4>] ? do_sync_read+0xc0/0x106
  [<ffffffff810d8813>] vfs_read+0xa8/0x102
  [<ffffffff810d88c9>] sys_pread64+0x5c/0x7d
  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
 mysqld        D 0000000000000000  5312  6899      1 0x00000000
  ffff88090a091cb8 0000000000000082 0000000000000000 ffffffff813fc68a
  ffff88090a091c28 000000000000de78 ffff88090a091fd8 0000000000013c00
  ffff88090a091fd8 0000000000013c00 ffff88085196cc40 ffffffff81a0e020
 Call Trace:
  [<ffffffff813fc68a>] ? release_sock+0xb2/0xba
  [<ffffffff814ebc5a>] __mutex_lock_common+0x139/0x1a2
  [<ffffffff814ebcd7>] __mutex_lock_slowpath+0x14/0x16
  [<ffffffff814ebda5>] mutex_lock+0x1e/0x35
  [<ffffffff8120e1bf>] xfs_read+0x100/0x1f9
  [<ffffffff8120a574>] xfs_file_aio_read+0x58/0x5c
  [<ffffffff810d7dc4>] do_sync_read+0xc0/0x106
  [<ffffffff810d7dc4>] ? do_sync_read+0xc0/0x106
  [<ffffffff810d8813>] vfs_read+0xa8/0x102
  [<ffffffff810d88c9>] sys_pread64+0x5c/0x7d
  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
 tar4ibd       D 0000000000000000  4552  6721   6720 0x00000004
  ffff88016a7c3740 0000000000000086 0000000000000000 ffff88095fc13c00
  0000000000000001 000000000000de78 ffff88016a7c3fd8 0000000000013c00
  ffff88016a7c3fd8 0000000000013c00 ffff8806b39344a0 ffff881239d253e0
 Call Trace:
  [<ffffffff81034837>] ? wake_up_process+0x10/0x12
  [<ffffffff8124c328>] ? __rwsem_do_wake+0x80/0x152
  [<ffffffff814ec6ac>] rwsem_down_failed_common+0x96/0xc8
  [<ffffffff81244595>] ? cfq_close_cooperator+0xd9/0x184
  [<ffffffff814ec72e>] rwsem_down_read_failed+0x26/0x30
  [<ffffffff81250484>] call_rwsem_down_read_failed+0x14/0x30
  [<ffffffff814ec028>] ? down_read+0x1f/0x23
  [<ffffffff811ebd4e>] xfs_ilock+0x5d/0x94
  [<ffffffff811ebdae>] xfs_ilock_map_shared+0x29/0x2f
  [<ffffffff811f231b>] xfs_iomap+0x9f/0x39c
  [<ffffffff81239215>] ? __blk_run_queue+0x4a/0x70
  [<ffffffff81247a91>] ? cpumask_next_and+0x2b/0x3c
  [<ffffffff812065bd>] __xfs_get_blocks+0x71/0x15c
  [<ffffffff812066d1>] xfs_get_blocks+0x12/0x14
  [<ffffffff810fec23>] do_mpage_readpage+0x173/0x467
  [<ffffffff810b2234>] ? __inc_zone_page_state+0x25/0x27
  [<ffffffff8109fecc>] ? add_to_page_cache_locked+0x82/0xc6
  [<ffffffff810ff04a>] mpage_readpages+0xd6/0x11c
  [<ffffffff812066bf>] ? xfs_get_blocks+0x0/0x14
  [<ffffffff812066bf>] ? xfs_get_blocks+0x0/0x14
  [<ffffffff81207724>] xfs_vm_readpages+0x1a/0x1c
  [<ffffffff810a72c4>] __do_page_cache_readahead+0x10c/0x1a2
  [<ffffffff810a7376>] ra_submit+0x1c/0x20
  [<ffffffff810a7606>] ondemand_readahead+0x1b2/0x1c5
  [<ffffffff810a76f3>] page_cache_sync_readahead+0x38/0x3a
  [<ffffffff810a0e0c>] generic_file_aio_read+0x229/0x582
  [<ffffffff8120e262>] xfs_read+0x1a3/0x1f9
  [<ffffffff8120a574>] xfs_file_aio_read+0x58/0x5c
  [<ffffffff810d7dc4>] do_sync_read+0xc0/0x106
  [<ffffffff81032879>] ? finish_task_switch+0x43/0xac
  [<ffffffff810d8813>] vfs_read+0xa8/0x102
  [<ffffffff810d8931>] sys_read+0x47/0x70
  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
 sync          D 0000000000000000  4496  8295   8248 0x00000000
  ffff8805b78b1cd8 0000000000000086 0000000000000000 0000000000013c00
  ffff8809388acac0 000000000000de78 ffff8805b78b1fd8 0000000000013c00
  ffff8805b78b1fd8 0000000000013c00 ffff8801002dadc0 ffff881239d23d00
 Call Trace:
  [<ffffffff810519e4>] ? prepare_to_wait+0x70/0x7b
  [<ffffffff81207928>] xfs_ioend_wait+0x83/0x9b
  [<ffffffff810517ab>] ? autoremove_wake_function+0x0/0x38
  [<ffffffff8121071b>] ? xfs_sync_inode_valid+0x68/0x9a
  [<ffffffff81210aaa>] xfs_sync_inode_data+0x98/0xbf
  [<ffffffff81210bf0>] xfs_inode_ag_walk+0x95/0xd4
  [<ffffffff81210a12>] ? xfs_sync_inode_data+0x0/0xbf
  [<ffffffff8109fdac>] ? wait_on_page_bit+0x6e/0x75
  [<ffffffff81210c82>] xfs_inode_ag_iterator+0x53/0x81
  [<ffffffff81210a12>] ? xfs_sync_inode_data+0x0/0xbf
  [<ffffffff81210e49>] xfs_sync_data+0x26/0x4d
  [<ffffffff81210ebf>] xfs_quiesce_data+0x1e/0x57
  [<ffffffff8120e841>] xfs_fs_sync_fs+0x26/0xd7
  [<ffffffff8111a159>] ? vfs_quota_sync+0x196/0x1a7
  [<ffffffff8111ba70>] sync_quota_sb+0x4e/0xfc
  [<ffffffff810f5e64>] __sync_filesystem+0x41/0x72
  [<ffffffff810f5f37>] sync_filesystems+0xa2/0xee
  [<ffffffff810f5fd4>] sys_sync+0x1c/0x2e
  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b


-- 
Ilia Mirkin
imirkin@alum.mit.edu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
