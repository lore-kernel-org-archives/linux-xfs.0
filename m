Return-Path: <SRS0=OPd9=7K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 929DBC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 28 May 2020 17:00:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70E89207BC
	for <linux-xfs@archiver.kernel.org>; Thu, 28 May 2020 17:00:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S7YxUFbL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405254AbgE1RAY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 May 2020 13:00:24 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20602 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2405172AbgE1RAU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 May 2020 13:00:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590685218;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=McrJpp/KPy2sqIfGOuLYS2tLDC3Poi0tqQOWcMeItOs=;
        b=S7YxUFbLhAyYmTsW3Q3NOd4h2lucNQZ883lof3umhr70AnWN/9KxQFZcm1D0M4HPkfALcv
        sbLuLI55gekK+ZZ0wr1wLT1OjIbsGCe40UXLF1pq98p81JjjabQVg/jxkUqnbl9pYWEEFT
        JrQ2ZzVfrXJAvHCXem5zSDKvWHqGYGI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-513-13R56vf7OGyotgqdGlj4aQ-1; Thu, 28 May 2020 13:00:16 -0400
X-MC-Unique: 13R56vf7OGyotgqdGlj4aQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2E5DC107ACF9;
        Thu, 28 May 2020 17:00:15 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8B2455D9CD;
        Thu, 28 May 2020 17:00:14 +0000 (UTC)
Date:   Thu, 28 May 2020 13:00:12 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 9/9] xfs_repair: track blocks lost during btree
 construction via extents
Message-ID: <20200528170012.GE17794@bfoster>
References: <158993944270.983175.4120094597556662259.stgit@magnolia>
 <158993950078.983175.14943057067035503330.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158993950078.983175.14943057067035503330.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 19, 2020 at 06:51:40PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use extent records (not just raw fsbs) to track blocks that were lost
> during btree construction.  This makes it somewhat more efficient.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  repair/phase5.c |   61 ++++++++++++++++++++++++++++++++-----------------------
>  1 file changed, 35 insertions(+), 26 deletions(-)
> 
> 
> diff --git a/repair/phase5.c b/repair/phase5.c
> index 72c6908a..22007275 100644
> --- a/repair/phase5.c
> +++ b/repair/phase5.c
> @@ -45,6 +45,12 @@ struct bt_rebuild {
>  	};
>  };
>  
> +struct lost_fsb {
> +	xfs_fsblock_t		fsbno;
> +	xfs_extlen_t		len;
> +};
> +

Looks reasonable at a glance, but could we call the above structure an
extent and rename lost_fsbs to lost_extents or some such?

Brian

> +
>  /*
>   * extra metadata for the agi
>   */
> @@ -314,21 +320,24 @@ static void
>  finish_rebuild(
>  	struct xfs_mount	*mp,
>  	struct bt_rebuild	*btr,
> -	struct xfs_slab		*lost_fsb)
> +	struct xfs_slab		*lost_fsbs)
>  {
>  	struct xrep_newbt_resv	*resv, *n;
>  
>  	for_each_xrep_newbt_reservation(&btr->newbt, resv, n) {
> -		while (resv->used < resv->len) {
> -			xfs_fsblock_t	fsb = resv->fsbno + resv->used;
> -			int		error;
> +		struct lost_fsb	lost;
> +		int		error;
>  
> -			error = slab_add(lost_fsb, &fsb);
> -			if (error)
> -				do_error(
> +		if (resv->used == resv->len)
> +			continue;
> +
> +		lost.fsbno = resv->fsbno + resv->used;
> +		lost.len = resv->len - resv->used;
> +		error = slab_add(lost_fsbs, &lost);
> +		if (error)
> +			do_error(
>  _("Insufficient memory saving lost blocks.\n"));
> -			resv->used++;
> -		}
> +		resv->used = resv->len;
>  	}
>  
>  	xrep_newbt_destroy(&btr->newbt, 0);
> @@ -1036,7 +1045,7 @@ build_agf_agfl(
>  	int			lostblocks,	/* # blocks that will be lost */
>  	struct bt_rebuild	*btr_rmap,
>  	struct bt_rebuild	*btr_refc,
> -	struct xfs_slab		*lost_fsb)
> +	struct xfs_slab		*lost_fsbs)
>  {
>  	struct extent_tree_node	*ext_ptr;
>  	struct xfs_buf		*agf_buf, *agfl_buf;
> @@ -1253,7 +1262,7 @@ static void
>  phase5_func(
>  	struct xfs_mount	*mp,
>  	xfs_agnumber_t		agno,
> -	struct xfs_slab		*lost_fsb)
> +	struct xfs_slab		*lost_fsbs)
>  {
>  	struct repair_ctx	sc = { .mp = mp, };
>  	struct agi_stat		agi_stat = {0,};
> @@ -1372,7 +1381,7 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
>  	 * set up agf and agfl
>  	 */
>  	build_agf_agfl(mp, agno, &btr_bno, &btr_cnt, freeblks1, extra_blocks,
> -			&btr_rmap, &btr_refc, lost_fsb);
> +			&btr_rmap, &btr_refc, lost_fsbs);
>  
>  	/*
>  	 * build inode allocation trees.
> @@ -1387,15 +1396,15 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
>  	/*
>  	 * tear down cursors
>  	 */
> -	finish_rebuild(mp, &btr_bno, lost_fsb);
> -	finish_rebuild(mp, &btr_cnt, lost_fsb);
> -	finish_rebuild(mp, &btr_ino, lost_fsb);
> +	finish_rebuild(mp, &btr_bno, lost_fsbs);
> +	finish_rebuild(mp, &btr_cnt, lost_fsbs);
> +	finish_rebuild(mp, &btr_ino, lost_fsbs);
>  	if (xfs_sb_version_hasfinobt(&mp->m_sb))
> -		finish_rebuild(mp, &btr_fino, lost_fsb);
> +		finish_rebuild(mp, &btr_fino, lost_fsbs);
>  	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
> -		finish_rebuild(mp, &btr_rmap, lost_fsb);
> +		finish_rebuild(mp, &btr_rmap, lost_fsbs);
>  	if (xfs_sb_version_hasreflink(&mp->m_sb))
> -		finish_rebuild(mp, &btr_refc, lost_fsb);
> +		finish_rebuild(mp, &btr_refc, lost_fsbs);
>  
>  	/*
>  	 * release the incore per-AG bno/bcnt trees so the extent nodes
> @@ -1414,19 +1423,19 @@ inject_lost_blocks(
>  {
>  	struct xfs_trans	*tp = NULL;
>  	struct xfs_slab_cursor	*cur = NULL;
> -	xfs_fsblock_t		*fsb;
> +	struct lost_fsb		*lost;
>  	int			error;
>  
>  	error = init_slab_cursor(lost_fsbs, NULL, &cur);
>  	if (error)
>  		return error;
>  
> -	while ((fsb = pop_slab_cursor(cur)) != NULL) {
> +	while ((lost = pop_slab_cursor(cur)) != NULL) {
>  		error = -libxfs_trans_alloc_rollable(mp, 16, &tp);
>  		if (error)
>  			goto out_cancel;
>  
> -		error = -libxfs_free_extent(tp, *fsb, 1,
> +		error = -libxfs_free_extent(tp, lost->fsbno, lost->len,
>  				&XFS_RMAP_OINFO_ANY_OWNER, XFS_AG_RESV_NONE);
>  		if (error)
>  			goto out_cancel;
> @@ -1447,7 +1456,7 @@ inject_lost_blocks(
>  void
>  phase5(xfs_mount_t *mp)
>  {
> -	struct xfs_slab		*lost_fsb;
> +	struct xfs_slab		*lost_fsbs;
>  	xfs_agnumber_t		agno;
>  	int			error;
>  
> @@ -1490,12 +1499,12 @@ phase5(xfs_mount_t *mp)
>  	if (sb_fdblocks_ag == NULL)
>  		do_error(_("cannot alloc sb_fdblocks_ag buffers\n"));
>  
> -	error = init_slab(&lost_fsb, sizeof(xfs_fsblock_t));
> +	error = init_slab(&lost_fsbs, sizeof(struct lost_fsb));
>  	if (error)
>  		do_error(_("cannot alloc lost block slab\n"));
>  
>  	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++)
> -		phase5_func(mp, agno, lost_fsb);
> +		phase5_func(mp, agno, lost_fsbs);
>  
>  	print_final_rpt();
>  
> @@ -1538,10 +1547,10 @@ _("unable to add AG %u reverse-mapping data to btree.\n"), agno);
>  	 * Put blocks that were unnecessarily reserved for btree
>  	 * reconstruction back into the filesystem free space data.
>  	 */
> -	error = inject_lost_blocks(mp, lost_fsb);
> +	error = inject_lost_blocks(mp, lost_fsbs);
>  	if (error)
>  		do_error(_("Unable to reinsert lost blocks into filesystem.\n"));
> -	free_slab(&lost_fsb);
> +	free_slab(&lost_fsbs);
>  
>  	bad_ino_btree = 0;
>  
> 

