Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2479CC4320A
	for <linux-xfs@archiver.kernel.org>; Sun, 15 Aug 2021 15:40:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC16561212
	for <linux-xfs@archiver.kernel.org>; Sun, 15 Aug 2021 15:40:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237917AbhHOPlV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 15 Aug 2021 11:41:21 -0400
Received: from verein.lst.de ([213.95.11.211]:51956 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229603AbhHOPlU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 15 Aug 2021 11:41:20 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id A1BF167357; Sun, 15 Aug 2021 17:40:47 +0200 (CEST)
Date:   Sun, 15 Aug 2021 17:40:47 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Sierra <alex.sierra@amd.com>
Cc:     akpm@linux-foundation.org, Felix.Kuehling@amd.com,
        linux-mm@kvack.org, rcampbell@nvidia.com,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        hch@lst.de, jgg@nvidia.com, jglisse@redhat.com,
        Roger Pau Monne <roger.pau@citrix.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH v6 08/13] mm: call pgmap->ops->page_free for
 DEVICE_GENERIC pages
Message-ID: <20210815154047.GC32384@lst.de>
References: <20210813063150.2938-1-alex.sierra@amd.com> <20210813063150.2938-9-alex.sierra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210813063150.2938-9-alex.sierra@amd.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 13, 2021 at 01:31:45AM -0500, Alex Sierra wrote:
> Add MEMORY_DEVICE_GENERIC case to free_zone_device_page callback.
> Device generic type memory case is now able to free its pages properly.

How is this going to work for the two existing MEMORY_DEVICE_GENERIC
that now change behavior?  And which don't have a ->page_free callback
at all?

> 
> Signed-off-by: Alex Sierra <alex.sierra@amd.com>
> ---
>  mm/memremap.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memremap.c b/mm/memremap.c
> index 5aa8163fd948..5773e15b6ac9 100644
> --- a/mm/memremap.c
> +++ b/mm/memremap.c
> @@ -459,7 +459,7 @@ struct dev_pagemap *get_dev_pagemap(unsigned long pfn,
>  EXPORT_SYMBOL_GPL(get_dev_pagemap);
>  
>  #ifdef CONFIG_DEV_PAGEMAP_OPS
> -static void free_device_private_page(struct page *page)
> +static void free_device_page(struct page *page)
>  {
>  
>  	__ClearPageWaiters(page);
> @@ -498,7 +498,8 @@ void free_zone_device_page(struct page *page)
>  		wake_up_var(&page->_refcount);
>  		return;
>  	case MEMORY_DEVICE_PRIVATE:
> -		free_device_private_page(page);
> +	case MEMORY_DEVICE_GENERIC:
> +		free_device_page(page);
>  		return;
>  	default:
>  		return;
> -- 
> 2.32.0
---end quoted text---
