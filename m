Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB7MOFv7234234 for <xfs@oss.sgi.com>; Tue, 7 Dec 2010 16:24:15 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0DBC914262B4
	for <xfs@oss.sgi.com>; Tue,  7 Dec 2010 14:26:01 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	M7tIUP3CZbkVnxYi for <xfs@oss.sgi.com>;
	Tue, 07 Dec 2010 14:26:01 -0800 (PST)
Date: Wed, 8 Dec 2010 09:25:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: kernel panic-xfs errors
Message-ID: <20101207222558.GC29333@dastard>
References: <30397503.post@talk.nabble.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <30397503.post@talk.nabble.com>
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
To: blacknred <leo1783@hotmail.co.uk>
Cc: xfs@oss.sgi.com

On Tue, Dec 07, 2010 at 07:42:56AM -0800, blacknred wrote:
> 
> Hi.....
> 
> I get a kernel panic on my HP Proliant Server.
> 
> here's trace:
>                                         
> BUG: unable to handle kernel NULL pointer dereference at virtual address
> 00000052
>  printing eip:                                                                  
> *pde = 2c731001                                                                 
> Oops: 0000 [#1]                                                                 
> SMP                                                                             
>                                                                              
> CPU:    2                                                                      
> EIP:    0060:[<c0529da1>]    Tainted: GF     VLI
                               ^^^^^^^^^^^

You've done a forced module load. No guarantee your kernel is in any
sane shape if you've done that....

> EFLAGS: 00010272   (2.6.33.3-85.fc13.x86_64 #1) 
> EIP is at do_page_fault+0x245/0x617
> eax: ec5ee000   ebx: 00000000   ecx: eb5de084   edx: 0000000e
> esi: 00013103   edi: ec5de0b3   ebp: 00000023   esp: ec5de024
> ds: 008b   es: 008b   ss: 0078
> Process bm (pid: 3210, ti=ec622000 task=ec5e3450 task.ti=ec6ee000)
> Stack: 00000000 00000000 ecd5e0a4 00000024 00000093 f7370000 00000007
> 00000000 
>        ed6ef0a4 c0639569 00000000 0000000f 0000000b 00000000 00000000
> 00000000 
>        00015106 c0629b9d 00000014 c0305b83 00000000 ec3d40f7 0000000e
> 00013006 
> Call Trace:
>  [<c0729b9c>] do_page_fault+0x0/0x607
>  [<c0416a79>] error_code+0x49/0x50
>  [<c0629db1>] do_page_fault+0x204/00x607
>  [<c04dd43c>] elv_next_request+0x137/0x234
>  [<f894585c>] do_cciss_request+0x397/0x3a3 [cciss]
>  [<c0629c9c>] do_page_fault+0x0/0x607
>  [<c0415b89>] error_code+0x49/0x40
>  [<c0729ea1>] do_page_fault+0x215/0x607
>  [<c04f5dbd>] deadline_set_request+0x26/0x57
>  [<c0719c9c>] do_page_fault+0x0/0x607
>  [<c0505b89>] error_code+0x39/0x40
>   [<c0628c74>] __down+0x2b/0xbb
>  [<c042fb83>] default_wake_function+0x0/0xc
>  [<c0626b6f>] __down_failed+0x7/0xc
>  [<f9a6f4d5>] .text.lock.xfs_buf+0x17/0x5f [xfs]
>  [<f8a6fe99>] xfs_buf_read_flags+0x48/0x76 [xfs]
>  [<f8a72992>] xfs_trans_read_buf+0x1bb/0x2c0 [xfs]
>  [<f8b3c029>] xfs_btree_read_bufl+0x96/0xb3 [xfs]
>  [<f8b38ce7>] xfs_bmbt_lookup+0x135/0x478 [xfs]
>  [<f8b303b4>] xfs_bmap_add_extent+0xd2b/0x1e30 [xfs]
>  [<f8a36456>] xfs_alloc_update+0x3a/0xbc [xfs]
>  [<f8b21af3>] xfs_alloc_fixup_trees+0x217/0x29a [xfs]
>  [<f8a725ff>] xfs_trans_log_buf+0x49/0x6c [xfs]
>  [<f8a31b96>] xfs_alloc_search_busy+0x20/0xae [xfs]
>  [<f8a5e08c>] xfs_iext_bno_to_ext+0xd8/0x191 [xfs]
>  [<f8a7bed2>] kmem_zone_zalloc+0x1d/0x41 [xfs]
>  [<f8a44165>] xfs_bmapi+0x15fe/0x2016 [xfs]
>  [<f8a4deec>] xfs_iext_bno_to_ext+0x48/0x191 [xfs]
>  [<f8a41a7e>] xfs_bmap_search_multi_extents+0x8a/0xc5 [xfs]
>  [<f8a5507f>] xfs_iomap_write_allocate+0x29c/0x469 [xfs]
>  [<c042e85d>] lock_timer_base+0x15/0x2f
>  [<c042dd28>] del_timer+0x41/0x47
>  [<f8a52d29>] xfs_iomap+0x409/0x71d [xfs]
>  [<f8a6c973>] xfs_map_blocks+0x29/0x52 [xfs]
>  [<f8a6dd6f>] xfs_page_state_convert+0x37b/0xd2e [xfs]
>  [<f8a41358>] xfs_bmap_add_extent+0x1dcf/0x1e30 [xfs]
>  [<f8a34a6e>] xfs_bmap_search_multi_extents+0x8a/0xc5 [xfs]
>  [<f8a31ee9>] xfs_bmapi+0x272/0x2017 [xfs]
>  [<f8a344ba>] xfs_bmapi+0x1853/0x2017 [xfs]
>  [<c05561be>] find_get_pages_tag+0x40/0x75
>  [<f8a6d82b>] xfs_vm_writepage+0x8f/0xd2 [xfs]
>  [<c0593f1c>] mpage_writepages+0x1b7/0x310
>  [<f8a6e89c>] xfs_vm_writepage+0x0/0xc4 [xfs]
>  [<c045c423>] do_writepages+0x20/0x42
>  [<c04936f7>] __writeback_single_inode+0x180/0x2af
>  [<c049389c>] write_inode_now+0x67/0xa7
>  [<c0476955>] file_fsync+0xf/0x6c
>  [<f8b9c75b>] moddw_ioctl+0x420/0x679 [mod_dw]
>  [<c0421f74>] __cond_resched+0x16/0x54
>  [<c04854d8>] do_ioctl+0x47/0x5d
>  [<c0484b41>] vfs_ioctl+0x47b/0x4d3
>  [<c0484af1>] sys_ioctl+0x48/0x4f
>  [<c0504ebd>] sysenter_past_esp+0x46/0x79

Strange failure. Hmmm - i386 arch and fedora - are you running with
4k stacks? If so, maybe it blew the stack...

> 
> dmesg shows:
> XFS: bad magic number
> XFS: SB validate failed
> 
> I rebooted the server, now xfs_repair comes clean.
> 
> But the server has hung again after an hour. No panic this time, checked
> dmesg output and it again
> shows same 
> XFS: bad magic number
> XFS: SB validate failed 
> messages.. Any thoughts??

What does this give you before and after the failure:

# dd if=<device> bs=512 count=1 | od -c

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
