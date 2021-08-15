Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E9DEC432BE
	for <linux-xfs@archiver.kernel.org>; Sun, 15 Aug 2021 15:37:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82A6F61208
	for <linux-xfs@archiver.kernel.org>; Sun, 15 Aug 2021 15:37:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237950AbhHOPhs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 15 Aug 2021 11:37:48 -0400
Received: from verein.lst.de ([213.95.11.211]:51934 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229603AbhHOPhr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 15 Aug 2021 11:37:47 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3DD6167357; Sun, 15 Aug 2021 17:37:14 +0200 (CEST)
Date:   Sun, 15 Aug 2021 17:37:13 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Sierra <alex.sierra@amd.com>
Cc:     akpm@linux-foundation.org, Felix.Kuehling@amd.com,
        linux-mm@kvack.org, rcampbell@nvidia.com,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        hch@lst.de, jgg@nvidia.com, jglisse@redhat.com,
        John Hubbard <jhubbard@nvidia.com>
Subject: Re: [PATCH v6 02/13] mm: remove extra ZONE_DEVICE struct page
 refcount
Message-ID: <20210815153713.GA32384@lst.de>
References: <20210813063150.2938-1-alex.sierra@amd.com> <20210813063150.2938-3-alex.sierra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210813063150.2938-3-alex.sierra@amd.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 8ae31622deef..d48a1f0889d1 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1218,7 +1218,7 @@ __maybe_unused struct page *try_grab_compound_head(struct page *page, int refs,
>  static inline __must_check bool try_get_page(struct page *page)
>  {
>  	page = compound_head(page);
> -	if (WARN_ON_ONCE(page_ref_count(page) <= 0))
> +	if (WARN_ON_ONCE(page_ref_count(page) < (int)!is_zone_device_page(page)))

Please avoid the overly long line.  In fact I'd be tempted to just not
bother here and keep the old, more lose check.  Especially given that
John has a patch ready that removes try_get_page entirely.
