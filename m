Return-Path: <SRS0=4ojB=6G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AD67C54FCB
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 15:19:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBB3A2074B
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 15:19:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbgDVPTU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Apr 2020 11:19:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:38354 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725779AbgDVPTU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 22 Apr 2020 11:19:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C25F6AA55;
        Wed, 22 Apr 2020 15:19:18 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id CB5B11E0E56; Wed, 22 Apr 2020 17:19:18 +0200 (CEST)
Date:   Wed, 22 Apr 2020 17:19:18 +0200
From:   Jan Kara <jack@suse.cz>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] iomap: Add iomap_iter API
Message-ID: <20200422151918.GA20756@quack2.suse.cz>
References: <20200401152522.20737-1-willy@infradead.org>
 <20200401152522.20737-2-willy@infradead.org>
 <20200401154248.GA2813@infradead.org>
 <20200401184245.GI21484@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200401184245.GI21484@bombadil.infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed 01-04-20 11:42:45, Matthew Wilcox wrote:
> On Wed, Apr 01, 2020 at 08:42:48AM -0700, Christoph Hellwig wrote:
> > > +loff_t iomap_iter(struct iomap_iter *iter, loff_t written)
> > > +{
> > > +	const struct iomap_ops *ops = iter->ops;
> > > +	struct iomap *iomap = &iter->iomap;
> > > +	struct iomap *srcmap = &iter->srcmap;
> > 
> > I think it makes sense to only have members in the iter structure
> > that this function modifies.  That is, just pass inode, ops and flags
> > as explicit parameters.
> 
> One of the annoying things we do when looking at the disassembly is
> spend a lot of instructions shuffling arguments around.  Passing as many
> arguments as possible in a struct minimises that.

Somewhat late to the game but ... from the conversions of "explicit
arguments to struct of arguments" I've seen (e.g. in xarray) compilers seem
to generate somewhat slower code when arguments are passed in structs. From
the profiling I did it just seems that when arguments are passed directly,
they are in registers which is generally the fastest access you can get.
When you pass arguments in structs, compilers just fetch the value from
stack which is slower even if its cached. And when the argument is not used
frequently or there's something else cache heavy going on, you may have to
go to L2 or L3 which is when you feel the pain... E.g. I've observed some
of the xarray functions which were "logically" identical to their
radix-tree counterparts generate non-negligible amount of cache misses when
reading their arguments from the passed struct.

I don't think iomap is as CPU sensitive as xarray (generally there's much
heavier work that happens in the filesystem) so I'd just strive for code
simplicity here. But I wanted to mention this so that it's clear that
pushing arguments to structs isn't free either.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
