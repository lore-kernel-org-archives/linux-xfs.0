Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:59099 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752749AbdKCH07 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 3 Nov 2017 03:26:59 -0400
Date: Fri, 3 Nov 2017 08:26:57 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 12/18] xfs: introduce the xfs_iext_cursor abstraction
Message-ID: <20171103072657.GA17606@lst.de>
References: <20171031142230.11755-1-hch@lst.de> <20171031142230.11755-13-hch@lst.de> <20171102171437.GH16645@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171102171437.GH16645@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

> > @@ -1553,8 +1558,6 @@ xfs_bmap_add_extent_delay_real(
> >  	nextents = (whichfork == XFS_COW_FORK ? &bma->ip->i_cnextents :
> >  						&bma->ip->i_d.di_nextents);

> > -	ASSERT(bma->idx >= 0);
> > -	ASSERT(bma->idx <= xfs_iext_count(ifp));
> 
> I think it might be useful to encapsulate this check (which is also part
> of xfs_iext_get_extent()) into a cursor validation helper so we can
> preserve these asserts (here and in the other bmap functions). E.g.,
> something like:
> 
> 	ASSERT(xfs_iext_valid(&bma->ext));

The bug problem here is that we don not check if it is valid, it just
is a plausability check.  bma->idx == xfs_iext_count(ifp) is not a
a valid index, but one beyond valid, a fact that the whole code
relies on.

But we do check for validity and plausability in the actual btree code,
so I don't think the additional checks here add much value.

> > - * Return true if there is an extent at index idx, and return the expanded
> > - * extent structure at idx in that case.  Else return false.
> > + * Return true if there is an extent at cursor cur and return the expanded
> > + * extent structure at cur in gotp in that case.  Else return false.
> 
> "Return true if the cursor points at an extent and return the extent
> structure in gotp. Else return false."

Fixed.

> >  bool		xfs_iext_lookup_extent(struct xfs_inode *ip,
> >  			struct xfs_ifork *ifp, xfs_fileoff_t bno,
> > -			xfs_extnum_t *idxp, struct xfs_bmbt_irec *gotp);
> > +			struct xfs_iext_cursor *cur,
> > +			 struct xfs_bmbt_irec *gotp);
> 
> Indentation looks off here.

Fixed.

