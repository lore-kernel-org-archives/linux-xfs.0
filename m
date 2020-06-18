Return-Path: <SRS0=OEwr=77=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD3E4C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Jun 2020 15:26:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C6702075E
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Jun 2020 15:26:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ss7uyirc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbgFRP0Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Jun 2020 11:26:24 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26943 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727841AbgFRP0X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Jun 2020 11:26:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592493982;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RA5s0lvYR+XfQK+NQXseUEv/2zWoh09bPNWnr3o4z2g=;
        b=Ss7uyircjGTuB0S/SvuxqIO/CPHmhZ4tPY0IYr3qEQSRF2KG17hFI2dZSegIi3sKJu2nAg
        HQzxyH0nyEpr2i8sgasTDGwEDTyYL+qOhj0ToF2RePLzaRvb2qpJWQmrRB4VnezV+WmMlW
        RjTdlcIzuzHo4QqiQMjpcpKgnAxDlaw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-210-8_mCHWheO9KD7Xxdiz7tcQ-1; Thu, 18 Jun 2020 11:26:20 -0400
X-MC-Unique: 8_mCHWheO9KD7Xxdiz7tcQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 50F94107BEFA;
        Thu, 18 Jun 2020 15:26:19 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D5B461002388;
        Thu, 18 Jun 2020 15:26:18 +0000 (UTC)
Date:   Thu, 18 Jun 2020 11:26:17 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/12] xfs_repair: rebuild refcount btrees with bulk
 loader
Message-ID: <20200618152617.GD32216@bfoster>
References: <159107201290.315004.4447998785149331259.stgit@magnolia>
 <159107207766.315004.3208486320108630923.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159107207766.315004.3208486320108630923.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 01, 2020 at 09:27:57PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use the btree bulk loading functions to rebuild the refcount btrees
> and drop the open-coded implementation.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  libxfs/libxfs_api_defs.h |    1 
>  repair/agbtree.c         |   71 ++++++++++
>  repair/agbtree.h         |    5 +
>  repair/phase5.c          |  341 ++--------------------------------------------
>  4 files changed, 93 insertions(+), 325 deletions(-)
> 
> 
...
> diff --git a/repair/phase5.c b/repair/phase5.c
> index 1c6448f4..ad009416 100644
> --- a/repair/phase5.c
> +++ b/repair/phase5.c
...
> @@ -817,10 +510,14 @@ build_agf_agfl(
>  				cpu_to_be32(btr_rmap->newbt.afake.af_blocks);
>  	}
>  
> -	agf->agf_refcount_root = cpu_to_be32(refcnt_bt->root);
> -	agf->agf_refcount_level = cpu_to_be32(refcnt_bt->num_levels);
> -	agf->agf_refcount_blocks = cpu_to_be32(refcnt_bt->num_tot_blocks -
> -			refcnt_bt->num_free_blocks);
> +	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
> +		agf->agf_refcount_root =
> +				cpu_to_be32(btr_refc->newbt.afake.af_root);
> +		agf->agf_refcount_level =
> +				cpu_to_be32(btr_refc->newbt.afake.af_levels);
> +		agf->agf_refcount_blocks =
> +				cpu_to_be32(btr_refc->newbt.afake.af_blocks);
> +	}

It looks like the previous cursor variant (refcnt_bt) would be zeroed
out if the feature isn't enabled (causing this to zero out the agf
fields on disk), whereas now we only write the fields when the feature
is enabled. Any concern over removing that zeroing behavior? Also note
that an assert further down unconditionally reads the
->agf_refcount_root field.

BTW, I suppose the same question may apply to the previous patch as
well...

Brian

>  
>  	/*
>  	 * Count and record the number of btree blocks consumed if required.
> @@ -981,7 +678,7 @@ phase5_func(
>  	struct bt_rebuild	btr_ino;
>  	struct bt_rebuild	btr_fino;
>  	struct bt_rebuild	btr_rmap;
> -	bt_status_t		refcnt_btree_curs;
> +	struct bt_rebuild	btr_refc;
>  	int			extra_blocks = 0;
>  	uint			num_freeblocks;
>  	xfs_agblock_t		num_extents;
> @@ -1017,11 +714,7 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
>  
>  	init_rmapbt_cursor(&sc, agno, num_freeblocks, &btr_rmap);
>  
> -	/*
> -	 * Set up the btree cursors for the on-disk refcount btrees,
> -	 * which includes pre-allocating all required blocks.
> -	 */
> -	init_refc_cursor(mp, agno, &refcnt_btree_curs);
> +	init_refc_cursor(&sc, agno, num_freeblocks, &btr_refc);
>  
>  	num_extents = count_bno_extents_blocks(agno, &num_freeblocks);
>  	/*
> @@ -1085,16 +778,14 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
>  		sb_fdblocks_ag[agno] += btr_rmap.newbt.afake.af_blocks - 1;
>  	}
>  
> -	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
> -		build_refcount_tree(mp, agno, &refcnt_btree_curs);
> -		write_cursor(&refcnt_btree_curs);
> -	}
> +	if (xfs_sb_version_hasreflink(&mp->m_sb))
> +		build_refcount_tree(&sc, agno, &btr_refc);
>  
>  	/*
>  	 * set up agf and agfl
>  	 */
> -	build_agf_agfl(mp, agno, &btr_bno, &btr_cnt, &btr_rmap,
> -			&refcnt_btree_curs, lost_fsb);
> +	build_agf_agfl(mp, agno, &btr_bno, &btr_cnt, &btr_rmap, &btr_refc,
> +			lost_fsb);
>  
>  	build_inode_btrees(&sc, agno, &btr_ino, &btr_fino);
>  
> @@ -1112,7 +803,7 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
>  	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
>  		finish_rebuild(mp, &btr_rmap, lost_fsb);
>  	if (xfs_sb_version_hasreflink(&mp->m_sb))
> -		finish_cursor(&refcnt_btree_curs);
> +		finish_rebuild(mp, &btr_refc, lost_fsb);
>  
>  	/*
>  	 * release the incore per-AG bno/bcnt trees so the extent nodes
> 

