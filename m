Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0CDJqmc195077 for <xfs@oss.sgi.com>; Wed, 12 Jan 2011 07:19:52 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EFF6C1D28547
	for <xfs@oss.sgi.com>; Wed, 12 Jan 2011 05:22:05 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id JW2jTgg10K0jYl6b for
	<xfs@oss.sgi.com>; Wed, 12 Jan 2011 05:22:05 -0800 (PST)
Date: Wed, 12 Jan 2011 08:22:05 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] [RFC] xfs: stop using the page cache to back the buffer
	cache
Message-ID: <20110112132205.GA7648@infradead.org>
References: <1294817201-18670-1-git-send-email-david@fromorbit.com>
	<20110112131604.GA28675@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110112131604.GA28675@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

> although I'm not sure it's actually correct.  slub is a pretty
> aggressive in using high order pages and might give us back memory that
> goes across multiple pages.  Adding a loop here to assign multiple pages
> if needed seems safer.

In fact I think I just tripped over it during an xfsqa run, with 4k page
size and 4k blocksize, but just using plain CONFIG_SLAB:

[ 1924.109656] Assertion failed: ((unsigned long)(bp->b_addr + bp->b_buffer_length - 1) & PAGE_MASK) == pageaddr, file: fs/xfs/linux-2.6/xfs_buf.c, line: 325
[ 1924.113437] ------------[ cut here ]------------
[ 1924.114798] kernel BUG at fs/xfs/support/debug.c:108!
[ 1924.116222] invalid opcode: 0000 [#1] SMP 
[ 1924.117359] last sysfs file:
/sys/devices/virtual/block/loop0/removable
[ 1924.117359] Modules linked in:
[ 1924.117359] 
[ 1924.117359] Pid: 716, comm: xfs_growfs Not tainted 2.6.37-rc4-xfs+ #81 /Bochs
[ 1924.117359] EIP: 0060:[<c04f0e1e>] EFLAGS: 00010282 CPU: 0
[ 1924.117359] EIP is at assfail+0x1e/0x30
[ 1924.117359] EAX: 000000a1 EBX: f57e9b10 ECX: ffffff5f EDX: 0000006e
[ 1924.117359] ESI: f49ae000 EDI: f57e9b10 EBP: f42abd50 ESP: f42abd40
[ 1924.117359]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[ 1924.117359] Process xfs_growfs (pid: 716, ti=f42aa000 task=cb6770c0 task.ti=f42aa000)
[ 1924.117359] Stack:
[ 1924.117359]  c0bc802c c0bc77c8 c0b8ccf0 00000145 f42abd88 c04e5636 e6a4582c f4a844a8
[ 1924.117359]  e6a45804 00000000 e6a45708 00000000 00000000 000002d0 00004004 00267530
[ 1924.117359]  00000000 f57e9b10 f42abdb0 c04e6619 00000800 00004004 f57e9b10 f57e9b10
[ 1924.117359] Call Trace:
[ 1924.117359]  [<c04e5636>] ? xfs_buf_allocate_buffer+0x176/0x250
[ 1924.117359]  [<c04e6619>] ? xfs_buf_get+0x69/0x190
[ 1924.117359]  [<c04b65ce>] ? xfs_growfs_data+0x6ae/0xc60
[ 1924.117359]  [<c04eb863>] ? xfs_file_ioctl+0x283/0x8e0
[ 1924.117359]  [<c01fccfc>] ? __do_fault+0xfc/0x420
[ 1924.117359]  [<c01fcd8c>] ? __do_fault+0x18c/0x420
[ 1924.117359]  [<c01e2a03>] ? unlock_page+0x43/0x50
[ 1924.117359]  [<c01fcf28>] ? __do_fault+0x328/0x420
[ 1924.117359]  [<c01fe8db>] ? handle_mm_fault+0xeb/0x6a0
[ 1924.117359]  [<c04eb5e0>] ? xfs_file_ioctl+0x0/0x8e0
[ 1924.117359]  [<c022520d>] ? do_vfs_ioctl+0x7d/0x5e0
[ 1924.117359]  [<c018c9b6>] ? up_read+0x16/0x30
[ 1924.117359]  [<c093979a>] ? do_page_fault+0x1ba/0x450
[ 1924.117359]  [<c0202e71>] ? sys_mmap_pgoff+0x71/0x1b0
[ 1924.117359]  [<c018c986>] ? up_write+0x16/0x30
[ 1924.117359]  [<c02257a9>] ? sys_ioctl+0x39/0x60
[ 1924.117359]  [<c09366dd>] ? syscall_call+0x7/0xb

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
