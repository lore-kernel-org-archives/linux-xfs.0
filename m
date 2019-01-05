Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:38602 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbfAEA3X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Jan 2019 19:29:23 -0500
Date: Fri, 4 Jan 2019 16:29:16 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 6/8] xfs: scrub big block inode btrees correctly
Message-ID: <20190105002916.GG12689@magnolia>
References: <154630850739.14372.14000129432637481206.stgit@magnolia>
 <154630855085.14372.11366121347834353110.stgit@magnolia>
 <20190104183856.GH16751@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190104183856.GH16751@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jan 04, 2019 at 01:38:56PM -0500, Brian Foster wrote:
> On Mon, Dec 31, 2018 at 06:09:10PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Teach scrub how to handle the case that there are one or more inobt
> > records covering a given inode cluster.  This fixes the operation on big
> > block filesystems (e.g. 64k blocks, 512 byte inodes).
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/scrub/ialloc.c |    8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
> > index 2f6c2d7fa3fd..1be6a5ebd61e 100644
> > --- a/fs/xfs/scrub/ialloc.c
> > +++ b/fs/xfs/scrub/ialloc.c
> > @@ -162,6 +162,7 @@ xchk_iallocbt_check_cluster_ifree(
> >  	xfs_ino_t			fsino;
> >  	xfs_agino_t			agino;
> >  	unsigned int			offset;
> > +	unsigned int			cluster_buf_base;
> >  	bool				irec_free;
> >  	bool				ino_inuse;
> >  	bool				freemask_ok;
> > @@ -174,11 +175,14 @@ xchk_iallocbt_check_cluster_ifree(
> >  	 * Given an inobt record, an offset of a cluster within the record,
> >  	 * and an offset of an inode within a cluster, compute which fs inode
> >  	 * we're talking about and the offset of the inode record within the
> > -	 * inode buffer.
> > +	 * inode buffer, being careful about inobt records that don't align
> > +	 * with the start of the inode buffer when block sizes are large.
> >  	 */
> >  	agino = irec->ir_startino + cluster_base + cluster_index;
> >  	fsino = XFS_AGINO_TO_INO(mp, bs->cur->bc_private.a.agno, agino);
> > -	offset = cluster_index * mp->m_sb.sb_inodesize;
> > +	cluster_buf_base = XFS_INO_TO_OFFSET(mp, irec->ir_startino +
> > +					     cluster_base);
> > +	offset = (cluster_buf_base + cluster_index) * mp->m_sb.sb_inodesize;
> 
> So cluster_buf_base should always be 0 unless the record itself is not
> cluster aligned (i.e., the second record in a large FSB), right?

Right.  For the (n > 0)th inobt record for a large FSB, ir_startino's
block offset will be less than inopblock, so cluster_buf_base will be
greater than zero.

> If so, cluster_base should also be 0 in any case where
> cluster_buf_base != 0.  I'm wondering if that can be made a little
> more explicit, or perhaps self-documented with an assert.

Right.  For the more typical case where there are multiple clusters for
each inobt record, ir_startino's block offset will always point to the
start of an inode cluster (and therefore cluster_buf_base will be zero)
but cluster_base will increment as we visit each cluster in the inobt.

I think this code can become:

	cluster_buf_base = XFS_INO_TO_OFFSET(mp, irec->ir_startino);
	ASSERT(cluster_buf_base == 0 || cluster_base == 0);
	offset = (cluster_buf_base + cluster_index) << mp->m_sb.sb_inopblog;

But I'll go feed that to the test machines before I commit to that. :)

> Thinking more about it, it's kind of confusing to me either way because
> cluster_index isn't really a cluster index in this case, rather it's
> more of a record index because it doesn't account for the fact that the
> record is a subset of the cluster. Hmmm... could we simplify this by
> setting imap.im_boffset appropriately in the caller such that dip always
> points to either the first inode in the buffer or first inode in the
> record, then just pass in dip directly and let the caller increment it
> in the associated loop? Maybe that's something for another patch..

I think that would be possible...

--D

> Brian
> 
> >  	if (offset >= BBTOB(cluster_bp->b_length)) {
> >  		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
> >  		goto out;
> > 
