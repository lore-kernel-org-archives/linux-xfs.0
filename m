Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2TJcoDi160071 for <xfs@oss.sgi.com>; Thu, 29 Mar 2012 14:38:51 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	Ao5zUTg1eBbGZJPG (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 29 Mar 2012 12:38:49 -0700 (PDT)
Date: Thu, 29 Mar 2012 15:38:43 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 00/10] remove xfsbufd
Message-ID: <20120329193843.GA32368@infradead.org>
References: <20120327164400.967415009@bombadil.infradead.org>
	<20120328005337.GH3592@dastard>
	<20120328151040.GA2487@infradead.org>
	<20120329005224.GJ5091@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120329005224.GJ5091@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Mar 29, 2012 at 11:52:24AM +1100, Dave Chinner wrote:
> I suspect that this can be done without much API churn, and it would
> remove the central per-AG buffer cache lookups for most operations.
> Smaller caches means less lookup overhead for most operations - with
> 10-11% of CPU time being spent in lookups on an 8p machine, that's
> almost an entire CPU worth of time being used. Hence reducing the
> rbtree lookup and modification overhead should be a significant win.
> 
> Crazy idea, yes, but I'm going to think about it some more,
> especially as the shrinker operates of the LRU and is entirely
> independent of the rbtree indexing.....

Sounds like a good idea to me.  I think the biggest win will be to index
the directory blocks logically, e.g. have a tree hanging off the inode
to find them.  The other worthwhile optimizations besides avoiding AGI buffer
lookups during inode scanning would be to do something more about inode
buffers - probably a tree that maps directly from inode number to the
backing buffer.

I'd probably add the secondary tree linkage directly to the buffer to
keep things simpler.  In fact I'm not even sure we need a secondary
linkage - at least from a quick look I can't see why we'd need to keep
buffers on the physically indexed per-ag rbtree if we can find them by
other means.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
