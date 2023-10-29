Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C43CCC4332F
	for <linux-xfs@archiver.kernel.org>; Sun, 29 Oct 2023 23:22:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231465AbjJ2XWY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 29 Oct 2023 19:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231848AbjJ2XWL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 29 Oct 2023 19:22:11 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 211BA121;
        Sun, 29 Oct 2023 16:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=e7NRE5J4yBZqR0H04zSj76mSU3bYxFrKgKvbigz2r28=; b=EmsjtjrntCdnf9uidPLCUElZDB
        rrLD1wAHhepXZQrvGeOqBYYrY7Tm2+OM6jT7pom/tNGj7AoH891NPoJT8KuPKRh+AQtMYBMCMefDo
        wm8nGdoeNoLPEYQnXSZMLM15uLPaSqp3IWyB6tnhucTKnq8OkQBIBfEc0M9GdszRLCv6VRvaz7BG+
        T1lynS2U8rv14NYjMUt+c7y/24ViXrjkv7SMQGjLsXCBjOxwpQwqezBIlD0j4NLC/6M5emqrwV333
        VVXTpXKU77MAEC886DdrahAN0jCoTeiAqivl/OOSPi04RStNzzcwbeuzwXO+omjsHDhBkFnpQpnCg
        5VkJ8ejg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qxF28-000e0z-RF; Sun, 29 Oct 2023 23:17:28 +0000
Date:   Sun, 29 Oct 2023 23:17:28 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Daniel Gomez <da.gomez@samsung.com>
Cc:     "minchan@kernel.org" <minchan@kernel.org>,
        "senozhatsky@chromium.org" <senozhatsky@chromium.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "djwong@kernel.org" <djwong@kernel.org>,
        "hughd@google.com" <hughd@google.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mcgrof@kernel.org" <mcgrof@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "gost.dev@samsung.com" <gost.dev@samsung.com>,
        Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [RFC PATCH 07/11] shmem: remove huge arg from
 shmem_alloc_and_add_folio()
Message-ID: <ZT7oCHiNa8YZQmzA@casper.infradead.org>
References: <20230919135536.2165715-1-da.gomez@samsung.com>
 <20231028211518.3424020-1-da.gomez@samsung.com>
 <CGME20231028211546eucas1p2147a423b26a6fa92be7e6c20df429da5@eucas1p2.samsung.com>
 <20231028211518.3424020-8-da.gomez@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231028211518.3424020-8-da.gomez@samsung.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Oct 28, 2023 at 09:15:45PM +0000, Daniel Gomez wrote:
> The huge flag is already part of of the memory allocation flag (gfp_t).
> Make use of the VM_HUGEPAGE bit set by vma_thp_gfp_mask() to know if
> the allocation must be a huge page.

... what?

> +	if (gfp & VM_HUGEPAGE) {

Does sparse not complain about this?  VM_HUGEPAGE is never part of
the GFP flags and there's supposed to be annotations that make the
various checkers warn.
