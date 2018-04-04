Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:53178 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752461AbeDDXNG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 4 Apr 2018 19:13:06 -0400
Date: Thu, 5 Apr 2018 07:12:52 +0800
From: Ming Lei <ming.lei@redhat.com>
Subject: V4.16+ kernel warning when running xfs/006
Message-ID: <20180404231246.GA12299@ming.t460p>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Mike Snitzer <snitzer@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, dm-devel@redhat.com

Hi,

The following warning is triggered when running xfs/006 with
v4.16+(the latest linus tree):


[ 4406.277765] run fstests xfs/006 at 2018-04-04 19:18:32
[ 4408.437679] XFS (dm-0): Mounting V5 Filesystem
[ 4408.457115] XFS (dm-0): Ending clean mount
[ 4430.340609] ------------[ cut here ]------------
[ 4430.341255] DEBUG_LOCKS_WARN_ON(sem->owner != get_current())
[ 4430.341275] WARNING: CPU: 1 PID: 10562 at kernel/locking/rwsem.c:133 up_write+0xd4/0x14c
[ 4430.342821] Modules linked in: btrfs xor zstd_decompress zstd_compress xxhash raid6_pq dm_thin_pool dm_persistent_data dm_bio_prison scsi_debug dm_snapshot dm_bufio dm_flakey xfs libcrc32c isofs iTCO_wdt iTCO_vendor_support i2c_i801 i2c_core lpc_ich mfd_core ip_tables sr_mod cdrom sd_mod usb_storage ahci nvme libahci crc32c_intel virtio_scsi nvme_core libata qemu_fw_cfg dm_mirror dm_region_hash dm_log dm_mod
[ 4430.346899] CPU: 1 PID: 10562 Comm: dmsetup Tainted: G        W        4.16.0_17dec0a94915_master+ #1
[ 4430.347924] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-2.fc27 04/01/2014
[ 4430.348875] RIP: 0010:up_write+0xd4/0x14c
[ 4430.349330] RSP: 0018:ffff8800103af730 EFLAGS: 00010282
[ 4430.349926] RAX: 0000000000000000 RBX: ffff880059eb4c00 RCX: 0000000000000000
[ 4430.350730] RDX: ffffed0002075e9b RSI: 0000000000000003 RDI: ffffed0002075ec3
[ 4430.351523] RBP: 1ffff10002075ee6 R08: dffffc0000000000 R09: 0000000000000001
[ 4430.352321] R10: ffffed000f726a09 R11: fffffbfff0565454 R12: 1ffff10002075efb
[ 4430.353120] R13: ffff880059eb4c68 R14: ffff880059eb4908 R15: ffffffff8148cb7f
[ 4430.353925] FS:  00007f204c389840(0000) GS:ffff88005c600000(0000) knlGS:0000000000000000
[ 4430.354834] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4430.355474] CR2: 00007f204b457830 CR3: 000000007d4b4001 CR4: 00000000007606e0
[ 4430.356288] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 4430.357086] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 4430.357889] PKRU: 55555554
[ 4430.358201] Call Trace:
[ 4430.358489]  ? up_read+0x89/0x89
[ 4430.358875]  ? __queue_delayed_work+0x16a/0x1a1
[ 4430.359401]  percpu_up_write+0x9d/0xcc
[ 4430.359836]  ? __percpu_up_read+0x3e/0x3e
[ 4430.360304]  thaw_super+0x114/0x157
[ 4430.360710]  thaw_bdev+0x83/0xbb
[ 4430.361093]  ? unlock_fs+0x45/0x74 [dm_mod]
[ 4430.361578]  unlock_fs+0x54/0x74 [dm_mod]
[ 4430.362047]  __dm_resume.part.12+0x3a/0x3e [dm_mod]
[ 4430.362606]  dm_resume+0x113/0x133 [dm_mod]
[ 4430.363092]  ? dm_suspended_md+0x15/0x24 [dm_mod]
[ 4430.363632]  dev_suspend+0x1c2/0x230 [dm_mod]
[ 4430.364143]  ctl_ioctl+0x529/0x669 [dm_mod]
[ 4430.364627]  ? retrieve_status+0x2d1/0x2d1 [dm_mod]
[ 4430.365194]  ? free_params+0x2d/0x2d [dm_mod]
[ 4430.365692]  ? wake_up_q+0x11/0x73
[ 4430.366115]  ? kasan_unpoison_shadow+0xf/0x2e
[ 4430.366651]  ? semctl_main+0xa54/0xac2
[ 4430.367112]  ? do_smart_update+0x1f6/0x1f6
[ 4430.367583]  ? pvclock_read_flags+0x37/0x37
[ 4430.368089]  ? lock_acquire+0x32d/0x32d
[ 4430.368542]  dm_ctl_ioctl+0xa/0xd [dm_mod]
[ 4430.369010]  vfs_ioctl+0x4c/0x5f
[ 4430.369384]  do_vfs_ioctl+0x93e/0x989
[ 4430.369807]  ? do_raw_spin_trylock+0x115/0x115
[ 4430.370309]  ? ioctl_preallocate+0x17c/0x17c
[ 4430.370808]  ? _raw_spin_unlock_irq+0x29/0x4c
[ 4430.371304]  ? __fget_light+0x1a6/0x219
[ 4430.371746]  ? iterate_fd+0x270/0x270
[ 4430.372166]  ? ksys_semctl+0x11e/0x1b4
[ 4430.372593]  ? SyS_semget+0xa/0xa
[ 4430.372982]  ? trace_hardirqs_off_caller+0x11c/0x14a
[ 4430.373543]  ? exit_to_usermode_loop+0x104/0x14b
[ 4430.374071]  ? __bpf_trace_sys_enter+0x5/0x5
[ 4430.374557]  ksys_ioctl+0x3e/0x5d
[ 4430.374954]  ? ksys_ioctl+0x5d/0x5d
[ 4430.375353]  SyS_ioctl+0xa/0xd
[ 4430.375709]  do_syscall_64+0x1bf/0x406
[ 4430.376139]  ? syscall_return_slowpath+0x291/0x291
[ 4430.376679]  ? lockdep_sys_exit+0x16/0x8d
[ 4430.377142]  ? syscall_return_slowpath+0x239/0x291
[ 4430.377687]  ? prepare_exit_to_usermode+0x1c4/0x1c4
[ 4430.378240]  ? mark_held_locks+0x28/0x7f
[ 4430.378701]  ? trace_hardirqs_off_caller+0x11c/0x14a
[ 4430.379270]  ? trace_hardirqs_off_thunk+0x1a/0x1c
[ 4430.379808]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[ 4430.380372] RIP: 0033:0x7f204bc44dc7
[ 4430.380781] RSP: 002b:00007ffdf21bbc88 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[ 4430.381629] RAX: ffffffffffffffda RBX: 00007f204bf27ec0 RCX: 00007f204bc44dc7
[ 4430.382423] RDX: 000055cef48d8b40 RSI: 00000000c138fd06 RDI: 0000000000000003
[ 4430.383233] RBP: 0000000000000000 R08: 00007f204bf631c8 R09: 00007ffdf21bbaf0
[ 4430.384031] R10: 00007f204bf62683 R11: 0000000000000246 R12: 0000000000000001
[ 4430.384824] R13: 000055cef48d8b70 R14: 000055cef48d8b40 R15: 000055cef48d8940
[ 4430.385628] Code: c0 74 2a 48 c7 c7 a0 d1 92 84 e8 3c 62 2a 00 83 3d e8 31 7a 03 00 75 15 48 c7 c6 c0 41 29 82 48 c7 c7 80 41 29 82 e8 6a 48 f5 ff <0f> 0b 4c 8d 64 24 20 4c 89 e7 49 c1 ec 03 e8 88 63 2a 00 4c 89
[ 4430.387855] ---[ end trace 107bc7c31af8101d ]---
[ 4430.421678] Buffer I/O error on dev dm-0, logical block 8388480, async page read
[ 4430.422612] Buffer I/O error on dev dm-0, logical block 8388481, async page read
[ 4430.423512] Buffer I/O error on dev dm-0, logical block 8388482, async page read
[ 4430.424440] Buffer I/O error on dev dm-0, logical block 8388483, async page read
[ 4430.425479] Buffer I/O error on dev dm-0, logical block 8388484, async page read
[ 4430.426388] Buffer I/O error on dev dm-0, logical block 8388485, async page read
[ 4430.427350] Buffer I/O error on dev dm-0, logical block 8388486, async page read
[ 4430.428287] Buffer I/O error on dev dm-0, logical block 8388487, async page read
[ 4430.768942] XFS (dm-0): Unmounting Filesystem
[ 4430.769803] XFS (dm-0): metadata I/O error in "xfs_buf_iodone_callback_error" at daddr 0x0 len 1 error 5
[ 4430.771095] XFS (dm-0): xfs_do_force_shutdown(0x1) called from line 1161 of file fs/xfs/xfs_buf_item.c.  Return address = 000000005a7ca1af
[ 4430.772575] XFS (dm-0): I/O Error Detected. Shutting down filesystem
[ 4430.773306] XFS (dm-0): Please umount the filesystem and rectify the problem(s)
[ 4431.437109] XFS (dm-0): Mounting V5 Filesystem
[ 4431.457059] XFS (dm-0): Starting recovery (logdev: internal)
[ 4431.482273] XFS (dm-0): Ending recovery (logdev: internal)
[ 4431.535267] XFS (dm-0): Unmounting Filesystem`:


-- 
Ming
