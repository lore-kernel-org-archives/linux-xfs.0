Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0VNUkVL136313 for <xfs@oss.sgi.com>; Tue, 31 Jan 2012 17:30:46 -0600
Received: from smtp-1.hut.fi (smtp-1.hut.fi [130.233.228.91]) by cuda.sgi.com
	with ESMTP id KjrPoChatTg99xSN (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 31 Jan 2012 15:30:43 -0800 (PST)
Received: from localhost (katosiko.hut.fi [130.233.228.115])
	by smtp-1.hut.fi (8.13.6/8.12.10) with ESMTP id q0VNUeJE031490
	for <xfs@oss.sgi.com>; Wed, 1 Feb 2012 01:30:40 +0200
Received: from smtp-1.hut.fi ([130.233.228.91])
	by localhost (katosiko.hut.fi [130.233.228.115]) (amavisd-new,
	port 10024) with LMTP id 22246-805 for <xfs@oss.sgi.com>;
	Wed,  1 Feb 2012 01:30:40 +0200 (EET)
Received: from kosh.localdomain (kosh.hut.fi [130.233.228.12])
	by smtp-1.hut.fi (8.13.6/8.12.10) with ESMTP id q0VNUZvU031480
	for <xfs@oss.sgi.com>; Wed, 1 Feb 2012 01:30:35 +0200
Date: Wed, 1 Feb 2012 01:30:34 +0200
From: Sami Liedes <sami.liedes@iki.fi>
Subject: Re: xfs task blocked for more than 120 seconds
Message-ID: <20120131233034.GK10174@sli.dy.fi>
References: <20120130002026.GG10174@sli.dy.fi> <20120130010530.GI15102@dastard>
	<2504_1327964557_4F27218D_2504_92_2_20120130223527.GH10174@sli.dy.fi>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <2504_1327964557_4F27218D_2504_92_2_20120130223527.GH10174@sli.dy.fi>
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

On Tue, Jan 31, 2012 at 12:35:28AM +0200, Sami Liedes wrote:
> The workloads do eventually complete. I tried the tar extraction again
> but this time extracting the tar from a different disk and saw no such
> warnings (and the time taken seems reasonable at 96 minutes).

Extracting a 105 GB tar that resides on the same (target) XFS
partition on an otherwise idle disk does trigger warnings, but only
for kworker, not the tar process. The time taken to extract was a
reasonable-sounding 140 minutes, so maybe these are just harmless
warnings. Perhaps something should/could be done to silence them in
that case?

	Sami

------------------------------------------------------------
[438920.782686] INFO: task kworker/0:1:7593 blocked for more than 120 seconds.
[438920.782689] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[438920.782691] kworker/0:1     D ffff8802228519d8     0  7593      2 0x00000000
[438920.782695]  ffff88003627fb70 0000000000000046 ffff88003627fb10 ffffffff811d2106
[438920.782699]  ffff880222851650 ffff88003627ffd8 ffff88003627ffd8 ffff88003627ffd8
[438920.782702]  ffff880220adc2f0 ffff880222851650 ffff88003627fd90 ffff88003627fe2c
[438920.782706] Call Trace:
[438920.782713]  [<ffffffff811d2106>] ? cpumask_next_and+0x36/0x50
[438920.782718]  [<ffffffff813ed17a>] schedule+0x3a/0x50
[438920.782721]  [<ffffffff813ed6a5>] schedule_timeout+0x1c5/0x300
[438920.782724]  [<ffffffff81035a34>] ? __enqueue_entity+0x74/0x80
[438920.782727]  [<ffffffff8103c785>] ? enqueue_entity+0xe5/0x4d0
[438920.782730]  [<ffffffff813ee257>] __down_common+0x95/0xe5
[438920.782752]  [<ffffffffa0ad4e07>] ? xfs_getsb+0x37/0x60 [xfs]
[438920.782755]  [<ffffffff813ee306>] __down+0x18/0x1a
[438920.782759]  [<ffffffff8107214c>] down+0x3c/0x50
[438920.782768]  [<ffffffffa0a85d24>] xfs_buf_lock+0x44/0x110 [xfs]
[438920.782781]  [<ffffffffa0ad4e07>] xfs_getsb+0x37/0x60 [xfs]
[438920.782795]  [<ffffffffa0ae0d03>] xfs_trans_getsb+0x43/0x140 [xfs]
[438920.782809]  [<ffffffffa0ad4b36>] xfs_mod_sb+0x46/0xc0 [xfs]
[438920.782820]  [<ffffffffa0a96320>] ? xfs_sync_inode_attr+0xf0/0xf0 [xfs]
[438920.782829]  [<ffffffffa0a8c29f>] xfs_fs_log_dummy+0x4f/0x90 [xfs]
[438920.782842]  [<ffffffffa0adad03>] ? xfs_log_need_covered+0x83/0xb0 [xfs]
[438920.782853]  [<ffffffffa0a963a4>] xfs_sync_worker+0x84/0x90 [xfs]
[438920.782856]  [<ffffffff81066ec8>] process_one_work+0x118/0x470
[438920.782859]  [<ffffffff81067dee>] worker_thread+0x15e/0x350
[438920.782862]  [<ffffffff81067c90>] ? manage_workers.isra.29+0x220/0x220
[438920.782864]  [<ffffffff8106c7a7>] kthread+0x87/0x90
[438920.782867]  [<ffffffff813f8974>] kernel_thread_helper+0x4/0x10
[438920.782870]  [<ffffffff8106c720>] ? kthread_worker_fn+0x190/0x190
[438920.782872]  [<ffffffff813f8970>] ? gs_change+0x13/0x13
[439640.359882] INFO: task kworker/0:3:7681 blocked for more than 120 seconds.
[439640.359885] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[439640.359887] kworker/0:3     D ffff8801086499d8     0  7681      2 0x00000000
[439640.359891]  ffff88013591db70 0000000000000046 ffff88013591db00 0000000000000086
[439640.359895]  ffff880108649650 ffff88013591dfd8 ffff88013591dfd8 ffff88013591dfd8
[439640.359898]  ffff880222335940 ffff880108649650 ffff88013591db80 ffffffff81044ecd
[439640.359902] Call Trace:
[439640.359909]  [<ffffffff81044ecd>] ? try_to_wake_up+0x22d/0x290
[439640.359914]  [<ffffffff813ed17a>] schedule+0x3a/0x50
[439640.359916]  [<ffffffff813ed6a5>] schedule_timeout+0x1c5/0x300
[439640.359920]  [<ffffffff81115124>] ? kmem_cache_free+0x104/0x110
[439640.359924]  [<ffffffff810d7172>] ? mempool_free_slab+0x12/0x20
[439640.359927]  [<ffffffff813ee257>] __down_common+0x95/0xe5
[439640.359947]  [<ffffffffa0ad4e07>] ? xfs_getsb+0x37/0x60 [xfs]
[439640.359950]  [<ffffffff813ee306>] __down+0x18/0x1a
[439640.359954]  [<ffffffff8107214c>] down+0x3c/0x50
[439640.359962]  [<ffffffffa0a85d24>] xfs_buf_lock+0x44/0x110 [xfs]
[439640.359975]  [<ffffffffa0ad4e07>] xfs_getsb+0x37/0x60 [xfs]
[439640.359987]  [<ffffffffa0ae0d03>] xfs_trans_getsb+0x43/0x140 [xfs]
[439640.360000]  [<ffffffffa0ad4b36>] xfs_mod_sb+0x46/0xc0 [xfs]
[439640.360009]  [<ffffffffa0a96320>] ? xfs_sync_inode_attr+0xf0/0xf0 [xfs]
[439640.360018]  [<ffffffffa0a8c29f>] xfs_fs_log_dummy+0x4f/0x90 [xfs]
[439640.360030]  [<ffffffffa0adad03>] ? xfs_log_need_covered+0x83/0xb0 [xfs]
[439640.360039]  [<ffffffffa0a963a4>] xfs_sync_worker+0x84/0x90 [xfs]
[439640.360042]  [<ffffffff81066ec8>] process_one_work+0x118/0x470
[439640.360045]  [<ffffffff81067dee>] worker_thread+0x15e/0x350
[439640.360048]  [<ffffffff81067c90>] ? manage_workers.isra.29+0x220/0x220
[439640.360050]  [<ffffffff8106c7a7>] kthread+0x87/0x90
[439640.360053]  [<ffffffff813f8974>] kernel_thread_helper+0x4/0x10
[439640.360055]  [<ffffffff8106c720>] ? kthread_worker_fn+0x190/0x190
[439640.360057]  [<ffffffff813f8970>] ? gs_change+0x13/0x13
------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
