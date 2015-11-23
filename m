Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 560D97F37
	for <xfs@oss.sgi.com>; Mon, 23 Nov 2015 17:21:53 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 47BC730405F
	for <xfs@oss.sgi.com>; Mon, 23 Nov 2015 15:21:50 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ZEMXkJdo6xVWep6m for <xfs@oss.sgi.com>;
	Mon, 23 Nov 2015 15:21:47 -0800 (PST)
Date: Tue, 24 Nov 2015 10:20:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Does XFS support cgroup writeback limiting?
Message-ID: <20151123232052.GI26718@dastard>
References: <5652F311.7000406@5t9.de> <20151123202619.GE26718@dastard>
	<56538E6A.6030203@5t9.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56538E6A.6030203@5t9.de>
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
To: Lutz Vieweg <lvml@5t9.de>
Cc: xfs@oss.sgi.com

On Mon, Nov 23, 2015 at 11:08:42PM +0100, Lutz Vieweg wrote:
> On 11/23/2015 09:26 PM, Dave Chinner wrote:
> >On Mon, Nov 23, 2015 at 12:05:53PM +0100, Lutz Vieweg wrote:
> >>in June 2015 the article https://lwn.net/Articles/648292/ mentioned
> >>upcoming support for limiting the quantity of buffered writes
> >>using control groups.
> >>
> >>Back then, only ext4 was said to support that feature, with other
> >>filesystems requiring some minor changes to do the same.
> >
> >Yes, changing the kernel code to support this functionality is about
> >3 lines of code.
> 
> Oh, I didn't expect it to be such a small change :-)
> 
> >.... I haven't added support to XFS because I have no way of
> >verifying the functionality works and that it continues to work as
> >it is intended. i.e. we have no regression test coverage for cgroup
> >aware writeback and until someone writes a set of regression tests
> >that validate it's functionality works correctly it will remain this
> >way.
> >
> >Writing code is trivial. Validating the code actually works as
> >intended and doesn't silently get broken in the future is the
> >hard part....
> 
> Understood, would you anyway be willing to publish such a
> three-line-patch (outside of official releases) for those
> daredevils (like me :-)) who'd be willing to give it a try?

Just make the same mods to XFS as the ext4 patch here:

http://www.spinics.net/lists/kernel/msg2014816.html

> After all, this functionality is the last piece of the
> "isolation"-puzzle that is missing from Linux to actually
> allow fencing off virtual machines or containers from DOSing
> each other by using up all I/O bandwidth...

Yes, I know, but no-one seems to care enough about it to provide
regression tests for it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
