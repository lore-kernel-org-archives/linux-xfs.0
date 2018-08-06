Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:32154 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726408AbeHFEq4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Aug 2018 00:46:56 -0400
Date: Mon, 6 Aug 2018 12:37:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/6] xfs: avoid COW fork extent lookups in writeback if
 the fork didn't change
Message-ID: <20180806023738.GC7395@dastard>
References: <20180717232405.18511-1-hch@lst.de>
 <20180717232405.18511-7-hch@lst.de>
 <20180721232311.GA1691@dastard>
 <20180723074940.GA18816@lst.de>
 <20180724223523.GO4813@magnolia>
 <20180727151039.GA29982@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180727151039.GA29982@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Fri, Jul 27, 2018 at 05:10:39PM +0200, Christoph Hellwig wrote:
> On Tue, Jul 24, 2018 at 03:35:23PM -0700, Darrick J. Wong wrote:
> > > mutex_unlock contains a barrier, and the sequence is a single register
> > > read.  There is nothing holding a lock here would help us with.
> > 
> > Which mutex_unlock is that?
> 
> Actually an up_write (on i_lock), but the result is the same.

I'm not sure it is - I've lost count of the number of times I've
heard the phrase "unlock does not provide a memory barrier, only
unlock to lock provides a full memory barrier".  As such, I've
always treated unlock as a store (release) barrier to keep stores
inside the critical section, and lock as the correspending load
barrier to keep loads inside the critical section.

I think that's irrelevant, anyway, because there is no memory
barrier implied until the ILOCK is dropped. i.e. we can change the
value before making the extent modification, but there's no
guarantee that it's visible to other CPUs until the store memory
barrier occurs when the ILOCK is dropped. i.e. after the extent map
has actually been changed.

And, FWIW, without read-side memory barriers before checking the
value, the load can be re-ordered and perhaps even elided by the
optimising compiler.

IOWs, I can't see any reliable access serialisation being provided
by holding the ILOCK while modifying the value. Perhaps this should
use WRITE_ONCE/READ_ONCE to ensure the correct memory barriers are
used to serialise tthe sequence count against itself rather than the
wider inode extent modification process?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
