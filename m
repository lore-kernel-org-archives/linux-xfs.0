Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0DLnuEa010907 for <xfs@oss.sgi.com>; Tue, 13 Jan 2009 15:49:58 -0600
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D6A971BA3231
	for <xfs@oss.sgi.com>; Tue, 13 Jan 2009 13:49:53 -0800 (PST)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	HHlwUzGCMqhAwMxY for <xfs@oss.sgi.com>;
	Tue, 13 Jan 2009 13:49:53 -0800 (PST)
Date: Wed, 14 Jan 2009 08:49:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: spurious -ENOSPC on XFS
Message-ID: <20090113214949.GN8071@disturbed>
References: <Pine.LNX.4.64.0901120509550.11089@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0901120509550.11089@hs20-bc2-1.build.redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Jan 12, 2009 at 06:14:36AM -0500, Mikulas Patocka wrote:
> Hi
> 
> I discovered a bug in XFS in delayed allocation.
> 
> When you take a small partition (52MB in my case) and copy many small 
> files on it (source code) that barely fits there, you get -ENOSPC. Then 
> sync the partition, some free space pops up, click "retry" in MC an the 
> copy continues. They you get again -ENOSPC, you must sync, click "retry" 
> and go on. And so on few times until the source code finally fits on the 
> XFS partition.

Not a Bug. This is by design.

> This misbehavior is apparently caused by delayed allocation, delayed 
> allocation does not exactly know how much space will be occupied by data, 
> so it makes some upper bound guess.

No, we know *exactly* how much space is consumed by the data. What
we don't know is how much space will be required for additional
*metadata* to do the allocation so we reserve the worst case need so
hat we should never get an ENOSPC during async writeback when we
can't report the error to anyone.  Worst case is 4 metadata blocks
per allocation (delalloc extent, really).

If we ENOSPC in the delalloc path, we have two choices:

	1. potentially lock the system up due to OOM and being
	   unable to flush pages
	2. throw away user data without being able to report an
	   error to the application that wrote it originally.

Personally, I don't like either option, so premature ENOSPC at
write() time is fine by me....

> Because free space count is only a 
> guess, not the actual data being consumed, XFS should not return -ENOSPC 
> on behalf of it. When the free space overflows, XFS should sync itself, 
> retry allocation and only return -ENOSPC if it fails the second time, 
> after the sync.

It does, by graduated response (see xfs_iomap_write_delay() and
xfs_flush_space()):

	1. trigger async flush of the inode and retry
	2. retry again
	3. start a filesystem wide flush, wait 500ms and try again
	4. really ENOSPC now.

It could probably be improved but, quite frankly, XFS wasn't designed
for small filesystems so I don't think this is worth investing any
major effort in changing/fixing.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
