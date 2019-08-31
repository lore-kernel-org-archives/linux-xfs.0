Return-Path: <SRS0=0uIH=W3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91A07C3A59B
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Aug 2019 01:00:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60B6023431
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Aug 2019 01:00:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728251AbfHaBAj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 21:00:39 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:41389 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727708AbfHaBAi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 21:00:38 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 349C543D47C;
        Sat, 31 Aug 2019 11:00:35 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i3rkn-0002u8-D9; Sat, 31 Aug 2019 11:00:33 +1000
Date:   Sat, 31 Aug 2019 11:00:33 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: factor data block addition from
 xfs_dir2_node_addname_int()
Message-ID: <20190831010033.GQ1119@dread.disaster.area>
References: <20190829104710.28239-1-david@fromorbit.com>
 <20190829104710.28239-3-david@fromorbit.com>
 <20190829210224.GJ5354@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829210224.GJ5354@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=JkGj8qbl2v7pUztNvXkA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 29, 2019 at 02:02:25PM -0700, Darrick J. Wong wrote:
> On Thu, Aug 29, 2019 at 08:47:07PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Factor out the code that adds a data block to a directory from
> > xfs_dir2_node_addname_int(). This makes the code flow cleaner and
> > more obvious and provides clear isolation of upcoming optimsations.
> > 
> > Signed-off-By: Dave Chinner <dchinner@redhat.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/libxfs/xfs_dir2_node.c | 324 +++++++++++++++++-----------------
> >  1 file changed, 158 insertions(+), 166 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> > index e40986cc0759..cc1f1c505a2b 100644
> > --- a/fs/xfs/libxfs/xfs_dir2_node.c
> > +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> > @@ -1608,6 +1608,129 @@ xfs_dir2_leafn_unbalance(
> >  	xfs_dir3_leaf_check(dp, drop_blk->bp);
> >  }
> >  
> > +/*
> > + * Add a new data block to the directory at the free space index that the caller
> > + * has specified.
> > + */
> > +static int
> > +xfs_dir2_node_add_datablk(
> > +	struct xfs_da_args	*args,
> > +	struct xfs_da_state_blk	*fblk,
> > +	xfs_dir2_db_t		*dbno,
> > +	struct xfs_buf		**dbpp,
> > +	struct xfs_buf		**fbpp,
> > +	int			*findex)
> > +{
> > +	struct xfs_inode	*dp = args->dp;
> > +	struct xfs_trans	*tp = args->trans;
> > +	struct xfs_mount	*mp = dp->i_mount;
> > +	struct xfs_dir3_icfree_hdr freehdr;
> > +	struct xfs_dir2_data_free *bf;
> > +	struct xfs_dir2_data_hdr *hdr;
> > +	struct xfs_dir2_free	*free = NULL;
> > +	xfs_dir2_db_t		fbno;
> > +	struct xfs_buf		*fbp;
> > +	struct xfs_buf		*dbp;
> > +	__be16			*bests = NULL;
> > +	int			error;
> > +
> > +	/* Not allowed to allocate, return failure. */
> > +	if ((args->op_flags & XFS_DA_OP_JUSTCHECK) || args->total == 0)
> > +		return -ENOSPC;
> > +
> > +	/* Allocate and initialize the new data block.  */
> > +	error = xfs_dir2_grow_inode(args, XFS_DIR2_DATA_SPACE, dbno);
> > +	if (error)
> > +		return error;
> > +	error = xfs_dir3_data_init(args, *dbno, &dbp);
> > +	if (error)
> > +		return error;
> > +
> > +	/*
> > +	 * Get the freespace block corresponding to the data block
> > +	 * that was just allocated.
> > +	 */
> > +	fbno = dp->d_ops->db_to_fdb(args->geo, *dbno);
> > +	error = xfs_dir2_free_try_read(tp, dp,
> > +			       xfs_dir2_db_to_da(args->geo, fbno), &fbp);
> > +	if (error)
> > +		return error;
> > +
> > +	/*
> > +	 * If there wasn't a freespace block, the read will
> > +	 * return a NULL fbp.  Allocate and initialize a new one.
> > +	 */
> > +	if (!fbp) {
> > +		error = xfs_dir2_grow_inode(args, XFS_DIR2_FREE_SPACE, &fbno);
> > +		if (error)
> > +			return error;
> > +
> > +		if (dp->d_ops->db_to_fdb(args->geo, *dbno) != fbno) {
> 
> As a straight "cut this huge function into smaller pieces, no functional
> changes" patch I guess this is fine, but ... when can this happen?

No idea. We're growing the free space segment, and it's checking
that we allocated a new block over the free block index for the
data segment block we just allocated. It's a sanity check more than
anything, I think, because if we have a hole in the free block index
for a give data block bad things are going to happen later...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
