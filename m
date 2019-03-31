Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:38463 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731172AbfCaWAG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 31 Mar 2019 18:00:06 -0400
Date: Mon, 1 Apr 2019 09:00:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 2/3] block: verify data when endio
Message-ID: <20190331220001.GM23020@dastard>
References: <41c8688a-65bd-96ac-9b23-4facd0ade4a7@kernel.dk>
 <yq1ftr5rbq1.fsf@oracle.com>
 <f65d6a7b-9e69-ae1e-b8b8-8769dc650311@kernel.dk>
 <yq1bm1trb4y.fsf@oracle.com>
 <feefa611-b744-326c-29d5-c64bcda45d9f@kernel.dk>
 <yq17echrax1.fsf@oracle.com>
 <1b638dc2-56fd-6ab4-dcca-ad2adb9931bb@kernel.dk>
 <c9adb48c-7b6e-2017-9480-aa2342b3523b@oracle.com>
 <7599b239-46f4-9799-a87a-3ca3891d4a08@kernel.dk>
 <yq1imw1p0lp.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1imw1p0lp.fsf@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, Bob Liu <bob.liu@oracle.com>, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, shirley.ma@oracle.com, allison.henderson@oracle.com, darrick.wong@oracle.com, hch@infradead.org, adilger@dilger.ca, tytso@mit.edu

On Fri, Mar 29, 2019 at 10:17:22PM -0400, Martin K. Petersen wrote:
> 
> Jens,
> 
> > You will not need a callback in the bio, you will just have a private
> > end_io function for that particular bio that does the verification.
> 
> The saving grace for the integrity stuff is that once all the child bios
> complete, we no longer care about their completion context and we have
> the parent bio submitted by the filesystem we can use to verify the PI
> against.
> 
> For the redundant copy use case, however, I am guessing that the
> filesystem folks would want the same thing. I.e. verify the structure of
> the data received once the parent bio completes. However, at that point
> all the slicing and dicing completion state is lost.

Right, that's the problem. We already run the verifier on completion
of the bio that the filesytsem sends down the stack, but that then
means....

> And thus there is
> no way to know that the failure was due to mirror B two layers down the
> stack. Nor is there any way to retry the I/O without having recorded a
> completion breadcrumb trail for every child bio.

.... we have this problem when the verifier fails. i.e. the bio
needs to contain sufficient information for the filesystem to
implement some robust retry mechanism without having any clue what
lies below it or what failed.

> The other approach is the callback where each stacking layer--which
> knows about redundancy--can do verification of a bio upon completion.

*nod*

> However, that suffers from another headache in that the I/O can get
> arbitrarily sliced and diced in units of 512 bytes.

Right, but we don't need support that insane case. Indeed, if
it wasn't already obvious, we _can't support it_ because the
filesystem verifiers can't do partial verification. i.e.  part of
the verification is CRC validation of the whole bio, not to mention
that filesystem structure fragments cannot be safely parsed,
interpretted and/or verified without the whole structure first being
read in.

This means the verifier is only useful if the entire IO can be
passed down to the next layer. IOWs, if the bio has to be sliced and
diced to be issued to the next layer down, then we have a hard stop
on verifier propagation. Put simply, the verifier can only be run at
the lowest layer that sees the whole parent bio context. Hence
sliced and diced child bios won't have the parent verifier attached
to them, and so we can ignore the whole "slice and dice" problem
altogether.

Further, arguing about slicing and dicing misses the key observation
that the filesystem can largely avoid slicing and dicing for most
common cases. i.e. the IO sizes (XFS metadata!) we are talking about
here and their alignment to the underlying block devices are very
small and so are extremely unlikely to cross multi-device
boundaries.  And, of course, if the underlying device can't verify
the biofor whatever reason, we'll still do it at the filesystem IO
completion and so detect corruption like we do now.

IOWs, we need to look at this problem from a "whole stack" point of
view, not just cry about how "bios are too flexible and so make this
too hard!". The filesystem greatly constrains the alignment and
slicing/dicing problem to the point where it should be non-existent,
we have a clearly defined hard stop where verifier propagation
terminates, and if all else fails we can still detect corruption at
the filesystem level just like we do now. The worst thing that
happens here is we give up the capability for automatic block device
recovery and repair of damaged copies, which we can't do right now,
so it's essentially status quo...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
