Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:36254 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753120AbdIDBWF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Sep 2017 21:22:05 -0400
Date: Mon, 4 Sep 2017 11:17:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] xfs: Add rtdefault mount option
Message-ID: <20170904011714.GF10621@dastard>
References: <25856B28-A65C-4C5B-890D-159F8822393D@fb.com>
 <20170901043151.GZ10621@dastard>
 <C6F6823D-65D7-4B73-9AC7-CBA4125F2429@fb.com>
 <20170901193237.GF29225@bfoster.bfoster>
 <BF1D2F17-045E-4BF7-839D-FF7D0643329E@fb.com>
 <20170901225539.GC10621@dastard>
 <67F62657-D116-4B85-9452-5BAB52EC7041@fb.com>
 <20170902115545.GA36492@bfoster.bfoster>
 <E62CB1B9-AB21-4880-A9CF-88297C4051B8@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E62CB1B9-AB21-4880-A9CF-88297C4051B8@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Richard Wareing <rwareing@fb.com>
Cc: Brian Foster <bfoster@redhat.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

[ Richard, can you please fix your quoting and line wrapping to
work like everyone else's mail clients?]

On Sun, Sep 03, 2017 at 12:43:57AM +0000, Richard Wareing wrote:
> On 9/2/17, 4:55 AM, "Brian Foster" <bfoster@redhat.com> wrote:
>  >  I am obviously not at all familiar with your storage stack and
>  >  the requirements of your environment and whatnoat. It's
>  >  certainly possible that there's some technical reason you
>  >  can't use dm, but I find it very hard to believe that reason
>  >  is "there might be bugs" if you're instead willing to hack up
>  >  and deploy a barely tested feature such as XFS RT.  Using dm
>  >  for basic linear mapping (i.e., partitioning) seems pretty
>  >  much ubiquitous in the Linux world these days.
>     
> Bugs aren’t the only reason of course, but we’ve been
> working on this for a number of months, we also have thousands of
> production hours (* >10 FSes per system == >1M hours on the
> real-time code) on this setup, I’m also doing more testing
> with dm-flaky + dm-log w/ xfs-tests along with this.  In any
> event, large deviations (or starting over from scratch) on our
> setup isn’t something we’d like to do.  At this point I
> trust the RT allocator a good amount, and its sheer simplicity is
> something of an asset for us.

I'm just going to address the "rt dev is stable and well tested"
claim here.


I have my doubts you're actually testing what you think you are
testing with xfstests. Just configuring a rtdev doesn't mean
xfstests runs all it's tests on the rtdev. All it means is it runs
the very few tests that require a rtdev in addition to all the other
tests it runs against the normal data device.

If you really want to test rtdev functionality, you need to use the
"-d rtinherit" mkfs option to force all file data to be targetted at
the rtdev, not the data dev.

And when you do that, the rtdev blows up in 3 different ways in
under 30s, the thrid being a fatal kernel OOPS....

i.e.: Test device setup:

$ mkfs.xfs -f -r rtdev=/dev/ram0 -d rtinherit=1 /dev/pmem0

xfstests config section:

[xfs_rt]
FSTYP=xfs
TEST_DIR=/mnt/test
TEST_DEV=/dev/pmem0
TEST_RTDEV=/dev/ram0
SCRATCH_MNT=/mnt/scratch
SCRATCH_DEV=/dev/pmem1
SCRATCH_RTDEV=/dev/ram1
MKFS_OPTIONS="-d rtinherit=1"


And the result of running:

# ./check -g quick -s xfs_rt
SECTION       -- xfs_rt
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 test4 4.13.0-rc7-dgc
MKFS_OPTIONS  -- -f -d rtinherit=1 /dev/pmem1
MOUNT_OPTIONS -- /dev/pmem1 /mnt/scratch

generic/001 3s ... 3s
generic/002 0s ... 1s
generic/003 10s ... - output mismatch (see /home/dave/src/xfstests-dev/results//xfs_rt/generic/003.out.bad)
    --- tests/generic/003.out   2014-02-24 09:58:09.505184325 +1100
    +++ /home/dave/src/xfstests-dev/results//xfs_rt/generic/003.out.bad 2017-09-04 10:19:07.609694351 +1000
    @@ -1,2 +1,27 @@
     QA output created by 003
    +./tests/generic/003: line 93: echo: write error: No space left on device
    +stat: cannot stat '/mnt/scratch/dir1/file1': Structure needs cleaning
    +ERROR: access time has changed for file1 after remount
    +ERROR: modify time has changed for file1 after remount
    +ERROR: change time has changed for file1 after remount
    +./tests/generic/003: line 120: echo: write error: No space left on device
    ...
    (Run 'diff -u tests/generic/003.out /home/dave/src/xfstests-dev/results//xfs_rt/generic/003.out.bad'  to see the entire diff)
_check_xfs_filesystem: filesystem on /dev/pmem1 is inconsistent (r)
(see /home/dave/src/xfstests-dev/results//xfs_rt/generic/003.full for details)
_check_dmesg: something found in dmesg (see /home/dave/src/xfstests-dev/results//xfs_rt/generic/003.dmesg)

[352996.421261] run fstests generic/003 at 2017-09-04 10:18:57
[352996.669490] XFS (pmem1): Unmounting Filesystem
[352996.714422] XFS (pmem1): Mounting V5 Filesystem
[352996.718122] XFS (pmem1): Ending clean mount
[352996.745512] XFS (pmem1): Unmounting Filesystem
[352996.780789] XFS (pmem1): Mounting V5 Filesystem
[352996.783980] XFS (pmem1): Ending clean mount
[352998.825234] XFS (pmem1): Unmounting Filesystem
[352998.839376] XFS (pmem1): Mounting V5 Filesystem
[352998.842762] XFS (pmem1): Ending clean mount
[352998.847718] XFS (pmem1): corrupt dinode 100, has realtime flag set.
[352998.848716] ffff88013b348800: 49 4e 81 a4 03 02 00 00 00 00 00 00 00 00 00 00  IN..............
[352998.851393] ffff88013b348810: 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00  ................
[352998.852738] ffff88013b348820: 59 ac 9b f2 2e cf 4e 87 59 ac 9b f1 2e 91 a7 2b  Y.....N.Y......+
[352998.854168] ffff88013b348830: 59 ac 9b f1 2e 91 a7 2b 00 00 00 00 00 00 00 00  Y......+........
[352998.855514] XFS (pmem1): Internal error xfs_iformat(realtime) at line 94 of file fs/xfs/libxfs/xfs_inode_fork.c.  Caller xfs_iread+0x1cf/0x230
[352998.857637] CPU: 3 PID: 7470 Comm: stat Tainted: G        W       4.13.0-rc7-dgc #45
[352998.858833] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
[352998.860092] Call Trace:
[352998.860492]  dump_stack+0x63/0x8f
[352998.861052]  xfs_corruption_error+0x87/0x90
[352998.861711]  ? xfs_iread+0x1cf/0x230
[352998.862270]  xfs_iformat_fork+0x390/0x690
[352998.862896]  ? xfs_iread+0x1cf/0x230
[352998.863454]  ? xfs_inode_from_disk+0x35/0x230
[352998.864132]  xfs_iread+0x1cf/0x230
[352998.864672]  xfs_iget+0x518/0xa40
[352998.865221]  xfs_lookup+0xd6/0x100
[352998.865755]  xfs_vn_lookup+0x4c/0x90
[352998.866316]  lookup_slow+0x96/0x150
[352998.866860]  walk_component+0x19a/0x330
[352998.867454]  ? path_init+0x1dc/0x330
[352998.868011]  path_lookupat+0x64/0x1f0
[352998.868581]  filename_lookup+0xa9/0x170
[352998.869192]  ? filemap_map_pages+0x152/0x290
[352998.869853]  user_path_at_empty+0x36/0x40
[352998.870474]  ? user_path_at_empty+0x36/0x40
[352998.871130]  vfs_statx+0x67/0xc0
[352998.871635]  SYSC_newlstat+0x2e/0x50
[352998.872200]  ? trace_do_page_fault+0x41/0x140
[352998.872871]  SyS_newlstat+0xe/0x10
[352998.873423]  entry_SYSCALL_64_fastpath+0x1a/0xa5
[352998.874140] RIP: 0033:0x7f75730690e5
[352998.874699] RSP: 002b:00007ffdcad5e878 EFLAGS: 00000246 ORIG_RAX: 0000000000000006
[352998.875856] RAX: ffffffffffffffda RBX: 00007ffdcad5ea68 RCX: 00007f75730690e5
[352998.876975] RDX: 00007ffdcad5e8b0 RSI: 00007ffdcad5e8b0 RDI: 00007ffdcad5fc9a
[352998.878072] RBP: 0000000000000004 R08: 0000000000000100 R09: 0000000000000000
[352998.879154] R10: 00000000000001cb R11: 0000000000000246 R12: 000056423451cc80
[352998.880233] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[352998.881548] XFS (pmem1): Corruption detected. Unmount and run xfs_repair
[352998.882581] XFS (pmem1): xfs_iread: xfs_iformat() returned error -117

The second blowup is:

generic/015 1s ... [failed, exit status 1] - output mismatch (see /home/dave/src/xfstests-dev/results//xfs_rt/generic/015.out.bad)
    --- tests/generic/015.out   2014-01-20 16:57:33.965658221 +1100
    +++ /home/dave/src/xfstests-dev/results//xfs_rt/generic/015.out.bad 2017-09-04 10:19:17.998113907 +1000
    @@ -2,6 +2,5 @@
     fill disk:
        !!! disk full (expected)
     check free space:
    -delete fill:
    -check free space:
    -   !!! free space is in range
    +   *** file created with zero length
    ...
    (Run 'diff -u tests/generic/015.out /home/dave/src/xfstests-dev/results//xfs_rt/generic/015.out.bad'  to see the entire diff)
_check_xfs_filesystem: filesystem on /dev/pmem1 is inconsistent (r)
(see /home/dave/src/xfstests-dev/results//xfs_rt/generic/015.full for details)

Which may or may not be a xfstests problem, because repair blows
up with:

.....
inode 96 has RT flag set but there is no RT device
inode 99 has RT flag set but there is no RT device
inode 96 has RT flag set but there is no RT device
would fix bad flags.
inode 99 has RT flag set but there is no RT device
would fix bad flags.
found inode 99 claiming to be a real-time file
.....

And the third is:

[353017.737976] run fstests generic/018 at 2017-09-04 10:19:18
[353017.956902] XFS (pmem1): Mounting V5 Filesystem
[353017.960672] XFS (pmem1): Ending clean mount
[353017.982836] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
[353017.984077] IP: xfs_find_bdev_for_inode+0x2b/0x30
[353017.984873] PGD 0 
[353017.984874] P4D 0 

[353017.985788] Oops: 0000 [#1] PREEMPT SMP
[353017.986412] CPU: 9 PID: 15847 Comm: xfs_io Tainted: G        W       4.13.0-rc7-dgc #45
[353017.987641] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
[353017.988932] task: ffff880236955740 task.stack: ffffc90007878000
[353017.989853] RIP: 0010:xfs_find_bdev_for_inode+0x2b/0x30
[353017.990666] RSP: 0018:ffffc9000787bc88 EFLAGS: 00010202
[353017.991466] RAX: 0000000000000000 RBX: ffffc9000787bd70 RCX: 000000000000000c
[353017.992584] RDX: 0000000000000001 RSI: fffffffffffffffe RDI: ffff8808280891e8
[353017.993657] RBP: ffffc9000787bcb0 R08: 0000000000000009 R09: ffff8808280890c8
[353017.994726] R10: 000000000000034e R11: ffff880236955740 R12: ffff880828089080
[353017.995808] R13: ffffc9000787bd08 R14: ffff88080a8de000 R15: ffff88080a8de000
[353017.996905] FS:  00007ff336cb21c0(0000) GS:ffff88023fd00000(0000) knlGS:0000000000000000
[353017.998114] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[353017.998984] CR2: 0000000000000008 CR3: 000000022dc09000 CR4: 00000000000406e0
[353018.000049] Call Trace:
[353018.000465]  ? xfs_bmbt_to_iomap+0x78/0xb0
[353018.001097]  xfs_file_iomap_begin+0x265/0x990
[353018.001770]  iomap_apply+0x48/0xe0
[353018.002300]  ? iomap_write_end+0x70/0x70
[353018.002909]  iomap_fiemap+0x9e/0x100
[353018.003471]  ? iomap_write_end+0x70/0x70
[353018.004085]  xfs_vn_fiemap+0x5c/0x80
[353018.004668]  do_vfs_ioctl+0x450/0x5c0
[353018.005233]  SyS_ioctl+0x79/0x90
[353018.005735]  entry_SYSCALL_64_fastpath+0x1a/0xa5
[353018.006440] RIP: 0033:0x7ff336390dc7
[353018.007000] RSP: 002b:00007fff1b806b38 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[353018.008154] RAX: ffffffffffffffda RBX: 0000000000000063 RCX: 00007ff336390dc7
[353018.009241] RDX: 0000558a334476a0 RSI: 00000000c020660b RDI: 0000000000000003
[353018.010314] RBP: 0000000000002710 R08: 0000000000000003 R09: 000000000000001d
[353018.011396] R10: 000000000000034e R11: 0000000000000246 R12: 0000000000001010
[353018.012479] R13: 00007ff336647b58 R14: 0000558a33447dc0 R15: 00007ff336647b00
[353018.013554] Code: 66 66 66 66 90 f6 47 da 01 55 48 89 e5 48 8b 87 98 fe ff ff 75 0d 48 8b 80 38 02 00 00 5d 48 8b 40 08 c3 48 8b 80 48 02 00 00 5d <48> 8b 40 08 c3 66 66 66 66 90 55 48 89 e5 41 57 41 56 41 55 41 
[353018.016404] RIP: xfs_find_bdev_for_inode+0x2b/0x30 RSP: ffffc9000787bc88
[353018.017420] CR2: 0000000000000008
[353018.018024] ---[ end trace af08c2af09ff5975 ]---


A null pointer dereference in generic/018. At which point the system
needs rebooting to recover.

So, yeah, the rtdev is not stable, not robust and not very well
maintained at this point. If you want to focus new development on
the RT device, then the first thing we need is fixes for all it's
obvious problems. Get it working reliably upstream first so we have
a good baseline from which we can evaluate enhancements sanely...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
