Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 272E97F3F
	for <xfs@oss.sgi.com>; Wed, 17 Dec 2014 15:02:50 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id ABEA1AC00A
	for <xfs@oss.sgi.com>; Wed, 17 Dec 2014 13:02:46 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	GvrathnBIR2vF1EY for <xfs@oss.sgi.com>;
	Wed, 17 Dec 2014 13:02:43 -0800 (PST)
Date: Thu, 18 Dec 2014 08:02:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Disconnected inodes after test xfs/261
Message-ID: <20141217210226.GY24183@dastard>
References: <20141217193535.GA8231@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141217193535.GA8231@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: xfs@oss.sgi.com

On Wed, Dec 17, 2014 at 08:35:35PM +0100, Jan Kara wrote:
>   Hello,
> 
>   in my test KVM with today's Linus' kernel I'm getting xfs_repair
> complaint about disconnected inodes after the test xfs/261 finishes
> (with success). xfs_repair output is like:
> xfs_repair -n /dev/vdb2
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - scan filesystem freespace and inode maps...
>         - found root inode chunk
> Phase 3 - for each AG...
>         - scan (but don't clear) agi unlinked lists...
>         - process known inodes and perform inode discovery...
>         - agno = 0
>         - agno = 1
>         - agno = 2
>         - agno = 3
>         - process newly discovered inodes...
> Phase 4 - check for duplicate blocks...
>         - setting up duplicate extent list...
>         - check for inodes claiming duplicate blocks...
>         - agno = 0
>         - agno = 1
>         - agno = 2
>         - agno = 3
> No modify flag set, skipping phase 5
> Phase 6 - check inode connectivity...
>         - traversing filesystem ...
>         - traversal finished ...
>         - moving disconnected inodes to lost+found ...
> disconnected inode 132, would move to lost+found
> disconnected inode 133, would move to lost+found
> Phase 7 - verify link counts...
> No modify flag set, skipping filesystem flush and exiting.
> ---
> Given how trivial test xfs/261 is, it seems like created private mtab files
> that also get unlinked don't get added to AGI unlinked list before umount.
> I didn't have a detailed look whether that's possible or not and probably
> won't get to it before Christmas. So I'm sending this just in case someone
> more knowledgeable has ideas earlier...

I don't see that here. If you mount/unmount the filesystem, does the
warning go away? i.e. xfs_repair -n ignores the contents of
the log, so if the unlinked list transactions are in the log then
log recovery will make everything good again.

That said, if unmount is not leaving the log clean, then we've still
got an issue we need to get to the bottom of.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
