Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F40397F3F
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2014 06:52:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 840C7AC003
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2014 04:52:48 -0700 (PDT)
Received: from mail-ob0-f169.google.com (mail-ob0-f169.google.com
	[209.85.214.169]) by cuda.sgi.com with ESMTP id
	7TTq1RaadIsrT3Rb (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 16 Oct 2014 04:52:44 -0700 (PDT)
Received: by mail-ob0-f169.google.com with SMTP id m8so2706820obr.28
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2014 04:52:43 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 16 Oct 2014 07:52:43 -0400
Message-ID: <CA+5PVA4FqAUXbtTtC-hZnAaw=869kfrAjM1vRrqcP=zgveAKJg@mail.gmail.com>
Subject: XFS lockdep with Linux v3.17-5503-g35a9ad8af0bb
From: Josh Boyer <jwboyer@fedoraproject.org>
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
To: Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

Hi All,

Colin reported a lockdep spew with XFS using Linus' tree last week.
The lockdep report is below.  He noted that his application was using
splice.

josh

[1] https://bugzilla.redhat.com/show_bug.cgi?id=1152813

[14689.265161] ======================================================
[14689.265175] [ INFO: possible circular locking dependency detected ]
[14689.265186] 3.18.0-0.rc0.git2.1.fc22.x86_64 #1 Not tainted
[14689.265190] -------------------------------------------------------
[14689.265199] atomic/1144 is trying to acquire lock:
[14689.265203]  (&sb->s_type->i_mutex_key#13){+.+.+.}, at:
[<ffffffffa01465ba>] xfs_file_buffered_aio_write.isra.10+0x7a/0x310
[xfs]
[14689.265245]
but task is already holding lock:
[14689.265249]  (&pipe->mutex/1){+.+.+.}, at: [<ffffffff8126937e>]
pipe_lock+0x1e/0x20
[14689.265262]
which lock already depends on the new lock.

[14689.265268]
the existing dependency chain (in reverse order) is:
[14689.265287]
-> #2 (&pipe->mutex/1){+.+.+.}:
[14689.265296]        [<ffffffff810ffde4>] lock_acquire+0xa4/0x1d0
[14689.265303]        [<ffffffff8183e5b5>] mutex_lock_nested+0x85/0x440
[14689.265310]        [<ffffffff8126937e>] pipe_lock+0x1e/0x20
[14689.265315]        [<ffffffff8129836a>] splice_to_pipe+0x2a/0x260
[14689.265321]        [<ffffffff81298b9f>]
__generic_file_splice_read+0x57f/0x620
[14689.265328]        [<ffffffff81298c7b>] generic_file_splice_read+0x3b/0x90
[14689.265334]        [<ffffffffa0145b20>] xfs_file_splice_read+0xb0/0x1e0 [xfs]
[14689.265350]        [<ffffffff812976ac>] do_splice_to+0x6c/0x90
[14689.265356]        [<ffffffff81299e7d>] SyS_splice+0x6dd/0x800
[14689.265362]        [<ffffffff81842f69>] system_call_fastpath+0x16/0x1b
[14689.265368]
-> #1 (&(&ip->i_iolock)->mr_lock){++++++}:
[14689.265424]        [<ffffffff810ffde4>] lock_acquire+0xa4/0x1d0
[14689.265494]        [<ffffffff810f87be>] down_write_nested+0x5e/0xc0
[14689.265553]        [<ffffffffa0153529>] xfs_ilock+0xb9/0x1c0 [xfs]
[14689.265629]        [<ffffffffa01465c7>]
xfs_file_buffered_aio_write.isra.10+0x87/0x310 [xfs]
[14689.265693]        [<ffffffffa01468da>] xfs_file_write_iter+0x8a/0x130 [xfs]
[14689.265749]        [<ffffffff8126019e>] new_sync_write+0x8e/0xd0
[14689.265811]        [<ffffffff81260a3a>] vfs_write+0xba/0x200
[14689.265862]        [<ffffffff812616ac>] SyS_write+0x5c/0xd0
[14689.265912]        [<ffffffff81842f69>] system_call_fastpath+0x16/0x1b
[14689.265963]
-> #0 (&sb->s_type->i_mutex_key#13){+.+.+.}:
[14689.266024]        [<ffffffff810ff45e>] __lock_acquire+0x1b0e/0x1c10
[14689.266024]        [<ffffffff810ffde4>] lock_acquire+0xa4/0x1d0
[14689.266024]        [<ffffffff8183e5b5>] mutex_lock_nested+0x85/0x440
[14689.266024]        [<ffffffffa01465ba>]
xfs_file_buffered_aio_write.isra.10+0x7a/0x310 [xfs]
[14689.266024]        [<ffffffffa01468da>] xfs_file_write_iter+0x8a/0x130 [xfs]
[14689.266024]        [<ffffffff81297ffc>] iter_file_splice_write+0x2ec/0x4b0
[14689.266024]        [<ffffffff81299b21>] SyS_splice+0x381/0x800
[14689.266024]        [<ffffffff81842f69>] system_call_fastpath+0x16/0x1b
[14689.266024]
other info that might help us debug this:

[14689.266024] Chain exists of:
  &sb->s_type->i_mutex_key#13 --> &(&ip->i_iolock)->mr_lock --> &pipe->mutex/1

[14689.266024]  Possible unsafe locking scenario:

[14689.266024]        CPU0                    CPU1
[14689.266024]        ----                    ----
[14689.266024]   lock(&pipe->mutex/1);
[14689.266024]                                lock(&(&ip->i_iolock)->mr_lock);
[14689.266024]                                lock(&pipe->mutex/1);
[14689.266024]   lock(&sb->s_type->i_mutex_key#13);
[14689.266024]
 *** DEADLOCK ***

[14689.266024] 2 locks held by atomic/1144:
[14689.266024]  #0:  (sb_writers#8){.+.+.+}, at: [<ffffffff81299f1f>]
SyS_splice+0x77f/0x800
[14689.266024]  #1:  (&pipe->mutex/1){+.+.+.}, at:
[<ffffffff8126937e>] pipe_lock+0x1e/0x20
[14689.266024]
stack backtrace:
[14689.266024] CPU: 0 PID: 1144 Comm: atomic Not tainted
3.18.0-0.rc0.git2.1.fc22.x86_64 #1
[14689.266024] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[14689.266024]  0000000000000000 00000000fd91796b ffff88003793bad0
ffffffff81838f3e
[14689.266024]  ffffffff82c03eb0 ffff88003793bb10 ffffffff81836b36
ffff88003793bb70
[14689.266024]  ffff88003828a670 ffff880038289a40 0000000000000002
ffff880038289ab0
[14689.266024] Call Trace:
[14689.266024]  [<ffffffff81838f3e>] dump_stack+0x4d/0x66
[14689.266024]  [<ffffffff81836b36>] print_circular_bug+0x201/0x20f
[14689.266024]  [<ffffffff810ff45e>] __lock_acquire+0x1b0e/0x1c10
[14689.266024]  [<ffffffff8101c8c0>] ? dump_trace+0x170/0x350
[14689.266024]  [<ffffffff810ffde4>] lock_acquire+0xa4/0x1d0
[14689.266024]  [<ffffffffa01465ba>] ?
xfs_file_buffered_aio_write.isra.10+0x7a/0x310 [xfs]
[14689.266024]  [<ffffffff8183e5b5>] mutex_lock_nested+0x85/0x440
[14689.266024]  [<ffffffffa01465ba>] ?
xfs_file_buffered_aio_write.isra.10+0x7a/0x310 [xfs]
[14689.266024]  [<ffffffffa01465ba>] ?
xfs_file_buffered_aio_write.isra.10+0x7a/0x310 [xfs]
[14689.266024]  [<ffffffff810fd36c>] ? mark_held_locks+0x7c/0xb0
[14689.266024]  [<ffffffffa01465ba>]
xfs_file_buffered_aio_write.isra.10+0x7a/0x310 [xfs]
[14689.266024]  [<ffffffff8126937e>] ? pipe_lock+0x1e/0x20
[14689.266024]  [<ffffffffa01468da>] xfs_file_write_iter+0x8a/0x130 [xfs]
[14689.266024]  [<ffffffff81297ffc>] iter_file_splice_write+0x2ec/0x4b0
[14689.266024]  [<ffffffff81299b21>] SyS_splice+0x381/0x800
[14689.266024]  [<ffffffff81842f69>] system_call_fastpath+0x16/0x1b

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
