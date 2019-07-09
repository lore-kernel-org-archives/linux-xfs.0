Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:33414 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbfGIPoz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jul 2019 11:44:55 -0400
Date: Tue, 9 Jul 2019 08:44:47 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 19/24] xfs: use bios directly to read and write the log
 recovery buffers
Message-ID: <20190709154447.GR1404256@magnolia>
References: <20190605191511.32695-1-hch@lst.de>
 <20190605191511.32695-20-hch@lst.de>
 <20190708073740.GI7689@dread.disaster.area>
 <20190708161919.GN1404256@magnolia>
 <20190708213423.GA18177@lst.de>
 <20190708221508.GJ7689@dread.disaster.area>
 <20190709152330.GA3945@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190709152330.GA3945@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On Tue, Jul 09, 2019 at 05:23:30PM +0200, Christoph Hellwig wrote:
> On Tue, Jul 09, 2019 at 08:15:08AM +1000, Dave Chinner wrote:
> > That fixes the problem I saw, but I think bio_chain() needs some
> > more checks to prevent this happening in future. It's trivially
> > easy to chain the bios in the wrong order, very difficult to spot
> > in review, and difficult to trigger in testing as it requires
> > chain nesting and adverse IO timing to expose....
> 
> Not sure how we can better check it.  At best we can set a flag for a
> bio that is a chain "child" and complain if someone is calling
> submit_bio_wait, but that would only really cover the wait case.

I think submit_bio_wait ought to at least WARN_ON_ONCE if it was fed a
bio with bi_end_io already set, which at least would have made it more
obvious that we'd screwed something up in this case, even if the
detection was after we'd already done bio_chain in the wrong order.

Granted IIRC Dave sent a fix for a zeroout integer overflow a while ago
and Jens committed the patch with the debugging assertions removed, so
... yay?

Maybe we just need CONFIG_BLK_DEBUG for these kinds of assertions so
that ignorant clods like me have another line of defense against bugs
and the growing crowd of people who care about performance above
correctness can crash faster. <grumble>

> But one thing I planned to do is to lift xfs_chain_bio to the block
> layer so that people can use it for any kind of continuation bio
> instead of duplicating the logic.

That'll help, I suspect. :)

--D
