Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47584 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729157AbeKUWfw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Nov 2018 17:35:52 -0500
Date: Wed, 21 Nov 2018 07:01:43 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/7] xfs: zero length symlinks are not valid
Message-ID: <20181121120142.GA57715@bfoster>
References: <20181119210459.8506-1-david@fromorbit.com>
 <20181119210459.8506-2-david@fromorbit.com>
 <20181120134439.GA47711@bfoster>
 <20181120211918.GR19305@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181120211918.GR19305@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Nov 21, 2018 at 08:19:18AM +1100, Dave Chinner wrote:
> On Tue, Nov 20, 2018 at 08:44:39AM -0500, Brian Foster wrote:
> > On Tue, Nov 20, 2018 at 08:04:53AM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > A log recovery failure has been reproduced where a symlink inode has
> > > a zero length in extent form. It was caused by a shutdown during a
> > > combined fstress+fsmark workload.
> > > 
> > > The underlying problem is the issue in xfs_inactive_symlink(): the
> > > inode is unlocked between the symlink inactivation/truncation and
> > > the inode being freed. This opens a window for the inode to be
> > > written to disk before it xfs_ifree() removes it from the unlinked
> > > list, marks it free in the inobt and zeros the mode.
> > > 
> > > For shortform inodes, the fix is simple. xfs_ifree() clears the data
> > > fork state, so there's no need to do it in xfs_inactive_symlink().
> > > This means the shortform fork verifier will not see a zero length
> > > data fork as it mirrors the inode size through to xfs_ifree()), and
> > > hence if the inode gets written back and the fork verifiers are run
> > > they will still see a fork that matches the on-disk inode size.
> > > 
> > > For extent form (remote) symlinks, it is a little more tricky. Here
> > > we explicitly set the inode size to zero, so the above race can lead
> > > to zero length symlinks on disk. Because the inode is unlinked at
> > > this point (i.e. on the unlinked list) and unreferenced, it can
> > > never be seen again by a user. Hence when we set the inode size to
> > > zeor, also change the type to S_IFREG. xfs_ifree() expects S_IFREG
> > > inodes to be of zero length, and so this avoids all the problems of
> > > zero length symlinks ever hitting the disk. It also avoids the
> > > problem of needing to handle zero length symlink inodes in log
> > > recovery to replay the extent free intents and the remaining
> > > deferops to free the extents the symlink used.
> > > 
> > > Also add a couple of asserts to warn us if zero length symlinks end
> > > up in either the symlink create or inactivation paths.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > 
> > Hmm, I saw this and thought this was something we had already fixed.
> > Looking back, I see this was actually posted[1] months ago and there was
> > a fairly nuanced discussion. On a quick skim, that appears to have
> > concluded with the patch being mostly sane, but requiring a couple minor
> > tweaks and commit log updates. This patch looks exactly the same to me,
> > however. Hm?
> 
> Hmmm, I did all that, months ago. The code barely changed, it was
> all just commit message updates. maybe I picked up the wrong version
> of the patch - it had been sitting around for a while. I had even
> gone back and checked the discussion before concluding that "it 
> doesn't need code changes" before adding it to this stack...
> 
> I'll go back and see if I can find a more recent version...
> 

It was mostly commit log changes except for an
s/xfs_difree()/xfs_ifree()/ needed in the code comment. IIRC, there was
additional context worth describing for log recovery in the commit log.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
