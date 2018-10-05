Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:39154 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727572AbeJEWKN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Oct 2018 18:10:13 -0400
Date: Fri, 5 Oct 2018 08:11:00 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/3] xfs: fix buffer state management in
 xrep_findroot_block
Message-ID: <20181005151100.GP19324@magnolia>
References: <153870045847.29695.10286947858219936840.stgit@magnolia>
 <153870047729.29695.18042015772366432041.stgit@magnolia>
 <20181005115950.GC54400@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181005115950.GC54400@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Fri, Oct 05, 2018 at 07:59:51AM -0400, Brian Foster wrote:
> On Thu, Oct 04, 2018 at 05:47:57PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > We don't handle buffer state properly in online repair's findroot
> > routine.  If a buffer already has b_ops set, we don't ever want to touch
> > that, and we don't want to call the read verifiers on a buffer that
> > could be dirty (CRCs are only recomputed during log checkpoints).
> > 
> > Therefore, be more careful about what we do with a buffer -- if someone
> > else already attached ops that are not the ones for this btree type,
> > just ignore the buffer.  We only attach our btree type's buf ops if it
> > matches the magic/uuid and structure checks.
> > 
> > We also modify xfs_buf_read_map to allow callers to set buffer ops on a
> > DONE buffer with NULL ops so that repair doesn't leave behind buffers
> > which won't have buffers attached to them.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/scrub/repair.c  |   63 +++++++++++++++++++++++++++++++++++++-----------
> >  fs/xfs/xfs_trans.h     |    1 +
> >  fs/xfs/xfs_trans_buf.c |   13 ++++++++++
> >  3 files changed, 63 insertions(+), 14 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> > index 63786341ac2a..cebaebb26566 100644
> > --- a/fs/xfs/scrub/repair.c
> > +++ b/fs/xfs/scrub/repair.c
> ...
> > @@ -718,28 +720,61 @@ xrep_findroot_block(
> >  			return error;
> >  	}
> >  
> ...
> > +	/*
> > +	 * If the buffer already has ops applied and they're not the ones for
> > +	 * this btree type, we know this block doesn't match the btree and we
> > +	 * can bail out.
> > +	 *
> > +	 * If the buffer ops match ours, someone else has already validated
> > +	 * the block for us, so we can move on to checking if this is a root
> > +	 * block candidate.
> > +	 *
> > +	 * If the buffer does not have ops, nobody has successfully validated
> > +	 * the contents and the buffer cannot be dirty.  If the magic, uuid,
> > +	 * and structure match this btree type then we'll move on to checking
> > +	 * if it's a root block candidate.  If there is no match, bail out.
> > +	 */
> > +	if (bp->b_ops) {
> > +		if (bp->b_ops != fab->buf_ops)
> > +			goto out;
> > +	} else {
> > +		ASSERT(!xfs_trans_buf_is_dirty(bp));
> > +		if (!uuid_equal(&btblock->bb_u.s.bb_uuid,
> > +				&mp->m_sb.sb_meta_uuid))
> > +			goto out;
> > +		fab->buf_ops->verify_read(bp);
> > +		if (bp->b_error)
> > +			goto out;
> 
> I guess this is related to my question on the previous patch. If the
> verifier fails, we leave the XBF_DONE buffer around with ->b_ops == NULL
> and ->b_error != 0.
> 
> I suppose somebody should eventually attach a verifier before this
> buffer is ever really used, but I think I'd feel a little better about
> this if we immediately cleaned up the side effects of using the wrong
> verifier rather than potentially leaking an error to other contexts
> where it has no relevance. That aside, this all looks fine to me.

Ok, I'll make it clean up the error state before dumping the buffer.

--D

> Brian
> 
> > +		bp->b_ops = fab->buf_ops;
> > +	}
> >  
> >  	/*
> >  	 * This block passes the magic/uuid and verifier tests for this btree
> > diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> > index c3d278e96ad1..a0c5dbda18aa 100644
> > --- a/fs/xfs/xfs_trans.h
> > +++ b/fs/xfs/xfs_trans.h
> > @@ -220,6 +220,7 @@ void		xfs_trans_ijoin(struct xfs_trans *, struct xfs_inode *, uint);
> >  void		xfs_trans_log_buf(struct xfs_trans *, struct xfs_buf *, uint,
> >  				  uint);
> >  void		xfs_trans_dirty_buf(struct xfs_trans *, struct xfs_buf *);
> > +bool		xfs_trans_buf_is_dirty(struct xfs_buf *bp);
> >  void		xfs_trans_log_inode(xfs_trans_t *, struct xfs_inode *, uint);
> >  
> >  void		xfs_extent_free_init_defer_op(void);
> > diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> > index b0ba2ca9cca3..93a053c700dd 100644
> > --- a/fs/xfs/xfs_trans_buf.c
> > +++ b/fs/xfs/xfs_trans_buf.c
> > @@ -349,6 +349,19 @@ xfs_trans_read_buf_map(
> >  
> >  }
> >  
> > +/* Has this buffer been dirtied by anyone? */
> > +bool
> > +xfs_trans_buf_is_dirty(
> > +	struct xfs_buf		*bp)
> > +{
> > +	struct xfs_buf_log_item	*bip = bp->b_log_item;
> > +
> > +	if (!bip)
> > +		return false;
> > +	ASSERT(bip->bli_item.li_type == XFS_LI_BUF);
> > +	return test_bit(XFS_LI_DIRTY, &bip->bli_item.li_flags);
> > +}
> > +
> >  /*
> >   * Release the buffer bp which was previously acquired with one of the
> >   * xfs_trans_... buffer allocation routines if the buffer has not
> > 
