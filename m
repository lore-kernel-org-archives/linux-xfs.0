Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CB39C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Nov 2021 23:37:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 345F461A40
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Nov 2021 23:37:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343683AbhKOXj7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 15 Nov 2021 18:39:59 -0500
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:44402 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244235AbhKOVYk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Nov 2021 16:24:40 -0500
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id D094EA3E4D;
        Tue, 16 Nov 2021 08:21:41 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mmjQ4-009GDy-Ck; Tue, 16 Nov 2021 08:21:40 +1100
Date:   Tue, 16 Nov 2021 08:21:40 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Sean Caron <scaron@umich.edu>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Question regarding XFS crisis recovery
Message-ID: <20211115212140.GN449541@dread.disaster.area>
References: <CAA43vkU_X5Ss0uiKwji3eOPSo00-t-UGO-hNnAUy7-Wuyuce-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA43vkU_X5Ss0uiKwji3eOPSo00-t-UGO-hNnAUy7-Wuyuce-g@mail.gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=epq8cqlX c=1 sm=1 tr=0 ts=6192cf65
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=kj9zAlcOel0A:10 a=vIxV3rELxO4A:10 a=7-415B0cAAAA:8
        a=xSgTIT8fC6Y3WRbsYe4A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 15, 2021 at 12:14:34PM -0500, Sean Caron wrote:
> Hi all,
> 
> I recently had to manage a storage failure on a ~150 TB XFS volume and
> I just wanted to check with the group here to see if anything could
> have been done differently. Here is my story.

:(

> We had a 150 TB RAID 60 volume formatted with XFS. The volume was made
> up of two 21-drive RAID 6 strings (4 TB drives). This was all done
> with Linux MD software RAID.

A 21-drive RAID-6 made this cascading failure scenario inevitable,
especially if all the drives were identical (same vendor and
manufacturing batch). Once the first drive goes bad, the rest are at
death's door. RAID rebuild is about the most intensive sustained
load you can put on a drive, and if a drive is marginal that's often
all that is needed to kick it over the edge. The more disks in the
RAID set, the more likely cascading failures during rebuild are.

> We mount the array. It mounts, but it is obviously pretty damaged.
> Normally when this happens we try to mount it read only and copy off
> what we can, then write it off. This time, we can't hardly do anything
> but an "ls" in the filesystem without getting "structure needs
> cleaning".

Which makes me think that the damage is, unfortunately, high up in
directory heirarchy and the inodes and sub-directories that hold
most of the data can't be accessed.

> Doing any kind of material access to the filesystem gives
> various major errors (i.e. "in-memory corruption of filesystem data
> detected") and the filesystem goes offline. Reads just fail with I/O
> errors.
> 
> What can we do? Seems like at this stage we just run xfs_repair and
> hope for the best, right?

Not quite. The next step would have been to take a metadump of the
broken filesystem and then restore the image to a file on non-broken
storage. Then you can run repair on the restored metadump image and
see just how much ends up being left after xfs_repair runs. That
tells you the likely result of running repair without actually
changing anything in the damaged storage.

> Ran xfs_repair in dry run mode and it's looking pretty bad, just from
> the sheer amount of output.
> 
> But there's no real way to know exactly how much data xfs_repair will
> wipe out, and what alternatives do we have?

That's exactly what metadump/restore/repair/"mount -o loop" allows
us to evaluate.

> We run xfs_repair overnight. It ran for a while, then eventually hung
> in Phase 4, I think.
> 
> We killed xfs_repair off and re-ran it with the -P flag. It runs for
> maybe two or three hours and eventually completes.
> 
> We mount the filesystem up. Of around 150 TB, we have maybe 10% of
> that in data salad in lost+found, 21 GB of good data and the rest is
> gone.
> 
> Copy off what we can, and call it dead. This is where we're at now.

Yeah, and there's probably not a lot that can be done now except run
custom data scrapers over the raw disk blocks to try to recognise
unconnected metadata and files to try to recover the raw information
that is no longer connected to the repaired directory structure.
That's slow, time consuming and expensive.

> It seems like the MD rebuild process really scrambled things somehow.
> I'm not sure if this was due to some kind of kernel bug, or just
> zeroed out bad sectors in wrong places or what. Once the md resync
> ran, we were cooked.
> 
> I guess, after blowing through four or five "Hope you have a backup,
> but if not, you can try this and pray" checkpoints, I just want to
> check with the developers and group here to see if we did the best
> thing possible given the circumstances?

Before running repair - which is a "can't go back once it's started"
operation - you probably should have reached out for advice. We do
have tools that allow us to examine, investigate and modify the
on-disk format manually (xfs_db), and with metadump you can provide
us with a compact, obfuscated metadata-only image that we can look
at directly and see if there's anything that can be done to recover
the data from the broken filesystem. xfs_db requires substantial
expertise to use as a manual recovery tool, so it's not something
that just anyone can do...

> Xfs_repair is it, right? When things are that scrambled, pretty much
> all you can do is run an xfs_repair and hope for the best? Am I
> correct in thinking that there is no better or alternative tool that
> will give different results?

There are other tools that we have that can help understand the
nature of the corruption before an operation is performed that can't
be undone. Using those tools can lead to a better outcome, but in
RAID failure cases like these it is still often "storage is
completely scrambled, the filesystem and the data on it is toast no
matter what we do"....

> Can a commercial data recovery service make any better sense of a
> scrambled XFS than xfs_repair could? When the underlying device is
> presenting OK, just scrambled data on it?

Commercial data recovery services have their own custom data
scrapers that pull all the disconnected fragments of data off the
drive and then they tend to reconstruct the data manually from
there. They have a different goal to xfs_repair (data recovery vs
filesystem consistency) but a good data recovery service might be
able to scrape some of the data from disk blocks that xfs_repair
removed all the corrupt metadata references to...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
