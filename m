Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAQN5ARs018939 for <xfs@oss.sgi.com>; Wed, 26 Nov 2008 17:05:11 -0600
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A13A61609241
	for <xfs@oss.sgi.com>; Wed, 26 Nov 2008 15:05:08 -0800 (PST)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	8LPFSV41dEPUcwBE for <xfs@oss.sgi.com>;
	Wed, 26 Nov 2008 15:05:08 -0800 (PST)
Date: Thu, 27 Nov 2008 09:59:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: truncated files
Message-ID: <20081126225931.GK6291@disturbed>
References: <200811252244.14718.Martin@Lichtvoll.de>
	<20081125222703.GE6291@disturbed>
	<200811260949.19642.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200811260949.19642.Martin@lichtvoll.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: xfs@oss.sgi.com

On Wed, Nov 26, 2008 at 09:49:18AM +0100, Martin Steigerwald wrote:
> Am Dienstag 25 November 2008 schrieb Dave Chinner:
> > On Tue, Nov 25, 2008 at 10:44:14PM +0100, Martin Steigerwald wrote:
> > > Hi!
> > >
> > > Today on one try to hibernate via tuxonice it machine appeared dead.
> > > I am
> >
> >                       ^^^^^^^^^
> > When (not if) suspend to disk/resume fails, you get to keep all the
> > broken pieces of your filesystem. It works most of the time, but it has
> > some fundamentally broken corner cases that you probably just
> > hit....
> 
> Well I use TuxOnIce for a reason! I had uptimes of up to 70 days with it 
> already. And they are usually only interrupted by kernel updates or 
> manual shutdowns. I was never convinced by in-kernel solutions for 
> hibernate.

Sure, though I'm not convinced that TuxOnIce is any better because
it still uses the same fundamental design as the in-kernel ones.

> > I've never had a system that suspends reliably (let alone resumes
> > from the suspend) so it's no real surprise that I don't trust
> > suspend to disk....
> 
> Well I take it as bad luck then, especially since there are no hints that 
> XFS had a problem. I am not sure whether the machine really was dead, but 
> I can't reproduce what exactly happened. So thats it.

And therein lies the problem. I can't get suspend/resume to work
reliably on anything I own, so I can't do anything about problems
reported as a result of suspend/resume. Hell, I even considered
running linux on my new laptop inside a virtual machine on windows
just so I could have functioning suspend/resume....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
