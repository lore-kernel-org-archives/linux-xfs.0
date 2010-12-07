Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB7BIlMh139444 for <xfs@oss.sgi.com>; Tue, 7 Dec 2010 05:18:47 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 119A31C9DEDD
	for <xfs@oss.sgi.com>; Tue,  7 Dec 2010 03:20:32 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	RvH89D5X3JzyN0tm for <xfs@oss.sgi.com>;
	Tue, 07 Dec 2010 03:20:32 -0800 (PST)
Date: Tue, 7 Dec 2010 22:20:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS mount fail: XFS_WANT_CORRUPTED_GOTO fs/xfs/xfs_alloc.c
Message-ID: <20101207112024.GD16103@dastard>
References: <AANLkTi=7r8gV-cnBU9WNkn6kHz82qnUp8XD2dzAY+LF7@mail.gmail.com>
	<20101202224506.GY16922@dastard>
	<AANLkTimZt7vefTvg2XkzgUHjD3s8JD3dHLX_qbXpXrra@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTimZt7vefTvg2XkzgUHjD3s8JD3dHLX_qbXpXrra@mail.gmail.com>
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
To: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Cc: xfs@oss.sgi.com

On Sat, Dec 04, 2010 at 09:49:25AM +0530, Ajeet Yadav wrote:
> Our test case is automated:
> 1. Create large number of file of 6KB sizes ( 6KB is taken, we wanted to
> increase journal load, and file size not in multiple of file system block
> size)
> 2. Set target to reboot at random seconds seconds.
> 3. Next boot do "ls" of all files in XFS partition.
> 4. Remove all files in XFS.
> 5. Go back to step 1
> 
> The purpose of this test is to test journal and stability of XFS filestem.
> 
> Do you think, we should consider this test case ?

Are you running with barriers enabled? What are your mkfs and mount
options?

Also, does the problem exist on a current kernel? We've fixed lots
of writeback related problems since 2.6.30, so I'd suggest that you
need to reproduce this on a current kernel before anyone will spend
large amounts of time trying to track it down. Especially as
xfstests 136-140 do similar testing (just without the reboots) and
don't show any problems.

> Other is when we should run xfs_repair ? because if mount fails and journal
> contain dirty logs then xfs_repair does not run, we are forced to use (-L)
> option but its description say that (-L) can corrupt the file system.

Yes, it can.

> Other case even if xfs mount successfully, even in that case accessing some
> files give IO input/ output error.

Which means something got corrupted. Look in dmesg for reasons why.

> 1. I recommend the following usage for xfs_repair so that we do not come
> accross these problem
>     Mount Success -> Umount -> run xfs_repair -> mount
>     Mount fails -> try xfs_repair -> xfs_repair fails -> finally xfs_repair
> -L -> mount
> 
> Adding above mount + xfs_repair procedure to script makes file system
> stable. But other member of my team do not agree as it increases mount time.

I agree with your team members. All you are proposing to do is to hide
failures that need further investigation...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
