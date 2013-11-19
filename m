Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BACDE29E04
	for <xfs@oss.sgi.com>; Mon, 18 Nov 2013 18:57:47 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A87B28F8040
	for <xfs@oss.sgi.com>; Mon, 18 Nov 2013 16:57:47 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	U123qTIeIDy4NSBX for <xfs@oss.sgi.com>;
	Mon, 18 Nov 2013 16:57:44 -0800 (PST)
Date: Tue, 19 Nov 2013 11:57:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Filesystem writes on RAID5 too slow
Message-ID: <20131119005740.GY6188@dastard>
References: <CACtJ3HZxp6xEjY_wOucCcqX4scNzEGuiAsovQYObJS9whtYJsQ@mail.gmail.com>
	<528A5C45.4080906@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <528A5C45.4080906@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Martin Boutin <martboutin@gmail.com>, "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>, "Kernel.org-Linux-EXT4" <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On Mon, Nov 18, 2013 at 12:28:21PM -0600, Eric Sandeen wrote:
> On 11/18/13, 10:02 AM, Martin Boutin wrote:
> > Dear list,
> > 
> > I am writing about an apparent issue (or maybe it is normal, that's my
> > question) regarding filesystem write speed in in a linux raid device.
> > More specifically, I have linux-3.10.10 running in an Intel Haswell
> > embedded system with 3 HDDs in a RAID-5 configuration.
> > The hard disks have 4k physical sectors which are reported as 512
> > logical size. I made sure the partitions underlying the raid device
> > start at sector 2048.
> 
> (fixed cc: to xfs list)
> 
> > The RAID device has version 1.2 metadata and 4k (bytes) of data
> > offset, therefore the data should also be 4k aligned. The raid chunk
> > size is 512K.
> > 
> > I have the md0 raid device formatted as ext3 with a 4k block size, and
> > stride and stripes correctly chosen to match the raid chunk size, that
> > is, stride=128,stripe-width=256.
> > 
> > While I was working in a small university project, I just noticed that
> > the write speeds when using a filesystem over raid are *much* slower
> > than when writing directly to the raid device (or even compared to
> > filesystem read speeds).
> > 
> > The command line for measuring filesystem read and write speeds was:
> > 
> > $ dd if=/tmp/diskmnt/filerd.zero of=/dev/null bs=1M count=1000 iflag=direct
> > $ dd if=/dev/zero of=/tmp/diskmnt/filewr.zero bs=1M count=1000 oflag=direct
> > 
> > The command line for measuring raw read and write speeds was:
> > 
> > $ dd if=/dev/md0 of=/dev/null bs=1M count=1000 iflag=direct
> > $ dd if=/dev/zero of=/dev/md0 bs=1M count=1000 oflag=direct
> > 
> > Here are some speed measures using dd (an average of 20 runs).:
> > 
> > device       raw/fs  mode   speed (MB/s)    slowdown (%)
> > /dev/md0    raw    read    207
> > /dev/md0    raw    write    209
> > /dev/md1    raw    read    214
> > /dev/md1    raw    write    212

So, that's writing to the first 1GB of /dev/md0, and all the writes
are going to be aligned to the MD stripe.

> > /dev/md0    xfs    read    188    9
> > /dev/md0    xfs    write    35    83o

And these will not be written to the first 1GB of the block device
but somewhere else. Most likely a region that hasn't otherwise been
used, and so isn't going to be overwriting the same blocks like the
/dev/md0 case is going to be. Perhaps there's some kind of stripe
caching effect going on here? Was the md device fully initialised
before you ran these tests?

> > 
> > /dev/md1    ext3    read    199    7
> > /dev/md1    ext3    write    36    83
> > 
> > /dev/md0    ufs    read    212    0
> > /dev/md0    ufs    write    53    75
> > 
> > /dev/md0    ext2    read    202    2
> > /dev/md0    ext2    write    34    84

I suspect what you are seeing here is either the latency introduced
by having to allocate blocks before issuing the IO, or the file
layout due to allocation is not idea. Single threaded direct IO is
latency bound, not bandwidth bound and, as such, is IO size
sensitive. Allocation for direct IO is also IO size sensitive -
there's typically an allocation per IO, so the more IO you have to
do, the more allocation that occurs.

So, on XFS, what does "xfs_bmap -vvp /tmp/diskmnt/filewr.zero"
output for the file you wrote? Specifically, I'm interested whether
it aligned the allocations to the stripe unit boundary, and if so,
what offset into the device those extents sit at....

Also, you should run iostat and blktrace to determine if MD is
doing RMW cycles when being written to through the filesystem.

> > Is it possible that the filesystem has such enormous impact in the
> > write speed? We are talking about a slowdown of 80%!!! Even a
> > filesystem as simple as ufs has a slowdown of 75%! What am I missing?
> 
> One thing you're missing is enough info to debug this.
> 
> /proc/mdstat, kernel version, xfs_info output, mkfs commandlines used,
> partition table details, etc.

THere's a good list here:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

> If something is misaligned and you are doing RMW for these IOs it could
> hurt a lot.
> 
> -Eric
> 
> > Thank you,
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
