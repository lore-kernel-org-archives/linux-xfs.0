Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7N9jCNg168384 for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 04:45:13 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E75641DA3C5F
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 02:45:10 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	kU1XmF63KFJPP3pu for <xfs@oss.sgi.com>;
	Tue, 23 Aug 2011 02:45:10 -0700 (PDT)
Date: Tue, 23 Aug 2011 19:45:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Ubuntu 10.04.2 (2.6.32-32-server) random kernel panic on xfs write
Message-ID: <20110823094505.GA3162@dastard>
References: <CAPd5bUoWZdn6j1yH6BtYEAHh8_45mfoH+aDs45-tOj30N8Tvyg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPd5bUoWZdn6j1yH6BtYEAHh8_45mfoH+aDs45-tOj30N8Tvyg@mail.gmail.com>
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
To: Muhammad Hallaj Subery <hallajs@gmail.com>
Cc: xfs@oss.sgi.com

On Tue, Aug 23, 2011 at 09:46:23AM +0800, Muhammad Hallaj Subery wrote:
> Hi all, I'm getting kernel panic on XFS write process by random. Could
> someone point to me if this is a known issue and if there's a fix for it?
> Attach is the log for it.

> [922371.445221] BUG: unable to handle kernel paging request at 0000000389b14ad8
> [922371.445730] IP: [<ffffffff81557980>] schedule+0x250/0x451
> [922371.446093] PGD 17b7c6067 PUD 0 
> [922371.446436] Thread overran stack, or stack corrupted

There's your problem - stack overflow.

> [922371.446680] Oops: 0000 [#1] SMP 
> [922371.447021] last sysfs file: /sys/devices/system/cpu/cpu11/cache/index2/shared_cpu_map
> [922371.447386] CPU 0 
> [922371.447585] Modules linked in: btrfs zlib_deflate crc32c libcrc32c ufs qnx4 hfsplus hfs minix ntfs vfat msdos fat jfs reiserfs netconsole configfs xfs exportfs fbcon tileblit font bitblit softcursor dell_wmi dcdbas psmouse vga16fb joydev serio_raw vgastate power_meter bnx2 lp parport usbhid hid usb_storage mpt2sas scsi_transport_sas
> [922371.452534] Pid: 803, comm: flush-8:0 Not tainted 2.6.32-32-server #62-Ubuntu PowerEdge R710

2.6.32 is pretty old now.

> [922371.452913] RIP: 0010:[<ffffffff81557980>]  [<ffffffff81557980>] schedule+0x250/0x451
> [922371.453372] RSP: 0018:ffff88022149a280  EFLAGS: 00010087
> [922371.453616] RAX: 0000000081055cc3 RBX: ffff880009015f00 RCX: 0000000000000001
> [922371.453958] RDX: ffff880222e8ae00 RSI: ffffffff817d5e00 RDI: ffff880222e8ae00
> [922371.454299] RBP: ffff88022149a320 R08: 0000000000000000 R09: 0000000000000100
> [922371.480427] R10: fffea2c9014dd580 R11: 0000000000000001 R12: 0000000000000000
> [922371.506921] R13: ffffffff81570f40 R14: 00000001057fa251 R15: 00000000ffffffff
> [922371.533337] FS:  0000000000000000(0000) GS:ffff880009000000(0000) knlGS:0000000000000000
> [922371.560002] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> [922371.573587] CR2: 0000000389b14ad8 CR3: 00000001ad407000 CR4: 00000000000006f0
> [922371.601358] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [922371.629838] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [922371.659001] Process flush-8:0 (pid: 803, threadinfo ffff88022149a000, task ffff880222e8ae00)
> [922371.688450] Stack:
> [922371.702807]  0000000000015f00 0000000000015f00 ffff880222e8b1d0 ffff88022149bfd8
> [922371.717663] <0> 0000000000015f00 ffff880222e8ae00 0000000000015f00 ffff88022149bfd8
> [922371.746297] <0> 0000000000015f00 ffff880222e8b1d0 0000000000015f00 0000000000015f00
> [922371.788745] Call Trace:
> [922371.802681]  [<ffffffff8155837d>] schedule_timeout+0x22d/0x300
> [922371.816525]  [<ffffffff810f7a96>] ? find_lock_page+0x26/0x80
> [922371.830133]  [<ffffffff810f803f>] ? find_or_create_page+0x3f/0xb0
> [922371.843599]  [<ffffffff815592ae>] __down+0x7e/0xc0
> [922371.856770]  [<ffffffff8108b021>] down+0x41/0x50
> [922371.869659]  [<ffffffffa01621f3>] xfs_buf_lock+0x23/0x60 [xfs]
> [922371.882403]  [<ffffffffa0162375>] _xfs_buf_find+0x145/0x240 [xfs]
> [922371.894892]  [<ffffffffa01624d0>] xfs_buf_get_flags+0x60/0x170 [xfs]
> [922371.907127]  [<ffffffffa01625f8>] xfs_buf_read_flags+0x18/0xa0 [xfs]
> [922371.919262]  [<ffffffffa0157529>] xfs_trans_read_buf+0x1c9/0x300 [xfs]
> [922371.931032]  [<ffffffff810f6527>] ? unlock_page+0x27/0x30
> [922371.942743]  [<ffffffffa0126e8e>] xfs_btree_read_buf_block+0x5e/0xc0 [xfs]
> [922371.954441]  [<ffffffffa0127584>] xfs_btree_lookup_get_block+0x84/0xf0 [xfs]
> [922371.965886]  [<ffffffffa0127c27>] xfs_btree_lookup+0xd7/0x4a0 [xfs]
> [922371.976976]  [<ffffffffa015d82a>] ? kmem_zone_zalloc+0x3a/0x50 [xfs]
> [922371.987853]  [<ffffffffa0113dac>] ? xfs_allocbt_init_cursor+0x4c/0xc0 [xfs]
> [922371.998550]  [<ffffffffa0110d9c>] xfs_alloc_lookup_ge+0x1c/0x20 [xfs]
> [922372.009119]  [<ffffffffa01127fb>] xfs_alloc_ag_vextent_near+0x5b/0x9a0 [xfs]
> [922372.019540]  [<ffffffffa0113215>] xfs_alloc_ag_vextent+0xd5/0x130 [xfs]
> [922372.029747]  [<ffffffffa01139d8>] xfs_alloc_vextent+0x1f8/0x490 [xfs]
> [922372.039761]  [<ffffffffa0121856>] xfs_bmap_btalloc+0x176/0x9f0 [xfs]
> [922372.049512]  [<ffffffffa0122fb1>] xfs_bmap_alloc+0x21/0x40 [xfs]
> [922372.059372]  [<ffffffffa0123b6f>] xfs_bmapi+0xb9f/0x1290 [xfs]
> [922372.069136]  [<ffffffffa014b274>] ? xfs_log_reserve+0xd4/0xe0 [xfs]
> [922372.078831]  [<ffffffffa0145055>] xfs_iomap_write_allocate+0x1c5/0x3c0 [xfs]
> [922372.088471]  [<ffffffff8105f0fb>] ? enqueue_task_fair+0x5b/0xa0
> [922372.098157]  [<ffffffffa0145dab>] xfs_iomap+0x2ab/0x2e0 [xfs]
> [922372.107705]  [<ffffffffa015e45d>] xfs_map_blocks+0x2d/0x40 [xfs]
> [922372.117076]  [<ffffffffa015f86a>] xfs_page_state_convert+0x3da/0x720 [xfs]
> [922372.126686]  [<ffffffff812baa3d>] ? radix_tree_delete+0x14d/0x2d0
> [922372.136318]  [<ffffffffa015fd0a>] xfs_vm_writepage+0x7a/0x130 [xfs]
> [922372.146051]  [<ffffffff8110f91e>] ? __dec_zone_page_state+0x2e/0x30
> [922372.155947]  [<ffffffff81103d33>] pageout+0x123/0x280
> [922372.165811]  [<ffffffff811042f3>] shrink_page_list+0x263/0x600
> [922372.175760]  [<ffffffff8110499e>] shrink_inactive_list+0x30e/0x810

And there's the cause - direct memroy reclaim doing writeback. XFS
has aborted writeback in upstream kernels for quite some time for
exactly this reason. i.e. even a dedicated writeback thread doesn't
have enough stack space to do writeback from direct memory reclaim.

Best to raise an Ubuntu bug and get them to backport the relevant
fix:

commit 070ecdca54dde9577d2697088e74e45568f48efb
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Jun 3 16:22:29 2010 +1000

    xfs: skip writeback from reclaim context
    
    Allowing writeback from reclaim context causes massive problems with stack
    overflows as we can call into the writeback code which tends to be a heavy
    stack user both in the generic code and XFS from random contexts that
    perform memory allocations.
    
    Follow the example of btrfs (and in slightly different form ext4) and refuse
    to write out data from reclaim context.  This issue should really be handled
    by the VM so that we can tune better for this case, but until we get it
    sorted out there we have to hack around this in each filesystem with a
    complex writeback path.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>

Hope this helps.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
