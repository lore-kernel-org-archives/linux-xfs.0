Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5E3417F51
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 19:54:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3E598304039
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 17:54:19 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	xF5tdDmM2xwhFiH4 for <xfs@oss.sgi.com>;
	Mon, 12 Aug 2013 17:54:17 -0700 (PDT)
Date: Tue, 13 Aug 2013 10:54:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Failure growing xfs with linux 3.10.5
Message-ID: <20130813005414.GT12779@dastard>
References: <52073905.8010608@allmail.net> <5207D9C4.7020102@sandeen.net>
	<5209126F.5020204@allmail.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5209126F.5020204@allmail.net>
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
To: Michael Maier <m1278468@allmail.net>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Mon, Aug 12, 2013 at 06:50:55PM +0200, Michael Maier wrote:
> Eric Sandeen wrote:
> > On 8/11/13 2:11 AM, Michael Maier wrote:
> >> Hello!
> >>
> >> I think I'm facing the same problem as already described here:
> >> http://thread.gmane.org/gmane.comp.file-systems.xfs.general/54428
> > 
> > Maybe you can try the tracing Dave suggested in that thread?
> 
> I sent you a trace.
> 
> 
> 
> 
> Meanwhile, I faced another problem on another xfs-file system with linux
> 3.10.5 which I never saw before. During writing a few bytes to disc, I
> got "disc full" and the writing failed.
> 
> At the same time, df reported 69G of free space! I ran xfs_repair -n and
> got:
> 
> 
> xfs_repair -n /dev/mapper/raid0-daten2
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - scan filesystem freespace and inode maps...
> sb_ifree 591, counted 492
> ^^^^^^^^^^^^^^^^^^^^^^^^^
> What does this mean? How can I get rid of it w/o loosing data? This file
> system was created a few days ago and never resized.

Superblock inode counting is lazy - it can get out of sync in after
an unclean shutdown, but generally mounting a dirty filesystem will
result in it being recalculated rather than trusted to be correct.
So there's nothing to worry about here.

> Phase 7 - verify link counts...
> No modify flag set, skipping filesystem flush and exiting.

Ok, - it was a no-modify run, so it wouldn't have complained about a
dirty log needing replay. Hence the counters are probably out
because the filesystem has a dirty log.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
