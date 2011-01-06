Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p06IEoj6101936 for <xfs@oss.sgi.com>; Thu, 6 Jan 2011 12:14:50 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A54A8FAE91F
	for <xfs@oss.sgi.com>; Thu,  6 Jan 2011 10:16:59 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id XXKAbBk9YkZNciE7 for
	<xfs@oss.sgi.com>; Thu, 06 Jan 2011 10:16:59 -0800 (PST)
Date: Thu, 6 Jan 2011 13:16:58 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 06/34] xfs: dynamic speculative EOF preallocation
Message-ID: <20110106181658.GA7299@infradead.org>
References: <1292916570-25015-1-git-send-email-david@fromorbit.com>
	<1292916570-25015-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1292916570-25015-7-git-send-email-david@fromorbit.com>
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

The lastest version of this patch makes test 229 oops for me.  This
only started to happen very recently, so I'm not sure if was caused
by an updated of this patch or an change in environment.  Either way
reverting this commit from the xfs tree makes 229 not oops (but still
fail as always) for me:

[   52.089635] Assertion failed: (blockcount & xfs_mask64hi(64-BMBT_BLOCKCOUNT_BITLEN)) == 0, file: fs/xfs/xfs_bmap_btree.c, line: 236
[   52.093089] ------------[ cut here ]------------
[   52.094491] kernel BUG at fs/xfs/support/debug.c:108!
[   52.095965] invalid opcode: 0000 [#1] SMP 
[   52.097003] last sysfs file: /sys/devices/virtio-pci/virtio1/block/vdb/removable
[   52.097003] Modules linked in:
[   52.097003] 
[   52.097003] Pid: 2343, comm: t_holes Not tainted 2.6.37-rc4-xfs+ #70 /Bochs
[   52.097003] EIP: 0060:[<c04f0eae>] EFLAGS: 00010286 CPU: 0
[   52.097003] EIP is at assfail+0x1e/0x30
[   52.097003] EAX: 0000008a EBX: 00000000 ECX: ffffff76 EDX: 00000001
[   52.097003] ESI: 00000000 EDI: f530d56c EBP: f4779930 ESP: f4779920
[   52.097003]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[   52.097003] Process t_holes (pid: 2343, ti=f4778000 task=f4f54340 task.ti=f4778000)
[   52.097003] Stack:
[   52.097003]  c0bc7d84 c0bbf538 c0b8a547 000000ec f477994c c049a822 00000000 00200000
[   52.097003]  000fffff 00000001 00000001 f477996c c049a8c3 fffe2065 000fffff 00200000
[   52.097003]  00000000 00000000 f4779b5c f47799a0 c04bc2bf 00000000 f530d554 00000000
[   52.097003] Call Trace:
[   52.097003]  [<c049a822>] ? xfs_bmbt_set_allf+0x72/0xe0
[   52.097003]  [<c049a8c3>] ? xfs_bmbt_set_all+0x33/0x40
[   52.097003]  [<c04bc2bf>] ? xfs_iext_insert+0x7f/0xe0
[   52.097003]  [<c0494c08>] ? xfs_bmap_add_extent+0x98/0x640
[   52.097003]  [<c0494c08>] ? xfs_bmap_add_extent+0x98/0x640
[   52.097003]  [<c04d4a2b>] ? xfs_icsb_modify_counters+0x5b/0x1b0
[   52.097003]  [<c0153074>] ? kvm_clock_read+0x14/0x20
[   52.097003]  [<c0496122>] ? xfs_bmapi+0xf72/0x20d0
[   52.097003]  [<c0139c58>] ? sched_clock+0x8/0x10
[   52.097003]  [<c04d1f03>] ? xfs_icsb_sync_counters_locked+0x63/0x80
[   52.097003]  [<c04c35dd>] ? xfs_iomap_write_delay+0x20d/0x480
[   52.097003]  [<c04e290b>] ? __xfs_get_blocks+0x59b/0x6c0
[   52.097003]  [<c04e2a81>] ? xfs_get_blocks+0x21/0x30
[   52.097003]  [<c023de15>] ? __block_write_begin+0x165/0x390
[   52.097003]  [<c023e1aa>] ? block_write_begin+0x4a/0x80
[   52.097003]  [<c04e2a60>] ? xfs_get_blocks+0x0/0x30
[   52.097003]  [<c04e20d3>] ? xfs_vm_write_begin+0x43/0x70
[   52.097003]  [<c04e2a60>] ? xfs_get_blocks+0x0/0x30
[   52.097003]  [<c01e2255>] ? generic_file_buffered_write+0xd5/0x200
[   52.097003]  [<c0934d45>] ? mutex_lock_nested+0x35/0x40
[   52.097003]  [<c04e94e2>] ? xfs_file_aio_write+0x552/0x950
[   52.097003]  [<c0216d4c>] ? do_sync_write+0x9c/0xd0
[   52.097003]  [<c093983a>] ? do_page_fault+0x1ba/0x450
[   52.097003]  [<c0216fda>] ? vfs_write+0x9a/0x140
[   52.097003]  [<c0216cb0>] ? do_sync_write+0x0/0xd0
[   52.097003]  [<c021786d>] ? sys_write+0x3d/0x70
[   52.097003]  [<c093677d>] ? syscall_call+0x7/0xb
[   52.097003] Code: 00 e8 e7 5f 19 00 c9 c3 90 8d 74 26 00 55 89 e5 83 ec 10 89 4c 24 0c 89 54 24 08 89 44 24 04 c7 04 24 84 7d bc c0 e8 82 23 44 00 <0f> 0b eb fe 8d b4 26 00 00 00 00 8d bc 27 00 00 00 00 55 89 e5 
[   52.097003] EIP: [<c04f0eae>] assfail+0x1e/0x30 SS:ESP 0068:f4779920
[   52.187554] ---[ end trace 7e012a71bd3e3b9d ]---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
