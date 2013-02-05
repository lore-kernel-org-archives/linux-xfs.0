Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 33B9A7F52
	for <xfs@oss.sgi.com>; Tue,  5 Feb 2013 15:32:14 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 117D58F8039
	for <xfs@oss.sgi.com>; Tue,  5 Feb 2013 13:32:10 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	8THFjEgXvZzoEIEw for <xfs@oss.sgi.com>;
	Tue, 05 Feb 2013 13:32:09 -0800 (PST)
Date: Wed, 6 Feb 2013 08:32:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS appears to cause strange hang with md raid1 on reboot
Message-ID: <20130205213206.GP2667@dastard>
References: <32271.192.104.24.222.1359415698.squirrel@secure.skymagik.net>
	<20130129151833.GF27055@sgi.com>
	<42720.75.149.17.233.1359515780.squirrel@secure.skymagik.net>
	<20130130234650.GE32297@disturbed.disaster>
	<45702.75.149.17.233.1359599410.squirrel@secure.skymagik.net>
	<20130204125510.GL2667@dastard>
	<11083.192.104.24.222.1360088562.squirrel@secure.skymagik.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <11083.192.104.24.222.1360088562.squirrel@secure.skymagik.net>
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
To: Tom <storm9c1@skymagik.com>
Cc: xfs@oss.sgi.com

On Tue, Feb 05, 2013 at 01:22:42PM -0500, Tom wrote:
> In a previous message, Dave Chinner wrote:
> >
> > Which doesn't tell us why the filesystem was not unmounted. We need to
> > know why/how the unmount failed to solve the problem, so you'll need to
> > do some debugging of the unmount to try to work that out...
> >
> 
> Thanks Dave.
> 
> I can work on that tonight.
> 
> Oddly, since the problem is kernel related (308 doesn't do it, 348 does),
> the system shuts down the same way no matter what kernel I'm using.  So
> what would be the difference?  The umounts and running processes shouldn't
> change.  Just seems to me that some resource isn't being released.  And
> only with kernel 348 and XFS.  Quite puzzling..........
> 
> Any suggestions on how I would debug this?

Find out if the unmount is returning an error first. If there is no
error, then you need to find what is doing bind mounts on your
system and make sure they are unmounted properly before the final
unmount is done. If lazy unmount is being done, make it a normal
unmount an see where the unmount is getting stcuk or taking time to
complete by using sysrq-w if it gets delayed for any length of time.

FWIW, because this is a old, old kernel, event tracing is not
available, so the single most useful tool for tracking this down is
not available...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
