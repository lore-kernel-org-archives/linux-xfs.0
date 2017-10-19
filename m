Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:42768 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751734AbdJSNOI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Oct 2017 09:14:08 -0400
Date: Thu, 19 Oct 2017 15:14:07 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH for-4.14] xfs: fix AIM7 regression
Message-ID: <20171019131407.GA20645@lst.de>
References: <20171019074705.24827-1-hch@lst.de> <20171019113848.GA8911@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171019113848.GA8911@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Thu, Oct 19, 2017 at 07:38:48AM -0400, Brian Foster wrote:
> On Thu, Oct 19, 2017 at 09:47:05AM +0200, Christoph Hellwig wrote:
> > Apparently our current rwsem code doesn't like doing the trylock, then
> > lock for real scheme.  So change our read/write methods to just do the
> > trylock for the RWF_NOWAIT case.  This fixes a ~25% regression in
> > AIM7.
> > 
> 
> The code looks fine, but this seems really strange. If the trylock
> fails, then wouldn't the blocking lock have slept anyways if done
> initially? Is there any more background info available on this, or
> perhaps a theory on why there is such a significant regression..?

No, unfortunately I don't have a theory, but I agree it is odd
behavior in the rwsem code.
