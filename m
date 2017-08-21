Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:60871 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751251AbdHUIQF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 21 Aug 2017 04:16:05 -0400
Date: Mon, 21 Aug 2017 10:16:03 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: another possible integer truncation in xfs
Message-ID: <20170821081603.GA6581@lst.de>
References: <12EF8D94C6F8734FB2FF37B9FBEDD173010E035CD2@EXCHANGE.collogia.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12EF8D94C6F8734FB2FF37B9FBEDD173010E035CD2@EXCHANGE.collogia.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Markus Stockhausen <stockhausen@collogia.de>
Cc: Christoph Hellwig <hch@lst.de>, "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

On Mon, Aug 21, 2017 at 08:01:03AM +0000, Markus Stockhausen wrote:
> Hi Christoph,
> 
> out of curiosity I looked for other use cases of min_t in xfs. At least 
> until 4.12 there is a similar constellation in xfs_dir2_leaf_readbuf:
> 
>   if (trim_map) {
>     mip->map_blocks -= geo->fsbcount;
>     /*
>      * Loop to get rid of the extents for the
>      * directory block.
>      */
>     for (i = geo->fsbcount; i > 0; ) {
>       j = min_t(int, map->br_blockcount, i);
>       map->br_blockcount -= j;
>       map->br_startblock += j;
>       map->br_startoff += j;
> 
> The loop could go havoc if map->br_blockcount is larger than 
> 2G. If you think it could classify for stable feel free to add it too.

I don't think it has a chance to be larger in practice, but we should
fix it anyway.  I'll prepare a patch.

Thanks for spotting this!
