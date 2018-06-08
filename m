Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:39558 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751112AbeFHGTK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Jun 2018 02:19:10 -0400
Date: Thu, 7 Jun 2018 23:19:09 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3 V2] xfs: replace do_mod with native operations
Message-ID: <20180608061909.GA12715@infradead.org>
References: <20180607052751.6541-1-david@fromorbit.com>
 <20180607052751.6541-3-david@fromorbit.com>
 <20180608004357.GW10363@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180608004357.GW10363@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jun 08, 2018 at 10:43:57AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> do_mod() is a hold-over from when we have different sizes for file
> offsets and and other internal values for 40 bit XFS filesystems.
> Hence depending on build flags variables passed to do_mod() could
> change size. We no longer support those small format filesystems and
> hence everything is of fixed size theses days, even on 32 bit
> platforms.
> 
> As such, we can convert all the do_mod() callers to platform
> optimised modulus operations as defined by linux/math64.h.
> Individual conversions depend on the types of variables being used.

I have to admit the XFS helpers are much more intuitive.

>  7 files changed, 66 insertions(+), 50 deletions(-)

And the diffstat agrees with me.

I'd rather see the XFS helpers lifted to the kernel on an as-needed
basis than making the code bigger and more hairy.
