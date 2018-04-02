Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-by2nam03on0112.outbound.protection.outlook.com ([104.47.42.112]:61400
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751874AbeDBAct (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 1 Apr 2018 20:32:49 -0400
From: Sasha Levin <Alexander.Levin@microsoft.com>
Subject: Re: [PATCH] xfs: always free inline data before resetting inode fork
 during ifree
Date: Mon, 2 Apr 2018 00:32:44 +0000
Message-ID: <20180402003242.GF7561@sasha-vm>
References: <20180323170813.GD30543@wotan.suse.de>
 <20180323172620.GK4818@magnolia> <20180323182302.GB9190@wotan.suse.de>
 <20180325223357.GJ18129@dastard>
 <CA+1xoqdWBumgCn9iw7FH_6VtDnEmd5_Hyw=cY4b9zB=Avhx-4g@mail.gmail.com>
 <20180328033228.GA18129@dastard> <20180328193004.GB7561@sasha-vm>
 <20180328230535.GE18129@dastard> <20180330024704.GE7561@sasha-vm>
 <20180331220245.GG1150@dastard>
In-Reply-To: <20180331220245.GG1150@dastard>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9D45E0E8C955614BB738B9246F633550@namprd21.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Sasha Levin <levinsasha928@gmail.com>, "Luis R. Rodriguez" <mcgrof@kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, xfs <linux-xfs@vger.kernel.org>, "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Julia Lawall <julia.lawall@lip6.fr>, Josh Triplett <josh@joshtriplett.org>, Takashi Iwai <tiwai@suse.de>, Michal Hocko <mhocko@kernel.org>, Joerg Roedel <joro@8bytes.org>

On Sun, Apr 01, 2018 at 08:02:45AM +1000, Dave Chinner wrote:
>On Fri, Mar 30, 2018 at 02:47:05AM +0000, Sasha Levin wrote:
>> On Thu, Mar 29, 2018 at 10:05:35AM +1100, Dave Chinner wrote:
>> >On Wed, Mar 28, 2018 at 07:30:06PM +0000, Sasha Levin wrote:
>> > This commit has been processed by the -stable helper bot and determine=
d
>> > to be a high probability candidate for -stable trees. (score: 6.4845)
>> >
>> > The bot has tested the following trees: v4.15.12, v4.14.29, v4.9.89, v=
4.4.123, v4.1.50, v3.18.101.
>> >
>> > v4.15.12: Build OK!
>> > v4.14.29: Build OK!
>> > v4.9.89: Build OK!
>> > v4.4.123: Build OK!
>> > v4.1.50: Build OK!
>> > v3.18.101: Build OK!
>> >
>> > XFS Specific tests:
>> >
>> > v4.15.12 (http://stable-bot.westus2.cloudapp.azure.com/test/v4.15.12/t=
ests/):
>> >     No tests completed!
>
>Can you capture the actual check command output into it's own file?
>That tells us at a glance which tests succeed or failed.
>
>So I'm looking at the v5.log file:
>
>....
>echo 'export MKFS_OPTIONS=3D'\''-m crc=3D0,reflink=3D0,rmapbt=3D0, -i spar=
se=3D0,'\'''
>....
>
>
>FSTYP         -- xfs (debug)
>PLATFORM      -- Linux/x86_64 autosel 4.15.12+
>MKFS_OPTIONS  -- -f -m crc=3D0,reflink=3D0,rmapbt=3D0, -i sparse=3D0,
>/dev/vdb
>MOUNT_OPTIONS -- /dev/vdb /mnt2
>
>That's not testing v5 filesystems. That's turned off crcs, and
>so is testing a v4 filesystem. You'll see this on filesysetms that
>don't support reflink:
>
> [not run] Reflink not supported by test filesystem type: xfs

I mixed up the configs here. Basically I have 4 different ones (provided
by Darrick):

MKFS_OPTIONS=3D'-m reflink=3D1,rmapbt=3D1, -i sparse=3D1, -b size=3D1024,'
MKFS_OPTIONS=3D'-m reflink=3D1,rmapbt=3D1, -i sparse=3D1,'
MKFS_OPTIONS=3D'-m crc=3D0,reflink=3D0,rmapbt=3D0, -i sparse=3D0,'
MKFS_OPTIONS=3D'-m crc=3D0,reflink=3D0,rmapbt=3D0, -i sparse=3D0, -b size=
=3D512,'

>Also, you need to make the test filesystem to match the options
>the test run is configured with (i.e. v4, v5, reflink, etc)
>otherwise half the tests don't exercise the expected config.
>
>[not run] src/dbtest not built
>
> [not run] chacl command not found
>
> [not run] xfs_io set_encpolicy support is missing
>
>You need to update your userspace.

I thought xfsprogs in Ubuntu 18.04 is more recent, but is really 1 year
old. Instead, I'm just building it from source now.

>And the test run has not completed. It's run to:
>
>generic/430	[11172.480621] run fstests generic/430 at 2018-03-30 00:20:12
>+ scp -i /home/sasha/ssh/id_rsa -P 10022 -r root@10.3.38.7:/root/xfstests-=
dev/results /home/sasha/data/results/test/v4.15.12/tests//v5/
>+ az vm delete -y --resource-group sasha-auto-stable --name sasha-worker-6=
29016242-vm
>
>generic/430 and then stopped. There's still another ~50 tests in the
>generic group to run, and then there's the shared and XFS subdirs to
>run, too. So there's still something wrong in the way you are
>setting up/installing fstests here....

I had a timeout I forgot about. There tests do take a while... :)

>> > v4.14.29 (http://stable-bot.westus2.cloudapp.azure.com/test/v4.14.29/t=
ests/):
>> >     No tests completed!
>> > v4.9.89 (http://stable-bot.westus2.cloudapp.azure.com/test/v4.9.89/tes=
ts/):
>> >     No tests completed!
>> > v4.4.123 (http://stable-bot.westus2.cloudapp.azure.com/test/v4.4.123/t=
ests/):
>> >     v4:
>> >         Thu Mar 29 21:23:57 UTC 2018
>> >         Interrupted!
>> >         Passed all 0 tests
>> >     v4_reflink:
>
>There's no such configuration as "v4 reflink". reflink is only
>available on v5 (crc enabled) filesystems on kernels >=3D4.10 (IIRC).
>Perhaps you've mislabelled them?
>
>> Let me know if this would be good enough for now, and if there's
>> anything else to add that'll be useful.
>>
>> This brings me to the sad part of this mail: not a single stable kernel
>> survived a run. Most are paniced, some are hanging, and some were killed
>> because of KASan.
>>
>> All have hit various warnings in fs/iomap.c,
>
>Normal - the dmesg filter in the test harness catches those and
>ignores them if they are known/expected to occur.
>
>> and kernels accross several
>> versions hit the BUG at fs/xfs/xfs_message.c:113 (+-1 line)
>
>That's an ASSERT() failure, indicating a fatal error. e.g:
>
>Stuff like this (from
>http://stable-bot.westus2.cloudapp.azure.com/test/v4.9.89/tests/v4_reflink=
.log)
>
>.....
>generic/083	[ 4443.536212] run fstests generic/083 at 2018-03-29 22:32:17
>[ 4444.557989] XFS (vdb): Unmounting Filesystem
>[ 4445.498461] XFS (vdb): EXPERIMENTAL reverse mapping btree feature enabl=
ed. Use at your own risk!
>[ 4445.505860] XFS (vdb): EXPERIMENTAL reflink feature enabled. Use at you=
r own risk!
>[ 4445.513090] XFS (vdb): Mounting V5 Filesystem
>[ 4445.531284] XFS (vdb): Ending clean mount
>[ 4458.087406] XFS: Assertion failed: xfs_is_reflink_inode(ip), file: fs/x=
fs/xfs_reflink.c, line: 509
>
>[snip stack trace]
>
>Indicate a problem that should not be occurring. It's debug an
>triage time - there's some problem that needs backports to fix. I
>doubt anyone in XFS land has time to do this on top of everything
>else we alreayd have to do...
>
>> 4.15.12 is hitting a use-after-free in xfs_efi_release().
>
>Debug and triage time.
>
>> 4.14.29 and 4.9.89 seems to end up with corrupted memory (KASAN
>> warnings) at or before generic/027.
>
>More debug and triage time.
>
>> And finally, 3.18.101 is pretty unhappy with sleeping functions called
>> from atomic context.
>
>Needle in a haystack :/
>
>So this is just basic XFS validation, and it's throwing problems up
>all over the place. Now do you see why we've been saying maintaining
>stable backports for XFS is pretty much a full time job for someone?

Maintaining stable backports is indeed lots of work, but I feel that
a lot of progress can be made by automating parts of it.

>And keep in mind this is just one filesystem. You're going to end up
>with the same issues on ext4 and btrfs - the regression tests are
>going to show up all sorts of problems that have been fixed in the
>upstream kernels but never backported....

Right, but this effort will both make it harder for new regressions to
creep in, and will make it easier to backport fixes for these issues
much easier.

I've tried running it on current mainline (that was about 12 hours
before v4.16 was released), and saw some failures there, in particular
the use-after-free which seems to be caused by generic/388:

[25302.342348] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[25302.348851] BUG: KASAN: use-after-free in xfs_rui_release+0x1ce/0x220
[25302.355334] Read of size 4 at addr ffff8801600f3630 by task fsstress/627=
4
[25302.360678]
[25302.360678] CPU: 7 PID: 6274 Comm: fsstress Not tainted 4.16.0-rc7+ #22
[25302.360678] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
Ubuntu-1.8.2-1ubuntu1 04/01/2014
[25302.360678] Call Trace:
[25302.360678]  dump_stack+0xd6/0x184
[25302.360678]  ? _atomic_dec_and_lock+0x2cc/0x2cc
[25302.360678]  ? show_regs_print_info+0x5/0x5
[25302.360678]  print_address_description+0x75/0x430
[25302.360678]  ? xfs_rui_release+0x1ce/0x220
[25302.360678]  kasan_report+0x1d8/0x460
[25302.360678]  ? xfs_rui_release+0x1ce/0x220
[25302.360678]  xfs_rui_release+0x1ce/0x220
[25302.407137]  ? xfs_rui_copy_format+0x100/0x100
[25302.407137]  xfs_defer_trans_abort+0x1e6/0xac0
[25302.407137]  ? xfs_defer_intake_work+0xad0/0xad0
[25302.407137]  ? xfs_trans_free_items+0x2e0/0x2e0
[25302.407137]  ? __lock_is_held+0xcb/0x1a0
[25302.407137]  xfs_defer_trans_roll+0x727/0xe60
[25302.407137]  ? xfs_defer_trans_abort+0xac0/0xac0
[25302.407137]  ? xfs_bmap_add_extent_hole_delay+0x1320/0x1320
[25302.407137]  ? __lock_is_held+0xcb/0x1a0
[25302.407137]  xfs_defer_finish+0x2a6/0x2140
[25302.407137]  ? xfs_trans_log_inode+0xa5/0x5b0
[25302.407137]  ? xfs_defer_bjoin+0x100/0x100
[25302.407137]  ? xfs_trans_ichgtime+0x1a0/0x1a0
[25302.448302]  ? save_stack+0x89/0xb0
[25302.448302]  ? xfs_bmapi_write+0x275c/0x4e20
[25302.448302]  ? do_syscall_64+0x24b/0x8b0
[25302.460213]  ? entry_SYSCALL_64_after_hwframe+0x42/0xb7
[25302.460213]  ? __bfs+0xaa0/0xaf0
[25302.460213]  ? xfs_bmapi_reserve_delalloc+0xd20/0xd20
[25302.460213]  ? __lock_is_held+0xcb/0x1a0
[25302.460213]  ? __lock_is_held+0xcb/0x1a0
[25302.460213]  ? rcu_read_lock_sched_held+0x102/0x120
[25302.482063]  ? xfs_defer_init+0x433/0x5f0
[25302.482063]  ? xfs_trans_unreserve_and_mod_sb+0xc10/0xc10
[25302.490331]  xfs_alloc_file_space+0x53a/0xf90
[25302.490331]  ? xfs_prepare_shift+0x160/0x160
[25302.498803]  ? lock_acquire+0x1c0/0x600
[25302.498803]  ? xfs_ilock+0x42b/0x670
[25302.498803]  ? lock_contended+0x1330/0x1330
[25302.498803]  ? down_write_nested+0xf2/0x190
[25302.498803]  ? _down_write_nest_lock+0x190/0x190
[25302.498803]  ? xfs_get_cowextsz_hint+0xa0/0xa0
[25302.498803]  ? xfs_break_layouts+0x2c/0x350
[25302.498803]  xfs_file_fallocate+0x5c6/0xac0
[25302.498803]  ? xfs_update_prealloc_flags+0x370/0x370
[25302.498803]  ? __lock_is_held+0xcb/0x1a0
[25302.498803]  ? rcu_read_lock_sched_held+0x102/0x120
[25302.498803]  ? rcu_sync_lockdep_assert+0xbc/0x150
[25302.498803]  vfs_fallocate+0x2f5/0x930
[25302.498803]  ioctl_preallocate+0x1dc/0x320
[25302.498803]  ? vfs_ioctl+0xf0/0xf0
[25302.550185]  do_vfs_ioctl+0xfe4/0x1690
[25302.550185]  ? cp_new_stat+0x66a/0x8e0
[25302.550185]  ? inode_get_bytes+0xc0/0xc0
[25302.550185]  ? ioctl_preallocate+0x320/0x320
[25302.550185]  ? fget_raw+0x10/0x10
[25302.550185]  ? vfs_statx_fd+0x3f/0x70
[25302.550185]  ? SYSC_newfstat+0x7c/0xd0
[25302.570302]  ? vfs_statx_fd+0x70/0x70
[25302.570302]  SyS_ioctl+0x6f/0x80
[25302.570302]  ? do_vfs_ioctl+0x1690/0x1690
[25302.570302]  do_syscall_64+0x24b/0x8b0
[25302.570302]  ? exit_to_usermode_loop+0xdf/0x1f0
[25302.570302]  ? trace_hardirqs_on_thunk+0x1a/0x1c
[25302.570302]  ? syscall_return_slowpath+0x560/0x560
[25302.590209]  ? syscall_return_slowpath+0x21f/0x560
[25302.590209]  ? entry_SYSCALL_64_after_hwframe+0x52/0xb7
[25302.600302]  ? trace_hardirqs_off_thunk+0x1a/0x1c
[25302.600302]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[25302.607106] RIP: 0033:0x7fb0455315d7
[25302.607106] RSP: 002b:00007fffc620fef8 EFLAGS: 00000202 ORIG_RAX: 000000=
0000000010
[25302.607106] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007fb0455=
315d7
[25302.607106] RDX: 00007fffc620ff20 RSI: 000000004030582a RDI: 00000000000=
00003
[25302.607106] RBP: 00000000000000dd R08: 000000000000007d R09: feff54bcff6=
03065
[25302.607106] R10: 0000000000000000 R11: 0000000000000202 R12: 00000000000=
51873
[25302.607106] R13: 0000000051eb851f R14: 00007fffc62104b6 R15: 000055be2ca=
263e0
[25302.607106]
[25302.607106] Allocated by task 6274:
[25302.607106]  kasan_kmalloc+0xa0/0xd0
[25302.649054]  kmem_cache_alloc+0x109/0x450
[25302.649054]  kmem_zone_alloc+0x67/0x180
[25302.649054]  xfs_rui_init+0xbd/0x2e0
[25302.649054]  xfs_rmap_update_create_intent+0x43/0xd0
[25302.660185]  xfs_defer_intake_work+0x184/0xad0
[25302.660185]  xfs_defer_finish+0x29b/0x2140
[25302.660185]  xfs_alloc_file_space+0x53a/0xf90
[25302.660185]  xfs_file_fallocate+0x5c6/0xac0
[25302.660185]  vfs_fallocate+0x2f5/0x930
[25302.680347]  ioctl_preallocate+0x1dc/0x320
[25302.680347]  do_vfs_ioctl+0xfe4/0x1690
[25302.680347]  SyS_ioctl+0x6f/0x80
[25302.680347]  do_syscall_64+0x24b/0x8b0
[25302.680347]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[25302.680347]
[25302.680347] Freed by task 6274:
[25302.680347]  __kasan_slab_free+0x136/0x180
[25302.700464]  kmem_cache_free+0xe7/0x4b0
[25302.700464]  xfs_trans_free_items+0x198/0x2e0
[25302.700464]  __xfs_trans_commit+0x27f/0xcc0
[25302.711238]  xfs_trans_roll+0x17b/0x2a0
[25302.713745]  xfs_defer_trans_roll+0x6ad/0xe60
[25302.713745]  xfs_defer_finish+0x2a6/0x2140
[25302.713745]  xfs_alloc_file_space+0x53a/0xf90
[25302.713745]  xfs_file_fallocate+0x5c6/0xac0
[25302.713745]  vfs_fallocate+0x2f5/0x930
[25302.713745]  ioctl_preallocate+0x1dc/0x320
[25302.713745]  do_vfs_ioctl+0xfe4/0x1690
[25302.713745]  SyS_ioctl+0x6f/0x80
[25302.713745]  do_syscall_64+0x24b/0x8b0
[25302.713745]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[25302.713745]
[25302.713745] The buggy address belongs to the object at ffff8801600f35a8
[25302.713745]  which belongs to the cache xfs_rui_item of size 680
[25302.757350] The buggy address is located 136 bytes inside of
[25302.757350]  680-byte region [ffff8801600f35a8, ffff8801600f3850)
[25302.757350] The buggy address belongs to the page:
[25302.757350] page:ffffea0005803c00 count:1 mapcount:0 mapping:00000000000=
00000 index:0x0 compound_mapcount: 0
[25302.757350] flags: 0x2fffc0000008100(slab|head)
[25302.757350] raw: 02fffc0000008100 0000000000000000 0000000000000000 0000=
000180140014
[25302.757350] raw: ffffea000e4da600 0000000500000005 ffff8803a707c300 0000=
000000000000
[25302.757350] page dumped because: kasan: bad access detected
[25302.757350]
[25302.757350] Memory state around the buggy address:
[25302.757350]  ffff8801600f3500: fb fb fb fb fb fc fc fc fc fc fc fc fc fc=
 fc fc
[25302.757350]  ffff8801600f3580: fc fc fc fc fc fb fb fb fb fb fb fb fb fb=
 fb fb
[25302.757350] >ffff8801600f3600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb=
 fb fb
[25302.757350]                                      ^
[25302.757350]  ffff8801600f3680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb=
 fb fb
[25302.757350]  ffff8801600f3700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb=
 fb fb
[25302.757350] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


--
Thanks,
Sasha=
