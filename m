Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B0F8C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 18:27:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E113A64E21
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 18:27:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbhA1S1L (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 13:27:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59299 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231470AbhA1SYr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jan 2021 13:24:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611858201;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iyMuffMtjf/EVXNn+ecq9C6TGwEH9qLW+UvyysSBchc=;
        b=GzfPrjai+6tCWV2Lqie2cDzuHlP061aAMlwSfyrPpxtjz48QeDOKtspqdyCw9Gf1jOtGM2
        I//dfeuMxDDNwzOUpogMm8xRLuOdg54HZ7w95qtYwnQcEKr1XhIgCXzem807t9YKxxMixB
        f4pB+S4mIXci7Yql6EjHoAfU05JAn+w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-NWMN6pM5MDW5TUfulNZfBw-1; Thu, 28 Jan 2021 13:23:19 -0500
X-MC-Unique: NWMN6pM5MDW5TUfulNZfBw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 12FE4107ACE8;
        Thu, 28 Jan 2021 18:23:18 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7346B5D9F1;
        Thu, 28 Jan 2021 18:23:17 +0000 (UTC)
Date:   Thu, 28 Jan 2021 13:23:15 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 10/13] xfs: try worst case space reservation upfront in
 xfs_reflink_remap_extent
Message-ID: <20210128182315.GI2619139@bfoster>
References: <161181366379.1523592.9213241916555622577.stgit@magnolia>
 <161181372121.1523592.2524488839590698117.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161181372121.1523592.2524488839590698117.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 27, 2021 at 10:02:01PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that we've converted xfs_reflink_remap_extent to use the new
> xfs_trans_alloc_inode API, we can focus on its slightly unusual behavior
> with regard to quota reservations.
> 
> Since it's valid to remap written blocks into a hole, we must be able to
> increase the quota count by the number of blocks in the mapping.
> However, the incore space reservation process requires us to supply an
> asymptotic guess before we can gain exclusive access to resources.  We'd
> like to reserve all the quota we need up front, but we also don't want
> to fail a written -> allocated remap operation unnecessarily.
> 
> The solution is to make the remap_extents function call the transaction
> allocation function twice.  The first time we ask to reserve enough
> space and quota to handle the absolute worst case situation, but if that
> fails, we can fall back to the old strategy: ask for the bare minimum
> space reservation upfront and increase the quota reservation later if we
> need to.
> 
> This isn't a problem now, but in the next patchset we change the
> transaction and quota code to try to reclaim space if we cannot reserve
> free space or quota.  Restructuring the remap_extent function in this
> manner means that if the fallback increase fails, we can pass that back
> to the caller knowing that the transaction allocation already tried
> freeing space.
> 

This looks pretty good to me, but I'd probably move this patch closer to
the patch that depends on it..

Brian

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_reflink.c |   23 ++++++++++++++++++++---
>  1 file changed, 20 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index ded86cc4764c..c6296fd1512f 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -992,6 +992,7 @@ xfs_reflink_remap_extent(
>  	xfs_off_t		newlen;
>  	int64_t			qdelta = 0;
>  	unsigned int		resblks;
> +	bool			quota_reserved = true;
>  	bool			smap_real;
>  	bool			dmap_written = xfs_bmap_is_written_extent(dmap);
>  	int			iext_delta = 0;
> @@ -1007,10 +1008,26 @@ xfs_reflink_remap_extent(
>  	 * the same index in the bmap btree, so we only need a reservation for
>  	 * one bmbt split if either thing is happening.  However, we haven't
>  	 * locked the inode yet, so we reserve assuming this is the case.
> +	 *
> +	 * The first allocation call tries to reserve enough space to handle
> +	 * mapping dmap into a sparse part of the file plus the bmbt split.  We
> +	 * haven't locked the inode or read the existing mapping yet, so we do
> +	 * not know for sure that we need the space.  This should succeed most
> +	 * of the time.
> +	 *
> +	 * If the first attempt fails, try again but reserving only enough
> +	 * space to handle a bmbt split.  This is the hard minimum requirement,
> +	 * and we revisit quota reservations later when we know more about what
> +	 * we're remapping.
>  	 */
>  	resblks = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
> -	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write, resblks, 0,
> -			false, &tp);
> +	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write,
> +			resblks + dmap->br_blockcount, 0, false, &tp);
> +	if (error == -EDQUOT || error == -ENOSPC) {
> +		quota_reserved = false;
> +		error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write,
> +				resblks, 0, false, &tp);
> +	}
>  	if (error)
>  		goto out;
>  
> @@ -1077,7 +1094,7 @@ xfs_reflink_remap_extent(
>  	 * before we started.  That should have removed all the delalloc
>  	 * reservations, but we code defensively.
>  	 */
> -	if (!smap_real && dmap_written) {
> +	if (!quota_reserved && !smap_real && dmap_written) {
>  		error = xfs_trans_reserve_quota_nblks(tp, ip,
>  				dmap->br_blockcount, 0, false);
>  		if (error)
> 

