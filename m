Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:51679 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726044AbeISLQg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 19 Sep 2018 07:16:36 -0400
Date: Wed, 19 Sep 2018 07:40:22 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: delalloc and reflink fixes & tweaks
Message-ID: <20180919054022.GA19507@lst.de>
References: <20180917205354.15401-1-hch@lst.de> <20180917212323.GF16550@dastard> <20180918181728.GA7171@lst.de> <20180918230057.GK27618@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180918230057.GK27618@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Wed, Sep 19, 2018 at 09:00:57AM +1000, Dave Chinner wrote:
> > Careful.  We already have issues because delalloc blocks before EOF don't
> > ever get reclaimed.  This triggers up on xfs/442 with 1k blocksize for
> > me.  I actually have a fix for that now, but that will require dropping
> > one of the cleanup patches from this series, so expect a respin.
> 
> Yeah, I didn't say everything already worked, just that using
> preallocation for delalloc gets rid of the stale data exposure
> problem that has prevented us from doing this in the past.

And I think I have to do the mark preallocations as unwritten now
given that my other fix idea that I wasted the whole day on yesterday
didn't turn out to actually work properly.  Sigh..

> That's sounds like a good idea, and a good direction to head
> towards. No immediate hurry, just trying to understand where you
> might be going with these changes.

I've been working on adding (or resurrecting) and always_cow mode,
which helped to expose all kinds of interesting bugs.  That mode
again will be that base for atomic writes (including safe overwrites)
and a zone block device (aka SMR) mode that also can't write in place.
