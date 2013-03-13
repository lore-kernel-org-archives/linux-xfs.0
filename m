Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EDC6C7F37
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 23:56:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B0650304077
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 21:56:20 -0700 (PDT)
Received: from mx3-phx2.redhat.com (mx3-phx2.redhat.com [209.132.183.24]) by
	cuda.sgi.com with ESMTP id e8s4La7l1bYc5xEW for
	<xfs@oss.sgi.com>; Tue, 12 Mar 2013 21:56:19 -0700 (PDT)
Date: Wed, 13 Mar 2013 00:56:16 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
Message-ID: <303705686.219049.1363150576604.JavaMail.root@redhat.com>
In-Reply-To: <20130313044307.GV21651@dastard>
Subject: Re: 3.9-rc2 xfs panic
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
Cc: xfs@oss.sgi.com



----- Original Message -----
> From: "Dave Chinner" <david@fromorbit.com>
> To: "CAI Qian" <caiqian@redhat.com>
> Cc: xfs@oss.sgi.com
> Sent: Wednesday, March 13, 2013 12:43:07 PM
> Subject: Re: 3.9-rc2 xfs panic
> 
> On Tue, Mar 12, 2013 at 10:44:36PM -0400, CAI Qian wrote:
> > Eek, got another NULL pointer on an x64 system also. Looks like
> > from
> > xfstests case 110. Same user-space version as the one in the ppc64
> > case. Still trying to reproduce and without more debugging options
> > enabled if possible.
> > 
> > Swap Size               = 7983 MB
> > Mem Size                = 7852 MB
> > Number of Processors    = 16
> > 
> > meta-data=/dev/loop0             isize=256    agcount=4,
> > agsize=655360 blks
> >          =                       sectsz=512   attr=2, projid32bit=0
> > data     =                       bsize=2048   blocks=2621440,
> > imaxpct=25
> >          =                       sunit=0      swidth=0 blks
> > naming   =version 2              bsize=4096   ascii-ci=0
> > log      =internal log           bsize=2048   blocks=5120,
> > version=2
> >          =                       sectsz=512   sunit=0 blks,
> >          lazy-count=1
> > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > 
> > CAI Qian
> > 
> > [30706.240701] XFS (loop1): xfs_trans_ail_delete_bulk: attempting
> > to delete a log item that is not in the AIL
> 
> What happens prior to this message? This is the first indication of
> a problem....
Something might be interesting before those were,
[30409.026043] XFS (loop1): xfs_log_force: error 5 returned. 
[30409.027253] XFS (loop1): xfs_log_force: error 5 returned. 
[30409.028900] XFS (loop1): xfs_log_force: error 5 returned. 
...
[30453.156830] XFS (loop1): Quotacheck: Done. 
[30454.006227] XFS (loop1): xfs_log_force: error 5 returned. 
[30454.010698] XFS (loop1): xfs_log_force: error 5 returned. 
[30454.011673] XFS (loop1): xfs_qm_dquot_logitem_push: push error 5 on dqp ffff8801f6785e48 
[30454.019251] XFS (loop1): xfs_log_force: error 5 returned. 
...
> 
> > [30706.242124] XFS (loop1): xfs_do_force_shutdown(0x2) called from
> > line 743 of file fs/xfs/xfs_trans_ail.c.  Return address =
> > 0xffffffffa03c03ef
> > [30706.245280] XFS (loop1): Log I/O Error Detected.  Shutting down
> > filesystem
> > [30706.246311] XFS (loop1): Please umount the filesystem and
> > rectify the problem(s)
> > [30707.279880] XFS (loop0): Mounting Filesystem
> > [30707.290512] XFS (loop0): Ending clean mount
> > [30708.966751] XFS (loop1): xfs_log_force: error 5 returned.
> > [30708.977075] XFS (loop1): xfs_log_force: error 5 returned.
> > [30708.978074] BUG: unable to handle kernel NULL pointer
> > dereference at 0000000000000230
> > [30708.979629] IP: [] xfs_bdstrat_cb+0x27/0xd0
> > [xfs]
> 
> And that indicates that the buftarg attached to the buffer has a
> NULL xfs_mount pointer, so it's probably related to the above issue.
> 
> As it is, none of my machines see this problem, so I'm wondering if
> this is related to the way you are using loop devices. Can you
> reproduce it on a different type of storage device (like LVm of
> physical disk partitions)?
Will do.
> 
> Also, can you turn on CONFIG_XFS_DEBUG and all the memory
> leak/poisoning checks and see if that catches anything.
Will do.
CAI Qian
> 
> Cheers,
> 
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
