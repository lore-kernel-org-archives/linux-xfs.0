Return-Path: <SRS0=O+9a=AA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AEE0C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Jun 2020 11:12:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D77892080C
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Jun 2020 11:12:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dQoOgfGT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732574AbgFSLL5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Jun 2020 07:11:57 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:33975 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732588AbgFSLLQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Jun 2020 07:11:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592565052;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yNxawvTutXZ+5uJfem1ze84V209XLEUo3wX7SsgbaE0=;
        b=dQoOgfGTsI5zMWWBqZbFvuh1LpHx5/JWRjmie58e9cTMs8Qv5a0a0wW2CbpPD1FpXY4oLR
        DDKgzmZIde8mLFCWJnChUAcz+iGgjRFaiMtVpwtLChh4028UHciGzO5s5xGPA+HbyPNGt1
        SozhTqyp5B5Y6D1l0seKw6r/6NNrz8s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-qvN41upeOiu4CQAcWL9jdg-1; Fri, 19 Jun 2020 07:10:50 -0400
X-MC-Unique: qvN41upeOiu4CQAcWL9jdg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 95A281800D42;
        Fri, 19 Jun 2020 11:10:49 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3F60019D61;
        Fri, 19 Jun 2020 11:10:49 +0000 (UTC)
Date:   Fri, 19 Jun 2020 07:10:47 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/12] xfs_repair: use bitmap to track blocks lost during
 btree construction
Message-ID: <20200619111047.GB36770@bfoster>
References: <159107201290.315004.4447998785149331259.stgit@magnolia>
 <159107209039.315004.11590903544086845302.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159107209039.315004.11590903544086845302.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 01, 2020 at 09:28:10PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use the incore bitmap structure to track blocks that were lost
> during btree construction.  This makes it somewhat more efficient.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  repair/agbtree.c |   21 ++++++++--------
>  repair/agbtree.h |    2 +-
>  repair/phase5.c  |   72 ++++++++++++++++++++++--------------------------------
>  3 files changed, 41 insertions(+), 54 deletions(-)
> 
> 
...
> diff --git a/repair/phase5.c b/repair/phase5.c
> index 439c1065..446f7ec0 100644
> --- a/repair/phase5.c
> +++ b/repair/phase5.c
...
> @@ -211,7 +212,7 @@ build_agf_agfl(
>  	struct bt_rebuild	*btr_cnt,
>  	struct bt_rebuild	*btr_rmap,
>  	struct bt_rebuild	*btr_refc,
> -	struct xfs_slab		*lost_fsb)
> +	struct bitmap		*lost_blocks)
>  {

Looks like another case of an unused parameter here, otherwise looks
good:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  	struct extent_tree_node	*ext_ptr;
>  	struct xfs_buf		*agf_buf, *agfl_buf;
> @@ -428,7 +429,7 @@ static void
>  phase5_func(
>  	struct xfs_mount	*mp,
>  	xfs_agnumber_t		agno,
> -	struct xfs_slab		*lost_fsb)
> +	struct bitmap		*lost_blocks)
>  {
>  	struct repair_ctx	sc = { .mp = mp, };
>  	struct bt_rebuild	btr_bno;
> @@ -543,7 +544,7 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
>  	 * set up agf and agfl
>  	 */
>  	build_agf_agfl(mp, agno, &btr_bno, &btr_cnt, &btr_rmap, &btr_refc,
> -			lost_fsb);
> +			lost_blocks);
>  
>  	build_inode_btrees(&sc, agno, &btr_ino, &btr_fino);
>  
> @@ -553,15 +554,15 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
>  	/*
>  	 * tear down cursors
>  	 */
> -	finish_rebuild(mp, &btr_bno, lost_fsb);
> -	finish_rebuild(mp, &btr_cnt, lost_fsb);
> -	finish_rebuild(mp, &btr_ino, lost_fsb);
> +	finish_rebuild(mp, &btr_bno, lost_blocks);
> +	finish_rebuild(mp, &btr_cnt, lost_blocks);
> +	finish_rebuild(mp, &btr_ino, lost_blocks);
>  	if (xfs_sb_version_hasfinobt(&mp->m_sb))
> -		finish_rebuild(mp, &btr_fino, lost_fsb);
> +		finish_rebuild(mp, &btr_fino, lost_blocks);
>  	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
> -		finish_rebuild(mp, &btr_rmap, lost_fsb);
> +		finish_rebuild(mp, &btr_rmap, lost_blocks);
>  	if (xfs_sb_version_hasreflink(&mp->m_sb))
> -		finish_rebuild(mp, &btr_refc, lost_fsb);
> +		finish_rebuild(mp, &btr_refc, lost_blocks);
>  
>  	/*
>  	 * release the incore per-AG bno/bcnt trees so the extent nodes
> @@ -572,48 +573,33 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
>  	PROG_RPT_INC(prog_rpt_done[agno], 1);
>  }
>  
> -/* Inject lost blocks back into the filesystem. */
> +/* Inject this unused space back into the filesystem. */
>  static int
> -inject_lost_blocks(
> -	struct xfs_mount	*mp,
> -	struct xfs_slab		*lost_fsbs)
> +inject_lost_extent(
> +	uint64_t		start,
> +	uint64_t		length,
> +	void			*arg)
>  {
> -	struct xfs_trans	*tp = NULL;
> -	struct xfs_slab_cursor	*cur = NULL;
> -	xfs_fsblock_t		*fsb;
> +	struct xfs_mount	*mp = arg;
> +	struct xfs_trans	*tp;
>  	int			error;
>  
> -	error = init_slab_cursor(lost_fsbs, NULL, &cur);
> +	error = -libxfs_trans_alloc_rollable(mp, 16, &tp);
>  	if (error)
>  		return error;
>  
> -	while ((fsb = pop_slab_cursor(cur)) != NULL) {
> -		error = -libxfs_trans_alloc_rollable(mp, 16, &tp);
> -		if (error)
> -			goto out_cancel;
> -
> -		error = -libxfs_free_extent(tp, *fsb, 1,
> -				&XFS_RMAP_OINFO_ANY_OWNER, XFS_AG_RESV_NONE);
> -		if (error)
> -			goto out_cancel;
> -
> -		error = -libxfs_trans_commit(tp);
> -		if (error)
> -			goto out_cancel;
> -		tp = NULL;
> -	}
> +	error = -libxfs_free_extent(tp, start, length,
> +			&XFS_RMAP_OINFO_ANY_OWNER, XFS_AG_RESV_NONE);
> +	if (error)
> +		return error;
>  
> -out_cancel:
> -	if (tp)
> -		libxfs_trans_cancel(tp);
> -	free_slab_cursor(&cur);
> -	return error;
> +	return -libxfs_trans_commit(tp);
>  }
>  
>  void
>  phase5(xfs_mount_t *mp)
>  {
> -	struct xfs_slab		*lost_fsb;
> +	struct bitmap		*lost_blocks = NULL;
>  	xfs_agnumber_t		agno;
>  	int			error;
>  
> @@ -656,12 +642,12 @@ phase5(xfs_mount_t *mp)
>  	if (sb_fdblocks_ag == NULL)
>  		do_error(_("cannot alloc sb_fdblocks_ag buffers\n"));
>  
> -	error = init_slab(&lost_fsb, sizeof(xfs_fsblock_t));
> +	error = bitmap_alloc(&lost_blocks);
>  	if (error)
> -		do_error(_("cannot alloc lost block slab\n"));
> +		do_error(_("cannot alloc lost block bitmap\n"));
>  
>  	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++)
> -		phase5_func(mp, agno, lost_fsb);
> +		phase5_func(mp, agno, lost_blocks);
>  
>  	print_final_rpt();
>  
> @@ -704,10 +690,10 @@ _("unable to add AG %u reverse-mapping data to btree.\n"), agno);
>  	 * Put blocks that were unnecessarily reserved for btree
>  	 * reconstruction back into the filesystem free space data.
>  	 */
> -	error = inject_lost_blocks(mp, lost_fsb);
> +	error = bitmap_iterate(lost_blocks, inject_lost_extent, mp);
>  	if (error)
>  		do_error(_("Unable to reinsert lost blocks into filesystem.\n"));
> -	free_slab(&lost_fsb);
> +	bitmap_free(&lost_blocks);
>  
>  	bad_ino_btree = 0;
>  
> 

