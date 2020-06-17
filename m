Return-Path: <SRS0=Ja7n=76=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C2C9C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Jun 2020 12:09:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1F8F208B3
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Jun 2020 12:09:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xfxfkesi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbgFQMJy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 17 Jun 2020 08:09:54 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33137 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726355AbgFQMJw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Jun 2020 08:09:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592395791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5w9k87TYLTbZqtFhhAdqY5kJ/uxXGI9Zx5Zrk3lNUXs=;
        b=XfxfkesihOcdEnMKUaJFHi2KB8lWrkd7BKwXDU/PD8NIasynI2uZu3ltCtQIuWK++wVJyF
        5EwvjMw4SbYP1/RkBv0ZQUMcDD+e0hn1Hu4SD/sZH78bLZqG4eCSRLK/JWYdqsiUocotvj
        9FRQB2N3Pw+ZJtx6uIptrgPo0rJlr3A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-185-hpr5HtpZNXCLRqnpMCVA4w-1; Wed, 17 Jun 2020 08:09:49 -0400
X-MC-Unique: hpr5HtpZNXCLRqnpMCVA4w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B2F8A80F5E5;
        Wed, 17 Jun 2020 12:09:48 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2C6036EDBE;
        Wed, 17 Jun 2020 12:09:48 +0000 (UTC)
Date:   Wed, 17 Jun 2020 08:09:46 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/12] xfs_repair: inject lost blocks back into the fs no
 matter the owner
Message-ID: <20200617120946.GD27169@bfoster>
References: <159107201290.315004.4447998785149331259.stgit@magnolia>
 <159107204483.315004.966896847007086323.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159107204483.315004.966896847007086323.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 01, 2020 at 09:27:24PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In repair phase 5, inject_lost_blocks takes the blocks that we allocated
> but didn't use for constructing the new AG btrees and puts them back in
> the filesystem by adding them to the free space.  The only btree that
> can overestimate like that are the free space btrees, but in principle,
> any of the btrees can do that.  If the others did, the rmap record owner
> for those blocks won't necessarily be OWNER_AG, and if it isn't, repair
> will fail.
> 
> Get rid of this logic bomb so that we can use it for /any/ block count
> overestimation, and then we can use it to clean up after all
> reconstruction of any btree type.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  repair/phase5.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/repair/phase5.c b/repair/phase5.c
> index 44a6bda8..75c480fd 100644
> --- a/repair/phase5.c
> +++ b/repair/phase5.c
> @@ -2516,8 +2516,8 @@ inject_lost_blocks(
>  		if (error)
>  			goto out_cancel;
>  
> -		error = -libxfs_free_extent(tp, *fsb, 1, &XFS_RMAP_OINFO_AG,
> -					    XFS_AG_RESV_NONE);
> +		error = -libxfs_free_extent(tp, *fsb, 1,
> +				&XFS_RMAP_OINFO_ANY_OWNER, XFS_AG_RESV_NONE);
>  		if (error)
>  			goto out_cancel;
>  
> 

