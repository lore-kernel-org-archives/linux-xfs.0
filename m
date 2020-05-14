Return-Path: <SRS0=gMH0=64=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8F57C433E2
	for <linux-xfs@archiver.kernel.org>; Thu, 14 May 2020 15:11:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A135205CB
	for <linux-xfs@archiver.kernel.org>; Thu, 14 May 2020 15:11:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Yotn8I1l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbgENPLQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 May 2020 11:11:16 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23600 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727123AbgENPLP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 May 2020 11:11:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589469073;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kkBWGPGmvmMqXD1ngQuUPfnC3lomQGXI8WH9o2U75gc=;
        b=Yotn8I1lTMGT+oNa9z5vQOQXqvwmj/fKgPwaCOPdlmULfLum14cUZupVQ7tFGeHrWj/RM9
        JE/OjI00yCuCE0TtHSgiF31hZFCsv96SsJYVjucUYq92vdPjd38UmcbiEJ2hI4KUX9zdpF
        RAyU9bhJ/BCbF858D2/Ha+oVlk0GAko=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-205-e-CNG0cEOEuUif_0Onf9sw-1; Thu, 14 May 2020 11:11:11 -0400
X-MC-Unique: e-CNG0cEOEuUif_0Onf9sw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3194B800053;
        Thu, 14 May 2020 15:11:10 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8469E10016E8;
        Thu, 14 May 2020 15:11:09 +0000 (UTC)
Date:   Thu, 14 May 2020 11:11:07 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs_repair: create a new class of btree rebuild
 cursors
Message-ID: <20200514151107.GC50849@bfoster>
References: <158904190079.984305.707785748675261111.stgit@magnolia>
 <158904191982.984305.12997847094211521747.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <158904191982.984305.12997847094211521747.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 09, 2020 at 09:31:59AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create some new support structures and functions to assist phase5 in
> using the btree bulk loader to reconstruct metadata btrees.  This is the
> first step in removing the open-coded rebuilding code.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

FYI, unused variable warnings:

phase5.c: In function ‘phase5_func’:
phase5.c:2491:20: warning: unused variable ‘sc’ [-Wunused-variable]
 2491 |  struct repair_ctx sc = { .mp = mp, };
      |                    ^~
At top level:
phase5.c:509:1: warning: ‘finish_rebuild’ defined but not used [-Wunused-function]
  509 | finish_rebuild(
      | ^~~~~~~~~~~~~~
phase5.c:468:1: warning: ‘rebuild_alloc_block’ defined but not used [-Wunused-function]
  468 | rebuild_alloc_block(
      | ^~~~~~~~~~~~~~~~~~~
phase5.c:381:1: warning: ‘setup_rebuild’ defined but not used [-Wunused-function]
  381 | setup_rebuild(
      | ^~~~~~~~~~~~~
phase5.c:366:1: warning: ‘init_rebuild’ defined but not used [-Wunused-function]
  366 | init_rebuild(
      | ^~~~~~~~~~~~

>  repair/phase5.c |  240 ++++++++++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 219 insertions(+), 21 deletions(-)
> 
> 
> diff --git a/repair/phase5.c b/repair/phase5.c
> index f3be15de..7eb24519 100644
> --- a/repair/phase5.c
> +++ b/repair/phase5.c
...
> @@ -306,6 +324,157 @@ _("error - not enough free space in filesystem\n"));
...
> +/* Reserve blocks for the new btree. */
> +static void
> +setup_rebuild(
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		agno,
> +	struct bt_rebuild	*btr,
> +	uint32_t		nr_blocks)
> +{
> +	struct extent_tree_node	*ext_ptr;
> +	struct extent_tree_node	*bno_ext_ptr;
> +	uint32_t		blocks_allocated = 0;
> +	int			error;
> +
> +	/*
> +	 * grab the smallest extent and use it up, then get the
> +	 * next smallest.  This mimics the init_*_cursor code.
> +	 */
> +	ext_ptr =  findfirst_bcnt_extent(agno);
> +
> +	/*
> +	 * set up the free block array
> +	 */
> +	while (blocks_allocated < nr_blocks)  {
> +		uint64_t	len;
> +		xfs_agblock_t	new_start;
> +		xfs_extlen_t	new_len;
> +
> +		if (!ext_ptr)
> +			do_error(
> +_("error - not enough free space in filesystem\n"));
> +
> +		/* Use up the extent we've got. */
> +		len = min(ext_ptr->ex_blockcount,
> +				btr->bload.nr_blocks - blocks_allocated);

What's the difference between the nr_blocks parameter and this one?

> +		error = xrep_newbt_add_reservation(&btr->newbt,
> +				XFS_AGB_TO_FSB(mp, agno,
> +					       ext_ptr->ex_startblock),
> +				len, NULL);
> +		if (error)
> +			do_error(_("could not set up btree reservation: %s\n"),
> +				strerror(-error));
> +		blocks_allocated += len;
> +
> +		error = rmap_add_ag_rec(mp, agno, ext_ptr->ex_startblock, len,
> +				btr->newbt.oinfo.oi_owner);
> +		if (error)
> +			do_error(_("could not set up btree rmaps: %s\n"),
> +				strerror(-error));
> +
> +		/* Figure out if we're putting anything back. */

The remaining extent replacement bits of this loop looks like it could
warrant a little helper and a comment to explain exactly what's
happening at a high level.

Brian

> +		new_start = ext_ptr->ex_startblock + len;
> +		new_len = ext_ptr->ex_blockcount - len;
> +
> +		/* Delete the used-up extent from both extent trees. */
> +#ifdef XR_BLD_FREE_TRACE
> +		fprintf(stderr, "releasing extent: %u [%u %u]\n",
> +			agno, ext_ptr->ex_startblock, ext_ptr->ex_blockcount);
> +#endif
> +		bno_ext_ptr = find_bno_extent(agno, ext_ptr->ex_startblock);
> +		ASSERT(bno_ext_ptr != NULL);
> +		get_bno_extent(agno, bno_ext_ptr);
> +		release_extent_tree_node(bno_ext_ptr);
> +
> +		ext_ptr = get_bcnt_extent(agno, ext_ptr->ex_startblock,
> +				ext_ptr->ex_blockcount);
> +		ASSERT(ext_ptr != NULL);
> +		release_extent_tree_node(ext_ptr);
> +
> +		/*
> +		 * If we only used part of this last extent, then we need only
> +		 * to reinsert the extent in the extent trees and we're done.
> +		 */
> +		if (new_len > 0) {
> +			add_bno_extent(agno, new_start, new_len);
> +			add_bcnt_extent(agno, new_start, new_len);
> +			break;
> +		}
> +
> +		/* Otherwise, find the next biggest extent. */
> +		ext_ptr = findfirst_bcnt_extent(agno);
> +	}
> +#ifdef XR_BLD_FREE_TRACE
> +	fprintf(stderr, "blocks_allocated = %d\n",
> +		blocks_allocated);
> +#endif
> +}
> +
> +/* Feed one of the new btree blocks to the bulk loader. */
> +static int
> +rebuild_alloc_block(
> +	struct xfs_btree_cur	*cur,
> +	union xfs_btree_ptr	*ptr,
> +	void			*priv)
> +{
> +	struct bt_rebuild	*btr = priv;
> +
> +	return xrep_newbt_claim_block(cur, &btr->newbt, ptr);
> +}
> +
>  static void
>  write_cursor(bt_status_t *curs)
>  {
> @@ -336,6 +505,34 @@ finish_cursor(bt_status_t *curs)
>  	free(curs->btree_blocks);
>  }
>  
> +static void
> +finish_rebuild(
> +	struct xfs_mount	*mp,
> +	struct bt_rebuild	*btr)
> +{
> +	struct xrep_newbt_resv	*resv, *n;
> +
> +	for_each_xrep_newbt_reservation(&btr->newbt, resv, n) {
> +		xfs_agnumber_t	agno;
> +		xfs_agblock_t	bno;
> +		xfs_extlen_t	len;
> +
> +		if (resv->used >= resv->len)
> +			continue;
> +
> +		/* XXX: Shouldn't this go on the AGFL? */
> +		/* Put back everything we didn't use. */
> +		bno = XFS_FSB_TO_AGBNO(mp, resv->fsbno + resv->used);
> +		agno = XFS_FSB_TO_AGNO(mp, resv->fsbno + resv->used);
> +		len = resv->len - resv->used;
> +
> +		add_bno_extent(agno, bno, len);
> +		add_bcnt_extent(agno, bno, len);
> +	}
> +
> +	xrep_newbt_destroy(&btr->newbt, 0);
> +}
> +
>  /*
>   * We need to leave some free records in the tree for the corner case of
>   * setting up the AGFL. This may require allocation of blocks, and as
> @@ -2290,28 +2487,29 @@ keep_fsinos(xfs_mount_t *mp)
>  
>  static void
>  phase5_func(
> -	xfs_mount_t	*mp,
> -	xfs_agnumber_t	agno,
> -	struct xfs_slab	*lost_fsb)
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		agno,
> +	struct xfs_slab		*lost_fsb)
>  {
> -	uint64_t	num_inos;
> -	uint64_t	num_free_inos;
> -	uint64_t	finobt_num_inos;
> -	uint64_t	finobt_num_free_inos;
> -	bt_status_t	bno_btree_curs;
> -	bt_status_t	bcnt_btree_curs;
> -	bt_status_t	ino_btree_curs;
> -	bt_status_t	fino_btree_curs;
> -	bt_status_t	rmap_btree_curs;
> -	bt_status_t	refcnt_btree_curs;
> -	int		extra_blocks = 0;
> -	uint		num_freeblocks;
> -	xfs_extlen_t	freeblks1;
> +	struct repair_ctx	sc = { .mp = mp, };
> +	struct agi_stat		agi_stat = {0,};
> +	uint64_t		num_inos;
> +	uint64_t		num_free_inos;
> +	uint64_t		finobt_num_inos;
> +	uint64_t		finobt_num_free_inos;
> +	bt_status_t		bno_btree_curs;
> +	bt_status_t		bcnt_btree_curs;
> +	bt_status_t		ino_btree_curs;
> +	bt_status_t		fino_btree_curs;
> +	bt_status_t		rmap_btree_curs;
> +	bt_status_t		refcnt_btree_curs;
> +	int			extra_blocks = 0;
> +	uint			num_freeblocks;
> +	xfs_extlen_t		freeblks1;
>  #ifdef DEBUG
> -	xfs_extlen_t	freeblks2;
> +	xfs_extlen_t		freeblks2;
>  #endif
> -	xfs_agblock_t	num_extents;
> -	struct agi_stat	agi_stat = {0,};
> +	xfs_agblock_t		num_extents;
>  
>  	if (verbose)
>  		do_log(_("        - agno = %d\n"), agno);
> @@ -2533,8 +2731,8 @@ inject_lost_blocks(
>  		if (error)
>  			goto out_cancel;
>  
> -		error = -libxfs_free_extent(tp, *fsb, 1, &XFS_RMAP_OINFO_AG,
> -					    XFS_AG_RESV_NONE);
> +		error = -libxfs_free_extent(tp, *fsb, 1,
> +				&XFS_RMAP_OINFO_ANY_OWNER, XFS_AG_RESV_NONE);
>  		if (error)
>  			goto out_cancel;
>  
> 

