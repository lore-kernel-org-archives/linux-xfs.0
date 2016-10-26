Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:18683 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752208AbcJZFuA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Oct 2016 01:50:00 -0400
Date: Wed, 26 Oct 2016 16:49:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3] xfs: fix unbalanced inode reclaim flush locking
Message-ID: <20161026054947.GK23194@dastard>
References: <1476815175-25909-1-git-send-email-bfoster@redhat.com>
 <20161025173312.GA6594@laptop.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161025173312.GA6594@laptop.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 25, 2016 at 01:33:12PM -0400, Brian Foster wrote:
> On Tue, Oct 18, 2016 at 02:26:15PM -0400, Brian Foster wrote:
> > Filesystem shutdown testing on an older distro kernel has uncovered an
> > imbalanced locking pattern for the inode flush lock in
> > xfs_reclaim_inode(). Specifically, there is a double unlock sequence
> > between the call to xfs_iflush_abort() and xfs_reclaim_inode() at the
> > "reclaim:" label.
> > 
> > This actually does not cause obvious problems on current kernels due to
> > the current flush lock implementation. Older kernels use a counting
> > based flush lock mechanism, however, which effectively breaks the lock
> > indefinitely when an already unlocked flush lock is repeatedly unlocked.
> > Though this only currently occurs on filesystem shutdown, it has
> > reproduced the effect of elevating an fs shutdown to a system-wide crash
> > or hang.
> > 
> > As it turns out, the flush lock is not actually required for the reclaim
> > logic in xfs_reclaim_inode() because by that time we have already cycled
> > the flush lock once while holding ILOCK_EXCL. Therefore, remove the
> > additional flush lock/unlock cycle around the 'reclaim:' label and
> > update branches into this label to release the flush lock where
> > appropriate. Add an assert to xfs_ifunlock() to help prevent future
> > occurences of the same problem.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > Reported-by: Zorro Lang <zlang@redhat.com>
> > ---
> 
> ping?

not had a chance to context switch back to this. Once I've got the
reflink userspace stuff sorted, I'll switch back to kernel stuff...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
