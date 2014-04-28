Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 46B1829DF8
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2014 18:46:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1C5988F8054
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2014 16:46:07 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	LNfM7fvIUy3Rle7K for <xfs@oss.sgi.com>;
	Mon, 28 Apr 2014 16:46:02 -0700 (PDT)
Date: Tue, 29 Apr 2014 09:45:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs umount hang in xfs_ail_push_all_sync on i/o error
Message-ID: <20140428234558.GD18672@dastard>
References: <CALjwKZDsGBxTDLvy7-W76FRpHRuki_ZjOXLWZ70fut4hmDkTSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CALjwKZDsGBxTDLvy7-W76FRpHRuki_ZjOXLWZ70fut4hmDkTSQ@mail.gmail.com>
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

On Mon, Apr 28, 2014 at 04:29:02PM -0600, Bob Mastors wrote:
> Greetings,
> 
> I have an xfs umount hang caused by forcing the block device to return
> i/o errors while copying files to the filesystem.
> Detailed steps to reproduce the problem on virtualbox are below.
> 
> The linux version is a recent pull and reports as 3.15.0-rc3.
> 
> [ 2040.248096] INFO: task umount:10303 blocked for more than 120 seconds.
> [ 2040.323947]       Not tainted 3.15.0-rc3 #4
> [ 2040.343423] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
> this message.
> [ 2040.352665] umount          D ffffffff8180fe40     0 10303   8691
> 0x00000000
> [ 2040.404918]  ffff88001e33dd58 0000000000000086 ffff88001e33dd48
> ffffffff81080f82
> [ 2040.489901]  ffff88001b311900 0000000000013180 ffff88001e33dfd8
> 0000000000013180
> [ 2040.534772]  ffff88003daa3200 ffff88001b311900 ffff88002421aec0
> ffff88002421ae80
> [ 2040.587450] Call Trace:
> [ 2040.592176]  [<ffffffff81080f82>] ? try_to_wake_up+0x232/0x2b0
> [ 2040.620212]  [<ffffffff816c54d9>] schedule+0x29/0x70
> [ 2040.627685]  [<ffffffffa04c4cd6>] xfs_ail_push_all_sync+0x96/0xd0 [xfs]
> [ 2040.632236]  [<ffffffff81092230>] ? __wake_up_sync+0x20/0x20
> [ 2040.659105]  [<ffffffffa04731a3>] xfs_unmountfs+0x63/0x160 [xfs]
> [ 2040.691774]  [<ffffffffa0478f65>] ? kmem_free+0x35/0x40 [xfs]
> [ 2040.698610]  [<ffffffffa0474cf5>] xfs_fs_put_super+0x25/0x60 [xfs]
> [ 2040.706838]  [<ffffffff8119561e>] generic_shutdown_super+0x7e/0x100
> [ 2040.723958]  [<ffffffff811956d0>] kill_block_super+0x30/0x80
> [ 2040.734963]  [<ffffffff8119591d>] deactivate_locked_super+0x4d/0x80
> [ 2040.745485]  [<ffffffff8119652e>] deactivate_super+0x4e/0x70
> [ 2040.751274]  [<ffffffff811b1d42>] mntput_no_expire+0xd2/0x160
> [ 2040.755894]  [<ffffffff811b2fff>] SyS_umount+0xaf/0x3b0
> [ 2040.761032]  [<ffffffff816d1592>] system_call_fastpath+0x16/0x1b
> [ .060058] XFS (sdb): xfs_log_force: error 5 returned.
> [ 268059] XFS (sdb): xfs_log_force: error 5 returned.
> 
> I took a look at xfs_ail_push_all_sync and it is pretty easy to see
> the hang. But it is not obvious to me how to fix it.
> Any ideas would be appreciated.
> 
> I am available to run additional tests or capture more logging
> or whatever if that would help.

What's the entire log output from the first shutdown message?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
