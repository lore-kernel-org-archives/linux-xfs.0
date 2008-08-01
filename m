Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 01 Aug 2008 12:48:01 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m71JlxZH027520
	for <xfs@oss.sgi.com>; Fri, 1 Aug 2008 12:48:00 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 35F471623F45
	for <xfs@oss.sgi.com>; Fri,  1 Aug 2008 12:49:12 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id A2VJIBGzgXV6IG3Q for <xfs@oss.sgi.com>; Fri, 01 Aug 2008 12:49:12 -0700 (PDT)
Date: Fri, 1 Aug 2008 21:49:14 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 15/21] implement generic xfs_btree_rshift
Message-ID: <20080801194914.GI1263@lst.de>
References: <20080729193125.GP19104@lst.de> <20080730060808.GP13395@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080730060808.GP13395@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

> > +{
> > +	ASSERT(from >= 0 && from <= 1000);
> > +	ASSERT(to >= 0 && to <= 1000);
> > +	ASSERT(numptrs >= 0);
> 
> Those numbers are not safe. I plucked them out of thin air to verify
> validity on 4k block size filesystem which had (IIRC) a max of about
> 500 ptrs to a block. It was throwaway debug code to find a problem.
> Larger block sizes can well exceed 1000. So realistically, the only
> valid assert there is this one:
> 
> 	ASSERT(numptrs >= 0);

Yeah, I've actually managed to trigger it now.  The >=0 checks
for from and to still make sense, although they might be overkill.

> How about:
> 
> 		union xfs_btree_ptr	*pp;
> 		xfs_caddr_t		*block = XFS_BUF_TO_BLOCK(bp);
> 		xfs_caddr_t		start;	/* first byte offset logged */
> 		xfs_caddr_t		end;	/* last byte offset logged */
> 
> 		pp = cur->bc_ops->ptr_addr(cur, 1, XFS_BUF_TO_BLOCK(bp));
> 
> 		if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
> 			__be64		*lpp = &pp->l;
> 
> 			start = (xfs_caddr_t)&lpp[first - 1] - block;
> 			end  = ((xfs_caddr_t)&lpp[last] - 1) - block;
> 		} else {
> 			__be32		*spp = &pp->s;
> 
> 			start = (xfs_caddr_t)&spp[first - 1] - block;
> 			end  = ((xfs_caddr_t)&spp[last] - 1) - block;
> 		}
> 
> 		xfs_trans_log_buf(cur->bc_tp, bp, (int)start, (int)end);
> 
> That makes it much easier to read (to me, anyway).

Yes, absolutely.  And there's also another set of useless braces.
I've also applied a similar cleanup to the log_keys and log_recs
implementations.

> > +	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
> > +	XFS_BTREE_TRACE_ARGBI(cur, bp, fields);
> > +
> > +	if (bp) {
> > +		xfs_btree_offsets(fields,
> > +				  (cur->bc_flags & XFS_BTREE_LONG_PTRS) ?
> > +				  	loffsets : soffsets,
>                                 ^^
> Some stray whitespace there.

Fixed.

> > +				  XFS_BB_NUM_BITS, &first, &last);
> > +		xfs_trans_log_buf(cur->bc_tp, bp, first, last);
> > +	} else {
> > +		/* XXX(hch): maybe factor out into a method? */
> > +		xfs_trans_log_inode(cur->bc_tp, cur->bc_private.b.ip,
> > +			XFS_ILOG_FBROOT(cur->bc_private.b.whichfork));
> 
> I don't think it is necessary at this point.

It's the only leakage of the detailed inode root implementation into
the generic code, so I'm still wondering whether a method would be
better.
