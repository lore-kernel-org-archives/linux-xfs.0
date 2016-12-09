Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:7748 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752030AbcLIVjF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Dec 2016 16:39:05 -0500
Date: Sat, 10 Dec 2016 08:38:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: icreate transactions should be replayed first
Message-ID: <20161209213820.GQ4326@dastard>
References: <20161209044222.618-1-david@fromorbit.com>
 <20161209142430.GA12400@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161209142430.GA12400@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Fri, Dec 09, 2016 at 06:24:30AM -0800, Christoph Hellwig wrote:
> This looks fine in general.  One thing that confused be a bit is
> that list_move will reorder them in a lifo way, but given that
> inode create transactions shouldn't depend on each other that's
> fine in the end.

Yeah, I don't see an easy way around that. But all the create
items are in the same transaction, so it shouldn't matter what order
the get replayed in as long as they come first...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
