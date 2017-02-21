Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:36230 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751637AbdBUJHt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 Feb 2017 04:07:49 -0500
Date: Tue, 21 Feb 2017 10:07:47 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: transaction reservations for deleting of shared extents
Message-ID: <20170221090747.GA20840@lst.de>
References: <20170220072945.GA17608@lst.de> <20170221014356.GA5844@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170221014356.GA5844@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Mon, Feb 20, 2017 at 05:43:56PM -0800, Darrick J. Wong wrote:
> Hmmmm.  refcountbt updates should all be processed as deferred ops,
> which means that each logical update ("increase refcount of blocks
> 3-300") should be getting its own transaction.

Yes, but we'd still need to figure out how much to allocate for that
transaction.

> The function xfs_refcount_still_have_space tries to guess when we're
> getting close to using up all the log reservation by assuming that each
> refcount update will eventually use 32 bytes of the transaction
> reservation, though it's hard to know precisely what the results of
> formatting the log items will be.

I guess it's getting that estimate wrong.  It's also pretty weird
and different from how we reserve space for transactions everywhere
else in XFS..

> When it thinks we're out of transaction space it'll signal a partial
> completion, which (should) cause the defer_ops mechanism to log an RUD
> and a new RUI, then roll the transaction and start again.  I speculate
> that my guess of 32 bytes per refcountbt update is not correct. :(
> 
> Can you reproduce it easily?  IIRC xfs/140 should exercise some of this
> mechanism.

I personally can't reproduce it easily, but there is a QA setup that
reproduces it reliably, although it takes quite some time. I think I
can send you the reproducer, but it might require the right hardware
to hit the race, given that I can't actually reproduce it.

> 
> --D
---end quoted text---
