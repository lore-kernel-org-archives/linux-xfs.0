Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q161soVM092771
	for <linux-xfs@oss.sgi.com>; Sun, 5 Feb 2012 19:54:51 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	A7jEUbQTHNN1OZf5 for <linux-xfs@oss.sgi.com>;
	Sun, 05 Feb 2012 17:54:48 -0800 (PST)
Date: Mon, 6 Feb 2012 12:54:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Placing the root partition on an XFS filesystem is not supported
Message-ID: <20120206015430.GK6922@dastard>
References: <loom.20120129T133929-288@post.gmane.org>
	<4F2B02C4.8070903@sandeen.net>
	<loom.20120203T152753-631@post.gmane.org>
	<4F2C2C69.5020103@sandeen.net> <20120206001123.GJ6922@dastard>
	<4F2F1B28.3060308@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F2F1B28.3060308@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@oss.sgi.com, Marcos Mello <marcosfrm@gmail.com>

On Sun, Feb 05, 2012 at 06:13:28PM -0600, Eric Sandeen wrote:
> On 2/5/12 6:11 PM, Dave Chinner wrote:
> > On Fri, Feb 03, 2012 at 12:50:17PM -0600, Eric Sandeen wrote:
> >> On 2/3/12 8:39 AM, Marcos Mello wrote:
> >>> Eric Sandeen <sandeen <at> sandeen.net> writes:
> >>>
> >>>>
> >>>> In general there is no problem with xfs on a root partition.  However, the
> >>> installer
> >>>> may not make it easy or available for you.
> >>>>
> >>>> (I never use xfs for /boot though, I don't trust grub enough for that
> >>> honestly).
> >>>>
> >>>> -Eric
> >>>
> >>> Same thing on Fedora 16. Let's hope some day Anaconda will change that.
> >>
> >> F16 prevents it?  I didn't see it in the upstream tree.  That should
> >> not be so.  :/
> >>
> >>> About GRUB with a XFS /boot the problem was with GRUB Lagacy, wasn't it?
> >>> Or GRUB2 is still buggy?
> >>
> >> I have no idea, actually.  I delved into grub a bit, it was disturbing
> >> enough that I have not tried to look at grub2.  :)
> > 
> > Certainly the problem exists with legacy grub - it assumes that it
> > can write to the first sector or any disk or partition which
> > overwrites the XFS superblock...
> 
> well, it was worse than that.  I can work around the grub-on-a-partition
> problem, but what I ran into was grub reading & writing to/from the block
> device under a mounted filesystem - corruption and hilarity ensued.

Oh, grub2 does worse things than that - grub_probe mounts any device
that appears to have a valid superblock so it can find out what
devices it needs to list in it's boot menu. I found this out when I
built a big DM stripe out of disks that used to have filesystems on
them.  grub-probe mounted every single device -inside- the stripe
and ran log recovery on them, corrupting the new filesystem and
quite a bit of data on the DM stripe they were part of....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
