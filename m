Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB93nZoe167350 for <xfs@oss.sgi.com>; Wed, 8 Dec 2010 21:49:36 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 63773152A76D
	for <xfs@oss.sgi.com>; Wed,  8 Dec 2010 19:51:23 -0800 (PST)
Received: from mail.sandeen.net (64-131-28-21.usfamily.net [64.131.28.21]) by
	cuda.sgi.com with ESMTP id 0aMhTIiIxjXTwnNX for
	<xfs@oss.sgi.com>; Wed, 08 Dec 2010 19:51:23 -0800 (PST)
Message-ID: <4D00523A.9020703@sandeen.net>
Date: Wed, 08 Dec 2010 21:51:22 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS mount fail: XFS_WANT_CORRUPTED_GOTO fs/xfs/xfs_alloc.c
References: <AANLkTi=7r8gV-cnBU9WNkn6kHz82qnUp8XD2dzAY+LF7@mail.gmail.com>	<20101202224506.GY16922@dastard>
	<AANLkTimZt7vefTvg2XkzgUHjD3s8JD3dHLX_qbXpXrra@mail.gmail.com>
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

On 12/3/10 10:19 PM, Ajeet Yadav wrote:
> Our test case is automated:
> 1. Create large number of file of 6KB sizes ( 6KB is taken, we wanted to increase journal load, and file size not in multiple of file system block size)
> 2. Set target to reboot at random seconds seconds.

What exactly is meant by "reboot?"

Does this mean "cycle power" or cleanly reboot?

Based on the problems you are encountering, I am guessing that
you drop power.

Is the storage external for this test?  Is it qualified hardware
or are you planning on supporting anything that the user may choose
to plug into their device?

It's possible that an external USB device is behaving poorly,
and that may be the root of your problems.

-Eric

> 3. Next boot do "ls" of all files in XFS partition.
> 4. Remove all files in XFS.
> 5. Go back to step 1
> 
> The purpose of this test is to test journal and stability of XFS filestem.
> 
> Do you think, we should consider this test case ?
> 
> Other is when we should run xfs_repair ? because if mount fails and journal contain dirty logs then xfs_repair does not run, we are forced to use (-L) option but its description say that (-L) can corrupt the file system.
> 
> Other case even if xfs mount successfully, even in that case accessing some files give IO input/ output error.
> 
> 1. I recommend the following usage for xfs_repair so that we do not come accross these problem
>     Mount Success -> Umount -> run xfs_repair -> mount
>     Mount fails -> try xfs_repair -> xfs_repair fails -> finally xfs_repair -L -> mount
> 
> Adding above mount + xfs_repair procedure to script makes file system stable. But other member of my team do not agree as it increases mount time.
> 
>                                               
> 
> On Fri, Dec 3, 2010 at 4:15 AM, Dave Chinner <david@fromorbit.com <mailto:david@fromorbit.com>> wrote:
> 
>     On Thu, Dec 02, 2010 at 12:31:30PM +0530, Ajeet Yadav wrote:
>     > Dear all,
>     > This is XFS fail mount log on linux 2.6.30.9
>     >
>     > XFS mounting filesystem sda2
>     > Starting XFS recovery on filesystem: sda2 (logdev: internal)
>     > XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1629 of file
>     > fs/xfs/xfs_alloc.c.  Caller 0x80129658
>     > Call Trace:
>     > [<802dedc8>] dump_stack+0x8/0x34 from[<80127400>]
>     > xfs_free_ag_extent+0x128/0x7ac
>     > [<80127400>] xfs_free_ag_extent+0x128/0x7ac from[<80129658>]
>     > xfs_free_extent+0xb8/0xe8
>     > [<80129658>] xfs_free_extent+0xb8/0xe8 from[<80163978>]
>     > xlog_recover_process_efi+0x160/0x214
>     > [<80163978>] xlog_recover_process_efi+0x160/0x214 from[<80163ac4>]
>     > xlog_recover_process_efis+0x98/0x11c
>     > [<80163ac4>] xlog_recover_process_efis+0x98/0x11c from[<8016663c>]
>     > xlog_recover_finish+0x28/0xdc
>     > [<8016663c>] xlog_recover_finish+0x28/0xdc from[<8016aec0>]
>     > xfs_mountfs+0x4d0/0x610
>     > [<8016aec0>] xfs_mountfs+0x4d0/0x610 from[<80184434>]
>     > xfs_fs_fill_super+0x1fc/0x418
>     > [<80184434>] xfs_fs_fill_super+0x1fc/0x418 from[<800bae48>]
>     > get_sb_bdev+0x11c/0x1c0
>     > [<800bae48>] get_sb_bdev+0x11c/0x1c0 from[<80181f20>]
>     > xfs_fs_get_sb+0x20/0x2c
>     > [<80181f20>] xfs_fs_get_sb+0x20/0x2c from[<800b9424>]
>     > vfs_kern_mount+0x68/0xd0
>     > [<800b9424>] vfs_kern_mount+0x68/0xd0 from[<800b94f0>]
>     > do_kern_mount+0x54/0x118
>     > [<800b94f0>] do_kern_mount+0x54/0x118 from[<800d44e8>] do_mount+0x7b4/0x828
>     > [<800d44e8>] do_mount+0x7b4/0x828 from[<800d45f8>] sys_mount+0x9c/0x194
>     > [<800d45f8>] sys_mount+0x9c/0x194 from[<800102c4>] stack_done+0x20/0x3c
>     >
>     > Failed to recover EFIs on filesystem: sda2
>     > XFS: log mount finish failed
> 
>     You corrupted a free space btree. Care to tell uswhat test you were
>     running that caused this?  Did you pull the plug on the device
>     during a copy again?
> 
>     Cheers,
> 
>     Dave.
>     --
>     Dave Chinner
>     david@fromorbit.com <mailto:david@fromorbit.com>
> 
> 
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
