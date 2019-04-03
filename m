Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:56874 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbfDCDYN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Apr 2019 23:24:13 -0400
Subject: Re: [PATCH v3 2/3] block: verify data when endio
From: "Martin K. Petersen" <martin.petersen@oracle.com>
References: <f65d6a7b-9e69-ae1e-b8b8-8769dc650311@kernel.dk>
        <yq1bm1trb4y.fsf@oracle.com>
        <feefa611-b744-326c-29d5-c64bcda45d9f@kernel.dk>
        <yq17echrax1.fsf@oracle.com>
        <1b638dc2-56fd-6ab4-dcca-ad2adb9931bb@kernel.dk>
        <c9adb48c-7b6e-2017-9480-aa2342b3523b@oracle.com>
        <7599b239-46f4-9799-a87a-3ca3891d4a08@kernel.dk>
        <yq1imw1p0lp.fsf@oracle.com> <20190331220001.GM23020@dastard>
        <yq1ef6lq0sk.fsf@oracle.com> <20190401212115.GQ26298@dastard>
Date: Tue, 02 Apr 2019 22:45:03 -0400
In-Reply-To: <20190401212115.GQ26298@dastard> (Dave Chinner's message of "Tue,
        2 Apr 2019 08:21:15 +1100")
Message-ID: <yq1d0m3olhs.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Bob Liu <bob.liu@oracle.com>, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, shirley.ma@oracle.com, allison.henderson@oracle.com, darrick.wong@oracle.com, hch@infradead.org, adilger@dilger.ca, tytso@mit.edu


Dave,

> Not sure what you mean by "capped to the size you care about". The
> verifier attached to a bio will exactly match the size of the bio
> being issued. AFAICT, coalescing with other bios in the request
> queues should not affect how the completion of that bio is
> handled by things like the RAID layers...

Just wanted to make sure that you wanted an interface that worked on a
bio containing a single logical entity. As opposed to an interface that
permitted you to submit 10 logical entities in one bio and have the
verify function iterate over them at completion time.

> As far as I'm concerned, correcting bad copies is the responisbility
> of the layer that manages the copies. It has nothing to do with the
> filesystem.

Good.

> There is so many varied storage algorithms and recovery options
> (rewrite, partial rewrite, recalc parity/erasure codes and rewrite,
> full stripe rewrite, rebuild onto hot spare due to too many errors,
> etc) it doesn't make sense to only allow repair to be done by
> completely error context-free rewriting from a higher layer. The
> layer that owns the redundancy can make much better decisions aout
> repair

I agree.

> If the storage fails (and it will) and the filesystem cannot recover
> the lost metadata, then it will let the user know and potentially
> shut down the filesystem to protect the rest of the filesystem from
> further damage. That is the current status quo, and the presence or
> absence of automatic block layer retry and repair does not change
> this at all.

No. But hopefully the retry logic will significantly reduce the cases
where shutdown and recovery is required. Availability is super
important.

Also, at least some storage technologies are trending towards becoming
less reliable, not more. So the reality is that recovering from block
errors could become, if not hot path, then at least relatively common
path.

> IOWs, the filesystem doesn't expect hard "always correct" guarantees
> from the storage layers - we always have to assume IO failures will
> occur because they do, even with T10 PI. Hence it makes no sense to
> for an automatic retry-and-recovery infrastructure for filesystems to
> require hard guarantees that the block device will always return good
> data.

I am not expecting hard guarantees wrt. always delivering good data. But
I want predictable behavior of the retry infrastructure.

That's no different from RAID drive failures. Things keep running, I/Os
don't fail until we run out of good copies. But we notify the user that
redundancy is lost so they can decide how to deal with the situation.
Setting the expectation that an I/O failure on the remaining drive would
potentially lead to a filesystem or database shutdown. RAID1 isn't
branded as "we sometimes mirror your data". Substantial effort has gone
into making sure that the mirrors are in sync.

For the retry stuff we should have a similar expectation. It doesn't
have to be fancy. I'm perfectly happy with a check at mkfs/growfs time
that complains if the resulting configuration violates whichever
alignment and other assumptions we end up baking into this.

-- 
Martin K. Petersen	Oracle Linux Engineering
