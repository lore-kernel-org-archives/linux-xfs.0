Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EB21C43381
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 18:28:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E303F64E21
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 18:27:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbhA1S1Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 13:27:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20045 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232072AbhA1SYm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jan 2021 13:24:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611858194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=o/71Qa77uyEkpPOCs4B4HHO2B1c86Ro6Vi9Av6xPwCY=;
        b=ZqB8sPRY56YN649kJbhP6V1kXsRr+NzOuklWzvXy4DkH+FuH5gFO6c7xryTlNYXtXYDJr+
        6TJRU1DyxxvKL9gVf89ELZQ0+QY7QpTRI7X7Lu41VJtT3z1eFzK5WnpodT0TOeLsRs5DVL
        fICYNyE6pi24s4MtDEHqu/fxgPQapDE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-lSEVa3TnMxmuKvKsNHPZ_A-1; Thu, 28 Jan 2021 13:23:10 -0500
X-MC-Unique: lSEVa3TnMxmuKvKsNHPZ_A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E2BCD1015C83;
        Thu, 28 Jan 2021 18:23:08 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5BC0A5D9EF;
        Thu, 28 Jan 2021 18:23:08 +0000 (UTC)
Date:   Thu, 28 Jan 2021 13:23:06 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 09/13] xfs: refactor reflink functions to use
 xfs_trans_alloc_inode
Message-ID: <20210128182306.GH2619139@bfoster>
References: <161181366379.1523592.9213241916555622577.stgit@magnolia>
 <161181371557.1523592.14364313318301403930.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161181371557.1523592.14364313318301403930.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 27, 2021 at 10:01:55PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The two remaining callers of xfs_trans_reserve_quota_nblks are in the
> reflink code.  These conversions aren't as uniform as the previous
> conversions, so call that out in a separate patch.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Modulo Christoph's feedback on the locking:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_reflink.c |   58 +++++++++++++++++++++-----------------------------
>  1 file changed, 24 insertions(+), 34 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 0778b5810c26..ded86cc4764c 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -376,16 +376,15 @@ xfs_reflink_allocate_cow(
>  	resblks = XFS_DIOSTRAT_SPACE_RES(mp, resaligned);
>  
>  	xfs_iunlock(ip, *lockmode);
> -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
> -	*lockmode = XFS_ILOCK_EXCL;
> -	xfs_ilock(ip, *lockmode);
>  
> -	if (error)
> +	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write, resblks, 0,
> +			false, &tp);
> +	if (error) {
> +		/* This function must return with ILOCK_EXCL held. */
> +		*lockmode = XFS_ILOCK_EXCL;
> +		xfs_ilock(ip, *lockmode);
>  		return error;
> -
> -	error = xfs_qm_dqattach_locked(ip, false);
> -	if (error)
> -		goto out_trans_cancel;
> +	}
>  
>  	/*
>  	 * Check for an overlapping extent again now that we dropped the ilock.
> @@ -398,12 +397,6 @@ xfs_reflink_allocate_cow(
>  		goto convert;
>  	}
>  
> -	error = xfs_trans_reserve_quota_nblks(tp, ip, resblks, 0, false);
> -	if (error)
> -		goto out_trans_cancel;
> -
> -	xfs_trans_ijoin(tp, ip, 0);
> -
>  	/* Allocate the entire reservation as unwritten blocks. */
>  	nimaps = 1;
>  	error = xfs_bmapi_write(tp, ip, imap->br_startoff, imap->br_blockcount,
> @@ -997,7 +990,7 @@ xfs_reflink_remap_extent(
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_trans	*tp;
>  	xfs_off_t		newlen;
> -	int64_t			qres, qdelta;
> +	int64_t			qdelta = 0;
>  	unsigned int		resblks;
>  	bool			smap_real;
>  	bool			dmap_written = xfs_bmap_is_written_extent(dmap);
> @@ -1005,15 +998,22 @@ xfs_reflink_remap_extent(
>  	int			nimaps;
>  	int			error;
>  
> -	/* Start a rolling transaction to switch the mappings */
> +	/*
> +	 * Start a rolling transaction to switch the mappings.
> +	 *
> +	 * Adding a written extent to the extent map can cause a bmbt split,
> +	 * and removing a mapped extent from the extent can cause a bmbt split.
> +	 * The two operations cannot both cause a split since they operate on
> +	 * the same index in the bmap btree, so we only need a reservation for
> +	 * one bmbt split if either thing is happening.  However, we haven't
> +	 * locked the inode yet, so we reserve assuming this is the case.
> +	 */
>  	resblks = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
> -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
> +	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write, resblks, 0,
> +			false, &tp);
>  	if (error)
>  		goto out;
>  
> -	xfs_ilock(ip, XFS_ILOCK_EXCL);
> -	xfs_trans_ijoin(tp, ip, 0);
> -
>  	/*
>  	 * Read what's currently mapped in the destination file into smap.
>  	 * If smap isn't a hole, we will have to remove it before we can add
> @@ -1061,15 +1061,9 @@ xfs_reflink_remap_extent(
>  	}
>  
>  	/*
> -	 * Compute quota reservation if we think the quota block counter for
> +	 * Increase quota reservation if we think the quota block counter for
>  	 * this file could increase.
>  	 *
> -	 * Adding a written extent to the extent map can cause a bmbt split,
> -	 * and removing a mapped extent from the extent can cause a bmbt split.
> -	 * The two operations cannot both cause a split since they operate on
> -	 * the same index in the bmap btree, so we only need a reservation for
> -	 * one bmbt split if either thing is happening.
> -	 *
>  	 * If we are mapping a written extent into the file, we need to have
>  	 * enough quota block count reservation to handle the blocks in that
>  	 * extent.  We log only the delta to the quota block counts, so if the
> @@ -1083,13 +1077,9 @@ xfs_reflink_remap_extent(
>  	 * before we started.  That should have removed all the delalloc
>  	 * reservations, but we code defensively.
>  	 */
> -	qres = qdelta = 0;
> -	if (smap_real || dmap_written)
> -		qres = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
> -	if (!smap_real && dmap_written)
> -		qres += dmap->br_blockcount;
> -	if (qres > 0) {
> -		error = xfs_trans_reserve_quota_nblks(tp, ip, qres, 0, false);
> +	if (!smap_real && dmap_written) {
> +		error = xfs_trans_reserve_quota_nblks(tp, ip,
> +				dmap->br_blockcount, 0, false);
>  		if (error)
>  			goto out_cancel;
>  	}
> 

