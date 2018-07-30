Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:55234 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726782AbeG3S6Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Jul 2018 14:58:24 -0400
Date: Mon, 30 Jul 2018 10:22:16 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 03/14] xfs: repair the AGFL
Message-ID: <20180730172216.GX30972@magnolia>
References: <153292966714.24509.15809693393247424274.stgit@magnolia>
 <153292968888.24509.5021796491286828939.stgit@magnolia>
 <20180730162523.GC35107@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180730162523.GC35107@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, allison.henderson@oracle.com

On Mon, Jul 30, 2018 at 12:25:24PM -0400, Brian Foster wrote:
> On Sun, Jul 29, 2018 at 10:48:08PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Repair the AGFL from the rmap data.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> 
> FWIW, I tried tweaking a couple agfl values via xfs_db and xfs_scrub
> seems to always dump a cross-referencing failed error and not want to
> deal with it. Expected? Is there a good way to unit test some of this
> stuff with simple/localized corruptions?

I usually pick one of the corruptions from xfs/355...

$ SCRATCH_XFS_LIST_FUZZ_VERBS=random \
SCRATCH_XFS_LIST_METADATA_FIELDS=somefield \
./check xfs/355

> Otherwise this looks sane, a couple comments..
> 
> >  fs/xfs/scrub/agheader_repair.c |  276 ++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/scrub/bitmap.c          |   92 +++++++++++++
> >  fs/xfs/scrub/bitmap.h          |    4 +
> >  fs/xfs/scrub/scrub.c           |    2 
> >  4 files changed, 373 insertions(+), 1 deletion(-)
> > 
> > 
> > diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> > index 4842fc598c9b..bfef066c87c3 100644
> > --- a/fs/xfs/scrub/agheader_repair.c
> > +++ b/fs/xfs/scrub/agheader_repair.c
> > @@ -424,3 +424,279 @@ xrep_agf(
> >  	memcpy(agf, &old_agf, sizeof(old_agf));
> >  	return error;
> >  }
> > +
> ...
> > +/* Write out a totally new AGFL. */
> > +STATIC void
> > +xrep_agfl_init_header(
> > +	struct xfs_scrub	*sc,
> > +	struct xfs_buf		*agfl_bp,
> > +	struct xfs_bitmap	*agfl_extents,
> > +	xfs_agblock_t		flcount)
> > +{
> > +	struct xfs_mount	*mp = sc->mp;
> > +	__be32			*agfl_bno;
> > +	struct xfs_bitmap_range	*br;
> > +	struct xfs_bitmap_range	*n;
> > +	struct xfs_agfl		*agfl;
> > +	xfs_agblock_t		agbno;
> > +	unsigned int		fl_off;
> > +
> > +	ASSERT(flcount <= xfs_agfl_size(mp));
> > +
> > +	/* Start rewriting the header. */
> > +	agfl = XFS_BUF_TO_AGFL(agfl_bp);
> > +	memset(agfl, 0xFF, BBTOB(agfl_bp->b_length));
> 
> What's the purpose behind 0xFF? Related to NULLAGBLOCK/NULLCOMMITLSN..?

Yes, it prepopulates the AGFL bno[] array with NULLAGBLOCK, then writes
in the header fields.

> > +	agfl->agfl_magicnum = cpu_to_be32(XFS_AGFL_MAGIC);
> > +	agfl->agfl_seqno = cpu_to_be32(sc->sa.agno);
> > +	uuid_copy(&agfl->agfl_uuid, &mp->m_sb.sb_meta_uuid);
> > +
> > +	/*
> > +	 * Fill the AGFL with the remaining blocks.  If agfl_extents has more
> > +	 * blocks than fit in the AGFL, they will be freed in a subsequent
> > +	 * step.
> > +	 */
> > +	fl_off = 0;
> > +	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agfl_bp);
> > +	for_each_xfs_bitmap_extent(br, n, agfl_extents) {
> > +		agbno = XFS_FSB_TO_AGBNO(mp, br->start);
> > +
> > +		trace_xrep_agfl_insert(mp, sc->sa.agno, agbno, br->len);
> > +
> > +		while (br->len > 0 && fl_off < flcount) {
> > +			agfl_bno[fl_off] = cpu_to_be32(agbno);
> > +			fl_off++;
> > +			agbno++;
> 
> 			/* bump br so we don't reap blocks we've used */
> 
> (i.e., took me a sec to realize why we bother with ->start)
> 
> > +			br->start++;
> > +			br->len--;
> > +		}
> > +
> > +		if (br->len)
> > +			break;
> > +		list_del(&br->list);
> > +		kmem_free(br);
> > +	}
> > +
> > +	/* Write new AGFL to disk. */
> > +	xfs_trans_buf_set_type(sc->tp, agfl_bp, XFS_BLFT_AGFL_BUF);
> > +	xfs_trans_log_buf(sc->tp, agfl_bp, 0, BBTOB(agfl_bp->b_length) - 1);
> > +}
> > +
> ...
> > diff --git a/fs/xfs/scrub/bitmap.c b/fs/xfs/scrub/bitmap.c
> > index c770e2d0b6aa..fdadc9e1dc49 100644
> > --- a/fs/xfs/scrub/bitmap.c
> > +++ b/fs/xfs/scrub/bitmap.c
> > @@ -9,6 +9,7 @@
> >  #include "xfs_format.h"
> >  #include "xfs_trans_resv.h"
> >  #include "xfs_mount.h"
> > +#include "xfs_btree.h"
> >  #include "scrub/xfs_scrub.h"
> >  #include "scrub/scrub.h"
> >  #include "scrub/common.h"
> > @@ -209,3 +210,94 @@ xfs_bitmap_disunion(
> >  }
> >  #undef LEFT_ALIGNED
> >  #undef RIGHT_ALIGNED
> > +
> > +/*
> > + * Record all btree blocks seen while iterating all records of a btree.
> > + *
> > + * We know that the btree query_all function starts at the left edge and walks
> > + * towards the right edge of the tree.  Therefore, we know that we can walk up
> > + * the btree cursor towards the root; if the pointer for a given level points
> > + * to the first record/key in that block, we haven't seen this block before;
> > + * and therefore we need to remember that we saw this block in the btree.
> > + *
> > + * So if our btree is:
> > + *
> > + *    4
> > + *  / | \
> > + * 1  2  3
> > + *
> > + * Pretend for this example that each leaf block has 100 btree records.  For
> > + * the first btree record, we'll observe that bc_ptrs[0] == 1, so we record
> > + * that we saw block 1.  Then we observe that bc_ptrs[1] == 1, so we record
> > + * block 4.  The list is [1, 4].
> > + *
> > + * For the second btree record, we see that bc_ptrs[0] == 2, so we exit the
> > + * loop.  The list remains [1, 4].
> > + *
> > + * For the 101st btree record, we've moved onto leaf block 2.  Now
> > + * bc_ptrs[0] == 1 again, so we record that we saw block 2.  We see that
> > + * bc_ptrs[1] == 2, so we exit the loop.  The list is now [1, 4, 2].
> > + *
> > + * For the 102nd record, bc_ptrs[0] == 2, so we continue.
> > + *
> > + * For the 201st record, we've moved on to leaf block 3.  bc_ptrs[0] == 1, so
> > + * we add 3 to the list.  Now it is [1, 4, 2, 3].
> > + *
> > + * For the 300th record we just exit, with the list being [1, 4, 2, 3].
> > + */
> > +
> > +/*
> > + * Record all the buffers pointed to by the btree cursor.  Callers already
> > + * engaged in a btree walk should call this function to capture the list of
> > + * blocks going from the leaf towards the root.
> > + */
> > +int
> > +xfs_bitmap_set_btcur_path(
> > +	struct xfs_bitmap	*bitmap,
> > +	struct xfs_btree_cur	*cur)
> > +{
> > +	struct xfs_buf		*bp;
> > +	xfs_fsblock_t		fsb;
> > +	int			i;
> > +	int			error;
> > +
> > +	for (i = 0; i < cur->bc_nlevels && cur->bc_ptrs[i] == 1; i++) {
> > +		xfs_btree_get_block(cur, i, &bp);
> > +		if (!bp)
> > +			continue;
> > +		fsb = XFS_DADDR_TO_FSB(cur->bc_mp, bp->b_bn);
> > +		error = xfs_bitmap_set(bitmap, fsb, 1);
> 
> Thanks for the comment. It helps explain the bc_ptrs == 1 check above,
> but also highlights that xfs_bitmap_set() essentially allocates entries
> for duplicate values if they exist. Is this handled by the broader
> mechanism, for example, if the rmapbt was corrupted to have multiple
> entries for a particular unused OWN_AG block? Or could we end up leaking
> that corruption over to the agfl?

Right now we're totally dependent on the rmapbt being sane to rebuild
the space metadata.

> I also wonder a bit about memory consumption on filesystems with large
> metadata footprints. We essentially have to allocate one of these for
> every allocation btree block before we can do the disunion and locate
> the agfl-appropriate blocks. If we had a more lookup friendly structure,
> perhaps this could be optimized by filtering out bnobt/cntbt blocks
> during the associated btree walks..?
> 
> Have you thought about reusing something like the new in-core extent
> tree mechanism as a pure in-memory extent store? It's certainly not
> worth reworking something like that right now, but I wonder if we could
> save memory via the denser format (and perhaps benefit from code
> flexibility, reuse, etc.).

Yes, I was thinking about refactoring the iext btree into a more generic
in-core index with 64-bit key so that I could adapt xfs_bitmap to use
it.  In the longer term I would /also/ like to use xfs_bitmap to detect
xfs_buf cache aliasing when multi-block buffers are in use, but that's
further off. :)

As for the memory-intensive record lists in all the btree rebuilders, I
have some ideas around that too -- either find a way to build an
alternate btree and switch the roots over, or (once we gain the ability
to mark an AG unavailable for new allocations) allocate an unlinked
inode, store the records in the page cache pages for the file, and
release it when we're done.

But, that can wait until I've gotten more of this merged, or get bored.
:)

--D

> Brian
> 
> > +		if (error)
> > +			return error;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +/* Collect a btree's block in the bitmap. */
> > +STATIC int
> > +xfs_bitmap_collect_btblock(
> > +	struct xfs_btree_cur	*cur,
> > +	int			level,
> > +	void			*priv)
> > +{
> > +	struct xfs_bitmap	*bitmap = priv;
> > +	struct xfs_buf		*bp;
> > +	xfs_fsblock_t		fsbno;
> > +
> > +	xfs_btree_get_block(cur, level, &bp);
> > +	if (!bp)
> > +		return 0;
> > +
> > +	fsbno = XFS_DADDR_TO_FSB(cur->bc_mp, bp->b_bn);
> > +	return xfs_bitmap_set(bitmap, fsbno, 1);
> > +}
> > +
> > +/* Walk the btree and mark the bitmap wherever a btree block is found. */
> > +int
> > +xfs_bitmap_set_btblocks(
> > +	struct xfs_bitmap	*bitmap,
> > +	struct xfs_btree_cur	*cur)
> > +{
> > +	return xfs_btree_visit_blocks(cur, xfs_bitmap_collect_btblock, bitmap);
> > +}
> > diff --git a/fs/xfs/scrub/bitmap.h b/fs/xfs/scrub/bitmap.h
> > index dad652ee9177..ae8ecbce6fa6 100644
> > --- a/fs/xfs/scrub/bitmap.h
> > +++ b/fs/xfs/scrub/bitmap.h
> > @@ -28,5 +28,9 @@ void xfs_bitmap_destroy(struct xfs_bitmap *bitmap);
> >  
> >  int xfs_bitmap_set(struct xfs_bitmap *bitmap, uint64_t start, uint64_t len);
> >  int xfs_bitmap_disunion(struct xfs_bitmap *bitmap, struct xfs_bitmap *sub);
> > +int xfs_bitmap_set_btcur_path(struct xfs_bitmap *bitmap,
> > +		struct xfs_btree_cur *cur);
> > +int xfs_bitmap_set_btblocks(struct xfs_bitmap *bitmap,
> > +		struct xfs_btree_cur *cur);
> >  
> >  #endif	/* __XFS_SCRUB_BITMAP_H__ */
> > diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
> > index 1e8a17c8e2b9..2670f4cf62f4 100644
> > --- a/fs/xfs/scrub/scrub.c
> > +++ b/fs/xfs/scrub/scrub.c
> > @@ -220,7 +220,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
> >  		.type	= ST_PERAG,
> >  		.setup	= xchk_setup_fs,
> >  		.scrub	= xchk_agfl,
> > -		.repair	= xrep_notsupported,
> > +		.repair	= xrep_agfl,
> >  	},
> >  	[XFS_SCRUB_TYPE_AGI] = {	/* agi */
> >  		.type	= ST_PERAG,
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
