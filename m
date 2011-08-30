Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7U1nCqq100683 for <xfs@oss.sgi.com>; Mon, 29 Aug 2011 20:49:12 -0500
Date: Tue, 30 Aug 2011 11:49:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [xfs-masters] [dm-devel] new dm-bufio
Message-ID: <20110830014906.GJ3162@dastard>
References: <Pine.LNX.4.64.1108221600510.26651@hs20-bc2-1.build.redhat.com>
	<20110823113048.GC5442@ubuntu>
	<Pine.LNX.4.64.1108231012560.2629@hs20-bc2-1.build.redhat.com>
	<20110823185423.GA10936@infradead.org>
	<Pine.LNX.4.64.1108291445460.7825@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1108291445460.7825@hs20-bc2-1.build.redhat.com>
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
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Joe Thornber <thornber@redhat.com>, Mike Snitzer <snitzer@redhat.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, xfs-masters@oss.sgi.com, device-mapper development <dm-devel@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>

On Mon, Aug 29, 2011 at 02:53:51PM -0400, Mikulas Patocka wrote:
> On Tue, 23 Aug 2011, Christoph Hellwig wrote:
> 
> > FYI, the "shrinker" interface in include/linux/shrinker.h is how the
> > VM tells subsystems to shrink their memory usage.  It is used for
> > various slab caches, and the XFS buffercache in
> > fs/xfs/linux-2.6/xfs_buf.c
> 
> BTW. shrinker functions from xfs_qm.c - xfs_qm_shake and 
> xfs_qm_shake_freelist - look completely bogus. They don't read 
> sc->nr_to_scan to determine how many values they should scan (and compare 
> it with zero to test if they should scan at all) and they return the 
> number of entries freed - the interface specifies that they should return 
> the number of entries remaining the in cache.

It's a relic from the days of Irix that we've kept around and never
really touched because it's never shown up as a problem. Such code
is cleaned up as we go along or as problems arise.

As it is, this patchset:

http://thread.gmane.org/gmane.linux.kernel.mm/67326

that I'm currently working on changes the shrinker API to be much
more sane - the shrinker now has a separate "count objects"
operation and the "scan objects" operation now returns the number of
items freed rather than the number of items left in the cache.

As the API is being changed, the xfs_qm shrinker is also fixed to
return the right values according to the new API. It still doesn't
pay attention to nr_to_scan, but that's not a big deal and will get
addressed in future when other upcoming changes are made to the
code....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
