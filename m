Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 21 Mar 2008 07:12:33 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2LEBwvs007695
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2008 07:12:01 -0700
Received: from mx1.wp.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2DCD66CEB5D
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2008 07:12:30 -0700 (PDT)
Received: from mx1.wp.pl (mx1.wp.pl [212.77.101.5]) by cuda.sgi.com with ESMTP id a4vHBfgVxfXhjPoE for <xfs@oss.sgi.com>; Fri, 21 Mar 2008 07:12:30 -0700 (PDT)
Received: from ip-83-238-22-2.netia.com.pl (HELO lapsg1.open-e.pl) (stf_xl@wp.pl@[83.238.22.2])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with AES128-SHA encrypted SMTP
          for <xfs@oss.sgi.com>; 21 Mar 2008 15:05:48 +0100
From: Stanislaw Gruszka <stf_xl@wp.pl>
Subject: BUG: xfs on linux lvm - lvconvert random hungs when doing i/o
Date: Fri, 21 Mar 2008 15:20:16 +0100
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803211520.16398.stf_xl@wp.pl>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hello

I have problems using xfs and lvm snapshots on linux-2.6.24 , When I do
lvconvert  to create snapshots and when system is under heavy load, lvconvert
and I/O processes randomly hung .  I use below script to reproduce, but it is very hard
to catch this bug.

<code>
#!/bin/bash
#set -x
DISK="physical_device" 

# clean old stuff
umount /mnt/tmp
for ((j = 0; j < 20; j++)) ; do
    echo -n "Remove $j "
    date
    umount /mnt/m$j
    lvremove -s -f /dev/VG/sn_$j
done
vgchange -a n
vgremove -f VG

# initialization
pvcreate  $DISK 2> /dev/null
vgcreate VG $DISK 2> /dev/null
vgchange -a y
lvcreate -L40G -n lv VG
mkdir -p /mnt/tmp
mkfs.xfs /dev/VG/lv
for ((j = 0; j < 20; j++)) do
    lvcreate -L512M -n /dev/VG/sn_${j} VG
    mkdir -p /mnt/m$j
done

# test
nloops=10
for ((loop = 0; loop < $nloops; loop++)) ;  do
    echo "loop $loop start ... "
    mount /dev/VG/lv /mnt/tmp

    dd if=/dev/urandom of=/mnt/tmp/file_tmp1 bs=1024  &
    load_pid1=$!
    dd if=/dev/urandom of=/mnt/tmp/file_tmp2 bs=1024  &
    load_pid2=$!

    for ((j = 0; j < 20; j++)) ; do
        echo -n "Convert $j "
        date
        lvconvert -s -c512 /dev/VG/lv /dev/VG/sn_$j
        sleep 10
        mount -t xfs -o nouuid,noatime /dev/VG/sn_$j /mnt/m$j
        sync
    done

    for ((j = 0; j < 20; j++)) ; do
        echo -n "Remove $j "
        date
        umount /mnt/m$j
        lvremove -s -f /dev/VG/sn_$j
    done

    kill $load_pid1
    wait $load_pid1
    kill $load_pid2
    wait $load_pid2

    umount /mnt/tmp
    echo "done"
done
</code>

Here is sysrq show-blocked-task output of such situation:

SysRq : HELP : loglevel0-8 reBoot Crashdump tErm Full kIll saK showMem Nice powerOff showPc show-all-timers(Q) unRaw Sync showTasks Unmount shoW-blocked-tasks 
SysRq : Show Blocked State
  task                PC stack   pid father
xfsdatad/1    D 00000000     0   288      2
       f7d1aa90 00000046 00000000 00000000 00000000 00000000 f68be900 c4018a80 
       ffffffff ea4906f8 f7d1aa90 f744bf0c c05558e6 ea490700 c4015d60 00000000 
       ea4906f8 00000004 ea490680 ea490680 c0555a2d ea490700 ea490700 f7d1aa90 
Call Trace:
 [<c05558e6>] rwsem_down_failed_common+0x76/0x170
 [<c0555a2d>] rwsem_down_write_failed+0x1d/0x24
 [<c0555aa2>] call_rwsem_down_write_failed+0x6/0x8
 [<c05555d2>] down_write+0x12/0x20
 [<c029906a>] xfs_ilock+0x5a/0xa0
 [<c02c0093>] xfs_setfilesize+0x43/0x130
 [<c02c0180>] xfs_end_bio_delalloc+0x0/0x20
 [<c02c018d>] xfs_end_bio_delalloc+0xd/0x20
 [<c01334d2>] run_workqueue+0x52/0x100
 [<c01373a2>] prepare_to_wait+0x52/0x70
 [<c01335ff>] worker_thread+0x7f/0xc0
 [<c01374a0>] autoremove_wake_function+0x0/0x50
 [<c01374a0>] autoremove_wake_function+0x0/0x50
 [<c0133580>] worker_thread+0x0/0xc0
 [<c0136f09>] kthread+0x59/0xa0
 [<c0136eb0>] kthread+0x0/0xa0
 [<c0104d47>] kernel_thread_helper+0x7/0x10
 =======================
pdflush       D 00fc61cb     0  7337      2
       edc37a90 00000046 f28f9ed8 00fc61cb f28f9ed8 00000282 f7c5de40 c4010a80 
       f28f9ed8 00fc61cb f28f9f2c 00000000 c0554fd7 00000000 00000002 c07443e4 
       c07443e4 00fc61cb c012ca40 edc37a90 c0743d80 00000246 c0137370 c4010a80 
Call Trace:
 [<c0554fd7>] schedule_timeout+0x47/0x90
 [<c012ca40>] process_timeout+0x0/0x10
 [<c0137370>] prepare_to_wait+0x20/0x70
 [<c0554f5b>] io_schedule_timeout+0x1b/0x30
 [<c0162ede>] congestion_wait+0x7e/0xa0
 [<c01374a0>] autoremove_wake_function+0x0/0x50
 [<c0196a71>] sync_sb_inodes+0x141/0x1d0
 [<c01374a0>] autoremove_wake_function+0x0/0x50
 [<c0196b87>] writeback_inodes+0x87/0xb0
 [<c015d463>] wb_kupdate+0xa3/0x100
 [<c015e139>] __pdflush+0xb9/0x170
 [<c015e1f0>] pdflush+0x0/0x30
 [<c015e218>] pdflush+0x28/0x30
 [<c015d3c0>] wb_kupdate+0x0/0x100
 [<c0136f09>] kthread+0x59/0xa0
 [<c0136eb0>] kthread+0x0/0xa0
 [<c0104d47>] kernel_thread_helper+0x7/0x10
 =======================
dd            D c4018ab4     0 12113  29734
       ee178a90 00000082 ebe70ac0 c4018ab4 00000001 f75a4440 f7d0ee40 c4010a80 
       f3951bc0 f3951bc8 00000246 ee178a90 c0555b35 00000001 ee178a90 c011eaa0 
       f3951bcc f3951bcc ee25b160 c04793c7 f3baed80 f3951bc0 00008000 00000000 
Call Trace:
 [<c0555b35>] __down+0x75/0xe0
 [<c011eaa0>] default_wake_function+0x0/0x10
 [<c04793c7>] dm_unplug_all+0x17/0x30
 [<c0555a3b>] __down_failed+0x7/0xc
 [<c02e1ac0>] blk_backing_dev_unplug+0x0/0x10
 [<c02c2e4c>] xfs_buf_lock+0x3c/0x50
 [<c02c27d1>] _xfs_buf_find+0x151/0x1d0
 [<c02bfe67>] kmem_zone_alloc+0x47/0xc0
 [<c03cd208>] ata_check_status+0x8/0x10
 [<c02c28a5>] xfs_buf_get_flags+0x55/0x130
 [<c02c299c>] xfs_buf_read_flags+0x1c/0x90
 [<c02b48cf>] xfs_trans_read_buf+0x16f/0x350
 [<c02995fd>] xfs_itobp+0x7d/0x250
 [<c0156ba8>] find_get_pages_tag+0x38/0x90
 [<c015d70d>] write_cache_pages+0x11d/0x330
 [<c029cfc9>] xfs_iflush+0x99/0x470
 [<c02bd907>] xfs_inode_flush+0x127/0x1f0
 [<c02c9732>] xfs_fs_write_inode+0x22/0x80
 [<c01963fb>] write_inode+0x4b/0x50
 [<c01966d0>] __sync_single_inode+0xf0/0x190
 [<c01967b9>] __writeback_single_inode+0x49/0x1c0
 [<c012c5ce>] del_timer_sync+0xe/0x20
 [<c02ef3e3>] prop_fraction_single+0x33/0x60
 [<c015cc56>] task_dirty_limit+0x46/0xd0
 [<c0196a0e>] sync_sb_inodes+0xde/0x1d0
 [<c015ce8a>] get_dirty_limits+0x13a/0x160
 [<c0196ba0>] writeback_inodes+0xa0/0xb0
 [<c015d043>] balance_dirty_pages+0x193/0x2c0
 [<c0158ad2>] generic_perform_write+0x142/0x190
 [<c0158ba7>] generic_file_buffered_write+0x87/0x150
 [<c02c8d0b>] xfs_write+0x61b/0x8c0
 [<c0128555>] __do_softirq+0x75/0xf0
 [<c011177a>] smp_apic_timer_interrupt+0x2a/0x40
 [<c0104bf4>] apic_timer_interrupt+0x28/0x30
 [<c02c45f6>] xfs_file_aio_write+0x76/0x90
 [<c0178e9d>] do_sync_write+0xbd/0x110
 [<c013bb80>] notify_die+0x30/0x40
 [<c01374a0>] autoremove_wake_function+0x0/0x50
 [<c013b827>] atomic_notifier_call_chain+0x17/0x20
 [<c013bb80>] notify_die+0x30/0x40
 [<c0179050>] vfs_write+0x160/0x170
 [<c0179111>] sys_write+0x41/0x70
 [<c010418e>] syscall_call+0x7/0xb
 =======================
lvconvert     D c4010a80     0 12930  12501
       ec09e030 00000082 00000000 c4010a80 ec09e030 ebe70a90 f7c5d580 c4010a80 
       7fffffff cbd43e38 cbd43de8 00000002 c055501c ec1ea98c 00000292 ec09e030 
       c011eb9a 00000000 00000292 c0555b8e 00000001 ec09e030 c011eaa0 7fffffff 
Call Trace:
 [<c055501c>] schedule_timeout+0x8c/0x90
 [<c011eb9a>] __wake_up_locked+0x1a/0x20
 [<c0555b8e>] __down+0xce/0xe0
 [<c011eaa0>] default_wake_function+0x0/0x10
 [<c0554ca9>] wait_for_common+0xa9/0x140
 [<c011eaa0>] default_wake_function+0x0/0x10
 [<c011eaa0>] default_wake_function+0x0/0x10
 [<c0133719>] flush_cpu_workqueue+0x69/0xa0
 [<c0133640>] wq_barrier_func+0x0/0x10
 [<c013377c>] flush_workqueue+0x2c/0x40
 [<c02c3fc7>] xfs_flush_buftarg+0x17/0x120
 [<c02b6f26>] xfs_quiesce_fs+0x16/0x70
 [<c02b6fa0>] xfs_attr_quiesce+0x20/0x60
 [<c02b8db8>] xfs_freeze+0x8/0x10
 [<c019a617>] freeze_bdev+0x77/0x80
 [<c0479deb>] lock_fs+0x1b/0x70
 [<c019ff50>] bdev_set+0x0/0x10
 [<c0479f43>] dm_suspend+0xc3/0x350
 [<c011eaa0>] default_wake_function+0x0/0x10
 [<c011eaa0>] default_wake_function+0x0/0x10
 [<c047d71a>] do_suspend+0x7a/0x90
 [<c047d870>] dev_suspend+0x0/0x20
 [<c047e3db>] ctl_ioctl+0xcb/0x130
 [<c018544a>] do_ioctl+0x6a/0xa0
 [<c018560e>] vfs_ioctl+0x5e/0x1d0
 [<c01857f0>] sys_ioctl+0x70/0x80
 [<c010418e>] syscall_call+0x7/0xb
 =======================
dd            D 00fc61cb     0 12953  29684
       f7c92a90 00000082 e99a7c70 00fc61cb e99a7c70 00000286 f69b9580 c4018a80 
       e99a7c70 00fc61cb e99a7cc4 00000010 c0554fd7 00008000 c0748e44 f7c6a664 
       f7c6a664 00fc61cb c012ca40 f7c92a90 f7c6a000 00000246 c0137370 c4018a80 
Call Trace:
 [<c0554fd7>] schedule_timeout+0x47/0x90
 [<c012ca40>] process_timeout+0x0/0x10
 [<c0137370>] prepare_to_wait+0x20/0x70
 [<c0554f5b>] io_schedule_timeout+0x1b/0x30
 [<c0162ede>] congestion_wait+0x7e/0xa0
 [<c01374a0>] autoremove_wake_function+0x0/0x50
 [<c015ce8a>] get_dirty_limits+0x13a/0x160
 [<c01374a0>] autoremove_wake_function+0x0/0x50
 [<c015cf70>] balance_dirty_pages+0xc0/0x2c0
 [<c0158ad2>] generic_perform_write+0x142/0x190
 [<c0158ba7>] generic_file_buffered_write+0x87/0x150
 [<c02c8d0b>] xfs_write+0x61b/0x8c0
 [<c02df03d>] elv_next_request+0x7d/0x150
 [<c03abbde>] scsi_dispatch_cmd+0x15e/0x290
 [<c02c45f6>] xfs_file_aio_write+0x76/0x90
 [<c0178e9d>] do_sync_write+0xbd/0x110
 [<c01374a0>] autoremove_wake_function+0x0/0x50
 [<c012c740>] run_timer_softirq+0x30/0x180
 [<c014037f>] tick_do_periodic_broadcast+0x1f/0x30
 [<c013bb80>] notify_die+0x30/0x40
 [<c014039d>] tick_handle_periodic_broadcast+0xd/0x50
 [<c0179050>] vfs_write+0x160/0x170
 [<c0179111>] sys_write+0x41/0x70
 [<c010418e>] syscall_call+0x7/0xb
 =======================

I have also full memory dump of hung situation, so I could provide some interesting
variables values (xfs_buf, xfs_inode) if you want.  Please tell me if you eventually 
want some other info like linux .config etc. .  Currently I try to reproduce bug with
CONFIG_XFS_DEBUG and CONFIG_XFS_TRACE options and with such tracing options: 

#define XFS_ALLOC_TRACE 0
#define XFS_ATTR_TRACE 0
#define XFS_BLI_TRACE 0
#define XFS_BMAP_TRACE 0
#define XFS_BMBT_TRACE 0
#define XFS_DIR2_TRACE 0
#define XFS_DQUOT_TRACE 0
#define XFS_ILOCK_TRACE 1
#define XFS_LOG_TRACE 0
#define XFS_RW_TRACE 1
#define XFS_BUF_TRACE 1
#define XFS_VNODE_TRACE 0
#define XFS_FILESTREAMS_TRACE 0

I hope I would provide more valuable information soon to fix this problem.

I also would like to ask if you have some propositions how to reproduce bug,
because my scripts need to work few hours or even days to hung processes.

Regards
Stanislaw Gruszka
