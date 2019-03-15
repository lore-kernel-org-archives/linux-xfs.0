Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38866 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726791AbfCODqj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Mar 2019 23:46:39 -0400
Date: Fri, 15 Mar 2019 11:50:36 +0800
From: Zorro Lang <zlang@redhat.com>
Subject: Re: [ANNOUNCE] xfs-linux: for-next updated to 6ef50fe9afae
Message-ID: <20190315035036.GN7200@dhcp-12-102.nay.redhat.com>
References: <20190313163243.GI4359@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190313163243.GI4359@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Wed, Mar 13, 2019 at 09:32:43AM -0700, Darrick J. Wong wrote:
> Hi folks,
> 
> The for-next branch of the xfs-linux repository at:
> 
> 	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git
> 
> has just been updated.
> 
> Patches often get missed, so please check if your outstanding
> patches were in this update. If they have not been in this update,
> please resubmit them to linux-xfs@vger.kernel.org so they can be
> picked up in the next update.
> 
> The new head of the for-next branch is commit:
> 
> 6ef50fe9afae xfs: clean up xfs_dir2_leaf_addname

XFS tier1/2 regression/functional/stress test nearly done, no obvious error can
be reproducible. Trying to loop run some failed cases. Some details as below:

[0]
Hit 3 times NFS panic, when test on NFS base on XFS. It's a known issue which
fixed on Linux v5.0-rc7. These test has to ben interrupted.

[1]
Hit once shared/010 fails on an aarch64(64k pagesize) machine, but haven't got
chance to reproduce it again:
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/aarch64 xxx.xxx.xxx.xxx 5.0.0-rc6
MKFS_OPTIONS  -- -f -m crc=1,finobt=1,rmapbt=1,reflink=1 -i sparse=1 /dev/sda4
MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 /dev/sda4 /mnt/xfstests/mnt2

shared/010	- output mismatch (see /var/lib/xfstests/results//shared/010.out.bad)
    --- tests/shared/010.out	2019-03-14 00:15:41.016366697 -0400
    +++ /var/lib/xfstests/results//shared/010.out.bad	2019-03-14 03:03:16.660309118 -0400
    @@ -1,2 +1,4 @@
     QA output created by 010
    +/mnt/xfstests/mnt2/dir/p0/d1XXXXX/d2cXXXXXXXXXX/d7bdXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/d1267XXXXXXXXXXXXXXXX/d2dffXXXXXXXX/f2ff0XXXXXXX: FAILED
    +md5sum: WARNING: 1 computed checksum did NOT match
     Silence is golden
    ...
    (Run 'diff -u /var/lib/xfstests/tests/shared/010.out /var/lib/xfstests/results//shared/010.out.bad'  to see the entire diff)
Ran: shared/010
Failures: shared/010
Failed 1 of 1 tests

[2]
Hit once generic/418 fails on x86_64, when it run "diotest -wp -b 2048 -n 8 -i 4":
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 xxx.xxx.xxx.xx 5.0.0-rc6
MKFS_OPTIONS  -- -f -b size=2048 -m crc=1,finobt=1,rmapbt=0,reflink=1 -i sparse=1 /dev/vda5
MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 /dev/vda5 /mnt/xfstests/mnt2

generic/418	- output mismatch (see /var/lib/xfstests/results//generic/418.out.bad)
    --- tests/generic/418.out	2019-03-14 08:46:07.320192617 -0400
    +++ /var/lib/xfstests/results//generic/418.out.bad	2019-03-14 14:34:35.731791631 -0400
    @@ -1,2 +1,5 @@
     QA output created by 418
    +cmpbuf: offset 0: Expected: 0x1, got 0x0
    +[4:0] FAIL - comparison failed, offset 8192
    +diotest -wp -b 2048 -n 8 -i 4 failed at loop 0
     Silence is golden
    ...
    (Run 'diff -u /var/lib/xfstests/tests/generic/418.out /var/lib/xfstests/results//generic/418.out.bad'  to see the entire diff)
Ran: generic/418
Failures: generic/418
Failed 1 of 1 tests

[3]
And Hit once generic/475 dmesg error on x86_64:
[29451.222118] XFS (dm-0): xfs_dabuf_map: bno 16777216 dir: inode 16797760
[29451.222123] XFS (dm-0): [00] br_startoff 16777216 br_startblock -2 br_blockcount 2 br_state 0
[29451.222239] XFS (dm-0): Internal error xfs_da_do_buf(1) at line 2577 of file fs/xfs/libxfs/xfs_da_btree.c.  Caller xfs_da_read_buf+0x68/0x110 [xfs]
[29451.222244] XFS (dm-0): metadata I/O error in "xfs_trans_read_buf_map" at daddr 0x3270 len 4 error 5
[29451.222254] CPU: 3 PID: 24483 Comm: fsstress Tainted: G        W         5.0.0-rc6 #1
[29451.222257] XFS (dm-0): page discard on page 0000000021f9ff4f, inode 0x3d1e3, offset 323584.
[29451.222259] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2007
[29451.222261] Call Trace:
[29451.222276]  dump_stack+0x46/0x60
[29451.222278] XFS (dm-0): metadata I/O error in "xfs_trans_read_buf_map" at daddr 0x3270 len 4 error 5
[29451.222332]  xfs_dabuf_map.constprop.18+0x10c/0x390 [xfs]
[29451.222334] XFS (dm-0): page discard on page 000000008631c468, inode 0x3d1e3, offset 327680.
[29451.222388]  xfs_da_read_buf+0x68/0x110 [xfs]
[29451.222390] XFS (dm-0): metadata I/O error in "xfs_trans_read_buf_map" at daddr 0x18 len 4 error 5
[29451.222441]  xfs_da3_node_read+0x17/0xd0 [xfs]
[29451.222444] XFS (dm-0): page discard on page 0000000051fc0a12, inode 0x3d1e3, offset 331776.
[29451.222495]  xfs_da3_node_lookup_int+0x70/0x3f0 [xfs]
[29451.222498] XFS (dm-0): metadata I/O error in "xfs_trans_read_buf_map" at daddr 0x18 len 4 error 5
[29451.222503] XFS (dm-0): page discard on page 00000000298f4bdb, inode 0x3d1e3, offset 335872.
[29451.222508]  ? _cond_resched+0x15/0x30
[29451.222562]  xfs_dir2_node_lookup+0x4b/0x170 [xfs]
[29451.222564] XFS (dm-0): metadata I/O error in "xfs_trans_read_buf_map" at daddr 0x18 len 4 error 5
[29451.222615]  xfs_dir_lookup+0x1b8/0x1d0 [xfs]
[29451.222618] XFS (dm-0): page discard on page 00000000c53e4d6f, inode 0x3d1e3, offset 339968.
[29451.222682]  xfs_lookup+0x58/0x120 [xfs]
[29451.222748]  xfs_vn_lookup+0x70/0xa0 [xfs]
[29451.222756]  __lookup_hash+0x71/0xa0
[29451.222761]  ? down_write+0xe/0x40
[29451.222765]  do_renameat2+0x2f6/0x530
[29451.222770]  __x64_sys_rename+0x1c/0x20
[29451.222776]  do_syscall_64+0x55/0x1a0
[29451.222781]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[29451.222786] RIP: 0033:0x7f2ac0958c2b
[29451.222790] Code: e8 2a 03 08 00 85 c0 0f 95 c0 0f b6 c0 f7 d8 5b c3 66 0f 1f 44 00 00 b8 ff ff ff ff 5b c3 90 f3 0f 1e fa b8 52 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 05 c3 0f 1f 40 00 48 8b 15 29 f2 34 00 f7 d8
[29451.222793] RSP: 002b:00007ffea6a494a8 EFLAGS: 00000202 ORIG_RAX: 0000000000000052
[29451.222797] RAX: ffffffffffffffda RBX: 000000000000001c RCX: 00007f2ac0958c2b
[29451.222799] RDX: 0000000000000000 RSI: 0000000001c39480 RDI: 0000000001c393d0
[29451.222801] RBP: 00007ffea6a49730 R08: fefefefefefefeff R09: fefefefefeff3265
[29451.222803] R10: 0000000000000000 R11: 0000000000000202 R12: 00007ffea6a49740
[29451.222805] R13: 0000000000409c10 R14: 0000000000000000 R15: 0000000000000000
[29451.223011] XFS (dm-0): xfs_dabuf_map: bno 16777216 dir: inode 16797760
[29451.223015] XFS (dm-0): [00] br_startoff 16777216 br_startblock -2 br_blockcount 2 br_state 0
[29451.223072] XFS (dm-0): Internal error xfs_da_do_buf(1) at line 2577 of file fs/xfs/libxfs/xfs_da_btree.c.  Caller xfs_da_read_buf+0x68/0x110 [xfs]
[29451.223120] CPU: 3 PID: 24483 Comm: fsstress Tainted: G        W         5.0.0-rc6 #1
[29451.223122] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2007
[29451.223123] Call Trace:
[29451.223148]  dump_stack+0x46/0x60
[29451.223223]  xfs_dabuf_map.constprop.18+0x10c/0x390 [xfs]
[29451.223299]  ? xfs_quota_calc_throttle+0xb0/0xb0 [xfs]
[29451.223306]  ? iomap_apply+0xe8/0x130
[29451.223359]  xfs_da_read_buf+0x68/0x110 [xfs]
[29451.223412]  xfs_da3_node_read+0x17/0xd0 [xfs]
[29451.223464]  xfs_da3_node_lookup_int+0x70/0x3f0 [xfs]
[29451.223468]  ? _cond_resched+0x15/0x30
[29451.223522]  xfs_dir2_node_lookup+0x4b/0x170 [xfs]
[29451.223575]  xfs_dir_lookup+0x1b8/0x1d0 [xfs]
[29451.223642]  xfs_lookup+0x58/0x120 [xfs]
[29451.223706]  xfs_vn_lookup+0x70/0xa0 [xfs]
[29451.223713]  ? security_inode_create+0x37/0x50
[29451.223717]  path_openat+0x987/0x1670
[29451.223723]  ? tlb_flush_mmu_free+0x14/0x50
[29451.223727]  do_filp_open+0x93/0x100
[29451.223733]  ? __check_object_size+0x15d/0x189
[29451.223739]  do_sys_open+0x186/0x220
[29451.223744]  do_syscall_64+0x55/0x1a0
[29451.223749]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[29451.223753] RIP: 0033:0x7f2ac09d7bb8
[29451.223756] Code: 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 8d 05 65 5b 2d 00 8b 00 85 c0 75 17 b8 55 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 48 c3 0f 1f 80 00 00 00 00 55 89 f5 53 48 89
[29451.223758] RSP: 002b:00007ffea6a495d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000055
[29451.223762] RAX: ffffffffffffffda RBX: 00000000ffffffff RCX: 00007f2ac09d7bb8
[29451.223764] RDX: 0000000000000000 RSI: 00000000000001b6 RDI: 0000000001c393d0
[29451.223766] RBP: 00007ffea6a49730 R08: fefefefefefefeff R09: feff7efda4ff3365
[29451.223768] R10: 0000000000000000 R11: 0000000000000246 R12: 00000000000001b6
[29451.223770] R13: 0000000000404320 R14: 0000000000000000 R15: 0000000000000000
[29451.223891] XFS (dm-0): xfs_dabuf_map: bno 16777216 dir: inode 16797760
[29451.223946] XFS (dm-0): metadata I/O error in "xfs_trans_read_buf_map" at daddr 0x1d4e0 len 32 error 5
[29451.223955] XFS (dm-0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
[29451.224316] XFS (dm-0): metadata I/O error in "xfs_trans_read_buf_map" at daddr 0x780003 len 1 error 5
[29451.224566] XFS (dm-0): metadata I/O error in "xlog_iodone" at daddr 0xf04849 len 64 error 5
[29451.224604] XFS (dm-0): xfs_do_force_shutdown(0x2) called from line 1271 of file fs/xfs/xfs_log.c. Return address = 0000000050cd81b6
[29451.224606] XFS (dm-0): Log I/O Error Detected. Shutting down filesystem
[29451.224608] XFS (dm-0): Please unmount the filesystem and rectify the problem(s)
[29451.232905] Buffer I/O error on dev dm-0, logical block 31457152, async page read
[29451.234256] XFS (dm-0): [00] br_startoff 16777216 br_startblock -2 br_blockcount 2 br_state 0

> 
> New Commits:
> 
> Darrick J. Wong (3):
>       [79622c7ce687] xfs: clean up xfs_dir2_leafn_add
>       [f51fac689262] xfs: zero initialize highstale and lowstale in xfs_dir2_leaf_addname
>       [6ef50fe9afae] xfs: clean up xfs_dir2_leaf_addname
> 
> Nathan Chancellor (1):
>       [7be73fa1c1b0] xfs: Zero initialize highstale and lowstale in xfs_dir2_leafn_add
> 
> 
> Code Diffstat:
> 
>  fs/xfs/libxfs/xfs_dir2_leaf.c | 37 +++++++++++++++++--------------------
>  fs/xfs/libxfs/xfs_dir2_node.c | 18 ++++++++----------
>  2 files changed, 25 insertions(+), 30 deletions(-)
