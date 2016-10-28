Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:11095 "EHLO
        ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751743AbcJ1E3f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Oct 2016 00:29:35 -0400
Date: Fri, 28 Oct 2016 15:29:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [rfc] larger batches for crc32c
Message-ID: <20161028042929.GH22126@dastard>
References: <20161028031747.68472ac7@roar.ozlabs.ibm.com>
 <20161027214244.GO14023@dastard>
 <20161028131234.24a5cb6f@roar.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161028131234.24a5cb6f@roar.ozlabs.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nicholas Piggin <npiggin@gmail.com>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>

On Fri, Oct 28, 2016 at 01:12:34PM +1100, Nicholas Piggin wrote:
> On Fri, 28 Oct 2016 08:42:44 +1100
> Dave Chinner <david@fromorbit.com> wrote:
> > > As a rule, it helps the crc implementation if it can operate on as large a
> > > chunk as possible (alignment, startup overhead, etc). So I did a quick hack
> > > at getting XFS checksumming to feed crc32c() with larger chunks, by setting
> > > the existing crc to 0 before running over the entire buffer. Together with
> > > some small work on the powerpc crc implementation, crc drops below 0.1%.  
> > 
> > I wouldn't have expected reducing call numbers and small alignment
> > changes to make that amount of difference given the amount of data
> > we are actually checksumming. How much of that difference was due to
> > the improved CRC implementation?
> 
> Sorry, I should have been more clear about what was happening. Not enough
> sleep. The larger sizes allows the vectorized crc implementation to kick in.

Ah, ok. So it never gets out of the slow, branchy lead in/lead out
code for the smaller chunks.Fair enough.

For the verify side it probably doesn't matter than much - the
latency of the initial memory fetches on the data to be verified are
likely to be the dominant factor for performance...

> > FWIW, can you provide some additional context by grabbing the log
> > stats that tell us the load on the log that is generating this
> > profile?  A sample over a minute of a typical workload (with a
> > corresponding CPU profile) would probably be sufficient. You can get
> > them simply by zeroing the xfs stats via
> > /proc/sys/fs/xfs/stats_clear at the start of the sample period and
> > then dumping /proc/fs/xfs/stat at the end.
> 
> Yeah I'll get some better information for you.
> 
> > > I don't know if something like this would be acceptable? It's not pretty,
> > > but I didn't see an easier way.  
> > 
> > ISTR we made the choice not to do that to avoid potential problems
> > with potential race conditions and bugs (i.e. don't modify anything
> > in objects on read access) but I can't point you at anything
> > specific...
> 
> Sounds pretty reasonable, especially for the verifiers. For the paths
> that create/update the checksums (including this log checksum), it seems
> like it should be less controversial.

Yup. For the paths that update the checksum we have to have an
exclusive lock on the object (and will always require that), so I
can't see a problem with changing the update code to use this
method.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
