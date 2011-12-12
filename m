Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBC10vXF063378 for <xfs@oss.sgi.com>; Sun, 11 Dec 2011 19:00:57 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D05BC1B421AB
	for <xfs@oss.sgi.com>; Sun, 11 Dec 2011 17:00:55 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	x1lani7KFgodSc7x for <xfs@oss.sgi.com>;
	Sun, 11 Dec 2011 17:00:55 -0800 (PST)
Date: Mon, 12 Dec 2011 12:00:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Bad performance with XFS + 2.6.38 / 2.6.39
Message-ID: <20111212010053.GM14273@dastard>
References: <CACaf2aYZ=k=x8sPFJs4f-4vQxs+qNyoO1EUi8X=iBjWjRhy99Q@mail.gmail.com>
	<20111211233929.GI14273@dastard>
	<CACaf2aYTsxOBXEJEbQu7gwAminBc3R2usDHvypJW0AqOfnz0Pg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CACaf2aYTsxOBXEJEbQu7gwAminBc3R2usDHvypJW0AqOfnz0Pg@mail.gmail.com>
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
To: Xupeng Yun <xupeng@xupeng.me>
Cc: XFS group <xfs@oss.sgi.com>

On Mon, Dec 12, 2011 at 08:40:15AM +0800, Xupeng Yun wrote:
> On Mon, Dec 12, 2011 at 07:39, Dave Chinner <david@fromorbit.com> wrote:
> >
> > > ====== XFS + 2.6.29 ======
> >
> > Read 21GB @ 11k iops, 210MB/s, av latency of 1.3ms/IO
> > Wrote 2.3GB @ 1250 iops, 20MB/s, av latency of 0.27ms/IO
> > Total 1.5m IOs, 95% @ <= 2ms
> >
> > > ====== XFS + 2.6.39 ======
> >
> > Read 6.5GB @ 3.5k iops, 55MB/s, av latency of 4.5ms/IO
> > Wrote 700MB @ 386 iops, 6MB/s, av latency of 0.39ms/IO
> > Total 460k IOs, 95% @ <= 10ms, 4ms > 50% < 10ms
> >
> > Looking at the IO stats there, this doesn't look to me like an XFS
> > problem. The IO times are much, much longer on 2.6.39, so that's the
> > first thing to understand. If the two tests are doing identical IO
> > patterns, then I'd be looking at validating raw device performance
> > first.
> >
> 
> Thank you Dave.
> 
> I also did raw device and ext4 performance test with 2.6.39, all these
> tests are
> doing identical IO patterns(non-buffered IO, 16 IO threads, 16KB block size,
> mixed random read and write, r:w=9:1):
> ====== raw device + 2.6.39 ======
> Read 21.7GB @ 11.6k IOPS , 185MB/s, av latency of 1.37 ms/IO
> Wrote 2.4GB @ 1.3k IOPS, 20MB/s, av latency of 0.095 ms/IO
> Total 1.5M IOs, @ 96% <= 2ms
> 
> ====== ext4 + 2.6.39 ======
> Read 21.7GB @ 11.6k IOPS , 185MB/s, av latency of 1.37 ms/IO
> Wrote 2.4GB @ 1.3k IOPS, 20MB/s, av latency of 0.1 ms/IO
> Total 1.5M IOs, @ 96% <= 2ms
> 
> ====== XFS + 2.6.39 ======
> Read 6.5GB @ 3.5k iops, 55MB/s, av latency of 4.5ms/IO
> Wrote 700MB @ 386 iops, 6MB/s, av latency of 0.39ms/IO
> Total 460k IOs, @ 95% <= 10ms, 4ms > 50% < 10ms

Oh, of course, now I remember what the problem is - it's a locking
issue that was fixed in 3.0.11, 3.1.5 and 3.2-rc1.

commit 0c38a2512df272b14ef4238b476a2e4f70da1479
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu Aug 25 07:17:01 2011 +0000

    xfs: don't serialise direct IO reads on page cache checks
    
    There is no need to grab the i_mutex of the IO lock in exclusive
    mode if we don't need to invalidate the page cache. Taking these
    locks on every direct IO effective serialises them as taking the IO
    lock in exclusive mode has to wait for all shared holders to drop
    the lock. That only happens when IO is complete, so effective it
    prevents dispatch of concurrent direct IO reads to the same inode.
    
    Fix this by taking the IO lock shared to check the page cache state,
    and only then drop it and take the IO lock exclusively if there is
    work to be done. Hence for the normal direct IO case, no exclusive
    locking will occur.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Tested-by: Joern Engel <joern@logfs.org>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Alex Elder <aelder@sgi.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
