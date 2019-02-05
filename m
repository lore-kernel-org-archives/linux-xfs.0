Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:60022 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726614AbfBEBC4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Feb 2019 20:02:56 -0500
Date: Mon, 4 Feb 2019 17:02:43 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 10/10] xfs: cache unlinked pointers in an rhashtable
Message-ID: <20190205010242.GG7991@magnolia>
References: <154930313674.31814.17994684613232167921.stgit@magnolia>
 <154930320519.31814.7868551876308474527.stgit@magnolia>
 <20190204210848.GI30334@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190204210848.GI30334@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Mon, Feb 04, 2019 at 01:08:48PM -0800, Christoph Hellwig wrote:
> > +int xfs_iunlink_init(struct xfs_perag *pag);
> > +void xfs_iunlink_destroy(struct xfs_perag *pag);
> > +xfs_agino_t xfs_iunlink_lookup_backref(struct xfs_perag *pag,
> > +		xfs_agino_t agino);
> > +int xfs_iunlink_add_backref(struct xfs_perag *pag, xfs_agino_t prev_agino,
> > +		xfs_agino_t this_agino);
> > +int xfs_iunlink_change_backref(struct xfs_perag *pag, xfs_agino_t prev_agino,
> > +		xfs_agino_t this_agino);
> 
> xfs_iunlink_lookup_backref and xfs_iunlink_change_backref aren't
> used outside of xfs_inode.c and should be marked static.

Fixed.

> > +	/*
> > +	 * Make sure the in-core data knows about this unlinked inode.  Since
> > +	 * our iunlinks recovery basically just deletes the head of a bucket
> > +	 * list until the bucket is empty, we need only to add the backref from
> > +	 * the current list item to the next one, if this isn't the list tail.
> > +	 */
> >  	pag = xfs_perag_get(mp, agno);
> >  	pag->pagi_unlinked_count++;
> > +	if (agino != NULLAGINO)
> > +		error = xfs_iunlink_add_backref(pag, XFS_INO_TO_AGINO(mp, ino),
> > +				agino);
> >  	xfs_perag_put(pag);
> > +	if (error)
> > +		goto fail_iput;
> 
> Note that the previos agino that we recaculate above is actually passed
> to the function as an argument.  I think we should just add a new
> next_agino variable for the one we read from the dinode and return and
> reuse the argument here instead of recaculating it.

Ok, I'll change the variable names.

> Question: what lock now protects the rhastable modifications?  Maybe
> we need to add some lockdep asserts to document that.

Callers are expected to hold the AGI buffer lock to serialize accesses
to the incore unlinked data.  That includes pagi_unlinked_count and
the new rhashtable.

--D
