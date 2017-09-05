Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:54050 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754121AbdIEWGg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Sep 2017 18:06:36 -0400
Date: Wed, 6 Sep 2017 08:06:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] mkfs: Remove messages printed when blocksize < physical
 sectorsize
Message-ID: <20170905220631.GL17782@dastard>
References: <20170905054442.28615-1-chandan@linux.vnet.ibm.com>
 <20170905063139.GA679@infradead.org>
 <20170905064208.GB15686@vader>
 <2656563.n056MvCHVb@localhost.localdomain>
 <89dbce28-5798-f404-4dc8-a85aae36cdec@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89dbce28-5798-f404-4dc8-a85aae36cdec@kernel.dk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, Omar Sandoval <osandov@osandov.com>, Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, sandeen@sandeen.net, Omar Sandoval <osandov@fb.com>, linux-block@vger.kernel.org

On Tue, Sep 05, 2017 at 09:00:26AM -0600, Jens Axboe wrote:
> On 09/05/2017 01:37 AM, Chandan Rajendra wrote:
> > On Tuesday, September 5, 2017 12:12:08 PM IST Omar Sandoval wrote:
> >> On Mon, Sep 04, 2017 at 11:31:39PM -0700, Christoph Hellwig wrote:
> >>> On Tue, Sep 05, 2017 at 11:14:42AM +0530, Chandan Rajendra wrote:
> >>>> Linux kernel commit 6c6b6f28b3335fd85ec833ee0005d9c9dca6c003 (loop: set
> >>>> physical block size to PAGE_SIZE) now sets PAGE_SIZE as the default
> >>>> physical sector size of loop devices. On ppc64, this causes loop devices
> >>>> to have 64k as the physical sector size.
> >>>
> >>> Eek.  We'll need to revert the loop change ASAP!
> >>
> >> Most annoying patch series ever. It hasn't made it to Linus' tree yet,
> >> right? We can revert (although the later change depends on that), fold
> >> in a fix, or apply a fix on top of it, whatever Jens prefers.
> >>
> >>
> > 
> > My bad. 6c6b6f28b3335fd85ec833ee0005d9c9dca6c003 is the commit id from 
> > Linux-next. I don't see this commit in Linus's git tree.
> 
> Right, it's only queued up, and scheduled for the 2nd part of the
> block changes for 4.14. It should have been PAGE_CACHE_SIZE, but
> we don't have that anymore...

But PAGE_CACHE_SIZE was equal to PAGE_SIZE, so that would have been
wrong, too.

I just don't see why this is necessary, given that buffered IO
through the upper filesystem will already be doing page
sized/aligned IO where possible (because that's what the page cache
does!). And for direct IO the loop device should just export the
underlying host filesystem logical/physical sector sizes, which
should be optimal for the backing storage to begin with.

Someone want to enlighten me as to what problem is being solved
here?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
