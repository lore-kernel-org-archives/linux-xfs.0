Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:40658 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751317AbdHVFvl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Aug 2017 01:51:41 -0400
Date: Mon, 21 Aug 2017 22:51:36 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Support for data CRC
Message-ID: <20170822055136.GA2697@infradead.org>
References: <20170821190414.long2535xppcxvvd@breakpoint.cc>
 <20170821230232.GS10621@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170821230232.GS10621@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>, linux-xfs@vger.kernel.org

On Tue, Aug 22, 2017 at 09:02:32AM +1000, Dave Chinner wrote:
> On Mon, Aug 21, 2017 at 09:04:15PM +0200, Sebastian Andrzej Siewior wrote:
> > Hi,
> > 
> > my understanding is that only metadata is protected by CRC in the new
> > on-disk format. Are there any plans to also protect data?
> 
> Not in XFS.

I had at least some customer interest in it, although not in the short
term.  Now that we have reflink we can do the required copy on write
mechanisms, but I've not done any more detailed analysis of potential
implementations yet.
