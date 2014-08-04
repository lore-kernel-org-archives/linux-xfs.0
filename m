Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 084AE7F61
	for <xfs@oss.sgi.com>; Mon,  4 Aug 2014 06:00:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9917AAC002
	for <xfs@oss.sgi.com>; Mon,  4 Aug 2014 04:00:13 -0700 (PDT)
Received: from mail-wi0-f177.google.com (mail-wi0-f177.google.com
	[209.85.212.177]) by cuda.sgi.com with ESMTP id
	9RjgfqnkWOJzKPrb (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 04 Aug 2014 04:00:10 -0700 (PDT)
Received: by mail-wi0-f177.google.com with SMTP id ho1so4802532wib.4
	for <xfs@oss.sgi.com>; Mon, 04 Aug 2014 04:00:08 -0700 (PDT)
Received: from alyakaslap ([212.143.144.103]) by mx.google.com with ESMTPSA id
	ex2sm39638660wic.24.2014.08.04.04.00.06 for <xfs@oss.sgi.com>
	(version=TLSv1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
	Mon, 04 Aug 2014 04:00:06 -0700 (PDT)
Message-ID: <9D3CBECB663B4A77B7EF74B67973310A@alyakaslap>
From: "Alex Lyakas" <alex@zadarastorage.com>
References: <20131219105513.GZ31386@dastard>
	<8155F3F9D6094F40B4DA71BD561D2DE8@alyakaslap>
	<20131226230018.GJ20579@dastard>
	<A0A556BD24EC45CEADAA07870B3E6205@alyakaslap>
	<20140113030230.GF3469@dastard>
	<CAOcd+r0B-4SPjzim=68w3L8Y9FxwBD-C5HkkeO58C6t9nfgbhw@mail.gmail.com>
	<20140113204314.GJ3469@dastard>
	<CAOcd+r22FirPMHjdxQyTmXOAM72ND-t0=njK9nEmesSV5=Ec=Q@mail.gmail.com>
	<20140115014503.GQ3469@dastard>
	<CAOcd+r0R6KxmgEJNPUZ0Q5cQhsStGb=cehYE0+wKgDNU1negsA@mail.gmail.com>
	<20140119231745.GF18112@dastard>
	<4B2A412C75324EE9880358513C069476@alyakaslap>
In-Reply-To: <4B2A412C75324EE9880358513C069476@alyakaslap>
Subject: use-after-free on log replay failure
Date: Mon, 4 Aug 2014 14:00:05 +0300
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Greetings,

we had a log replay failure due to some errors that the underlying block 
device returned:
[49133.801406] XFS (dm-95): metadata I/O error: block 0x270e8c180 
("xlog_recover_iodone") error 28 numblks 16
[49133.802495] XFS (dm-95): log mount/recovery failed: error 28
[49133.802644] XFS (dm-95): log mount failed

and then kernel panicked [1].

Looking at the code, when xfs_mountfs() fails, xfs_fs_fill_super() goes and 
cleans up and eventually frees the "xfs_mount" structure. But then 
xfs_buf_iodone_work() can still be delivered through "xfslogd_workqueue", 
which is static and not per-XFS. But this callback has a pointer to 
"xfs_mount", and may try to access it as in [1]. Does this analysis sound 
correct? Kernel is 3.8.13, but looking at the XFS master branch, it might 
have the same issue.

Should we flush this static workqueue before unmounting?

Thanks,
Alex.


[1]
[49133.804546] general protection fault: 0000 [#1] SMP
[49133.808033]  xcbc rmd160 crypto_null af_key xfrm_algo scsi_dh cirrus 
psmouse ttm drm_kms_helper serio_raw drm i2c_piix4 sysimgblt virtio_balloon 
sysfillrect syscopyarea nfsd(OF) kvm nfs_acl auth_rpcgss nfs fscache 
microcode lockd mac_hid sunrpc lp parport floppy ixgbevf(OF)
[49133.808033] CPU 2
[49133.808033] Pid: 2907, comm: kworker/2:1H Tainted: GF       W  O 
3.8.13-030813-generic #201305111843 Bochs Bochs
[49133.808033] RIP: 0010:[<ffffffff813582fb>]  [<ffffffff813582fb>] 
strnlen+0xb/0x30
[49133.808033] RSP: 0018:ffff8801e31c5b08  EFLAGS: 00010086
[49133.808033] RAX: 0000000000000000 RBX: ffffffff81e4e527 RCX: 
0000000000000000
[49133.808033] RDX: 640000450008cf9d RSI: ffffffffffffffff RDI: 
640000450008cf9d
[49133.808033] RBP: ffff8801e31c5b08 R08: 000000000000ffff R09: 
000000000000ffff
[49133.808033] R10: 0000000000000000 R11: 0000000000000ffe R12: 
640000450008cf9d
[49133.808033] R13: ffffffff81e4e900 R14: 0000000000000000 R15: 
000000000000ffff
[49133.808033] FS:  0000000000000000(0000) GS:ffff88021fd00000(0000) 
knlGS:0000000000000000
[49133.808033] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[49133.808033] CR2: 00007fa4a91abd80 CR3: 000000020e783000 CR4: 
00000000000006e0
[49133.808033] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[49133.808033] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[49133.808033] Process kworker/2:1H (pid: 2907, threadinfo ffff8801e31c4000, 
task ffff8802124f45c0)
[49133.808033] Stack:
[49133.808033]  ffff8801e31c5b48 ffffffff81359d8e ffff8801e31c5b28 
ffffffff81e4e527
[49133.808033]  ffffffffa0636a1e ffff8801e31c5c80 ffffffffa0636a1e 
ffffffff81e4e900
[49133.808033]  ffff8801e31c5bc8 ffffffff8135af89 ffff8801e31c5bc8 
ffffffff8105a4e7
[49133.808033] Call Trace:
[49133.808033]  [<ffffffff81359d8e>] string.isra.4+0x3e/0xd0
[49133.808033]  [<ffffffff8135af89>] vsnprintf+0x219/0x640
[49133.808033]  [<ffffffff8105a4e7>] ? msg_print_text+0xb7/0x1b0
[49133.808033]  [<ffffffff8135b471>] vscnprintf+0x11/0x30
[49133.808033]  [<ffffffff8105b3b1>] vprintk_emit+0xc1/0x490
[49133.808033]  [<ffffffff8105b460>] ? vprintk_emit+0x170/0x490
[49133.808033]  [<ffffffff816d5848>] printk+0x61/0x63
[49133.808033]  [<ffffffffa05ba261>] __xfs_printk+0x31/0x50 [xfs]
[49133.808033]  [<ffffffffa05ba4b3>] xfs_notice+0x53/0x60 [xfs]
[49133.808033]  [<ffffffffa05b14a5>] xfs_do_force_shutdown+0xf5/0x180 [xfs]
[49133.808033]  [<ffffffffa05f6c38>] ? xlog_recover_iodone+0x48/0x70 [xfs]
[49133.808033]  [<ffffffffa05f6c38>] xlog_recover_iodone+0x48/0x70 [xfs]
[49133.808033]  [<ffffffffa05a749d>] xfs_buf_iodone_work+0x4d/0xa0 [xfs]
[49133.808033]  [<ffffffff81078b81>] process_one_work+0x141/0x490
[49133.808033]  [<ffffffff81079b48>] worker_thread+0x168/0x400
[49133.808033]  [<ffffffff810799e0>] ? manage_workers+0x120/0x120
[49133.808033]  [<ffffffff8107f050>] kthread+0xc0/0xd0
[49133.808033]  [<ffffffff8107ef90>] ? flush_kthread_worker+0xb0/0xb0
[49133.808033]  [<ffffffff816f61ec>] ret_from_fork+0x7c/0xb0
[49133.808033]  [<ffffffff8107ef90>] ? flush_kthread_worker+0xb0/0xb0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
