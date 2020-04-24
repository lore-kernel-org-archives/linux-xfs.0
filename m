Return-Path: <SRS0=lEGq=6I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73350C54FCB
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Apr 2020 14:04:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E35D2075A
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Apr 2020 14:04:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gvg3Etrt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgDXOEU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Apr 2020 10:04:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52990 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726698AbgDXOET (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Apr 2020 10:04:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587737057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xjPfE1Qsa9/vy2n3aI+cLJlaWt6qn51/aMxG9pVgBdU=;
        b=gvg3EtrtzqH6Es3Nz7IKTOVAkdsiDP0Sn+GRNxF7LMVEDUuqD5vh7JpZdCosJpKTZNRl4D
        gE+c8sQZ68yj7caCRvEvcoc22Sa1Rmm6+AAmtEBgXzaNFY9uz6JDhWAIdW2cJyH5IRso72
        q1urQ01+FIdA9+jYzCy/xDobTtN5ofs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-AdjdibxnPmy9YaaxQsOWVw-1; Fri, 24 Apr 2020 10:04:11 -0400
X-MC-Unique: AdjdibxnPmy9YaaxQsOWVw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E9D5D835B50;
        Fri, 24 Apr 2020 14:04:10 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8B6CB100238D;
        Fri, 24 Apr 2020 14:04:10 +0000 (UTC)
Date:   Fri, 24 Apr 2020 10:04:08 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: reduce log recovery transaction block
 reservations
Message-ID: <20200424140408.GE53690@bfoster>
References: <158752128766.2142108.8793264653760565688.stgit@magnolia>
 <158752130035.2142108.11825776210575708747.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158752130035.2142108.11825776210575708747.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 21, 2020 at 07:08:20PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> On filesystems that support them, bmap intent log items can be used to
> change mappings in inode data or attr forks.  However, if the bmbt must
> expand, the enormous block reservations that we make for finishing
> chains of deferred log items become a liability because the bmbt block
> allocator sets minleft to the transaction reservation and there probably
> aren't any AGs in the filesystem that have that much free space.
> 
> Whereas previously we would reserve 93% of the free blocks in the
> filesystem, now we only want to reserve 7/8ths of the free space in the
> least full AG, and no more than half of the usable blocks in an AG.  In
> theory we shouldn't run out of space because (prior to the unclean
> shutdown) all of the in-progress transactions successfully reserved the
> worst case number of disk blocks.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_log_recover.c |   55 ++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 43 insertions(+), 12 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index e9b3e901d009..a416b028b320 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2669,6 +2669,44 @@ xlog_recover_process_data(
>  	return 0;
>  }
>  
> +/*
> + * Estimate a block reservation for a log recovery transaction.  Since we run
> + * separate transactions for each chain of deferred ops that get created as a
> + * result of recovering unfinished log intent items, we must be careful not to
> + * reserve so many blocks that block allocations fail because we can't satisfy
> + * the minleft requirements (e.g. for bmbt blocks).
> + */
> +static int
> +xlog_estimate_recovery_resblks(
> +	struct xfs_mount	*mp,
> +	unsigned int		*resblks)
> +{
> +	struct xfs_perag	*pag;
> +	xfs_agnumber_t		agno;
> +	unsigned int		free = 0;
> +	int			error;
> +
> +	/* Don't use more than 7/8th of the free space in the least full AG. */
> +	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> +		unsigned int	ag_free;
> +
> +		error = xfs_alloc_pagf_init(mp, NULL, agno, 0);
> +		if (error)
> +			return error;
> +		pag = xfs_perag_get(mp, agno);
> +		ag_free = pag->pagf_freeblks + pag->pagf_flcount;
> +		free = max(free, (ag_free * 7) / 8);
> +		xfs_perag_put(pag);
> +	}
> +

Somewhat unfortunate that we have to iterate all AGs for each chain. I'm
wondering if that has any effect on a large recovery on fs' with an
inordinate AG count. Have you tested under those particular conditions?
I suppose it's possible the recovery is slow enough that this won't
matter...

Also, perhaps not caused by this patch but does this
outsized/manufactured reservation have the effect of artificially
steering allocations to a particular AG if one happens to be notably
larger than the rest?

Brian

> +	/* Don't try to reserve more than half the usable AG blocks. */
> +	*resblks = min(free, xfs_alloc_ag_max_usable(mp) / 2);
> +	if (*resblks == 0)
> +		return -ENOSPC;
> +
> +	return 0;
> +}
> +
>  /* Take all the collected deferred ops and finish them in order. */
>  static int
>  xlog_finish_defer_ops(
> @@ -2677,27 +2715,20 @@ xlog_finish_defer_ops(
>  {
>  	struct xfs_defer_freezer *dff, *next;
>  	struct xfs_trans	*tp;
> -	int64_t			freeblks;
>  	uint			resblks;
>  	int			error = 0;
>  
>  	list_for_each_entry_safe(dff, next, dfops_freezers, dff_list) {
> +		error = xlog_estimate_recovery_resblks(mp, &resblks);
> +		if (error)
> +			break;
> +
>  		/*
>  		 * We're finishing the defer_ops that accumulated as a result
>  		 * of recovering unfinished intent items during log recovery.
>  		 * We reserve an itruncate transaction because it is the
> -		 * largest permanent transaction type.  Since we're the only
> -		 * user of the fs right now, take 93% (15/16) of the available
> -		 * free blocks.  Use weird math to avoid a 64-bit division.
> +		 * largest permanent transaction type.
>  		 */
> -		freeblks = percpu_counter_sum(&mp->m_fdblocks);
> -		if (freeblks <= 0) {
> -			error = -ENOSPC;
> -			break;
> -		}
> -
> -		resblks = min_t(int64_t, UINT_MAX, freeblks);
> -		resblks = (resblks * 15) >> 4;
>  		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, resblks,
>  				0, XFS_TRANS_RESERVE, &tp);
>  		if (error)
> 

