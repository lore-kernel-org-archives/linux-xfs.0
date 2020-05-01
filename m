Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2F82C47257
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 15:57:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F3FD24953
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 15:57:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cZujVDdD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729008AbgEAP5t (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 11:57:49 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:41816 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729975AbgEAP5s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 11:57:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588348667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LXv4GQ8lVqlF3SCb2yLb6bIMO2AwDq7Qfjf0LhcCK8k=;
        b=cZujVDdDLF7RcPar3pBs+isa3OYs8/B40Ji7/JafuWCb2+PUiP1fdFbu8KaAJ/k60RGaxw
        cPqfktP4//KIICZ5LD9Yr7GMTozGwQqGN0dFqh4thHOEc7P+5FLLL4SlopVBuMbo2d6wcT
        BWwFatUPHboZPmXNXQT79HmpClNp8wU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-203-t4pFqesAM3KfKqt0JuDq2Q-1; Fri, 01 May 2020 11:57:45 -0400
X-MC-Unique: t4pFqesAM3KfKqt0JuDq2Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9996B107ACF2;
        Fri,  1 May 2020 15:57:44 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2AEC05C1B0;
        Fri,  1 May 2020 15:57:44 +0000 (UTC)
Date:   Fri, 1 May 2020 11:57:42 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/12] xfs: remove the special COW fork handling in
 xfs_bmapi_read
Message-ID: <20200501155742.GQ40250@bfoster>
References: <20200501081424.2598914-1-hch@lst.de>
 <20200501081424.2598914-12-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501081424.2598914-12-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 01, 2020 at 10:14:23AM +0200, Christoph Hellwig wrote:
> We don't call xfs_bmapi_read for the COW fork anymore, so remove the
> special casing.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Seems fine, though I wonder if I we really need that DEBUG check just
for the alert message in the same branch. ISTM we could drop the ifdef
or the whole hunk..

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_bmap.c | 13 +------------
>  1 file changed, 1 insertion(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index fda13cd7add0e..76be1a18e2442 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3902,8 +3902,7 @@ xfs_bmapi_read(
>  	int			whichfork = xfs_bmapi_whichfork(flags);
>  
>  	ASSERT(*nmap >= 1);
> -	ASSERT(!(flags & ~(XFS_BMAPI_ATTRFORK|XFS_BMAPI_ENTIRE|
> -			   XFS_BMAPI_COWFORK)));
> +	ASSERT(!(flags & ~(XFS_BMAPI_ATTRFORK | XFS_BMAPI_ENTIRE)));
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED|XFS_ILOCK_EXCL));
>  
>  	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ip, whichfork)) ||
> @@ -3918,16 +3917,6 @@ xfs_bmapi_read(
>  
>  	ifp = XFS_IFORK_PTR(ip, whichfork);
>  	if (!ifp) {
> -		/* No CoW fork?  Return a hole. */
> -		if (whichfork == XFS_COW_FORK) {
> -			mval->br_startoff = bno;
> -			mval->br_startblock = HOLESTARTBLOCK;
> -			mval->br_blockcount = len;
> -			mval->br_state = XFS_EXT_NORM;
> -			*nmap = 1;
> -			return 0;
> -		}
> -
>  		/*
>  		 * A missing attr ifork implies that the inode says we're in
>  		 * extents or btree format but failed to pass the inode fork
> -- 
> 2.26.2
> 

