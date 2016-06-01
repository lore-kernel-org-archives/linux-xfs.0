Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F0C947CA2
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2016 00:52:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5C6CDAC001
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 22:52:43 -0700 (PDT)
Received: from hotel311.server4you.de (hotel311.server4you.de [85.25.146.15])
	by cuda.sgi.com with ESMTP id frcIhCz0Wp9y8MDZ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 31 May 2016 22:52:38 -0700 (PDT)
From: Daniel Wagner <wagi@monom.org>
Subject: Internal error xfs_trans_cancel
Message-ID: <ab487269-a423-e3dc-6f59-3dda004960c3@monom.org>
Date: Wed, 1 Jun 2016 07:52:31 +0200
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

Hi,

I got the error message below while compiling a kernel 
on that system. I can't really say if I did something
which made the file system unhappy before the crash.


[Jun 1 07:41] XFS (sde1): Internal error xfs_trans_cancel at line 984 of file fs/xfs/xfs_trans.c.  Caller xfs_rename+0x453/0x960 [xfs]
[  +0.000095] CPU: 22 PID: 8640 Comm: gcc Not tainted 4.7.0-rc1 #16
[  +0.000035] Hardware name: Dell Inc. PowerEdge R820/066N7P, BIOS 2.0.20 01/16/2014
[  +0.000048]  0000000000000286 00000000c8be6bc3 ffff885fa9473cb0 ffffffff813d146e
[  +0.000056]  ffff885fa9ac5ed0 0000000000000001 ffff885fa9473cc8 ffffffffa0213cdc
[  +0.000053]  ffffffffa02257b3 ffff885fa9473cf0 ffffffffa022eb36 ffff883faa502d00
[  +0.000053] Call Trace:
[  +0.000028]  [<ffffffff813d146e>] dump_stack+0x63/0x85
[  +0.000069]  [<ffffffffa0213cdc>] xfs_error_report+0x3c/0x40 [xfs]
[  +0.000065]  [<ffffffffa02257b3>] ? xfs_rename+0x453/0x960 [xfs]
[  +0.000064]  [<ffffffffa022eb36>] xfs_trans_cancel+0xb6/0xe0 [xfs]
[  +0.000065]  [<ffffffffa02257b3>] xfs_rename+0x453/0x960 [xfs]
[  +0.000062]  [<ffffffffa021fa63>] xfs_vn_rename+0xb3/0xf0 [xfs]
[  +0.000040]  [<ffffffff8124f92c>] vfs_rename+0x58c/0x8d0
[  +0.000032]  [<ffffffff81253fb1>] SyS_rename+0x371/0x390
[  +0.000036]  [<ffffffff817d2032>] entry_SYSCALL_64_fastpath+0x1a/0xa4
[  +0.000040] XFS (sde1): xfs_do_force_shutdown(0x8) called from line 985 of file fs/xfs/xfs_trans.c.  Return address = 0xffffffffa022eb4f
[  +0.027680] XFS (sde1): Corruption of in-memory data detected.  Shutting down filesystem
[  +0.000057] XFS (sde1): Please umount the filesystem and rectify the problem(s)
[Jun 1 07:42] XFS (sde1): xfs_log_force: error -5 returned.
[ +30.081016] XFS (sde1): xfs_log_force: error -5 returned.


cheers,
daniel

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
