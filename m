Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:34504 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S935351AbdIZEbF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Sep 2017 00:31:05 -0400
Date: Tue, 26 Sep 2017 14:24:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: false positive lockdep splat with loop device
Message-ID: <20170926042421.GP10955@dastard>
References: <CAOQ4uxixLMRU2YT-3csTr_684vNUZ=2CazKKD-ojO68fC4f6tA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxixLMRU2YT-3csTr_684vNUZ=2CazKKD-ojO68fC4f6tA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Byungchul Park <byungchul.park@lge.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Thu, Sep 21, 2017 at 09:43:41AM +0300, Amir Goldstein wrote:
> On Thu, Sep 21, 2017 at 1:22 AM, Dave Chinner <david@fromorbit.com> wrote:
> > [cc lkml, PeterZ and Byungchul]
> ...
> > The thing is, this IO completion has nothing to do with the lower
> > filesystem - it's the IO completion for the filesystem on the loop
> > device (the upper filesystem) and is not in any way related to the
> > IO completion from the dax device the lower filesystem is waiting
> > on.
> >
> > IOWs, this is a false positive.
> >
> > Peter, this is the sort of false positive I mentioned were likely to
> > occur without some serious work to annotate the IO stack to prevent
> > them.  We can nest multiple layers of IO completions and locking in
> > the IO stack via things like loop and RAID devices.  They can be
> > nested to arbitrary depths, too (e.g. loop on fs on loop on fs on
> > dm-raid on n * (loop on fs) on bdev) so this new completion lockdep
> > checking is going to be a source of false positives until there is
> > an effective (and simple!) way of providing context based completion
> > annotations to avoid them...
> >
> 
> IMO, the way to handle this is to add 'nesting_depth' information
> on blockdev (or bdi?). 'nesting' in the sense of blockdev->fs->blockdev->fs.
> AFAIK, the only blockdev drivers that need to bump nesting_depth
> are loop and nbd??

You're assumming that this sort of "completion inversion" can only
happen with bdev->fs->bdev, and that submit_bio_wait() is the only
place where completions are used in stackable block devices.

AFAICT, this could happen on with any block device that can be
stacked multiple times that uses completions. e.g. MD has a function
sync_page_io() that calls submit_bio_wait(), and that is called from
places in the raid 5, raid 10, raid 1 and bitmap layers (plus others
in DM). These can get stacked anywhere - even on top of loop devices
- and so I think the issue has a much wider scope than just loop and
nbd devices.

> Not sure if the kernel should limit loop blockdev nesting depth??

There's no way we should do that just because new lockdep
functionality is unable to express such constructs.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
