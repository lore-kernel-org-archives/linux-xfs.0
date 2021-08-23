Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 488C0C4320A
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Aug 2021 21:20:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E3C86127B
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Aug 2021 21:20:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232724AbhHWVVG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Aug 2021 17:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232834AbhHWVVE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Aug 2021 17:21:04 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62EBCC061575
        for <linux-xfs@vger.kernel.org>; Mon, 23 Aug 2021 14:20:21 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id a5so10956652plh.5
        for <linux-xfs@vger.kernel.org>; Mon, 23 Aug 2021 14:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6Tta22g6TzCbS8+A5F3hRnTInZTNETaE2nytspmuyiI=;
        b=WmkNeRi7tFECQpCdiAmGDL4hHYzV9+5I3fYvoUDlepLk2e1dCoJMI6zB/qrgiW/KA8
         tjlG4bLQMDL/lTTTfR20oVNEgEEZ9SZi71LCMKYLmB9l7o0IKWQV3x99rHH9jrOdt/aQ
         KvCTbbVrru40KnJ4Ss45A2n6Y2tle0h2j1Fyp9R/qhfGrgpEmPMaySRW6/mu3K7iVXr5
         PxzRBeLG0yaFZc9b/9i/1w066LgdKUZn7jriSCoN6lLiH0EHg9NWUBuRKhMrDkvqUavH
         1ra/FqSzDumL4aMl8uZzZVoN/2mdgv0SPsnRwIrftWCnmVtCvSYcmYp/HvEhrMhW4u3g
         nk6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6Tta22g6TzCbS8+A5F3hRnTInZTNETaE2nytspmuyiI=;
        b=OFL8Aexso9fMvUOWnW7IxUu8LGFmL0mrpfq8yfHBvvSrcoATv98ykhVdrZfdRtNBdh
         kD8R0hrAFGCbsTGXCJSRGcK2ltTLmMpZLMw47JB7XfiZXD+ltl4/mtRuxLBCC/oOmuuW
         +8kcazaPMod060hxspvsgaIw2x7Ef4gYhqXg9qsoyeOQiqZ0fE0tBph77FXqnzGTZlxJ
         eBWROPNJcW5t5U03ofd18prb35SeTRJ/fW5KS83eweP6pnRd3O4kaxVCuimY2JLoV/5C
         mTyDAjJFSN3vZhO3puuVzQ3XaEpYbGMg/2s6VXP3pXSZRWZHjNLWj0lApoRr32z+MAGy
         hl/A==
X-Gm-Message-State: AOAM53141Txwh/tezWsSSlg4Nsiy/h/RUEarCh6aEHeD1V5qi460mQGi
        x5pb7FnlTy/8md+iomgXxA7V0uVTiLPVOU+i6fvUBw==
X-Google-Smtp-Source: ABdhPJzdZDOlIEIUdEe/koFlzTPnIhrvJ+LvlXLPoKCXM8QxzZFIYVnDFkM1MxM7I34jVCC/VnQMg8JkpWiv08lsQpo=
X-Received: by 2002:a17:90b:23d6:: with SMTP id md22mr532829pjb.149.1629753620957;
 Mon, 23 Aug 2021 14:20:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210823123516.969486-1-hch@lst.de> <20210823123516.969486-9-hch@lst.de>
In-Reply-To: <20210823123516.969486-9-hch@lst.de>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Mon, 23 Aug 2021 14:20:10 -0700
Message-ID: <CAPcyv4jR7U2N0-fFE8FUL+fNdY+6f=FNs7ex56F5tsLztA_GJA@mail.gmail.com>
Subject: Re: [PATCH 8/9] xfs: factor out a xfs_buftarg_is_dax helper
To:     Christoph Hellwig <hch@lst.de>
Cc:     Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 23, 2021 at 5:44 AM Christoph Hellwig <hch@lst.de> wrote:
>

I wouldn't mind adding:

"In support of a future change to kill bdev_dax_supported() first move
its usage to a helper."

...but either way:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
