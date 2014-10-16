Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3A57E7F3F
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2014 17:14:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F0DF58F8033
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2014 15:14:40 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	u16HmSL9t6HCBfPz for <xfs@oss.sgi.com>;
	Thu, 16 Oct 2014 15:14:38 -0700 (PDT)
Date: Fri, 17 Oct 2014 09:14:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: splice read/write pipe lock ordering issues (was Re: XFS lockdep
	with Linux v3.17-5503-g35a9ad8af0bb)
Message-ID: <20141016221434.GF7169@dastard>
References: <CA+5PVA4FqAUXbtTtC-hZnAaw=869kfrAjM1vRrqcP=zgveAKJg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+5PVA4FqAUXbtTtC-hZnAaw=869kfrAjM1vRrqcP=zgveAKJg@mail.gmail.com>
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
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: linux-fsdevel@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>, viro@ZenIV.linux.org.uk, xfs@oss.sgi.com

[ Adding Al and linux-fsdevel to the cc list ]

On Thu, Oct 16, 2014 at 07:52:43AM -0400, Josh Boyer wrote:
> Hi All,
> 
> Colin reported a lockdep spew with XFS using Linus' tree last week.
> The lockdep report is below.  He noted that his application was using
> splice.

That smells like a splice architecture bug. splice write puts the
pipe lock outside the inode locks, but splice read puts the pipes
locks *inside* the inode locks.

The recent commit 8d02076 "(->splice_write() via ->write_iter()")
which went into 3.16 will be what is causing this. It replaced a
long standing splice lock inversion problem (XFS iolock vs i_mutex
http://oss.sgi.com/archives/xfs/2011-08/msg00122.html) by moving
to a ->write_iter call under the pipe_lock.

Only XFS reports this issue because XFS is the only filesystem that
serialises splice reads against truncate, concurrent writes into the
same region, extent manipulation functions via fallocate() (e.g.
hole punch), etc. and it does so via the inode iolock that it takes
in shared (read) mode during xfs_file_splice_read().

> josh
> 
> [1] https://bugzilla.redhat.com/show_bug.cgi?id=1152813
> 
> [14689.265161] ======================================================
> [14689.265175] [ INFO: possible circular locking dependency detected ]
> [14689.265186] 3.18.0-0.rc0.git2.1.fc22.x86_64 #1 Not tainted
> [14689.265190] -------------------------------------------------------
> [14689.265199] atomic/1144 is trying to acquire lock:
> [14689.265203]  (&sb->s_type->i_mutex_key#13){+.+.+.}, at:
> [<ffffffffa01465ba>] xfs_file_buffered_aio_write.isra.10+0x7a/0x310
> [xfs]
> [14689.265245]
> but task is already holding lock:
> [14689.265249]  (&pipe->mutex/1){+.+.+.}, at: [<ffffffff8126937e>]
> pipe_lock+0x1e/0x20
> [14689.265262]
> which lock already depends on the new lock.
> 
> [14689.265268]
> the existing dependency chain (in reverse order) is:
> [14689.265287]
> -> #2 (&pipe->mutex/1){+.+.+.}:
> [14689.265296]        [<ffffffff810ffde4>] lock_acquire+0xa4/0x1d0
> [14689.265303]        [<ffffffff8183e5b5>] mutex_lock_nested+0x85/0x440
> [14689.265310]        [<ffffffff8126937e>] pipe_lock+0x1e/0x20
> [14689.265315]        [<ffffffff8129836a>] splice_to_pipe+0x2a/0x260
> [14689.265321]        [<ffffffff81298b9f>]
> __generic_file_splice_read+0x57f/0x620
> [14689.265328]        [<ffffffff81298c7b>] generic_file_splice_read+0x3b/0x90
> [14689.265334]        [<ffffffffa0145b20>] xfs_file_splice_read+0xb0/0x1e0 [xfs]
> [14689.265350]        [<ffffffff812976ac>] do_splice_to+0x6c/0x90
> [14689.265356]        [<ffffffff81299e7d>] SyS_splice+0x6dd/0x800
> [14689.265362]        [<ffffffff81842f69>] system_call_fastpath+0x16/0x1b

splice read -> iolock(shared) -> pipe lock.

> [14689.265368]
> -> #1 (&(&ip->i_iolock)->mr_lock){++++++}:
> [14689.265424]        [<ffffffff810ffde4>] lock_acquire+0xa4/0x1d0
> [14689.265494]        [<ffffffff810f87be>] down_write_nested+0x5e/0xc0
> [14689.265553]        [<ffffffffa0153529>] xfs_ilock+0xb9/0x1c0 [xfs]
> [14689.265629]        [<ffffffffa01465c7>]
> xfs_file_buffered_aio_write.isra.10+0x87/0x310 [xfs]
> [14689.265693]        [<ffffffffa01468da>] xfs_file_write_iter+0x8a/0x130 [xfs]
> [14689.265749]        [<ffffffff8126019e>] new_sync_write+0x8e/0xd0
> [14689.265811]        [<ffffffff81260a3a>] vfs_write+0xba/0x200
> [14689.265862]        [<ffffffff812616ac>] SyS_write+0x5c/0xd0
> [14689.265912]        [<ffffffff81842f69>] system_call_fastpath+0x16/0x1b

write(2) -> i_mutex -> iolock(exclusive)

> [14689.265963]
> -> #0 (&sb->s_type->i_mutex_key#13){+.+.+.}:
> [14689.266024]        [<ffffffff810ff45e>] __lock_acquire+0x1b0e/0x1c10
> [14689.266024]        [<ffffffff810ffde4>] lock_acquire+0xa4/0x1d0
> [14689.266024]        [<ffffffff8183e5b5>] mutex_lock_nested+0x85/0x440
> [14689.266024]        [<ffffffffa01465ba>]
> xfs_file_buffered_aio_write.isra.10+0x7a/0x310 [xfs]
> [14689.266024]        [<ffffffffa01468da>] xfs_file_write_iter+0x8a/0x130 [xfs]
> [14689.266024]        [<ffffffff81297ffc>] iter_file_splice_write+0x2ec/0x4b0
> [14689.266024]        [<ffffffff81299b21>] SyS_splice+0x381/0x800
> [14689.266024]        [<ffffffff81842f69>] system_call_fastpath+0x16/0x1b

splice write -> pipe lock -> i_mutex [ -> iolock(exclusive) ]

This reminds me of the mmap_sem and all the problems we have because
we can't serialise page faults against IO path and data manipulation
functions (e.g. hole punch). We shouldn't be repeating that disaster
is we can avoid it....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
