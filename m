Return-Path: <SRS0=WPjR=DA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECEC8C4363D
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 07:16:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97C7E235FC
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 07:16:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LrXaFcYp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgIWHQR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Sep 2020 03:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbgIWHQQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Sep 2020 03:16:16 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C80C061755
        for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2020 00:16:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=YniORjxpFEZM0xhu9GueILeHdSIXnvlykBn4m28OvdQ=; b=LrXaFcYpKPijJMLS/yb1hhhjQD
        JVdM9Nqj1vMFAPDb+J757p6Ce0SwtSECIM+pxgCms8IM+UNP7Z1l31xrKCuu19HmL8cdIfJ/5qaYc
        FX7K6G17rR32apSOsZoKxkP64LDt4Qo1FPeKlJaTDGwtXNMFD9TGAJBn+n0yWzzvfBvebv8uoxhsI
        v8u8vymS3x4HF1hq6DNN7yUERb/UHiSr1lp20aM8qtEebr2iBoBLuoKgnvezexwY2ITXSbYFs9eoq
        sdxFwmnnwgD3nTKJylQPMr5vtAayN+6MZUt1gEe5aMxWuMzGttGph4xiq873yygynjXE/xP51ZGMX
        C6Ar2Bhg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kKz0g-00083U-Q8; Wed, 23 Sep 2020 07:16:14 +0000
Date:   Wed, 23 Sep 2020 08:16:14 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 1/3] xfs: clean up bmap intent item recovery checking
Message-ID: <20200923071614.GA29203@infradead.org>
References: <160031336397.3624582.9639363323333392474.stgit@magnolia>
 <160031337029.3624582.3821482653073391016.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160031337029.3624582.3821482653073391016.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 16, 2020 at 08:29:30PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The bmap intent item checking code in xfs_bui_item_recover is spread all
> over the function.  We should check the recovered log item at the top
> before we allocate any resources or do anything else, so do that.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_bmap_item.c |   57 ++++++++++++++++--------------------------------
>  1 file changed, 19 insertions(+), 38 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 0a0904a7650a..877afe76d76a 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -437,17 +437,13 @@ xfs_bui_item_recover(
>  	xfs_fsblock_t			inode_fsb;
>  	xfs_filblks_t			count;
>  	xfs_exntst_t			state;
> -	enum xfs_bmap_intent_type	type;
> -	bool				op_ok;
>  	unsigned int			bui_type;
>  	int				whichfork;
>  	int				error = 0;
>  
>  	/* Only one mapping operation per BUI... */
> -	if (buip->bui_format.bui_nextents != XFS_BUI_MAX_FAST_EXTENTS) {
> -		xfs_bui_release(buip);
> -		return -EFSCORRUPTED;
> -	}
> +	if (buip->bui_format.bui_nextents != XFS_BUI_MAX_FAST_EXTENTS)
> +		goto garbage;

We don't really need the xfs_bui_release any more, and can stick to
plain "return -EFSCORRUPTED" instead of the goto, but I suspect the
previous patch has taken care of that and you've rebased already?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
