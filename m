Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 259B5C77B7A
	for <linux-xfs@archiver.kernel.org>; Sun, 21 May 2023 01:56:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbjEUB4l (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 20 May 2023 21:56:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjEUB4j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 20 May 2023 21:56:39 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8147D124;
        Sat, 20 May 2023 18:56:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=+ESHnpcV7R4Mbdr+nVVyt6GbZ49e+Lc+MRu1RQfty5E=; b=RRg/CU02C4IHHPvR3dT0O1tiaT
        VidUHzBZyLpIPPZHnHMWNby4c6SS4yeU6CIxez10Y/TTxi6NslDBKOWyZw6UEC0bUX2N9K05/I4Rg
        xgv5K984aNVTid6OQwKsqVHIxSrepZQrJBbWGHTiPrZKX/x+VCiOjMRPMg4KXp483ZfW/OcBbLjmb
        AeFZhLj82GrifxIQ86TfczwK1QuU09lLdc+AZYfLp078SIOgpiIVYJ+souPCEyLcFrud6pp8tNKbs
        oqFhAScCeNK+WEbZ4MhBGsZrRQOOgOV3T9npWkU5/WBUTIwhnYXFcV846ZH8G8JGSGhuQ7ON0CU6R
        ahR9Srew==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1q0YJF-007rpb-9C; Sun, 21 May 2023 01:56:33 +0000
Date:   Sun, 21 May 2023 02:56:33 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Wang Yugui <wangyugui@e16-tech.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: Re: [PATCH 1/3] filemap: Allow __filemap_get_folio to allocate large
 folios
Message-ID: <ZGl6UZ0a+fIAPmn5@casper.infradead.org>
References: <20230520163603.1794256-1-willy@infradead.org>
 <20230520163603.1794256-2-willy@infradead.org>
 <20230521090235.4860.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230521090235.4860.409509F4@e16-tech.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, May 21, 2023 at 09:02:36AM +0800, Wang Yugui wrote:
> > +static inline unsigned fgp_order(size_t size)
> > +{
> > +	unsigned int shift = ilog2(size);
> > +
> > +	if (shift <= PAGE_SHIFT)
> > +		return 0;
> > +	return (shift - PAGE_SHIFT) << 26;
> 
> int overflow will happen when size > 0.5M(2**19)?

I don't see it?

size == 1 << 20;

shift = 20;
return (20 - 12) << 26;

Looks like about 1 << 29 to me.

