Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FBF5C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 08:39:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D35132224E
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 08:39:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ncgv9/5L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387959AbgJOIjr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 04:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387873AbgJOIjr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 04:39:47 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 079ECC061755
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 01:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Gbln5Cnj2gSPLdzBq740YaUZzBLghHXFJwyO1YmIt6U=; b=Ncgv9/5LGAvnUGFos0DYDU0omy
        Ccl5GmBIOUi3f4u/8GD69TGwO8Aj2mWR2k62nXT7A5CgbTPR4uoD/5RnMqFuNJD7m8bU8gHDUdbjV
        9yqER09jEkZZihNzYsYkuA7Uupq+PjIqZqsnm5qZr1dgb4xY5LZaEilTGXwkWpeixeWAwpjBDK/gZ
        s6rxjyaZ9EhXZd8bTYb1/rHxTpGkYK6yYV2fkuhLizBew+mQ5K1PTDM3lYH5kID8FPN61P2TUL6LR
        omyq+V4kDnidlZIx8zHJVSzVcTy8zt3dKdB6AJ+IjBX8unBAR/joBCuORqwmFPCpqj4X1cxFTNeY3
        21l3tiCQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kSynZ-000214-NG; Thu, 15 Oct 2020 08:39:45 +0000
Date:   Thu, 15 Oct 2020 09:39:45 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: Re: [PATCH V6 08/11] xfs: Check for extent overflow when remapping
 an extent
Message-ID: <20201015083945.GH5902@infradead.org>
References: <20201012092938.50946-1-chandanrlinux@gmail.com>
 <20201012092938.50946-9-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201012092938.50946-9-chandanrlinux@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch demonstrates very well why I think having these magic
defines and the comments in a header makes no sense.

> +/*
> + * Remapping an extent involves unmapping the existing extent and mapping in the
> + * new extent.
> + *
> + * When unmapping, an extent containing the entire unmap range can be split into
> + * two extents,
> + * i.e. | Old extent | hole | Old extent |
> + * Hence extent count increases by 1.
> + *
> + * Mapping in the new extent into the destination file can increase the extent
> + * count by 1.
> + */
> +#define XFS_IEXT_REFLINK_REMAP_CNT(smap_real, dmap_written) \
> +	(((smap_real) ? 1 : 0) + ((dmap_written) ? 1 : 0))
> +
>  /*
>   * Fork handling.
>   */
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 4f0198f636ad..c9f9ff68b5bb 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1099,6 +1099,11 @@ xfs_reflink_remap_extent(
>  			goto out_cancel;
>  	}
>  
> +	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
> +			XFS_IEXT_REFLINK_REMAP_CNT(smap_real, dmap_written));
> +	if (error)
> +		goto out_cancel;
> +

This is a completely mess.

If OTOH xfs_reflink_remap_extent had a local variable for the potential
max number of extents, which is incremented near the initialization
of smap_real and dmap_written, with a nice comment near to each
increment it would make complete sense to the reader.
