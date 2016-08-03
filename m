Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3EBA87CA1
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 12:28:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 99CF6AC002
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 10:28:46 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id KDJQEKgDDYDSDmvu (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 03 Aug 2016 10:28:45 -0700 (PDT)
Subject: Re: [PATCH 42/45] block, fs, drivers: remove REQ_OP compat defs and
	related code
References: <1465155145-10812-1-git-send-email-mchristi@redhat.com>
	<1465155145-10812-43-git-send-email-mchristi@redhat.com>
	<CAOxpaSVzkR+9anramDg7nHxjb5hp0q_oKGRdEpiU07jWM=tzdQ@mail.gmail.com>
From: Mike Christie <mchristi@redhat.com>
Message-ID: <57A229C7.6010102@redhat.com>
Date: Wed, 3 Aug 2016 12:28:39 -0500
MIME-Version: 1.0
In-Reply-To: <CAOxpaSVzkR+9anramDg7nHxjb5hp0q_oKGRdEpiU07jWM=tzdQ@mail.gmail.com>
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
To: Ross Zwisler <zwisler@gmail.com>, axboe@fb.com, Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, XFS Developers <xfs@oss.sgi.com>, ocfs2-devel@oss.oracle.com, linux-scsi@vger.kernel.org, konrad.wilk@oracle.com, LKML <linux-kernel@vger.kernel.org>, philipp.reisner@linbit.com, linux-f2fs-devel@lists.sourceforge.net, linux-raid@vger.kernel.org, dm-devel@redhat.com, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, osd-dev@open-osd.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, lars.ellenberg@linbit.com, linux-ext4 <linux-ext4@vger.kernel.org>, linux-btrfs@vger.kernel.org, drbd-dev@lists.linbit.com

On 08/03/2016 11:25 AM, Ross Zwisler wrote:
>  run fstests generic/008 at 2016-08-03 09:54:56
> page:ffffea0017af04c0 count:3 mapcount:0 mapping:ffff8805eb059200 index:0x0
> flags: 0x3fff8000002828(uptodate|lru|private|writeback)
> page dumped because: VM_BUG_ON_PAGE(!PageLocked(page))
> page->mem_cgroup:ffff8806098e0800
> ------------[ cut here ]------------
> kernel BUG at mm/filemap.c:833!
> invalid opcode: 0000 [#1] SMP
> Modules linked in: brd dax_pmem nd_pmem dax nd_btt nd_e820 libnvdimm
> CPU: 0 PID: 2522 Comm: xfs_io Not tainted 4.7.0-rc2-00042-g4e1b2d52 #18
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> rel-1.9.1-0-gb3ef39f-prebuilt.qemu-project.org 04/01/2014
> task: ffff8805ebae4ec0 ti: ffff8805eba3c000 task.ti: ffff8805eba3c000
> RIP: 0010:[<ffffffff811de115>] [<ffffffff811de115>] unlock_page+0xa5/0xb0
> RSP: 0018:ffff8805eba3fa60 EFLAGS: 00010282
> RAX: 0000000000000021 RBX: 0000000000000000 RCX: 0000000000000006
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff8806109ce200
> RBP: ffff8805eba3fa60 R08: 0000000000000001 R09: 0000000000000001
> R10: ffff8805ebae4ec0 R11: 0000000000000001 R12: ffffea0017af04c0
> R13: 0000000000028000 R14: ffffffffa00202c0 R15: ffff88060eff1200
> FS: 00007f87a31cf700(0000) GS:ffff880610800000(0000) knlGS:0000000000000000
> CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f87a31e6000 CR3: 000000060da31000 CR4: 00000000001406f0
> Stack:
> ffff8805eba3fa98 ffffffff812bd782 ffff8805eba3fdb0 0000000000001000
> ffffea0017af04c0 0000000000000000 0000000000000088 ffff8805eba3fbe0
> ffffffff812c3ff1 ffff8805eba3fd00 0000000000028000 0000000c00000000
> Call Trace:
> [<ffffffff812bd782>] bdev_write_page+0xb2/0xe0 fs/block_dev.c:462
> [<ffffffff812c3ff1>] __mpage_writepage+0x5c1/0x750 fs/mpage.c:604
> [<ffffffff811eedbd>] write_cache_pages+0x20d/0x5f0 mm/page-writeback.c:2261
> [<ffffffff812c3955>] mpage_writepages+0x75/0xe0 fs/mpage.c:703
> [<ffffffff8137951b>] ext2_writepages+0x3b/0x40 fs/ext2/inode.c:887
> [<ffffffff811f27a1>] do_writepages+0x21/0x30 mm/page-writeback.c:2361
> [<ffffffff811e1396>] __filemap_fdatawrite_range+0xc6/0x100 mm/filemap.c:300
> [<ffffffff811e1514>] filemap_write_and_wait_range+0x44/0x90 mm/filemap.c:490
> [<ffffffff812a7707>] __generic_file_fsync+0x27/0x90 fs/libfs.c:937
> [<ffffffff812a7789>] generic_file_fsync+0x19/0x40 fs/libfs.c:974
> [<ffffffff81377e9e>] ext2_fsync+0x2e/0x70 fs/ext2/file.c:149
> [<ffffffff812b549b>] vfs_fsync_range+0x4b/0xb0 fs/sync.c:195
> [< inline >] vfs_fsync fs/sync.c:209
> [<ffffffff812b555d>] do_fsync+0x3d/0x70 fs/sync.c:219
> [< inline >] SYSC_fsync fs/sync.c:227
> [<ffffffff812b5810>] SyS_fsync+0x10/0x20 fs/sync.c:225
> [<ffffffff81acd33c>] entry_SYSCALL_64_fastpath+0x1f/0xbd
> arch/x86/entry/entry_64.S:207
> Code: 00 00 48 d3 ea 89 d2 48 8d 0c 92 48 8d 14 4a 48 8d 3c d0 31 d2
> e8 bc fc f1 ff 5d c3 48 c7 c6 20 1d ec 81 4c 89 c7 e8 bb 8d 03 00 <0f>
> 0b 66 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55 b9 08 00 00
> RIP [<ffffffff811de115>] unlock_page+0xa5/0xb0 mm/filemap.c:833
> RSP <ffff8805eba3fa60>
> ---[ end trace d419bf59bba263fb ]---


Thanks for testing and the detailed bug report. Looks like I missed the
rw_page callback. Testing a patch right now. Should be done in a couple
of hours.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
