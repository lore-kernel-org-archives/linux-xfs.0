Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:25487 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726228AbfBQVJw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Feb 2019 16:09:52 -0500
Date: Mon, 18 Feb 2019 08:09:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [LSF/MM TOPIC] More async operations for file systems - async
 discard?
Message-ID: <20190217210948.GB14116@dastard>
References: <92ab41f7-35bc-0f56-056f-ed88526b8ea4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <92ab41f7-35bc-0f56-056f-ed88526b8ea4@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ric Wheeler <ricwheeler@gmail.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, linux-block@vger.kernel.org

On Sun, Feb 17, 2019 at 03:36:10PM -0500, Ric Wheeler wrote:
> One proposal for btrfs was that we should look at getting discard
> out of the synchronous path in order to minimize the slowdown
> associated with enabling discard at mount time. Seems like an
> obvious win for "hint" like operations like discard.

We already have support for that. blkdev_issue_discard() is
synchornous, yes, but __blkdev_issue_discard() will only build the
discard bio chain - it is up to the caller to submit and wait for it.

Some callers (XFS, dm-thinp, nvmet, etc) use a bio completion to
handle the discard IO completion, hence allowing async dispatch and
processing of the discard chain without blocking the caller. Others
(like ext4) simply call submit_bio_wait() to do wait synchronously
on completion of the discard bio chain.

> I do wonder where we stand now with the cost of the various discard
> commands - how painful is it for modern SSD's?

AIUI, it still depends on the SSD implementation, unfortunately.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
