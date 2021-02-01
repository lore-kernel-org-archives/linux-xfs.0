Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1A55C433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 16:59:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B4EA64DE3
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 16:59:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbhBAQ7L (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Feb 2021 11:59:11 -0500
Received: from verein.lst.de ([213.95.11.211]:42096 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231751AbhBAQ7K (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 Feb 2021 11:59:10 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7D2AE68AFE; Mon,  1 Feb 2021 17:58:26 +0100 (CET)
Date:   Mon, 1 Feb 2021 17:58:25 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, avi@scylladb.com,
        Dave Chinner <david@fromorbit.com>
Subject: Re: reduce sub-block DIO serialisation v4
Message-ID: <20210201165825.GB9858@lst.de>
References: <20210122162043.616755-1-hch@lst.de> <20210123185706.GG1282159@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210123185706.GG1282159@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jan 23, 2021 at 10:57:06AM -0800, Darrick J. Wong wrote:
> On Fri, Jan 22, 2021 at 05:20:32PM +0100, Christoph Hellwig wrote:
> > This takes the approach from Dave, but adds a new flag instead of abusing
> > the nowait one, and keeps a simpler calling convention for iomap_dio_rw.
> 
> Hm.  I realized while putting together for-next branches that I really
> would have preferred the three iomap patches at the start so that I
> could push those parts through the iomap tree.  The changes required to
> resequence the series is minor and the iomap changes (AFAICT) are inert
> if the calling fs doesn't set IOMAP_DIO_OVERWRITE_ONLY, so I think it's
> low risk to push the iomap changes into iomap-for-next as a 5.12 thing.
> 
> The rest of the xfs patches in this series would form the basis of a
> second week pull request (or not) since I think I ought to evaluate the
> effects on performance for a little longer.

So that is the reason why they aren't in for-next yet?  Or do you want
the remaining patches resent on top of the iomap branch?
