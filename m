Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6K0KvQV200685 for <xfs@oss.sgi.com>; Tue, 19 Jul 2011 19:20:58 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 142E8150D648
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2011 17:20:56 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	r3WVXx2Eu9z0yb2g for <xfs@oss.sgi.com>;
	Tue, 19 Jul 2011 17:20:56 -0700 (PDT)
Date: Wed, 20 Jul 2011 10:20:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 30 TB RAID6 + XFS slow write performance
Message-ID: <20110720002053.GD9359@dastard>
References: <4E24907F.6020903@johnbokma.com>
	<20110719103719.18c4773f@galadriel.home>
	<4E260725.4040003@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E260725.4040003@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: John Bokma <contact@johnbokma.com>, xfs@oss.sgi.com

On Tue, Jul 19, 2011 at 05:37:25PM -0500, Stan Hoeppner wrote:
> On 7/19/2011 3:37 AM, Emmanuel Florac wrote:
> > Le Mon, 18 Jul 2011 14:58:55 -0500 vous =E9criviez:
> > =

> >> card: MegaRAID SAS 9260-16i
> >> disks: 14x Barracuda=AE XT ST33000651AS 3TB (2 hot spares).
> >> RAID6
> >> ~ 30TB
> =

> > This card doesn't activate the write cache without a BBU present. Be
> > sure you have a BBU or the performance will always be unbearably awful.
> =

> In addition to all the other recommendations, once the BBU is installed,
> disable the individual drive caches (if this isn't done automatically),
> and set the controller cache mode to 'write back'.  The write through
> and direct I/O cache modes will deliver horrible RAID6 write performance.
> =

> And, BTW, RAID6 is a horrible choice for a parallel, small file, high
> random I/O workload such as you've described.  RAID10 would be much more
> suitable.  Actually, any striped RAID is less than optimal for such a
> small file workload.  The default stripe size for the LSI RAID
> controllers, IIRC, is 64KB.  With 14 spindles of stripe width you end up
> with 64*14 =3D 896KB. =


All good up to here.

> XFS will try to pack as many of these 50-150K files
> into a single extent, but you're talking 6 to 18 files per extent,

I think you've got your terminology wrong. An extent can only belong
to a single inode, but an inode can contain many extents, as can a
stripe width. We do not pack data from multiple files into a single
extent.

For new files on a su/sw aware filesystem, however, XFS will *not*
pack multiple files into the same stripe unit. It will try to align
the first extent of the file to sunit, or if you have the swalloc
mount option set and the allocation is for more than a swidth of
space it will align to swidth rather than sunit.

So if you have a small file workload, specifying sunit/swidth can
actually -decrease- performance because it allocates the file
extents sparsely. IOWs, stripe alignment is important for bandwidth
intensive applications because it allows full stripe writes to occur
much more frequently, but can be harmful to small file performance
as the aligned allocation pattern can prevent full stripe writes
from occurring.....

> and
> this is wholly dependent on the parallel write pattern, and in which of
> the allocation groups XFS decides to write each file.

That's pretty much irrelevant for small files as a single allocation
is done for each file during writeback.

> XFS isn't going
> to be 100% efficient in this case.  Thus, you will end up with many
> partial stripe width writes, eliminating much of the performance
> advantage of striping.

Yes, that's the ultimate problem, but not for the reasons you
suggested. ;)

> These are large 7200 rpm SATA drives which have poor seek performance to
> begin with, unlike the 'small' 300GB 15k SAS drives.  You're robbing
> that poor seek performance further by:
> =

> 1.  Using double parity striped RAID
> 2.  Writing thousands of small files in parallel

The writing in parallel is only an issue if it is direct or
synchronous IO. If it's using normal buffered writes, then writeback
is mostly single threaded and delayed allocation should be preventing
fragmentation completely. That still doesn't guarantee that
writeback avoids RAID RMW cycles (see above about allocation
alignment).

> This workload is very similar to the case of a mail server using the
> maildir storage format.

There's not enough detail in the workload description to make that
assumption.

> If you read the list archives you'll see
> recommendations for an optimal storage stack setup for this workload.
> It goes something like this:
> =

> 1.  Create a linear array of hardware RAID1 mirror sets.
>     Do this all in the controller if it can do it.
>     If not, use Linux RAID (mdadm) to create a '--linear' array of the
>     multiple (7 in your case, apparently) hardware RAID1 mirror sets
> =

> 2.  Now let XFS handle the write parallelism.  Format the resulting
>     7 spindle Linux RAID device with, for example:
> =

>     mkfs.xfs -d agcount=3D14 /dev/md0
> =

> By using this configuration you eliminate the excessive head seeking
> associated with the partial stripe write problems of RAID6, restoring
> performance efficiency to the array.  Using 14 allocation groups allows
> XFS to write write, at minimum, 14 such files in parallel.

That's not correct. 14 AG means that if the files are laid out
across all AGs then there can be 14 -allocations- in parallel at
once. If Io does not require allocation, then they don't serialise
at all on the AGs.  IOWs, If allocation takes 1ms of work in an AG,
then you could have 1,000 allocations per second per AG. With 14
AGs, that gives allocation capability of up to 14,000/s

And given that not all writes require allocation and allocation is
usually only a small percentage of the total IO time. You can have
many, many more write IOs in flight than you can do allocations in
an AG....

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
