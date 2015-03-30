Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4A2F87F58
	for <xfs@oss.sgi.com>; Mon, 30 Mar 2015 14:40:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4455D8F8050
	for <xfs@oss.sgi.com>; Mon, 30 Mar 2015 12:40:22 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	QayyMQMixmDkHU0J for <xfs@oss.sgi.com>;
	Mon, 30 Mar 2015 12:40:19 -0700 (PDT)
Date: Tue, 31 Mar 2015 06:40:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: deadlock between &type->i_mutex_dir_key#4 and &xfs_dir_ilock_class
Message-ID: <20150330194016.GC28621@dastard>
References: <5518FB4A.4070200@monom.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5518FB4A.4070200@monom.org>
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
To: Daniel Wagner <wagi@monom.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Mon, Mar 30, 2015 at 09:29:14AM +0200, Daniel Wagner wrote:
> Hi,
> 
> Just my test box booted 4.0.0-rc6 and I was greeted by:
> 
> 
> [Mar30 10:10] ======================================================
> [  +0.000043] [ INFO: possible circular locking dependency detected ]
> [  +0.000045] 4.0.0-rc6 #32 Not tainted
> [  +0.000027] -------------------------------------------------------
> [  +0.000042] ls/1709 is trying to acquire lock:
> [  +0.000034]  (&mm->mmap_sem){++++++}, at: [<ffffffff811e62cf>] might_fault+0x5f/0xb0
> [  +0.000083] 
> but task is already holding lock:
> [  +0.000043]  (&xfs_dir_ilock_class){.+.+..}, at: [<ffffffffa0424902>] xfs_ilock+0xc2/0x130 [xfs]
> [  +0.000110] 
> which lock already depends on the new lock.

No deadlock. Problem is the shmem code, which is doing inode
instantiation under the mmap_sem, thereby inverting the entire vfs
locking order w.r.t. to the mmap_sem....

i.e. this one:

> -> #1 (&isec->lock){+.+.+.}:
> [  +0.000045]        [<ffffffff810ef987>] lock_acquire+0xc7/0x160
> [  +0.000045]        [<ffffffff817e273d>] mutex_lock_nested+0x7d/0x450
> [  +0.000045]        [<ffffffff8135a755>] inode_doinit_with_dentry+0xc5/0x6a0
> [  +0.000050]        [<ffffffff8135b91c>] selinux_d_instantiate+0x1c/0x20
> [  +0.001072]        [<ffffffff8134ef9b>] security_d_instantiate+0x1b/0x30
> [  +0.001056]        [<ffffffff81255454>] d_instantiate+0x54/0x80
> [  +0.001052]        [<ffffffff811d24bc>] __shmem_file_setup+0xdc/0x250
> [  +0.001059]        [<ffffffff811d5fd8>] shmem_zero_setup+0x28/0x70
> [  +0.001074]        [<ffffffff811f2168>] mmap_region+0x5d8/0x5f0
> [  +0.001045]        [<ffffffff811f249b>] do_mmap_pgoff+0x31b/0x400
> [  +0.001040]        [<ffffffff811d6540>] vm_mmap_pgoff+0xb0/0xf0
> [  +0.001015]        [<ffffffff811f07e6>] SyS_mmap_pgoff+0x116/0x2b0
> [  +0.001009]        [<ffffffff8101bc12>] SyS_mmap+0x22/0x30
> [  +0.001000]        [<ffffffff817e7589>] system_call_fastpath+0x12/0x17

vm_mmap_pgoff() takes the mmap_sem.

> I tried to find out if this was reported before but I
> haven't found anything. If I missed it I am sorry for the noise.

It's been reported so many times I need a FAQ entry for it. problem
is, i can't fix it easily because it's a shmem bug...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
