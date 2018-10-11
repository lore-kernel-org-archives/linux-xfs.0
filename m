Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it1-f194.google.com ([209.85.166.194]:34092 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbeJKNql (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Oct 2018 09:46:41 -0400
Received: by mail-it1-f194.google.com with SMTP id l127-v6so17952418ith.1
        for <linux-xfs@vger.kernel.org>; Wed, 10 Oct 2018 23:20:55 -0700 (PDT)
MIME-Version: 1.0
References: <CABXGCsPMXLbPJdAFq79Fmby3y89s=o7F-tf_+zSo_RsJXjaRaA@mail.gmail.com>
 <20181011060027.GP6311@dastard>
In-Reply-To: <20181011060027.GP6311@dastard>
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Date: Thu, 11 Oct 2018 11:20:43 +0500
Message-ID: <CABXGCsNzZKE6-7LB9_KQi=YuhWcd=GRZPG-FeicZiz8bEwb23g@mail.gmail.com>
Subject: Re: xfs_bmap stuck at ~/.steam/steam.pipe file
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Thu, 11 Oct 2018 at 11:00, Dave Chinner <david@fromorbit.com> wrote:
>
> On Thu, Oct 11, 2018 at 10:47:31AM +0500, Mikhail Gavrilov wrote:
> > When I researched the most fragmented files, I found that xfs_bmap
> > stuck at the file /home/mikhail/.steam/steam.pipe.
>
> Stuck, or just taking a long time?

I was waiting for seven hours when process ended. I think it's enough
for think than this process stuck.

$ ps aux | grep xfs_bmap
mikhail  16226  0.0  0.0 213216   840 pts/21   S+   11:07   0:00 grep
--color=auto xfs_bmap
mikhail  21021  0.0  0.0 213804  1224 pts/12   S+   04:32   0:00
/usr/bin/sh -f /usr/sbin/xfs_bmap /home/mikhail/.steam/steam.pipe
mikhail  21024  0.0  0.0 217424     8 pts/12   S+   04:32   0:00
/usr/sbin/xfs_io -r -p xfs_bmap -c bmap
/home/mikhail/.steam/steam.pipe
[mikhail@localhost ~]$ date
Thu Oct 11 11:07:55 +05 2018

>
> It's in the kernel open() syscall opening the file. userspace
> tracing won't tell you what is going on at this point. Is there
> anything in dmesg?

Nothing since the time when process xfs_io was started.

$ dmesg -e
...
[Oct10 23:37] perf: interrupt took too long (2512 > 2500), lowering
kernel.perf_event_max_sample_rate to 79000
[Oct11 09:53] tun: Universal TUN/TAP device driver, 1.6
[Oct11 10:21] usb 3-2.4: USB disconnect, device number 6
[  +0.953248] usb 3-2.4: new high-speed USB device number 10 using xhci_hcd
[  +0.090606] usb 3-2.4: New USB device found, idVendor=2109,
idProduct=2813, bcdDevice=90.11
[  +0.000003] usb 3-2.4: New USB device strings: Mfr=1, Product=2,
SerialNumber=0
[  +0.000002] usb 3-2.4: Product: USB2.0 Hub
[  +0.000002] usb 3-2.4: Manufacturer: VIA Labs, Inc.
[  +0.043404] hub 3-2.4:1.0: USB hub found
[  +0.000869] hub 3-2.4:1.0: 4 ports detected


> what is the output of `cat /proc/<pid>/stack` for the xfs_io process
> that is running the bmap command?

# cat /proc/21024/stack
[<0>] pipe_wait+0x6c/0xb0
[<0>] wait_for_partner+0x19/0x50
[<0>] fifo_open+0x266/0x2c0
[<0>] do_dentry_open+0x132/0x340
[<0>] path_openat+0x334/0x1610
[<0>] do_filp_open+0x93/0x100
[<0>] do_sys_open+0x186/0x210
[<0>] do_syscall_64+0x5b/0x160
[<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[<0>] 0xffffffffffffffff


> What output ends up in dmesg after running 'echo w > sysrq-trigger'?

[53333.758723] sysrq: SysRq : Show Blocked State
[53333.758728]   task                        PC stack   pid father
[53333.758937] gmain           D    0  2632   1913 0x00000000
[53333.758939] Call Trace:
[53333.758946]  ? __schedule+0x253/0x860
[53333.758948]  schedule+0x28/0x80
[53333.758949]  schedule_timeout+0x268/0x380
[53333.758952]  ? blk_finish_plug+0x21/0x2e
[53333.758953]  wait_for_completion+0x111/0x180
[53333.758955]  ? wake_up_q+0x70/0x70
[53333.758982]  ? __xfs_buf_submit+0x115/0x230 [xfs]
[53333.759024]  ? xfs_buf_read_map+0xfc/0x170 [xfs]
[53333.759069]  ? xfs_trans_read_buf_map+0xaa/0x2e0 [xfs]
[53333.759122]  xfs_buf_iowait+0x22/0xd0 [xfs]
[53333.759174]  __xfs_buf_submit+0x115/0x230 [xfs]
[53333.759232]  xfs_buf_read_map+0xfc/0x170 [xfs]
[53333.759274]  xfs_trans_read_buf_map+0xaa/0x2e0 [xfs]
[53333.759311]  xfs_imap_to_bp+0x67/0xd0 [xfs]
[53333.759348]  xfs_iread+0x82/0x1f0 [xfs]
[53333.759352]  ? inode_init_always+0x120/0x1d0
[53333.759390]  xfs_iget+0x201/0x920 [xfs]
[53333.759430]  ? xfs_iunlock+0x9d/0x100 [xfs]
[53333.759466]  ? xfs_dir_lookup+0x17a/0x1c0 [xfs]
[53333.759505]  xfs_lookup+0xdf/0x120 [xfs]
[53333.759553]  xfs_vn_lookup+0x70/0xa0 [xfs]
[53333.759558]  __lookup_slow+0x97/0x150
[53333.759560]  lookup_slow+0x35/0x50
[53333.759562]  walk_component+0x1bf/0x4a0
[53333.759565]  path_lookupat.isra.53+0x6d/0x220
[53333.759567]  filename_lookup.part.67+0xa0/0x170
[53333.759571]  ? __check_object_size+0xa3/0x181
[53333.759574]  ? strncpy_from_user+0x4a/0x170
[53333.759575]  ? getname_flags+0x6a/0x1e0
[53333.759579]  inotify_find_inode+0x20/0x60
[53333.759581]  __x64_sys_inotify_add_watch+0xa4/0x120
[53333.759585]  do_syscall_64+0x5b/0x160
[53333.759587]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[53333.759590] RIP: 0033:0x7f7fdffcbd0b
[53333.759594] Code: Bad RIP value.
[53333.759595] RSP: 002b:00007f7fcf948998 EFLAGS: 00000202 ORIG_RAX:
00000000000000fe
[53333.759598] RAX: ffffffffffffffda RBX: 000055f5967a6fc0 RCX: 00007f7fdffcbd0b
[53333.759599] RDX: 0000000001002fce RSI: 000055f5967a6ff0 RDI: 000000000000000d
[53333.759600] RBP: 00007f7fcf9489c4 R08: 0000000000000001 R09: 0000000000000000
[53333.759601] R10: 001c23d063ab5288 R11: 0000000000000202 R12: 0000000000000000
[53333.759602] R13: 0000000000000000 R14: 00007f7fe0103d10 R15: 000055f596710350
[53333.759641] TaskSchedulerFo D    0 11811   3159 0x00000000
[53333.759643] Call Trace:
[53333.759647]  ? __schedule+0x253/0x860
[53333.759649]  schedule+0x28/0x80
[53333.759651]  io_schedule+0x12/0x40
[53333.759654]  generic_file_read_iter+0x3cb/0xd10
[53333.759659]  ? page_cache_tree_insert+0xe0/0xe0
[53333.759697]  xfs_file_buffered_aio_read+0x47/0xe0 [xfs]
[53333.759735]  xfs_file_read_iter+0x64/0xc0 [xfs]
[53333.759739]  __vfs_read+0x133/0x190
[53333.759742]  vfs_read+0x8a/0x140
[53333.759743]  ksys_pread64+0x61/0xa0
[53333.759746]  do_syscall_64+0x5b/0x160
[53333.759748]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[53333.759749] RIP: 0033:0x7fdbc8dce657
[53333.759751] Code: Bad RIP value.
[53333.759752] RSP: 002b:00007fdb87a950c0 EFLAGS: 00000293 ORIG_RAX:
0000000000000011
[53333.759754] RAX: ffffffffffffffda RBX: 000000000000032f RCX: 00007fdbc8dce657
[53333.759755] RDX: 0000000000000018 RSI: 00007fdb87a95278 RDI: 000000000000032f
[53333.759756] RBP: 00007fdb87a95278 R08: 0000000000000000 R09: 0000000000005480
[53333.759757] R10: 0000000000005480 R11: 0000000000000293 R12: 0000000000000018
[53333.759758] R13: 0000000000005480 R14: 0000000000005480 R15: 00007fdb87a95278
[53333.759768] TaskSchedulerFo D    0 14877   3159 0x00000000
[53333.759770] Call Trace:
[53333.759773]  ? __schedule+0x253/0x860
[53333.759775]  schedule+0x28/0x80
[53333.759814]  __xfs_log_force_lsn+0x141/0x250 [xfs]
[53333.759817]  ? wake_up_q+0x70/0x70
[53333.759856]  xfs_file_fsync+0x19d/0x1d0 [xfs]
[53333.759859]  do_fsync+0x38/0x70
[53333.759862]  __x64_sys_fdatasync+0x13/0x20
[53333.759864]  do_syscall_64+0x5b/0x160
[53333.759866]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[53333.759868] RIP: 0033:0x7fdbc77d6fbf
[53333.759870] Code: Bad RIP value.
[53333.759871] RSP: 002b:00007fdb74bfb4a0 EFLAGS: 00000293 ORIG_RAX:
000000000000004b
[53333.759872] RAX: ffffffffffffffda RBX: 00000000000000bd RCX: 00007fdbc77d6fbf
[53333.759873] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000000000bd
[53333.759874] RBP: 00007fdb74bfb500 R08: 0000000000000000 R09: 0000000000800000
[53333.759875] R10: 0009bfff6787b168 R11: 0000000000000293 R12: 0000000000000000
[53333.759876] R13: 0000000000000000 R14: 00002222b74e9920 R15: 00002222b74e9900
[53333.759974] TaskSchedulerFo D    0 15031   3327 0x00000000
[53333.759975] Call Trace:
[53333.759978]  ? __schedule+0x253/0x860
[53333.759981]  schedule+0x28/0x80
[53333.760020]  __xfs_log_force_lsn+0x141/0x250 [xfs]
[53333.760022]  ? wake_up_q+0x70/0x70
[53333.760061]  xfs_file_fsync+0x19d/0x1d0 [xfs]
[53333.760063]  do_fsync+0x38/0x70
[53333.760066]  __x64_sys_fdatasync+0x13/0x20
[53333.760068]  do_syscall_64+0x5b/0x160
[53333.760070]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[53333.760071] RIP: 0033:0x7f3f1110efbf
[53333.760073] Code: Bad RIP value.
[53333.760074] RSP: 002b:00007f3ece3c8360 EFLAGS: 00000293 ORIG_RAX:
000000000000004b
[53333.760076] RAX: ffffffffffffffda RBX: 0000000000000160 RCX: 00007f3f1110efbf
[53333.760076] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000160
[53333.760077] RBP: 00007f3ece3c83c0 R08: 0000000000000000 R09: 0000000000300000
[53333.760078] R10: 0009824ccb9f7528 R11: 0000000000000293 R12: 0000000000000000
[53333.760079] R13: 0000000000000000 R14: 000026cd9644c0a0 R15: 000026cd9644c080


Thanks.

--
Best Regards,
Mike Gavrilov.
