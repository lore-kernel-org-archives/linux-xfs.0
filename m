Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:53685 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754424AbdLOANA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Dec 2017 19:13:00 -0500
Date: Thu, 14 Dec 2017 16:12:57 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 01/13] xfs: refactor long-format btree header
 verification routines
Message-ID: <20171215001257.GN13436@magnolia>
References: <151320949282.30654.14805160700975182459.stgit@magnolia>
 <151320949899.30654.10787297507975715065.stgit@magnolia>
 <20171214220613.GJ5858@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171214220613.GJ5858@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Dec 15, 2017 at 09:06:14AM +1100, Dave Chinner wrote:
> On Wed, Dec 13, 2017 at 03:58:19PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Create two helper functions to verify the headers of a long format
> > btree block.  We'll use this later for the realtime rmapbt.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> .....
> 
> > +bool
> > +xfs_btree_lblock_verify(
> > +	struct xfs_buf		*bp,
> > +	unsigned int		max_recs)
> > +{
> > +	struct xfs_mount	*mp = bp->b_target->bt_mount;
> > +	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
> > +
> > +	/* numrecs verification */
> > +	if (be16_to_cpu(block->bb_numrecs) > max_recs)
> > +		return false;
> > +
> > +	/* sibling pointer verification */
> > +	if (!block->bb_u.l.bb_leftsib ||
> > +	    (block->bb_u.l.bb_leftsib != cpu_to_be64(NULLFSBLOCK) &&
> > +	     !XFS_FSB_SANITY_CHECK(mp, be64_to_cpu(block->bb_u.l.bb_leftsib))))
> > +		return false;
> > +	if (!block->bb_u.l.bb_rightsib ||
> > +	    (block->bb_u.l.bb_rightsib != cpu_to_be64(NULLFSBLOCK) &&
> > +	     !XFS_FSB_SANITY_CHECK(mp, be64_to_cpu(block->bb_u.l.bb_rightsib))))
> 
> XFS_FSB_SANITY_CHECK() is the same thing as xfs_verify_fsbno(),
> right? Perhaps they should be converted at the same time so we can
> get rid of XFS_FSB_SANITY_CHECK()?

Oops, yes.  Fixed.

--D

> 
> Cheers,
> 
> Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
