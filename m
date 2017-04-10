Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:51997 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754099AbdDJRml (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Apr 2017 13:42:41 -0400
Date: Mon, 10 Apr 2017 19:42:34 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/6] xfs: pass individual arguments to
        xfs_bmap_add_extent_hole_real
Message-ID: <20170410174234.GB19106@lst.de>
References: <20170403121833.7825-1-hch@lst.de> <20170403121833.7825-4-hch@lst.de> <20170410171316.GV4864@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170410171316.GV4864@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Mon, Apr 10, 2017 at 10:13:16AM -0700, Darrick J. Wong wrote:
> > -	struct xfs_bmalloca	*bma,
> > -	int			whichfork)
> > +	struct xfs_trans	*tp,
> > +	xfs_inode_t		*ip,	/* incore inode pointer */
> > +	int			whichfork,
> > +	xfs_extnum_t		*idx,	/* extent number to update/insert */
> > +	xfs_btree_cur_t		**curp,	/* if *curp is null, not a btree */
> > +	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
> 
> struct xfs_inode vs. xfs_inode_t ?

Sure, I can fix this up.

> 
> I was under the impression that we don't add comments to the function
> arguments anymore, but TBH they don't bother me.

It's copy and paste from the other function in the family that
takes individual parameters.  I can remove it.
