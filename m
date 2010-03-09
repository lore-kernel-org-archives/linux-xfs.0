Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o29BboXG135525 for <xfs@oss.sgi.com>; Tue, 9 Mar 2010 05:37:52 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9327014092F4
	for <xfs@oss.sgi.com>; Tue,  9 Mar 2010 03:39:21 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id LhLWXCoQOA3Ekhcr for
	<xfs@oss.sgi.com>; Tue, 09 Mar 2010 03:39:21 -0800 (PST)
Date: Tue, 9 Mar 2010 06:39:19 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/9] Log and transaction cleanups, factoring and bug fixes
Message-ID: <20100309113919.GA5479@infradead.org>
References: <1267840284-4652-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1267840284-4652-1-git-send-email-david@fromorbit.com>
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

With the whole series (and my posted cleanups) applied I get the
following XFSQA 113 failure (and a similar one before):

[ 2064.763171] Assertion failed: xfs_lic_are_all_free(licp), file: fs/xfs/xfs_trans.c, line: 1432
[ 2064.765993] ------------[ cut here ]------------
[ 2064.767449] kernel BUG at fs/xfs/support/debug.c:109!
[ 2064.768918] invalid opcode: 0000 [#1] SMP 
[ 2064.769847] last sysfs file: /sys/devices/virtio-pci/virtio1/block/vdb/removable
[ 2064.769847] Modules linked in:
[ 2064.769847] 
[ 2064.769847] Pid: 329, comm: xfslogd/0 Not tainted 2.6.33-xfs #477 /Bochs
[ 2064.769847] EIP: 0060:[<c04ede2e>] EFLAGS: 00010286 CPU: 0
[ 2064.769847] EIP is at assfail+0x1e/0x30
[ 2064.769847] EAX: 00000065 EBX: f5a91b40 ECX: f70c5040 EDX: 01704000
[ 2064.769847] ESI: 00000000 EDI: 00000000 EBP: f6b25e4c ESP: f6b25e3c
[ 2064.769847]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[ 2064.769847] Process xfslogd/0 (pid: 329, ti=f6b24000 task=f70c5040 task.ti=f6b24000)
[ 2064.769847] Stack:
[ 2064.769847]  c0b74894 c0b2f5b6 c0b2f35a 00000598 f6b25e84 c04d4e66 000010d2 00000180
[ 2064.769847] <0> 00000180 000010d2 00001098 00000000 f4375574 f4375550 daaf3aa0 daaf3aa4
[ 2064.769847] <0> daaf3d3c 00000000 f6b25ee0 c04c53a2 00000046 f63273d4 f63273e4 00000292
[ 2064.769847] Call Trace:
[ 2064.769847]  [<c04d4e66>] ? xfs_trans_committed+0xe6/0x1b0
[ 2064.769847]  [<c04c53a2>] ? xlog_state_do_callback+0x282/0x3c0
[ 2064.769847]  [<c0158ad0>] ? __wake_up+0x40/0x50
[ 2064.769847]  [<c04c5974>] ? xlog_state_done_syncing+0xc4/0xe0
[ 2064.769847]  [<c04c5a81>] ? xlog_iodone+0xf1/0x160
[ 2064.769847]  [<c04e3f10>] ? xfs_buf_iodone_work+0x0/0xd0
[ 2064.769847]  [<c04e3f3f>] ? xfs_buf_iodone_work+0x2f/0xd0
[ 2064.769847]  [<c04e3f10>] ? xfs_buf_iodone_work+0x0/0xd0
[ 2064.769847]  [<c017a7c4>] ? worker_thread+0x154/0x270
[ 2064.769847]  [<c017a763>] ? worker_thread+0xf3/0x270
[ 2064.769847]  [<c017e1f0>] ? autoremove_wake_function+0x0/0x40
[ 2064.769847]  [<c017a670>] ? worker_thread+0x0/0x270
[ 2064.769847]  [<c017de3c>] ? kthread+0x6c/0x80
[ 2064.769847]  [<c017ddd0>] ? kthread+0x0/0x80
[ 2064.769847]  [<c012effa>] ? kernel_thread_helper+0x6/0x1c
[ 2064.769847] Code: 00 e8 e7 57 18 00 c9 c3 90 8d 74 26 00 55 89 e5 83 ec 10 89 4c 24 0c 89 54 24 08 89 44 24 04 c7 04 24 94 48 b7 c0 e8 35 a3 3f 00 <0f> 0b eb fe 8d b4 26 00 00 00 00 8d bc 27 00 00 00 00 55 89 e5 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
