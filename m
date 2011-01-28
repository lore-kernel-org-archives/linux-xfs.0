Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0S5nVgi114124 for <xfs@oss.sgi.com>; Thu, 27 Jan 2011 23:49:31 -0600
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 70D8F8D8356
	for <xfs@oss.sgi.com>; Thu, 27 Jan 2011 21:51:55 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	vPB9r6MsBBzHHnYA for <xfs@oss.sgi.com>;
	Thu, 27 Jan 2011 21:51:55 -0800 (PST)
Date: Fri, 28 Jan 2011 16:51:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/6] xfs: optimize xfs_alloc_fix_freelist
Message-ID: <20110128055153.GT21311@dastard>
References: <20110121092227.115815324@bombadil.infradead.org>
	<20110121092551.185804716@bombadil.infradead.org>
	<20110128053653.GS21311@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110128053653.GS21311@dastard>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, Jan 28, 2011 at 04:36:53PM +1100, Dave Chinner wrote:
> Thinking through this a bit more - we don't need to do a busy search
> for metadata allocations - it's only necessary for metadata -> data
> extent transistions. Metadata modifications are all logged, so there
> is no need to force out the busy extent transaction if the next
> allocation is for metadata. If the new transaction hits the disk,
> then it will only be replayed if the previous transaction to free
> the extent is on the disk and has already been replayed.
> 
> Hence I think we only need to do a busy search in these cases for
> XFS_FREELIST_ALLOC when args->userdata == 0. The XFS_FREELIST_BTREE
> case is definitely a metadata allocation, so it seems to me that
> there is further scope for optimisation here. i.e. that allocbt ->
> freelist -> allocbt doesn't require a sync transaction to be issued.
> 
> The code as it stands looks good; the question is should we take
> this next step as well? Have I missed anything that makes this a bad
> thing to do, Christoph?

Oh, I see the next patch tries to address this. That'll learn me to
read the entire patch series through before commenting on any of
it. I'll take this discussion to that patch.... ;)

Cheers,,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
