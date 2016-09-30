Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50766 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932430AbcI3Rsw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Sep 2016 13:48:52 -0400
Date: Fri, 30 Sep 2016 10:48:25 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 29/63] xfs: introduce the CoW fork
Message-ID: <20160930174825.GO14092@birch.djwong.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520492856.29434.17061076591831860945.stgit@birch.djwong.org>
 <20160930073934.GA951@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160930073934.GA951@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Fri, Sep 30, 2016 at 12:39:34AM -0700, Christoph Hellwig wrote:
> > +/* XFS_IEXT_STATE_TO_FORK() -- Convert BMAP state flags to an inode fork. */
> > +xfs_ifork_t *
> > +XFS_IEXT_STATE_TO_FORK(
> > +	struct xfs_inode	*ip,
> > +	int			state)
> > +{
> > +	if (state & BMAP_COWFORK)
> > +		return ip->i_cowfp;
> > +	else if (state & BMAP_ATTRFORK)
> > +		return ip->i_afp;
> > +	return &ip->i_df;
> > +}
> 
> Would be nice to have a lower ase name for this.  And while we're at
> it drop duplicating the function name in the top of the function
> comment.

Ok, done.

--D

> 
> Othwerise looks fine:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
