Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56674 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1032414AbdADUsj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 4 Jan 2017 15:48:39 -0500
Date: Wed, 4 Jan 2017 15:48:38 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH, RFC] xfs: use per-AG reservations for the finobt
Message-ID: <20170104204837.GF41989@bfoster.bfoster>
References: <1483107598-6779-1-git-send-email-hch@lst.de>
 <20170103192426.GA14031@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170103192426.GA14031@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Tue, Jan 03, 2017 at 11:24:26AM -0800, Darrick J. Wong wrote:
> On Fri, Dec 30, 2016 at 03:19:58PM +0100, Christoph Hellwig wrote:
> > Currently we try to rely on the global reserved block pool for block
> > allocations for the free inode btree, but I have customer reports
> > (fairly complex workload, need to find an easier reproducer) where that
> > is not enough as the AG where we free an inode that requires a new
> > finobt block is entirely full.  This causes us to cancel a dirty
> > transaction and thus a file system shutdown.
> > 
> > I think the right way to guard against this is to treat the finot the same
> > way as the refcount btree and have a per-AG reservations for the possible
> > worst case size of it, and the patch below implements that.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/libxfs/xfs_ag_resv.c      |  6 +++
> >  fs/xfs/libxfs/xfs_ialloc.h       |  1 -
> >  fs/xfs/libxfs/xfs_ialloc_btree.c | 96 ++++++++++++++++++++++++++++++++++++++--
> >  fs/xfs/libxfs/xfs_ialloc_btree.h |  3 ++
> >  fs/xfs/libxfs/xfs_trans_space.h  |  3 --
> >  fs/xfs/xfs_inode.c               | 25 ++---------
> >  6 files changed, 105 insertions(+), 29 deletions(-)
> > 
...
> > diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> > index 0fd086d..3aba153 100644
> > --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> > +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
...
> > @@ -480,3 +503,70 @@ xfs_inobt_rec_check_count(
...
> > +static int
> > +xfs_inobt_count_blocks(
> > +	struct xfs_mount	*mp,
> > +	xfs_agnumber_t		agno,
> > +	xfs_btnum_t		btnum,
> > +	xfs_extlen_t		*tree_blocks)
> > +{
> > +	struct xfs_buf		*agbp;
> > +	struct xfs_btree_cur	*cur;
> > +	int			error;
> > +
> > +	error = xfs_ialloc_read_agi(mp, NULL, agno, &agbp);
> > +	if (error)
> > +		return error;
> > +
> > +	cur = xfs_inobt_init_cursor(mp, NULL, agbp, agno, btnum);
> > +	error = xfs_btree_count_blocks(cur, tree_blocks);
> > +	xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
> > +	xfs_buf_relse(agbp);
> > +
> > +	return error;
> > +}
> > +
> > +/*
> > + * Figure out how many blocks to reserve and how many are used by this btree.
> > + */
> > +int
> > +xfs_finobt_calc_reserves(
> > +	struct xfs_mount	*mp,
> > +	xfs_agnumber_t		agno,
> > +	xfs_extlen_t		*ask,
> > +	xfs_extlen_t		*used)
> > +{
> > +	xfs_extlen_t		tree_len = 0;
> > +	int			error;
> > +
> > +	if (!xfs_sb_version_hasfinobt(&mp->m_sb))
> > +		return 0;
> > +
> > +	error = xfs_inobt_count_blocks(mp, agno, XFS_BTNUM_FINO, &tree_len);
> 
> This requires us to traverse all the blocks in the finobt at mount time,
> which isn't necessarily quick.  For refcount/rmap we cache the number of
> tree blocks in the AGF to speed this up... but it was easy to sneak that
> into the disk format. :)
> 
> For finobt I wonder if one could defer the block counting work to a
> separate thread if the AG has enough free blocks to cover, say, 10x the
> maximum reservation?  Though that could be racy and maybe finobts are
> small enough that the impact on mount time is low anyway?
> 

While the finobt is a subset of the inobt, I don't think we can really
assume it's small, at least enough that it wouldn't ever cause mount
delays. It might require an uncommon workload to cause, but if we have
one that causes this problem in the first place then I wouldn't rule it
out. ;P

How accurate does the reservation really need to be? I'm wondering if we
could get away with a conservative estimate of how many blocks are used
based on tree level or something (and/or perhaps use that as a heuristic
to determine when to count vs. estimate). We reserve up to the
theoretical max and may never consume those blocks with the finobt, so
it seems to me we're already affecting when the user hits ENOSPC in most
cases. I'd just be leery about how much further we could throw that off
to the point that ENOSPC could occur annoyingly prematurely.

> 
> There's also the unsolved problem of what happens if we mount and find
> agf_freeblks < (sum(ask) - sum(used)) -- right now we eat that state and
> hope that we don't later ENOSPC and crash.  For reflink and rmap we will
> have always had the AG reservation and therefore it should never happen
> that we have fewer free blocks than reserved blocks.  (Unless the user
> does something pathological like using CoW to create many billions of
> separate rmap records...)
> 

This might be less severe/rare enough than the reflink use case so as to
not require a hard failure. This is the first I've heard of such a
condition since finobt was introduced (and I'm interested in a
reproducer or workload description, if possible). Note that we also had
similar behavior with the global reserve pool in low free space
conditions and only discovered that bug by accident. :P

Perhaps a mount time warning for the finobt-specific bit of the
reservation would suffice? That could indicate to the user to free up
space, grow the fs or risk the consequences. :P Taking a quick look,
however, it looks like that could introduce problems for reflink=1 fs'
because everything is pooled into one allocation request. So I guess
even that would require some effort to support subsequent/additive
reservation requests with different failure constraints. :/

Brian

> But as for retroactively adding AG reservations for an existing tree, I
> guess we'll have to come up with a strategy for dealing with
> insufficient free blocks.  I suppose one could try to use xfs_fsr to
> move large contiguous extents to a less full AG, if there are any...
> 
> (I actually hit the "insufficient freeblks for AG reservation" case over
> the holiday when I "upgraded" an XFS to rmap+reflink the foolish way and
> neglected to ensure the free space...)
> 
> --D
> 
> > +	if (error)
> > +		return error;
> > +
> > +	*ask += xfs_inobt_max_size(mp);
> > +	*used += tree_len;
> > +	return 0;
> > +}
> > diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.h b/fs/xfs/libxfs/xfs_ialloc_btree.h
> > index bd88453..aa81e2e 100644
> > --- a/fs/xfs/libxfs/xfs_ialloc_btree.h
> > +++ b/fs/xfs/libxfs/xfs_ialloc_btree.h
> > @@ -72,4 +72,7 @@ int xfs_inobt_rec_check_count(struct xfs_mount *,
> >  #define xfs_inobt_rec_check_count(mp, rec)	0
> >  #endif	/* DEBUG */
> >  
> > +int xfs_finobt_calc_reserves(struct xfs_mount *mp, xfs_agnumber_t agno,
> > +		xfs_extlen_t *ask, xfs_extlen_t *used);
> > +
> >  #endif	/* __XFS_IALLOC_BTREE_H__ */
> > diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
> > index 7917f6e..6db3e2d 100644
> > --- a/fs/xfs/libxfs/xfs_trans_space.h
> > +++ b/fs/xfs/libxfs/xfs_trans_space.h
> > @@ -94,8 +94,5 @@
> >  	(XFS_DIRREMOVE_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl))
> >  #define	XFS_SYMLINK_SPACE_RES(mp,nl,b)	\
> >  	(XFS_IALLOC_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl) + (b))
> > -#define XFS_IFREE_SPACE_RES(mp)		\
> > -	(xfs_sb_version_hasfinobt(&mp->m_sb) ? (mp)->m_in_maxlevels : 0)
> > -
> >  
> >  #endif	/* __XFS_TRANS_SPACE_H__ */
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index b955779..0283ab6 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -1792,30 +1792,11 @@ xfs_inactive_ifree(
> >  	int			error;
> >  
> >  	/*
> > -	 * The ifree transaction might need to allocate blocks for record
> > -	 * insertion to the finobt. We don't want to fail here at ENOSPC, so
> > -	 * allow ifree to dip into the reserved block pool if necessary.
> > -	 *
> > -	 * Freeing large sets of inodes generally means freeing inode chunks,
> > -	 * directory and file data blocks, so this should be relatively safe.
> > -	 * Only under severe circumstances should it be possible to free enough
> > -	 * inodes to exhaust the reserve block pool via finobt expansion while
> > -	 * at the same time not creating free space in the filesystem.
> > -	 *
> > -	 * Send a warning if the reservation does happen to fail, as the inode
> > -	 * now remains allocated and sits on the unlinked list until the fs is
> > -	 * repaired.
> > +	 * We use a per-AG reservation for any block needed by the finobt tree.
> >  	 */
> > -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ifree,
> > -			XFS_IFREE_SPACE_RES(mp), 0, XFS_TRANS_RESERVE, &tp);
> > +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ifree, 0, 0, 0, &tp);
> >  	if (error) {
> > -		if (error == -ENOSPC) {
> > -			xfs_warn_ratelimited(mp,
> > -			"Failed to remove inode(s) from unlinked list. "
> > -			"Please free space, unmount and run xfs_repair.");
> > -		} else {
> > -			ASSERT(XFS_FORCED_SHUTDOWN(mp));
> > -		}
> > +		ASSERT(XFS_FORCED_SHUTDOWN(mp));
> >  		return error;
> >  	}
> >  
> > -- 
> > 2.1.4
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
