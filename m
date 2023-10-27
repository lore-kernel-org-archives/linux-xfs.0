Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3472BC25B47
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Oct 2023 10:48:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345516AbjJ0KsA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 Oct 2023 06:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345488AbjJ0KsA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Oct 2023 06:48:00 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E3E018A;
        Fri, 27 Oct 2023 03:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=A6XT05o/YE2YAl7azzjql+Nv40UT9xpao7WebDopBsY=; b=QLzFUm9EY9T91kssbRS85ZWl8p
        ejBCVRpRQDFD7nhXbaIk8pEScp5lWkESy2fpXogkUqmYyZd66nt9kAmuCzg8vW6I+Oos/Cc0Afwu+
        UHVCweSBtJUGwi+I4XM+cWkhbWmbqDI2zOs7rMTflj28FAWhnA6veVrB8UmJ5gmgb5Q5lsJb2HxIZ
        EBWkIXuwT7yoxAgml9QoNHmb2tR+fKAHNvdYxJ3vVCI01neDUf1zChw4udnHDiOUhdTzaPCIqU3wj
        Omc3w/ph0SCAAvzEIt3olVe+PHwOLMa4bqvx3JWYQoI8XuHIXOcTgn4p8E2IKfxuD9jG9k3JQnPlh
        3AtytAxQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qwKNZ-002xPE-Kr; Fri, 27 Oct 2023 10:47:49 +0000
Date:   Fri, 27 Oct 2023 11:47:49 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Pankaj Raghav <p.raghav@samsung.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Pankaj Raghav <kernel@pankajraghav.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        djwong@kernel.org, mcgrof@kernel.org, da.gomez@samsung.com,
        gost.dev@samsung.com, david@fromorbit.com
Subject: Re: [PATCH] iomap: fix iomap_dio_zero() for fs bs > system page size
Message-ID: <ZTuVVSD1FnQ7qPG5@casper.infradead.org>
References: <20231026140832.1089824-1-kernel@pankajraghav.com>
 <CGME20231027051855eucas1p2e465ca6afc8d45dc0529f0798b8dd669@eucas1p2.samsung.com>
 <20231027051847.GA7885@lst.de>
 <1e7e9810-9b06-48c4-aec8-d4817cca9d17@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1e7e9810-9b06-48c4-aec8-d4817cca9d17@samsung.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 27, 2023 at 10:03:15AM +0200, Pankaj Raghav wrote:
> I also noticed this pattern in fscrypt_zeroout_range_inline_crypt().
> Probably there are more places which could use a ZERO_FOLIO directly
> instead of iterating with ZERO_PAGE.
> 
> Chinner also had a similar comment. It would be nice if we can reserve
> a zero huge page that is the size of MAX_PAGECACHE_ORDER and add it as
> one folio to the bio.

i'm on holiday atm.  start looking at mm_get_huge_zero_page()
