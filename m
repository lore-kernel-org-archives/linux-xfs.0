Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4FB6B7F3F
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2015 16:33:52 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3D8C4304039
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2015 14:33:49 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	NdfmrPtyfVJRYDJx for <xfs@oss.sgi.com>;
	Tue, 24 Feb 2015 14:33:46 -0800 (PST)
Date: Wed, 25 Feb 2015 09:33:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS/LVM/Multipath on a single RAID volume
Message-ID: <20150224223344.GE4251@dastard>
References: <5155F2B2.1010308@binghamton.edu> <20130331012231.GJ6369@dastard>
	<515C3BF3.60601@binghamton.edu> <51684382.50008@binghamton.edu>
	<5168AC0B.5010100@hardwarefreak.com>
	<516C649A.8010003@binghamton.edu>
	<20130416161841.GB13938@destitution>
	<54EA67B7.30805@binghamton.edu>
	<20150223121812.5077ff07@harpe.intellique.com>
	<54ECF573.9050106@binghamton.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54ECF573.9050106@binghamton.edu>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Hall <kdhall@binghamton.edu>
Cc: stan@hardwarefreak.com, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, Feb 24, 2015 at 05:04:35PM -0500, Dave Hall wrote:
> =

> Dave Hall
> Binghamton University
> kdhall@binghamton.edu
> 607-760-2328 (Cell)
> 607-777-4641 (Office)
> =

> =

> On 02/23/2015 06:18 AM, Emmanuel Florac wrote:
> >Le Sun, 22 Feb 2015 18:35:19 -0500
> >Dave Hall<kdhall@binghamton.edu>  =E9crivait:
> >
> >>So since I have a fresh array that's not in production yet I was
> >>hoping to get some pointers on how to configure it to maximize XFS
> >>performance.  In particular, I've seen a suggestion that a
> >>multipathed array should be sliced up into logical drives and pasted
> >>back together with LVM.  Wondering also about putting the journal in
> >>a separate logical drive on the same array.
> >What's the hardware configuration like? before multipathing, you need
> >to know if your RAID controller and disks can actually saturate your
> >link. Generally SAS-attached enclosures are driven through a 4 way
> >SFF-8088 cable, with a bandwidth of 4x 6Gbps (maximum throughput per
> >link: 3 GB/s) or 4 x 12 Gbps (max thruput: 6 GB/s).
> >
> The new hardware is an Infortrend with 16 x 2TB 6Gbps SAS drives.
> It has one controller with dual 6Gbps SAS ports.  The server
> currently has two 3Gbps SAS HBAs.
> =

> On an existing array based on similar but slightly slower hardware,
> I'm getting miserable performance.  The bottleneck seems to be on
> the server side.  For specifics, the array is laid out as a single
> 26TB volume and attached by a single 3Gbps SAS. =


So, 300MB/s max throughput.

> The server is quad
> 8-core Xeon with 128GB RAM.  The networking is all 10GB.  The
> application is rsnapshot which is essentially a series of rsync
> copies where the unchanged files are hard-linked from one snapshot
> to the next.  CPU utilization is very low and only a few cores seem
> to be active.  Yet the operation is taking hours to complete.

rsync is likely limited by network throughput and round trip
latency. Test your storage performance locally first, see it if
performs as expected.

> The premise that was presented to me by someone in the storage
> business is that with 'many' proccessor cores one should slice a
> large array up into segments, multipath the whole deal, and then
> mash the segments back together with LVM (or MD).

No, that's just a bad idea. CPU and memory locality is the least of
your worries, and wont have any influence on performance at such low
speeds. When you start getting up into the multiple-GB/s of
throughput (note, GB/s not Gbps) locality matters more, but not for
what you are doing. And multipathing should be ignored until you've
characterised and understood single port lun performance.

> Since the kernel
> would ultimately see a bunch of smaller storage segments that were
> all getting activity, it should dispatch a set of cores for each
> storage segment and get the job done faster.  I think in theory this
> would even work to some extent on a single-path SAS connection.

The kernel already does most of the necessary locality stuff for
optimal performance for you.

> >>I am able to set up a 2-way multipath right now, and I might be able
> >>to justify adding a second controller to the array to get a 4-way
> >>multipath going.
> >A multipath can double the throughput, provided that you have enough
> >drives: you'll need about 24 7k RPM drives to saturate _one_ 4x6Gbps
> >SAS link. If you have only 12 drives, dual attachment probably won't
> >yield much.
> >
> >>Even if the LVM approach is the wrong one, I clearly have a rare
> >>chance to set this array up the right way.  Please let me know if you
> >>have any suggestions.
> >In my experience, software RAID-0 with md gives slightly better
> >performance than LVM, though not much.
> >
> >
> MD RAID-0 seems as likely as LVM, so I'd probably try that first.
> The big question is how to size the slices of the array

Doesn't really matter for RAID 0.

> to make XFS
> happy and then how to make sure XFS knows about it.

IF you are using MD, then mkfs.xfs will pick up the config
automatically from the MD device.

> Secondly, there
> is the question of the log volume.  Seems that with multipath there
> might be some possible advantage to putting this in it's on slice on
> the array so that log writes could be in an I/O stream that is
> managed separately from the rest.

There are very few workloads where an external log makes any sense
these days. Log bandwidth is generally a minor part of any workload,
and non-volatile write caches aggregrate the sequential writes to
the point where they impose very little physical IO overhead on teh
array...

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
