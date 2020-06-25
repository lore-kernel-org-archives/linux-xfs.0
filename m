Return-Path: <SRS0=UnAH=AG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E04E3C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 12:28:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B960820709
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 12:28:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a1gDxYiO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404630AbgFYM2M (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Jun 2020 08:28:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43650 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2404451AbgFYM2L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jun 2020 08:28:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593088090;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SfVrBPVBI8PegkQZuhsjz3VVTMa/JYWyC/OmvKcBG00=;
        b=a1gDxYiODPxpMZT+Wxrs9QRo5tkgTXY2VrXas4SoFQ6iDc9VjZyfoTWQMlLAY28eGFrJw+
        YDNq7c8FA5NQqYoJ/udkl5/Ky0V5EdYCMe93LDLP2NJF1vO0Z3/zNFGztfInAmzwZTBAkV
        UZHGC6H2/MmqvzN02g9CrN/O5o16eHo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-218-yf2txZUyNbeBaL2PAPeC1g-1; Thu, 25 Jun 2020 08:28:09 -0400
X-MC-Unique: yf2txZUyNbeBaL2PAPeC1g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2B0C2DBE4;
        Thu, 25 Jun 2020 12:28:08 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C7DEC61B71;
        Thu, 25 Jun 2020 12:28:07 +0000 (UTC)
Date:   Thu, 25 Jun 2020 08:28:06 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, edwin@etorok.net
Subject: Re: [PATCH 5/9] xfs: only reserve quota blocks if we're mapping into
 a hole
Message-ID: <20200625122806.GG2863@bfoster>
References: <159304785928.874036.4735877085735285950.stgit@magnolia>
 <159304789231.874036.3844840616429094322.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159304789231.874036.3844840616429094322.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 24, 2020 at 06:18:12PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When logging quota block count updates during a reflink operation, we
> only log the /delta/ of the block count changes to the dquot.  Since we
> now know ahead of time the extent type of both dmap and smap (and that
> they have the same length), we know that we only need to reserve quota
> blocks for dmap's blockcount if we're mapping it into a hole.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_reflink.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 9cc1c340d0ec..72de7179399d 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1051,7 +1051,9 @@ xfs_reflink_remap_extent(
>  	 *
>  	 * If we are mapping a written extent into the file, we need to have
>  	 * enough quota block count reservation to handle the blocks in that
> -	 * extent.
> +	 * extent.  We log only the delta to the quota block counts, so if the
> +	 * extent we're unmapping also has blocks allocated to it, we don't
> +	 * need a quota reservation for the extent itself.
>  	 *
>  	 * Note that if we're replacing a delalloc reservation with a written
>  	 * extent, we have to take the full quota reservation because removing
> @@ -1063,7 +1065,7 @@ xfs_reflink_remap_extent(
>  	qres = qdelta = 0;
>  	if (smap_mapped || dmap_written)
>  		qres = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
> -	if (dmap_written)
> +	if (!smap_mapped && dmap_written)
>  		qres += dmap->br_blockcount;
>  	if (qres > 0) {
>  		error = xfs_trans_reserve_quota_nblks(tp, ip, qres, 0,
> 

