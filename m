Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2FG0JhZ062138 for <xfs@oss.sgi.com>; Mon, 15 Mar 2010 11:00:19 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 31CF619D334A
	for <xfs@oss.sgi.com>; Mon, 15 Mar 2010 09:01:55 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id HwETDGHDMEgoyKEN for
	<xfs@oss.sgi.com>; Mon, 15 Mar 2010 09:01:55 -0700 (PDT)
Date: Mon, 15 Mar 2010 12:01:54 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] Delayed logging
Message-ID: <20100315160154.GA10406@infradead.org>
References: <20100315043000.GK4732@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100315043000.GK4732@dastard>
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

Running the series on my KVM testbox trips out this assert in
xfstests 013, which suggests we might be calling iput one too
much somewhere (e.g. IOP_UNLOCK)):

[  132.174780] Assertion failed: atomic_read(&VFS_I(dp)->i_count) > 0, file: fs/xfs/xfs_vnodeops.c, line: 1430
[  132.177814] ------------[ cut here ]------------
[  132.179219] kernel BUG at fs/xfs/support/debug.c:109!
[  132.180818] invalid opcode: 0000 [#1] SMP 
[  132.181734] last sysfs file: /sys/devices/virtio-pci/virtio1/block/vdb/removable
[  132.181734] Modules linked in:
[  132.181734] 
[  132.181734] Pid: 7752, comm: fsstress Not tainted 2.6.33-xfs #488 /Bochs
[  132.181734] EIP: 0060:[<c04ef4fe>] EFLAGS: 00010286 CPU: 0
[  132.181734] EIP is at assfail+0x1e/0x30
[  132.181734] EAX: 00000072 EBX: f5aba270 ECX: f5551200 EDX: 01704000
[  132.181734] ESI: 00000000 EDI: f5f701f0 EBP: f5307e48 ESP: f5307e38
[  132.181734]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  132.181734] Process fsstress (pid: 7752, ti=f5306000 task=f5551200 task.ti=f5306000)
[  132.181734] Stack:
[  132.181734]  c0b75db8 c0b74e40 c0b30914 00000596 f5307ec0 c04ded8e 00000001 00000000
[  132.181734] <0> 00000000 00000000 00000001 f5307eb0 f5307ea8 00000000 00002124 f5307ee0
[  132.181734] <0> 000268b8 00000002 00000000 00000000 00000029 00000000 00000000 00000000
[  132.181734] Call Trace:
[  132.181734]  [<c04ded8e>] ? xfs_create+0x42e/0x640
[  132.181734]  [<c04eb768>] ? xfs_vn_mknod+0xa8/0x180
[  132.181734]  [<c04eb6c0>] ? xfs_vn_mknod+0x0/0x180
[  132.181734]  [<c020eaaf>] ? vfs_mknod+0xcf/0x160
[  132.181734]  [<c020ed1b>] ? sys_mknodat+0x1db/0x230
[  132.181734]  [<c020ed97>] ? sys_mknod+0x27/0x30
[  132.181734]  [<c012ea9c>] ? sysenter_do_call+0x12/0x3c
[  132.181734] Code: 00 e8 f7 57 18 00 c9 c3 90 8d 74 26 00 55 89 e5 83
ec 10 89 4c 24 0c 89 54 24 08 89 44 24 04 c7 04 24 b8 5d b7 c0 e8 59 a2
3f 00 <0f> 0b eb fe 8d b4 26 00 00 00 00 8d bc 27 00 00 00 00 55 89 e5 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
