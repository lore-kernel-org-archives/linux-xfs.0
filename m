Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0T5c0ih193601 for <xfs@oss.sgi.com>; Fri, 28 Jan 2011 23:38:01 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DE55429ADBC
	for <xfs@oss.sgi.com>; Fri, 28 Jan 2011 21:40:25 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	0evGC7WglPVZ1hFR for <xfs@oss.sgi.com>;
	Fri, 28 Jan 2011 21:40:25 -0800 (PST)
Date: Sat, 29 Jan 2011 16:40:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs: very slow after mount, very slow at umount
Message-ID: <20110129054021.GB21311@dastard>
References: <4D40EB2F.2050809@teksavvy.com> <4D418B57.1000501@teksavvy.com>
	<alpine.DEB.2.00.1101271040000.31246@p34.internal.lan>
	<4D419765.4070805@teksavvy.com>
	<4D41CA16.8070001@hardwarefreak.com>
	<alpine.DEB.2.00.1101271209370.17579@asgard.lang.hm>
	<4D42056E.2050505@hardwarefreak.com>
	<alpine.DEB.2.00.1101271730030.17579@asgard.lang.hm>
	<20110128135629.GX21311@dastard>
	<alpine.DEB.2.00.1101281119250.17579@asgard.lang.hm>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1101281119250.17579@asgard.lang.hm>
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
To: david@lang.hm
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Justin Piszcz <jpiszcz@lucidpixels.com>, Alex Elder <aelder@sgi.com>, Mark Lord <kernel@teksavvy.com>, Stan Hoeppner <stan@hardwarefreak.com>

On Fri, Jan 28, 2011 at 11:26:00AM -0800, david@lang.hm wrote:
> On Sat, 29 Jan 2011, Dave Chinner wrote:
> 
> >On Thu, Jan 27, 2011 at 06:09:58PM -0800, david@lang.hm wrote:
> >>On Thu, 27 Jan 2011, Stan Hoeppner wrote:
> >>>david@lang.hm put forth on 1/27/2011 2:11 PM:
> >>>
> >>>Picking the perfect mkfs.xfs parameters for a hardware RAID array can be
> >>>somewhat of a black art, mainly because no two vendor arrays act or perform
> >>>identically.
> >>
> >>if mkfs.xfs can figure out how to do the 'right thing' for md raid
> >>arrays, can there be a mode where it asks the users for the same
> >>information that it gets from the kernel?
> >
> >mkfs.xfs can get the information it needs directly from dm and md
> >devices. However, when hardware RAID luns present themselves to the
> >OS in an identical manner to single drives, how does mkfs tell the
> >difference between a 2TB hardware RAID lun made up of 30x73GB drives
> >and a single 2TB SATA drive? The person running mkfs should already
> >know this little detail....
> 
> that's my point, the person running mkfs knows this information, and
> can easily answer questions that mkfs asks (or provide this
> information on the command line). but mkfs doesn't ask for this
> infomation, instead it asks the user to define a whole bunch of
> parameters that are not well understood.

I'm going to be blunt - XFS is not a filesystem suited to use by
clueless noobs. XFS is a highly complex filesystem designed for high
end, high performance storage and therefore has the configurability
and flexibility required by such environments. Hence I expect that
anyone configuring an XFS filesystem for a production environments
is a professional and has, at minimum, done their homework before
they go fiddling with knobs. And we have a FAQ for a reason. ;)

> An XFS guru can tell you
> how to configure these parameters based on different hardware
> layouts, but as long as it remains a 'back art' getting new people
> up to speed is really hard. If this can be reduced down to
> 
> is this a hardware raid device
>   if yes
>     how many drives are there
>     what raid type is used (linear, raid 0, 1, 5, 6, 10)
>
> and whatever questions are needed, it would _greatly_ improve the
> quality of the settings that non-guru people end up using.

As opposed to just making mkfs DTRT without needing to ask
questions?

If you really think an interactive mkfs-for-dummies script is
necessary, then go ahead and write one - you don't need to modify
mkfs at all to do it.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
