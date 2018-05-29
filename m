Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:41352 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936855AbeE2Qvd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 May 2018 12:51:33 -0400
Received: by mail-oi0-f53.google.com with SMTP id 11-v6so13670060ois.8
        for <linux-xfs@vger.kernel.org>; Tue, 29 May 2018 09:51:33 -0700 (PDT)
From: lopresti@gmail.com (Patrick J. LoPresti)
Subject: Re: Temporary drive failure leads to massive data corruption?
References: <CAKGkouuK6Dz82JBx2s8cccC-ST_enhF3jyVCHr+w=O_-QeppRw@mail.gmail.com>
        <1b397e88-0e1f-5f33-7def-a38a4a1e484a@sandeen.net>
Date: Tue, 29 May 2018 09:51:27 -0700
In-Reply-To: <1b397e88-0e1f-5f33-7def-a38a4a1e484a@sandeen.net> (Eric
        Sandeen's message of "Fri, 25 May 2018 12:28:18 -0500")
Message-ID: <8636yav20g.fsf@self-evident.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

Eric Sandeen <sandeen@sandeen.net> writes:

> I'm sure you won't like this answer,

Hi, Eric. I know enough about XFS to recognize your name, and it is not
like I am paying for support... So actually I am just grateful for your
reply.

> and I can't base it on empirical evidence, but my first hunch would be
> that your controller did a poor job of recovering from the error, and
> damaged the storage beneath the filesystem.

I admit this is possible, but... We have two RAID containers inside each
JBOD. Each JBOD has a single SAS cable to the hardware RAID card. Only
one of the RAID containers suffered damage; the other container in the
same JBOD is fine.

I can believe the RAID card did not recover particularly gracefully, but
I do not think we lost more than a few blocks on the file system. For
one thing, there wasn't enough time.

Until we ran xfs_repair, that is.

> On a more concrete note, it would be interestting to run xfs_bmap -vv
> on some of those files with zeros and see what extents, if any, cover
> the zeroed ranges.  i.e. are they holes, allocated, unwritten, etc.

I tried this on a few of the damaged files. Here is a typical output:

# xfs_bmap -p -v xxx
    xxx:
   EXT: FILE-OFFSET      BLOCK-RANGE                 AG  AG-OFFSET  TOTAL FLAGS
     0: [0..16255]:      195467240568..195467256823  91  (46229328..46245583)  16256 00000
     1: [16256..715959]: 195477629880..195478329583  91  (56618640..57318343) 699704 00000

Looking at the "zeroed" data ranges (there are several), none of them
are near the beginning nor end of either extent.

None of the files I looked at had FLAGS other than 00000.

All of the zeroed ranges I checked are page-aligned (4K multiple).

It really feels like some small amount of damage in one area of the file
system got amplified into corruption across many files' contents by
xfs_repair.

I do not know much about XFS internals, so forgive me if the following
is stupid... I imagine there are global data structures recording the
free/in-use blocks, as well as local data structures recording the
extents used by each file. Is it possible xfs_repair decided to "trust"
some corrupted global data structure instead of the local extents
associated with each file, and responded by wiping parts of the latter?

In general, could anything cause xfs_repair to zero out whole ranges of
blocks allocated to many files?

Thanks again.

 - Pat
