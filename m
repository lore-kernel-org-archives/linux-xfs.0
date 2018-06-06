Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:39424 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751035AbeFFE6o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Jun 2018 00:58:44 -0400
Date: Tue, 5 Jun 2018 21:58:40 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 04/14] xfs: repair inode btrees
Message-ID: <20180606045840.GW9437@magnolia>
References: <152770863951.11611.5866814627357136911.stgit@magnolia>
 <152770866495.11611.1193477717645761767.stgit@magnolia>
 <20180604034130.GM10363@dastard>
 <20180606035528.GT9437@magnolia>
 <20180606043246.GP10363@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180606043246.GP10363@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Jun 06, 2018 at 02:32:46PM +1000, Dave Chinner wrote:
> On Tue, Jun 05, 2018 at 08:55:28PM -0700, Darrick J. Wong wrote:
> > On Mon, Jun 04, 2018 at 01:41:30PM +1000, Dave Chinner wrote:
> > > On Wed, May 30, 2018 at 12:31:04PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > Use the rmapbt to find inode chunks, query the chunks to compute
> > > > hole and free masks, and with that information rebuild the inobt
> > > > and finobt.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > [...]
> > > 
> > > > +xfs_repair_ialloc_check_free(
> > > > +	struct xfs_btree_cur	*cur,
> > > > +	struct xfs_buf		*bp,
> > > > +	xfs_ino_t		fsino,
> > > > +	xfs_agino_t		bpino,
> > > > +	bool			*inuse)
> > > > +{
> > > > +	struct xfs_mount	*mp = cur->bc_mp;
> > > > +	struct xfs_dinode	*dip;
> > > > +	int			error;
> > > > +
> > > > +	/* Will the in-core inode tell us if it's in use? */
> > > > +	error = xfs_icache_inode_is_allocated(mp, cur->bc_tp, fsino, inuse);
> > > > +	if (!error)
> > > > +		return 0;
> > > > +
> > > > +	/* Inode uncached or half assembled, read disk buffer */
> > > > +	dip = xfs_buf_offset(bp, bpino * mp->m_sb.sb_inodesize);
> > > > +	if (be16_to_cpu(dip->di_magic) != XFS_DINODE_MAGIC)
> > > > +		return -EFSCORRUPTED;
> > > 
> > > Do we hold the buffer locked here? i.e. can we race with someone
> > > else allocating/freeing/reading the inode?
> > 
> > I think repair should be ok from alloc/free because both of those paths
> > (xfs_dialloc/xfs_difree) will grab the AGI header, whereas repair locks
> > all three AG headers and keeps them locked until repairs are complete.
> > I don't think we have to worry about concurrent reads because the only
> > field we care about are di_mode/i_mode, which don't change outside of
> > inode allocation and freeing.
> 
> Comment please :P
> 
> And, to be technically correct - di_mode/i_mode can change outside
> of alloc/free. However, only the permission bits can change so it
> doesn't affect the test we are doing here.

Done.

> > > > +		/* The per-AG inum of this inode cluster. */
> > > > +		agino = XFS_OFFBNO_TO_AGINO(mp, agbno, 0);
> > > > +
> > > > +		/* The per-AG inum of the inobt record. */
> > > > +		startino = rmino +
> > > > +				rounddown(agino - rmino, XFS_INODES_PER_CHUNK);
> > > > +		cdist = agino - startino;
> > > 
> > > What's "cdist" mean? I can guess at it's meaning, but I don't recall
> > > seeing the inode number offset into a cluster been refered to as a
> > > distanced before....
> > 
> > cluster offset?
> >
> > I wasn't sure of the terminology for the offset of the cluster within a
> > chunk, in units of ag inodes.
> 
> I'm not sure we have one. :/
> 
> But, yeah, going by the definition of inode offset from
> XFS_INO_TO_OFFSET() and XFS_AGINO_TO_OFFSET() - "offset" is the
> inode number index from the start of the block - cluster offset is
> probably the best name for it.

Yeah, that's what I picked.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
