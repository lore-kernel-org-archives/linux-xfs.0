Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EA2447CA3
	for <xfs@oss.sgi.com>; Tue, 23 Feb 2016 06:25:54 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3D4A0AC003
	for <xfs@oss.sgi.com>; Tue, 23 Feb 2016 04:25:47 -0800 (PST)
Received: from mail-wm0-f52.google.com (mail-wm0-f52.google.com
	[74.125.82.52]) by cuda.sgi.com with ESMTP id rZhbWwlBkOvit9Tg
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 23 Feb 2016 04:25:39 -0800 (PST)
Received: by mail-wm0-f52.google.com with SMTP id c200so217678647wme.0
	for <xfs@oss.sgi.com>; Tue, 23 Feb 2016 04:25:39 -0800 (PST)
Message-ID: <D5578D3E98EE48B88EA9A1126B671155@alyakaslap>
From: "Alex Lyakas" <alex@zadarastorage.com>
References: <3685DFAD20214109878873CF81232704@alyakaslap>
	<20160222212019.GI25832@dastard>
	<CAOcd+r1XY2kcp+qJ=mPOAQSmb90QUnLfmT3-FkMjQN_+Ejmt8A@mail.gmail.com>
	<20160222235628.GK25832@dastard>
In-Reply-To: <20160222235628.GK25832@dastard>
Subject: Re: xfs resize: primary superblock is not updated immediately
Date: Tue, 23 Feb 2016 14:25:38 +0200
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Danny Shavit <danny@zadarastorage.com>, Shyam Kaushik <shyam@zadarastorage.com>, Yair Hershko <yair@zadarastorage.com>, xfs@oss.sgi.com

Hi Dave,

Below is a detailed reproduction scenario of the problem. No snapshots 
involved, only XFS. The scenario is performed on a VM, running kernel 
3.18.19.

1) Use 100 MB block device for XFS. In my case, this is achieved by:
# dmsetup create xfs_base --table "0 204800 linear /dev/vdd 0"

2) Create XFS on the block device:
# mkfs.xfs -f -K /dev/mapper/xfs_base -d agsize=25690112  -l 
size=10485760 -p /etc/zadara/xfs.protofile
The protofile is [1].

Output:
meta-data=/dev/mapper/xfs_base   isize=256    agcount=4, agsize=6272 blks
         =                       sectsz=512   attr=2, projid32bit=0
data     =                       bsize=4096   blocks=25088, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

So we have 4 AGs right now. We are not using the full 100 Mb.

3) Mount the XFS:
# mount -o sync /dev/mapper/xfs_base /mnt/xfs/

4) Verify the primary superblock on disk:
# xfs_db -r -c "sb 0" -c "p"   /dev/mapper/xfs_base  | grep agc
agcount = 4

5) Resize to full 100MB:
# xfs_growfs -d /mnt/xfs

Output:
meta-data=/dev/mapper/xfs_base   isize=256    agcount=4, agsize=6272 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=25088, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
data blocks changed from 25088 to 25600

6) Verify that primary superblock still have 4 AGs:
# xfs_db -r -c "sb 0" -c "p"   /dev/mapper/xfs_base  | grep agc
agcount = 4

7) Immediately crash the VM

8) After VM reboots, re-create the device mapper
# dmsetup create xfs_base --table "0 204800 linear /dev/vdd 0"

9) mount
# mount -o sync /dev/mapper/xfs_base /mnt/xfs/

Kernel panics with [2]. Note that I added some prints to xfs_perag_get() in 
case the pag is not found, and also to xfs_initialize_perag() when adding a 
new pag. The prints indicate, that after mount XFS did not create pag for 
agno 4. But during log mount/replay it needs this pag and crashes.

Does this repro align with what you expect currently?

Thanks,
Alex.


[1]
# cat /etc/zadara/xfs.protofile
dummy                   : bootfilename, not used, backward compatibility
0 0                             : numbers of blocks and inodes, not used, 
backward compatibility
d--777 0 0              : set 777 perms for the root dir
$
$

[2]
[   53.506307] [2392]xfs*[xfs_perag_get:130] XFS(dm-0): pag[0]: not found!
[   53.506323] [2392]xfs [xfs_initialize_perag:239] XFS(dm-0): Add pag[0]
[   53.506326] [2392]xfs*[xfs_perag_get:130] XFS(dm-0): pag[1]: not found!
[   53.506332] [2392]xfs [xfs_initialize_perag:239] XFS(dm-0): Add pag[1]
[   53.506336] [2392]xfs*[xfs_perag_get:130] XFS(dm-0): pag[2]: not found!
[   53.506348] [2392]xfs [xfs_initialize_perag:239] XFS(dm-0): Add pag[2]
[   53.506358] [2392]xfs*[xfs_perag_get:130] XFS(dm-0): pag[3]: not found!
[   53.506392] [2392]xfs [xfs_initialize_perag:239] XFS(dm-0): Add pag[3]
[   53.506397] XFS (dm-0): Mounting V4 Filesystem
[   53.562231] XFS (dm-0): Starting recovery (logdev: internal)
[   53.567501] [2392]xfs*[xfs_perag_get:130] XFS(dm-0): pag[4]: not found!
[   53.567574] BUG: unable to handle kernel NULL pointer dereference at 
00000000000000a0
[   53.568464] IP: [<ffffffff81717436>] _raw_spin_lock+0x16/0x60
[   53.568464] PGD 7b446067 PUD 35299067 PMD 0
[   53.568464] Oops: 0002 [#1] PREEMPT SMP
[   53.568464] CPU: 3 PID: 2392 Comm: mount Tainted: G           OE 
3.18.19-zadara05 #1
[   53.568464] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[   53.568464] task: ffff88007b698a20 ti: ffff880076fdc000 task.ti: 
ffff880076fdc000
[   53.568464] RIP: 0010:[<ffffffff81717436>]  [<ffffffff81717436>] 
_raw_spin_lock+0x16/0x60
[   53.568464] RSP: 0018:ffff880076fdfa48  EFLAGS: 00010282
[   53.568464] RAX: 0000000000020000 RBX: ffff880035331900 RCX: 
0000000000000000
[   53.568464] RDX: ffff88007fd8f238 RSI: ffff88007fd8d318 RDI: 
00000000000000a0
[   53.568464] RBP: ffff880076fdfa48 R08: 0000000000000096 R09: 
0000000000000000
[   53.568464] R10: 00000000000002de R11: ffff880076fdf64e R12: 
0000000000000001
[   53.568464] R13: 0000000000000001 R14: 0000000000000000 R15: 
0000000000000000
[   53.568464] FS:  00007ff569ee7880(0000) GS:ffff88007fd80000(0000) 
knlGS:0000000000000000
[   53.568464] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   53.568464] CR2: 00000000000000a0 CR3: 0000000076f07000 CR4: 
00000000000406e0
[   53.568464] Stack:
[   53.568464]  ffff880076fdfa98 ffffffffc0989247 00000000000000a0 
0000000000031001
[   53.568464]  ffff880076fdfac8 ffff880035331900 0000000000000001 
0000000000000001
[   53.568464]  ffff880076fdfbb8 0000000000000001 ffff880076fdfae8 
ffffffffc09894ba
[   53.568464] Call Trace:
[   53.568464]  [<ffffffffc0989247>] _xfs_buf_find+0x97/0x2e0 [xfs]
[   53.568464]  [<ffffffffc09894ba>] xfs_buf_get_map+0x2a/0x210 [xfs]
[   53.568464]  [<ffffffffc098a1d3>] ? _xfs_buf_read+0x23/0x40 [xfs]
[   53.568464]  [<ffffffffc098a21c>] xfs_buf_read_map+0x2c/0x190 [xfs]
[   53.568464]  [<ffffffffc09bb969>] xfs_trans_read_buf_map+0x1e9/0x490 
[xfs]
[   53.568464]  [<ffffffffc094ae04>] xfs_read_agf+0x84/0x110 [xfs]
[   53.568464]  [<ffffffffc094aedb>] xfs_alloc_read_agf+0x4b/0x150 [xfs]
[   53.568464]  [<ffffffffc094affa>] xfs_alloc_pagf_init+0x1a/0x40 [xfs]
[   53.568464]  [<ffffffffc097e690>] xfs_initialize_perag_data+0xa0/0x120 
[xfs]
[   53.568464]  [<ffffffffc09a4972>] xfs_mountfs+0x5d2/0x7b0 [xfs]
[   53.568464]  [<ffffffffc09a810a>] xfs_fs_fill_super+0x2ca/0x360 [xfs]
[   53.568464]  [<ffffffff811eb220>] mount_bdev+0x1b0/0x1f0
[   53.568464]  [<ffffffffc09a7e40>] ? xfs_parseargs+0xbe0/0xbe0 [xfs]
[   53.568464]  [<ffffffffc09a5dd5>] xfs_fs_mount+0x15/0x20 [xfs]
[   53.568464]  [<ffffffff811ebb79>] mount_fs+0x39/0x1b0
[   53.568464]  [<ffffffff81192fc5>] ? __alloc_percpu+0x15/0x20
[   53.568464]  [<ffffffff812070db>] vfs_kern_mount+0x6b/0x120
[   53.568464]  [<ffffffff8120a032>] do_mount+0x222/0xca0
[   53.568464]  [<ffffffff8120adab>] SyS_mount+0x8b/0xe0
[   53.568464]  [<ffffffff817179cd>] system_call_fastpath+0x16/0x1b


-----Original Message----- 
From: Dave Chinner
Sent: 23 February, 2016 1:56 AM
To: Alex Lyakas
Cc: xfs@oss.sgi.com ; Christoph Hellwig ; Danny Shavit
Subject: Re: xfs resize: primary superblock is not updated immediately

On Tue, Feb 23, 2016 at 12:38:48AM +0200, Alex Lyakas wrote:
> Hi Dave,
> Thanks for your response.
>
> I am not freezing the filesystem before the snapshot.

There's your problem. A mounted filesystem is not consistent on disk
without flushing the entire journal and all the dirty metadata to
disk.

> However, let's assume that somebody resized the XFS, and it completed
> and got back to user-space. At this moment the primary superblock
> on-disk is not updated yet with the new agcount. And at this same
> moment there is a power-out. After the power comes back and the
> machine boots, if we mount the XFS, the same problem would happen, I
> believe.

Log recovery will run and update the superblock buffer with the correct
values. But the in-memory superblock that log recoery is working
with does not change, and so if there were accesses beyond the
current superblock ag/block count you'd see messages like this:

XFS (sda1): _xfs_buf_find: Block out of range: block 0xnnnnn EOFS 0xmmmmm

and log recovery should fail at that point because it can't pull in
a buffer it needs for recovery to make further progress. At which
point, you have an unmountable filesystem.

If log recovery succeeds, then yes, I can see that there is a
problem here because the per-ag tree is not reinitialised after the
superblock is re-read. That's a pretty easy fix, though (3-4 lines
of code in xlog_do_recover() to detect a change in filesystem block
count and call xfs_initialize_perag() again.

> Taking a block-level snapshot is exactly like a power-out from XFS
> perspective.

It's similar, but it's not the same. e.g. there are no issues like
volatile storage cache loss that have to be handled.

> And XFS should, in principle, be able to recover from
> that.

For some definition of recover. There is no guarantee that any of
the async transactions in memory will make it to disk, so the point
to which XFS can recover is undefined.

> The snapshot will come up as a new block device, which exhibits
> identical content as the original block device had at the moment when
> the snapshot was taken (like a boot after power-out).

The block device might be identical, but it's not identical to what
the filesystem is presenting the user. Any user dirty data cached in
memory, or metadata changes staged in the CIL will not be in the
snapshot. Hence the snapshot block device is not identical to the
original user visible state and data. You only get that if you
freeze the filesystem before taking the snapshot.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
