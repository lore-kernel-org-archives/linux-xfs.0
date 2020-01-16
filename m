Return-Path: <SRS0=yxE5=3F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D011EC33CB1
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 16:21:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A267A206D9
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 16:21:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aTOC4+iM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729149AbgAPQVt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jan 2020 11:21:49 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:38006 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726867AbgAPQVs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jan 2020 11:21:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=7uyMSUe5fGIx3kNEng+GBAerC2MVr0RSfeDuPe7xDyw=; b=aTOC4+iMSmOa4o4NFTmhGyWBx
        abE6yMgGRDBGt9zyanpuT5ADQecEMc6v+US0nQEHSG34tWIecSyS31cVhZbx7aRe1n6UpI1/dIfwr
        VNgzwGR50rsqln5R1q/xGiSbmWaKNFeu5j5Wce6Nt45nt4s1sdiewM3rihtHgbyg9nWA4BE0YSC4O
        UGskI1nBCMsITdxTrsdb6j3UmjCR3/1hCqUyFmdSh02Qy/5gjcHK3ThSS6JjGc8eRoVz/gVBwutCp
        md6+tRiYL6nAZXgyLYp6BUf3ERavcsY2Yv+GuDU2/ZhnzrcJxkCsbU91aEZAJzfca/X49MBqZdl/A
        swr+b86bQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1is7u0-0005vu-G8; Thu, 16 Jan 2020 16:21:48 +0000
Date:   Thu, 16 Jan 2020 08:21:48 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 5/9] xfs: make xfs_buf_read_map return an error code
Message-ID: <20200116162148.GE3802@infradead.org>
References: <157910781961.2028217.1250106765923436515.stgit@magnolia>
 <157910785108.2028217.14921731819456574224.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157910785108.2028217.14921731819456574224.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> @@ -2960,6 +2960,10 @@ xfs_read_agf(
>  			mp, tp, mp->m_ddev_targp,
>  			XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
>  			XFS_FSS_TO_BB(mp, 1), flags, bpp, &xfs_agf_buf_ops);
> +	if (error == -EAGAIN && (flags & XBF_TRYLOCK)) {

Given that EAGAIN is only returned in the XBF_TRYLOCK case the check
for XBF_TRYLOCK should not be required.

> +		*bpp = NULL;
> +		return 0;

Also we should make sure in the lowest layers to never return a
non-NULL bpp if returning an error to avoid this boilerplate code.

> -	if (!bp)
> -		return -ENOMEM;
> +	error = xfs_buf_read_map(target, &map, 1, flags, &bp, ops);
> +	if (error)
> +		return error;
>  	error = bp->b_error;
>  	if (error) {
>  		xfs_buf_ioerror_alert(bp, __func__);

The extra checking of bp->b_error shoudn't be required now.  That almost
means we might have to move the xfs_buf_ioerror_alert into
xfs_buf_read_map.

That also means xfs_buf_read can be turned into a simple inline
function again.
