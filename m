Return-Path: <SRS0=OEwr=77=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8916C433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Jun 2020 15:25:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9924420888
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Jun 2020 15:25:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jEbFWlf8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731443AbgFRPZS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Jun 2020 11:25:18 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:25432 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727991AbgFRPZR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Jun 2020 11:25:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592493916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=awetAEM/i7GfVYs+ssTar2OURwpmOa7wN6m7aqA5x6Y=;
        b=jEbFWlf8/WWjS4nrMDMbJCTOvoxWHomCVDw2dsfRO7adxIfBKMPJzERbUVEOMfNfgpKg39
        NkN8OWiYKauU2kOKqcd4XxzJDTx5GrrNO7HEJM7pwpTbi076JI7sWNQilzziud2temTJYd
        PCuPx0pTumnJAayahv/EVIyDbfTkWG8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-289-Dh7cplrbNe6DnNr9Qq5sfQ-1; Thu, 18 Jun 2020 11:25:14 -0400
X-MC-Unique: Dh7cplrbNe6DnNr9Qq5sfQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A13BB8005AD;
        Thu, 18 Jun 2020 15:25:13 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4BFFA5C1D6;
        Thu, 18 Jun 2020 15:25:13 +0000 (UTC)
Date:   Thu, 18 Jun 2020 11:25:11 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/12] xfs_repair: rebuild reverse mapping btrees with
 bulk loader
Message-ID: <20200618152511.GC32216@bfoster>
References: <159107201290.315004.4447998785149331259.stgit@magnolia>
 <159107207124.315004.2948634653215669449.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159107207124.315004.2948634653215669449.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 01, 2020 at 09:27:51PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use the btree bulk loading functions to rebuild the reverse mapping
> btrees and drop the open-coded implementation.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  libxfs/libxfs_api_defs.h |    1 
>  repair/agbtree.c         |   70 ++++++++
>  repair/agbtree.h         |    5 +
>  repair/phase5.c          |  409 ++--------------------------------------------
>  4 files changed, 96 insertions(+), 389 deletions(-)
> 
> 
...
> diff --git a/repair/phase5.c b/repair/phase5.c
> index e570349d..1c6448f4 100644
> --- a/repair/phase5.c
> +++ b/repair/phase5.c
...
> @@ -1244,6 +879,8 @@ build_agf_agfl(
>  	freelist = xfs_buf_to_agfl_bno(agfl_buf);
>  	fill_agfl(btr_bno, freelist, &agfl_idx);
>  	fill_agfl(btr_cnt, freelist, &agfl_idx);
> +	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
> +		fill_agfl(btr_rmap, freelist, &agfl_idx);

Is this new behavior? Either way, I guess it makes sense since the
rmapbt feeds from/to the agfl:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  
>  	/* Set the AGF counters for the AGFL. */
>  	if (agfl_idx > 0) {
> @@ -1343,7 +980,7 @@ phase5_func(
>  	struct bt_rebuild	btr_cnt;
>  	struct bt_rebuild	btr_ino;
>  	struct bt_rebuild	btr_fino;
> -	bt_status_t		rmap_btree_curs;
> +	struct bt_rebuild	btr_rmap;
>  	bt_status_t		refcnt_btree_curs;
>  	int			extra_blocks = 0;
>  	uint			num_freeblocks;
> @@ -1378,11 +1015,7 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
>  	init_ino_cursors(&sc, agno, num_freeblocks, &sb_icount_ag[agno],
>  			&sb_ifree_ag[agno], &btr_ino, &btr_fino);
>  
> -	/*
> -	 * Set up the btree cursors for the on-disk rmap btrees, which includes
> -	 * pre-allocating all required blocks.
> -	 */
> -	init_rmapbt_cursor(mp, agno, &rmap_btree_curs);
> +	init_rmapbt_cursor(&sc, agno, num_freeblocks, &btr_rmap);
>  
>  	/*
>  	 * Set up the btree cursors for the on-disk refcount btrees,
> @@ -1448,10 +1081,8 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
>  	ASSERT(btr_bno.freeblks == btr_cnt.freeblks);
>  
>  	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
> -		build_rmap_tree(mp, agno, &rmap_btree_curs);
> -		write_cursor(&rmap_btree_curs);
> -		sb_fdblocks_ag[agno] += (rmap_btree_curs.num_tot_blocks -
> -				rmap_btree_curs.num_free_blocks) - 1;
> +		build_rmap_tree(&sc, agno, &btr_rmap);
> +		sb_fdblocks_ag[agno] += btr_rmap.newbt.afake.af_blocks - 1;
>  	}
>  
>  	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
> @@ -1462,7 +1093,7 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
>  	/*
>  	 * set up agf and agfl
>  	 */
> -	build_agf_agfl(mp, agno, &btr_bno, &btr_cnt, &rmap_btree_curs,
> +	build_agf_agfl(mp, agno, &btr_bno, &btr_cnt, &btr_rmap,
>  			&refcnt_btree_curs, lost_fsb);
>  
>  	build_inode_btrees(&sc, agno, &btr_ino, &btr_fino);
> @@ -1479,7 +1110,7 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
>  	if (xfs_sb_version_hasfinobt(&mp->m_sb))
>  		finish_rebuild(mp, &btr_fino, lost_fsb);
>  	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
> -		finish_cursor(&rmap_btree_curs);
> +		finish_rebuild(mp, &btr_rmap, lost_fsb);
>  	if (xfs_sb_version_hasreflink(&mp->m_sb))
>  		finish_cursor(&refcnt_btree_curs);
>  
> 

