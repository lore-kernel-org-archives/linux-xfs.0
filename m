Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from smtp1.onthe.net.au ([203.22.196.249]:33653 "EHLO
        smtp1.onthe.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754956AbeAMP3S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 13 Jan 2018 10:29:18 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 3D6A060C96
        for <linux-xfs@vger.kernel.org>; Sun, 14 Jan 2018 02:22:03 +1100 (EST)
Received: from smtp1.onthe.net.au ([127.0.0.1])
        by localhost (smtp1.onthe.net.au [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id yFVcxuTtJWkd for <linux-xfs@vger.kernel.org>;
        Sun, 14 Jan 2018 02:22:02 +1100 (EST)
Received: from hestia.private.onthe.net.au (hestia-gw1-vpn.private.onthe.net.au [10.9.1.6])
        by smtp1.onthe.net.au (Postfix) with ESMTP id CB6F760BA6
        for <linux-xfs@vger.kernel.org>; Sun, 14 Jan 2018 02:22:00 +1100 (EST)
Date: Sun, 14 Jan 2018 01:52:28 +1100
From: Chris Dunlop <chris@onthe.net.au>
Subject: _xfs_buf_find: Block out of range, then umount hung
Message-ID: <20180113145228.GA16780@onthe.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi,

tl;dr: a filesystem corruption (cause unknown) has produced an unkillable 
umount. Is the only recourse to reboot?

On linux-4.9.76, I had this error crop up:

Jan 13 19:57:31 b2 kernel: XFS (sdp1): _xfs_buf_find: Block out of range: block 0x837940948, EOFS 0x6f281288
Jan 13 19:57:31 b2 kernel: ------------[ cut here ]------------
Jan 13 19:57:31 b2 kernel: WARNING: CPU: 5 PID: 31412 at /home2/chris/git/linux/fs/xfs/xfs_buf.c:535 _xfs_buf_find+0x2ff/0x370 [xfs]
Jan 13 19:57:31 b2 kernel: Modules linked in: nfsd auth_rpcgss oid_registry nfs_acl nfs lockd grace sunrpc ipt_REJECT nf_reject_ipv4 xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_recent xt_multiport iptable_filter ip_tables x_tables iTCO_wdt iTCO_vendor_support intel_powerclamp coretemp kvm_intel kvm irqbypass lpc_ich mfd_core xfs ipmi_ssif i7core_edac edac_core ioatdma shpchp evdev 8250 8250_base serial_core ipmi_si ipmi_msghandler button acpi_cpufreq processor loop fuse autofs4 ext4 crc16 jbd2 mbcache dm_mod bridge stp llc raid456 async_raid6_recov async_memcpy async_pq async_xor xor async_tx raid6_pq raid1 md_mod ses enclosure sg sd_mod hid_generic usbhid hid bnx2x mpt3sas mdio libcrc32c raid_class crc32c_generic ehci_pci psmouse crc32c_intel igb scsi_transport_sas i2c_algo_bit uhci_hcd
Jan 13 19:57:31 b2 kernel:  ehci_hcd i2c_core scsi_mod dca ptp pps_core
Jan 13 19:57:31 b2 kernel: CPU: 5 PID: 31412 Comm: tp_fstore_op Not tainted 4.9.76-otn-00021-g2af03421 #1
Jan 13 19:57:31 b2 kernel: Hardware name: Supermicro X8DTH-i/6/iF/6F/X8DTH, BIOS 2.1a       12/12/11
Jan 13 19:57:31 b2 kernel:  ffffc900418e3718 ffffffff812a91bb 0000000000000000 0000000000000000
Jan 13 19:57:31 b2 kernel:  ffffc900418e3758 ffffffff8105ab31 00000217418e3778 ffff8817c62cdc00
Jan 13 19:57:31 b2 kernel:  0000000000000008 ffff8817c62cdc00 ffffc900418e3848 0000000000000000
Jan 13 19:57:31 b2 kernel: Call Trace:
Jan 13 19:57:31 b2 kernel:  [<ffffffff812a91bb>] dump_stack+0x4d/0x72
Jan 13 19:57:31 b2 kernel:  [<ffffffff8105ab31>] __warn+0xd1/0xf0
Jan 13 19:57:31 b2 kernel:  [<ffffffff8105ac1d>] warn_slowpath_null+0x1d/0x20
Jan 13 19:57:31 b2 kernel:  [<ffffffffa0746e6f>] _xfs_buf_find+0x2ff/0x370 [xfs]
Jan 13 19:57:31 b2 kernel:  [<ffffffffa06f6824>] ? xfs_alloc_update_counters.isra.13+0x44/0x50 [xfs]
Jan 13 19:57:31 b2 kernel:  [<ffffffffa0746f0a>] xfs_buf_get_map+0x2a/0x2f0 [xfs]
Jan 13 19:57:31 b2 kernel:  [<ffffffffa06f6c12>] ? xfs_free_ag_extent+0x3e2/0x7b0 [xfs]
Jan 13 19:57:31 b2 kernel:  [<ffffffffa077c7a6>] xfs_trans_get_buf_map+0x126/0x1d0 [xfs]
Jan 13 19:57:31 b2 kernel:  [<ffffffffa07121ff>] xfs_btree_get_bufs+0x4f/0x60 [xfs]
Jan 13 19:57:31 b2 kernel:  [<ffffffffa06f8fa7>] xfs_alloc_fix_freelist+0x1c7/0x390 [xfs]
Jan 13 19:57:31 b2 kernel:  [<ffffffff8108b46f>] ? sched_clock_cpu+0x8f/0xa0
Jan 13 19:57:31 b2 kernel:  [<ffffffffa06f98e5>] xfs_free_extent_fix_freelist+0x65/0xa0 [xfs]
Jan 13 19:57:31 b2 kernel:  [<ffffffffa06f996b>] xfs_free_extent+0x4b/0x120 [xfs]
Jan 13 19:57:31 b2 kernel:  [<ffffffff811b63e3>] ? kmem_cache_alloc+0x1a3/0x1b0
Jan 13 19:57:31 b2 kernel:  [<ffffffffa077d5ae>] xfs_trans_free_extent+0x6e/0x130 [xfs]
Jan 13 19:57:31 b2 kernel:  [<ffffffffa077d696>] xfs_extent_free_finish_item+0x26/0x40 [xfs]
Jan 13 19:57:31 b2 kernel:  [<ffffffffa071dbdc>] xfs_defer_finish+0x16c/0x430 [xfs]
Jan 13 19:57:31 b2 kernel:  [<ffffffffa06fb0c4>] xfs_attr_leaf_addname+0x3e4/0x400 [xfs]
Jan 13 19:57:31 b2 kernel:  [<ffffffffa06fb975>] xfs_attr_set+0x245/0x3f0 [xfs]
Jan 13 19:57:31 b2 kernel:  [<ffffffffa07696a2>] xfs_xattr_set+0x52/0xa0 [xfs]
Jan 13 19:57:31 b2 kernel:  [<ffffffff811fdb8b>] __vfs_setxattr+0x6b/0x90
Jan 13 19:57:31 b2 kernel:  [<ffffffff811fe5d1>] __vfs_setxattr_noperm+0x51/0xe0
Jan 13 19:57:31 b2 kernel:  [<ffffffff811fe707>] vfs_setxattr+0xa7/0xb0
Jan 13 19:57:31 b2 kernel:  [<ffffffff811fe83d>] setxattr+0x12d/0x150
Jan 13 19:57:31 b2 kernel:  [<ffffffff811f9408>] ? mnt_want_write_file+0x28/0x60
Jan 13 19:57:31 b2 kernel:  [<ffffffff811d914e>] ? __sb_start_write+0xee/0x1a0
Jan 13 19:57:31 b2 kernel:  [<ffffffff811f9408>] ? mnt_want_write_file+0x28/0x60
Jan 13 19:57:31 b2 kernel:  [<ffffffff811f58d5>] ? __fget+0x5/0xe0
Jan 13 19:57:31 b2 kernel:  [<ffffffff811feaed>] SyS_fsetxattr+0x7d/0xa0
Jan 13 19:57:31 b2 kernel:  [<ffffffff814ed0e0>] entry_SYSCALL_64_fastpath+0x13/0x99
Jan 13 19:57:31 b2 kernel: ---[ end trace 144423dbd5ec0057 ]---

That whole lot repeated again (same call trace), then:

Jan 13 19:57:31 b2 kernel: XFS (sdp1): xfs_do_force_shutdown(0x8) called from line 236 of file /home2/chris/git/linux/fs/xfs/libxfs/xfs_defer.c.  Return address = 0xffffffffa071d787
Jan 13 19:57:31 b2 kernel: XFS (sdp1): Corruption of in-memory data detected.  Shutting down filesystem
Jan 13 19:57:31 b2 kernel: XFS (sdp1): Please umount the filesystem and rectify the problem(s)
Jan 13 19:57:31 b2 kernel:
Jan 13 19:57:31 b2 kernel: ================================================
Jan 13 19:57:31 b2 kernel: [ BUG: lock held when returning to user space! ]
Jan 13 19:57:31 b2 kernel: 4.9.76-otn-00021-g2af03421 #1 Tainted: G        W
Jan 13 19:57:31 b2 kernel: ------------------------------------------------
Jan 13 19:57:31 b2 kernel: tp_fstore_op/31412 is leaving the kernel with locks still held!
Jan 13 19:57:31 b2 kernel: 1 lock held by tp_fstore_op/31412:
Jan 13 19:57:31 b2 kernel:  #0:  (sb_internal){......}, at: [<ffffffffa07692a3>] xfs_trans_alloc+0xe3/0x130 [xfs]

I tried umounting, and the fs has disappeared from /etc/mtab, but my umount 
went into an unkillable hang (been sitting there for 90m+):

# ps -olstart,pid,time,stat,wchan='WCHAN-xxxxxxxxxxxxxxxxxx',cmd -C umount
                 STARTED   PID     TIME STAT WCHAN-xxxxxxxxxxxxxxxxxx CMD
Sat Jan 13 23:28:58 2018 30518 00:00:00 D+   xfs_ail_push_all_sync    umount /var/lib/ceph/osd/ceph-60

...and this popped up in the log:

Jan 13 23:29:00 b2 kernel: XFS (sdp1): Unmounting Filesystem
Jan 13 23:29:37 b2 kernel: INFO: task umount:30518 blocked for more than 30 seconds.
Jan 13 23:29:37 b2 kernel:       Tainted: G        W       4.9.76-otn-00021-g2af03421 #1
Jan 13 23:29:37 b2 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 13 23:29:37 b2 kernel: umount          D    0 30518  31666 0x00000000
Jan 13 23:29:37 b2 kernel:  ffff8817b5cf6e00 ffff882fdebd7498 ffff880c75b19800 ffff882fdebd7480
Jan 13 23:29:37 b2 kernel:  ffff882fd2133000 ffffc900456dbd40 ffffffff814e694e 00000008c9e0dda8
Jan 13 23:29:37 b2 kernel:  0000000000000282 ffff882fdebd7498 00000000a077bb85 ffff880c75b19800
Jan 13 23:29:37 b2 kernel: Call Trace:
Jan 13 23:29:37 b2 kernel:  [<ffffffff814e694e>] ? __schedule+0x1de/0x7c0
Jan 13 23:29:37 b2 kernel:  [<ffffffff814e6f66>] schedule+0x36/0x80
Jan 13 23:29:37 b2 kernel:  [<ffffffffa077bb8a>] xfs_ail_push_all_sync+0xaa/0xf0 [xfs]
Jan 13 23:29:37 b2 kernel:  [<ffffffff810a07f0>] ? wake_up_atomic_t+0x30/0x30
Jan 13 23:29:37 b2 kernel:  [<ffffffffa07608d9>] xfs_unmountfs+0x99/0x1e0 [xfs]
Jan 13 23:29:37 b2 kernel:  [<ffffffffa0765af2>] xfs_fs_put_super+0x32/0x90 [xfs]
Jan 13 23:29:37 b2 kernel:  [<ffffffff811d84af>] generic_shutdown_super+0x6f/0x100
Jan 13 23:29:37 b2 kernel:  [<ffffffff811d8827>] kill_block_super+0x27/0x70
Jan 13 23:29:37 b2 kernel:  [<ffffffff811d89ce>] deactivate_locked_super+0x3e/0x70
Jan 13 23:29:37 b2 kernel:  [<ffffffff811d8eec>] deactivate_super+0x5c/0x60
Jan 13 23:29:37 b2 kernel:  [<ffffffff811f7aef>] cleanup_mnt+0x3f/0x90
Jan 13 23:29:37 b2 kernel:  [<ffffffff811f7b82>] __cleanup_mnt+0x12/0x20
Jan 13 23:29:37 b2 kernel:  [<ffffffff81078cfe>] task_work_run+0x7e/0xa0
Jan 13 23:29:37 b2 kernel:  [<ffffffff810014e1>] exit_to_usermode_loop+0xb1/0xc0
Jan 13 23:29:37 b2 kernel:  [<ffffffff81001966>] syscall_return_slowpath+0x86/0x100
Jan 13 23:29:37 b2 kernel:  [<ffffffff814ed164>] entry_SYSCALL_64_fastpath+0x97/0x99

The filesystem is on:

brw-rw---- 1 root disk 8, 241 2018-01-13 13:31 /dev/sdp1

I ran a trace-cmd and extracted that device:

# trace-cmd record -e xfs_ail\* & sleep 10; kill -2 $!
# trace-cmd report | grep 'dev 8:241 ' > trace.txt
# head -n 20 trace.txt
    xfsaild/sdp1-9351  [002] 42146.476734: xfs_ail_locked:       dev 8:241 lip 0x0xffff88187855fd10 lsn 1255/554090 type XFS_LI_BUF flags IN_AIL
    xfsaild/sdp1-9351  [002] 42146.476744: xfs_ail_locked:       dev 8:241 lip 0x0xffff881879217e08 lsn 1255/554090 type XFS_LI_BUF flags IN_AIL
    xfsaild/sdp1-9351  [002] 42146.476745: xfs_ail_pinned:       dev 8:241 lip 0x0xffff88188e7cabe0 lsn 1255/554090 type XFS_LI_EFI flags IN_AIL
    xfsaild/sdp1-9351  [002] 42146.476746: xfs_ail_locked:       dev 8:241 lip 0x0xffff882468f61a28 lsn 1255/554090 type XFS_LI_BUF flags IN_AIL
    xfsaild/sdp1-9351  [002] 42146.476747: xfs_ail_locked:       dev 8:241 lip 0x0xffff8818c512c4d8 lsn 1255/554090 type XFS_LI_BUF flags IN_AIL
    xfsaild/sdp1-9351  [002] 42146.536737: xfs_ail_locked:       dev 8:241 lip 0x0xffff88187855fd10 lsn 1255/554090 type XFS_LI_BUF flags IN_AIL
    xfsaild/sdp1-9351  [002] 42146.536740: xfs_ail_locked:       dev 8:241 lip 0x0xffff881879217e08 lsn 1255/554090 type XFS_LI_BUF flags IN_AIL
    xfsaild/sdp1-9351  [002] 42146.536740: xfs_ail_pinned:       dev 8:241 lip 0x0xffff88188e7cabe0 lsn 1255/554090 type XFS_LI_EFI flags IN_AIL
    xfsaild/sdp1-9351  [002] 42146.536741: xfs_ail_locked:       dev 8:241 lip 0x0xffff882468f61a28 lsn 1255/554090 type XFS_LI_BUF flags IN_AIL
    xfsaild/sdp1-9351  [002] 42146.536742: xfs_ail_locked:       dev 8:241 lip 0x0xffff8818c512c4d8 lsn 1255/554090 type XFS_LI_BUF flags IN_AIL
    xfsaild/sdp1-9351  [002] 42146.596834: xfs_ail_locked:       dev 8:241 lip 0x0xffff88187855fd10 lsn 1255/554090 type XFS_LI_BUF flags IN_AIL
    xfsaild/sdp1-9351  [002] 42146.596836: xfs_ail_locked:       dev 8:241 lip 0x0xffff881879217e08 lsn 1255/554090 type XFS_LI_BUF flags IN_AIL
    xfsaild/sdp1-9351  [002] 42146.596837: xfs_ail_pinned:       dev 8:241 lip 0x0xffff88188e7cabe0 lsn 1255/554090 type XFS_LI_EFI flags IN_AIL
    xfsaild/sdp1-9351  [002] 42146.596838: xfs_ail_locked:       dev 8:241 lip 0x0xffff882468f61a28 lsn 1255/554090 type XFS_LI_BUF flags IN_AIL
    xfsaild/sdp1-9351  [002] 42146.596838: xfs_ail_locked:       dev 8:241 lip 0x0xffff8818c512c4d8 lsn 1255/554090 type XFS_LI_BUF flags IN_AIL
    xfsaild/sdp1-9351  [002] 42146.656840: xfs_ail_locked:       dev 8:241 lip 0x0xffff88187855fd10 lsn 1255/554090 type XFS_LI_BUF flags IN_AIL
    xfsaild/sdp1-9351  [002] 42146.656841: xfs_ail_locked:       dev 8:241 lip 0x0xffff881879217e08 lsn 1255/554090 type XFS_LI_BUF flags IN_AIL
    xfsaild/sdp1-9351  [002] 42146.656842: xfs_ail_pinned:       dev 8:241 lip 0x0xffff88188e7cabe0 lsn 1255/554090 type XFS_LI_EFI flags IN_AIL
    xfsaild/sdp1-9351  [002] 42146.656843: xfs_ail_locked:       dev 8:241 lip 0x0xffff882468f61a28 lsn 1255/554090 type XFS_LI_BUF flags IN_AIL
    xfsaild/sdp1-9351  [002] 42146.656844: xfs_ail_locked:       dev 8:241 lip 0x0xffff8818c512c4d8 lsn 1255/554090 type XFS_LI_BUF flags IN_AIL

The entire trace.txt is 345 lines, but if I remove the timestamp there are far 
fewer unique lines:

# sed -r 's/ [0-9]+\.[0-9]+:/ /' trace.txt | sort | uniq -c | sort -n
      4     xfsaild/sdp1-9351  [001]  xfs_ail_locked:       dev 8:241 lip 0x0xffff88187855fd10 lsn 1255/554090 type XFS_LI_BUF flags IN_AIL
      4     xfsaild/sdp1-9351  [001]  xfs_ail_locked:       dev 8:241 lip 0x0xffff881879217e08 lsn 1255/554090 type XFS_LI_BUF flags IN_AIL
      4     xfsaild/sdp1-9351  [001]  xfs_ail_locked:       dev 8:241 lip 0x0xffff8818c512c4d8 lsn 1255/554090 type XFS_LI_BUF flags IN_AIL
      4     xfsaild/sdp1-9351  [001]  xfs_ail_locked:       dev 8:241 lip 0x0xffff882468f61a28 lsn 1255/554090 type XFS_LI_BUF flags IN_AIL
      4     xfsaild/sdp1-9351  [001]  xfs_ail_pinned:       dev 8:241 lip 0x0xffff88188e7cabe0 lsn 1255/554090 type XFS_LI_EFI flags IN_AIL
      5     xfsaild/sdp1-9351  [002]  xfs_ail_locked:       dev 8:241 lip 0x0xffff88187855fd10 lsn 1255/554090 type XFS_LI_BUF flags IN_AIL
      5     xfsaild/sdp1-9351  [002]  xfs_ail_locked:       dev 8:241 lip 0x0xffff881879217e08 lsn 1255/554090 type XFS_LI_BUF flags IN_AIL
      5     xfsaild/sdp1-9351  [002]  xfs_ail_locked:       dev 8:241 lip 0x0xffff8818c512c4d8 lsn 1255/554090 type XFS_LI_BUF flags IN_AIL
      5     xfsaild/sdp1-9351  [002]  xfs_ail_locked:       dev 8:241 lip 0x0xffff882468f61a28 lsn 1255/554090 type XFS_LI_BUF flags IN_AIL
      5     xfsaild/sdp1-9351  [002]  xfs_ail_pinned:       dev 8:241 lip 0x0xffff88188e7cabe0 lsn 1255/554090 type XFS_LI_EFI flags IN_AIL
      5     xfsaild/sdp1-9351  [010]  xfs_ail_locked:       dev 8:241 lip 0x0xffff88187855fd10 lsn 1255/554090 type XFS_LI_BUF flags IN_AIL
      5     xfsaild/sdp1-9351  [010]  xfs_ail_locked:       dev 8:241 lip 0x0xffff881879217e08 lsn 1255/554090 type XFS_LI_BUF flags IN_AIL
      5     xfsaild/sdp1-9351  [010]  xfs_ail_locked:       dev 8:241 lip 0x0xffff8818c512c4d8 lsn 1255/554090 type XFS_LI_BUF flags IN_AIL
      5     xfsaild/sdp1-9351  [010]  xfs_ail_locked:       dev 8:241 lip 0x0xffff882468f61a28 lsn 1255/554090 type XFS_LI_BUF flags IN_AIL
      5     xfsaild/sdp1-9351  [010]  xfs_ail_pinned:       dev 8:241 lip 0x0xffff88188e7cabe0 lsn 1255/554090 type XFS_LI_EFI flags IN_AIL
      7     xfsaild/sdp1-9351  [000]  xfs_ail_locked:       dev 8:241 lip 0x0xffff88187855fd10 lsn 1255/554090 type XFS_LI_BUF flags IN_AIL
      7     xfsaild/sdp1-9351  [000]  xfs_ail_locked:       dev 8:241 lip 0x0xffff881879217e08 lsn 1255/554090 type XFS_LI_BUF flags IN_AIL
      7     xfsaild/sdp1-9351  [000]  xfs_ail_locked:       dev 8:241 lip 0x0xffff8818c512c4d8 lsn 1255/554090 type XFS_LI_BUF flags IN_AIL
      7     xfsaild/sdp1-9351  [000]  xfs_ail_locked:       dev 8:241 lip 0x0xffff882468f61a28 lsn 1255/554090 type XFS_LI_BUF flags IN_AIL
      7     xfsaild/sdp1-9351  [000]  xfs_ail_pinned:       dev 8:241 lip 0x0xffff88188e7cabe0 lsn 1255/554090 type XFS_LI_EFI flags IN_AIL
      8     xfsaild/sdp1-9351  [011]  xfs_ail_locked:       dev 8:241 lip 0x0xffff88187855fd10 lsn 1255/554090 type XFS_LI_BUF flags IN_AIL
      8     xfsaild/sdp1-9351  [011]  xfs_ail_locked:       dev 8:241 lip 0x0xffff881879217e08 lsn 1255/554090 type XFS_LI_BUF flags IN_AIL
      8     xfsaild/sdp1-9351  [011]  xfs_ail_locked:       dev 8:241 lip 0x0xffff8818c512c4d8 lsn 1255/554090 type XFS_LI_BUF flags IN_AIL
      8     xfsaild/sdp1-9351  [011]  xfs_ail_locked:       dev 8:241 lip 0x0xffff882468f61a28 lsn 1255/554090 type XFS_LI_BUF flags IN_AIL
      8     xfsaild/sdp1-9351  [011]  xfs_ail_pinned:       dev 8:241 lip 0x0xffff88188e7cabe0 lsn 1255/554090 type XFS_LI_EFI flags IN_AIL
      9     xfsaild/sdp1-9351  [003]  xfs_ail_locked:       dev 8:241 lip 0x0xffff88187855fd10 lsn 1255/554090 type XFS_LI_BUF flags IN_AIL
      9     xfsaild/sdp1-9351  [003]  xfs_ail_locked:       dev 8:241 lip 0x0xffff881879217e08 lsn 1255/554090 type XFS_LI_BUF flags IN_AIL
      9     xfsaild/sdp1-9351  [003]  xfs_ail_locked:       dev 8:241 lip 0x0xffff8818c512c4d8 lsn 1255/554090 type XFS_LI_BUF flags IN_AIL
      9     xfsaild/sdp1-9351  [003]  xfs_ail_locked:       dev 8:241 lip 0x0xffff882468f61a28 lsn 1255/554090 type XFS_LI_BUF flags IN_AIL
      9     xfsaild/sdp1-9351  [003]  xfs_ail_pinned:       dev 8:241 lip 0x0xffff88188e7cabe0 lsn 1255/554090 type XFS_LI_EFI flags IN_AIL
     15     xfsaild/sdp1-9351  [009]  xfs_ail_locked:       dev 8:241 lip 0x0xffff88187855fd10 lsn 1255/554090 type XFS_LI_BUF flags IN_AIL
     15     xfsaild/sdp1-9351  [009]  xfs_ail_locked:       dev 8:241 lip 0x0xffff881879217e08 lsn 1255/554090 type XFS_LI_BUF flags IN_AIL
     15     xfsaild/sdp1-9351  [009]  xfs_ail_locked:       dev 8:241 lip 0x0xffff8818c512c4d8 lsn 1255/554090 type XFS_LI_BUF flags IN_AIL
     15     xfsaild/sdp1-9351  [009]  xfs_ail_locked:       dev 8:241 lip 0x0xffff882468f61a28 lsn 1255/554090 type XFS_LI_BUF flags IN_AIL
     15     xfsaild/sdp1-9351  [009]  xfs_ail_pinned:       dev 8:241 lip 0x0xffff88188e7cabe0 lsn 1255/554090 type XFS_LI_EFI flags IN_AIL
     16     xfsaild/sdp1-9351  [008]  xfs_ail_locked:       dev 8:241 lip 0x0xffff88187855fd10 lsn 1255/554090 type XFS_LI_BUF flags IN_AIL
     16     xfsaild/sdp1-9351  [008]  xfs_ail_locked:       dev 8:241 lip 0x0xffff881879217e08 lsn 1255/554090 type XFS_LI_BUF flags IN_AIL
     16     xfsaild/sdp1-9351  [008]  xfs_ail_locked:       dev 8:241 lip 0x0xffff8818c512c4d8 lsn 1255/554090 type XFS_LI_BUF flags IN_AIL
     16     xfsaild/sdp1-9351  [008]  xfs_ail_locked:       dev 8:241 lip 0x0xffff882468f61a28 lsn 1255/554090 type XFS_LI_BUF flags IN_AIL
     16     xfsaild/sdp1-9351  [008]  xfs_ail_pinned:       dev 8:241 lip 0x0xffff88188e7cabe0 lsn 1255/554090 type XFS_LI_EFI flags IN_AIL


Cheers,

Chris
