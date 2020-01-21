Return-Path: <SRS0=uPG+=3K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED99BC2D0CE
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 22:52:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1652217F4
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 22:52:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CugBZdCy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgAUWw3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jan 2020 17:52:29 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:42324 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbgAUWw3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jan 2020 17:52:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=NvvBxpTCG38mB7xvC6GlXb9j7CmikpSo262eReUp00o=; b=CugBZdCyTRiztQQXgUegepcIs
        1UzQ1H7bIG8+QG4ZL4wFy17W8OL1SapO8ZRF+BL8vuy95ObECSUJpPhRpb6NyXFhQIo3r8bDMt1g5
        Q4FHtM58va83Ztw3dYrI2xfShSDCsLLniAWszyfmKKrGsSRumGphuqCMYWvv2RFcA8Psdr2vC4cxy
        JX6o30zLyVVrrkdd+2gTJ+OEP+HjTFqkaU3yoLYvMJgTzG/3xWuPwB4mnfWIBCEpZdfnkG6MuRVPQ
        CQrYtBwy11qQwlFyHaPirdA2FdcdzXdoLYqAswpmvN566CJA5Sw5985HIsBhJkbR6fccdMVoDfmfq
        i+O37Qwsw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iu2No-0006r1-FI; Tue, 21 Jan 2020 22:52:28 +0000
Date:   Tue, 21 Jan 2020 14:52:28 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 05/13] xfs: make xfs_buf_read_map return an error code
Message-ID: <20200121225228.GA11169@infradead.org>
References: <157956098906.1166689.13651975861399490259.stgit@magnolia>
 <157956102137.1166689.2159908930036102057.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157956102137.1166689.2159908930036102057.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 20, 2020 at 02:57:01PM -0800, Darrick J. Wong wrote:
> @@ -831,7 +833,8 @@ xfs_buf_read_map(
>  		XFS_STATS_INC(target->bt_mount, xb_get_read);
>  		bp->b_ops = ops;
>  		_xfs_buf_read(bp, flags);
> -		return bp;
> +		*bpp = bp;
> +		return 0;

_xfs_buf_read can return an error, and we are losing that here.  So
we should return the value from _xfs_buf_read, an ensure *bpp is NULL
if it returns an error.  That also means all the b_error check in the
callers of xfs_buf_read_map and xfs_buf_read (and with that the biggest
wart in the buffer cache API) can go away.
