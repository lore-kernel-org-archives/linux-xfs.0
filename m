Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 864D77CA0
	for <xfs@oss.sgi.com>; Sun,  3 Apr 2016 20:47:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5A2798F8035
	for <xfs@oss.sgi.com>; Sun,  3 Apr 2016 18:47:41 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	tuk7yb7cECYnEaPv for <xfs@oss.sgi.com>;
	Sun, 03 Apr 2016 18:47:38 -0700 (PDT)
Date: Mon, 4 Apr 2016 11:47:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/7] fs: introduce iomap infrastructure
Message-ID: <20160404014706.GC11238@dastard>
References: <1457989370-6904-1-git-send-email-hch@lst.de>
	<1457989370-6904-3-git-send-email-hch@lst.de>
	<20160404012849.GB11238@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160404012849.GB11238@dastard>
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

On Mon, Apr 04, 2016 at 11:28:49AM +1000, Dave Chinner wrote:
> On Mon, Mar 14, 2016 at 10:02:45PM +0100, Christoph Hellwig wrote:
> > Add infrastructure for multipage buffered writes.  This is implemented
> > using an main iterator that applies an actor function to a range that
> > can be written.
....
> Patch below fixes the issue, as well as the fact that
> iomap_page_mkwrite_actor() needs to return the count of bytes
> "written", not zero on success for iomap_write_segment() to do the
> right thing on multi-segment writes.

Hmm - this fix then breaks generic/029. Christoph, can you look into
these issues?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
