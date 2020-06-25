Return-Path: <SRS0=UnAH=AG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C6A0C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 12:28:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5552C20709
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 12:28:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SsVFQ4pV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404451AbgFYM2Z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Jun 2020 08:28:25 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23901 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2404688AbgFYM2Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jun 2020 08:28:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593088103;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6BSnrrdlIMGBBXDBQ4AmTkGoPSE6I1QUEil51cFb1EA=;
        b=SsVFQ4pVCHGXUEs7Rcp2qM9yuhHbrzogS4LKS5HyyN9dK/8JPUoNdLXbUsYbDCtjocTukw
        jsE7rQEuCFiKdoC94rh99FUuYQ6GmBqrWXwKdIr5s//q2TUuoCgKx2leOruOjuUiC8/qlk
        gd+0kZ06KJG2Mm6ilDhmLPG0axdnVZ0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-411-qQeMQhOgOsGVoqlSi76ANA-1; Thu, 25 Jun 2020 08:28:21 -0400
X-MC-Unique: qQeMQhOgOsGVoqlSi76ANA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D16F1800FF1;
        Thu, 25 Jun 2020 12:28:20 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5FE9A10013C4;
        Thu, 25 Jun 2020 12:28:20 +0000 (UTC)
Date:   Thu, 25 Jun 2020 08:28:18 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, edwin@etorok.net
Subject: Re: [PATCH 6/9] xfs: reflink can skip remap existing mappings
Message-ID: <20200625122818.GH2863@bfoster>
References: <159304785928.874036.4735877085735285950.stgit@magnolia>
 <159304789856.874036.15102270304208951038.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159304789856.874036.15102270304208951038.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 24, 2020 at 06:18:18PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If the source and destination map are identical, we can skip the remap
> step to save some time.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_reflink.c |   17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 72de7179399d..f1156f121b7d 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1031,6 +1031,23 @@ xfs_reflink_remap_extent(
>  
>  	trace_xfs_reflink_remap_extent_dest(ip, &smap);
>  
> +	/*
> +	 * Two extents mapped to the same physical block must not have
> +	 * different states; that's filesystem corruption.  Move on to the next
> +	 * extent if they're both holes or both the same physical extent.
> +	 */
> +	if (dmap->br_startblock == smap.br_startblock) {
> +		ASSERT(dmap->br_startblock == smap.br_startblock);

That assert duplicates the logic in the if statement. Was this intended
to be the length check I asked for? If so it looks like that was added
previously so perhaps this can just drop off. With that fixed up:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +		if (dmap->br_state != smap.br_state)
> +			error = -EFSCORRUPTED;
> +		goto out_cancel;
> +	}
> +
> +	/* If both extents are unwritten, leave them alone. */
> +	if (dmap->br_state == XFS_EXT_UNWRITTEN &&
> +	    smap.br_state == XFS_EXT_UNWRITTEN)
> +		goto out_cancel;
> +
>  	/* No reflinking if the AG of the dest mapping is low on space. */
>  	if (dmap_written) {
>  		error = xfs_reflink_ag_has_free_space(mp,
> 

