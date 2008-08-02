Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 01 Aug 2008 18:26:59 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m721QrVa024081
	for <xfs@oss.sgi.com>; Fri, 1 Aug 2008 18:26:54 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BC3CFEF0C88
	for <xfs@oss.sgi.com>; Fri,  1 Aug 2008 18:28:06 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id WbR3G9u1mV6l9rsl for <xfs@oss.sgi.com>; Fri, 01 Aug 2008 18:28:06 -0700 (PDT)
Date: Sat, 2 Aug 2008 11:28:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 16/21] implement generic xfs_btree_lshift
Message-ID: <20080802012803.GO6201@disturbed>
References: <20080729193132.GQ19104@lst.de> <20080730062422.GQ13395@disturbed> <20080801195249.GJ1263@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080801195249.GJ1263@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Fri, Aug 01, 2008 at 09:52:49PM +0200, Christoph Hellwig wrote:
> > > +xfs_btree_copy_ptrs(
> > > +	struct xfs_btree_cur	*cur,
> > > +	union xfs_btree_ptr	*src_ptr,
> > > +	union xfs_btree_ptr	*dst_ptr,
> > > +	int			numptrs)
> > > +{
> > > +	ASSERT(numptrs > 0);
> > > +
> > > +	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
> > > +		memcpy(dst_ptr, src_ptr, numptrs * sizeof(__be64));
> > > +	else
> > > +		memcpy(dst_ptr, src_ptr, numptrs * sizeof(__be32));
> > > +}
> > 
> > These should really use memmove, not memcpy. There is no guarantee
> > the source and destination do not overlap.
> > 
> > At minimum, we need comments to say this must only be used to
> > copy between blocks, and xfs_btree_move_ptrs() must be used to
> > copy within a block. I note the original patchset of mine
> > commented on this distinction when defining the ->move_* and
> > ->copy_* operations.
> > 
> > FWIW, that also helps explain why they have different interfaces...
> 
> There were some comments in the pre-walkthru cleanup version but they
> were already lost in that patch.  But yes, adding some comments makes
> sense.  Or moving back to single one that unlike your very first
> version always passes src and dst pointers and always uses memmove.

It might make sense to go back to a single implementation,
though at the time I did it it made sense to split the move/copy
operations because it made both cases simpler. Seeing as you've
stuck more closely to the original structure of the code, the
distinction is not as great as so it might be best to go back to a
single memmove based interface.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
