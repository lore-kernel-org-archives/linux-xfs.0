Return-Path: <SRS0=UnAH=AG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58BC8C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 12:28:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 396FD20709
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 12:28:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L6mVV4ec"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404634AbgFYM2F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Jun 2020 08:28:05 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36218 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2404630AbgFYM2F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jun 2020 08:28:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593088084;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hbxFpxNseWlo6TdRZ9T+HXpID6+pMvkEZNSGixxZRew=;
        b=L6mVV4ecTojuFpOg4K2wFeAUp0oCVCXzXoHMeBRlIqvjFevCm3o629RiYfFT6Y4OSUzbKi
        lfY0B+Qhjdq2ANZRshKdIuwzfCpr0/xqY2QIdOmADryuwendXmY9qP8RXxpn6B6UWD1hfo
        XtSX4tzpNEvx1xcuUwSGZXtRZhezrN8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-205-aNnyXdyyMBOoKGVEV1zBgQ-1; Thu, 25 Jun 2020 08:28:02 -0400
X-MC-Unique: aNnyXdyyMBOoKGVEV1zBgQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 781DF100CCC0;
        Thu, 25 Jun 2020 12:28:01 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 06A5E76114;
        Thu, 25 Jun 2020 12:28:00 +0000 (UTC)
Date:   Thu, 25 Jun 2020 08:27:59 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, edwin@etorok.net
Subject: Re: [PATCH 4/9] xfs: only reserve quota blocks for bmbt changes if
 we're changing the data fork
Message-ID: <20200625122759.GF2863@bfoster>
References: <159304785928.874036.4735877085735285950.stgit@magnolia>
 <159304788616.874036.5580426142663484238.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159304788616.874036.5580426142663484238.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 24, 2020 at 06:18:06PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Now that we've reworked xfs_reflink_remap_extent to remap only one
> extent per transaction, we actually know if the extent being removed is
> an allocated mapping.  This means that we now know ahead of time if
> we're going to be touching the data fork.
> 
> Since we only need blocks for a bmbt split if we're going to update the
> data fork, we only need to get quota reservation if we know we're going
> to touch the data fork.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

That addresses my question on the previous patch. Looks like the qres
check was just misplaced. NBD:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_reflink.c |   11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index c593d52156df..9cc1c340d0ec 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1043,7 +1043,11 @@ xfs_reflink_remap_extent(
>  	 * Compute quota reservation if we think the quota block counter for
>  	 * this file could increase.
>  	 *
> -	 * We start by reserving enough blocks to handle a bmbt split.
> +	 * Adding a written extent to the extent map can cause a bmbt split,
> +	 * and removing a mapped extent from the extent can cause a bmbt split.
> +	 * The two operations cannot both cause a split since they operate on
> +	 * the same index in the bmap btree, so we only need a reservation for
> +	 * one bmbt split if either thing is happening.
>  	 *
>  	 * If we are mapping a written extent into the file, we need to have
>  	 * enough quota block count reservation to handle the blocks in that
> @@ -1056,8 +1060,9 @@ xfs_reflink_remap_extent(
>  	 * before we started.  That should have removed all the delalloc
>  	 * reservations, but we code defensively.
>  	 */
> -	qdelta = 0;
> -	qres = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
> +	qres = qdelta = 0;
> +	if (smap_mapped || dmap_written)
> +		qres = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
>  	if (dmap_written)
>  		qres += dmap->br_blockcount;
>  	if (qres > 0) {
> 

