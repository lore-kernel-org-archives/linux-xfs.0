Return-Path: <SRS0=6H2z=7S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2877FC433DF
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Jun 2020 16:27:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F41032074B
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Jun 2020 16:27:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y00Mfpl0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728452AbgFEQ1j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Jun 2020 12:27:39 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:31899 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727812AbgFEQ0Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Jun 2020 12:26:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591374384;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SjVzW7somMSqTvMjheEcuVpM3FkzK/KxO2hwrVAbcYM=;
        b=Y00Mfpl01Q/Vqyw8tdIbIYb909JuYQ3z6+KmyrNPultRihiInmn8SWmyMO7NO47MalY89J
        z1BFAMRGQP2TAM9gLqCrZmc9+faMz/mIoIa1ddWUL45fRaJQz3/TmnGlMLbJ3BvVTrnRyB
        sJCSYzm0C07udaLzPkRwFSGemj+UXVk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-HLz1cM-kOa6_NJlH6S3dVA-1; Fri, 05 Jun 2020 12:26:22 -0400
X-MC-Unique: HLz1cM-kOa6_NJlH6S3dVA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E3AA8100A8E7;
        Fri,  5 Jun 2020 16:26:21 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9D52010013D0;
        Fri,  5 Jun 2020 16:26:21 +0000 (UTC)
Date:   Fri, 5 Jun 2020 12:26:20 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 20/30] xfs: don't block inode reclaim on the ILOCK
Message-ID: <20200605162620.GD23747@bfoster>
References: <20200604074606.266213-1-david@fromorbit.com>
 <20200604074606.266213-21-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604074606.266213-21-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 04, 2020 at 05:45:56PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we attempt to reclaim an inode, the first thing we do is take
> the inode lock. This is blocking right now, so if the inode being
> accessed by something else (e.g. being flushed to the cluster
> buffer) we will block here.
> 
> Change this to a trylock so that we do not block inode reclaim
> unnecessarily here.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_icache.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index c4ba8d7bc45bc..d1c47a0e0b0ec 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1119,9 +1119,10 @@ xfs_reclaim_inode(
>  {
>  	xfs_ino_t		ino = ip->i_ino; /* for radix_tree_delete */
>  
> -	xfs_ilock(ip, XFS_ILOCK_EXCL);
> -	if (!xfs_iflock_nowait(ip))
> +	if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL))
>  		goto out;
> +	if (!xfs_iflock_nowait(ip))
> +		goto out_iunlock;
>  
>  	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
>  		xfs_iunpin_wait(ip);
> @@ -1188,8 +1189,9 @@ xfs_reclaim_inode(
>  
>  out_ifunlock:
>  	xfs_ifunlock(ip);
> -out:
> +out_iunlock:
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +out:
>  	xfs_iflags_clear(ip, XFS_IRECLAIM);
>  	return false;
>  }
> -- 
> 2.26.2.761.g0e0b3e54be
> 

