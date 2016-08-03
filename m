Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9BC767CA1
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 17:33:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E2536AC003
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 15:33:18 -0700 (PDT)
Received: from mail-qk0-f195.google.com (mail-qk0-f195.google.com
	[209.85.220.195]) by cuda.sgi.com with ESMTP id
	bJDVrTLhrpCXBt7m (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 03 Aug 2016 15:33:16 -0700 (PDT)
Received: by mail-qk0-f195.google.com with SMTP id x185so1720842qkc.3
	for <xfs@oss.sgi.com>; Wed, 03 Aug 2016 15:33:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1465155145-10812-38-git-send-email-mchristi@redhat.com>
References: <1465155145-10812-1-git-send-email-mchristi@redhat.com>
	<1465155145-10812-38-git-send-email-mchristi@redhat.com>
From: Ross Zwisler <zwisler@gmail.com>
Date: Wed, 3 Aug 2016 16:33:15 -0600
Message-ID: <CAOxpaSUMsgfTYsL0bL6VCnwxz7bpgpKO-ZfC5J8dFG9PN-hzvg@mail.gmail.com>
Subject: Re: [PATCH 37/45] drivers: use req op accessor
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
To: Mike Christie <mchristi@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Dave Chinner <david@fromorbit.com>, axboe@fb.com
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, XFS Developers <xfs@oss.sgi.com>, ocfs2-devel@oss.oracle.com, linux-scsi@vger.kernel.org, konrad.wilk@oracle.com, LKML <linux-kernel@vger.kernel.org>, philipp.reisner@linbit.com, linux-f2fs-devel@lists.sourceforge.net, linux-raid@vger.kernel.org, dm-devel@redhat.com, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, osd-dev@open-osd.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, lars.ellenberg@linbit.com, linux-ext4 <linux-ext4@vger.kernel.org>, linux-btrfs@vger.kernel.org, drbd-dev@lists.linbit.com

On Sun, Jun 5, 2016 at 1:32 PM,  <mchristi@redhat.com> wrote:
> From: Mike Christie <mchristi@redhat.com>
>
> The req operation REQ_OP is separated from the rq_flag_bits
> definition. This converts the block layer drivers to
> use req_op to get the op from the request struct.
>
> Signed-off-by: Mike Christie <mchristi@redhat.com>
> ---
>  drivers/block/loop.c              |  6 +++---
>  drivers/block/mtip32xx/mtip32xx.c |  2 +-
>  drivers/block/nbd.c               |  2 +-
>  drivers/block/rbd.c               |  4 ++--
>  drivers/block/xen-blkfront.c      |  8 +++++---
>  drivers/ide/ide-floppy.c          |  2 +-
>  drivers/md/dm.c                   |  2 +-
>  drivers/mmc/card/block.c          |  7 +++----
>  drivers/mmc/card/queue.c          |  6 ++----

Dave Chinner reported a deadlock with XFS + DAX, which I reproduced
and bisected to this commit:

commit c2df40dfb8c015211ec55f4b1dd0587f875c7b34
Author: Mike Christie <mchristi@redhat.com>
Date:   Sun Jun 5 14:32:17 2016 -0500
drivers: use req op accessor

Here are the steps to reproduce the deadlock with a BRD ramdisk:

mkfs.xfs -f /dev/ram0
mount -o dax /dev/ram0 /mnt/scratch
xfs_io -f -c "truncate 1g" /mnt/scratch/test.img
losetup -f --show /mnt/scratch/test.img
mkfs.xfs -f /dev/loop0

At this point the mkfs.xfs deadlocks.  Here is the stack trace
gathered via "echo w > /proc/sysrq-trigger" and passed through
kasan_symbolize.py:

brd: module loaded
XFS (ram0): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
XFS (ram0): Mounting V5 Filesystem
XFS (ram0): Ending clean mount
sysrq: SysRq : Show Blocked State
  task                        PC stack   pid father
mkfs.xfs        D ffff88060ae47b38     0  1482   1287 0x00000000
 ffff88060ae47b38 00000000000079e8 ffff880610fd8d98 ffff880036011a40
 ffff8800aa6dcec0 ffff88060ae48000 ffff880610fd8d80 7fffffffffffffff
 ffff8800aa6dcec0 00000000024000c0 ffff88060ae47b50 ffffffff81aca775
Call Trace:
 [<ffffffff81aca775>] schedule+0x35/0x80 kernel/sched/core.c:3360
 [<ffffffff81acf431>] schedule_timeout+0x271/0x460 kernel/time/timer.c:1493
 [<ffffffff81ac9c34>] io_schedule_timeout+0xa4/0x110 kernel/sched/core.c:4969
 [<     inline     >] do_wait_for_common kernel/sched/completion.c:75
 [<     inline     >] __wait_for_common kernel/sched/completion.c:93
 [<     inline     >] wait_for_common_io kernel/sched/completion.c:107
 [<ffffffff81acb33f>] wait_for_completion_io+0xdf/0x120
kernel/sched/completion.c:155
 [<ffffffff81573206>] submit_bio_wait+0x66/0x90 block/bio.c:870
 [<ffffffff81588016>] blkdev_issue_discard+0x86/0xc0 block/blk-lib.c:115
 [<ffffffff8158ea23>] blk_ioctl_discard+0xa3/0xd0 block/ioctl.c:221
 [<ffffffff8158f5da>] blkdev_ioctl+0x60a/0x9e0 block/ioctl.c:510
 [<ffffffff812bddb3>] block_ioctl+0x43/0x50 fs/block_dev.c:1714
 [<     inline     >] vfs_ioctl fs/ioctl.c:43
 [<ffffffff8128ec72>] do_vfs_ioctl+0xa2/0x6a0 fs/ioctl.c:674
 [<     inline     >] SYSC_ioctl fs/ioctl.c:689
 [<ffffffff8128f2e9>] SyS_ioctl+0x79/0x90 fs/ioctl.c:680
 [<ffffffff81ad0abc>] entry_SYSCALL_64_fastpath+0x1f/0xbd
arch/x86/entry/entry_64.S:207

The line numbers are for the commit above, not for linux/master.  This
occurs 100% as of this commit, and 0% with the previous commit.

This doesn't occur if you don't use DAX, but based on the content of
the commit I'm guessing that difference is due to variations in the
way the two paths use discard.

- Ross

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
