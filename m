Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 238147F6C
	for <xfs@oss.sgi.com>; Mon,  4 Aug 2014 09:13:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DB8868F8049
	for <xfs@oss.sgi.com>; Mon,  4 Aug 2014 07:13:05 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 6RgcKx8faAKFXGpw (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 04 Aug 2014 07:13:01 -0700 (PDT)
Date: Mon, 4 Aug 2014 10:12:57 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: use-after-free on log replay failure
Message-ID: <20140804141257.GB4049@bfoster.bfoster>
References: <A0A556BD24EC45CEADAA07870B3E6205@alyakaslap>
	<20140113030230.GF3469@dastard>
	<CAOcd+r0B-4SPjzim=68w3L8Y9FxwBD-C5HkkeO58C6t9nfgbhw@mail.gmail.com>
	<20140113204314.GJ3469@dastard>
	<CAOcd+r22FirPMHjdxQyTmXOAM72ND-t0=njK9nEmesSV5=Ec=Q@mail.gmail.com>
	<20140115014503.GQ3469@dastard>
	<CAOcd+r0R6KxmgEJNPUZ0Q5cQhsStGb=cehYE0+wKgDNU1negsA@mail.gmail.com>
	<20140119231745.GF18112@dastard>
	<4B2A412C75324EE9880358513C069476@alyakaslap>
	<9D3CBECB663B4A77B7EF74B67973310A@alyakaslap>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <9D3CBECB663B4A77B7EF74B67973310A@alyakaslap>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Alex Lyakas <alex@zadarastorage.com>
Cc: xfs@oss.sgi.com

On Mon, Aug 04, 2014 at 02:00:05PM +0300, Alex Lyakas wrote:
> Greetings,
> 
> we had a log replay failure due to some errors that the underlying block
> device returned:
> [49133.801406] XFS (dm-95): metadata I/O error: block 0x270e8c180
> ("xlog_recover_iodone") error 28 numblks 16
> [49133.802495] XFS (dm-95): log mount/recovery failed: error 28
> [49133.802644] XFS (dm-95): log mount failed
> 
> and then kernel panicked [1].
> 
> Looking at the code, when xfs_mountfs() fails, xfs_fs_fill_super() goes and
> cleans up and eventually frees the "xfs_mount" structure. But then
> xfs_buf_iodone_work() can still be delivered through "xfslogd_workqueue",
> which is static and not per-XFS. But this callback has a pointer to
> "xfs_mount", and may try to access it as in [1]. Does this analysis sound
> correct? Kernel is 3.8.13, but looking at the XFS master branch, it might
> have the same issue.
> 

Seems possible... we call xfs_buf_delwri_submit() via log recovery which
does an xfs_buf_iowait() on each buffer for synchronous I/O.
xfs_buf_iowait() doesn't wait on b_iowait if b_error is set, however. In
the callback side, xfs_buf_ioerror() is called before the
_xfs_buf_ioend() sequence that calls into the workqueue. Perhaps the
error can be detected by the iowait before the xfslogd_workqueue job can
run..?

> Should we flush this static workqueue before unmounting?
> 

It's not totally clear that fixes the problem since we set b_error on
the buffer before we even schedule on the workqueue. Perhaps it depends
on the nature of the race. Another option could be to not use the wq on
error, but that may or may not be ideal for other contexts besides log
recovery.

It looks like the bio code always returns error via the callback and the
xlog_recover_iodone() handler does call back into ioend, presumably to
do the io completion. It might not be appropriate to remove the b_error
bypass in xfs_buf_iowait() as we have ioerror() callers on the buffer
that can occur before I/O submission, but I wonder if it could be made
conditional for this particular case. That would be an interesting
experiment at least to see if it fixes this problem.

Brian

> Thanks,
> Alex.
> 
> 
> [1]
> [49133.804546] general protection fault: 0000 [#1] SMP
> [49133.808033]  xcbc rmd160 crypto_null af_key xfrm_algo scsi_dh cirrus
> psmouse ttm drm_kms_helper serio_raw drm i2c_piix4 sysimgblt virtio_balloon
> sysfillrect syscopyarea nfsd(OF) kvm nfs_acl auth_rpcgss nfs fscache
> microcode lockd mac_hid sunrpc lp parport floppy ixgbevf(OF)
> [49133.808033] CPU 2
> [49133.808033] Pid: 2907, comm: kworker/2:1H Tainted: GF       W  O
> 3.8.13-030813-generic #201305111843 Bochs Bochs
> [49133.808033] RIP: 0010:[<ffffffff813582fb>]  [<ffffffff813582fb>]
> strnlen+0xb/0x30
> [49133.808033] RSP: 0018:ffff8801e31c5b08  EFLAGS: 00010086
> [49133.808033] RAX: 0000000000000000 RBX: ffffffff81e4e527 RCX:
> 0000000000000000
> [49133.808033] RDX: 640000450008cf9d RSI: ffffffffffffffff RDI:
> 640000450008cf9d
> [49133.808033] RBP: ffff8801e31c5b08 R08: 000000000000ffff R09:
> 000000000000ffff
> [49133.808033] R10: 0000000000000000 R11: 0000000000000ffe R12:
> 640000450008cf9d
> [49133.808033] R13: ffffffff81e4e900 R14: 0000000000000000 R15:
> 000000000000ffff
> [49133.808033] FS:  0000000000000000(0000) GS:ffff88021fd00000(0000)
> knlGS:0000000000000000
> [49133.808033] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [49133.808033] CR2: 00007fa4a91abd80 CR3: 000000020e783000 CR4:
> 00000000000006e0
> [49133.808033] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [49133.808033] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> 0000000000000400
> [49133.808033] Process kworker/2:1H (pid: 2907, threadinfo ffff8801e31c4000,
> task ffff8802124f45c0)
> [49133.808033] Stack:
> [49133.808033]  ffff8801e31c5b48 ffffffff81359d8e ffff8801e31c5b28
> ffffffff81e4e527
> [49133.808033]  ffffffffa0636a1e ffff8801e31c5c80 ffffffffa0636a1e
> ffffffff81e4e900
> [49133.808033]  ffff8801e31c5bc8 ffffffff8135af89 ffff8801e31c5bc8
> ffffffff8105a4e7
> [49133.808033] Call Trace:
> [49133.808033]  [<ffffffff81359d8e>] string.isra.4+0x3e/0xd0
> [49133.808033]  [<ffffffff8135af89>] vsnprintf+0x219/0x640
> [49133.808033]  [<ffffffff8105a4e7>] ? msg_print_text+0xb7/0x1b0
> [49133.808033]  [<ffffffff8135b471>] vscnprintf+0x11/0x30
> [49133.808033]  [<ffffffff8105b3b1>] vprintk_emit+0xc1/0x490
> [49133.808033]  [<ffffffff8105b460>] ? vprintk_emit+0x170/0x490
> [49133.808033]  [<ffffffff816d5848>] printk+0x61/0x63
> [49133.808033]  [<ffffffffa05ba261>] __xfs_printk+0x31/0x50 [xfs]
> [49133.808033]  [<ffffffffa05ba4b3>] xfs_notice+0x53/0x60 [xfs]
> [49133.808033]  [<ffffffffa05b14a5>] xfs_do_force_shutdown+0xf5/0x180 [xfs]
> [49133.808033]  [<ffffffffa05f6c38>] ? xlog_recover_iodone+0x48/0x70 [xfs]
> [49133.808033]  [<ffffffffa05f6c38>] xlog_recover_iodone+0x48/0x70 [xfs]
> [49133.808033]  [<ffffffffa05a749d>] xfs_buf_iodone_work+0x4d/0xa0 [xfs]
> [49133.808033]  [<ffffffff81078b81>] process_one_work+0x141/0x490
> [49133.808033]  [<ffffffff81079b48>] worker_thread+0x168/0x400
> [49133.808033]  [<ffffffff810799e0>] ? manage_workers+0x120/0x120
> [49133.808033]  [<ffffffff8107f050>] kthread+0xc0/0xd0
> [49133.808033]  [<ffffffff8107ef90>] ? flush_kthread_worker+0xb0/0xb0
> [49133.808033]  [<ffffffff816f61ec>] ret_from_fork+0x7c/0xb0
> [49133.808033]  [<ffffffff8107ef90>] ? flush_kthread_worker+0xb0/0xb0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
