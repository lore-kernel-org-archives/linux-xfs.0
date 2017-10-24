Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31609 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751412AbdJXRAW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Oct 2017 13:00:22 -0400
Date: Tue, 24 Oct 2017 10:00:13 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: abort extended attribute list operation if btree is
 obviously weird
Message-ID: <20171024170013.GN5483@magnolia>
References: <20171024002824.GL5483@magnolia>
 <20171024125336.GB56184@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171024125336.GB56184@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Tue, Oct 24, 2017 at 08:53:36AM -0400, Brian Foster wrote:
> On Mon, Oct 23, 2017 at 05:28:24PM -0700, Darrick J. Wong wrote:
> > Abort an attribute list operation if the attr btree has obvious problems
> > like loops back to the root or pointers don't point down the tree.
> > Found by fuzzing btree[0].before to zero in xfs/402.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_attr_list.c |   54 ++++++++++++++++++++++++++++++++++++++----------
> >  1 file changed, 43 insertions(+), 11 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> > index 5816786..9f6fcc6 100644
> > --- a/fs/xfs/xfs_attr_list.c
> > +++ b/fs/xfs/xfs_attr_list.c
> ...
> > @@ -302,6 +306,30 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
> >  			}
> >  
> >  			dp->d_ops->node_hdr_from_disk(&nodehdr, node);
> > +
> > +			/* Tree taller than we can handle; bail out! */
> > +			if (nodehdr.level >= XFS_DA_NODE_MAXDEPTH) {
> > +				xfs_trans_brelse(context->tp, bp);
> > +				return -EFSCORRUPTED;
> > +			}
> > +
> > +			if (cursor->blkno == 0) {
> > +				/*
> > +				 * This is the root node, set up for the
> > +				 * next level we want to see.
> > +				 */
> > +				expected_level = nodehdr.level - 1;
> > +			} else if (expected_level != nodehdr.level) {
> > +				/*
> > +				 * Not the level we were expecting, which
> > +				 * implies that the tree is bad.
> > +				 */
> > +				xfs_trans_brelse(context->tp, bp);
> > +				return -EFSCORRUPTED;
> > +			} else {
> > +				expected_level--;
> > +			}
> > +
> 
> It looks like we wouldn't catch the case of a two level tree having a
> bad level, since we'd break out on leaf magic check above. Perhaps we
> should check or assert that expected_level reaches 0? Otherwise looks Ok
> to me.

Ok, will do.

--D

> 
> Brian
> 
> >  			btree = dp->d_ops->node_tree_p(node);
> >  			for (i = 0; i < nodehdr.count; btree++, i++) {
> >  				if (cursor->hashval
> > @@ -317,6 +345,10 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
> >  				return 0;
> >  			}
> >  			xfs_trans_brelse(context->tp, bp);
> > +
> > +			/* We can't point back to the root. */
> > +			if (cursor->blkno == 0)
> > +				return -EFSCORRUPTED;
> >  		}
> >  	}
> >  	ASSERT(bp != NULL);
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
