Return-Path: <SRS0=oH8U=3G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E806AC33CB1
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jan 2020 06:50:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFE8D2073A
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jan 2020 06:50:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LTSNZQtT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbgAQGuV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Jan 2020 01:50:21 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:51324 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726726AbgAQGuU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jan 2020 01:50:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Ywcma//wbHCAtk0A5X/o7iByK0IE+FImhLHDNF5oMGc=; b=LTSNZQtTYrim44ZwQLRCKVIOx
        n/IK5N2aJkzug9s6w69z7IEZEiQRXmvI+EQ4K/qgyhmCdz3Zcv6gQKEY1YDkuDexSEszJoSj9U1UX
        LicJyr+ciobc6kRZ9NctsIyiBW9QAWRGidqD/CGZMhR9rGCpUw/s+2nuZtltnhjBjvu/kiXVMGhUx
        8wiCo3TZXIcqkFlqiA/jcK/6zbLIuWKtn1bQC1rK+ahIs8qO9o3GEWWEY3dTp7eTH4NtPZzPpPeDp
        UqHFON4Gjz//9vH/i6x6YCTjyu3DGgrVAYicPaF5S7mmJRP0YX/c+NRGHyQ0lGW2vG2vVBRAXmrN5
        1DCvG83fg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1isLSW-00056t-3h; Fri, 17 Jan 2020 06:50:20 +0000
Date:   Thu, 16 Jan 2020 22:50:20 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 05/11] xfs: make xfs_buf_read_map return an error code
Message-ID: <20200117065020.GA26438@infradead.org>
References: <157924221149.3029431.1461924548648810370.stgit@magnolia>
 <157924224846.3029431.3421957295562306193.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157924224846.3029431.3421957295562306193.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> @@ -842,13 +845,15 @@ xfs_buf_read_map(
>  		 * drop the buffer
>  		 */
>  		xfs_buf_relse(bp);
> -		return NULL;
> +		*bpp = NULL;

We already set *bpp to NULL at the very beginning, so this line is
redundant.

> @@ -860,19 +865,18 @@ xfs_buf_read(
>  	struct xfs_buf		**bpp,
>  	const struct xfs_buf_ops *ops)
>  {
>  	int			error;
>  	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
>  
> -	*bpp = NULL;
> -	bp = xfs_buf_read_map(target, &map, 1, flags, ops);
> -	if (!bp)
> -		return -ENOMEM;
> -	error = bp->b_error;
> +	error = xfs_buf_read_map(target, &map, 1, flags, bpp, ops);
> +	if (error)
> +		return error;
> +	error = (*bpp)->b_error;
>  	if (error) {
> +		xfs_buf_ioerror_alert(*bpp, __func__);
> +		xfs_buf_stale(*bpp);
> +		xfs_buf_relse(*bpp);
> +		*bpp = NULL;
>  
>  		/* bad CRC means corrupted metadata */
>  		if (error == -EFSBADCRC)

I still think we have a problem here.  We should not have to check
->b_error, and the xfs_buf_ioerror_alert should be either in the callers
or in xfs_buf_read_map, as xfs_buf_read is just supposed to be a trivial
wrapper for the single map case, not add functionality of its own.
