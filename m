Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:57475 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750759AbdFCHNI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 3 Jun 2017 03:13:08 -0400
Date: Sat, 3 Jun 2017 09:13:07 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: transaction reservations for deleting of shared extents
Message-ID: <20170603071307.GA8523@lst.de>
References: <20170220072945.GA17608@lst.de> <20170221014356.GA5844@birch.djwong.org> <20170412135231.GA3891@lst.de> <20170412230612.GS8502@birch.djwong.org> <20170413035250.GT8502@birch.djwong.org> <20170413121325.GA31322@lst.de> <20170425020906.GU23371@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170425020906.GU23371@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

While looking at stable updates it seems like we didn't make
it anywhere with this series.  Are you planning to do further work
or should I pick it up?

On Mon, Apr 24, 2017 at 07:09:06PM -0700, Darrick J. Wong wrote:
> On Thu, Apr 13, 2017 at 02:13:25PM +0200, Christoph Hellwig wrote:
> > On Wed, Apr 12, 2017 at 08:52:50PM -0700, Darrick J. Wong wrote:
> > > Hmm... can you try out the attached RFC(RAP) xfstests testcase to see if
> > > it can reproduce the problem you're seeing, and then apply the (equally
> > > RFCRAP) patch to see if it fixes the problem?
> > 
> > Yeah. limiting at the caller seems much better than second guessing
> > later.  Below is a version of your patch with a couple random edits.
> > I wonder if we could now get rid of xfs_refcount_still_have_space
> > or at least turn it into warnings only..
> 
> We also have to plumb in the code necessary to recover a block unmap log
> intent item of arbitrary length by splitting the unmap operation into a
> series of __xfs_bunmapi calls.  That seems to fix the asserts and other
> weird log burps... will send an RFC patch shortly.
> 
> --D
> 
> > 
> > ---
> > From 9b25b1bdba8fb93650710444a6bab7b10f74680d Mon Sep 17 00:00:00 2001
> > From: "Darrick J. Wong" <darrick.wong@oracle.com>
> > Date: Thu, 13 Apr 2017 13:35:00 +0200
> > Subject: xfs: try to avoid blowing out the transaction reservation when
> >  bunmaping a shared extent
> > 
> > In a pathological scenario where we are trying to bunmapi a single
> > extent in which every other block is shared, it's possible that trying
> > to unmap the entire large extent in a single transaction can generate so
> > many EFIs that we overflow the transaction reservation.
> > 
> > Therefore, use a heuristic to guess at the number of blocks we can
> > safely unmap from a reflink file's data fork in an single transaction.
> > This should prevent problems such as the log head slamming into the tail
> > and ASSERTs that trigger because we've exceeded the transaction
> > reservation.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@djwong.org>
> > [hch: random edits, all bugs are my fault]
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/libxfs/xfs_bmap.c     | 23 ++++++++++++++++++++++-
> >  fs/xfs/libxfs/xfs_refcount.c | 10 +---------
> >  fs/xfs/libxfs/xfs_refcount.h | 16 ++++++++++++++++
> >  3 files changed, 39 insertions(+), 10 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index 8e94030bcb8f..04dac8954425 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -5442,6 +5442,7 @@ __xfs_bunmapi(
> >  	int			whichfork;	/* data or attribute fork */
> >  	xfs_fsblock_t		sum;
> >  	xfs_filblks_t		len = *rlen;	/* length to unmap in file */
> > +	xfs_fileoff_t		max_len;
> >  
> >  	trace_xfs_bunmap(ip, bno, len, flags, _RET_IP_);
> >  
> > @@ -5463,6 +5464,16 @@ __xfs_bunmapi(
> >  	ASSERT(len > 0);
> >  	ASSERT(nexts >= 0);
> >  
> > +	/*
> > +	 * Guesstimate how many blocks we can unmap without running the risk of
> > +	 * blowing out the transaction with a mix of EFIs and reflink
> > +	 * adjustments.
> > +	 */
> > +	if (xfs_is_reflink_inode(ip) && whichfork == XFS_DATA_FORK)
> > +		max_len = min(len, xfs_refcount_max_unmap(tp->t_log_res));
> > +	else
> > +		max_len = len;
> > +
> >  	if (!(ifp->if_flags & XFS_IFEXTENTS) &&
> >  	    (error = xfs_iread_extents(tp, ip, whichfork)))
> >  		return error;
> > @@ -5507,7 +5518,7 @@ __xfs_bunmapi(
> >  
> >  	extno = 0;
> >  	while (bno != (xfs_fileoff_t)-1 && bno >= start && lastx >= 0 &&
> > -	       (nexts == 0 || extno < nexts)) {
> > +	       (nexts == 0 || extno < nexts) && max_len > 0) {
> >  		/*
> >  		 * Is the found extent after a hole in which bno lives?
> >  		 * Just back up to the previous extent, if so.
> > @@ -5539,6 +5550,15 @@ __xfs_bunmapi(
> >  		}
> >  		if (del.br_startoff + del.br_blockcount > bno + 1)
> >  			del.br_blockcount = bno + 1 - del.br_startoff;
> > +
> > +		/* How much can we safely unmap? */
> > +		if (max_len < del.br_blockcount) {
> > +			del.br_startoff += del.br_blockcount - max_len;
> > +			if (!wasdel)
> > +				del.br_startblock += del.br_blockcount - max_len;
> > +			del.br_blockcount = max_len;
> > +		}
> > +
> >  		sum = del.br_startblock + del.br_blockcount;
> >  		if (isrt &&
> >  		    (mod = do_mod(sum, mp->m_sb.sb_rextsize))) {
> > @@ -5715,6 +5735,7 @@ __xfs_bunmapi(
> >  		if (!isrt && wasdel)
> >  			xfs_mod_fdblocks(mp, (int64_t)del.br_blockcount, false);
> >  
> > +		max_len -= del.br_blockcount;
> >  		bno = del.br_startoff - 1;
> >  nodelete:
> >  		/*
> > diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> > index b177ef33cd4c..29dcde381505 100644
> > --- a/fs/xfs/libxfs/xfs_refcount.c
> > +++ b/fs/xfs/libxfs/xfs_refcount.c
> > @@ -784,14 +784,6 @@ xfs_refcount_merge_extents(
> >  }
> >  
> >  /*
> > - * While we're adjusting the refcounts records of an extent, we have
> > - * to keep an eye on the number of extents we're dirtying -- run too
> > - * many in a single transaction and we'll exceed the transaction's
> > - * reservation and crash the fs.  Each record adds 12 bytes to the
> > - * log (plus any key updates) so we'll conservatively assume 24 bytes
> > - * per record.  We must also leave space for btree splits on both ends
> > - * of the range and space for the CUD and a new CUI.
> > - *
> >   * XXX: This is a pretty hand-wavy estimate.  The penalty for guessing
> >   * true incorrectly is a shutdown FS; the penalty for guessing false
> >   * incorrectly is more transaction rolls than might be necessary.
> > @@ -822,7 +814,7 @@ xfs_refcount_still_have_space(
> >  	else if (overhead > cur->bc_tp->t_log_res)
> >  		return false;
> >  	return  cur->bc_tp->t_log_res - overhead >
> > -		cur->bc_private.a.priv.refc.nr_ops * 32;
> > +		cur->bc_private.a.priv.refc.nr_ops * XFS_REFCOUNT_ITEM_OVERHEAD;
> >  }
> >  
> >  /*
> > diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
> > index 098dc668ab2c..eafb9d1f3b37 100644
> > --- a/fs/xfs/libxfs/xfs_refcount.h
> > +++ b/fs/xfs/libxfs/xfs_refcount.h
> > @@ -67,4 +67,20 @@ extern int xfs_refcount_free_cow_extent(struct xfs_mount *mp,
> >  extern int xfs_refcount_recover_cow_leftovers(struct xfs_mount *mp,
> >  		xfs_agnumber_t agno);
> >  
> > +/*
> > + * While we're adjusting the refcounts records of an extent, we have
> > + * to keep an eye on the number of extents we're dirtying -- run too
> > + * many in a single transaction and we'll exceed the transaction's
> > + * reservation and crash the fs.  Each record adds 12 bytes to the
> > + * log (plus any key updates) so we'll conservatively assume 32 bytes
> > + * per record.  We must also leave space for btree splits on both ends
> > + * of the range and space for the CUD and a new CUI.
> > + */
> > +#define XFS_REFCOUNT_ITEM_OVERHEAD	32
> > +
> > +static inline xfs_fileoff_t xfs_refcount_max_unmap(int log_res)
> > +{
> > +	return (log_res * 3 / 4) / XFS_REFCOUNT_ITEM_OVERHEAD;
> > +}
> > +
> >  #endif	/* __XFS_REFCOUNT_H__ */
> > -- 
> > 2.11.0
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
