Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAT1w06J085900 for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 19:58:00 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 919121AF8E8
	for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 17:59:40 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	oNz11yqMLceos3p1 for <xfs@oss.sgi.com>;
	Sun, 28 Nov 2010 17:59:40 -0800 (PST)
Date: Mon, 29 Nov 2010 12:59:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS: performance
Message-ID: <20101129015937.GB28672@dastard>
References: <AANLkTi=u8dX0ehPN3Rv3FQ+84htY3AYEv0eboGgC7_qi@mail.gmail.com>
	<20101129001112.GA28672@dastard>
	<AANLkTikom6jpkuZquTfinGpaqz4Gp0y8niYN7yWQgmzj@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTikom6jpkuZquTfinGpaqz4Gp0y8niYN7yWQgmzj@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Yclept Nemo <orbisvicis@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, Nov 29, 2010 at 01:21:11AM +0000, Yclept Nemo wrote:
> On Mon, Nov 29, 2010 at 12:11 AM, Dave Chinner <david@fromorbit.com> wrot=
e:
> > On Sun, Nov 28, 2010 at 10:51:04PM +0000, Yclept Nemo wrote:
> >> After 3-4 years of using one XFS partition for every mount point
> >> (/,/usr,/etc,/home,/tmp...) I started noticing a rapid performance
> >> degradation. Subjectively I now feel my XFS partition is 5-10x slower
> >> ... while other partitions (ntfs,ext3) remain the same.
> >
> > Can you run some benchmarks to show this non-subjectively? Aged
> > filesystems will be slower than new filesytsems, and it should be
> > measurable. Also, knowing what you filesystem contains (number of
> > files, used capacity, whether you have run it near ENOSPC for
> > extended periods of time, etc) would help us understand the way the
> > filesytesm has aged as well.
> =

> Certainly, if you are interested I can run either dbench or bonnie++
> tests comparing an XFS partition (with default values from xfsprogs
> 3.1.3) on the new hard-drive to the existing partition on the old. As
> I'm not sure what you're looking for, what command parameters should I
> profile against?
> =

> The XFS partition in question is 39.61GB in size, of which 30.71GB are
> in use (8.90GB free). It contains a typical Arch Linux installation
> with many programs and many personal files. Usage pattern as follows:
> . equal runtime split between (near ENOSPC) and (approximately 10.0GB fre=
e)

There's your problem - it's a well known fact that running XFS at
more than 85-90% capacity for extended periods of time causes free
space fragmentation and that results in performance degradation.

> . mostly small files, one or two exceptions
> . often reach ENOSPC through carelessness
> . run xfs_fsr very often

And xfs_fsr is also known to cause free space fragmentation when run
on filesystems with not much space available...

> >> I was considering running "mkfs.xfs -d agcount=3D32 -i attr=3D2 -l
> >> version=3D2,lazy-count=3D1,size=3D256m /dev/sda5".
> >>
> >> Yes, I know that in xfs_progs 3.1.3 "-i attr=3D2 -l
> >> version=3D2,lazy-count=3D1" are already default options. However I thi=
nk I
> >> should tweak the log size, blocksize, and data allocation group counts
> >> beyond the default values and I'm looking for some recommendations or
> >> input.
> >
> > Why do you think you should tweak them?
> =

> To avoid the aging slowdown as well as to increase read/write/metadata
> performance with small files.

According to your description above, tweaking these will not help
you at all.

> >> I assume mkfs.xfs automatically selects optimal values, but I *have*
> >> space to spare for a larger log section... and perhaps my old XFS
> >> partition became sluggish when the log section had filled up, if this
> >> is even possible.
> >
> > Well, you had a very small log (20MB) on the original filesystem,
> > and so as the filesystems ages (e.g. free space fragments), each
> > allocation/free transaction would be larger than on a new filesytsem
> > because of the larger btrees that need to be manipulated. With such
> > a small log, that could be part of the reason for the slowdown you
> > were seeing. =A0However, without knowing what you filesystem looks
> > like physically, this is only speculation.
> >
> > That being said, the larger log (50MB) that the new filesystem has
> > shouldn't have the same degree of degradation under the same aging
> > characteristics. It's probably not necesary to go larger than ~100MB
> > for partition of 100GB on a single spindle...
> =

> In this case I'll aim for a large log section, probably 256 or 512MB,
> unless it will impede performance.

It can because once you get into a tail-pushing situation then it'll
trigger lots and lots of metadata IO. That's probably not ideal for
a laptop drive. You'd do better to keep the log at around 100MB and
use delayed logging....

> That way there will be no problems
> when I resize the partition to 200GB ... 300GB... up to a maximum of
> 450GB. In fact the manual page of xfs_growfs - which might be outdated
> - warns that log resizing is not implemented, so it would probably be
> auspicious to create an overly-large log section.
> =

> >> Similarly a larger agcount should always give better performance,
> >> right?
> >
> > No.
> >
> >> Some resources claim that agcount should never fall below
> >> eight.
> >
> > If those resources are right, then why would we default to 4 AGs for
> > filesystems on single spindles?
> =

> Obviously you are against modifying the agcount - I won't touch it :)

No, what I'm pointing out is that <some random web reference> is not
a good guide for tuning an XFS filesystem. You need to _understand_
what changing that knob does before you change it. If you don't
understand what it does, then don't change it...

> Not actually sure what I intended. My knowledge of file-systems
> depends on Google and that statement was only a shot in the dark.
> However, you've convinced me not to change the blocksize (keep in mind
> I'm running an entire Linux installation from this one XFS partition,
> small files included).

Sure, I do that too. My workstation has a 220GB root partition that
contains all my kernel trees, build areas, etc. It has agcount=3D16
because I'm running on a 8c machine and do 8-way parallel builds, a
log of 105MB and I'm using delaylog....

> If the blocksize option is so
> performance-independent, why does it even exist?

Because there are situations where it makes sense to change the
block size. That isn't really a general use root filesystem,
though...

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
