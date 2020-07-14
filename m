Return-Path: <SRS0=oQKh=AZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BE6AC433ED
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 11:00:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 865CA20773
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 11:00:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727839AbgGNLAQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jul 2020 07:00:16 -0400
Received: from verein.lst.de ([213.95.11.211]:53816 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727828AbgGNLAQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 14 Jul 2020 07:00:16 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 28D5B68CFC; Tue, 14 Jul 2020 13:00:12 +0200 (CEST)
Date:   Tue, 14 Jul 2020 13:00:11 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Goldwyn Rodrigues <rgoldwyn@suse.de>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        Johannes Thumshirn <jth@kernel.org>,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        cluster-devel@redhat.com, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] iomap: fall back to buffered writes for
 invalidation failures
Message-ID: <20200714110011.GB16178@lst.de>
References: <20200713074633.875946-1-hch@lst.de> <20200713074633.875946-3-hch@lst.de> <20200713115509.GW12769@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200713115509.GW12769@casper.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 13, 2020 at 12:55:09PM +0100, Matthew Wilcox wrote:
> On Mon, Jul 13, 2020 at 09:46:33AM +0200, Christoph Hellwig wrote:
> > Failing to invalid the page cache means data in incoherent, which is
> > a very bad state for the system.  Always fall back to buffered I/O
> > through the page cache if we can't invalidate mappings.
> 
> Is that the right approach though?  I don't have a full picture in my head,
> but wouldn't we be better off marking these pages as !Uptodate and doing
> the direct I/O?

Isn't that a problem if e.g. pages are mapped into userspace and mlocked?
