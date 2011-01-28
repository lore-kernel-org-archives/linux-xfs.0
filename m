Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0SDsYCf159524 for <xfs@oss.sgi.com>; Fri, 28 Jan 2011 07:54:35 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B32D31A4005C
	for <xfs@oss.sgi.com>; Fri, 28 Jan 2011 05:56:58 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	WlCD8Umajh6aiiHI for <xfs@oss.sgi.com>;
	Fri, 28 Jan 2011 05:56:58 -0800 (PST)
Date: Sat, 29 Jan 2011 00:56:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs: very slow after mount, very slow at umount
Message-ID: <20110128135629.GX21311@dastard>
References: <4D40C8D1.8090202@teksavvy.com> <20110127033011.GH21311@dastard>
	<4D40EB2F.2050809@teksavvy.com> <4D418B57.1000501@teksavvy.com>
	<alpine.DEB.2.00.1101271040000.31246@p34.internal.lan>
	<4D419765.4070805@teksavvy.com>
	<4D41CA16.8070001@hardwarefreak.com>
	<alpine.DEB.2.00.1101271209370.17579@asgard.lang.hm>
	<4D42056E.2050505@hardwarefreak.com>
	<alpine.DEB.2.00.1101271730030.17579@asgard.lang.hm>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1101271730030.17579@asgard.lang.hm>
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

On Thu, Jan 27, 2011 at 06:09:58PM -0800, david@lang.hm wrote:
> On Thu, 27 Jan 2011, Stan Hoeppner wrote:
> >david@lang.hm put forth on 1/27/2011 2:11 PM:
> >
> >>how do I understand how to setup things on multi-disk systems? the documentation
> >>I've found online is not that helpful, and in some ways contradictory.
> >
> >Visit http://xfs.org  There you will find:
> >
> >Users guide:
> >http://xfs.org/docs/xfsdocs-xml-dev/XFS_User_Guide//tmp/en-US/html/index.html
> >
> >File system structure:
> >http://xfs.org/docs/xfsdocs-xml-dev/XFS_Filesystem_Structure//tmp/en-US/html/index.html
> >
> >Training labs:
> >http://xfs.org/docs/xfsdocs-xml-dev/XFS_Labs/tmp/en-US/html/index.html
> 
> thanks for the pointers.
> 
> >>If there really are good rules for how to do this, it would be very helpful if
> >>you could just give mkfs.xfs the information about your system (this partition
> >>is on a 16 drive raid6 array) and have it do the right thing.
> >
> >If your disk array is built upon Linux mdraid, recent versions of mkfs.xfs will
> >read the parameters and automatically make the filesystem accordingly, properly.
> >
> >mxfs.fxs will not do this for PCIe/x hardware RAID arrays or external FC/iSCSI
> >based SAN arrays as there is no standard place to acquire the RAID configuration
> >information for such systems.  For these you will need to configure mkfs.xfs
> >manually.
> >
> >At minimum you will want to specify stripe width (sw) which needs to match the
> >hardware stripe width.  For RAID0 sw=[#of_disks].  For RAID 10, sw=[#disks/2].
> >For RAID5 sw=[#disks-1].  For RAID6 sw=[#disks-2].
> >
> >You'll want at minimum agcount=16 for striped hardware arrays.  Depending on the
> >number and spindle speed of the disks, the total size of the array, the
> >characteristics of the RAID controller (big or small cache), you may want to
> >increase agcount.  Experimentation may be required to find the optimum
> >parameters for a given hardware RAID array.  Typically all other parameters may
> >be left at defaults.
> 
> does this value change depending on the number of disks in the array?

Only depending on block device capacity. Once at the maximum AG size
(1TB), mkfs has to add more AGs. So once above 4TB for hardware RAID
LUNs and 16TB for md/dm devices, you will get an AG per TB of
storage by default.

As it is, the optimal number and size of AGs will depend on many
geometry factors as workload factors, such as the size of the luns,
the way they are striped, whether you are using linear concatenation
of luns or striping them or a combination of both, the amount of
allocation concurrency you require, etc. In these sorts of
situations, mkfs can only make a best guess - to do better you
really need someone proficient in the dark arts to configure the
storage and filesystem optimally.

> >Picking the perfect mkfs.xfs parameters for a hardware RAID array can be
> >somewhat of a black art, mainly because no two vendor arrays act or perform
> >identically.
> 
> if mkfs.xfs can figure out how to do the 'right thing' for md raid
> arrays, can there be a mode where it asks the users for the same
> information that it gets from the kernel?

mkfs.xfs can get the information it needs directly from dm and md
devices. However, when hardware RAID luns present themselves to the
OS in an identical manner to single drives, how does mkfs tell the
difference between a 2TB hardware RAID lun made up of 30x73GB drives
and a single 2TB SATA drive? The person running mkfs should already
know this little detail....

> >Systems of a caliber requiring XFS should be thoroughly tested before going into
> >production.  Testing _with your workload_ of multiple parameters should be
> >performed to identify those yielding best performance.
> 
> <rant>
> the problem with this is that for large arrays, formatting the array
> and loading it with data can take a day or more, even before you
> start running the test. This is made even worse if you are scaling
> up an existing system a couple orders of magnatude, because you may
> not have the full workload available to you.

If your hardware procurement-to-production process doesn't include
testing performance of potential equipment on a representative
workload, then I'd say you have a process problem that we can't help
you solve....

> Saying that you should
> test out every option before going into production is a cop-out.

I never test every option. I know what the options do, so to decide
what to tweak (if anything) what I first need to know is how a
workload performs on a given storage layout with default options. I
need to have:

	a) some idea of the expected performance of the workload
	b) a baseline performance characterisation of the underlying
	   block devices
	c) a set of baseline performance metrics from a
	   representative workload on a default filesystem
	d) spent some time analysing the baseline metrics for
	   evidence of sub-optimal performance characteristics.

Once I have that information, I can suggest meaningful ways (if any)
to change the storage and filesystem configuration that may improve
the performance of the workload.

BTW, if you ask me how to optimise an ext4 filesystem for the same
workload, I'll tell you straight up that I have no idea and that you
should ask an ext4 expert....

> The better you can test it, the better off you are, but without
> knowing what the knobs do, just doing a test and twiddling the
> knobs to do another test isn't very useful.

Well, yes, that is precisely the reason you should use the defaults.
It's also the reason we have experts - they know what knob to
twiddle to fix specific problems. If you prefer to twiddle knobs
like Blind Freddy, then you should expect things to go wrong....

> If there is a way to
> set the knobs in the general ballpark,

Have you ever considered that this is exactly what mkfs does when
you use the defaults?  And that this is the fundamental reason we
keep saying "use the defaults"?

> then you can test and see
> if the performance seems adaquate, if not you can try teaking one
> of the knobs a little bit and see if it helps or hurts. but if the
> knobs aren't even in the ballpark when you start, this doesn't
> help much.

The thread has now come full circle - you're ranting about not
knowing what knobs do or how to set reasonable values so you want to
twiddle random knobs them to see if they do anything as the basis of
your optimisation process. This is the exact process that lead to
the bug report that started this thread - a tweak-without-
understanding configuration leading to undesirable behavioural
characteristics from the filesystem.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
