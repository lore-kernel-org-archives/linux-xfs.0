Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87D42E9270E
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Oct 2023 14:32:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233755AbjJEOcT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Oct 2023 10:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234986AbjJEOaJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Oct 2023 10:30:09 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56FDBAD3C
        for <linux-xfs@vger.kernel.org>; Thu,  5 Oct 2023 02:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=WFe1yGlOn9i0zuOQf8+5Qh0VigsFkhmdSPJgUwzlW/c=; b=a+JcheTwmY4VUAkiPeOYW0gCqS
        lUM/V2w5gZyGISGXNiwk9T5Mg3VMcHp9FtZokNzaJDz8uE/vzL5mTmR5kWHoKWxPTjI7vs1KPPdhL
        tbLuJDqv9dKHtrkfQhWgoBsP+1kB2RkAlYNjSYaHMo28HhAXLm2R65FU7ra/TrIbCnyexTYWAOkVd
        lGdeCFh+bmKJqHAauwx2ElkpS9R788Q6Qk84tJAmnwwYRtHgfCiHT1IWJY35i6+CWz5Nbh7VuD/70
        G1/UfQJHpxybbiA2SgCbyL6rbSmzJrahNQ1e1YHTsj02fWP0S6cmQqjiSdU9CY2zMBrPSpuRZarqT
        QfLH+TsQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qoKrZ-001mlt-2X;
        Thu, 05 Oct 2023 09:41:45 +0000
Date:   Thu, 5 Oct 2023 02:41:45 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, john.g.garry@oracle.com
Subject: Re: [PATCH 1/9] xfs: split xfs_bmap_btalloc_at_eof()
Message-ID: <ZR6E2b2ypkgCSgh7@infradead.org>
References: <20231004001943.349265-1-david@fromorbit.com>
 <20231004001943.349265-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231004001943.349265-2-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The split looks good, and much easier to understand than before.

I have a minor nitpick on the callsites below:

> @@ -3612,8 +3612,14 @@ xfs_bmap_btalloc_filestreams(
>  	}
>  
>  	args->minlen = xfs_bmap_select_minlen(ap, args, blen);
> +	if (ap->aeof && ap->offset)
> +		error = xfs_bmap_btalloc_at_eof(ap, args, blen, stripe_align);
> +
> +	if (error || args->fsbno != NULLFSBLOCK)
> +		goto out_low_space;
> +
>  	if (ap->aeof)
> -		error = xfs_bmap_btalloc_at_eof(ap, args, blen, stripe_align,
> +		error = xfs_bmap_btalloc_aligned(ap, args, blen, stripe_align,
>  				true);
>  
>  	if (!error && args->fsbno == NULLFSBLOCK)

I find the way how this is structured not very helpful to the read,
although most of the blame lies with the pre-existing code.  If we'd
check the error where it happens I think it would be way easier to read:

 	args->minlen = xfs_bmap_select_minlen(ap, args, blen);
	if (ap->aeof) {
		if (ap->offset) {
			error = xfs_bmap_btalloc_at_eof(ap, args, blen,
					stripe_align);
			if (error || args->fsbno != NULLFSBLOCK)
				goto out_low_space;
		}

		error = xfs_bmap_btalloc_aligned(ap, args, blen, stripe_align,
 				true);
		if (error || args->fsbno != NULLFSBLOCK)
			goto out_low_space;
	}

	error = xfs_alloc_vextent_near_bno(args, ap->blkno);

The same applies to xfs_bmap_btalloc_best_length.

