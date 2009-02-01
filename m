Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n118D5Pg165019 for <xfs@oss.sgi.com>; Sun, 1 Feb 2009 02:13:06 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F300218A0BC4
	for <xfs@oss.sgi.com>; Sun,  1 Feb 2009 00:12:25 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Q0AqCm3TGbDQHHHp for
	<xfs@oss.sgi.com>; Sun, 01 Feb 2009 00:12:25 -0800 (PST)
Date: Sun, 1 Feb 2009 03:12:24 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: reproducible xfs/vmap oops
Message-ID: <20090201081224.GA22398@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com, Nick Piggin <nickpiggin@yahoo.com.au>

When running xfsqa on the current xfs development tree (sometimes two
runs are needed to trigger it) I get the following oops.  This seems to
have been introduced by the last mainling merge (with
5ee810072175042775e39bdd3eaaa68884c27805), but I'd need to bisect it to
make sure my gut feeling is right.

[ 3262.460241] XFS mounting filesystem vde
[ 3262.474253] ------------[ cut here ]------------
[ 3262.476024] kernel BUG at mm/vmalloc.c:294!
[ 3262.476024] invalid opcode: 0000 [#1] SMP 
[ 3262.476024] last sysfs file: /sys/class/net/lo/operstate
[ 3262.476024] Modules linked in:
[ 3262.476024] 
[ 3262.476024] Pid: 31907, comm: mount Not tainted (2.6.29-rc2-xfs #30) 
[ 3262.476024] EIP: 0060:[<c01b4b28>] EFLAGS: 00010207 CPU: 0
[ 3262.476024] EIP is at __insert_vmap_area+0x88/0xb0
[ 3262.476024] EAX: 00101000 EBX: ffd01000 ECX: 00000000 EDX: f5f25df4
[ 3262.476024] ESI: d2180340 EDI: d2180340 EBP: f32f5bcc ESP: f32f5bc4
[ 3262.476024]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[ 3262.476024] Process mount (pid: 31907, ti=f32f4000 task=de55e2b0
task.ti=f32f4000)
[ 3262.476024] Stack:
[ 3262.476024]  ffd01000 f874e000 f32f5c10 c01b5581 00000000 000200d0
00001000 f8b4e000
[ 3262.476024]  00400000 d2180340 00000000 d2180340 00000fff fffff000
c0a69e80 c0a69e80
[ 3262.476024]  f685ca98 00000400 00000400 f32f5c58 c01b5972 fff4e000
ffffffff 000000d0
[ 3262.476024] Call Trace:
[ 3262.476024]  [<c01b5581>] ? alloc_vmap_area+0x1b1/0x220
[ 3262.476024]  [<c01b5972>] ? vm_map_ram+0x382/0x3a0
[ 3262.476024]  [<c0450609>] ? kmem_alloc+0x59/0xf0
[ 3262.476024]  [<c04538a9>] ? _xfs_buf_map_pages+0x89/0xc0
[ 3262.476024]  [<c0453a17>] ? xfs_buf_get_noaddr+0x137/0x170
[ 3262.476024]  [<c043f52a>] ? xlog_get_bp+0x4a/0x80
[ 3262.476024]  [<c044045b>] ? xlog_write_log_records+0x4b/0x260
[ 3262.476024]  [<c079ea52>] ? _spin_unlock_irq+0x22/0x30
[ 3262.476024]  [<c0440712>] ? xlog_clear_stale_blocks+0xa2/0x180
[ 3262.476024]  [<c04419bc>] ? xlog_find_tail+0x46c/0x4f0
[ 3262.476024]  [<c0441a54>] ? xlog_recover+0x14/0xa0
[ 3262.476024]  [<c043a4b0>] ? xfs_log_mount+0xa0/0x180
[ 3262.476024]  [<c0444bd8>] ? xfs_mountfs+0x348/0x6d0
[ 3262.476024]  [<c05a8bb9>] ? __debug_object_init+0x229/0x340
[ 3262.476024]  [<c05a8d17>] ? debug_object_init+0x17/0x20
[ 3262.476024]  [<c0156480>] ? init_timer+0x10/0x30
[ 3262.476024]  [<c0445694>] ? xfs_mru_cache_create+0x114/0x150
[ 3262.476024]  [<c045ba0f>] ? xfs_fs_fill_super+0x1cf/0x310
[ 3262.476024]  [<c01c6d53>] ? get_sb_bdev+0x123/0x150
[ 3262.476024]  [<c01dace7>] ? alloc_vfsmnt+0x77/0x100
[ 3262.476024]  [<c01a7c51>] ? kstrdup+0x31/0x60
[ 3262.476024]  [<c0459b71>] ? xfs_fs_get_sb+0x21/0x30
[ 3262.476024]  [<c045b840>] ? xfs_fs_fill_super+0x0/0x310
[ 3262.476024]  [<c01c5a5a>] ? vfs_kern_mount+0x3a/0xa0
[ 3262.476024]  [<c01c5b19>] ? do_kern_mount+0x39/0xe0
[ 3262.476024]  [<c01dba2b>] ? do_mount+0x3ab/0x780
[ 3262.476024]  [<c05a7cf1>] ? _raw_spin_lock+0x41/0x120
[ 3262.476024]  [<c01da00c>] ? copy_mount_options+0x3c/0x130
[ 3262.476024]  [<c01dbe89>] ? sys_mount+0x89/0xc0
[ 3262.476024]  [<c0120dfe>] ? syscall_call+0x7/0xb
[ 3262.476024]  [<c0120000>] ? restore_sigcontext+0x140/0x150

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
