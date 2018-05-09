Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:61248 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933175AbeEIAON (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 May 2018 20:14:13 -0400
Date: Wed, 9 May 2018 10:14:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_db: add -R option
Message-ID: <20180509001410.GM23861@dastard>
References: <20180504140244.GA32161@deer-run.com>
 <db080bb2-a649-fbb3-ec91-d16f00ad30f0@sandeen.net>
 <20180508161353.GA18224@deer-run.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180508161353.GA18224@deer-run.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: hal@deer-run.com
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org

On Tue, May 08, 2018 at 11:13:53AM -0500, hal@deer-run.com wrote:
> > Hm, so this probably makes it possible that blockget will wander off
> > into inconsistencies and fail; there's a /reason/ for the check.  So
> > if anything this is probably best-effort.  I doubt you can rely on
> > blockget even completing without error, let alone being correct.  In
> > that case, is it still useful to you?
> 
> I've been testing a modified version of xfs_db on live file systems
> and dirty image files, and I have yet to have blockget fail. I agree
> that it's certainly possible for blockget to blow up under these
> circumstances, but it's working often enough to be useful.

That's a slippery slope.

IMO, the only thing worse than not having a forensic tool for a
specific job is having a forensic tool provided by a trusted toolkit
whose results are unreliable and cannot be trusted....

> > What sort of information do you hope to gather after running
> > blockget without a replay?
> 
> Suppose I can match a string or magic number for a file of interest
> at a specific byte offset in the file system image. A little arithmetic
> and I have a daddr value. xfs_db let's me convert that to an fsblock
> and then call blockuse -n to get the inode and file path. I've tried
> it, and it works with my modifed xfs_db.

There are so many ways that can go wrong on a live filesystem.
Regardless of whether you've personally seen it go wrong, it's still
not a reliable method of information extraction. And we know that
there's every chance that xfs_db will stumble on something
unexpected in a live filesystem traversal and just crash.

FWIW, blockuse -n also requires a full filesystem scan to find the
file path (i.e. via blockget -n). That can take a long time, affect
anything that is running on the machine at the time. And by the time
it's all done, there's no guarantee the path it comes up will be
valid or correct....

What you are trying to do - offset/block to owner path lookups on
live filesystems - is something that the FSMAP ioctl and the
upcoming parent pointer functionality will solve.....

> Until we get XFS support into libsleuthkit (which I'm working towards,
> but it's going to be a while), having this functionality lets me
> use xfs_db as a forensic tool. And it also lets me use xfs_db to
> validate other forensic tools.

I'd suggest, in that case, that you limit it's use to off-line or
read-only snapshots of online filesystems? This would mean that the
results of xfs_db operations (while eceedingly slow) will be
reliable.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
