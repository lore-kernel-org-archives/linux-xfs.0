Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C1EFC07E9B
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jul 2021 12:16:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B4DE6113B
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jul 2021 12:16:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235407AbhGTLff (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Jul 2021 07:35:35 -0400
Received: from verein.lst.de ([213.95.11.211]:54958 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234417AbhGTLff (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Jul 2021 07:35:35 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 33F2B6736F; Tue, 20 Jul 2021 14:16:11 +0200 (CEST)
Date:   Tue, 20 Jul 2021 14:16:11 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH 2/2] iomap: simplify iomap_add_to_ioend
Message-ID: <20210720121611.GA6540@lst.de>
References: <20210720084320.184877-1-hch@lst.de> <20210720084320.184877-2-hch@lst.de> <YPa9HFTyJV4qIqJ+@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YPa9HFTyJV4qIqJ+@casper.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 20, 2021 at 01:10:04PM +0100, Matthew Wilcox wrote:
> On Tue, Jul 20, 2021 at 10:43:20AM +0200, Christoph Hellwig wrote:
> > Now that the outstanding writes are counted in bytes, there is no need
> > to use the low-level __bio_try_merge_page API, we can switch back to
> > always using bio_add_page and simply iomap_add_to_ioend again.
> 
> These two callers were the only external users of __bio_try_merge_page(),
> so it can now be made static to block/bio.c.

Yeah, but doing so in the same merge window will create an annoying
cross dependency.  I have a series to cleanup a whole lot of the
bio_add_page related code including starting to clean up the return
value for the next merge window.
