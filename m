Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:16916 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726412AbfDAVVX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Apr 2019 17:21:23 -0400
Date: Tue, 2 Apr 2019 08:21:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 2/3] block: verify data when endio
Message-ID: <20190401212115.GQ26298@dastard>
References: <f65d6a7b-9e69-ae1e-b8b8-8769dc650311@kernel.dk>
 <yq1bm1trb4y.fsf@oracle.com>
 <feefa611-b744-326c-29d5-c64bcda45d9f@kernel.dk>
 <yq17echrax1.fsf@oracle.com>
 <1b638dc2-56fd-6ab4-dcca-ad2adb9931bb@kernel.dk>
 <c9adb48c-7b6e-2017-9480-aa2342b3523b@oracle.com>
 <7599b239-46f4-9799-a87a-3ca3891d4a08@kernel.dk>
 <yq1imw1p0lp.fsf@oracle.com>
 <20190331220001.GM23020@dastard>
 <yq1ef6lq0sk.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1ef6lq0sk.fsf@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, Bob Liu <bob.liu@oracle.com>, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, shirley.ma@oracle.com, allison.henderson@oracle.com, darrick.wong@oracle.com, hch@infradead.org, adilger@dilger.ca, tytso@mit.edu

On Mon, Apr 01, 2019 at 10:04:43AM -0400, Martin K. Petersen wrote:
> 
> Hi Dave!

Hi Martin!

> >> However, that suffers from another headache in that the I/O can get
> >> arbitrarily sliced and diced in units of 512 bytes.
> >
> > Right, but we don't need support that insane case. Indeed, if
> > it wasn't already obvious, we _can't support it_ because the
> > filesystem verifiers can't do partial verification. i.e.  part of
> > the verification is CRC validation of the whole bio, not to mention
> > that filesystem structure fragments cannot be safely parsed,
> > interpretted and/or verified without the whole structure first being
> > read in.
> 
> What I thought. There are some things I can verify by masking but it's
> limited.
> 
> What about journal entries? Would they be validated with 512-byte
> granularity or in bundles thereof? Only a problem during recovery, but
> potentially a case where we care deeply about trying another copy if it
> exists.

Journal writes are padded to the specified mkfs alignment (i.e. the
"log stripe unit") and are checksummed individually, so they can be
explicitly configured not to cross device boundaries (e.g 32kB
stripe unit on 64k chunk size means exactly 2 journal writes to each
chunk). I took this into account when I said "the filesystem can
constrain the alignment problem entirely at mkfs time"....

> What I'm asking is if we should have a block size argument for the
> verification? Or would you want to submit bios capped to the size you
> care about and let the block layer take care of coalescing?

Not sure what you mean by "capped to the size you care about". The
verifier attached to a bio will exactly match the size of the bio
being issued. AFAICT, coalescing with other bios in the request
queues should not affect how the completion of that bio is
handled by things like the RAID layers...

> Validation of units bigger than the logical block size is an area which
> our older Oracle HARD technology handles gracefully but which T10 PI has
> been unable to address. So this is an area of particular interest to me,
> although it's somewhat orthogonal to Bob's retry plumbing.
> 
> Another question for you wrt. retries: Once a copy has been identified
> as bad and a good copy read from media, who does the rewrite?

As far as I'm concerned, correcting bad copies is the responisbility
of the layer that manages the copies. It has nothing to do with the
filesystem.

> Does the
> filesystem send a new I/O (which would overwrite all copies) or does the
> retry plumbing own the responsibility of writing the good bio to the bad
> location?

There is so many varied storage algorithms and recovery options
(rewrite, partial rewrite, recalc parity/erasure codes and rewrite,
full stripe rewrite, rebuild onto hot spare due to too many errors,
etc) it doesn't make sense to only allow repair to be done by
completely error context-free rewriting from a higher layer. The
layer that owns the redundancy can make much better decisions aout
repair

And let's face it: we don't want to have to add complex IO retry
logic to every single filesystem.

> > IOWs, we need to look at this problem from a "whole stack" point of
> > view, not just cry about how "bios are too flexible and so make this
> > too hard!". The filesystem greatly constrains the alignment and
> > slicing/dicing problem to the point where it should be non-existent,
> > we have a clearly defined hard stop where verifier propagation
> > terminates, and if all else fails we can still detect corruption at
> > the filesystem level just like we do now. The worst thing that
> > happens here is we give up the capability for automatic block device
> > recovery and repair of damaged copies, which we can't do right now,
> > so it's essentially status quo...
> 
> Having gone down the path of the one-to-many relationship when I did the
> original heterogeneous I/O topology attempt, it's pure hell. Also dealt
> with similar conundrums for the integrity stuff. So I don't like the
> breadcrumb approach. Perfect is the enemy of good and all that.
> 
> And I am 100% in agreement on the careful alignment and not making
> things complex for crazy use cases (although occasional straddling I/Os
> are not as uncommon as we'd like to think). However, I do have concerns
> about this particular feature when it comes to your status quo comment.

In what way? This is only one layer of defense from the filesystem
perspective. i.e. If the underlying device cannot verify or correct
the bad metadata it found from another copy/rebuild, then we still
have to fall back to the filesystem rebuilding the metadata. That's
what all the online scrubbing and repair code we're working on in
XFS does, and btrfs is already capable of doing this when CRC errors
are detected.  i.e. the post-IO metadata verifier detects the error,
the online scrub and repair code then kicks in and rebuilds the
bad metadata block from other information in the filesystem.

What we are trying to do is avoid the scrub-and-repair stage in the
filesystem (as it is costly!) by ensuring that the underlying
storage has exhausted all redundancy and repair capabilities it has
before we run the filesystem rebuild phase. Recovering a bad block
from a RAID1/5/6 stripe is much, much faster than rebuilding a
metadata block from other metadata references in the filesystem....

> In order for us to build highly reliable systems, we have to have a
> better building block than "this redundancy retry feature works most of
> the time".

But that is actually good enough when you put a self-repairing
filesystem on top of a block layer that can recover from redundant
information /most of the time/. i.e. to build a reliable storage
system, the filesystem *must* be able to tolerate storage failures
because IO errors and hardware/media corruption can and do happen.

> So to me it is imperative that we provide hard guarantees
> once a particular configuration has been set up and stacked. And if the
> retry guarantee is somehow invalidated, then we really need to let the
> user know about it.

If the storage fails (and it will) and the filesystem cannot recover
the lost metadata, then it will let the user know and potentially
shut down the filesystem to protect the rest of the filesystem from
further damage. That is the current status quo, and the presence or
absence of automatic block layer retry and repair does not change
this at all.

IOWs, I think you're still looking at the problem as a "block
storage layers need to be perfect" problem when, in fact, we do not
need that nor are we asking for it. We have redundancy, rebuild and
reporting apabilities above the block storage layers (i.e. in
filesystems like btrfs and XFS) these days which mean we can
tolerate the lower layers of the storage being less than perfect.

IOWs, the filesystem doesn't expect hard "always correct" guarantees
from the storage layers - we always have to assume IO failures will
occur because they do, even with T10 PI. Hence it makes no sense to
for an automatic retry-and-recovery infrastructure for filesystems
to require hard guarantees that the block device will always return
good data.  Automatic repair doesn't guarantee the storage is free
from errors - it just provides a mechanism to detect errors and
perform optimistic, best effort recovery at the lowest possible
layer in the stack as early as possible.

Cheers,

dave.
-- 
Dave Chinner
david@fromorbit.com
