Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E843AC43214
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Aug 2021 05:39:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C78FD60FA0
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Aug 2021 05:39:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234265AbhHKFjX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Aug 2021 01:39:23 -0400
Received: from verein.lst.de ([213.95.11.211]:39147 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234285AbhHKFjW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 11 Aug 2021 01:39:22 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 66E0A6736F; Wed, 11 Aug 2021 07:38:56 +0200 (CEST)
Date:   Wed, 11 Aug 2021 07:38:56 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Shiyang Ruan <ruansy.fnst@fujitsu.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, nvdimm@lists.linux.dev,
        cluster-devel@redhat.com
Subject: Re: [PATCH 11/30] iomap: add the new iomap_iter model
Message-ID: <20210811053856.GA1934@lst.de>
References: <20210809061244.1196573-1-hch@lst.de> <20210809061244.1196573-12-hch@lst.de> <20210811003118.GT3601466@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210811003118.GT3601466@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 10, 2021 at 05:31:18PM -0700, Darrick J. Wong wrote:
> > +static inline void iomap_iter_done(struct iomap_iter *iter)
> 
> I wonder why this is a separate function, since it only has debugging
> warnings and tracepoints?

The reason for these two sub-helpers was to force me to structure the
code so that Matthews original idea of replacing ->iomap_begin and
->iomap_end with a single next callback so that iomap_iter could
be inlined into callers and the indirect calls could be elided is
still possible.  This would only be useful for a few specific
methods (probably dax and direct I/O) where we care so much, but it
seemed like a nice idea conceptually so I would not want to break it.

OTOH we could just remove this function for now and do that once needed.

> Modulo the question about iomap_iter_done, I guess this looks all right
> to me.  As far as apply.c vs. core.c, I'm not wildly passionate about
> either naming choice (I would have called it iter.c) but ... fmeh.

iter.c is also my preference, but in the end I don't care too much.

