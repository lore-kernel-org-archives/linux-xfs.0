Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 05EDF29DF8
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2014 20:01:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E71488F8039
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2014 18:01:29 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	fYW9p5IZiVrav6sU for <xfs@oss.sgi.com>;
	Mon, 28 Apr 2014 18:01:27 -0700 (PDT)
Date: Tue, 29 Apr 2014 11:01:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs umount hang in xfs_ail_push_all_sync on i/o error
Message-ID: <20140429010121.GE18672@dastard>
References: <CALjwKZDsGBxTDLvy7-W76FRpHRuki_ZjOXLWZ70fut4hmDkTSQ@mail.gmail.com>
	<20140428234558.GD18672@dastard>
	<CALjwKZCZrpHNnqCWyotiYvLNa8yJMRoBgNp4NShSj0j2hLJ9DQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CALjwKZCZrpHNnqCWyotiYvLNa8yJMRoBgNp4NShSj0j2hLJ9DQ@mail.gmail.com>
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
To: Bob Mastors <bob.mastors@solidfire.com>
Cc: xfs@oss.sgi.com

On Mon, Apr 28, 2014 at 05:51:31PM -0600, Bob Mastors wrote:
> Log output attached.
> The xfs filesystem being mounted and unmounted is the only xfs filesystem
> on the system.
> Bob
> 
> 
> On Mon, Apr 28, 2014 at 5:45 PM, Dave Chinner <david@fromorbit.com> wrote:
> 
> > On Mon, Apr 28, 2014 at 04:29:02PM -0600, Bob Mastors wrote:
> > > Greetings,
> > >
> > > I have an xfs umount hang caused by forcing the block device to return
> > > i/o errors while copying files to the filesystem.
> > > Detailed steps to reproduce the problem on virtualbox are below.
> > >
> > > The linux version is a recent pull and reports as 3.15.0-rc3.
> > >
> > > [ 2040.248096] INFO: task umount:10303 blocked for more than 120 seconds.
> > > [ 2040.323947]       Not tainted 3.15.0-rc3 #4
> > > [ 2040.343423] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> > disables
> > > this message.
> > > [ 2040.352665] umount          D ffffffff8180fe40     0 10303   8691
> > > 0x00000000
> > > [ 2040.404918]  ffff88001e33dd58 0000000000000086 ffff88001e33dd48
> > > ffffffff81080f82
> > > [ 2040.489901]  ffff88001b311900 0000000000013180 ffff88001e33dfd8
> > > 0000000000013180
> > > [ 2040.534772]  ffff88003daa3200 ffff88001b311900 ffff88002421aec0
> > > ffff88002421ae80
> > > [ 2040.587450] Call Trace:
> > > [ 2040.592176]  [<ffffffff81080f82>] ? try_to_wake_up+0x232/0x2b0
> > > [ 2040.620212]  [<ffffffff816c54d9>] schedule+0x29/0x70
> > > [ 2040.627685]  [<ffffffffa04c4cd6>] xfs_ail_push_all_sync+0x96/0xd0
> > [xfs]
> > > [ 2040.632236]  [<ffffffff81092230>] ? __wake_up_sync+0x20/0x20
> > > [ 2040.659105]  [<ffffffffa04731a3>] xfs_unmountfs+0x63/0x160 [xfs]
> > > [ 2040.691774]  [<ffffffffa0478f65>] ? kmem_free+0x35/0x40 [xfs]
> > > [ 2040.698610]  [<ffffffffa0474cf5>] xfs_fs_put_super+0x25/0x60 [xfs]
> > > [ 2040.706838]  [<ffffffff8119561e>] generic_shutdown_super+0x7e/0x100
> > > [ 2040.723958]  [<ffffffff811956d0>] kill_block_super+0x30/0x80
> > > [ 2040.734963]  [<ffffffff8119591d>] deactivate_locked_super+0x4d/0x80
> > > [ 2040.745485]  [<ffffffff8119652e>] deactivate_super+0x4e/0x70
> > > [ 2040.751274]  [<ffffffff811b1d42>] mntput_no_expire+0xd2/0x160
> > > [ 2040.755894]  [<ffffffff811b2fff>] SyS_umount+0xaf/0x3b0
> > > [ 2040.761032]  [<ffffffff816d1592>] system_call_fastpath+0x16/0x1b
> > > [ .060058] XFS (sdb): xfs_log_force: error 5 returned.
> > > [ 268059] XFS (sdb): xfs_log_force: error 5 returned.
> > >
> > > I took a look at xfs_ail_push_all_sync and it is pretty easy to see
> > > the hang. But it is not obvious to me how to fix it.
> > > Any ideas would be appreciated.
> > >
> > > I am available to run additional tests or capture more logging
> > > or whatever if that would help.
> >
> > What's the entire log output from the first shutdown message?

So what is the AIL stuck on? Can you trace the xfs_ail* trace points
when it is in shutdown like this and post the output of the report?

> [ 1318.816643] XFS (sdb): metadata I/O error: block 0x19fc80 ("xfs_buf_iodone_callbacks") error 5 numblks 16
> [ 1318.818080] XFS (sdb): metadata I/O error: block 0x1025cf ("xlog_iodone") error 5 numblks 64
> [ 1318.819350] XFS (sdb): xfs_do_force_shutdown(0x2) called from line 1170 of file fs/xfs/xfs_log.c.  Return address = 0xffffffffa04b9859
> [ 1318.821089] XFS (sdb): Log I/O Error Detected.  Shutting down filesystem
> [ 1318.822301] XFS (sdb): xfs_log_force: error 5 returned.
> [ 1318.822308] XFS (sdb): xfs_log_force: error 5 returned.
> [ 1318.822311] XFS (sdb): Detected failing async write on buffer block 0x19fca0. Retrying async write.

That's the only thing that is unusual about the hang. Does this
always appear when a hang occurs?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
