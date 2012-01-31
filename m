Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0VAs9Ya242800 for <xfs@oss.sgi.com>; Tue, 31 Jan 2012 04:54:09 -0600
Received: from smtp.pobox.com (b-pb-sasl-quonix.pobox.com [208.72.237.35]) by
	cuda.sgi.com with ESMTP id PRtUC4Eqk659QVNA for
	<xfs@oss.sgi.com>; Tue, 31 Jan 2012 02:54:08 -0800 (PST)
Received: from smtp.pobox.com (unknown [127.0.0.1])
	by b-sasl-quonix.pobox.com (Postfix) with ESMTP id 5F65D5188
	for <xfs@oss.sgi.com>; Tue, 31 Jan 2012 05:54:08 -0500 (EST)
Received: from b-pb-sasl-quonix.pobox.com (unknown [127.0.0.1])
	by b-sasl-quonix.pobox.com (Postfix) with ESMTP id 57B455187
	for <xfs@oss.sgi.com>; Tue, 31 Jan 2012 05:54:08 -0500 (EST)
Received: from Brians-MacBook-Air.local (unknown [217.206.150.147]) (using
	TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits)) (No client
	certificate
	requested) by b-sasl-quonix.pobox.com (Postfix) with ESMTPSA id
	A3AFB5186 for
	<xfs@oss.sgi.com>; Tue, 31 Jan 2012 05:54:07 -0500 (EST)
Received: from brian by Brians-MacBook-Air.local with local (Exim 4.77)
	(envelope-from <b.candler@pobox.com>) id LYNSY8-000ZOR-13 for
	xfs@oss.sgi.com; Tue, 31 Jan 2012 10:54:08 +0000
Date: Tue, 31 Jan 2012 10:54:08 +0000
From: Brian Candler <B.Candler@pobox.com>
Subject: Re: xfs task blocked for more than 120 seconds
Message-ID: <20120131105408.GA46226@nsrc.org>
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
To: xfs@oss.sgi.com

Aside: I saw what seems to be the same error twice yesterday in a setup
without dcrypt, but running bonnie++ on a software RAID6 array (12 drives)

The tasks affected were "kworker" and "xfsaild" - full logs below. OS is
stock ubuntu 11.10 x86_64 server.

Write performance to the RAID6 is admittedly pretty terrible, so maybe it
was just some backlog building up.

Regards,

Brian.

...
Jan 30 10:36:40 storage2 kernel: [  149.840035] XFS (md127): Mounting Filesystem
Jan 30 10:36:40 storage2 kernel: [  150.083318] XFS (md127): Ending clean mount
Jan 30 12:00:11 storage2 kernel: [ 5159.737134] INFO: task kworker/0:3:1644 blocked for more than 120 seconds.
Jan 30 12:00:11 storage2 kernel: [ 5159.737507] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 30 12:00:11 storage2 kernel: [ 5159.746598] kworker/0:3     D ffffffff81805120     0  1644      2 0x00000000
Jan 30 12:00:11 storage2 kernel: [ 5159.746603]  ffff8802078abb00 0000000000000046 0000000000000004 0000000000000000
Jan 30 12:00:11 storage2 kernel: [ 5159.746608]  ffff8802078abfd8 ffff8802078abfd8 ffff8802078abfd8 0000000000012a40
Jan 30 12:00:11 storage2 kernel: [ 5159.746613]  ffffffff81c0b020 ffff880212bc4560 ffff8802078abaf0 ffff8802129c2998
Jan 30 12:00:11 storage2 kernel: [ 5159.746618] Call Trace:
Jan 30 12:00:11 storage2 kernel: [ 5159.746625]  [<ffffffff8160492f>] schedule+0x3f/0x60
Jan 30 12:00:11 storage2 kernel: [ 5159.746642]  [<ffffffffa029f60c>] xlog_wait+0x6c/0x90 [xfs]
Jan 30 12:00:11 storage2 kernel: [ 5159.746646]  [<ffffffff810573a0>] ? try_to_wake_up+0x200/0x200
Jan 30 12:00:11 storage2 kernel: [ 5159.746658]  [<ffffffffa029f93f>] xlog_cil_push+0x30f/0x380 [xfs]
Jan 30 12:00:11 storage2 kernel: [ 5159.746661]  [<ffffffff81086b92>] ? up+0x32/0x50
Jan 30 12:00:11 storage2 kernel: [ 5159.746672]  [<ffffffffa02a015e>] xlog_cil_force_lsn+0x10e/0x120 [xfs]
Jan 30 12:00:11 storage2 kernel: [ 5159.746676]  [<ffffffff811532df>] ? kmem_cache_free+0x2f/0x120
Jan 30 12:00:11 storage2 kernel: [ 5159.746687]  [<ffffffffa029e797>] _xfs_log_force_lsn+0x57/0x2e0 [xfs]
Jan 30 12:00:11 storage2 kernel: [ 5159.746690]  [<ffffffff811532df>] ? kmem_cache_free+0x2f/0x120
Jan 30 12:00:11 storage2 kernel: [ 5159.746702]  [<ffffffffa02abf8d>] _xfs_trans_commit+0x29d/0x2b0 [xfs]
Jan 30 12:00:11 storage2 kernel: [ 5159.746715]  [<ffffffffa02bfec0>] ? xfs_sync_inode_attr+0xf0/0xf0 [xfs]
Jan 30 12:00:11 storage2 kernel: [ 5159.746726]  [<ffffffffa028f0c4>] xfs_fs_log_dummy+0x64/0x90 [xfs]
Jan 30 12:00:11 storage2 kernel: [ 5159.746738]  [<ffffffffa02bff44>] xfs_sync_worker+0x84/0x90 [xfs]
Jan 30 12:00:11 storage2 kernel: [ 5159.746742]  [<ffffffff8107b9ca>] process_one_work+0x11a/0x480
Jan 30 12:00:11 storage2 kernel: [ 5159.746745]  [<ffffffff8107c775>] worker_thread+0x165/0x370
Jan 30 12:00:11 storage2 kernel: [ 5159.746748]  [<ffffffff8107c610>] ? manage_workers.isra.30+0x130/0x130
Jan 30 12:00:11 storage2 kernel: [ 5159.746752]  [<ffffffff81080bbc>] kthread+0x8c/0xa0
Jan 30 12:00:11 storage2 kernel: [ 5159.746755]  [<ffffffff8160fca4>] kernel_thread_helper+0x4/0x10
Jan 30 12:00:11 storage2 kernel: [ 5159.746759]  [<ffffffff81080b30>] ? flush_kthread_worker+0xa0/0xa0
Jan 30 12:00:11 storage2 kernel: [ 5159.746761]  [<ffffffff8160fca0>] ? gs_change+0x13/0x13
Jan 30 12:56:11 storage2 kernel: [ 8519.003667] INFO: task xfsaild/md127:1559 blocked for more than 120 seconds.
Jan 30 12:56:11 storage2 kernel: [ 8519.008584] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 30 12:56:11 storage2 kernel: [ 8519.018149] xfsaild/md127   D ffffffff81805120     0  1559      2 0x00000000
Jan 30 12:56:11 storage2 kernel: [ 8519.018153]  ffff88020789dcb0 0000000000000046 0000000000000000 0000000000000000
Jan 30 12:56:11 storage2 kernel: [ 8519.018155]  ffff88020789dfd8 ffff88020789dfd8 ffff88020789dfd8 0000000000012a40
Jan 30 12:56:11 storage2 kernel: [ 8519.018158]  ffff880212d28000 ffff8802117dc560 ffff88020789dca0 000000000000007e
Jan 30 12:56:11 storage2 kernel: [ 8519.018160] Call Trace:
Jan 30 12:56:11 storage2 kernel: [ 8519.018167]  [<ffffffff8160492f>] schedule+0x3f/0x60
Jan 30 12:56:11 storage2 kernel: [ 8519.018183]  [<ffffffffa02a0147>] xlog_cil_force_lsn+0xf7/0x120 [xfs]
Jan 30 12:56:11 storage2 kernel: [ 8519.018185]  [<ffffffff810573a0>] ? try_to_wake_up+0x200/0x200
Jan 30 12:56:11 storage2 kernel: [ 8519.018196]  [<ffffffffa029e4c8>] _xfs_log_force+0x68/0x2a0 [xfs]
Jan 30 12:56:11 storage2 kernel: [ 8519.018208]  [<ffffffffa02b5fdb>] ? xfs_buf_unlock+0x3b/0xc0 [xfs]
Jan 30 12:56:11 storage2 kernel: [ 8519.018218]  [<ffffffffa029e718>] xfs_log_force+0x18/0x40 [xfs]
Jan 30 12:56:11 storage2 kernel: [ 8519.018229]  [<ffffffffa02ac804>] xfsaild_push+0x394/0x3a0 [xfs]
Jan 30 12:56:11 storage2 kernel: [ 8519.018239]  [<ffffffffa02ac872>] xfsaild+0x62/0xc0 [xfs]
Jan 30 12:56:11 storage2 kernel: [ 8519.018249]  [<ffffffffa02ac810>] ? xfsaild_push+0x3a0/0x3a0 [xfs]
Jan 30 12:56:11 storage2 kernel: [ 8519.018252]  [<ffffffff81080bbc>] kthread+0x8c/0xa0
Jan 30 12:56:11 storage2 kernel: [ 8519.018254]  [<ffffffff8160fca4>] kernel_thread_helper+0x4/0x10
Jan 30 12:56:11 storage2 kernel: [ 8519.018256]  [<ffffffff81080b30>] ? flush_kthread_worker+0xa0/0xa0
Jan 30 12:56:11 storage2 kernel: [ 8519.018258]  [<ffffffff8160fca0>] ? gs_change+0x13/0x13
Jan 30 12:56:11 storage2 kernel: [ 8519.018260] INFO: task kworker/0:0:1796 blocked for more than 120 seconds.
Jan 30 12:56:11 storage2 kernel: [ 8519.023397] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 30 12:56:11 storage2 kernel: [ 8519.033551] kworker/0:0     D ffffffff81805120     0  1796      2 0x00000000
Jan 30 12:56:11 storage2 kernel: [ 8519.033553]  ffff88010c9ebb00 0000000000000046 0000000000000004 0000000000000000
Jan 30 12:56:11 storage2 kernel: [ 8519.033555]  ffff88010c9ebfd8 ffff88010c9ebfd8 ffff88010c9ebfd8 0000000000012a40
Jan 30 12:56:11 storage2 kernel: [ 8519.033557]  ffffffff81c0b020 ffff880212cedc80 ffff88010c9ebaf0 ffff8802129c2998
Jan 30 12:56:11 storage2 kernel: [ 8519.033560] Call Trace:
Jan 30 12:56:11 storage2 kernel: [ 8519.033562]  [<ffffffff8160492f>] schedule+0x3f/0x60
Jan 30 12:56:11 storage2 kernel: [ 8519.033572]  [<ffffffffa029f60c>] xlog_wait+0x6c/0x90 [xfs]
Jan 30 12:56:11 storage2 kernel: [ 8519.033574]  [<ffffffff810573a0>] ? try_to_wake_up+0x200/0x200
Jan 30 12:56:11 storage2 kernel: [ 8519.033583]  [<ffffffffa029f93f>] xlog_cil_push+0x30f/0x380 [xfs]
Jan 30 12:56:11 storage2 kernel: [ 8519.033586]  [<ffffffff81086b92>] ? up+0x32/0x50
Jan 30 12:56:11 storage2 kernel: [ 8519.033595]  [<ffffffffa02a015e>] xlog_cil_force_lsn+0x10e/0x120 [xfs]
Jan 30 12:56:11 storage2 kernel: [ 8519.033598]  [<ffffffff811532df>] ? kmem_cache_free+0x2f/0x120
Jan 30 12:56:11 storage2 kernel: [ 8519.033607]  [<ffffffffa029e797>] _xfs_log_force_lsn+0x57/0x2e0 [xfs]
Jan 30 12:56:11 storage2 kernel: [ 8519.033609]  [<ffffffff811532df>] ? kmem_cache_free+0x2f/0x120
Jan 30 12:56:11 storage2 kernel: [ 8519.033619]  [<ffffffffa02abf8d>] _xfs_trans_commit+0x29d/0x2b0 [xfs]
Jan 30 12:56:11 storage2 kernel: [ 8519.033630]  [<ffffffffa02bfec0>] ? xfs_sync_inode_attr+0xf0/0xf0 [xfs]
Jan 30 12:56:11 storage2 kernel: [ 8519.033640]  [<ffffffffa028f0c4>] xfs_fs_log_dummy+0x64/0x90 [xfs]
Jan 30 12:56:11 storage2 kernel: [ 8519.033651]  [<ffffffffa02bff44>] xfs_sync_worker+0x84/0x90 [xfs]
Jan 30 12:56:11 storage2 kernel: [ 8519.033654]  [<ffffffff8107b9ca>] process_one_work+0x11a/0x480
Jan 30 12:56:11 storage2 kernel: [ 8519.033656]  [<ffffffff8107c775>] worker_thread+0x165/0x370
Jan 30 12:56:11 storage2 kernel: [ 8519.033657]  [<ffffffff8107c610>] ? manage_workers.isra.30+0x130/0x130
Jan 30 12:56:11 storage2 kernel: [ 8519.033660]  [<ffffffff81080bbc>] kthread+0x8c/0xa0
Jan 30 12:56:11 storage2 kernel: [ 8519.033661]  [<ffffffff8160fca4>] kernel_thread_helper+0x4/0x10
Jan 30 12:56:11 storage2 kernel: [ 8519.033664]  [<ffffffff81080b30>] ? flush_kthread_worker+0xa0/0xa0
Jan 30 12:56:11 storage2 kernel: [ 8519.033665]  [<ffffffff8160fca0>] ? gs_change+0x13/0x13

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
