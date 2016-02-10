Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 202AB7CB7
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 15:25:59 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B0F6FAC002
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 13:25:55 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	shVtc64o1c8PzqGL for <xfs@oss.sgi.com>;
	Wed, 10 Feb 2016 13:25:52 -0800 (PST)
Date: Thu, 11 Feb 2016 08:25:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/8 v4] xfs: get rid of xfs_cluster_write
Message-ID: <20160210212550.GM14668@dastard>
References: <1455094043-9694-1-git-send-email-david@fromorbit.com>
	<20160210182538.GA7481@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160210182538.GA7481@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Feb 10, 2016 at 10:25:38AM -0800, Christoph Hellwig wrote:
> On Wed, Feb 10, 2016 at 07:47:15PM +1100, Dave Chinner wrote:
> > of the writepage context. Patches 7 and 8 are new patches (as in the
> > first time I've posted them) to demonstrate how to remove the IO
> > completion dependency on recording the bufferehads attached to the
> > ioend. This is the first step in removing bufferheads from the
> > writepage IO path - these are FYI patches, not patches I want to
> > have committed immediately.
> 
> This looks interesting.  I played around with this a bit and ported
> my patch to embedd the main bio into struct ioend to it.  My older
> version allowed to chain additional bios to get ioends larger than
> 1MB (or PAGE_SIZE * 256), but that will require additional work
> in the new completion handler.  It does however simplify things quite
> a bit, and I suspect a lot of that simplification could be kept even
> with chained bios.  I've attached the patch below for reference:

I really like the idea, especially how using a bioset encapsulates
the ioend and binds the life cycle to the bio. It also removes a
heap of code, too.

We really do need some form of chaining here, though. If we don't,
then we'll be doing unwritten extent of set file size transactions
for ever 1MB bio completion instead of once for however large
writepages can build an ioend.

I think this is definitely worth pursuing - are you going to get any
time to work on this in the next couple of months, Christoph (i.e.
to target the 4.7 merge window)?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
