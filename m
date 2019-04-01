Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:45782 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbfDAOFJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Apr 2019 10:05:09 -0400
Subject: Re: [PATCH v3 2/3] block: verify data when endio
From: "Martin K. Petersen" <martin.petersen@oracle.com>
References: <41c8688a-65bd-96ac-9b23-4facd0ade4a7@kernel.dk>
        <yq1ftr5rbq1.fsf@oracle.com>
        <f65d6a7b-9e69-ae1e-b8b8-8769dc650311@kernel.dk>
        <yq1bm1trb4y.fsf@oracle.com>
        <feefa611-b744-326c-29d5-c64bcda45d9f@kernel.dk>
        <yq17echrax1.fsf@oracle.com>
        <1b638dc2-56fd-6ab4-dcca-ad2adb9931bb@kernel.dk>
        <c9adb48c-7b6e-2017-9480-aa2342b3523b@oracle.com>
        <7599b239-46f4-9799-a87a-3ca3891d4a08@kernel.dk>
        <yq1imw1p0lp.fsf@oracle.com> <20190331220001.GM23020@dastard>
Date: Mon, 01 Apr 2019 10:04:43 -0400
In-Reply-To: <20190331220001.GM23020@dastard> (Dave Chinner's message of "Mon,
        1 Apr 2019 09:00:01 +1100")
Message-ID: <yq1ef6lq0sk.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Bob Liu <bob.liu@oracle.com>, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, shirley.ma@oracle.com, allison.henderson@oracle.com, darrick.wong@oracle.com, hch@infradead.org, adilger@dilger.ca, tytso@mit.edu


Hi Dave!

>> However, that suffers from another headache in that the I/O can get
>> arbitrarily sliced and diced in units of 512 bytes.
>
> Right, but we don't need support that insane case. Indeed, if
> it wasn't already obvious, we _can't support it_ because the
> filesystem verifiers can't do partial verification. i.e.  part of
> the verification is CRC validation of the whole bio, not to mention
> that filesystem structure fragments cannot be safely parsed,
> interpretted and/or verified without the whole structure first being
> read in.

What I thought. There are some things I can verify by masking but it's
limited.

What about journal entries? Would they be validated with 512-byte
granularity or in bundles thereof? Only a problem during recovery, but
potentially a case where we care deeply about trying another copy if it
exists.

What I'm asking is if we should have a block size argument for the
verification? Or would you want to submit bios capped to the size you
care about and let the block layer take care of coalescing?

Validation of units bigger than the logical block size is an area which
our older Oracle HARD technology handles gracefully but which T10 PI has
been unable to address. So this is an area of particular interest to me,
although it's somewhat orthogonal to Bob's retry plumbing.

Another question for you wrt. retries: Once a copy has been identified
as bad and a good copy read from media, who does the rewrite? Does the
filesystem send a new I/O (which would overwrite all copies) or does the
retry plumbing own the responsibility of writing the good bio to the bad
location?

> IOWs, we need to look at this problem from a "whole stack" point of
> view, not just cry about how "bios are too flexible and so make this
> too hard!". The filesystem greatly constrains the alignment and
> slicing/dicing problem to the point where it should be non-existent,
> we have a clearly defined hard stop where verifier propagation
> terminates, and if all else fails we can still detect corruption at
> the filesystem level just like we do now. The worst thing that
> happens here is we give up the capability for automatic block device
> recovery and repair of damaged copies, which we can't do right now,
> so it's essentially status quo...

Having gone down the path of the one-to-many relationship when I did the
original heterogeneous I/O topology attempt, it's pure hell. Also dealt
with similar conundrums for the integrity stuff. So I don't like the
breadcrumb approach. Perfect is the enemy of good and all that.

And I am 100% in agreement on the careful alignment and not making
things complex for crazy use cases (although occasional straddling I/Os
are not as uncommon as we'd like to think). However, I do have concerns
about this particular feature when it comes to your status quo comment.

In order for us to build highly reliable systems, we have to have a
better building block than "this redundancy retry feature works most of
the time". So to me it is imperative that we provide hard guarantees
once a particular configuration has been set up and stacked. And if the
retry guarantee is somehow invalidated, then we really need to let the
user know about it.

-- 
Martin K. Petersen	Oracle Linux Engineering
