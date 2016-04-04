Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2E6EF7CA0
	for <xfs@oss.sgi.com>; Mon,  4 Apr 2016 02:55:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E5C41304032
	for <xfs@oss.sgi.com>; Mon,  4 Apr 2016 00:55:32 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	biVp7toJVQR5vwJt for <xfs@oss.sgi.com>;
	Mon, 04 Apr 2016 00:55:29 -0700 (PDT)
Date: Mon, 4 Apr 2016 17:55:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/7] fs: introduce iomap infrastructure
Message-ID: <20160404075514.GD11238@dastard>
References: <1457989370-6904-1-git-send-email-hch@lst.de>
	<1457989370-6904-3-git-send-email-hch@lst.de>
	<20160404012849.GB11238@dastard> <20160404014706.GC11238@dastard>
	<20160404071203.GA29313@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160404071203.GA29313@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Mon, Apr 04, 2016 at 09:12:03AM +0200, Christoph Hellwig wrote:
> On Mon, Apr 04, 2016 at 11:47:06AM +1000, Dave Chinner wrote:
> > > Patch below fixes the issue, as well as the fact that
> > > iomap_page_mkwrite_actor() needs to return the count of bytes
> > > "written", not zero on success for iomap_write_segment() to do the
> > > right thing on multi-segment writes.
> > 
> > Hmm - this fix then breaks generic/029. Christoph, can you look into
> > these issues?
> 
> I've allocated some time for the series this week, I'll also add the
> iomap based fiemap implementation from the gfs2 folks while I'm at it.

Great! I've been running it here for the past week or so, and on 4k
block size filesystems it hasn't caused any regressions. I've been
running it with the straight-to-bio writeback paches for XFS as
well, and it seems to be playing nicely with that, too. The above
problems were seen independent of the witeback patch series,
though...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
