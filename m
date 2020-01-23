Return-Path: <SRS0=OHiL=3M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1398BC33CAA
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jan 2020 22:20:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD1CF21D7E
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jan 2020 22:20:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SLUmSmAA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbgAWWUQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jan 2020 17:20:16 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:48666 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbgAWWUQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jan 2020 17:20:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=/LH08DpJdwJXvS6KcZ0g1VC3EDcDVsANJdyXH2Z5zeY=; b=SLUmSmAAj2vaBztJ61eLZ6d97
        vexXW9o/AmMVFTdp3DnAaJV8ebVNDZODbYMqm+uhjTQaQlqZOOHD7UKn0zoaKIcDdBHee4Q4VvB+m
        w+A5+eIVG32MUMZwLjznjlO61xNVo5oa6vv8Ht7GVC67nmbpOltfsMxDzr0gkkrXXaSUFiRTEOSI/
        Iw0652BdVkTzmTlK3b0ACz5iXYi9FeEVJSamlRJ+zQxZtATLLVtUm5MwxJ/bAqE0zZ8Sv5C5VXsxO
        XGAjArSwnkoSbuVWSX2fbb9JhkYmAcKPQvGruymT1sDm/e+rSMyCfJO8GKfvC3HJ/iBSSh8J8c0M2
        cjVeBlfcw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iukpj-0006tk-KM; Thu, 23 Jan 2020 22:20:15 +0000
Date:   Thu, 23 Jan 2020 14:20:15 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 02/12] xfs: make xfs_buf_read return an error code
Message-ID: <20200123222015.GA15904@infradead.org>
References: <157976531016.2388944.3654360225810285604.stgit@magnolia>
 <157976532333.2388944.17938500318924937596.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157976532333.2388944.17938500318924937596.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 22, 2020 at 11:42:03PM -0800, Darrick J. Wong wrote:
> -				return -ENOMEM;
> +			error = xfs_buf_read(mp->m_ddev_targp, dblkno, dblkcnt,
> +					0, &bp, &xfs_attr3_rmt_buf_ops);
> +			if (error)
> +				return error;
>  			error = bp->b_error;
>  			if (error) {
>  				xfs_buf_ioerror_alert(bp, __func__);

This still has the bogus b_error check where it should just check the
error and report it based on the return value.

> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 56e081dd1d96..fb60c36a8a5b 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -213,16 +213,25 @@ xfs_buf_get(
>  	return xfs_buf_get_map(target, &map, 1, 0);
>  }
>  
> -static inline struct xfs_buf *
> +static inline int
>  xfs_buf_read(
>  	struct xfs_buftarg	*target,
>  	xfs_daddr_t		blkno,
>  	size_t			numblks,
>  	xfs_buf_flags_t		flags,
> +	struct xfs_buf		**bpp,
>  	const struct xfs_buf_ops *ops)
>  {
> +	struct xfs_buf		*bp;
>  	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
> -	return xfs_buf_read_map(target, &map, 1, flags, ops);
> +
> +	*bpp = NULL;
> +	bp = xfs_buf_read_map(target, &map, 1, flags, ops);
> +	if (!bp)
> +		return -ENOMEM;
> +
> +	*bpp = bp;
> +	return 0;
>  }
>  
>  static inline void
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 0d683fb96396..b29806846916 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2745,10 +2745,10 @@ xlog_recover_buffer_pass2(
>  	if (buf_f->blf_flags & XFS_BLF_INODE_BUF)
>  		buf_flags |= XBF_UNMAPPED;
>  
> -	bp = xfs_buf_read(mp->m_ddev_targp, buf_f->blf_blkno, buf_f->blf_len,
> -			  buf_flags, NULL);
> -	if (!bp)
> -		return -ENOMEM;
> +	error = xfs_buf_read(mp->m_ddev_targp, buf_f->blf_blkno, buf_f->blf_len,
> +			  buf_flags, &bp, NULL);
> +	if (error)
> +		return error;
>  	error = bp->b_error;
>  	if (error) {

.. and same here.

