Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFE90C4338F
	for <linux-xfs@archiver.kernel.org>; Sun, 15 Aug 2021 09:19:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEDF361056
	for <linux-xfs@archiver.kernel.org>; Sun, 15 Aug 2021 09:19:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236862AbhHOJUK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 15 Aug 2021 05:20:10 -0400
Received: from verein.lst.de ([213.95.11.211]:51423 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236733AbhHOJUI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 15 Aug 2021 05:20:08 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2576E6736F; Sun, 15 Aug 2021 11:19:36 +0200 (CEST)
Date:   Sun, 15 Aug 2021 11:19:35 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Sierra <alex.sierra@amd.com>
Cc:     akpm@linux-foundation.org, Felix.Kuehling@amd.com,
        linux-mm@kvack.org, rcampbell@nvidia.com,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        hch@lst.de, jgg@nvidia.com, jglisse@redhat.com
Subject: Re: [PATCH v6 07/13] mm: add generic type support to migrate_vma
 helpers
Message-ID: <20210815091935.GD25067@lst.de>
References: <20210813063150.2938-1-alex.sierra@amd.com> <20210813063150.2938-8-alex.sierra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210813063150.2938-8-alex.sierra@amd.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 13, 2021 at 01:31:44AM -0500, Alex Sierra wrote:
> Device generic type case added for migrate_vma_pages and
> migrate_vma_check_page helpers.
> Both, generic and private device types have the same
> conditions to decide to migrate pages from/to device
> memory.

This reas a little weird mostly because it doesn't use up the line
length nicely:

Add the device generic type case to the migrate_vma_pages and
migrate_vma_check_page helpers.  This new case is handled identically
to the existing device private case.

> +			 * We support migrating to private and generic types for device
> +			 * zone memory.

Don't spill comments over 80 characters.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
