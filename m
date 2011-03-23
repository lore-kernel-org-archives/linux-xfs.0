Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2NCSZ4T091800 for <xfs@oss.sgi.com>; Wed, 23 Mar 2011 07:28:45 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E792312B1E6E
	for <xfs@oss.sgi.com>; Wed, 23 Mar 2011 05:31:35 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 57IhlGrstDA6nCJt for
	<xfs@oss.sgi.com>; Wed, 23 Mar 2011 05:31:35 -0700 (PDT)
Date: Wed, 23 Mar 2011 08:31:35 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/6] xfs: add online discard support
Message-ID: <20110323123135.GA19111@infradead.org>
References: <20110322195550.260682574@bombadil.infradead.org>
	<20110322200138.024991786@bombadil.infradead.org>
	<20110323003003.GG15270@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110323003003.GG15270@dastard>
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

> > +	if ((mp->m_flags & XFS_MOUNT_DISCARD) == 0)
> > +		return 0;
> 
> I'd move this check to the callers, otherwise we are going to be
> doing lots of function calls in a relatively performance sensitive
> loop just to run a single check when discard is not enabled...

Ok.  As you noticed it's done in the next patch, and they will probably
be merged into one before the final submission.  But for now I'll
move it to make the patch more obvious.

> > +	error = -blkdev_issue_discard(mp->m_ddev_targp->bt_bdev, bno, len,
> > +				      GFP_NOFS, 0);
> > +	if (error && error != EOPNOTSUPP)
> > +		xfs_info(mp, "discard failed, error %d", error);
> 
> This would be more informative if it also printed the bno and len of
> the discard that failed. A couple of tracepoints here (e.g.
> discard_extent_issued, discard_extent_failed) could also be useful
> for tracking discard operations.

Yeah, I was planning to add a lot more tracepoint later on, both
for the busy extent handling and discards.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
