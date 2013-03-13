Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1A82B7F37
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 23:43:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C3169304067
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 21:43:11 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	mXGjuh9QuDzwCr5r for <xfs@oss.sgi.com>;
	Tue, 12 Mar 2013 21:43:09 -0700 (PDT)
Date: Wed, 13 Mar 2013 15:43:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 3.9-rc2 xfs panic
Message-ID: <20130313044307.GV21651@dastard>
References: <20130312074608.GL21651@dastard>
	<1063371063.191362.1363142676803.JavaMail.root@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1063371063.191362.1363142676803.JavaMail.root@redhat.com>
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
To: CAI Qian <caiqian@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Mar 12, 2013 at 10:44:36PM -0400, CAI Qian wrote:
> Eek, got another NULL pointer on an x64 system also. Looks like from
> xfstests case 110. Same user-space version as the one in the ppc64
> case. Still trying to reproduce and without more debugging options
> enabled if possible.
> 
> Swap Size               = 7983 MB
> Mem Size                = 7852 MB
> Number of Processors    = 16
> 
> meta-data=/dev/loop0             isize=256    agcount=4, agsize=655360 blks
>          =                       sectsz=512   attr=2, projid32bit=0
> data     =                       bsize=2048   blocks=2621440, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal log           bsize=2048   blocks=5120, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> CAI Qian
> 
> [30706.240701] XFS (loop1): xfs_trans_ail_delete_bulk: attempting to delete a log item that is not in the AIL 

What happens prior to this message? This is the first indication of
a problem....

> [30706.242124] XFS (loop1): xfs_do_force_shutdown(0x2) called from line 743 of file fs/xfs/xfs_trans_ail.c.  Return address = 0xffffffffa03c03ef 
> [30706.245280] XFS (loop1): Log I/O Error Detected.  Shutting down filesystem 
> [30706.246311] XFS (loop1): Please umount the filesystem and rectify the problem(s) 
> [30707.279880] XFS (loop0): Mounting Filesystem 
> [30707.290512] XFS (loop0): Ending clean mount 
> [30708.966751] XFS (loop1): xfs_log_force: error 5 returned. 
> [30708.977075] XFS (loop1): xfs_log_force: error 5 returned. 
> [30708.978074] BUG: unable to handle kernel NULL pointer dereference at 0000000000000230 
> [30708.979629] IP: [<ffffffffa03655e7>] xfs_bdstrat_cb+0x27/0xd0 [xfs] 

And that indicates that the buftarg attached to the buffer has a
NULL xfs_mount pointer, so it's probably related to the above issue.

As it is, none of my machines see this problem, so I'm wondering if
this is related to the way you are using loop devices. Can you
reproduce it on a different type of storage device (like LVm of
physical disk partitions)?

Also, can you turn on CONFIG_XFS_DEBUG and all the memory
leak/poisoning checks and see if that catches anything.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
