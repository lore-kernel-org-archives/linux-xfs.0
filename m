Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 255A7C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 21:56:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F225061056
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 21:56:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233664AbhHSV4l (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Aug 2021 17:56:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231184AbhHSV4i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Aug 2021 17:56:38 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD175C061575
        for <linux-xfs@vger.kernel.org>; Thu, 19 Aug 2021 14:56:01 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id y190so6791850pfg.7
        for <linux-xfs@vger.kernel.org>; Thu, 19 Aug 2021 14:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oHbvW6UqiCTsRu5vWaf3qnfqFYd/iOMYaaPDkT+6n4k=;
        b=ZLTPQExqKJd8DCa2TyoJWa3XCbsUacLbIOl9KO7oHTE83PBtwK+t7km4R6MNyOTtZi
         SGiazJQsLWTBM7iseMRbLEv2+SegAraOApUKlAGLUjfvHejA0A5vc+V43eVlFy+zTsB9
         uAqCX7733MC+5i3lIosErzuEMthhPZvXXXIps3cRSMnuY8yZIAognhi1QZyoospV8DJm
         t/NY95OUxhJS1NokUENvcK0ev6TDCli4oVp0HinstyrA6hMUnGw1zDIth8EtIHjUh9RH
         nocO/p/V7QFexAOb9XnyfxfhZntIFJ6OEIea2ekTSxFWpQuI9o54TR+ak8fpwuBHCRpl
         Q4LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oHbvW6UqiCTsRu5vWaf3qnfqFYd/iOMYaaPDkT+6n4k=;
        b=YrjeWRzTjU2DPQBHra2FRBtRpKO+MG3/s/LgFrf92iXLn+ngs56iJql06wE8LhsNxL
         e8ZT3auVu9dxwM3OAmcyrKl9/B5zdmv+HHNv4HIBtgs3l1TjXs6F/lFY6/RawKFEJnqk
         31rxTq3e644ljYvck7SKYhO5WmJZ6QHxa6ikfE+Qi9J8mR4tWzTvM9jLjxmQL3XwH6yd
         0nC7ds5j9BBC50LdIn3f+8G8dV94AK0pl/26qH3RJY/q0fmgjQHOvpErzR9OIBVUw4vl
         TkA0iKQIrOjKGGkC/q0HKJwhjb/EPbzKlFfVJFFaSx6TiYoImXZBsYClLIANOGUo99Ny
         jjrg==
X-Gm-Message-State: AOAM533Fogc//NcWF7Bs9ERvumko7mziLikS8Es1PTLE+55217H7y4dq
        5B6o5kCDQ6RDpmAr4u5zZQJIMkJKbP1rsOI/BHHVug==
X-Google-Smtp-Source: ABdhPJy/B2hm2/hWvC7e67tV3MfHtjJtBBELucqps5FMrdqxqVA8mCj+nC4eNLvFYInr3AywzqexVgaoo2GPMcxThDI=
X-Received: by 2002:a63:311:: with SMTP id 17mr15684252pgd.450.1629410161397;
 Thu, 19 Aug 2021 14:56:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210809061244.1196573-1-hch@lst.de> <20210809061244.1196573-24-hch@lst.de>
In-Reply-To: <20210809061244.1196573-24-hch@lst.de>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 19 Aug 2021 14:55:50 -0700
Message-ID: <CAPcyv4jOh8qaTBVM5tRn1S1+Bp2QCW4eoj5Qi0xRw_EwJ0q0ww@mail.gmail.com>
Subject: Re: [PATCH 23/30] fsdax: switch dax_iomap_rw to use iomap_iter
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Shiyang Ruan <ruansy.fnst@fujitsu.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux NVDIMM <nvdimm@lists.linux.dev>, cluster-devel@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Aug 8, 2021 at 11:33 PM Christoph Hellwig <hch@lst.de> wrote:
>
> Switch the dax_iomap_rw implementation to use iomap_iter.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/dax.c | 49 ++++++++++++++++++++++++-------------------------
>  1 file changed, 24 insertions(+), 25 deletions(-)

Looks straightforward,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
