Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p66FBpxp128958 for <xfs@oss.sgi.com>; Wed, 6 Jul 2011 10:11:51 -0500
Subject: Re: [PATCH 17/27] xfs: kill struct xfs_dir2_block
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110706083714.GE19861@infradead.org>
References: <20110701094321.936534538@bombadil.infradead.org>
	<20110701094605.827598983@bombadil.infradead.org>
	<20110706023157.GL1026@dastard> <20110706083714.GE19861@infradead.org>
Date: Wed, 6 Jul 2011 10:11:50 -0500
Message-ID: <1309965110.1931.44.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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

On Wed, 2011-07-06 at 04:37 -0400, Christoph Hellwig wrote:
> On Wed, Jul 06, 2011 at 12:31:57PM +1000, Dave Chinner wrote:
> > >  	btp = xfs_dir2_block_tail_p(mp, hdr);
> > > -	ptr = (char *)block->u;
> > > +	ptr = (char *)(hdr + 1);
> > >  	endptr = (char *)xfs_dir2_block_leaf_p(btp);
> > 
> > That is slightly less obvious what it is doing. It's jumping over
> > the entire header, but could easily be confused with jumping one
> > byte in.

I actually have become pretty accustomed to this
idiom and have a (small) preference for the way it
is here rather than using a new macro that does
the same thing.  Either way is fine with me though.

					-Alex

> > Perhaps adding a wrapper e.g. xfs_dir2_block_data_p(hdr) to match
> > the xfs_dir2_block_tail_p() and xfs_dir2_block_leaf_p() wrappers,
> > and converting all the other cases to use this as well?
> 
> I had that in the initial version, but given that we usually use
> the result as char, and not one of the two types of the union just
> made the code very messy.
> 
> I can try it again, maybe as a add-on patch at the end so that we can
> decide if it actually improves anything.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
