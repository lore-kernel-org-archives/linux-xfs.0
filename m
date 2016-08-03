Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 589AE7CA3
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 11:25:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 28DD5304032
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 09:25:06 -0700 (PDT)
Received: from mail-qt0-f193.google.com (mail-qt0-f193.google.com
	[209.85.216.193]) by cuda.sgi.com with ESMTP id
	KWYF2jyihPrxBuZv (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 03 Aug 2016 09:25:04 -0700 (PDT)
Received: by mail-qt0-f193.google.com with SMTP id q11so11235509qtb.2
	for <xfs@oss.sgi.com>; Wed, 03 Aug 2016 09:25:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1465155145-10812-43-git-send-email-mchristi@redhat.com>
References: <1465155145-10812-1-git-send-email-mchristi@redhat.com>
	<1465155145-10812-43-git-send-email-mchristi@redhat.com>
From: Ross Zwisler <zwisler@gmail.com>
Date: Wed, 3 Aug 2016 10:25:02 -0600
Message-ID: <CAOxpaSVzkR+9anramDg7nHxjb5hp0q_oKGRdEpiU07jWM=tzdQ@mail.gmail.com>
Subject: Re: [PATCH 42/45] block, fs, drivers: remove REQ_OP compat defs and
	related code
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
To: mchristi@redhat.com, axboe@fb.com, Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, XFS Developers <xfs@oss.sgi.com>, ocfs2-devel@oss.oracle.com, linux-scsi@vger.kernel.org, konrad.wilk@oracle.com, LKML <linux-kernel@vger.kernel.org>, philipp.reisner@linbit.com, linux-f2fs-devel@lists.sourceforge.net, linux-raid@vger.kernel.org, dm-devel@redhat.com, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, osd-dev@open-osd.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, lars.ellenberg@linbit.com, linux-ext4 <linux-ext4@vger.kernel.org>, linux-btrfs@vger.kernel.org, drbd-dev@lists.linbit.com

On Sun, Jun 5, 2016 at 1:32 PM,  <mchristi@redhat.com> wrote:
> From: Mike Christie <mchristi@redhat.com>
>
> This patch drops the compat definition of req_op where it matches
> the rq_flag_bits definitions, and drops the related old and compat
> code that allowed users to set either the op or flags for the operation.
>
> We also then store the operation in the bi_rw/cmd_flags field similar
> to how we used to store the bio ioprio where it sat in the upper bits
> of the field.
>
> Signed-off-by: Mike Christie <mchristi@redhat.com>

I was doing some xfstests testing yesterday using linux/master, and
hit a kernel BUG that bisected to this change.  The failing test is
generic/008 + ext2, without DAX.  This BUG reproduces with this test
100% as of this change, and 0% with the previous commit.

Here's the kernel commit that I bisected to:

commit 4e1b2d52a80d79296a5d899d73249748dea71a53
Author: Mike Christie <mchristi@redhat.com>
Date:   Sun Jun 5 14:32:22 2016 -0500

block, fs, drivers: remove REQ_OP compat defs and related code

Here are the steps to reproduce the BUG using a pair of 1 GiB BRD ramdisks:

SCRATCH_DEV=/dev/ram0
TEST_DEV=/dev/ram1
mkfs.ext2 -F $SCRATCH_DEV
mkfs.ext2 -F $TEST_DEV
cd ~/xfstests
./check generic/008

Here is the BUG output for that commit, passed through
kasan_symbolize.py.  The line numbers are for the commit listed above,
not for linux/master:

 run fstests generic/008 at 2016-08-03 09:54:56
page:ffffea0017af04c0 count:3 mapcount:0 mapping:ffff8805eb059200 index:0x0
flags: 0x3fff8000002828(uptodate|lru|private|writeback)
page dumped because: VM_BUG_ON_PAGE(!PageLocked(page))
page->mem_cgroup:ffff8806098e0800
------------[ cut here ]------------
kernel BUG at mm/filemap.c:833!
invalid opcode: 0000 [#1] SMP
Modules linked in: brd dax_pmem nd_pmem dax nd_btt nd_e820 libnvdimm
CPU: 0 PID: 2522 Comm: xfs_io Not tainted 4.7.0-rc2-00042-g4e1b2d52 #18
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.9.1-0-gb3ef39f-prebuilt.qemu-project.org 04/01/2014
task: ffff8805ebae4ec0 ti: ffff8805eba3c000 task.ti: ffff8805eba3c000
RIP: 0010:[<ffffffff811de115>] [<ffffffff811de115>] unlock_page+0xa5/0xb0
RSP: 0018:ffff8805eba3fa60 EFLAGS: 00010282
RAX: 0000000000000021 RBX: 0000000000000000 RCX: 0000000000000006
RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff8806109ce200
RBP: ffff8805eba3fa60 R08: 0000000000000001 R09: 0000000000000001
R10: ffff8805ebae4ec0 R11: 0000000000000001 R12: ffffea0017af04c0
R13: 0000000000028000 R14: ffffffffa00202c0 R15: ffff88060eff1200
FS: 00007f87a31cf700(0000) GS:ffff880610800000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f87a31e6000 CR3: 000000060da31000 CR4: 00000000001406f0
Stack:
ffff8805eba3fa98 ffffffff812bd782 ffff8805eba3fdb0 0000000000001000
ffffea0017af04c0 0000000000000000 0000000000000088 ffff8805eba3fbe0
ffffffff812c3ff1 ffff8805eba3fd00 0000000000028000 0000000c00000000
Call Trace:
[<ffffffff812bd782>] bdev_write_page+0xb2/0xe0 fs/block_dev.c:462
[<ffffffff812c3ff1>] __mpage_writepage+0x5c1/0x750 fs/mpage.c:604
[<ffffffff811eedbd>] write_cache_pages+0x20d/0x5f0 mm/page-writeback.c:2261
[<ffffffff812c3955>] mpage_writepages+0x75/0xe0 fs/mpage.c:703
[<ffffffff8137951b>] ext2_writepages+0x3b/0x40 fs/ext2/inode.c:887
[<ffffffff811f27a1>] do_writepages+0x21/0x30 mm/page-writeback.c:2361
[<ffffffff811e1396>] __filemap_fdatawrite_range+0xc6/0x100 mm/filemap.c:300
[<ffffffff811e1514>] filemap_write_and_wait_range+0x44/0x90 mm/filemap.c:490
[<ffffffff812a7707>] __generic_file_fsync+0x27/0x90 fs/libfs.c:937
[<ffffffff812a7789>] generic_file_fsync+0x19/0x40 fs/libfs.c:974
[<ffffffff81377e9e>] ext2_fsync+0x2e/0x70 fs/ext2/file.c:149
[<ffffffff812b549b>] vfs_fsync_range+0x4b/0xb0 fs/sync.c:195
[< inline >] vfs_fsync fs/sync.c:209
[<ffffffff812b555d>] do_fsync+0x3d/0x70 fs/sync.c:219
[< inline >] SYSC_fsync fs/sync.c:227
[<ffffffff812b5810>] SyS_fsync+0x10/0x20 fs/sync.c:225
[<ffffffff81acd33c>] entry_SYSCALL_64_fastpath+0x1f/0xbd
arch/x86/entry/entry_64.S:207
Code: 00 00 48 d3 ea 89 d2 48 8d 0c 92 48 8d 14 4a 48 8d 3c d0 31 d2
e8 bc fc f1 ff 5d c3 48 c7 c6 20 1d ec 81 4c 89 c7 e8 bb 8d 03 00 <0f>
0b 66 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55 b9 08 00 00
RIP [<ffffffff811de115>] unlock_page+0xa5/0xb0 mm/filemap.c:833
RSP <ffff8805eba3fa60>
---[ end trace d419bf59bba263fb ]---

I'm happy to provide any additional info you need, or to test fixes.

Thanks,
- Ross

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
