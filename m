Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:49334 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbfB0NYy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Feb 2019 08:24:54 -0500
Date: Wed, 27 Feb 2019 05:24:51 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [LSF/MM TOPIC] More async operations for file systems - async
 discard?
Message-ID: <20190227132451.GL11592@bombadil.infradead.org>
References: <92ab41f7-35bc-0f56-056f-ed88526b8ea4@gmail.com>
 <20190217210948.GB14116@dastard>
 <46540876-c222-0889-ddce-44815dcaad04@gmail.com>
 <20190220234723.GA5999@localhost.localdomain>
 <yq18sy8ili7.fsf@oracle.com>
 <20190222164504.GB10066@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190222164504.GB10066@localhost.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Keith Busch <keith.busch@intel.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Ric Wheeler <ricwheeler@gmail.com>, Dave Chinner <david@fromorbit.com>, lsf-pc@lists.linux-foundation.org, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, linux-block@vger.kernel.org

On Fri, Feb 22, 2019 at 09:45:05AM -0700, Keith Busch wrote:
> On Thu, Feb 21, 2019 at 09:51:12PM -0500, Martin K. Petersen wrote:
> > 
> > Keith,
> > 
> > > With respect to fs block sizes, one thing making discards suck is that
> > > many high capacity SSDs' physical page sizes are larger than the fs
> > > block size, and a sub-page discard is worse than doing nothing.
> > 
> > That ties into the whole zeroing as a side-effect thing.
> > 
> > The devices really need to distinguish between discard-as-a-hint where
> > it is free to ignore anything that's not a whole multiple of whatever
> > the internal granularity is, and the WRITE ZEROES use case where the end
> > result needs to be deterministic.
> 
> Exactly, yes, considering the deterministic zeroing behavior. For devices
> supporting that, sub-page discards turn into a read-modify-write instead
> of invalidating the page.  That increases WAF instead of improving it
> as intended, and large page SSDs are most likely to have relatively poor
> write endurance in the first place.
> 
> We have NVMe spec changes in the pipeline so devices can report this
> granularity. But my real concern isn't with discard per se, but more
> with the writes since we don't support "sector" sizes greater than the
> system's page size. This is a bit of a different topic from where this
> thread started, though.

I don't understand how reporting a larger discard granularity helps.
Sure, if the file was written block-by-block in that large granularity
to begin with, then the drive can invalidate an entire page.  But if
even one page of that, say, 256kB block was rewritten, then discarding
the 256kB block will need to discard 252kB from one erase block and 4kB
from another erase block.

So it looks like you really just want to report a larger "optimal IO
size", which I thought we already had.
