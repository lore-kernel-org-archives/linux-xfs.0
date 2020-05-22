Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D418C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 12:04:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12E2F2072C
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 12:04:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Nnar08ok"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728544AbgEVMEA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 May 2020 08:04:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43816 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728979AbgEVMEA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 May 2020 08:04:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590149039;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DUF2ajh4xm6MwpeIjGTs5xk1fA6r9BzAmJdlWRB/65w=;
        b=Nnar08ok/PgtqxvZoC3pDdwtl5ZMdFIPjHbIG8kOvYPVxz45qHpT3VbNnmeQsAtvprjaES
        xDtWGiAIqF9aRUd1jSzdBzjU12vOz9O8rQP2k5WcP7uQ+5Wp8Q2r3I0e3+FKLZEULTUo5y
        I6QaV1xUgalAF5SgXebF5syV5/1qecE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-478-UZXpPe1sPI-A4Erh7N6Anw-1; Fri, 22 May 2020 08:03:57 -0400
X-MC-Unique: UZXpPe1sPI-A4Erh7N6Anw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1A5358015CF;
        Fri, 22 May 2020 12:03:54 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 87EF25D9CC;
        Fri, 22 May 2020 12:03:53 +0000 (UTC)
Date:   Fri, 22 May 2020 08:03:51 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/12] xfs: remove __xfs_icache_free_eofblocks
Message-ID: <20200522120351.GG50656@bfoster>
References: <159011600616.77079.14748275956667624732.stgit@magnolia>
 <159011604616.77079.6111029603205810668.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159011604616.77079.6111029603205810668.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 21, 2020 at 07:54:06PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> This is now a pointless wrapper, so kill it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_icache.c |   14 ++------------
>  1 file changed, 2 insertions(+), 12 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 53c6cc7bc02a..11a5e6897639 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1492,22 +1492,12 @@ xfs_inode_free_eofblocks(
>  	return ret;
>  }
>  
> -static int
> -__xfs_icache_free_eofblocks(
> -	struct xfs_mount	*mp,
> -	struct xfs_eofblocks	*eofb,
> -	int			(*execute)(struct xfs_inode *ip, void *args),
> -	int			tag)
> -{
> -	return xfs_inode_ag_iterator(mp, 0, execute, eofb, tag);
> -}
> -
>  int
>  xfs_icache_free_eofblocks(
>  	struct xfs_mount	*mp,
>  	struct xfs_eofblocks	*eofb)
>  {
> -	return __xfs_icache_free_eofblocks(mp, eofb, xfs_inode_free_eofblocks,
> +	return xfs_inode_ag_iterator(mp, 0, xfs_inode_free_eofblocks, eofb,
>  			XFS_ICI_EOFBLOCKS_TAG);
>  }
>  
> @@ -1769,7 +1759,7 @@ xfs_icache_free_cowblocks(
>  	struct xfs_mount	*mp,
>  	struct xfs_eofblocks	*eofb)
>  {
> -	return __xfs_icache_free_eofblocks(mp, eofb, xfs_inode_free_cowblocks,
> +	return xfs_inode_ag_iterator(mp, 0, xfs_inode_free_cowblocks, eofb,
>  			XFS_ICI_COWBLOCKS_TAG);
>  }
>  
> 

