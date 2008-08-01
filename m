Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 01 Aug 2008 12:51:37 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m71JpZmo028078
	for <xfs@oss.sgi.com>; Fri, 1 Aug 2008 12:51:36 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DC4321969680
	for <xfs@oss.sgi.com>; Fri,  1 Aug 2008 12:52:47 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id 1CMxQ23uQF61qxEA for <xfs@oss.sgi.com>; Fri, 01 Aug 2008 12:52:47 -0700 (PDT)
Date: Fri, 1 Aug 2008 21:52:49 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 16/21] implement generic xfs_btree_lshift
Message-ID: <20080801195249.GJ1263@lst.de>
References: <20080729193132.GQ19104@lst.de> <20080730062422.GQ13395@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080730062422.GQ13395@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

> > +xfs_btree_copy_ptrs(
> > +	struct xfs_btree_cur	*cur,
> > +	union xfs_btree_ptr	*src_ptr,
> > +	union xfs_btree_ptr	*dst_ptr,
> > +	int			numptrs)
> > +{
> > +	ASSERT(numptrs > 0);
> > +
> > +	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
> > +		memcpy(dst_ptr, src_ptr, numptrs * sizeof(__be64));
> > +	else
> > +		memcpy(dst_ptr, src_ptr, numptrs * sizeof(__be32));
> > +}
> 
> These should really use memmove, not memcpy. There is no guarantee
> the source and destination do not overlap.
> 
> At minimum, we need comments to say this must only be used to
> copy between blocks, and xfs_btree_move_ptrs() must be used to
> copy within a block. I note the original patchset of mine
> commented on this distinction when defining the ->move_* and
> ->copy_* operations.
> 
> FWIW, that also helps explain why they have different interfaces...

There were some comments in the pre-walkthru cleanup version but they
were already lost in that patch.  But yes, adding some comments makes
sense.  Or moving back to single one that unlike your very first
version always passes src and dst pointers and always uses memmove.

> This can be moved inside the branch it is used in.

Done.

> Move the XFS_BTREE_STATS_ADD() above the comment to match the rshift
> code.

Done.
