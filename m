Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66F38CCA47B
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jun 2022 18:51:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbiFHSvQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jun 2022 14:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbiFHSvP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jun 2022 14:51:15 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCDD33C07AC;
        Wed,  8 Jun 2022 11:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Xo6IxmvvWlpGe87V9hy8ELSZqpwDluRkQUN9FYsgsO8=; b=rfHHj2ZHW/C/0Kw1dyw2vOw0dn
        036bYpVT7flJX+VCmbfy0jCxWJnwIMEM89kaulpnbntJdGk4aXeMdB+ICG/zDg1bj5dhOO/W1RSZv
        Lh2EiU6/yeCvhq2bzh73Eh2yv5rTz3Lds46+OofoZM/kVNfUkwtTnX8GWyV6Wal2ofWPNrfewTaBy
        mlVSQqy/zQwYxiVU6Ul4Ag0dxEAbV9HbMtnmLeT8yWv8Rteq7W4fvMY9CgAdcIvzErW8cBZ71UKz4
        CgtlAhW5eU0CSNN2J6EPVvlc9qqRKhifABU2IUPoKXqYE9NsoKeMVQXbARZmCTDhCkenqJzTbm2wy
        GRT3tY9A==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nz0lo-00Csxy-51; Wed, 08 Jun 2022 18:51:08 +0000
Date:   Wed, 8 Jun 2022 19:51:08 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org,
        axboe@kernel.dk, Christoph Hellwig <hch@lst.de>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: Re: [PATCH v8 04/14] iomap: Add flags parameter to
 iomap_page_create()
Message-ID: <YqDvnAxPN/nQmQqu@casper.infradead.org>
References: <20220608171741.3875418-1-shr@fb.com>
 <20220608171741.3875418-5-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220608171741.3875418-5-shr@fb.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 08, 2022 at 10:17:31AM -0700, Stefan Roesch wrote:
> +iomap_page_create(struct inode *inode, struct folio *folio, unsigned int flags)
>  {
>  	struct iomap_page *iop = to_iomap_page(folio);
>  	unsigned int nr_blocks = i_blocks_per_folio(inode, folio);
> +	gfp_t gfp;
>  
>  	if (iop || nr_blocks <= 1)
>  		return iop;
>  
> +	if (flags & IOMAP_NOWAIT)
> +		gfp = GFP_NOWAIT;
> +	else
> +		gfp = GFP_NOFS | __GFP_NOFAIL;
> +
>  	iop = kzalloc(struct_size(iop, uptodate, BITS_TO_LONGS(nr_blocks)),
> -			GFP_NOFS | __GFP_NOFAIL);
> +		      gfp);
> +
>  	spin_lock_init(&iop->uptodate_lock);

Umm ... you just changed the gfp flags from NOFAIL to NOWAIT, but you
aren't checking to see if iop creation failed?

