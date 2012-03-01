Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q216VGBm086532 for <xfs@oss.sgi.com>; Thu, 1 Mar 2012 00:31:16 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	u7eD8kBqHovGUZn7 (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 29 Feb 2012 22:31:15 -0800 (PST)
Date: Thu, 1 Mar 2012 01:31:13 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Poor performance using discard
Message-ID: <20120301063113.GA15854@infradead.org>
References: <1330469778.9688.7.camel@core24> <20120229012259.GW3592@dastard>
	<1330480826.9688.23.camel@core24> <20120229040819.GZ3592@dastard>
	<4F4E809A.40308@sandeen.net> <20120301055943.GA23051@infradead.org>
	<20120301062709.GB5091@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120301062709.GB5091@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, Thomas Lynema <lyz27@yahoo.com>, xfs@oss.sgi.com

On Thu, Mar 01, 2012 at 05:27:09PM +1100, Dave Chinner wrote:
> One other thing the ext4 tracing implementation does is merge
> adjacent ranges, whereas the XFS implementation does not. XFS has
> more tracking complexity than ext4, though, in that it tracks free
> extents in multiple concurrent journal commits whereas ext4 only has
> to track across a single journal commit.  Hence ext4 can merge
> without having to care about where the adjacent range is being
> committed in the same journal checkpoint.
> 
> Further, ext4 doesn't reallocate from the freed extents until after
> the journal commit completes, whilst XFS can reallocate freed ranges
> before the freeing is journalled and hence can modify ranges in the
> free list prior to journal commit.
> 
> We could probably implement extent merging in the free extent
> tracking similar to ext4, but I'm not sure how much it would gain us
> because of the way we do reallocation of freed ranges prior to
> journal commit....

Also there generally aren't that many merging opportunities.  Back when
I implemented the code and looked at block traces we'd get them
occasionally:

 (a) for inode buffers due to the inode clusters beeing smaller than the
     inode chunks.  Better fixed by increasing the amount of inode
     clustering we do.
 (b) during rm -rf sometimes when lots of small files were end-to-end,
     but this doesn't happen all that often.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
