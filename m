Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08CDBC433E2
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 08:11:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5BA72075B
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 08:11:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lGInfJiG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgIQILj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 04:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbgIQILh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 04:11:37 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D19C06174A
        for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2020 01:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MJJsGpe1gJWrQvmlzZLPK7AT6SlD02LahKZACC12500=; b=lGInfJiGdnQnRdLxzqLLQuER2C
        B6Lhe6bjEbm1dr+9DOx0khFXUmDDd2IIF3A4M2PYcraus0p/1NdiXuNrWGUaDslOcrC3FYWu1KHIr
        G1znsTd5h50aAuYd9HQvoVue1wRR1C892wL0gGxV4Y/99rwjtlZQYPsUm5NlKWaWg82rNLgVcKlxD
        PQczPPpAnkWiPXpzxdzkTk/+2sqDJVJNHw0rSnnAcSNKc7qQoXYYddaCdAyyLLszIWkqUs1v8/gbm
        dIeYMlQZ9YBe5JJEKaDowWnKERpRV7sOpjfvtOjDgoaf+jqPxQ86JMrlEmu2YE4nPZjx2mN0fYkrq
        /oV2H3Rg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIp0w-00005v-Pn; Thu, 17 Sep 2020 08:11:34 +0000
Date:   Thu, 17 Sep 2020 09:11:34 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: don't free rt blocks when we're doing a REMAP
 bunmapi call
Message-ID: <20200917081134.GD26262@infradead.org>
References: <160031330694.3624286.7407913899137083972.stgit@magnolia>
 <160031331319.3624286.3971628628820322437.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160031331319.3624286.3971628628820322437.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 16, 2020 at 08:28:33PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When callers pass XFS_BMAPI_REMAP into xfs_bunmapi, they want the extent
> to be unmapped from the given file fork without the extent being freed.
> We do this for non-rt files, but we forgot to do this for realtime
> files.  So far this isn't a big deal since nobody makes a bunmapi call
> to a rt file with the REMAP flag set, but don't leave a logic bomb.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c |    9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 1b0a01b06a05..e8cd0012a017 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -5057,9 +5057,12 @@ xfs_bmap_del_extent_real(
>  				  &mod);
>  		ASSERT(mod == 0);
>  
> -		error = xfs_rtfree_extent(tp, bno, (xfs_extlen_t)len);
> -		if (error)
> -			goto done;
> +		if (!(bflags & XFS_BMAPI_REMAP)) {
> +			error = xfs_rtfree_extent(tp, bno, (xfs_extlen_t)len);
> +			if (error)
> +				goto done;
> +		}
> +
>  		do_fx = 0;
>  		nblks = len * mp->m_sb.sb_rextsize;
>  		qfield = XFS_TRANS_DQ_RTBCOUNT;

We also don't need to calculate bno for this case.
