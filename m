Return-Path: <SRS0=OHiL=3M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCBCFC33CAA
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jan 2020 22:24:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97E9321D7E
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jan 2020 22:24:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sGRBBNlo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729414AbgAWWYm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jan 2020 17:24:42 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:52796 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729387AbgAWWYm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jan 2020 17:24:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=7qtiDkPpIlxpsonpmi+72CWifn5VJQRSm9CX78afidQ=; b=sGRBBNloeYp5ZWfOndNNMS7l2
        bceA3Ck3OBJuFQ/UIM7pbrCoPUEZFXiHsrI0HThXFlfx+Eg2eKHeRSiztVSSnGBtlY5dybxBvdEhs
        GuloWcBHBms9CtXh+oy7YckgQULXB+WDPK+XEFruDJpBgokNXj1GE6pW7/FRIoDR8T2zeLqevGnW8
        b+L7XOFHHt88QYFi9E2wnAMXIgkD5tSrT55/QSbPSbLPEn70Sf1Y85RJlTqb3gNt/QMj3IG50Wq7Y
        ZrvZ5Da0uNkHLqcFH2S7fCDRgcJRvjZ/A0Y8cpUbSEwk+n+uNNjcsl+sxKyulnry8GlsH+bw+U/fl
        G5Kr6wGnQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iuku1-0007m6-P6; Thu, 23 Jan 2020 22:24:41 +0000
Date:   Thu, 23 Jan 2020 14:24:41 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 05/12] xfs: make xfs_buf_read_map return an error code
Message-ID: <20200123222441.GB15904@infradead.org>
References: <157976531016.2388944.3654360225810285604.stgit@magnolia>
 <157976534245.2388944.13378396804109422541.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157976534245.2388944.13378396804109422541.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 22, 2020 at 11:42:22PM -0800, Darrick J. Wong wrote:
> index fc93fd88ec89..df25024275a1 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2956,14 +2956,13 @@ xfs_read_agf(
>  	trace_xfs_read_agf(mp, agno);
>  
>  	ASSERT(agno != NULLAGNUMBER);
> -	error = xfs_trans_read_buf(
> -			mp, tp, mp->m_ddev_targp,
> +	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
>  			XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
>  			XFS_FSS_TO_BB(mp, 1), flags, bpp, &xfs_agf_buf_ops);
> +	if (error == -EAGAIN)
> +		return 0;
>  	if (error)
>  		return error;
> -	if (!*bpp)
> -		return 0;

Shouldn't the change in calling conventions for xfs_trans_read_buf be
in another patch dealing just with xfs_trans_read_buf?

> +		/* bad CRC means corrupted metadata */
> +		if (error == -EFSBADCRC)
> +			error = -EFSCORRUPTED;
> +		return error;

Note that this coukd and should now also go away in the xfs_buf_read()
callers, not just the direct xfs_buf_read_map ones.

> +	error = xfs_buf_read_map(target, map, nmaps, flags, &bp, ops);
> +	switch (error) {
> +	case 0:
> +		break;
> +	case -EFSCORRUPTED:
> +	case -EIO:
>  		if (tp && (tp->t_flags & XFS_TRANS_DIRTY))
> +			xfs_force_shutdown(tp->t_mountp,
> +					SHUTDOWN_META_IO_ERROR);
> +		/* fall through */
> +	default:

Isn't it really EAGAIN the only special case here?  I.e. something
more like:

	if (error && error != -EAGAIN) {
  		if (tp && (tp->t_flags & XFS_TRANS_DIRTY))
			xfs_force_shutdown(tp->t_mountp,
					SHUTDOWN_META_IO_ERROR);
	}

	return error;
