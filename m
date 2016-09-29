Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26000 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934107AbcI2VSb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 17:18:31 -0400
Date: Thu, 29 Sep 2016 14:18:23 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 08/63] xfs: account for the refcount btree in the
 alloc/free log reservation
Message-ID: <20160929211823.GH14092@birch.djwong.org>
References: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
 <147503126083.30303.8391218762410608178.stgit@birch.djwong.org>
 <20160928162005.GC8852@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160928162005.GC8852@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Wed, Sep 28, 2016 at 12:20:05PM -0400, Brian Foster wrote:
> On Tue, Sep 27, 2016 at 07:54:20PM -0700, Darrick J. Wong wrote:
> > Every time we allocate or free an extent, we might need to split the
> > refcount btree.  Reserve some blocks in the transaction to handle
> > this possibility.
> > 
> 
> I'm probably not far along enough to grok how this all works, but I'm a
> bit confused by the requirement here. Why is generic block
> allocation/free a refcountbt matter? E.g., the function below is used
> for things like inode chunk allocation and whatnot, aren't those
> irrelevant to the refcountbt?

Overnight tests seem to run ok, so I'll remove this patch.  If it
becomes a problem we can always put it back in.

--D

> 
> Brian
> 
> > (Reproduced by generic/167 over NFS atop XFS)
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > [darrick.wong@oracle.com: add commit message]
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_trans_resv.c |    5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> > index 7c840e1..a59838f 100644
> > --- a/fs/xfs/libxfs/xfs_trans_resv.c
> > +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> > @@ -67,7 +67,8 @@ xfs_calc_buf_res(
> >   * Per-extent log reservation for the btree changes involved in freeing or
> >   * allocating an extent.  In classic XFS there were two trees that will be
> >   * modified (bnobt + cntbt).  With rmap enabled, there are three trees
> > - * (rmapbt).  The number of blocks reserved is based on the formula:
> > + * (rmapbt).  With reflink, there are four trees (refcountbt).  The number of
> > + * blocks reserved is based on the formula:
> >   *
> >   * num trees * ((2 blocks/level * max depth) - 1)
> >   *
> > @@ -83,6 +84,8 @@ xfs_allocfree_log_count(
> >  	blocks = num_ops * 2 * (2 * mp->m_ag_maxlevels - 1);
> >  	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
> >  		blocks += num_ops * (2 * mp->m_rmap_maxlevels - 1);
> > +	if (xfs_sb_version_hasreflink(&mp->m_sb))
> > +		blocks += num_ops * (2 * mp->m_refc_maxlevels - 1);
> >  
> >  	return blocks;
> >  }
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
