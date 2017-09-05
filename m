Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:34985 "EHLO
        mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752313AbdIEWSx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Sep 2017 18:18:53 -0400
Received: by mail-pf0-f176.google.com with SMTP id g13so9886856pfm.2
        for <linux-xfs@vger.kernel.org>; Tue, 05 Sep 2017 15:18:53 -0700 (PDT)
Date: Tue, 5 Sep 2017 15:18:51 -0700
From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH] mkfs: Remove messages printed when blocksize < physical
 sectorsize
Message-ID: <20170905221851.GA4779@vader>
References: <20170905054442.28615-1-chandan@linux.vnet.ibm.com>
 <20170905063139.GA679@infradead.org>
 <20170905064208.GB15686@vader>
 <2656563.n056MvCHVb@localhost.localdomain>
 <89dbce28-5798-f404-4dc8-a85aae36cdec@kernel.dk>
 <20170905220631.GL17782@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170905220631.GL17782@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Jens Axboe <axboe@kernel.dk>, Chandan Rajendra <chandan@linux.vnet.ibm.com>, Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, sandeen@sandeen.net, Omar Sandoval <osandov@fb.com>, linux-block@vger.kernel.org

On Wed, Sep 06, 2017 at 08:06:31AM +1000, Dave Chinner wrote:
> On Tue, Sep 05, 2017 at 09:00:26AM -0600, Jens Axboe wrote:
> > On 09/05/2017 01:37 AM, Chandan Rajendra wrote:
> > > On Tuesday, September 5, 2017 12:12:08 PM IST Omar Sandoval wrote:
> > >> On Mon, Sep 04, 2017 at 11:31:39PM -0700, Christoph Hellwig wrote:
> > >>> On Tue, Sep 05, 2017 at 11:14:42AM +0530, Chandan Rajendra wrote:
> > >>>> Linux kernel commit 6c6b6f28b3335fd85ec833ee0005d9c9dca6c003 (loop: set
> > >>>> physical block size to PAGE_SIZE) now sets PAGE_SIZE as the default
> > >>>> physical sector size of loop devices. On ppc64, this causes loop devices
> > >>>> to have 64k as the physical sector size.
> > >>>
> > >>> Eek.  We'll need to revert the loop change ASAP!
> > >>
> > >> Most annoying patch series ever. It hasn't made it to Linus' tree yet,
> > >> right? We can revert (although the later change depends on that), fold
> > >> in a fix, or apply a fix on top of it, whatever Jens prefers.
> > >>
> > >>
> > > 
> > > My bad. 6c6b6f28b3335fd85ec833ee0005d9c9dca6c003 is the commit id from 
> > > Linux-next. I don't see this commit in Linus's git tree.
> > 
> > Right, it's only queued up, and scheduled for the 2nd part of the
> > block changes for 4.14. It should have been PAGE_CACHE_SIZE, but
> > we don't have that anymore...
> 
> But PAGE_CACHE_SIZE was equal to PAGE_SIZE, so that would have been
> wrong, too.
> 
> I just don't see why this is necessary, given that buffered IO
> through the upper filesystem will already be doing page
> sized/aligned IO where possible (because that's what the page cache
> does!). And for direct IO the loop device should just export the
> underlying host filesystem logical/physical sector sizes, which
> should be optimal for the backing storage to begin with.
> 
> Someone want to enlighten me as to what problem is being solved
> here?

I already sent a patch to fix this:
https://marc.info/?l=linux-block&m=150464670510301&w=2

Loop was using the default physical block size of 512, which is a lie
according to the definition of the physical block size:

/**
 * blk_queue_physical_block_size - set physical block size for the queue
 * @q:  the request queue for the device
 * @size:  the physical block size, in bytes
 *
 * Description:
 *   This should be set to the lowest possible sector size that the
 *   hardware can operate on without reverting to read-modify-write
 *   operations.
 */

Clearly for buffered loop devices, this unit is a page. The change was
pedantic, so whatever, my patch above makes things backwards compatible.
