Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:20741 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750940AbdIKGwi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Sep 2017 02:52:38 -0400
Date: Mon, 11 Sep 2017 16:52:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Support for data CRC
Message-ID: <20170911065217.GQ17782@dastard>
References: <20170821190414.long2535xppcxvvd@breakpoint.cc>
 <20170821230232.GS10621@dastard>
 <20170822055136.GA2697@infradead.org>
 <20170822111322.jt66qlzvalsiju6n@breakpoint.cc>
 <20170823061931.GA30488@infradead.org>
 <20170910195026.7ftxcgmwyri5a5fz@breakpoint.cc>
 <20170911063729.GA10489@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170911063729.GA10489@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>, linux-xfs@vger.kernel.org

On Sun, Sep 10, 2017 at 11:37:29PM -0700, Christoph Hellwig wrote:
> On Sun, Sep 10, 2017 at 09:50:27PM +0200, Sebastian Andrzej Siewior wrote:
> > On 2017-08-22 23:19:31 [-0700], Christoph Hellwig wrote:
> > > as part of the reflink feature.  These out of place writes are
> > > a requirement to implement data checksums, as otherwise your data
> > > and checksum can not be updated atomically.  Everything else is
> > > beyond that at this point is vapourware.  We'd have to decided
> > So using the journal for atomic updates doesn't work then. Which means
> > fragmentation unavoidable.
> 
> Well, in theory you could also do data journalling - but in the end
> out of place writes are probably going to be more efficient, and at
> least for XFS also area already implemented.

>From a quick look at the dm-integrity code, it looks like it is just
a journalling block device. i.e. it logs both the data and the
calculated CRC in it's internal journal before writing the data and
CRC to their separate destinations so it can avoid inconsistent
data/CRCs if a crash occurs.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
