Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE31EC433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Nov 2021 05:44:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8D6560FE3
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Nov 2021 05:44:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbhKLFr0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 12 Nov 2021 00:47:26 -0500
Received: from verein.lst.de ([213.95.11.211]:60111 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230464AbhKLFr0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 12 Nov 2021 00:47:26 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id B2FF668AA6; Fri, 12 Nov 2021 06:44:34 +0100 (CET)
Date:   Fri, 12 Nov 2021 06:44:34 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Andreas Gruenbacher <agruenba@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com
Subject: Re: [PATCH] iomap: Fix iomap_readahead_iter error handling
Message-ID: <20211112054434.GC27605@lst.de>
References: <20211111140802.577144-1-agruenba@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211111140802.577144-1-agruenba@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 11, 2021 at 03:08:02PM +0100, Andreas Gruenbacher wrote:
> In iomap_readahead_iter, deal with potential iomap_readpage_iter errors.
> 
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> ---
>  fs/iomap/buffered-io.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 1753c26c8e76..9f1e329e8b2c 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -370,6 +370,8 @@ static loff_t iomap_readahead_iter(const struct iomap_iter *iter,
>  			ctx->cur_page_in_bio = false;
>  		}
>  		ret = iomap_readpage_iter(iter, ctx, done);
> +		if (ret < 0)
> +			return ret;

This already is part of your previous patch.
