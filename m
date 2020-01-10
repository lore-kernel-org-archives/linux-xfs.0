Return-Path: <SRS0=1MH2=27=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCF66C33CA2
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jan 2020 11:55:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3D732072A
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jan 2020 11:55:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="t1sE5Omv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727957AbgAJLzl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jan 2020 06:55:41 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:52726 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727953AbgAJLzk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jan 2020 06:55:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=K2hRgwL8eJP9PvuMsx//Vb/xyldNHtw5Ekg00Ct9N5A=; b=t1sE5Omvj3xHkqOQ+RgR6fcYE
        ha7J2/ka0iGh14EBm1fUhfYejdNsUdH3Z2OJBshb2tzYCmlFurmbUxEHtsIRN9odDeGmnZ5J9pFIj
        IFACPQkHvauKXR/BkonY4XgRhURP9V1lnhtn9tFyLtC5enfwhqxo3rJrc9i4uQXaUpRkBkjjk2Eop
        1aWSU0VgElxjowp7I70VXYiO9a6uAOI7HfU0Xea12rwL7E5p4hb+pxIj+/5UuGY3G43nrdjGAaBkF
        j0ZDI3GxE5yfSaezg8nRayzWrkj8+0lCPTaRX1gnSOBEMQJdQp0rr//+2JDj/cH+kmd0E2AZKISL9
        JMBTO5QTw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ipstA-0000FS-5v; Fri, 10 Jan 2020 11:55:40 +0000
Date:   Fri, 10 Jan 2020 03:55:40 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: refactor remote attr value buffer invalidation
Message-ID: <20200110115540.GC19577@infradead.org>
References: <157859548029.164065.5207227581806532577.stgit@magnolia>
 <157859548668.164065.18078635787497973193.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157859548668.164065.18078635787497973193.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_buf		*bp;
> +	xfs_daddr_t		dblkno;
> +	int			dblkcnt;
> +
> +	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> +
> +	dblkno = XFS_FSB_TO_DADDR(mp, map->br_startblock),
> +	dblkcnt = XFS_FSB_TO_BB(mp, map->br_blockcount);
> +
> +	/*
> +	 * If the "remote" value is in the cache, remove it.
> +	 */
> +	bp = xfs_buf_incore(mp->m_ddev_targp, dblkno, dblkcnt, XBF_TRYLOCK);

Do we really need the dblkno and dblkcnt local variables here?

> @@ -592,18 +614,8 @@ xfs_attr_rmtval_remove(
>  		ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
>  		       (map.br_startblock != HOLESTARTBLOCK));
>  
> -		dblkno = XFS_FSB_TO_DADDR(mp, map.br_startblock),
> -		dblkcnt = XFS_FSB_TO_BB(mp, map.br_blockcount);
> -
> -		/*
> -		 * If the "remote" value is in the cache, remove it.
> -		 */
> -		bp = xfs_buf_incore(mp->m_ddev_targp, dblkno, dblkcnt, XBF_TRYLOCK);
> -		if (bp) {
> -			xfs_buf_stale(bp);
> -			xfs_buf_relse(bp);
> -			bp = NULL;
> -		}
> +		if (map.br_startblock != HOLESTARTBLOCK)
> +			xfs_attr_rmtval_stale(args->dp, &map);

I don't think we need the HOLESTARTBLOCK check here, given that we have
the asserts above.  I also think the assert should move into
xfs_attr_rmtval_stale and be split into two asserts, one each for the
invalid values.
