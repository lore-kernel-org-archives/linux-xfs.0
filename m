Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0S0FFux057298 for <xfs@oss.sgi.com>; Thu, 27 Jan 2011 18:15:15 -0600
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6574A29586B
	for <xfs@oss.sgi.com>; Thu, 27 Jan 2011 16:17:39 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	5gAIwIKAIHFRlHwb for <xfs@oss.sgi.com>;
	Thu, 27 Jan 2011 16:17:39 -0800 (PST)
Date: Fri, 28 Jan 2011 11:17:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs: very slow after mount, very slow at umount
Message-ID: <20110128001735.GO21311@dastard>
References: <4D40C8D1.8090202@teksavvy.com> <20110127033011.GH21311@dastard>
	<4D40EB2F.2050809@teksavvy.com> <4D418B57.1000501@teksavvy.com>
	<alpine.DEB.2.00.1101271040000.31246@p34.internal.lan>
	<4D419765.4070805@teksavvy.com>
	<4D41CA16.8070001@hardwarefreak.com>
	<4D41EA04.7010506@teksavvy.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4D41EA04.7010506@teksavvy.com>
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
To: Mark Lord <kernel@teksavvy.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Justin Piszcz <jpiszcz@lucidpixels.com>, Alex Elder <aelder@sgi.com>, Stan Hoeppner <stan@hardwarefreak.com>

On Thu, Jan 27, 2011 at 04:56:20PM -0500, Mark Lord wrote:
> On 11-01-27 02:40 PM, Stan Hoeppner wrote:
> ..
> > You need to use the mkfs.xfs defaults for any single drive filesystem, and trust
> > the allocator to do the right thing.
> 
> But it did not do the right thing when I used the defaults.
> Big files ended up with tons of (exactly) 64MB extents, ISTR.

Because your AG size is 64MB. An extent can't be larger than an AG.
Hence you are fragmenting your large files unnecessarily, as extents
can be up to 8GB in size on a 4k block size filesystem.

> With the increased number of ags, I saw much less fragmentation,
> and the drive was still very light on I/O despite multiple simultaneous
> recordings, commflaggers, and playback at once.

The allocsize mount option is the prefered method of keeping
fragemntation down for dvr style workloads.

> > Trust the defaults.
> 
> I imagine the defaults are designed to handle a typical Linux install,
> with 100,000 to 1,000,000 files varying from a few bytes to a few megabytes.

Why would we optimise a filesystem designed for use on high end
storage and large amounts of IO concurrency for what a typical Linux
desktop needs? For such storage (i.e. single spindle) mkfs optimises
the layout for minimal seeks and relatively low amounts of
concurrency. This gives _adequate_ performance on desktop machines
without compromising scalbility on high end storage.

In my experience with XFS, most people who tweak mkfs parameters end
up with some kind of problem they can't explain and don't know how
to solve. And they are typically problems that would not have
occurred had they simply used the defaults in the first place. What
you've done is a perfect example of this.

Yes, I know we are taking the fun out of tweaking knobs so you can
say it's 1% faster than the default, but that's our job: to
determine the right default settings so the filesystem works as well
as possible out of the box with no tweaking for most workloads on a
wide range of storage....

> That's not what this filesystem will have. It will have only a few thousand
> (max) inodes at any given time, but each file will be HUGE.

Which is exactly the use case XFS was designed for, and....

> XFS is fantastic at adapting to the workload, but I'd like to try and have
> it tuned more closely for the known workload this system is throwing at it.

.... as such the mkfs defaults are already tuned as well as they can
be for such usage.

> I'm now trying again, but with 8 ags instead of 8000+.

Why 8 AGs and not the default?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
