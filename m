Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AC2AB7CBE
	for <xfs@oss.sgi.com>; Fri,  7 Feb 2014 18:46:50 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 95549304066
	for <xfs@oss.sgi.com>; Fri,  7 Feb 2014 16:46:47 -0800 (PST)
Received: from e8.ny.us.ibm.com (e8.ny.us.ibm.com [32.97.182.138]) by
	cuda.sgi.com with ESMTP id 6p06gR4BdquKCX7q (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 07 Feb 2014 16:46:43 -0800 (PST)
Received: from /spool/local
	by e8.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <cody@linux.vnet.ibm.com>;
	Fri, 7 Feb 2014 19:46:43 -0500
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com
	[9.57.198.25])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 9A7896E803A
	for <xfs@oss.sgi.com>; Fri,  7 Feb 2014 19:46:36 -0500 (EST)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by b01cxnp22035.gho.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	s180keqq6488364 for <xfs@oss.sgi.com>; Sat, 8 Feb 2014 00:46:41 GMT
Received: from d01av03.pok.ibm.com (localhost [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
	s180ke3E028073 for <xfs@oss.sgi.com>; Fri, 7 Feb 2014 19:46:40 -0500
Received: from [9.80.95.14] ([9.80.95.14])
	by d01av03.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVin) with ESMTP id
	s180keO1028045 for <xfs@oss.sgi.com>; Fri, 7 Feb 2014 19:46:40 -0500
Message-ID: <52F57E6C.10907@linux.vnet.ibm.com>
Date: Fri, 07 Feb 2014 16:46:36 -0800
From: Cody P Schafer <cody@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: lockdep warning in 3.14-rc1
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
To: xfs@oss.sgi.com

Appears consistently during boot up.

$ uname -a
Linux hostname 3.14.0-rc1-24x7+ #8 SMP Fri Feb 7 15:32:43 CST 2014 ppc64 ppc64 ppc64 GNU/Linux

[    1.953983] audit: type=1403 audit(1391808989.120:3): policy loaded auid=4294967295 ses=4294967295
[    1.957980] systemd[1]: Successfully loaded SELinux policy in 323.280ms.
[    2.048622] systemd[1]: Relabelled /dev and /run in 22.877ms.

[    2.080219] ======================================================
[    2.080223] [ INFO: possible circular locking dependency detected ]
[    2.080227] 3.14.0-rc1-24x7+ #8 Tainted: G        W   
[    2.080230] -------------------------------------------------------
[    2.080234] systemd/1 is trying to acquire lock:
[    2.080238]  (&mm->mmap_sem){++++++}, at: [<c00000000021fe18>] .might_fault+0x78/0xe0
[    2.080249] 
but task is already holding lock:
[    2.080253]  (&(&ip->i_lock)->mr_lock){++++..}, at: [<c00000000042e7ec>] .xfs_ilock+0x15c/0x1b0
[    2.080262] 
which lock already depends on the new lock.

[    2.080267] 
the existing dependency chain (in reverse order) is:
[    2.080271] 
-> #1 (&(&ip->i_lock)->mr_lock){++++..}:
[    2.080278] 
-> #0 (&mm->mmap_sem){++++++}:
[    2.080284] 
other info that might help us debug this:

[    2.080289]  Possible unsafe locking scenario:

[    2.080292]        CPU0                    CPU1
[    2.080295]        ----                    ----
[    2.080298]   lock(&(&ip->i_lock)->mr_lock);
[    2.080303]                                lock(&mm->mmap_sem);
[    2.080307]                                lock(&(&ip->i_lock)->mr_lock);
[    2.080312]   lock(&mm->mmap_sem);
[    2.080316] 
 *** DEADLOCK ***

[    2.080321] 2 locks held by systemd/1:
[    2.080323]  #0:  (&type->i_mutex_dir_key#2){+.+.+.}, at: [<c000000000297470>] .iterate_dir+0xa0/0x160
[    2.080334]  #1:  (&(&ip->i_lock)->mr_lock){++++..}, at: [<c00000000042e7ec>] .xfs_ilock+0x15c/0x1b0
[    2.080343] 
stack backtrace:
[    2.080348] CPU: 2 PID: 1 Comm: systemd Tainted: G        W    3.14.0-rc1-24x7+ #8
[    2.080353] Call Trace:
[    2.080357] [c0000001fa103370] [c000000000016590] .show_stack+0x170/0x290 (unreliable)
[    2.080364] [c0000001fa103460] [c000000000934f5c] .dump_stack+0xa0/0xdc
[    2.080370] [c0000001fa1034e0] [c00000000092b6b4] .print_circular_bug+0x364/0x39c
[    2.080376] [c0000001fa103590] [c00000000010ba70] .check_prev_add+0x8d0/0x8e0
[    2.080381] [c0000001fa1036a0] [c00000000010c364] .validate_chain.isra.31+0x8e4/0xc40
[    2.080386] [c0000001fa103790] [c00000000010de08] .__lock_acquire+0x488/0xd40
[    2.080391] [c0000001fa1038b0] [c00000000010f08c] .lock_acquire+0xac/0x190
[    2.080397] [c0000001fa103980] [c00000000021fe44] .might_fault+0xa4/0xe0
[    2.080402] [c0000001fa1039f0] [c000000000297924] .filldir+0x1f4/0x290
[    2.080407] [c0000001fa103ab0] [c0000000003cebc8] .xfs_dir2_block_getdents+0x218/0x2b0
[    2.080413] [c0000001fa103b80] [c0000000003cf1e8] .xfs_readdir+0x168/0x1d0
[    2.080418] [c0000001fa103c30] [c0000000003d2508] .xfs_file_readdir+0x48/0x80
[    2.080423] [c0000001fa103cc0] [c0000000002974ec] .iterate_dir+0x11c/0x160
[    2.080428] [c0000001fa103d60] [c000000000297df0] .SyS_getdents+0xa0/0x190
[    2.080433] [c0000001fa103e30] [c00000000000a164] syscall_exit+0x0/0x98

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
