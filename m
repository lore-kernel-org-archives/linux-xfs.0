Return-Path: <SRS0=Htpe=6U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15A29C28CBC
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 14:56:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E58E0208E4
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 14:56:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NCsYv9Rc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728428AbgEFO4h (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 May 2020 10:56:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727984AbgEFO4h (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 10:56:37 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 391AEC061A0F
        for <linux-xfs@vger.kernel.org>; Wed,  6 May 2020 07:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=wWGlPHSN2NIvmB5u6iitGrq71rY8gJA6yXSsJNhULq0=; b=NCsYv9RcDCu1Vp6xmFTbmOsdsl
        lCwP75lLD6cc4T/rct38k97l09dcNMJtMKBNBwxio0SFbRb0Fq1PvvfTBV7QAtARv3tYnRnK+GBHM
        O2y3vpEUcGSlUqsrEqISxUxV0uaIC6csGdSdQMoll4zVS4WwYH5yz4ZTKjDEDM1a50Ly+RUK5tyr8
        ILB4pob5xCxW1gFCPWkWv9cE9iM24u9je0Tg0PKODpVLaN2FkGAFQ8834/UQ5AvA5oSqN8DRJ52X4
        y9RqGhYHjhZAKpvYwekUnCQjc4xeOavCDY6n+RYL5dauWV1tT/24sHO/SpY5n2L/Cc8G6LkIoEhr2
        56KWTf6A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWLTN-000525-15; Wed, 06 May 2020 14:56:33 +0000
Date:   Wed, 6 May 2020 07:56:33 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: clean up the metadata validation in
 xfs_swap_extent_rmap
Message-ID: <20200506145633.GB7864@infradead.org>
References: <158864100980.182577.10199078041909350877.stgit@magnolia>
 <158864102271.182577.2059355876586003107.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158864102271.182577.2059355876586003107.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 04, 2020 at 06:10:22PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Bail out if there's something not right with either file's fork
> mappings.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_bmap_util.c |   31 +++++++++++++++++++++++--------
>  1 file changed, 23 insertions(+), 8 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index cc23a3e23e2d..2774939e176d 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1342,8 +1342,16 @@ xfs_swap_extent_rmap(
>  				&nimaps, 0);
>  		if (error)
>  			goto out;
> -		ASSERT(nimaps == 1);
> -		ASSERT(tirec.br_startblock != DELAYSTARTBLOCK);
> +		if (nimaps != 1 || tirec.br_startblock == DELAYSTARTBLOCK) {
> +			/*
> +			 * We should never get no mapping or a delalloc extent
> +			 * since the donor file should have been flushed by the
> +			 * caller.
> +			 */
> +			ASSERT(0);
> +			error = -EINVAL;
> +			goto out;
> +		}

I'm not even sure the !nimaps case still exists.  Usually this will
return a hole extent, which we don't seem to handle here?

In general I think this code would be improved quite a bit by using
xfs_iext_lookup_extent instead of xfs_bmapi_read.

Same for the second hunk.
