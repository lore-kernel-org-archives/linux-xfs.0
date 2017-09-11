Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:43863 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750920AbdIKGhb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Sep 2017 02:37:31 -0400
Date: Sun, 10 Sep 2017 23:37:29 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Support for data CRC
Message-ID: <20170911063729.GA10489@infradead.org>
References: <20170821190414.long2535xppcxvvd@breakpoint.cc>
 <20170821230232.GS10621@dastard>
 <20170822055136.GA2697@infradead.org>
 <20170822111322.jt66qlzvalsiju6n@breakpoint.cc>
 <20170823061931.GA30488@infradead.org>
 <20170910195026.7ftxcgmwyri5a5fz@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170910195026.7ftxcgmwyri5a5fz@breakpoint.cc>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On Sun, Sep 10, 2017 at 09:50:27PM +0200, Sebastian Andrzej Siewior wrote:
> On 2017-08-22 23:19:31 [-0700], Christoph Hellwig wrote:
> > as part of the reflink feature.  These out of place writes are
> > a requirement to implement data checksums, as otherwise your data
> > and checksum can not be updated atomically.  Everything else is
> > beyond that at this point is vapourware.  We'd have to decided
> So using the journal for atomic updates doesn't work then. Which means
> fragmentation unavoidable.

Well, in theory you could also do data journalling - but in the end
out of place writes are probably going to be more efficient, and at
least for XFS also area already implemented.
