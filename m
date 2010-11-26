Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAQCKgmP163137 for <xfs@oss.sgi.com>; Fri, 26 Nov 2010 06:20:43 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 493781528FE7
	for <xfs@oss.sgi.com>; Fri, 26 Nov 2010 04:22:20 -0800 (PST)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	ilgJe0siFy0A3Cb4 for <xfs@oss.sgi.com>;
	Fri, 26 Nov 2010 04:22:20 -0800 (PST)
Date: Fri, 26 Nov 2010 23:22:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Verify filesystem is aligned to stripes
Message-ID: <20101126122218.GH12187@dastard>
References: <4CED5BFC.8000906@shiftmail.org> <20101125054607.GM13830@dastard>
	<4CEE0995.9030900@hardwarefreak.com>
	<20101125101537.GD12187@dastard>
	<4CEEE9BC.2030401@hardwarefreak.com>
	<20101126091622.264830fa@galadriel.home>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101126091622.264830fa@galadriel.home>
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, xfs@oss.sgi.com

On Fri, Nov 26, 2010 at 09:16:22AM +0100, Emmanuel Florac wrote:
> Le Thu, 25 Nov 2010 16:57:00 -0600 vous =E9criviez:
> =

> > Looking at the stripe size, which is equal to 64 sectors per array
> > member drive (448 sectors total), how exactly is a sub 4KB mail file
> > (8 sectors) going to be split up into equal chunks across a 224KB RAID
> > stripe?
> =

> It won't, it will simply end on one drive (actually one mirror).
> However because the mirrors are striped together, all drives in the
> array will be sollicited in my experience, that's why you need at least
> as many writing threads as there are stripes to reach the top IOPS. In
> your case, writing 56 4K files simultaneously will effectively write on
> all drives at once, hopefully (depends upon the filesystem allocation
> policy though).
> =

> >  Does 220KB of the stripe merely get wasted? =

> =

> It's not wasted, it just remains unallocated. What's wasted is
> potential IO performance.

No, that's wrong. I don't have the time to explain the intricacies
of how XFS packs small files together, but it does. You can observe
the result by unpacking a kernel tarball and looking at the layout
with xfs_bmap if you really want to...

FWIW, for workloads that do random, small IO, XFS works best when you
_turn off_ aligned allocation and just let it spray the IO at the
disks. This works best if you are using RAID 0/1/10. All the numbers
I've been posting are with aligned allocation turned off (i.e. no
sunit/swidth set).

> What appears from the benchmarks I ran along the year is that anyway
> you turn it, whatever caching, command tag queuing and reordering
> your're using, a single thread can't reach maximal IOPS throughput on
> an array, i. e. writing on all drives simultaneously; a single thread
> writing to the fastest RAID 10 with 4K or 8K IOs can't do much better
> than with a single drive, 200 to 300 IOPS for a 15k drive.

Assuming synchronous IO. If you are doing async IO, a single CPU
should be able to keep hundreds of SRDs (Spinning Rust Disks) busy...

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
