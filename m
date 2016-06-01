Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8D1C47CA2
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2016 02:10:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0402DAC001
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2016 00:10:53 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	WFrR1wCa0ggWlDUw for <xfs@oss.sgi.com>;
	Wed, 01 Jun 2016 00:10:50 -0700 (PDT)
Date: Wed, 1 Jun 2016 17:10:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Internal error xfs_trans_cancel
Message-ID: <20160601071047.GJ12670@dastard>
References: <ab487269-a423-e3dc-6f59-3dda004960c3@monom.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <ab487269-a423-e3dc-6f59-3dda004960c3@monom.org>
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
Cc: linux-fsdevel@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Wed, Jun 01, 2016 at 07:52:31AM +0200, Daniel Wagner wrote:
> Hi,
> 
> I got the error message below while compiling a kernel 
> on that system. I can't really say if I did something
> which made the file system unhappy before the crash.
> 
> 
> [Jun 1 07:41] XFS (sde1): Internal error xfs_trans_cancel at line 984 of file fs/xfs/xfs_trans.c.  Caller xfs_rename+0x453/0x960 [xfs]

Anything in the log before this?

> [  +0.000095] CPU: 22 PID: 8640 Comm: gcc Not tainted 4.7.0-rc1 #16
> [  +0.000035] Hardware name: Dell Inc. PowerEdge R820/066N7P, BIOS 2.0.20 01/16/2014
> [  +0.000048]  0000000000000286 00000000c8be6bc3 ffff885fa9473cb0 ffffffff813d146e
> [  +0.000056]  ffff885fa9ac5ed0 0000000000000001 ffff885fa9473cc8 ffffffffa0213cdc
> [  +0.000053]  ffffffffa02257b3 ffff885fa9473cf0 ffffffffa022eb36 ffff883faa502d00
> [  +0.000053] Call Trace:
> [  +0.000028]  [<ffffffff813d146e>] dump_stack+0x63/0x85
> [  +0.000069]  [<ffffffffa0213cdc>] xfs_error_report+0x3c/0x40 [xfs]
> [  +0.000065]  [<ffffffffa02257b3>] ? xfs_rename+0x453/0x960 [xfs]
> [  +0.000064]  [<ffffffffa022eb36>] xfs_trans_cancel+0xb6/0xe0 [xfs]
> [  +0.000065]  [<ffffffffa02257b3>] xfs_rename+0x453/0x960 [xfs]
> [  +0.000062]  [<ffffffffa021fa63>] xfs_vn_rename+0xb3/0xf0 [xfs]
> [  +0.000040]  [<ffffffff8124f92c>] vfs_rename+0x58c/0x8d0
> [  +0.000032]  [<ffffffff81253fb1>] SyS_rename+0x371/0x390
> [  +0.000036]  [<ffffffff817d2032>] entry_SYSCALL_64_fastpath+0x1a/0xa4
> [  +0.000040] XFS (sde1): xfs_do_force_shutdown(0x8) called from line 985 of file fs/xfs/xfs_trans.c.  Return address = 0xffffffffa022eb4f
> [  +0.027680] XFS (sde1): Corruption of in-memory data detected.  Shutting down filesystem
> [  +0.000057] XFS (sde1): Please umount the filesystem and rectify the problem(s)
> [Jun 1 07:42] XFS (sde1): xfs_log_force: error -5 returned.
> [ +30.081016] XFS (sde1): xfs_log_force: error -5 returned.

Doesn't normally happen, and there's not a lot to go on here. Can
you provide the info listed in the link below so we have some idea
of what configuration the error occurred on?

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

You didn't run out of space or something unusual like that?  Does
'xfs_repair -n <dev>' report any errors?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
