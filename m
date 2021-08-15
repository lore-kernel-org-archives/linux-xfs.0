Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF6A4C432BE
	for <linux-xfs@archiver.kernel.org>; Sun, 15 Aug 2021 09:16:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB2DA61057
	for <linux-xfs@archiver.kernel.org>; Sun, 15 Aug 2021 09:16:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236862AbhHOJRW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 15 Aug 2021 05:17:22 -0400
Received: from verein.lst.de ([213.95.11.211]:51414 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236733AbhHOJRW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 15 Aug 2021 05:17:22 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2F2856736F; Sun, 15 Aug 2021 11:16:49 +0200 (CEST)
Date:   Sun, 15 Aug 2021 11:16:48 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Sierra <alex.sierra@amd.com>
Cc:     akpm@linux-foundation.org, Felix.Kuehling@amd.com,
        linux-mm@kvack.org, rcampbell@nvidia.com,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        hch@lst.de, jgg@nvidia.com, jglisse@redhat.com
Subject: Re: [PATCH v6 06/13] include/linux/mm.h: helpers to check zone
 device generic type
Message-ID: <20210815091648.GC25067@lst.de>
References: <20210813063150.2938-1-alex.sierra@amd.com> <20210813063150.2938-7-alex.sierra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210813063150.2938-7-alex.sierra@amd.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 13, 2021 at 01:31:43AM -0500, Alex Sierra wrote:
> Two helpers added. One checks if zone device page is generic
> type. The other if page is either private or generic type.
> 
> Signed-off-by: Alex Sierra <alex.sierra@amd.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
