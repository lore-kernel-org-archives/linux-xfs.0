Return-Path: <SRS0=UnAH=AG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94C14C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 12:26:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D9C820709
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 12:26:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FgtlVjGh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404531AbgFYM0q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Jun 2020 08:26:46 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:49619 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404343AbgFYM0p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jun 2020 08:26:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593088004;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sPwX4LQGEmDJuX7W7qv0WuMOjp09CzDNcBq6HShpX8M=;
        b=FgtlVjGhqYRV5kK03v+R44tuSedU0Xy6jlgPiW+bd2+r4MUZoIl0Y3qsbl4IMozFt6VD5H
        /UC+/IzBnp75GrGdlLPVyae2MxWA6rKdh2SOTrFmvUvL+S8jk365QHgpZIdtG7BbjFeEzF
        8ElM689g7ZCVCrn9SwsRb8xx/Ilw4fs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-yVRugA2DNrCa50Lwm67OGQ-1; Thu, 25 Jun 2020 08:26:40 -0400
X-MC-Unique: yVRugA2DNrCa50Lwm67OGQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DD6361800D4A;
        Thu, 25 Jun 2020 12:26:37 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 567122C6C1;
        Thu, 25 Jun 2020 12:26:37 +0000 (UTC)
Date:   Thu, 25 Jun 2020 08:26:35 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, edwin@etorok.net
Subject: Re: [PATCH 1/9] xfs: fix reflink quota reservation accounting error
Message-ID: <20200625122635.GC2863@bfoster>
References: <159304785928.874036.4735877085735285950.stgit@magnolia>
 <159304786592.874036.13697964290841630094.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159304786592.874036.13697964290841630094.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 24, 2020 at 06:17:45PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Quota reservations are supposed to account for the blocks that might be
> allocated due to a bmap btree split.  Reflink doesn't do this, so fix
> this to make the quota accounting more accurate before we start
> rearranging things.
> 
> Fixes: 862bb360ef56 ("xfs: reflink extents from one file to another")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_reflink.c |   21 ++++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 107bf2a2f344..d89201d40891 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1003,6 +1003,7 @@ xfs_reflink_remap_extent(
>  	xfs_filblks_t		rlen;
>  	xfs_filblks_t		unmap_len;
>  	xfs_off_t		newlen;
> +	int64_t			qres;
>  	int			error;
>  
>  	unmap_len = irec->br_startoff + irec->br_blockcount - destoff;
> @@ -1025,13 +1026,19 @@ xfs_reflink_remap_extent(
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	xfs_trans_ijoin(tp, ip, 0);
>  
> -	/* If we're not just clearing space, then do we have enough quota? */
> -	if (real_extent) {
> -		error = xfs_trans_reserve_quota_nblks(tp, ip,
> -				irec->br_blockcount, 0, XFS_QMOPT_RES_REGBLKS);
> -		if (error)
> -			goto out_cancel;
> -	}
> +	/*
> +	 * Reserve quota for this operation.  We don't know if the first unmap
> +	 * in the dest file will cause a bmap btree split, so we always reserve
> +	 * at least enough blocks for that split.  If the extent being mapped
> +	 * in is written, we need to reserve quota for that too.
> +	 */
> +	qres = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
> +	if (real_extent)
> +		qres += irec->br_blockcount;
> +	error = xfs_trans_reserve_quota_nblks(tp, ip, qres, 0,
> +			XFS_QMOPT_RES_REGBLKS);
> +	if (error)
> +		goto out_cancel;
>  
>  	trace_xfs_reflink_remap(ip, irec->br_startoff,
>  				irec->br_blockcount, irec->br_startblock);
> 

