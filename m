Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38674 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752187AbeD3MRz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 30 Apr 2018 08:17:55 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B497F30C8098
        for <linux-xfs@vger.kernel.org>; Mon, 30 Apr 2018 12:17:55 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6EE1B60BEB
        for <linux-xfs@vger.kernel.org>; Mon, 30 Apr 2018 12:17:55 +0000 (UTC)
Date: Mon, 30 Apr 2018 08:17:54 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC PATCH] xfs: skip discard of unwritten extents
Message-ID: <20180430121753.GA22176@bfoster.bfoster>
References: <20180426180624.6134-1-bfoster@redhat.com>
 <20180430090635.nsbqgygaftboou3k@odin.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180430090635.nsbqgygaftboou3k@odin.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On Mon, Apr 30, 2018 at 11:06:35AM +0200, Carlos Maiolino wrote:
> Hi,
> 
> On Thu, Apr 26, 2018 at 02:06:24PM -0400, Brian Foster wrote:
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> > 
> > Hi all,
> > 
> > What do folks think of something like this? The motivation here is that
> > the VDO (dedup) devs had reported seeing online discards during
> > write-only workloads. These turn out to be related to trimming post-eof
> > preallocation blocks after large file copies. To my knowledge, this
> > isn't really a prevalent or serious issue, but I think that technically
> > these discards are unnecessary and so I was looking into how we could
> > avoid them.
> > 
> > This behavior is of course not directly related to unwritten extents,
> > but the immediate/obvious solution to bubble up a bmapi flag of some
> > kind to xfs_free_eofblocks() seemed rather crude. From there, I figured
> > that we technically don't need to discard any unwritten extents (within
> > or beyond EOF) because they haven't been written to since being
> > allocated. In fact, I'm not sure we have to even busy them, but it's
> > roughly equivalent logic either way and I'm trying to avoid getting too
> > clever.
> > 
> 
> There is one thing I'm wondering here, pardon me if my assumptions are wrong.
> 
> Regarding the discard of post-eof blocks, one thing that comes to my mind, is
> what would happen after let's say, a failed fallocate (I've run into this issued
> a few months ago, and it just came to my mind while looking into this patch).
> Currently, after a failed fallocate (issued beyond EOF), we do not rollback any
> successfully allocated extents, keeping such extents allocated to the file,
> consuming filesystem's space.
> 

Right.. I think this is fairly generic behavior, regardless of whether
some of the extents extend or run past eof. IOW, a failed falloc is
simply a partial falloc operation.

> Today, such extents are freed when xfs_free_eofblocks() is called, freeing up
> the space partially reserved by the failed fallocate.
> 

Hmm, I suspect this is more of an implementation detail than a hard and
fast rule. The eofblocks trimming should not occur on any inode that has
user-driven preallocation, which is marked via XFS_DIFLAG_PREALLOC. I
haven't tested behavior, but on a quick look it appears we set this flag
only after successful completion of xfs_alloc_file_space() in the
fallocate path.

I think that means it's possible for a first fallocate on an inode to
partially succeed allocating blocks and fail to set the flag. This means
an eofblocks trim could affect such blocks. I also think that means it's
possible for a subsequent fallocate to partially succeed where the flag
may have already been set on the inode..? If so, that means a subsequent
eofblocks trim would not affect such blocks.

FWIW, I'm not terribly concerned with error handling behavior in this
case. Ultimately the user will need to fix up the file one way or
another and this patch is more concerned about discard of the resulting
blocks if they are freed (independent of whether they should have been
freed in the first place).

> I honestly do not remember if in such situation, we might already have issued
> any write to the underlying device or not, if we did, issuing a discard here is
> still useful.
> 

eofblocks aside, I think it's always possible for the fs to send writes
and then crash after some of those writes have completed but before
we've converted unwritten extents. If the latter transaction is lost,
the blocks will have been written by an underlying thin device (for
e.g.) but not tracked as such in the fs. Failure to discard such blocks
if they are eventually freed means the underlying device would not
release them.

> I do *think* no writes have been issued to the block device so skipping discards
> is not an issue, but I thought it might be worth to bring up such case.
> 

I think it's a good point wrt to the discard. I'm not totally sure what
the right answer is. On one hand, I think the discards are technically
advisory so it might be a worthwhile tradeoff for a rare situation that
can already be introduced in other ways (such as a discard being ignored
or an intermediate mount without online discard enabled). We could
always recommend an fstrim after a log recovery, for example.

On the other hand, others might think that it's more appropriate to be
aggressive with online discards in the fs as we are today to provide the
device with as much information as possible.

Brian

> The right approach from user is still to rollback its failed fallocate, but I
> still think post eof block trim is useful in this case. Though I'm not sure if
> the discard itself is useful or not.
> 
> Thoughts?
> 
> Cheers
> > I also recall that we've discussed using unwritten extents for delalloc
> > -> real conversion to avoid the small stale data exposure window that
> > exists in writeback. Without getting too deep into the reason we don't
> > currently do an initial unwritten allocation [1], I don't think there's
> > anything blocking us from converting any post-eof blocks that happen to
> > be part of the resulting normal allocation. As it is, the imap is
> > already trimmed to EOF by the writeback code for coherency reasons. If
> > we were to convert post-eof blocks (not part of this patch) along with
> > something like this patch, then we'd indirectly prevent discards for
> > eofblocks trims.
> > 
> > Beyond the whole discard thing, conversion of post-eof blocks may have a
> > couple other advantages. First, we eliminate the aforementioned
> > writeback stale data exposure problem for writes over preallocated
> > blocks (which doesn't solve the fundamental problem, but closes the
> > gap). Second, the zeroing required for post-eof writes that jump over
> > eofblocks (see xfs_file_aio_write_checks()) becomes a much lighter
> > weight operation. Normal blocks are zeroed using buffered writes whereas
> > this is essentially a no-op for unwritten extents.
> > 
> > Thoughts? Flames? Other ideas?
> > 
> > Brian
> > 
> > [1] I think I've actually attempted this change in the past, but I
> > haven't dug through my old git branches as of yet to completely jog my
> > memory. IIRC, this may have been held up by the remnants of buffer_heads
> > being used to track state for the writeback code.
> > 
> >  fs/xfs/libxfs/xfs_alloc.c          | 8 ++++++--
> >  fs/xfs/libxfs/xfs_alloc.h          | 3 ++-
> >  fs/xfs/libxfs/xfs_bmap.c           | 9 ++++++---
> >  fs/xfs/libxfs/xfs_bmap.h           | 3 ++-
> >  fs/xfs/libxfs/xfs_bmap_btree.c     | 2 +-
> >  fs/xfs/libxfs/xfs_ialloc.c         | 4 ++--
> >  fs/xfs/libxfs/xfs_ialloc_btree.c   | 2 +-
> >  fs/xfs/libxfs/xfs_refcount.c       | 7 ++++---
> >  fs/xfs/libxfs/xfs_refcount_btree.c | 2 +-
> >  fs/xfs/xfs_extfree_item.c          | 2 +-
> >  fs/xfs/xfs_fsops.c                 | 2 +-
> >  fs/xfs/xfs_reflink.c               | 2 +-
> >  fs/xfs/xfs_trans.h                 | 3 ++-
> >  fs/xfs/xfs_trans_extfree.c         | 7 ++++---
> >  14 files changed, 34 insertions(+), 22 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index 4bcc095fe44a..942c90ec6747 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -2954,13 +2954,15 @@ xfs_free_extent(
> >  	xfs_fsblock_t		bno,	/* starting block number of extent */
> >  	xfs_extlen_t		len,	/* length of extent */
> >  	struct xfs_owner_info	*oinfo,	/* extent owner */
> > -	enum xfs_ag_resv_type	type)	/* block reservation type */
> > +	enum xfs_ag_resv_type	type,	/* block reservation type */
> > +	bool			skip_discard)
> >  {
> >  	struct xfs_mount	*mp = tp->t_mountp;
> >  	struct xfs_buf		*agbp;
> >  	xfs_agnumber_t		agno = XFS_FSB_TO_AGNO(mp, bno);
> >  	xfs_agblock_t		agbno = XFS_FSB_TO_AGBNO(mp, bno);
> >  	int			error;
> > +	unsigned int		busy_flags = 0;
> >  
> >  	ASSERT(len != 0);
> >  	ASSERT(type != XFS_AG_RESV_AGFL);
> > @@ -2984,7 +2986,9 @@ xfs_free_extent(
> >  	if (error)
> >  		goto err;
> >  
> > -	xfs_extent_busy_insert(tp, agno, agbno, len, 0);
> > +	if (skip_discard)
> > +		busy_flags |= XFS_EXTENT_BUSY_SKIP_DISCARD;
> > +	xfs_extent_busy_insert(tp, agno, agbno, len, busy_flags);
> >  	return 0;
> >  
> >  err:
> > diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> > index cbf789ea5a4e..5c7d8391edc4 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.h
> > +++ b/fs/xfs/libxfs/xfs_alloc.h
> > @@ -196,7 +196,8 @@ xfs_free_extent(
> >  	xfs_fsblock_t		bno,	/* starting block number of extent */
> >  	xfs_extlen_t		len,	/* length of extent */
> >  	struct xfs_owner_info	*oinfo,	/* extent owner */
> > -	enum xfs_ag_resv_type	type);	/* block reservation type */
> > +	enum xfs_ag_resv_type	type,	/* block reservation type */
> > +	bool			skip_discard);
> >  
> >  int				/* error */
> >  xfs_alloc_lookup_le(
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index 040eeda8426f..a5a37803f589 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -547,7 +547,8 @@ xfs_bmap_add_free(
> >  	struct xfs_defer_ops		*dfops,
> >  	xfs_fsblock_t			bno,
> >  	xfs_filblks_t			len,
> > -	struct xfs_owner_info		*oinfo)
> > +	struct xfs_owner_info		*oinfo,
> > +	bool				skip_discard)
> >  {
> >  	struct xfs_extent_free_item	*new;		/* new element */
> >  #ifdef DEBUG
> > @@ -574,6 +575,7 @@ xfs_bmap_add_free(
> >  		new->xefi_oinfo = *oinfo;
> >  	else
> >  		xfs_rmap_skip_owner_update(&new->xefi_oinfo);
> > +	new->xefi_skip_discard = skip_discard;
> >  	trace_xfs_bmap_free_defer(mp, XFS_FSB_TO_AGNO(mp, bno), 0,
> >  			XFS_FSB_TO_AGBNO(mp, bno), len);
> >  	xfs_defer_add(dfops, XFS_DEFER_OPS_TYPE_FREE, &new->xefi_list);
> > @@ -632,7 +634,7 @@ xfs_bmap_btree_to_extents(
> >  	if ((error = xfs_btree_check_block(cur, cblock, 0, cbp)))
> >  		return error;
> >  	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, whichfork);
> > -	xfs_bmap_add_free(mp, cur->bc_private.b.dfops, cbno, 1, &oinfo);
> > +	xfs_bmap_add_free(mp, cur->bc_private.b.dfops, cbno, 1, &oinfo, false);
> >  	ip->i_d.di_nblocks--;
> >  	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
> >  	xfs_trans_binval(tp, cbp);
> > @@ -5106,7 +5108,8 @@ xfs_bmap_del_extent_real(
> >  				goto done;
> >  		} else
> >  			xfs_bmap_add_free(mp, dfops, del->br_startblock,
> > -					del->br_blockcount, NULL);
> > +					del->br_blockcount, NULL,
> > +					del->br_state == XFS_EXT_UNWRITTEN);
> >  	}
> >  
> >  	/*
> > diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> > index 2b766b37096d..0d2de22d143e 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.h
> > +++ b/fs/xfs/libxfs/xfs_bmap.h
> > @@ -68,6 +68,7 @@ struct xfs_extent_free_item
> >  	xfs_extlen_t		xefi_blockcount;/* number of blocks in extent */
> >  	struct list_head	xefi_list;
> >  	struct xfs_owner_info	xefi_oinfo;	/* extent owner */
> > +	bool			xefi_skip_discard;
> >  };
> >  
> >  #define	XFS_BMAP_MAX_NMAP	4
> > @@ -194,7 +195,7 @@ int	xfs_bmap_add_attrfork(struct xfs_inode *ip, int size, int rsvd);
> >  void	xfs_bmap_local_to_extents_empty(struct xfs_inode *ip, int whichfork);
> >  void	xfs_bmap_add_free(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
> >  			  xfs_fsblock_t bno, xfs_filblks_t len,
> > -			  struct xfs_owner_info *oinfo);
> > +			  struct xfs_owner_info *oinfo, bool skip_discard);
> >  void	xfs_bmap_compute_maxlevels(struct xfs_mount *mp, int whichfork);
> >  int	xfs_bmap_first_unused(struct xfs_trans *tp, struct xfs_inode *ip,
> >  		xfs_extlen_t len, xfs_fileoff_t *unused, int whichfork);
> > diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> > index d89d06bea6e3..cecddfcbe11e 100644
> > --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> > +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> > @@ -305,7 +305,7 @@ xfs_bmbt_free_block(
> >  	struct xfs_owner_info	oinfo;
> >  
> >  	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, cur->bc_private.b.whichfork);
> > -	xfs_bmap_add_free(mp, cur->bc_private.b.dfops, fsbno, 1, &oinfo);
> > +	xfs_bmap_add_free(mp, cur->bc_private.b.dfops, fsbno, 1, &oinfo, false);
> >  	ip->i_d.di_nblocks--;
> >  
> >  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> > diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> > index de627fa19168..854ebe04c86f 100644
> > --- a/fs/xfs/libxfs/xfs_ialloc.c
> > +++ b/fs/xfs/libxfs/xfs_ialloc.c
> > @@ -1837,7 +1837,7 @@ xfs_difree_inode_chunk(
> >  	if (!xfs_inobt_issparse(rec->ir_holemask)) {
> >  		/* not sparse, calculate extent info directly */
> >  		xfs_bmap_add_free(mp, dfops, XFS_AGB_TO_FSB(mp, agno, sagbno),
> > -				  mp->m_ialloc_blks, &oinfo);
> > +				  mp->m_ialloc_blks, &oinfo, false);
> >  		return;
> >  	}
> >  
> > @@ -1881,7 +1881,7 @@ xfs_difree_inode_chunk(
> >  		ASSERT(agbno % mp->m_sb.sb_spino_align == 0);
> >  		ASSERT(contigblk % mp->m_sb.sb_spino_align == 0);
> >  		xfs_bmap_add_free(mp, dfops, XFS_AGB_TO_FSB(mp, agno, agbno),
> > -				  contigblk, &oinfo);
> > +				  contigblk, &oinfo, false);
> >  
> >  		/* reset range to current bit and carry on... */
> >  		startidx = endidx = nextbit;
> > diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> > index 367e9a0726e6..977a33cc60d3 100644
> > --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> > +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> > @@ -153,7 +153,7 @@ __xfs_inobt_free_block(
> >  	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INOBT);
> >  	return xfs_free_extent(cur->bc_tp,
> >  			XFS_DADDR_TO_FSB(cur->bc_mp, XFS_BUF_ADDR(bp)), 1,
> > -			&oinfo, resv);
> > +			&oinfo, resv, false);
> >  }
> >  
> >  STATIC int
> > diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> > index 560e28473024..e5cfbe2534b1 100644
> > --- a/fs/xfs/libxfs/xfs_refcount.c
> > +++ b/fs/xfs/libxfs/xfs_refcount.c
> > @@ -883,7 +883,8 @@ xfs_refcount_adjust_extents(
> >  						cur->bc_private.a.agno,
> >  						tmp.rc_startblock);
> >  				xfs_bmap_add_free(cur->bc_mp, dfops, fsbno,
> > -						tmp.rc_blockcount, oinfo);
> > +						tmp.rc_blockcount, oinfo,
> > +						false);
> >  			}
> >  
> >  			(*agbno) += tmp.rc_blockcount;
> > @@ -926,7 +927,7 @@ xfs_refcount_adjust_extents(
> >  					cur->bc_private.a.agno,
> >  					ext.rc_startblock);
> >  			xfs_bmap_add_free(cur->bc_mp, dfops, fsbno,
> > -					ext.rc_blockcount, oinfo);
> > +					ext.rc_blockcount, oinfo, false);
> >  		}
> >  
> >  skip:
> > @@ -1658,7 +1659,7 @@ xfs_refcount_recover_cow_leftovers(
> >  
> >  		/* Free the block. */
> >  		xfs_bmap_add_free(mp, &dfops, fsb,
> > -				rr->rr_rrec.rc_blockcount, NULL);
> > +				rr->rr_rrec.rc_blockcount, NULL, false);
> >  
> >  		error = xfs_defer_finish(&tp, &dfops);
> >  		if (error)
> > diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
> > index 375abfeb6267..bb0bdc6d97b5 100644
> > --- a/fs/xfs/libxfs/xfs_refcount_btree.c
> > +++ b/fs/xfs/libxfs/xfs_refcount_btree.c
> > @@ -131,7 +131,7 @@ xfs_refcountbt_free_block(
> >  	be32_add_cpu(&agf->agf_refcount_blocks, -1);
> >  	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_REFCOUNT_BLOCKS);
> >  	error = xfs_free_extent(cur->bc_tp, fsbno, 1, &oinfo,
> > -			XFS_AG_RESV_METADATA);
> > +			XFS_AG_RESV_METADATA, false);
> >  	if (error)
> >  		return error;
> >  
> > diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> > index b5b1e567b9f4..4735a31793b0 100644
> > --- a/fs/xfs/xfs_extfree_item.c
> > +++ b/fs/xfs/xfs_extfree_item.c
> > @@ -542,7 +542,7 @@ xfs_efi_recover(
> >  	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
> >  		extp = &efip->efi_format.efi_extents[i];
> >  		error = xfs_trans_free_extent(tp, efdp, extp->ext_start,
> > -					      extp->ext_len, &oinfo);
> > +					      extp->ext_len, &oinfo, false);
> >  		if (error)
> >  			goto abort_error;
> >  
> > diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> > index 523792768080..9c555f81431e 100644
> > --- a/fs/xfs/xfs_fsops.c
> > +++ b/fs/xfs/xfs_fsops.c
> > @@ -502,7 +502,7 @@ xfs_growfs_data_private(
> >  		error = xfs_free_extent(tp,
> >  				XFS_AGB_TO_FSB(mp, agno,
> >  					be32_to_cpu(agf->agf_length) - new),
> > -				new, &oinfo, XFS_AG_RESV_NONE);
> > +				new, &oinfo, XFS_AG_RESV_NONE, false);
> >  		if (error)
> >  			goto error0;
> >  	}
> > diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> > index cdbd342a5249..08381266ad85 100644
> > --- a/fs/xfs/xfs_reflink.c
> > +++ b/fs/xfs/xfs_reflink.c
> > @@ -604,7 +604,7 @@ xfs_reflink_cancel_cow_blocks(
> >  
> >  			xfs_bmap_add_free(ip->i_mount, &dfops,
> >  					del.br_startblock, del.br_blockcount,
> > -					NULL);
> > +					NULL, false);
> >  
> >  			/* Roll the transaction */
> >  			xfs_defer_ijoin(&dfops, ip);
> > diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> > index 9d542dfe0052..d5be3f6a3e8f 100644
> > --- a/fs/xfs/xfs_trans.h
> > +++ b/fs/xfs/xfs_trans.h
> > @@ -228,7 +228,8 @@ struct xfs_efd_log_item	*xfs_trans_get_efd(struct xfs_trans *,
> >  				  uint);
> >  int		xfs_trans_free_extent(struct xfs_trans *,
> >  				      struct xfs_efd_log_item *, xfs_fsblock_t,
> > -				      xfs_extlen_t, struct xfs_owner_info *);
> > +				      xfs_extlen_t, struct xfs_owner_info *,
> > +				      bool);
> >  int		xfs_trans_commit(struct xfs_trans *);
> >  int		xfs_trans_roll(struct xfs_trans **);
> >  int		xfs_trans_roll_inode(struct xfs_trans **, struct xfs_inode *);
> > diff --git a/fs/xfs/xfs_trans_extfree.c b/fs/xfs/xfs_trans_extfree.c
> > index ab438647592a..cd2acfa4e562 100644
> > --- a/fs/xfs/xfs_trans_extfree.c
> > +++ b/fs/xfs/xfs_trans_extfree.c
> > @@ -68,7 +68,8 @@ xfs_trans_free_extent(
> >  	struct xfs_efd_log_item	*efdp,
> >  	xfs_fsblock_t		start_block,
> >  	xfs_extlen_t		ext_len,
> > -	struct xfs_owner_info	*oinfo)
> > +	struct xfs_owner_info	*oinfo,
> > +	bool			skip_discard)
> >  {
> >  	struct xfs_mount	*mp = tp->t_mountp;
> >  	uint			next_extent;
> > @@ -80,7 +81,7 @@ xfs_trans_free_extent(
> >  	trace_xfs_bmap_free_deferred(tp->t_mountp, agno, 0, agbno, ext_len);
> >  
> >  	error = xfs_free_extent(tp, start_block, ext_len, oinfo,
> > -			XFS_AG_RESV_NONE);
> > +			XFS_AG_RESV_NONE, skip_discard);
> >  
> >  	/*
> >  	 * Mark the transaction dirty, even on error. This ensures the
> > @@ -195,7 +196,7 @@ xfs_extent_free_finish_item(
> >  	error = xfs_trans_free_extent(tp, done_item,
> >  			free->xefi_startblock,
> >  			free->xefi_blockcount,
> > -			&free->xefi_oinfo);
> > +			&free->xefi_oinfo, free->xefi_skip_discard);
> >  	kmem_free(free);
> >  	return error;
> >  }
> > -- 
> > 2.13.6
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> -- 
> Carlos
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
