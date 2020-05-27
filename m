Return-Path: <SRS0=YlU2=7J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF76FC433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 27 May 2020 12:18:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5C7F20657
	for <linux-xfs@archiver.kernel.org>; Wed, 27 May 2020 12:18:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SmtvxtCZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbgE0MSO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 May 2020 08:18:14 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45378 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725872AbgE0MSO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 May 2020 08:18:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590581892;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zBvcO6wGbCHXCnZkXdzXlEgBOHlY4nXmK+VisELNC+U=;
        b=SmtvxtCZLBVz+y+OGKpCGaTFhWhNg8ABl1qjZx4iVDSTA7zRxR8gYYyA7CC49CvtmL9R/o
        5B7EpX/EzMQIsKjXiwEeBgcMGPA4HlHtn4wfA6BTYSRhx1uBf+RqukHcnh/Kcu0TY3axvT
        CAfFE1nKc19S8NbeX+a+lkRaTouFpvE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-413-QnOT161eO4a66-V3bvwtjA-1; Wed, 27 May 2020 08:18:08 -0400
X-MC-Unique: QnOT161eO4a66-V3bvwtjA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2D1558014D4;
        Wed, 27 May 2020 12:18:07 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 990D710013D5;
        Wed, 27 May 2020 12:18:06 +0000 (UTC)
Date:   Wed, 27 May 2020 08:18:04 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs_repair: create a new class of btree rebuild
 cursors
Message-ID: <20200527121804.GC12014@bfoster>
References: <158993944270.983175.4120094597556662259.stgit@magnolia>
 <158993946213.983175.9823091723787830102.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158993946213.983175.9823091723787830102.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 19, 2020 at 06:51:02PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create some new support structures and functions to assist phase5 in
> using the btree bulk loader to reconstruct metadata btrees.  This is the
> first step in removing the open-coded rebuilding code.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  repair/phase5.c |  239 ++++++++++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 218 insertions(+), 21 deletions(-)
> 
> 
> diff --git a/repair/phase5.c b/repair/phase5.c
> index 84c05a13..8f5e5f59 100644
> --- a/repair/phase5.c
> +++ b/repair/phase5.c
> @@ -18,6 +18,7 @@
>  #include "progress.h"
>  #include "slab.h"
>  #include "rmap.h"
> +#include "bload.h"
>  
>  /*
>   * we maintain the current slice (path from root to leaf)
...
> @@ -306,6 +324,156 @@ _("error - not enough free space in filesystem\n"));
>  #endif
>  }
>  
...
> +static void
> +consume_freespace(
> +	xfs_agnumber_t		agno,
> +	struct extent_tree_node	*ext_ptr,
> +	uint32_t		len)
> +{
> +	struct extent_tree_node	*bno_ext_ptr;
> +	xfs_agblock_t		new_start = ext_ptr->ex_startblock + len;
> +	xfs_extlen_t		new_len = ext_ptr->ex_blockcount - len;
> +
> +	/* Delete the used-up extent from both extent trees. */
> +#ifdef XR_BLD_FREE_TRACE
> +	fprintf(stderr, "releasing extent: %u [%u %u]\n", agno,
> +			ext_ptr->ex_startblock, ext_ptr->ex_blockcount);
> +#endif
> +	bno_ext_ptr = find_bno_extent(agno, ext_ptr->ex_startblock);
> +	ASSERT(bno_ext_ptr != NULL);
> +	get_bno_extent(agno, bno_ext_ptr);
> +	release_extent_tree_node(bno_ext_ptr);
> +
> +	ext_ptr = get_bcnt_extent(agno, ext_ptr->ex_startblock,
> +			ext_ptr->ex_blockcount);
> +	release_extent_tree_node(ext_ptr);
> +

Not having looked too deeply at the in-core extent tracking structures,
is there any particular reason we unconditionally remove and reinsert
new records each time around? Is it because we're basically changing the
extent index in the tree? If so, comment please (an update to the
comment below is probably fine). :)

> +	/*
> +	 * If we only used part of this last extent, then we must reinsert the
> +	 * extent in the extent trees.
> +	 */
> +	if (new_len > 0) {
> +		add_bno_extent(agno, new_start, new_len);
> +		add_bcnt_extent(agno, new_start, new_len);
> +	}
> +}
> +
> +/* Reserve blocks for the new btree. */
> +static void
> +setup_rebuild(
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		agno,
> +	struct bt_rebuild	*btr,
> +	uint32_t		nr_blocks)
> +{
> +	struct extent_tree_node	*ext_ptr;
> +	uint32_t		blocks_allocated = 0;
> +	uint32_t		len;
> +	int			error;
> +
> +	while (blocks_allocated < nr_blocks)  {
> +		/*
> +		 * Grab the smallest extent and use it up, then get the
> +		 * next smallest.  This mimics the init_*_cursor code.
> +		 */
> +		ext_ptr =  findfirst_bcnt_extent(agno);

Extra whitespace	  ^

> +		if (!ext_ptr)
> +			do_error(
> +_("error - not enough free space in filesystem\n"));
> +
> +		/* Use up the extent we've got. */
> +		len = min(ext_ptr->ex_blockcount, nr_blocks - blocks_allocated);
> +		error = xrep_newbt_add_blocks(&btr->newbt,
> +				XFS_AGB_TO_FSB(mp, agno,
> +					       ext_ptr->ex_startblock),
> +				len);

Alignment.

> +		if (error)
> +			do_error(_("could not set up btree reservation: %s\n"),
> +				strerror(-error));
> +
> +		error = rmap_add_ag_rec(mp, agno, ext_ptr->ex_startblock, len,
> +				btr->newbt.oinfo.oi_owner);
> +		if (error)
> +			do_error(_("could not set up btree rmaps: %s\n"),
> +				strerror(-error));
> +
> +		consume_freespace(agno, ext_ptr, len);
> +		blocks_allocated += len;
> +	}
> +#ifdef XR_BLD_FREE_TRACE
> +	fprintf(stderr, "blocks_allocated = %d\n",
> +		blocks_allocated);
> +#endif
> +}
> +
> +/* Feed one of the new btree blocks to the bulk loader. */
> +static int
> +rebuild_claim_block(
> +	struct xfs_btree_cur	*cur,
> +	union xfs_btree_ptr	*ptr,
> +	void			*priv)
> +{
> +	struct bt_rebuild	*btr = priv;
> +
> +	return xrep_newbt_claim_block(cur, &btr->newbt, ptr);
> +}
> +

Seems like an unnecessary helper, unless this grows more code in later
patches..?

>  static void
>  write_cursor(bt_status_t *curs)
>  {
...
> @@ -2287,28 +2483,29 @@ keep_fsinos(xfs_mount_t *mp)
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

I don't see any reason to add sc here when it's still unused. It's not
as if a single variable is saving complexity somewhere else. I guess
I'll defer to Eric on the approach wrt to the other unused warnings.

Also, what's the purpose of the rmap change below? I'm wondering if that
(along with all of the indentation cleanup) should be its own patch with
appropriate explanation.

Brian

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
> @@ -2516,8 +2713,8 @@ inject_lost_blocks(
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

