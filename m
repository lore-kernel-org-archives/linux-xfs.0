Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:3835 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726199AbfDCWV1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Apr 2019 18:21:27 -0400
Date: Thu, 4 Apr 2019 09:21:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 2/3] block: verify data when endio
Message-ID: <20190403222118.GC26298@dastard>
References: <feefa611-b744-326c-29d5-c64bcda45d9f@kernel.dk>
 <yq17echrax1.fsf@oracle.com>
 <1b638dc2-56fd-6ab4-dcca-ad2adb9931bb@kernel.dk>
 <c9adb48c-7b6e-2017-9480-aa2342b3523b@oracle.com>
 <7599b239-46f4-9799-a87a-3ca3891d4a08@kernel.dk>
 <yq1imw1p0lp.fsf@oracle.com>
 <20190331220001.GM23020@dastard>
 <yq1ef6lq0sk.fsf@oracle.com>
 <20190401212115.GQ26298@dastard>
 <yq1d0m3olhs.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1d0m3olhs.fsf@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, Bob Liu <bob.liu@oracle.com>, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, shirley.ma@oracle.com, allison.henderson@oracle.com, darrick.wong@oracle.com, hch@infradead.org, adilger@dilger.ca, tytso@mit.edu

On Tue, Apr 02, 2019 at 10:45:03PM -0400, Martin K. Petersen wrote:
> 
> Dave,
> 
> > Not sure what you mean by "capped to the size you care about". The
> > verifier attached to a bio will exactly match the size of the bio
> > being issued. AFAICT, coalescing with other bios in the request
> > queues should not affect how the completion of that bio is
> > handled by things like the RAID layers...
> 
> Just wanted to make sure that you wanted an interface that worked on a
> bio containing a single logical entity. As opposed to an interface that
> permitted you to submit 10 logical entities in one bio and have the
> verify function iterate over them at completion time.
> 
> > As far as I'm concerned, correcting bad copies is the responisbility
> > of the layer that manages the copies. It has nothing to do with the
> > filesystem.
> 
> Good.
> 
> > There is so many varied storage algorithms and recovery options
> > (rewrite, partial rewrite, recalc parity/erasure codes and rewrite,
> > full stripe rewrite, rebuild onto hot spare due to too many errors,
> > etc) it doesn't make sense to only allow repair to be done by
> > completely error context-free rewriting from a higher layer. The
> > layer that owns the redundancy can make much better decisions aout
> > repair
> 
> I agree.
> 
> > If the storage fails (and it will) and the filesystem cannot recover
> > the lost metadata, then it will let the user know and potentially
> > shut down the filesystem to protect the rest of the filesystem from
> > further damage. That is the current status quo, and the presence or
> > absence of automatic block layer retry and repair does not change
> > this at all.
> 
> No. But hopefully the retry logic will significantly reduce the cases
> where shutdown and recovery is required. Availability is super
> important.

*nod*

We're on the same page, I think :)

> Also, at least some storage technologies are trending towards becoming
> less reliable, not more. So the reality is that recovering from block
> errors could become, if not hot path, then at least relatively common
> path.

Yup, all the more reason for having some form of generic
verification infrastructure plumbed into the stack.

> > IOWs, the filesystem doesn't expect hard "always correct" guarantees
> > from the storage layers - we always have to assume IO failures will
> > occur because they do, even with T10 PI. Hence it makes no sense to
> > for an automatic retry-and-recovery infrastructure for filesystems to
> > require hard guarantees that the block device will always return good
> > data.
> 
> I am not expecting hard guarantees wrt. always delivering good data. But
> I want predictable behavior of the retry infrastructure.
> 
> That's no different from RAID drive failures. Things keep running, I/Os
> don't fail until we run out of good copies. But we notify the user that
> redundancy is lost so they can decide how to deal with the situation.
> Setting the expectation that an I/O failure on the remaining drive would
> potentially lead to a filesystem or database shutdown. RAID1 isn't
> branded as "we sometimes mirror your data". Substantial effort has gone
> into making sure that the mirrors are in sync.

Oh, I've been assuming that the layers that can do verification
would immediately take steps to correct whatever was detected, and
if the error couldn't be corrected they take whatever action they
normally take when an uncorrectable error is encountered.  i.e.
they'd never silently violate the redundancy guarantees they are
supposed to provide. MD and DM already do this, right? (e.g.
marking arrays degraded and notifying the admin they need to replace
a drive and rebuild.)

> For the retry stuff we should have a similar expectation. It doesn't
> have to be fancy. I'm perfectly happy with a check at mkfs/growfs time
> that complains if the resulting configuration violates whichever
> alignment and other assumptions we end up baking into this.

Makes sense to me. If we can ensure that the alignment requirements
for the stack are communicated in the existing geometry infoi
correctly (i.e. io_min, io_opt) then we've pretty much already got
everything we need in place. We might need a few mkfs tweaks to
ensure the log is placed correctly, log write padding is set
appropriately, and check that inode clusters are appropriately
aligned (I think they are already) but otherwise I think we will be
good here...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
