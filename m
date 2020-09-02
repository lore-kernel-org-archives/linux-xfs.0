Return-Path: <SRS0=53rf=CL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23F6CC433E7
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 13:35:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE70F20767
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 13:35:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OsY65A39"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbgIBNeq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Sep 2020 09:34:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53969 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727788AbgIBNcb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Sep 2020 09:32:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599053527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bEV0Bl3l9XLU6AnDg5PrZe7IUg+U/S44plxe3s818gY=;
        b=OsY65A3974+7WuzeuQhw9O0f9dkcslalvMssU9jdo2Syd2MJdqaa5hxJ7yjyZjliYPU0mZ
        ZC946PzIIKcZV9YX87iDA2X1iApdGaq4DGLRFf4LuLEB4t/UaVlJYJa4g9MX5tQFUyAGva
        /tA9mum6tMn7RyfQZ3VRfymTTl2kt6Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-361-KGj8x15TN-qMzKzqEFoBAA-1; Wed, 02 Sep 2020 09:23:52 -0400
X-MC-Unique: KGj8x15TN-qMzKzqEFoBAA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 77190640A4;
        Wed,  2 Sep 2020 13:23:51 +0000 (UTC)
Received: from bfoster (ovpn-113-130.rdu2.redhat.com [10.10.113.130])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1AB007EEC9;
        Wed,  2 Sep 2020 13:23:51 +0000 (UTC)
Date:   Wed, 2 Sep 2020 09:23:49 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: support inode btree blockcounts in online repair
Message-ID: <20200902132349.GB289426@bfoster>
References: <159901535219.547164.1381621861988558776.stgit@magnolia>
 <159901537765.547164.7777551130535148618.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159901537765.547164.7777551130535148618.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 01, 2020 at 07:56:17PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add the necessary bits to the online repair code to support logging the
> inode btree counters when rebuilding the btrees, and to support fixing
> the counters when rebuilding the AGI.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_ialloc_btree.c |   16 +++++++++++++---
>  fs/xfs/scrub/agheader_repair.c   |   24 ++++++++++++++++++++++++
>  2 files changed, 37 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> index 1df04e48bd87..219f57f4b5a7 100644
> --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> @@ -504,19 +504,29 @@ xfs_inobt_commit_staged_btree(
>  {
>  	struct xfs_agi		*agi = agbp->b_addr;
>  	struct xbtree_afakeroot	*afake = cur->bc_ag.afake;
> +	int			fields;
>  
>  	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
>  
>  	if (cur->bc_btnum == XFS_BTNUM_INO) {
> +		fields = XFS_AGI_ROOT | XFS_AGI_LEVEL;
>  		agi->agi_root = cpu_to_be32(afake->af_root);
>  		agi->agi_level = cpu_to_be32(afake->af_levels);
> -		xfs_ialloc_log_agi(tp, agbp, XFS_AGI_ROOT | XFS_AGI_LEVEL);
> +		if (xfs_sb_version_hasinobtcounts(&cur->bc_mp->m_sb)) {
> +			agi->agi_iblocks = cpu_to_be32(afake->af_blocks);
> +			fields |= XFS_AGI_IBLOCKS;
> +		}
> +		xfs_ialloc_log_agi(tp, agbp, fields);
>  		xfs_btree_commit_afakeroot(cur, tp, agbp, &xfs_inobt_ops);
>  	} else {
> +		fields = XFS_AGI_FREE_ROOT | XFS_AGI_FREE_LEVEL;
>  		agi->agi_free_root = cpu_to_be32(afake->af_root);
>  		agi->agi_free_level = cpu_to_be32(afake->af_levels);
> -		xfs_ialloc_log_agi(tp, agbp, XFS_AGI_FREE_ROOT |
> -					     XFS_AGI_FREE_LEVEL);
> +		if (xfs_sb_version_hasinobtcounts(&cur->bc_mp->m_sb)) {
> +			agi->agi_fblocks = cpu_to_be32(afake->af_blocks);
> +			fields |= XFS_AGI_IBLOCKS;
> +		}
> +		xfs_ialloc_log_agi(tp, agbp, fields);
>  		xfs_btree_commit_afakeroot(cur, tp, agbp, &xfs_finobt_ops);
>  	}
>  }
> diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> index bca2ab1d4be9..401f71579ce6 100644
> --- a/fs/xfs/scrub/agheader_repair.c
> +++ b/fs/xfs/scrub/agheader_repair.c
> @@ -810,10 +810,34 @@ xrep_agi_calc_from_btrees(
>  	error = xfs_ialloc_count_inodes(cur, &count, &freecount);
>  	if (error)
>  		goto err;
> +	if (xfs_sb_version_hasinobtcounts(&mp->m_sb)) {
> +		xfs_agblock_t	blocks;
> +
> +		error = xfs_btree_count_blocks(cur, &blocks);
> +		if (error)
> +			goto err;
> +		agi->agi_iblocks = cpu_to_be32(blocks);
> +	}
>  	xfs_btree_del_cursor(cur, error);
>  
>  	agi->agi_count = cpu_to_be32(count);
>  	agi->agi_freecount = cpu_to_be32(freecount);
> +
> +	if (xfs_sb_version_hasfinobt(&mp->m_sb) &&
> +	    xfs_sb_version_hasinobtcounts(&mp->m_sb)) {
> +		xfs_agblock_t	blocks;
> +
> +		cur = xfs_inobt_init_cursor(mp, sc->tp, agi_bp, sc->sa.agno,
> +				XFS_BTNUM_FINO);
> +		if (error)
> +			goto err;
> +		error = xfs_btree_count_blocks(cur, &blocks);
> +		if (error)
> +			goto err;
> +		xfs_btree_del_cursor(cur, error);
> +		agi->agi_fblocks = cpu_to_be32(blocks);
> +	}
> +
>  	return 0;
>  err:
>  	xfs_btree_del_cursor(cur, error);
> 

