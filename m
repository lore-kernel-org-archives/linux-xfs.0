Return-Path: <SRS0=OPd9=7K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B43CFC433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 28 May 2020 15:11:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7416320814
	for <linux-xfs@archiver.kernel.org>; Thu, 28 May 2020 15:11:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cO5Fgxsa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403881AbgE1PLb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 May 2020 11:11:31 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:50170 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2403787AbgE1PL2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 May 2020 11:11:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590678686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Cbl3/smhXo11wdBB5iusdk6bN6k0KfZhpkDF+HAyt+g=;
        b=cO5FgxsamHKAQq7q3yc60o+QZtlb2MEtbW1K4W//r2iTSGghfuKVEqMCJ4/tTdnmd9xZGl
        wvdDyesZwwvqtWUlOk51MjnLx+QFkjnxT15vhSqUWIKcBZWyuaM1Aa7Vo/GI/Vn5ZPDhns
        /gX+SUWQ1hWvgO+V9TDSw/Fed9sZltM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-227-M9YaMcOWOK6odINXvWBlnw-1; Thu, 28 May 2020 11:11:24 -0400
X-MC-Unique: M9YaMcOWOK6odINXvWBlnw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 247788005AA;
        Thu, 28 May 2020 15:11:23 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A26021A91A;
        Thu, 28 May 2020 15:11:22 +0000 (UTC)
Date:   Thu, 28 May 2020 11:11:21 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] xfs_repair: rebuild inode btrees with bulk loader
Message-ID: <20200528151121.GD17794@bfoster>
References: <158993944270.983175.4120094597556662259.stgit@magnolia>
 <158993947501.983175.11198846141379731761.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158993947501.983175.11198846141379731761.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 19, 2020 at 06:51:15PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use the btree bulk loading functions to rebuild the inode btrees
> and drop the open-coded implementation.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  libxfs/libxfs_api_defs.h |    1 
>  repair/phase5.c          |  642 +++++++++++++++++-----------------------------
>  2 files changed, 240 insertions(+), 403 deletions(-)
> 
> 
...
> diff --git a/repair/phase5.c b/repair/phase5.c
> index e69b042c..38f30753 100644
> --- a/repair/phase5.c
> +++ b/repair/phase5.c
...
> @@ -372,6 +376,11 @@ estimate_ag_bload_slack(
>  		bload->node_slack = 0;
>  }
>  
> +static inline void skip_rebuild(struct bt_rebuild *btr)
> +{
> +	memset(btr, 0, sizeof(struct bt_rebuild));
> +}
> +

Is there any functional purpose to this? It looks like the memset could
be open-coded, but also seems like it could be elided if we just check
hasfinobt() before using the pointer..?

>  /* Initialize a btree rebuild context. */
>  static void
>  init_rebuild(
> @@ -765,48 +774,38 @@ _("Error %d while writing cntbt btree for AG %u.\n"), error, agno);
...
> +
> +/* Copy one incore inode record into the inobt cursor. */
> +static void
> +get_inode_data(
> +	struct xfs_btree_cur		*cur,
> +	struct ino_tree_node		*ino_rec,
> +	struct agi_stat			*agi_stat)
> +{
> +	struct xfs_inobt_rec_incore	*irec = &cur->bc_rec.i;
> +	int				inocnt = 0;
> +	int				finocnt = 0;
> +	int				k;
> +
> +	irec->ir_startino = ino_rec->ino_startnum;
> +	irec->ir_free = ino_rec->ir_free;
> +
> +	for (k = 0; k < sizeof(xfs_inofree_t) * NBBY; k++)  {
> +		ASSERT(is_inode_confirmed(ino_rec, k));
> +
> +		if (is_inode_sparse(ino_rec, k))
>  			continue;
> -
> -		nfinos += rec_nfinos;
> -		ninos += rec_ninos;
> -		num_recs++;
> +		if (is_inode_free(ino_rec, k))
> +			finocnt++;
> +		inocnt++;
>  	}
>  
> -	if (num_recs == 0) {
> -		/*
> -		 * easy corner-case -- no inode records
> -		 */
> -		lptr->num_blocks = 1;
> -		lptr->modulo = 0;
> -		lptr->num_recs_pb = 0;
> -		lptr->num_recs_tot = 0;
> -
> -		btree_curs->num_levels = 1;
> -		btree_curs->num_tot_blocks = btree_curs->num_free_blocks = 1;
> -
> -		setup_cursor(mp, agno, btree_curs);
> +	irec->ir_count = inocnt;
> +	irec->ir_freecount = finocnt;
>  
> -		return;
> -	}
> +	if (xfs_sb_version_hassparseinodes(&cur->bc_mp->m_sb)) {
> +		uint64_t		sparse;
> +		int			spmask;
> +		uint16_t		holemask;
>  
> -	blocks_allocated = lptr->num_blocks = howmany(num_recs,
> -					XR_INOBT_BLOCK_MAXRECS(mp, 0));
> -
> -	lptr->modulo = num_recs % lptr->num_blocks;
> -	lptr->num_recs_pb = num_recs / lptr->num_blocks;
> -	lptr->num_recs_tot = num_recs;
> -	level = 1;
> -
> -	if (lptr->num_blocks > 1)  {
> -		for (; btree_curs->level[level-1].num_blocks > 1
> -				&& level < XFS_BTREE_MAXLEVELS;
> -				level++)  {
> -			lptr = &btree_curs->level[level];
> -			p_lptr = &btree_curs->level[level - 1];
> -			lptr->num_blocks = howmany(p_lptr->num_blocks,
> -				XR_INOBT_BLOCK_MAXRECS(mp, level));
> -			lptr->modulo = p_lptr->num_blocks % lptr->num_blocks;
> -			lptr->num_recs_pb = p_lptr->num_blocks
> -					/ lptr->num_blocks;
> -			lptr->num_recs_tot = p_lptr->num_blocks;
> -
> -			blocks_allocated += lptr->num_blocks;
> +		/*
> +		 * Convert the 64-bit in-core sparse inode state to the
> +		 * 16-bit on-disk holemask.
> +		 */
> +		holemask = 0;
> +		spmask = (1 << XFS_INODES_PER_HOLEMASK_BIT) - 1;
> +		sparse = ino_rec->ir_sparse;
> +		for (k = 0; k < XFS_INOBT_HOLEMASK_BITS; k++) {
> +			if (sparse & spmask) {
> +				ASSERT((sparse & spmask) == spmask);
> +				holemask |= (1 << k);
> +			} else
> +				ASSERT((sparse & spmask) == 0);
> +			sparse >>= XFS_INODES_PER_HOLEMASK_BIT;
>  		}
> +
> +		irec->ir_holemask = holemask;
> +	} else {
> +		irec->ir_holemask = 0;
>  	}
> -	ASSERT(lptr->num_blocks == 1);
> -	btree_curs->num_levels = level;
>  
> -	btree_curs->num_tot_blocks = btree_curs->num_free_blocks
> -			= blocks_allocated;
> +	if (!agi_stat)
> +		return;
>  
> -	setup_cursor(mp, agno, btree_curs);
> +	if (agi_stat->first_agino != NULLAGINO)
> +		agi_stat->first_agino = ino_rec->ino_startnum;

This is initialized to NULLAGINO. When do we ever update it?

> +	agi_stat->freecount += finocnt;
> +	agi_stat->count += inocnt;
> +}
>  
> -	*num_inos = ninos;
> -	*num_free_inos = nfinos;
> +/* Grab one inobt record. */
> +static int
> +get_inobt_record(
> +	struct xfs_btree_cur		*cur,
> +	void				*priv)
> +{
> +	struct bt_rebuild		*rebuild = priv;
>  
> -	return;
> +	get_inode_data(cur, rebuild->ino_rec, rebuild->agi_stat);
> +	rebuild->ino_rec = next_ino_rec(rebuild->ino_rec);
> +	return 0;
>  }
>  
> +/* Rebuild a inobt btree. */
>  static void
> -prop_ino_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
> -	xfs_btnum_t btnum, xfs_agino_t startino, int level)
> +build_inobt(
> +	struct repair_ctx	*sc,
> +	xfs_agnumber_t		agno,
> +	struct bt_rebuild	*btr_ino,
> +	struct agi_stat		*agi_stat)
>  {
> -	struct xfs_btree_block	*bt_hdr;
> -	xfs_inobt_key_t		*bt_key;
> -	xfs_inobt_ptr_t		*bt_ptr;
> -	xfs_agblock_t		agbno;
> -	bt_stat_level_t		*lptr;
> -	const struct xfs_buf_ops *ops = btnum_to_ops(btnum);
>  	int			error;
>  
> -	level++;
> -
> -	if (level >= btree_curs->num_levels)
> -		return;
> -
> -	lptr = &btree_curs->level[level];
> -	bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
> -
> -	if (be16_to_cpu(bt_hdr->bb_numrecs) == 0)  {
> -		/*
> -		 * this only happens once to initialize the
> -		 * first path up the left side of the tree
> -		 * where the agbno's are already set up
> -		 */
> -		prop_ino_cursor(mp, agno, btree_curs, btnum, startino, level);
> -	}
> -
> -	if (be16_to_cpu(bt_hdr->bb_numrecs) ==
> -				lptr->num_recs_pb + (lptr->modulo > 0))  {
> -		/*
> -		 * write out current prev block, grab us a new block,
> -		 * and set the rightsib pointer of current block
> -		 */
> -#ifdef XR_BLD_INO_TRACE
> -		fprintf(stderr, " ino prop agbno %d ", lptr->prev_agbno);
> -#endif
> -		if (lptr->prev_agbno != NULLAGBLOCK)  {
> -			ASSERT(lptr->prev_buf_p != NULL);
> -			libxfs_buf_mark_dirty(lptr->prev_buf_p);
> -			libxfs_buf_relse(lptr->prev_buf_p);
> -		}
> -		lptr->prev_agbno = lptr->agbno;;
> -		lptr->prev_buf_p = lptr->buf_p;
> -		agbno = get_next_blockaddr(agno, level, btree_curs);
> -
> -		bt_hdr->bb_u.s.bb_rightsib = cpu_to_be32(agbno);
> -
> -		error = -libxfs_buf_get(mp->m_dev,
> -				XFS_AGB_TO_DADDR(mp, agno, agbno),
> -				XFS_FSB_TO_BB(mp, 1), &lptr->buf_p);
> -		if (error)
> -			do_error(_("Cannot grab inode btree buffer, err=%d"),
> -					error);
> -		lptr->agbno = agbno;
> +	btr_ino->bload.get_record = get_inobt_record;
> +	btr_ino->bload.claim_block = rebuild_claim_block;
> +	agi_stat->count = agi_stat->freecount = 0;

These are already initialized to zero by the caller. I suppose we might
as well also move the ->first_agino init to where this is allocated.

Otherwise I mostly just have the same general feedback as for the
previous patch (wrt to the get_record() logic and build_[f]inobt()
duplication.

Brian

> +	agi_stat->first_agino = NULLAGINO;
> +	btr_ino->agi_stat = agi_stat;
> +	btr_ino->ino_rec = findfirst_inode_rec(agno);
> +
> +	error = -libxfs_trans_alloc_empty(sc->mp, &sc->tp);
> +	if (error)
> +		do_error(
> +_("Insufficient memory to construct inobt rebuild transaction.\n"));
> +
> +	/* Add all observed inobt records. */
> +	error = -libxfs_btree_bload(btr_ino->cur, &btr_ino->bload, btr_ino);
> +	if (error)
> +		do_error(
> +_("Error %d while creating inobt btree for AG %u.\n"), error, agno);
> +
> +	/* Since we're not writing the AGI yet, no need to commit the cursor */
> +	libxfs_btree_del_cursor(btr_ino->cur, 0);
> +	error = -libxfs_trans_commit(sc->tp);
> +	if (error)
> +		do_error(
> +_("Error %d while writing inobt btree for AG %u.\n"), error, agno);
> +	sc->tp = NULL;
> +}
>  
> -		if (lptr->modulo)
> -			lptr->modulo--;
> +/* Grab one finobt record. */
> +static int
> +get_finobt_record(
> +	struct xfs_btree_cur		*cur,
> +	void				*priv)
> +{
> +	struct bt_rebuild		*rebuild = priv;
>  
> -		/*
> -		 * initialize block header
> -		 */
> -		lptr->buf_p->b_ops = ops;
> -		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
> -		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
> -		libxfs_btree_init_block(mp, lptr->buf_p, btnum,
> -					level, 0, agno);
> +	get_inode_data(cur, rebuild->ino_rec, NULL);
> +	rebuild->ino_rec = next_free_ino_rec(rebuild->ino_rec);
> +	return 0;
> +}
>  
> -		bt_hdr->bb_u.s.bb_leftsib = cpu_to_be32(lptr->prev_agbno);
> +/* Rebuild a finobt btree. */
> +static void
> +build_finobt(
> +	struct repair_ctx	*sc,
> +	xfs_agnumber_t		agno,
> +	struct bt_rebuild	*btr_fino)
> +{
> +	int			error;
>  
> -		/*
> -		 * propagate extent record for first extent in new block up
> -		 */
> -		prop_ino_cursor(mp, agno, btree_curs, btnum, startino, level);
> -	}
> -	/*
> -	 * add inode info to current block
> -	 */
> -	be16_add_cpu(&bt_hdr->bb_numrecs, 1);
> -
> -	bt_key = XFS_INOBT_KEY_ADDR(mp, bt_hdr,
> -				    be16_to_cpu(bt_hdr->bb_numrecs));
> -	bt_ptr = XFS_INOBT_PTR_ADDR(mp, bt_hdr,
> -				    be16_to_cpu(bt_hdr->bb_numrecs),
> -				    M_IGEO(mp)->inobt_mxr[1]);
> -
> -	bt_key->ir_startino = cpu_to_be32(startino);
> -	*bt_ptr = cpu_to_be32(btree_curs->level[level-1].agbno);
> +	btr_fino->bload.get_record = get_finobt_record;
> +	btr_fino->bload.claim_block = rebuild_claim_block;
> +	btr_fino->ino_rec = findfirst_free_inode_rec(agno);
> +
> +	error = -libxfs_trans_alloc_empty(sc->mp, &sc->tp);
> +	if (error)
> +		do_error(
> +_("Insufficient memory to construct finobt rebuild transaction.\n"));
> +
> +	/* Add all observed finobt records. */
> +	error = -libxfs_btree_bload(btr_fino->cur, &btr_fino->bload, btr_fino);
> +	if (error)
> +		do_error(
> +_("Error %d while creating finobt btree for AG %u.\n"), error, agno);
> +
> +	/* Since we're not writing the AGI yet, no need to commit the cursor */
> +	libxfs_btree_del_cursor(btr_fino->cur, 0);
> +	error = -libxfs_trans_commit(sc->tp);
> +	if (error)
> +		do_error(
> +_("Error %d while writing finobt btree for AG %u.\n"), error, agno);
> +	sc->tp = NULL;
>  }
>  
>  /*
>   * XXX: yet more code that can be shared with mkfs, growfs.
>   */
>  static void
> -build_agi(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
> -		bt_status_t *finobt_curs, struct agi_stat *agi_stat)
> +build_agi(
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		agno,
> +	struct bt_rebuild	*btr_ino,
> +	struct bt_rebuild	*btr_fino,
> +	struct agi_stat		*agi_stat)
>  {
> -	xfs_buf_t	*agi_buf;
> -	xfs_agi_t	*agi;
> -	int		i;
> -	int		error;
> +	struct xfs_buf		*agi_buf;
> +	struct xfs_agi		*agi;
> +	int			i;
> +	int			error;
>  
>  	error = -libxfs_buf_get(mp->m_dev,
>  			XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
> @@ -1008,8 +1053,8 @@ build_agi(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
>  		agi->agi_length = cpu_to_be32(mp->m_sb.sb_dblocks -
>  			(xfs_rfsblock_t) mp->m_sb.sb_agblocks * agno);
>  	agi->agi_count = cpu_to_be32(agi_stat->count);
> -	agi->agi_root = cpu_to_be32(btree_curs->root);
> -	agi->agi_level = cpu_to_be32(btree_curs->num_levels);
> +	agi->agi_root = cpu_to_be32(btr_ino->newbt.afake.af_root);
> +	agi->agi_level = cpu_to_be32(btr_ino->newbt.afake.af_levels);
>  	agi->agi_freecount = cpu_to_be32(agi_stat->freecount);
>  	agi->agi_newino = cpu_to_be32(agi_stat->first_agino);
>  	agi->agi_dirino = cpu_to_be32(NULLAGINO);
> @@ -1021,203 +1066,16 @@ build_agi(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
>  		platform_uuid_copy(&agi->agi_uuid, &mp->m_sb.sb_meta_uuid);
>  
>  	if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
> -		agi->agi_free_root = cpu_to_be32(finobt_curs->root);
> -		agi->agi_free_level = cpu_to_be32(finobt_curs->num_levels);
> +		agi->agi_free_root =
> +				cpu_to_be32(btr_fino->newbt.afake.af_root);
> +		agi->agi_free_level =
> +				cpu_to_be32(btr_fino->newbt.afake.af_levels);
>  	}
>  
>  	libxfs_buf_mark_dirty(agi_buf);
>  	libxfs_buf_relse(agi_buf);
>  }
>  
> -/*
> - * rebuilds an inode tree given a cursor.  We're lazy here and call
> - * the routine that builds the agi
> - */
> -static void
> -build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
> -		bt_status_t *btree_curs, xfs_btnum_t btnum,
> -		struct agi_stat *agi_stat)
> -{
> -	xfs_agnumber_t		i;
> -	xfs_agblock_t		j;
> -	xfs_agblock_t		agbno;
> -	xfs_agino_t		first_agino;
> -	struct xfs_btree_block	*bt_hdr;
> -	xfs_inobt_rec_t		*bt_rec;
> -	ino_tree_node_t		*ino_rec;
> -	bt_stat_level_t		*lptr;
> -	const struct xfs_buf_ops *ops = btnum_to_ops(btnum);
> -	xfs_agino_t		count = 0;
> -	xfs_agino_t		freecount = 0;
> -	int			inocnt;
> -	uint8_t			finocnt;
> -	int			k;
> -	int			level = btree_curs->num_levels;
> -	int			spmask;
> -	uint64_t		sparse;
> -	uint16_t		holemask;
> -	int			error;
> -
> -	ASSERT(btnum == XFS_BTNUM_INO || btnum == XFS_BTNUM_FINO);
> -
> -	for (i = 0; i < level; i++)  {
> -		lptr = &btree_curs->level[i];
> -
> -		agbno = get_next_blockaddr(agno, i, btree_curs);
> -		error = -libxfs_buf_get(mp->m_dev,
> -				XFS_AGB_TO_DADDR(mp, agno, agbno),
> -				XFS_FSB_TO_BB(mp, 1), &lptr->buf_p);
> -		if (error)
> -			do_error(_("Cannot grab inode btree buffer, err=%d"),
> -					error);
> -
> -		if (i == btree_curs->num_levels - 1)
> -			btree_curs->root = agbno;
> -
> -		lptr->agbno = agbno;
> -		lptr->prev_agbno = NULLAGBLOCK;
> -		lptr->prev_buf_p = NULL;
> -		/*
> -		 * initialize block header
> -		 */
> -
> -		lptr->buf_p->b_ops = ops;
> -		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
> -		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
> -		libxfs_btree_init_block(mp, lptr->buf_p, btnum, i, 0, agno);
> -	}
> -
> -	/*
> -	 * run along leaf, setting up records.  as we have to switch
> -	 * blocks, call the prop_ino_cursor routine to set up the new
> -	 * pointers for the parent.  that can recurse up to the root
> -	 * if required.  set the sibling pointers for leaf level here.
> -	 */
> -	if (btnum == XFS_BTNUM_FINO)
> -		ino_rec = findfirst_free_inode_rec(agno);
> -	else
> -		ino_rec = findfirst_inode_rec(agno);
> -
> -	if (ino_rec != NULL)
> -		first_agino = ino_rec->ino_startnum;
> -	else
> -		first_agino = NULLAGINO;
> -
> -	lptr = &btree_curs->level[0];
> -
> -	for (i = 0; i < lptr->num_blocks; i++)  {
> -		/*
> -		 * block initialization, lay in block header
> -		 */
> -		lptr->buf_p->b_ops = ops;
> -		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
> -		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
> -		libxfs_btree_init_block(mp, lptr->buf_p, btnum, 0, 0, agno);
> -
> -		bt_hdr->bb_u.s.bb_leftsib = cpu_to_be32(lptr->prev_agbno);
> -		bt_hdr->bb_numrecs = cpu_to_be16(lptr->num_recs_pb +
> -							(lptr->modulo > 0));
> -
> -		if (lptr->modulo > 0)
> -			lptr->modulo--;
> -
> -		if (lptr->num_recs_pb > 0)
> -			prop_ino_cursor(mp, agno, btree_curs, btnum,
> -					ino_rec->ino_startnum, 0);
> -
> -		bt_rec = (xfs_inobt_rec_t *)
> -			  ((char *)bt_hdr + XFS_INOBT_BLOCK_LEN(mp));
> -		for (j = 0; j < be16_to_cpu(bt_hdr->bb_numrecs); j++) {
> -			ASSERT(ino_rec != NULL);
> -			bt_rec[j].ir_startino =
> -					cpu_to_be32(ino_rec->ino_startnum);
> -			bt_rec[j].ir_free = cpu_to_be64(ino_rec->ir_free);
> -
> -			inocnt = finocnt = 0;
> -			for (k = 0; k < sizeof(xfs_inofree_t)*NBBY; k++)  {
> -				ASSERT(is_inode_confirmed(ino_rec, k));
> -
> -				if (is_inode_sparse(ino_rec, k))
> -					continue;
> -				if (is_inode_free(ino_rec, k))
> -					finocnt++;
> -				inocnt++;
> -			}
> -
> -			/*
> -			 * Set the freecount and check whether we need to update
> -			 * the sparse format fields. Otherwise, skip to the next
> -			 * record.
> -			 */
> -			inorec_set_freecount(mp, &bt_rec[j], finocnt);
> -			if (!xfs_sb_version_hassparseinodes(&mp->m_sb))
> -				goto nextrec;
> -
> -			/*
> -			 * Convert the 64-bit in-core sparse inode state to the
> -			 * 16-bit on-disk holemask.
> -			 */
> -			holemask = 0;
> -			spmask = (1 << XFS_INODES_PER_HOLEMASK_BIT) - 1;
> -			sparse = ino_rec->ir_sparse;
> -			for (k = 0; k < XFS_INOBT_HOLEMASK_BITS; k++) {
> -				if (sparse & spmask) {
> -					ASSERT((sparse & spmask) == spmask);
> -					holemask |= (1 << k);
> -				} else
> -					ASSERT((sparse & spmask) == 0);
> -				sparse >>= XFS_INODES_PER_HOLEMASK_BIT;
> -			}
> -
> -			bt_rec[j].ir_u.sp.ir_count = inocnt;
> -			bt_rec[j].ir_u.sp.ir_holemask = cpu_to_be16(holemask);
> -
> -nextrec:
> -			freecount += finocnt;
> -			count += inocnt;
> -
> -			if (btnum == XFS_BTNUM_FINO)
> -				ino_rec = next_free_ino_rec(ino_rec);
> -			else
> -				ino_rec = next_ino_rec(ino_rec);
> -		}
> -
> -		if (ino_rec != NULL)  {
> -			/*
> -			 * get next leaf level block
> -			 */
> -			if (lptr->prev_buf_p != NULL)  {
> -#ifdef XR_BLD_INO_TRACE
> -				fprintf(stderr, "writing inobt agbno %u\n",
> -					lptr->prev_agbno);
> -#endif
> -				ASSERT(lptr->prev_agbno != NULLAGBLOCK);
> -				libxfs_buf_mark_dirty(lptr->prev_buf_p);
> -				libxfs_buf_relse(lptr->prev_buf_p);
> -			}
> -			lptr->prev_buf_p = lptr->buf_p;
> -			lptr->prev_agbno = lptr->agbno;
> -			lptr->agbno = get_next_blockaddr(agno, 0, btree_curs);
> -			bt_hdr->bb_u.s.bb_rightsib = cpu_to_be32(lptr->agbno);
> -
> -			error = -libxfs_buf_get(mp->m_dev,
> -					XFS_AGB_TO_DADDR(mp, agno, lptr->agbno),
> -					XFS_FSB_TO_BB(mp, 1),
> -					&lptr->buf_p);
> -			if (error)
> -				do_error(
> -	_("Cannot grab inode btree buffer, err=%d"),
> -						error);
> -		}
> -	}
> -
> -	if (agi_stat) {
> -		agi_stat->first_agino = first_agino;
> -		agi_stat->count = count;
> -		agi_stat->freecount = freecount;
> -	}
> -}
> -
>  /* rebuild the rmap tree */
>  
>  /*
> @@ -2142,14 +2000,10 @@ phase5_func(
>  {
>  	struct repair_ctx	sc = { .mp = mp, };
>  	struct agi_stat		agi_stat = {0,};
> -	uint64_t		num_inos;
> -	uint64_t		num_free_inos;
> -	uint64_t		finobt_num_inos;
> -	uint64_t		finobt_num_free_inos;
>  	struct bt_rebuild	btr_bno;
>  	struct bt_rebuild	btr_cnt;
> -	bt_status_t		ino_btree_curs;
> -	bt_status_t		fino_btree_curs;
> +	struct bt_rebuild	btr_ino;
> +	struct bt_rebuild	btr_fino;
>  	bt_status_t		rmap_btree_curs;
>  	bt_status_t		refcnt_btree_curs;
>  	int			extra_blocks = 0;
> @@ -2184,19 +2038,8 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
>  			agno);
>  	}
>  
> -	/*
> -	 * ok, now set up the btree cursors for the on-disk btrees (includes
> -	 * pre-allocating all required blocks for the trees themselves)
> -	 */
> -	init_ino_cursor(mp, agno, &ino_btree_curs, &num_inos,
> -			&num_free_inos, 0);
> -
> -	if (xfs_sb_version_hasfinobt(&mp->m_sb))
> -		init_ino_cursor(mp, agno, &fino_btree_curs, &finobt_num_inos,
> -				&finobt_num_free_inos, 1);
> -
> -	sb_icount_ag[agno] += num_inos;
> -	sb_ifree_ag[agno] += num_free_inos;
> +	init_ino_cursors(&sc, agno, num_freeblocks, &sb_icount_ag[agno],
> +			&sb_ifree_ag[agno], &btr_ino, &btr_fino);
>  
>  	/*
>  	 * Set up the btree cursors for the on-disk rmap btrees, which includes
> @@ -2287,34 +2130,27 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
>  			&rmap_btree_curs, &refcnt_btree_curs, lost_fsb);
>  
>  	/*
> -	 * build inode allocation tree.
> +	 * build inode allocation trees.
>  	 */
> -	build_ino_tree(mp, agno, &ino_btree_curs, XFS_BTNUM_INO, &agi_stat);
> -	write_cursor(&ino_btree_curs);
> -
> -	/*
> -	 * build free inode tree
> -	 */
> -	if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
> -		build_ino_tree(mp, agno, &fino_btree_curs,
> -				XFS_BTNUM_FINO, NULL);
> -		write_cursor(&fino_btree_curs);
> -	}
> +	build_inobt(&sc, agno, &btr_ino, &agi_stat);
> +	if (xfs_sb_version_hasfinobt(&mp->m_sb))
> +		build_finobt(&sc, agno, &btr_fino);
>  
>  	/* build the agi */
> -	build_agi(mp, agno, &ino_btree_curs, &fino_btree_curs, &agi_stat);
> +	build_agi(mp, agno, &btr_ino, &btr_fino, &agi_stat);
>  
>  	/*
>  	 * tear down cursors
>  	 */
>  	finish_rebuild(mp, &btr_bno, lost_fsb);
>  	finish_rebuild(mp, &btr_cnt, lost_fsb);
> +	finish_rebuild(mp, &btr_ino, lost_fsb);
> +	if (xfs_sb_version_hasfinobt(&mp->m_sb))
> +		finish_rebuild(mp, &btr_fino, lost_fsb);
>  	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
>  		finish_cursor(&rmap_btree_curs);
>  	if (xfs_sb_version_hasreflink(&mp->m_sb))
>  		finish_cursor(&refcnt_btree_curs);
> -	if (xfs_sb_version_hasfinobt(&mp->m_sb))
> -		finish_cursor(&fino_btree_curs);
>  
>  	/*
>  	 * release the incore per-AG bno/bcnt trees so the extent nodes
> 

