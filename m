Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1OMdpCg170121 for <xfs@oss.sgi.com>; Tue, 24 Feb 2009 16:39:52 -0600
Received: from e39.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B30A314D554
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2009 14:39:19 -0800 (PST)
Received: from e39.co.us.ibm.com (e39.co.us.ibm.com [32.97.110.160]) by
	cuda.sgi.com with ESMTP id smXKRFyiTKlcAprE for
	<xfs@oss.sgi.com>; Tue, 24 Feb 2009 14:39:19 -0800 (PST)
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com
	[9.17.195.106])
	by e39.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n1OMaicH002835
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2009 15:36:44 -0700
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id
	n1OMdGWp094212 for <xfs@oss.sgi.com>; Tue, 24 Feb 2009 15:39:16 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id
	n1OMdFax029555 for <xfs@oss.sgi.com>; Tue, 24 Feb 2009 15:39:16 -0700
Subject: Re: next-20090220: XFS, IMA: BUG: sleeping function called from
	invalid  context at mm/slub.c:1613
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
In-Reply-To: <20090220122242.b36a778f.akpm@linux-foundation.org>
References: <a4423d670902200300n1d1bfdeeg6daca4b32989c9d3@mail.gmail.com>
	<20090220122242.b36a778f.akpm@linux-foundation.org>
Date: Tue, 24 Feb 2009 17:39:14 -0500
Message-Id: <1235515154.2953.14.camel@localhost.localdomain>
Mime-Version: 1.0
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
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, Alexander Beregalov <a.beregalov@gmail.com>, xfs@oss.sgi.com

On Fri, 2009-02-20 at 12:22 -0800, Andrew Morton wrote:

> But to fix this bug, xfs needs to stop calling inode_init_always()
> under read_lock().  Because inode_alloc_security() also can sleep (see
> new_inode_smack()).

Yes, even without IMA enabled, with SELINUX, PREEMPT, and DEBUG_PREEMPT
enabled, I'm seeing the problem:

Feb 24 17:37:52 iicu10 kernel: BUG: sleeping function called from invalid context at mm/slub.c:1613
Feb 24 17:37:52 iicu10 kernel: in_atomic(): 1, irqs_disabled(): 0, pid: 3209, name: vi
Feb 24 17:37:52 iicu10 kernel: Pid: 3209, comm: vi Tainted: P           2.6.29-rc6-next-20090224 #5
Feb 24 17:37:52 iicu10 kernel: Call Trace:
Feb 24 17:37:52 iicu10 kernel: [<ffffffff8103d2c1>] __might_sleep+0x120/0x122
Feb 24 17:37:52 iicu10 kernel: [<ffffffff810c9a96>] kmem_cache_alloc+0x32/0xd1
Feb 24 17:37:52 iicu10 kernel: [<ffffffff811563ca>] selinux_inode_alloc_security+0x39/0x90
Feb 24 17:37:52 iicu10 kernel: [<ffffffff8114ef12>] security_inode_alloc+0x1c/0x1e
Feb 24 17:37:52 iicu10 kernel: [<ffffffff810e15b3>] inode_init_always+0xc3/0x1dc
Feb 24 17:37:52 iicu10 kernel: [<ffffffffa0031a34>] xfs_iget+0x14e/0x49e [xfs]
Feb 24 17:37:52 iicu10 kernel: [<ffffffffa00462c2>] xfs_trans_iget+0xa6/0xd4 [xfs]
Feb 24 17:37:52 iicu10 kernel: [<ffffffffa003463c>] xfs_ialloc+0x96/0x517 [xfs]
Feb 24 17:37:52 iicu10 kernel: [<ffffffff8118b5e2>] ? _raw_spin_lock+0x6c/0x112
Feb 24 17:37:52 iicu10 kernel: [<ffffffff8118b5e2>] ? _raw_spin_lock+0x6c/0x112
Feb 24 17:37:52 iicu10 kernel: [<ffffffffa0046bb1>] xfs_dir_ialloc+0x73/0x26a [x

Mimi Zohar

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
