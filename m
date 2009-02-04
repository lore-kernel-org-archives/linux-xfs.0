Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n148GRot131650 for <xfs@oss.sgi.com>; Wed, 4 Feb 2009 02:16:28 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 021E218BB653
	for <xfs@oss.sgi.com>; Wed,  4 Feb 2009 00:15:48 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id kR84E1GWYR9Deh4O for
	<xfs@oss.sgi.com>; Wed, 04 Feb 2009 00:15:48 -0800 (PST)
Date: Wed, 4 Feb 2009 03:15:47 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: reproducible xfs/vmap oops
Message-ID: <20090204081547.GA21487@infradead.org>
References: <20090201081224.GA22398@infradead.org>
	<20090203214711.GA24837@infradead.org>
	<20090203220808.GA9195@infradead.org>
	<200902041648.55603.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200902041648.55603.nickpiggin@yahoo.com.au>
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
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Feb 04, 2009 at 04:48:55PM +1100, Nick Piggin wrote:
> OK, I could reproduce this directly with a vmap test. With this patch,
> I'm no longer able to. (not sure how this mail client goes with attaching
> patches, sorry if it messes up)

With that patch applies I run into a different issue:

[ 4909.811804] XFS mounting filesystem vde
[ 4909.986343] ------------[ cut here ]------------
[ 4909.999285] WARNING: at mm/vmalloc.c:105
vmap_page_range+0x159/0x1b0()
[ 4910.021800] Hardware name: 
[ 4910.032628] Modules linked in:
[ 4910.043549] Pid: 6770, comm: mount Not tainted 2.6.29-rc3-xfs #43
[ 4910.069113] Call Trace:
[ 4910.080264]  [<c079fbf6>] ? printk+0x18/0x1a
[ 4910.091954]  [<c014cca3>] warn_slowpath+0x73/0xd0
[ 4910.103164]  [<c019bb00>] ? __rmqueue_smallest+0xf0/0x170
[ 4910.124547]  [<c01b547a>] ? alloc_vmap_area+0x6a/0x240
[ 4910.139940]  [<c0139a05>] ? kvm_set_pte_at+0x45/0x50
[ 4910.161273]  [<c01b4f49>] vmap_page_range+0x159/0x1b0
[ 4910.172548]  [<c01b5931>] vm_map_ram+0x2e1/0x3a0
[ 4910.193782]  [<c0453c19>] ? kmem_alloc+0x59/0xf0
[ 4910.204960]  [<c0456eb9>] _xfs_buf_map_pages+0x89/0xc0
[ 4910.216249]  [<c0457027>] xfs_buf_get_noaddr+0x137/0x170
[ 4910.237660]  [<c0442ace>] xlog_get_bp+0x2e/0xd0
[ 4910.248825]  [<c0443a6b>] xlog_write_log_records+0x4b/0x260
[ 4910.270258]  [<c07a26e2>] ? _spin_unlock_irq+0x22/0x30
[ 4910.282965]  [<c0443d22>] xlog_clear_stale_blocks+0xa2/0x180
[ 4910.304712]  [<c0444fcc>] xlog_find_tail+0x46c/0x4f0
[ 4910.326012]  [<c0445064>] xlog_recover+0x14/0xa0
[ 4910.341291]  [<c043d9c0>] xfs_log_mount+0xa0/0x180
[ 4910.352791]  [<c04481e8>] xfs_mountfs+0x348/0x6d0
[ 4910.374052]  [<c05ac4e9>] ? __debug_object_init+0x229/0x340
[ 4910.385427]  [<c05ac647>] ? debug_object_init+0x17/0x20
[ 4910.406761]  [<c0156570>] ? init_timer+0x10/0x30
[ 4910.422081]  [<c0448ca4>] ? xfs_mru_cache_create+0x114/0x150
[ 4910.443597]  [<c045f01f>] xfs_fs_fill_super+0x1cf/0x310
[ 4910.464931]  [<c01c6dd3>] get_sb_bdev+0x123/0x150
[ 4910.476212]  [<c01dad87>] ? alloc_vfsmnt+0x77/0x100
[ 4910.487458]  [<c01a7e11>] ? kstrdup+0x31/0x60
[ 4910.508628]  [<c045d181>] xfs_fs_get_sb+0x21/0x30
[ 4910.520744]  [<c045ee50>] ? xfs_fs_fill_super+0x0/0x310
[ 4910.542092]  [<c01c5ada>] vfs_kern_mount+0x3a/0xa0
[ 4910.553307]  [<c01c5b99>] do_kern_mount+0x39/0xe0
[ 4910.564518]  [<c01dbacb>] do_mount+0x3ab/0x780
[ 4910.585736]  [<c05ab621>] ? _raw_spin_lock+0x41/0x120
[ 4910.597002]  [<c01da0ac>] ? copy_mount_options+0x3c/0x130
[ 4910.621489]  [<c01dbf29>] sys_mount+0x89/0xc0
[ 4910.632621]  [<c0120dfe>] syscall_call+0x7/0xb
[ 4910.643772]  [<c0120000>] ? restore_sigcontext+0x140/0x150
[ 4910.665203] ---[ end trace 5a228d052300b60a ]---
[ 4910.676954] xfs_buf_get_noaddr: failed to map pages

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
