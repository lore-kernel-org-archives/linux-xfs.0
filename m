Return-Path: <SRS0=yxE5=3F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79195C33CB1
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 16:15:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E4FD20728
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 16:15:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PA86rpSo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbgAPQPi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jan 2020 11:15:38 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:37754 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726371AbgAPQPi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jan 2020 11:15:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=GMj13kvzeIt02pSpSaAOa1FhYMGR7ciABGn+5xnjxhk=; b=PA86rpSoqIKfHnUetEr/mX/i4
        PbsjXkfIQpCGeXL9bgPpByP0iy3kbFGtuQQXoGaMXBMbHF0T5agFrsZqCWIr+9dxV5RTQaj1rlzxv
        S3SijKHL9/MZF/p8scUI6t/0ddL0fwDSUNGnnVAPNg7jagYZNNQix3NLtceCue0Huyo4p4Be+K2rU
        HoymhLO9JGmmZxRBOC8hSIksuYu4MDB5zSy/j4X2uRSlgbM0/3OOIhKkU/ItkIsLWxliM9zNWhDJZ
        eHgIs1aBDqz9ethCQHu5MmGJbX9sLsoqoTuXvSARfGw/TYCnV7L+h9HvffDP2pI1vQnQCeEx0nnIA
        dj2agnE3g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1is7o2-00044G-HO; Thu, 16 Jan 2020 16:15:38 +0000
Date:   Thu, 16 Jan 2020 08:15:38 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 2/9] xfs: make xfs_buf_read return an error code
Message-ID: <20200116161538.GB3802@infradead.org>
References: <157910781961.2028217.1250106765923436515.stgit@magnolia>
 <157910783215.2028217.1338010488330820754.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157910783215.2028217.1338010488330820754.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 15, 2020 at 09:03:52AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Convert xfs_buf_read() to return numeric error codes like most
> everywhere else in xfs.

It also does a few more things:

> +	error = bp->b_error;
> +	if (error) {
> +		xfs_buf_ioerror_alert(bp, __func__);

Adds a new call to xfs_buf_ioerror_alert, which exists in most callers.

> +		xfs_buf_stale(bp);
> +		xfs_buf_relse(bp);
> +
> +		/* bad CRC means corrupted metadata */
> +		if (error == -EFSBADCRC)
> +			error = -EFSCORRUPTED;

.. and it remaps this error value.

Both of which look sensible to me, so with that mentioned in the
commit log:

Reviewed-by: Christoph Hellwig <hch@lst.de>
