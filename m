Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7U5Rxkk114093 for <xfs@oss.sgi.com>; Tue, 30 Aug 2011 00:27:59 -0500
Date: Tue, 30 Aug 2011 01:27:55 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [xfs-masters] [dm-devel] new dm-bufio
Message-ID: <20110830052755.GA30730@infradead.org>
References: <Pine.LNX.4.64.1108221600510.26651@hs20-bc2-1.build.redhat.com>
	<20110823113048.GC5442@ubuntu>
	<Pine.LNX.4.64.1108231012560.2629@hs20-bc2-1.build.redhat.com>
	<20110823185423.GA10936@infradead.org>
	<Pine.LNX.4.64.1108291445460.7825@hs20-bc2-1.build.redhat.com>
	<20110830014906.GJ3162@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110830014906.GJ3162@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Joe Thornber <thornber@redhat.com>, Mike Snitzer <snitzer@redhat.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, xfs-masters@oss.sgi.com, device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>

On Tue, Aug 30, 2011 at 11:49:06AM +1000, Dave Chinner wrote:
> 
> It's a relic from the days of Irix that we've kept around and never
> really touched because it's never shown up as a problem. Such code
> is cleaned up as we go along or as problems arise.
> 
> As it is, this patchset:
> 
> http://thread.gmane.org/gmane.linux.kernel.mm/67326
> 
> that I'm currently working on changes the shrinker API to be much
> more sane - the shrinker now has a separate "count objects"
> operation and the "scan objects" operation now returns the number of
> items freed rather than the number of items left in the cache.

I think if you find bugs like that they should be in patches separate
from the main conversion.  Especially given that the 3.2 merge window
is getting closer a first batch of patches with these fixes and some
of the preparatory icache/dcache changes that can go into linux-next
ASAP would be nice.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
