Return-Path: <SRS0=JklA=3N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31004C2D0CE
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 23:12:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F10CA2077C
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 23:12:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bX+GWYr1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387420AbgAXXMI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jan 2020 18:12:08 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:43256 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387419AbgAXXMI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jan 2020 18:12:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ARUoVKp0kXpcgthiwM1Es0rUc8wtQMG96kOEIR72aOs=; b=bX+GWYr1iugpivTV5MxU9trhp
        fgfOIlRZRiKHbh0vT8Svob7Sz8YzYm3YvyIFv0m7MwimwXv5cx9HcIdQiCrjeYz+9WVP+X8BxXgtk
        UHB8fktn0b/0xyiPIRO/iwNY+ppoXvjjEbFEGSQhjjLBt1sFBiOQ7FvDUlWpTcNm/+iGoQiKrcJjV
        IluIQSxiKXAN8ZNH6Jph+wlCs2acRX6dihFLeVMji4Og//32l905YLfWFluVpiQUhFlolC9f09exj
        Zghl1TxcqGFqClmPlRi5SV5UhM+suSVVqGXcrM9hSu4bIqxy9nZNEvG4Li19wpDkgim6c7vdRzWn1
        R+CZ1nm0w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iv87T-0005ah-G7; Fri, 24 Jan 2020 23:12:07 +0000
Date:   Fri, 24 Jan 2020 15:12:07 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 10/12] xfs: make xfs_*read_agf return EAGAIN to
 ALLOC_FLAG_TRYLOCK callers
Message-ID: <20200124231207.GD20014@infradead.org>
References: <157984313582.3139258.1136501362141645797.stgit@magnolia>
 <157984320125.3139258.966527323692871610.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157984320125.3139258.966527323692871610.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 23, 2020 at 09:20:01PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor xfs_read_agf and xfs_alloc_read_agf to return EAGAIN if the
> caller passed TRYLOCK and we weren't able to get the lock; and change
> the callers to recognize this.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c |   36 ++++++++++++++----------------------
>  fs/xfs/libxfs/xfs_bmap.c  |   11 ++++++-----
>  fs/xfs/xfs_filestream.c   |   11 +++++------
>  3 files changed, 25 insertions(+), 33 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 34b65635ee34..d8053bc96c4d 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2502,12 +2502,11 @@ xfs_alloc_fix_freelist(
>  
>  	if (!pag->pagf_init) {
>  		error = xfs_alloc_read_agf(mp, tp, args->agno, flags, &agbp);
> -		if (error)
> +		if (error) {
> +			/* Couldn't lock the AGF so skip this AG. */
> +			if (error == -EAGAIN)
> +				error = 0;
>  			goto out_no_agbp;
> -		if (!pag->pagf_init) {
> -			ASSERT(flags & XFS_ALLOC_FLAG_TRYLOCK);
> -			ASSERT(!(flags & XFS_ALLOC_FLAG_FREEING));
> -			goto out_agbp_relse;
>  		}
>  	}
>  
> @@ -2533,11 +2532,10 @@ xfs_alloc_fix_freelist(
>  	 */
>  	if (!agbp) {
>  		error = xfs_alloc_read_agf(mp, tp, args->agno, flags, &agbp);
> -		if (error)
> -			goto out_no_agbp;
> -		if (!agbp) {
> -			ASSERT(flags & XFS_ALLOC_FLAG_TRYLOCK);
> -			ASSERT(!(flags & XFS_ALLOC_FLAG_FREEING));
> +		if (error) {
> +			/* Couldn't lock the AGF so skip this AG. */
> +			if (error == -EAGAIN)
> +				error = 0;
>  			goto out_no_agbp;
>  		}
>  	}
> @@ -2768,11 +2766,10 @@ xfs_alloc_pagf_init(
>  	xfs_buf_t		*bp;
>  	int			error;
>  
> -	if ((error = xfs_alloc_read_agf(mp, tp, agno, flags, &bp)))
> -		return error;
> -	if (bp)
> +	error = xfs_alloc_read_agf(mp, tp, agno, flags, &bp);
> +	if (!error)
>  		xfs_trans_brelse(tp, bp);
> -	return 0;
> +	return error;
>  }
>  
>  /*
> @@ -2961,12 +2958,6 @@ xfs_read_agf(
>  	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
>  			XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
>  			XFS_FSS_TO_BB(mp, 1), flags, bpp, &xfs_agf_buf_ops);
> -	/*
> -	 * Callers of xfs_read_agf() currently interpret a NULL bpp as EAGAIN
> -	 * and need to be converted to check for EAGAIN specifically.
> -	 */
> -	if (error == -EAGAIN)
> -		return 0;
>  	if (error)
>  		return error;
>  
> @@ -2992,14 +2983,15 @@ xfs_alloc_read_agf(
>  
>  	trace_xfs_alloc_read_agf(mp, agno);
>  
> +	/* We don't support trylock when freeing. */
> +	ASSERT((flags & (XFS_ALLOC_FLAG_FREEING | XFS_ALLOC_FLAG_TRYLOCK)) !=
> +			(XFS_ALLOC_FLAG_FREEING | XFS_ALLOC_FLAG_TRYLOCK));

Does this assert really work?  Shouldn't it be

	ASSERT(!(flags & XFS_ALLOC_FLAG_FREEING) ||
	       !(flags & XFS_ALLOC_FLAG_TRYLOCK));

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
