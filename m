Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DB6407CA2
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2016 17:54:18 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5000DAC006
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2016 15:54:18 -0800 (PST)
Received: from mga04.intel.com ([192.55.52.120]) by cuda.sgi.com with ESMTP id
	G3d3N2TTL844gTRj for <xfs@oss.sgi.com>;
	Tue, 16 Feb 2016 15:54:16 -0800 (PST)
Date: Tue, 16 Feb 2016 16:53:53 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 0/4] xfs: fixes for XFS_DIFLAG2_DAX support
Message-ID: <20160216235353.GA25419@linux.intel.com>
References: <1455513734-15192-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1455513734-15192-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: ross.zwisler@linux.intel.com, jack@suse.cz, xfs@oss.sgi.com

On Mon, Feb 15, 2016 at 04:22:10PM +1100, Dave Chinner wrote:
> Hi folks,
> 
> This is a series to add the correct constraints to using the on-disk
> inode flag to enable DAX on per-file basis. The same constraints are
> placed on setting the flag on directories for inheritance purposes.
> 
> These constraints are:
> 	- the inode flag is limited to regular files or directory
> 	  inodes.
> 	- the S_DAX flag is only ever set on regular files
> 	- the flag can only ever be set on filesystems which have
> 	  blocksize == PAGE_SIZE (for now)
> 	- When the flag is set or cleared, the current mapping
> 	  contents are flushed and then invalidated so that the new
> 	  access mode starts with an empty mapping.
> 	- Setting or clearing the flag is atomic w.r.t. IO and
> 	  page faults.
> 
> I've tested these manually with xfs_io (patchset for supporting
> chattr +x/-x to be sent soon), and it all appears to work as
> expected. I'd like to push these for 4.5-rc6 so the initial kernel
> with support for this flag doesn't do silly things, so comments,
> testing and review woul dbe appreciated.

I'm seeing the following errors with xfs/305 when running these four patches +
v4.5-rc4:

================================================
[ BUG: lock held when returning to user space! ]
4.5.0-rc4+ #4 Not tainted
------------------------------------------------
fsstress/2311 is leaving the kernel with locks still held!
2 locks held by fsstress/2311:
 #0:  (&(&ip->i_iolock)->mr_lock){++++++}, at: [<     inline     >] mrupdate_nested fs/xfs/mrlock.h:48
 #0:  (&(&ip->i_iolock)->mr_lock){++++++}, at: [<ffffffff8149ba82>] xfs_ilock+0x152/0x1f0 fs/xfs/xfs_inode.c:170
 #1:  (&(&ip->i_mmaplock)->mr_lock){+.+.+.}, at: [<     inline     >] mrupdate_nested fs/xfs/mrlock.h:48
 #1:  (&(&ip->i_mmaplock)->mr_lock){+.+.+.}, at: [<ffffffff8149baad>] xfs_ilock+0x17d/0x1f0 fs/xfs/xfs_inode.c:175
XFS: Assertion failed: !rwsem_is_locked(&ip->i_iolock.mr_lock), file: fs/xfs/xfs_super.c, line: 981
------------[ cut here ]------------
kernel BUG at fs/xfs/xfs_message.c:113!
invalid opcode: 0000 [#1] SMP
Modules linked in: nd_pmem nd_btt nd_e820 libnvdimm
CPU: 1 PID: 2332 Comm: fsstress Not tainted 4.5.0-rc4+ #4
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.8.2-20150714_191134- 04/01/2014
task: ffff88009a093180 ti: ffff88009993c000 task.ti: ffff88009993c000
RIP: 0010:[<ffffffff814a3830>]  [<ffffffff814a3830>] assfail+0x20/0x30
RSP: 0018:ffff88009993fe30  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88009843f018 RCX: 0000000000000000
RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffff81ee7c48
RBP: ffff88009993fe30 R08: 0000000000000000 R09: 0000000000000000
R10: 000000000000000a R11: f000000000000000 R12: ffff88009843ec80
R13: ffff88009843f018 R14: ffff88009843f0a0 R15: ffff88009843f018
FS:  00007f5dfda64700(0000) GS:ffff88051a200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f5dfd8c1008 CR3: 000000009a20a000 CR4: 00000000000006e0
Stack:
 ffff88009993fe58 ffffffff814a659a ffff88009843f018 ffff88009843f1f0
 ffffffff81c52e40 ffff88009993fe80 ffffffff8127e608 ffff880097112000
 ffff88009843f018 ffffffff81c52e40 ffff88009993feb0 ffffffff8127e8db
Call Trace:
 [<ffffffff814a659a>] xfs_fs_evict_inode+0x3a/0x110 fs/xfs/xfs_super.c:981
 [<ffffffff8127e608>] evict+0xb8/0x180 fs/inode.c:542
 [<     inline     >] iput_final fs/inode.c:1477
 [<ffffffff8127e8db>] iput+0x1ab/0x230 fs/inode.c:1504
 [<ffffffff81270df1>] do_unlinkat+0x1d1/0x2a0 fs/namei.c:3939
 [<     inline     >] SYSC_unlink fs/namei.c:3980
 [<ffffffff812718e6>] SyS_unlink+0x16/0x20 fs/namei.c:3978
 [<ffffffff81a6b2f2>] entry_SYSCALL_64_fastpath+0x12/0x76 arch/x86/entry/entry_64.S:185
Code: 66 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55 48 89 f1 41 89 d0 48 c7 c6 b8 cc f2 81 48 89 fa 31 ff 48 89 e5 e8 b0 f8 ff ff <0f> 0b 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90
RIP  [<ffffffff814a3830>] assfail+0x20/0x30 fs/xfs/xfs_message.c:111
 RSP <ffff88009993fe30>
---[ end trace 1f81c918d4ac8110 ]---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
