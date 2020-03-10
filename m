Return-Path: <SRS0=iJk4=43=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA434C10F27
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Mar 2020 11:34:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CA5B24684
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Mar 2020 11:34:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bgeEoGAZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbgCJLe2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Mar 2020 07:34:28 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48364 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725937AbgCJLe1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Mar 2020 07:34:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583840066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3XvFQmTCz6vyJUIzxVIX0gfai1Jv+78XZmOz39lh9oE=;
        b=bgeEoGAZE+XMDpzDP6OCUTiUwDCnhr0EfgVht+xBZoY+/e4Ut95eZCW8ylUYhQlEV2Nch3
        TXIklAgiKoVjuGFVQkw3up59uMHg7UUUzqqczaYTy4vEsxfEr4T2wi2Er87yBvirkAXDig
        c7j6rlyOcuyNkuOPmW8/woZy57V/l4c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-475-JfeS1hNlMYe833S2URTiWg-1; Tue, 10 Mar 2020 07:34:22 -0400
X-MC-Unique: JfeS1hNlMYe833S2URTiWg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E71328010EE;
        Tue, 10 Mar 2020 11:34:21 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D710B10013A1;
        Tue, 10 Mar 2020 11:34:18 +0000 (UTC)
Date:   Tue, 10 Mar 2020 07:34:17 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 4/6] xfs: remove XFS_BUF_TO_AGI
Message-ID: <20200310113417.GD50276@bfoster>
References: <20200306145220.242562-1-hch@lst.de>
 <20200306145220.242562-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200306145220.242562-5-hch@lst.de>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 06, 2020 at 07:52:18AM -0700, Christoph Hellwig wrote:
> Just dereference bp->b_addr directly and make the code a little
> simpler and more clear.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_ag.c           |  6 +++---
>  fs/xfs/libxfs/xfs_format.h       |  1 -
>  fs/xfs/libxfs/xfs_ialloc.c       | 27 +++++++++++++--------------
>  fs/xfs/libxfs/xfs_ialloc_btree.c | 10 +++++-----
>  fs/xfs/scrub/agheader.c          |  4 ++--
>  fs/xfs/scrub/agheader_repair.c   |  8 ++++----
>  fs/xfs/xfs_inode.c               |  6 +++---
>  fs/xfs/xfs_log_recover.c         |  6 +++---
>  8 files changed, 33 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index 32ceba66456f..465d0d568411 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -312,7 +312,7 @@ xfs_agiblock_init(
>  	struct xfs_buf		*bp,
>  	struct aghdr_init_data	*id)
>  {
> -	struct xfs_agi		*agi = XFS_BUF_TO_AGI(bp);
> +	struct xfs_agi		*agi = bp->b_addr;
>  	int			bucket;
>  
>  	agi->agi_magicnum = cpu_to_be32(XFS_AGI_MAGIC);
> @@ -502,7 +502,7 @@ xfs_ag_extend_space(
>  	if (error)
>  		return error;
>  
> -	agi = XFS_BUF_TO_AGI(bp);
> +	agi = bp->b_addr;
>  	be32_add_cpu(&agi->agi_length, len);
>  	ASSERT(id->agno == mp->m_sb.sb_agcount - 1 ||
>  	       be32_to_cpu(agi->agi_length) == mp->m_sb.sb_agblocks);
> @@ -569,7 +569,7 @@ xfs_ag_get_geometry(
>  	memset(ageo, 0, sizeof(*ageo));
>  	ageo->ag_number = agno;
>  
> -	agi = XFS_BUF_TO_AGI(agi_bp);
> +	agi = agi_bp->b_addr;
>  	ageo->ag_icount = be32_to_cpu(agi->agi_count);
>  	ageo->ag_ifree = be32_to_cpu(agi->agi_freecount);
>  
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index fe685ad91e0f..5710fed6c75a 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -775,7 +775,6 @@ typedef struct xfs_agi {
>  /* disk block (xfs_daddr_t) in the AG */
>  #define XFS_AGI_DADDR(mp)	((xfs_daddr_t)(2 << (mp)->m_sectbb_log))
>  #define	XFS_AGI_BLOCK(mp)	XFS_HDR_BLOCK(mp, XFS_AGI_DADDR(mp))
> -#define	XFS_BUF_TO_AGI(bp)	((xfs_agi_t *)((bp)->b_addr))
>  
>  /*
>   * The third a.g. block contains the a.g. freelist, an array
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index bf161e930f1d..b4a404278935 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -177,7 +177,7 @@ xfs_inobt_insert(
>  	xfs_btnum_t		btnum)
>  {
>  	struct xfs_btree_cur	*cur;
> -	struct xfs_agi		*agi = XFS_BUF_TO_AGI(agbp);
> +	struct xfs_agi		*agi = agbp->b_addr;
>  	xfs_agnumber_t		agno = be32_to_cpu(agi->agi_seqno);
>  	xfs_agino_t		thisino;
>  	int			i;
> @@ -525,7 +525,7 @@ xfs_inobt_insert_sprec(
>  	bool				merge)	/* merge or replace */
>  {
>  	struct xfs_btree_cur		*cur;
> -	struct xfs_agi			*agi = XFS_BUF_TO_AGI(agbp);
> +	struct xfs_agi			*agi = agbp->b_addr;
>  	xfs_agnumber_t			agno = be32_to_cpu(agi->agi_seqno);
>  	int				error;
>  	int				i;
> @@ -658,7 +658,7 @@ xfs_ialloc_ag_alloc(
>  	 * chunk of inodes.  If the filesystem is striped, this will fill
>  	 * an entire stripe unit with inodes.
>  	 */
> -	agi = XFS_BUF_TO_AGI(agbp);
> +	agi = agbp->b_addr;
>  	newino = be32_to_cpu(agi->agi_newino);
>  	agno = be32_to_cpu(agi->agi_seqno);
>  	args.agbno = XFS_AGINO_TO_AGBNO(args.mp, newino) +
> @@ -1130,7 +1130,7 @@ xfs_dialloc_ag_inobt(
>  	xfs_ino_t		*inop)
>  {
>  	struct xfs_mount	*mp = tp->t_mountp;
> -	struct xfs_agi		*agi = XFS_BUF_TO_AGI(agbp);
> +	struct xfs_agi		*agi = agbp->b_addr;
>  	xfs_agnumber_t		agno = be32_to_cpu(agi->agi_seqno);
>  	xfs_agnumber_t		pagno = XFS_INO_TO_AGNO(mp, parent);
>  	xfs_agino_t		pagino = XFS_INO_TO_AGINO(mp, parent);
> @@ -1583,7 +1583,7 @@ xfs_dialloc_ag(
>  	xfs_ino_t		*inop)
>  {
>  	struct xfs_mount		*mp = tp->t_mountp;
> -	struct xfs_agi			*agi = XFS_BUF_TO_AGI(agbp);
> +	struct xfs_agi			*agi = agbp->b_addr;
>  	xfs_agnumber_t			agno = be32_to_cpu(agi->agi_seqno);
>  	xfs_agnumber_t			pagno = XFS_INO_TO_AGNO(mp, parent);
>  	xfs_agino_t			pagino = XFS_INO_TO_AGINO(mp, parent);
> @@ -1943,7 +1943,7 @@ xfs_difree_inobt(
>  	struct xfs_icluster		*xic,
>  	struct xfs_inobt_rec_incore	*orec)
>  {
> -	struct xfs_agi			*agi = XFS_BUF_TO_AGI(agbp);
> +	struct xfs_agi			*agi = agbp->b_addr;
>  	xfs_agnumber_t			agno = be32_to_cpu(agi->agi_seqno);
>  	struct xfs_perag		*pag;
>  	struct xfs_btree_cur		*cur;
> @@ -2079,7 +2079,7 @@ xfs_difree_finobt(
>  	xfs_agino_t			agino,
>  	struct xfs_inobt_rec_incore	*ibtrec) /* inobt record */
>  {
> -	struct xfs_agi			*agi = XFS_BUF_TO_AGI(agbp);
> +	struct xfs_agi			*agi = agbp->b_addr;
>  	xfs_agnumber_t			agno = be32_to_cpu(agi->agi_seqno);
>  	struct xfs_btree_cur		*cur;
>  	struct xfs_inobt_rec_incore	rec;
> @@ -2489,9 +2489,8 @@ xfs_ialloc_log_agi(
>  		sizeof(xfs_agi_t)
>  	};
>  #ifdef DEBUG
> -	xfs_agi_t		*agi;	/* allocation group header */
> +	struct xfs_agi		*agi = bp->b_addr;
>  
> -	agi = XFS_BUF_TO_AGI(bp);
>  	ASSERT(agi->agi_magicnum == cpu_to_be32(XFS_AGI_MAGIC));
>  #endif
>  
> @@ -2523,14 +2522,13 @@ xfs_agi_verify(
>  	struct xfs_buf	*bp)
>  {
>  	struct xfs_mount *mp = bp->b_mount;
> -	struct xfs_agi	*agi = XFS_BUF_TO_AGI(bp);
> +	struct xfs_agi	*agi = bp->b_addr;
>  	int		i;
>  
>  	if (xfs_sb_version_hascrc(&mp->m_sb)) {
>  		if (!uuid_equal(&agi->agi_uuid, &mp->m_sb.sb_meta_uuid))
>  			return __this_address;
> -		if (!xfs_log_check_lsn(mp,
> -				be64_to_cpu(XFS_BUF_TO_AGI(bp)->agi_lsn)))
> +		if (!xfs_log_check_lsn(mp, be64_to_cpu(agi->agi_lsn)))
>  			return __this_address;
>  	}
>  
> @@ -2593,6 +2591,7 @@ xfs_agi_write_verify(
>  {
>  	struct xfs_mount	*mp = bp->b_mount;
>  	struct xfs_buf_log_item	*bip = bp->b_log_item;
> +	struct xfs_agi		*agi = bp->b_addr;
>  	xfs_failaddr_t		fa;
>  
>  	fa = xfs_agi_verify(bp);
> @@ -2605,7 +2604,7 @@ xfs_agi_write_verify(
>  		return;
>  
>  	if (bip)
> -		XFS_BUF_TO_AGI(bp)->agi_lsn = cpu_to_be64(bip->bli_item.li_lsn);
> +		agi->agi_lsn = cpu_to_be64(bip->bli_item.li_lsn);
>  	xfs_buf_update_cksum(bp, XFS_AGI_CRC_OFF);
>  }
>  
> @@ -2661,7 +2660,7 @@ xfs_ialloc_read_agi(
>  	if (error)
>  		return error;
>  
> -	agi = XFS_BUF_TO_AGI(*bpp);
> +	agi = (*bpp)->b_addr;
>  	pag = xfs_perag_get(mp, agno);
>  	if (!pag->pagi_init) {
>  		pag->pagi_freecount = be32_to_cpu(agi->agi_freecount);
> diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> index b82992f795aa..6903820f1c4b 100644
> --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> @@ -45,7 +45,7 @@ xfs_inobt_set_root(
>  	int			inc)	/* level change */
>  {
>  	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
> -	struct xfs_agi		*agi = XFS_BUF_TO_AGI(agbp);
> +	struct xfs_agi		*agi = agbp->b_addr;
>  
>  	agi->agi_root = nptr->s;
>  	be32_add_cpu(&agi->agi_level, inc);
> @@ -59,7 +59,7 @@ xfs_finobt_set_root(
>  	int			inc)	/* level change */
>  {
>  	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
> -	struct xfs_agi		*agi = XFS_BUF_TO_AGI(agbp);
> +	struct xfs_agi		*agi = agbp->b_addr;
>  
>  	agi->agi_free_root = nptr->s;
>  	be32_add_cpu(&agi->agi_free_level, inc);
> @@ -212,7 +212,7 @@ xfs_inobt_init_ptr_from_cur(
>  	struct xfs_btree_cur	*cur,
>  	union xfs_btree_ptr	*ptr)
>  {
> -	struct xfs_agi		*agi = XFS_BUF_TO_AGI(cur->bc_private.a.agbp);
> +	struct xfs_agi		*agi = cur->bc_private.a.agbp->b_addr;
>  
>  	ASSERT(cur->bc_private.a.agno == be32_to_cpu(agi->agi_seqno));
>  
> @@ -224,7 +224,7 @@ xfs_finobt_init_ptr_from_cur(
>  	struct xfs_btree_cur	*cur,
>  	union xfs_btree_ptr	*ptr)
>  {
> -	struct xfs_agi		*agi = XFS_BUF_TO_AGI(cur->bc_private.a.agbp);
> +	struct xfs_agi		*agi = cur->bc_private.a.agbp->b_addr;
>  
>  	ASSERT(cur->bc_private.a.agno == be32_to_cpu(agi->agi_seqno));
>  	ptr->s = agi->agi_free_root;
> @@ -410,7 +410,7 @@ xfs_inobt_init_cursor(
>  	xfs_agnumber_t		agno,		/* allocation group number */
>  	xfs_btnum_t		btnum)		/* ialloc or free ino btree */
>  {
> -	struct xfs_agi		*agi = XFS_BUF_TO_AGI(agbp);
> +	struct xfs_agi		*agi = agbp->b_addr;
>  	struct xfs_btree_cur	*cur;
>  
>  	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
> diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
> index ba0f747c82e8..a117e10feb82 100644
> --- a/fs/xfs/scrub/agheader.c
> +++ b/fs/xfs/scrub/agheader.c
> @@ -765,7 +765,7 @@ static inline void
>  xchk_agi_xref_icounts(
>  	struct xfs_scrub	*sc)
>  {
> -	struct xfs_agi		*agi = XFS_BUF_TO_AGI(sc->sa.agi_bp);
> +	struct xfs_agi		*agi = sc->sa.agi_bp->b_addr;
>  	xfs_agino_t		icount;
>  	xfs_agino_t		freecount;
>  	int			error;
> @@ -834,7 +834,7 @@ xchk_agi(
>  		goto out;
>  	xchk_buffer_recheck(sc, sc->sa.agi_bp);
>  
> -	agi = XFS_BUF_TO_AGI(sc->sa.agi_bp);
> +	agi = sc->sa.agi_bp->b_addr;
>  
>  	/* Check the AG length */
>  	eoag = be32_to_cpu(agi->agi_length);
> diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> index 6da2e87d19a8..6f0f5ff2cb3f 100644
> --- a/fs/xfs/scrub/agheader_repair.c
> +++ b/fs/xfs/scrub/agheader_repair.c
> @@ -760,7 +760,7 @@ xrep_agi_init_header(
>  	struct xfs_buf		*agi_bp,
>  	struct xfs_agi		*old_agi)
>  {
> -	struct xfs_agi		*agi = XFS_BUF_TO_AGI(agi_bp);
> +	struct xfs_agi		*agi = agi_bp->b_addr;
>  	struct xfs_mount	*mp = sc->mp;
>  
>  	memcpy(old_agi, agi, sizeof(*old_agi));
> @@ -806,7 +806,7 @@ xrep_agi_calc_from_btrees(
>  	struct xfs_buf		*agi_bp)
>  {
>  	struct xfs_btree_cur	*cur;
> -	struct xfs_agi		*agi = XFS_BUF_TO_AGI(agi_bp);
> +	struct xfs_agi		*agi = agi_bp->b_addr;
>  	struct xfs_mount	*mp = sc->mp;
>  	xfs_agino_t		count;
>  	xfs_agino_t		freecount;
> @@ -834,7 +834,7 @@ xrep_agi_commit_new(
>  	struct xfs_buf		*agi_bp)
>  {
>  	struct xfs_perag	*pag;
> -	struct xfs_agi		*agi = XFS_BUF_TO_AGI(agi_bp);
> +	struct xfs_agi		*agi = agi_bp->b_addr;
>  
>  	/* Trigger inode count recalculation */
>  	xfs_force_summary_recalc(sc->mp);
> @@ -891,7 +891,7 @@ xrep_agi(
>  	if (error)
>  		return error;
>  	agi_bp->b_ops = &xfs_agi_buf_ops;
> -	agi = XFS_BUF_TO_AGI(agi_bp);
> +	agi = agi_bp->b_addr;
>  
>  	/* Find the AGI btree roots. */
>  	error = xrep_agi_find_btrees(sc, fab);
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 3324e1696354..addc3ee0cb73 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2117,7 +2117,7 @@ xfs_iunlink_update_bucket(
>  	unsigned int		bucket_index,
>  	xfs_agino_t		new_agino)
>  {
> -	struct xfs_agi		*agi = XFS_BUF_TO_AGI(agibp);
> +	struct xfs_agi		*agi = agibp->b_addr;
>  	xfs_agino_t		old_value;
>  	int			offset;
>  
> @@ -2257,7 +2257,7 @@ xfs_iunlink(
>  	error = xfs_read_agi(mp, tp, agno, &agibp);
>  	if (error)
>  		return error;
> -	agi = XFS_BUF_TO_AGI(agibp);
> +	agi = agibp->b_addr;
>  
>  	/*
>  	 * Get the index into the agi hash table for the list this inode will
> @@ -2441,7 +2441,7 @@ xfs_iunlink_remove(
>  	error = xfs_read_agi(mp, tp, agno, &agibp);
>  	if (error)
>  		return error;
> -	agi = XFS_BUF_TO_AGI(agibp);
> +	agi = agibp->b_addr;
>  
>  	/*
>  	 * Get the index into the agi hash table for the list this inode will
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 25cfc85dbaa7..00d5df5fb26b 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -4947,7 +4947,7 @@ xlog_recover_clear_agi_bucket(
>  	if (error)
>  		goto out_abort;
>  
> -	agi = XFS_BUF_TO_AGI(agibp);
> +	agi = agibp->b_addr;
>  	agi->agi_unlinked[bucket] = cpu_to_be32(NULLAGINO);
>  	offset = offsetof(xfs_agi_t, agi_unlinked) +
>  		 (sizeof(xfs_agino_t) * bucket);
> @@ -5083,7 +5083,7 @@ xlog_recover_process_iunlinks(
>  		 * buffer reference though, so that it stays pinned in memory
>  		 * while we need the buffer.
>  		 */
> -		agi = XFS_BUF_TO_AGI(agibp);
> +		agi = agibp->b_addr;
>  		xfs_buf_unlock(agibp);
>  
>  		for (bucket = 0; bucket < XFS_AGI_UNLINKED_BUCKETS; bucket++) {
> @@ -5840,7 +5840,7 @@ xlog_recover_check_summary(
>  			xfs_alert(mp, "%s agi read failed agno %d error %d",
>  						__func__, agno, error);
>  		} else {
> -			struct xfs_agi	*agi = XFS_BUF_TO_AGI(agibp);
> +			struct xfs_agi	*agi = agibp->b_addr;
>  
>  			itotal += be32_to_cpu(agi->agi_count);
>  			ifree += be32_to_cpu(agi->agi_freecount);
> -- 
> 2.24.1
> 

