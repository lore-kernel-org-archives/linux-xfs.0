Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0S7T8vl133309 for <xfs@oss.sgi.com>; Fri, 28 Jan 2011 01:29:08 -0600
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E6E4C1490AC4
	for <xfs@oss.sgi.com>; Thu, 27 Jan 2011 23:31:31 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	iYGYpFEISnhqMMCL for <xfs@oss.sgi.com>;
	Thu, 27 Jan 2011 23:31:31 -0800 (PST)
Date: Fri, 28 Jan 2011 18:31:19 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs: very slow after mount, very slow at umount
Message-ID: <20110128073119.GV21311@dastard>
References: <4D40C8D1.8090202@teksavvy.com> <20110127033011.GH21311@dastard>
	<4D40EB2F.2050809@teksavvy.com> <4D418B57.1000501@teksavvy.com>
	<alpine.DEB.2.00.1101271040000.31246@p34.internal.lan>
	<4D419765.4070805@teksavvy.com>
	<4D41CA16.8070001@hardwarefreak.com>
	<4D41EA04.7010506@teksavvy.com> <20110128001735.GO21311@dastard>
	<4D421A68.9000607@teksavvy.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4D421A68.9000607@teksavvy.com>
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

On Thu, Jan 27, 2011 at 08:22:48PM -0500, Mark Lord wrote:
> On 11-01-27 07:17 PM, Dave Chinner wrote:
> >
> > In my experience with XFS, most people who tweak mkfs parameters end
> > up with some kind of problem they can't explain and don't know how
> > to solve. And they are typically problems that would not have
> > occurred had they simply used the defaults in the first place. What
> > you've done is a perfect example of this.
> 
> Maybe.  But what I read from the paragraph above,
> is that the documentation could perhaps explain things better,
> and then people other than the coders might understand how
> best to tweak it.

A simple google search turns up discussions like this:

http://oss.sgi.com/archives/xfs/2009-01/msg01161.html

Where someone reads the docco and asks questions to fill in gaps in
their knowledge that the docco didn't explain fully before they
try to twiddle knobs.

Configuring XFS filesystems for optimal performance has always been
a black art because it requires you to understand your storage, your
application workload(s) and XFS from the ground up.  Most people
can't even tick one of those boxes, let alone all three....

> > Why 8 AGs and not the default?
> 
> How AGs are used is not really explained anywhere I've looked,
> so I am guessing at what they do and how the system might respond
> to different values there (that documentation thing again).

Section 5.1 of this 1996 whitepaper tells you what allocation groups
are and the general allocation strategy around them:

http://oss.sgi.com/projects/xfs/papers/xfs_usenix/index.html

> Lacking documentation, my earlier experiences suggest that more AGs
> gives me less fragmentation when multiple simultaneous recording streams
> are active.  I got higher fragmentation with the defaults than with
> the tweaked value.

Fragmentation is not a big problem if you've got extents larger than
a typical IO. Once extents get to a few megabytes in size, it just
doesn't matter if they are any bigger for small DVR workloads
because the seek cost between streams is sufficiently amortised with
a few MB of sequential access per stream....

> Now, that might be due to differences in kernel versions too,
> as things in XFS are continuously getting even better (thanks!),
> and the original "defaults" assessment was with the kernel-of-the-day
> back in early 2010 (2.6.34?), and now the system is using 2.6.37.
> 
> But I just don't know.  My working theory, likely entirely wrong,
> is that if I have N streams active, odds are that each of those
> streams might get assigned to different AGs, given sufficient AGs >= N.

Streaming into different AGs is not necessarily the right solution;
it causes seeks between every streami, and the stream in AG0 will be
able to read/write faster than the stream in AG 7 because of their
locations on disk.

IOWs, interleaving streams within an AG might give better IO
patterns, lower latency and better throughput. Of course, it depends
on the storage subsystem, the application, etc. And yes, you can
change this sort of allocation behaviour by fiddling with XFS knobs
in the right way - start to see what I mean about tuning XFS really
being a "black art"?

> Since the box often has 3-7 recording streams active,
> I'm trying it out with 8 AGs now.

Seems like a reasonable decsion. Good luck.
> 
> Cheers
> 
> 

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
