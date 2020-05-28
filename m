Return-Path: <SRS0=OPd9=7K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5791C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 28 May 2020 15:10:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 947282075F
	for <linux-xfs@archiver.kernel.org>; Thu, 28 May 2020 15:10:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cLh33r9W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403985AbgE1PKw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 May 2020 11:10:52 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38436 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2403881AbgE1PKw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 May 2020 11:10:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590678649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=d7pXtz49T8ClYHgv3QWxiIz6VTVXt9J6AzIBR90ehvI=;
        b=cLh33r9W5p+LQKVRjKKhyHJf5bGgKYG76RSwv0xsbIDdBGQ7/bSOrj3vwsPziMm5JHfBlj
        WwWhwdCK1A4SxE4t10BNPA7IHJ0dAsYzJD4V7ZoKkLk3EGkLGzjzXiirkZNoNQ4d+dQWA1
        mYjdLbBmdIRgB1Zq2z039K9/UaJ6W+g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-yWrf8og4M6-5TqM-WJzT5w-1; Thu, 28 May 2020 11:10:47 -0400
X-MC-Unique: yWrf8og4M6-5TqM-WJzT5w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CC97D18FF664;
        Thu, 28 May 2020 15:10:46 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 66BED610F3;
        Thu, 28 May 2020 15:10:46 +0000 (UTC)
Date:   Thu, 28 May 2020 11:10:44 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/9] xfs_repair: rebuild free space btrees with bulk
 loader
Message-ID: <20200528151044.GC17794@bfoster>
References: <158993944270.983175.4120094597556662259.stgit@magnolia>
 <158993946854.983175.10392092867098415197.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158993946854.983175.10392092867098415197.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 19, 2020 at 06:51:08PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use the btree bulk loading functions to rebuild the free space btrees
> and drop the open-coded implementation.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  libxfs/libxfs_api_defs.h |    3 
>  repair/phase5.c          |  870 +++++++++++++---------------------------------
>  2 files changed, 254 insertions(+), 619 deletions(-)
> 
> 
...
> diff --git a/repair/phase5.c b/repair/phase5.c
> index 8f5e5f59..e69b042c 100644
> --- a/repair/phase5.c
> +++ b/repair/phase5.c
...
> @@ -837,268 +567,202 @@ btnum_to_ops(
...
> +static void
> +init_freespace_cursors(
> +	struct repair_ctx	*sc,
> +	xfs_agnumber_t		agno,
> +	unsigned int		free_space,
> +	unsigned int		*nr_extents,
> +	int			*extra_blocks,
> +	struct bt_rebuild	*btr_bno,
> +	struct bt_rebuild	*btr_cnt)
>  {
> -	xfs_agnumber_t		i;
> -	xfs_agblock_t		j;
> -	struct xfs_btree_block	*bt_hdr;
> -	xfs_alloc_rec_t		*bt_rec;
> -	int			level;
> -	xfs_agblock_t		agbno;
> -	extent_tree_node_t	*ext_ptr;
> -	bt_stat_level_t		*lptr;
> -	xfs_extlen_t		freeblks;
> -	const struct xfs_buf_ops *ops = btnum_to_ops(btnum);
> +	unsigned int		bno_blocks;
> +	unsigned int		cnt_blocks;
>  	int			error;
>  
> -	ASSERT(btnum == XFS_BTNUM_BNO || btnum == XFS_BTNUM_CNT);
> -
> -#ifdef XR_BLD_FREE_TRACE
> -	fprintf(stderr, "in build_freespace_tree, agno = %d\n", agno);
> -#endif
> -	level = btree_curs->num_levels;
> -	freeblks = 0;
> +	init_rebuild(sc, &XFS_RMAP_OINFO_AG, free_space, btr_bno);
> +	init_rebuild(sc, &XFS_RMAP_OINFO_AG, free_space, btr_cnt);
>  
> -	ASSERT(level > 0);
> +	btr_bno->cur = libxfs_allocbt_stage_cursor(sc->mp,
> +			&btr_bno->newbt.afake, agno, XFS_BTNUM_BNO);
> +	btr_cnt->cur = libxfs_allocbt_stage_cursor(sc->mp,
> +			&btr_cnt->newbt.afake, agno, XFS_BTNUM_CNT);
>  
>  	/*
> -	 * initialize the first block on each btree level
> +	 * Now we need to allocate blocks for the free space btrees using the
> +	 * free space records we're about to put in them.  Every record we use
> +	 * can change the shape of the free space trees, so we recompute the
> +	 * btree shape until we stop needing /more/ blocks.  If we have any
> +	 * left over we'll stash them in the AGFL when we're done.
>  	 */
> -	for (i = 0; i < level; i++)  {
> -		lptr = &btree_curs->level[i];
> +	do {
> +		unsigned int	num_freeblocks;
> +
> +		bno_blocks = btr_bno->bload.nr_blocks;
> +		cnt_blocks = btr_cnt->bload.nr_blocks;
>  
> -		agbno = get_next_blockaddr(agno, i, btree_curs);
> -		error = -libxfs_buf_get(mp->m_dev,
> -				XFS_AGB_TO_DADDR(mp, agno, agbno),
> -				XFS_FSB_TO_BB(mp, 1), &lptr->buf_p);
> +		/* Compute how many bnobt blocks we'll need. */
> +		error = -libxfs_btree_bload_compute_geometry(btr_bno->cur,
> +				&btr_bno->bload, *nr_extents);
>  		if (error)
>  			do_error(
...
> +_("Unable to compute free space by block btree geometry, error %d.\n"), -error);
> +
> +		/* Compute how many cntbt blocks we'll need. */
> +		error = -libxfs_btree_bload_compute_geometry(btr_bno->cur,

btr_cnt?							^

> +				&btr_cnt->bload, *nr_extents);
> +		if (error)
> +			do_error(
> +_("Unable to compute free space by length btree geometry, error %d.\n"), -error);
> +
> +		/* We don't need any more blocks, so we're done. */
> +		if (bno_blocks >= btr_bno->bload.nr_blocks &&
> +		    cnt_blocks >= btr_cnt->bload.nr_blocks)
> +			break;
> +
> +		/* Allocate however many more blocks we need this time. */
> +		if (bno_blocks < btr_bno->bload.nr_blocks)
> +			setup_rebuild(sc->mp, agno, btr_bno,
> +					btr_bno->bload.nr_blocks - bno_blocks);
> +		if (cnt_blocks < btr_cnt->bload.nr_blocks)
> +			setup_rebuild(sc->mp, agno, btr_cnt,
> +					btr_cnt->bload.nr_blocks - cnt_blocks);

Hmm, I find the setup_rebuild() name a little confusing when seeing an
init_rebuild() used in the same function. The difference is not apparent
at a glance. Could we rename setup_rebuild() to something more specific?
reserve_blocks() perhaps?

> +
> +		/* Ok, now how many free space records do we have? */
> +		*nr_extents = count_bno_extents_blocks(agno, &num_freeblocks);
> +	} while (1);
> +
> +	*extra_blocks = (bno_blocks - btr_bno->bload.nr_blocks) +
> +			(cnt_blocks - btr_cnt->bload.nr_blocks);
> +}
> +
> +static void
> +get_freesp_data(
> +	struct xfs_btree_cur		*cur,
> +	struct extent_tree_node		*bno_rec,
> +	xfs_agblock_t			*freeblks)
> +{
> +	struct xfs_alloc_rec_incore	*arec = &cur->bc_rec.a;
> +
> +	arec->ar_startblock = bno_rec->ex_startblock;
> +	arec->ar_blockcount = bno_rec->ex_blockcount;
> +	if (freeblks)
> +		*freeblks += bno_rec->ex_blockcount;
> +}
> +
> +/* Grab one bnobt record. */
> +static int
> +get_bnobt_record(
> +	struct xfs_btree_cur		*cur,
> +	void				*priv)
> +{
> +	struct bt_rebuild		*btr = priv;
> +
> +	get_freesp_data(cur, btr->bno_rec, btr->freeblks);
> +	btr->bno_rec = findnext_bno_extent(btr->bno_rec);

We should probably check for NULL here even if we don't expect it to
happen.

Also, this logic where we load the current pointer and get the next had
my eyes crossed for a bit. Can we just check the pointer state here to
determine whether to find the first record or the next?

Finally, I notice we duplicate the build_[bno|cnt]bt() functions for
what amounts to a different get_record() callback specific to the tree
type. If we also generalize get_record() to use the tree type (it
already has the cursor), it seems that much of the duplication can be
reduced and the logic simplified.

> +	return 0;
> +}
> +
> +/* Rebuild a free space by block number btree. */
> +static void
> +build_bnobt(
> +	struct repair_ctx	*sc,
> +	xfs_agnumber_t		agno,
> +	struct bt_rebuild	*btr_bno,
> +	xfs_agblock_t		*freeblks)
> +{
> +	int			error;
> +
> +	*freeblks = 0;
> +	btr_bno->bload.get_record = get_bnobt_record;
> +	btr_bno->bload.claim_block = rebuild_claim_block;

Note that one of these callbacks is introduced in this patch and the
other in the previous. I've no issue with splitting the patches as noted
in the previous patch, but these should probably be consistent one way
or the other.

> +	btr_bno->bno_rec = findfirst_bno_extent(agno);
> +	btr_bno->freeblks = freeblks;
> +
> +	error = -libxfs_trans_alloc_empty(sc->mp, &sc->tp);
> +	if (error)
> +		do_error(
> +_("Insufficient memory to construct bnobt rebuild transaction.\n"));
> +
> +	/* Add all observed bnobt records. */
> +	error = -libxfs_btree_bload(btr_bno->cur, &btr_bno->bload, btr_bno);
> +	if (error)
> +		do_error(
> +_("Error %d while creating bnobt btree for AG %u.\n"), error, agno);
> +
> +	/* Since we're not writing the AGF yet, no need to commit the cursor */
> +	libxfs_btree_del_cursor(btr_bno->cur, 0);
> +	error = -libxfs_trans_commit(sc->tp);
> +	if (error)
> +		do_error(
> +_("Error %d while writing bnobt btree for AG %u.\n"), error, agno);
> +	sc->tp = NULL;
> +}
> +
...
> @@ -2354,48 +2041,14 @@ build_agf_agfl(
>  			freelist[i] = cpu_to_be32(NULLAGBLOCK);
>  	}
>  
> -	/*
> -	 * do we have left-over blocks in the btree cursors that should
> -	 * be used to fill the AGFL?
> -	 */
> -	if (bno_bt->num_free_blocks > 0 || bcnt_bt->num_free_blocks > 0)  {
> -		/*
> -		 * yes, now grab as many blocks as we can
> -		 */
> -		i = 0;
> -		while (bno_bt->num_free_blocks > 0 && i < libxfs_agfl_size(mp))
> -		{
> -			freelist[i] = cpu_to_be32(
> -					get_next_blockaddr(agno, 0, bno_bt));
> -			i++;
> -		}
> -
> -		while (bcnt_bt->num_free_blocks > 0 && i < libxfs_agfl_size(mp))
> -		{
> -			freelist[i] = cpu_to_be32(
> -					get_next_blockaddr(agno, 0, bcnt_bt));
> -			i++;
> -		}
> -		/*
> -		 * now throw the rest of the blocks away and complain
> -		 */
> -		while (bno_bt->num_free_blocks > 0) {
> -			fsb = XFS_AGB_TO_FSB(mp, agno,
> -					get_next_blockaddr(agno, 0, bno_bt));
> -			error = slab_add(lost_fsb, &fsb);
> -			if (error)
> -				do_error(
> -_("Insufficient memory saving lost blocks.\n"));
> -		}
> -		while (bcnt_bt->num_free_blocks > 0) {
> -			fsb = XFS_AGB_TO_FSB(mp, agno,
> -					get_next_blockaddr(agno, 0, bcnt_bt));
> -			error = slab_add(lost_fsb, &fsb);
> -			if (error)
> -				do_error(
> -_("Insufficient memory saving lost blocks.\n"));
> -		}
> +	/* Fill the AGFL with leftover blocks or save them for later. */
> +	i = 0;

How about agfl_idx or something since this variable is passed down into
a function?

> +	freelist = xfs_buf_to_agfl_bno(agfl_buf);
> +	fill_agfl(btr_bno, freelist, &i);
> +	fill_agfl(btr_cnt, freelist, &i);
>  
> +	/* Set the AGF counters for the AGFL. */
> +	if (i > 0) {
>  		agf->agf_flfirst = 0;
>  		agf->agf_fllast = cpu_to_be32(i - 1);
>  		agf->agf_flcount = cpu_to_be32(i);
...
> @@ -2650,9 +2283,9 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
>  	/*
>  	 * set up agf and agfl
>  	 */
> -	build_agf_agfl(mp, agno, &bno_btree_curs,
> -		&bcnt_btree_curs, freeblks1, extra_blocks,
> -		&rmap_btree_curs, &refcnt_btree_curs, lost_fsb);
> +	build_agf_agfl(mp, agno, &btr_bno, &btr_cnt, freeblks1, extra_blocks,
> +			&rmap_btree_curs, &refcnt_btree_curs, lost_fsb);
> +

I was trying to figure out what extra_blocks was used for and noticed
that it's not even used by this function. Perhaps a preceding cleanup
patch to drop it?

>  	/*
>  	 * build inode allocation tree.
>  	 */
> @@ -2674,15 +2307,14 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
>  	/*
>  	 * tear down cursors
>  	 */
> -	finish_cursor(&bno_btree_curs);
> -	finish_cursor(&ino_btree_curs);

Looks like this one shouldn't be going away here.

Brian

> +	finish_rebuild(mp, &btr_bno, lost_fsb);
> +	finish_rebuild(mp, &btr_cnt, lost_fsb);
>  	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
>  		finish_cursor(&rmap_btree_curs);
>  	if (xfs_sb_version_hasreflink(&mp->m_sb))
>  		finish_cursor(&refcnt_btree_curs);
>  	if (xfs_sb_version_hasfinobt(&mp->m_sb))
>  		finish_cursor(&fino_btree_curs);
> -	finish_cursor(&bcnt_btree_curs);
>  
>  	/*
>  	 * release the incore per-AG bno/bcnt trees so the extent nodes
> 

