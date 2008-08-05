Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Aug 2008 18:28:34 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m751ST9v023720
	for <xfs@oss.sgi.com>; Mon, 4 Aug 2008 18:28:29 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5222C12432CA
	for <xfs@oss.sgi.com>; Mon,  4 Aug 2008 18:29:44 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id puDLVgivkGY3NzNw for <xfs@oss.sgi.com>; Mon, 04 Aug 2008 18:29:44 -0700 (PDT)
Date: Mon, 4 Aug 2008 21:29:43 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 21/26] implement generic xfs_btree_in??ert/insrec
Message-ID: <20080805012943.GB22147@infradead.org>
References: <20080804013535.GV8819@lst.de> <20080805010557.GL6119@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080805010557.GL6119@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Tue, Aug 05, 2008 at 11:05:57AM +1000, Dave Chinner wrote:
> I think that ->get_dmaxrecs is probably badly named. I called it
> that originally because it matched the macro name it was wrapping.
> Realisitically it should be ->get_root_maxrecs....

Yeah.  The name giving macro is already gone in my current tree.

> 
> > +	/* Make a key out of the record data to be inserted, and save it. */
> > +	cur->bc_ops->init_key_from_rec(cur, &key, recp);
> > +
> > +	/* If we're off the left edge, return failure. */
> > +	ptr = cur->bc_ptrs[level];
> > +	if (ptr == 0) {
> > +		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
> > +		*stat = 0;
> > +		return 0;
> > +	}
> 
> You can probably move the key initialisation till after then initial
> 'in this block' checks.

Done.

> > +	/*
> > +	 * If the block is full, we can't insert the new entry until we
> > +	 * make the block un-full.
> > +	 */
> > +	xfs_btree_set_ptr_null(cur, &nptr);
> > +	if (numrecs == cur->bc_ops->get_maxrecs(cur, level)) {
> > +		error = xfs_btree_make_block_unfull(cur, level, numrecs,
> > +					&optr, &ptr, &nptr, &ncur, &nrec, stat);
> > +		if (error || *stat == 0)
> > +			goto error0;
> > +	}
> > +
> > +	/* The current block may have changed during the split. */
> > +	block = xfs_btree_get_block(cur, level, &bp);
> > +	numrecs = xfs_btree_get_numrecs(block);
> 
> The comment here should probably refer to the unfull call, not a
> 'split'. i.e.:
> 
> 	/*
> 	 * the current block may have changed if the block was
> 	 * previously full and we have just made space in it.
> 	 */

Updated.
