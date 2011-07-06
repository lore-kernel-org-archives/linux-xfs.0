Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p668bGZQ094307 for <xfs@oss.sgi.com>; Wed, 6 Jul 2011 03:37:16 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0014915B54D2
	for <xfs@oss.sgi.com>; Wed,  6 Jul 2011 01:37:15 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	mXswYsh5uCJ8RqIv for <xfs@oss.sgi.com>;
	Wed, 06 Jul 2011 01:37:15 -0700 (PDT)
Date: Wed, 6 Jul 2011 04:37:14 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 17/27] xfs: kill struct xfs_dir2_block
Message-ID: <20110706083714.GE19861@infradead.org>
References: <20110701094321.936534538@bombadil.infradead.org>
	<20110701094605.827598983@bombadil.infradead.org>
	<20110706023157.GL1026@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110706023157.GL1026@dastard>
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

On Wed, Jul 06, 2011 at 12:31:57PM +1000, Dave Chinner wrote:
> >  	btp = xfs_dir2_block_tail_p(mp, hdr);
> > -	ptr = (char *)block->u;
> > +	ptr = (char *)(hdr + 1);
> >  	endptr = (char *)xfs_dir2_block_leaf_p(btp);
> 
> That is slightly less obvious what it is doing. It's jumping over
> the entire header, but could easily be confused with jumping one
> byte in.
> 
> Perhaps adding a wrapper e.g. xfs_dir2_block_data_p(hdr) to match
> the xfs_dir2_block_tail_p() and xfs_dir2_block_leaf_p() wrappers,
> and converting all the other cases to use this as well?

I had that in the initial version, but given that we usually use
the result as char, and not one of the two types of the union just
made the code very messy.

I can try it again, maybe as a add-on patch at the end so that we can
decide if it actually improves anything.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
