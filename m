Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5351EC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Apr 2022 13:22:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234610AbiD1NZW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Apr 2022 09:25:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231500AbiD1NZV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Apr 2022 09:25:21 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B5DBAC901
        for <linux-xfs@vger.kernel.org>; Thu, 28 Apr 2022 06:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=iZOO7f7Lsvz/BYpBq0fkBFWiiaUEj3WCMTQyMxjFRmc=; b=hYeHT4pApL4QcaJGQTXilB9AMi
        bt94LMzEwnT6lQfURMqDogl3R2fWZ6tcxWHIrUpa/hUbjVhsX5AVlbl/dlyW/jES3EHIfIW4VJSUN
        fEFL6rQYFfOKwf12sZOx48gDVF7lTcfegtpkNjK/CZhJ6tJhwKcfMW15Gl3UBpeiTJ5GGp0s8aCcX
        3k0pcO5EFyFXiXc6yq3GlYZoVu1EI9iScw7npCjE2yvSLwhKAG2uBBn6u0Qx/vMvtaCckrpDMMgFh
        GmUwKc0t9ED31oDheXamUnPm6CjbLuINQ2apYOGBbaBuM8jSzq0rXZU8xrUrNUuw3y+EQBPuMt81r
        0Iz/rKlg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nk45u-006zem-2G; Thu, 28 Apr 2022 13:22:06 +0000
Date:   Thu, 28 Apr 2022 06:22:06 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/8] xfs: intent item whiteouts
Message-ID: <YmqU/n4qkuI3XAlq@infradead.org>
References: <20220427022259.695399-1-david@fromorbit.com>
 <20220427022259.695399-9-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427022259.695399-9-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -39,6 +39,7 @@ STATIC void
>  xfs_bui_item_free(
>  	struct xfs_bui_log_item	*buip)
>  {
> +	kmem_free(buip->bui_item.li_lv_shadow);
>  	kmem_cache_free(xfs_bui_cache, buip);
>  }

Based on the discussion with Darrick:  what about splitting adding
the frees of the shadow buffers into a separate prep patch?

> +	/* clean up log items that had whiteouts */
> +	while (!list_empty(&whiteouts)) {
> +		struct xfs_log_item *item = list_first_entry(&whiteouts,
> +						struct xfs_log_item, li_cil);
> +		list_del_init(&item->li_cil);
> +		trace_xfs_cil_whiteout_unpin(item);
> +		item->li_ops->iop_unpin(item, 1);
> +	}
>  	return;
>  
>  out_skip:
> @@ -1212,6 +1236,14 @@ xlog_cil_push_work(
>  out_abort_free_ticket:
>  	xfs_log_ticket_ungrant(log, ctx->ticket);
>  	ASSERT(xlog_is_shutdown(log));
> +	while (!list_empty(&whiteouts)) {
> +		struct xfs_log_item *item = list_first_entry(&whiteouts,
> +						struct xfs_log_item, li_cil);
> +		list_del_init(&item->li_cil);
> +		trace_xfs_cil_whiteout_unpin(item);
> +		item->li_ops->iop_unpin(item, 1);
> +	}

Sees like this would benefit from a little helper instead of
duplicating the logic?

Otherwise this does look surprisingly nice and simple:

Reviewed-by: Christoph Hellwig <hch@lst.de>
