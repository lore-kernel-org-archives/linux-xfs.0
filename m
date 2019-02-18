Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:28706 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727266AbfBRCWs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Feb 2019 21:22:48 -0500
Date: Mon, 18 Feb 2019 13:22:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [LSF/MM TOPIC] More async operations for file systems - async
 discard?
Message-ID: <20190218022243.GC14116@dastard>
References: <92ab41f7-35bc-0f56-056f-ed88526b8ea4@gmail.com>
 <20190217210948.GB14116@dastard>
 <46540876-c222-0889-ddce-44815dcaad04@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46540876-c222-0889-ddce-44815dcaad04@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ric Wheeler <ricwheeler@gmail.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, linux-block@vger.kernel.org

On Sun, Feb 17, 2019 at 06:42:59PM -0500, Ric Wheeler wrote:
> On 2/17/19 4:09 PM, Dave Chinner wrote:
> >On Sun, Feb 17, 2019 at 03:36:10PM -0500, Ric Wheeler wrote:
> >>One proposal for btrfs was that we should look at getting discard
> >>out of the synchronous path in order to minimize the slowdown
> >>associated with enabling discard at mount time. Seems like an
> >>obvious win for "hint" like operations like discard.
> >We already have support for that. blkdev_issue_discard() is
> >synchornous, yes, but __blkdev_issue_discard() will only build the
> >discard bio chain - it is up to the caller to submit and wait for it.
> >
> >Some callers (XFS, dm-thinp, nvmet, etc) use a bio completion to
> >handle the discard IO completion, hence allowing async dispatch and
> >processing of the discard chain without blocking the caller. Others
> >(like ext4) simply call submit_bio_wait() to do wait synchronously
> >on completion of the discard bio chain.
> >
> >>I do wonder where we stand now with the cost of the various discard
> >>commands - how painful is it for modern SSD's?
> >AIUI, it still depends on the SSD implementation, unfortunately.
> 
> I think the variability makes life really miserable for layers above it.

Yup, that it does.

> Might be worth constructing some tooling that we can use to validate
> or shame vendors over

That doesn't seem to work.

> - testing things like a full device discard,
> discard of fs block size and big chunks, discard against already
> discarded, etc.

We did that many years ago because discard on SSDs sucked:

https://people.redhat.com/lczerner/discard/test_discard.html
https://sourceforge.net/projects/test-discard/files/

And, really, that didn't changed a thing - discard still sucks...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
