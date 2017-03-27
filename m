Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:39845 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751839AbdC0WmA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Mar 2017 18:42:00 -0400
Date: Tue, 28 Mar 2017 09:40:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: don't let suspend freeze the buffer workqueue
Message-ID: <20170327224045.GJ17542@dastard>
References: <20170327204611.GA4864@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170327204611.GA4864@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-pm@vger.kernel.org, xfs <linux-xfs@vger.kernel.org>

On Mon, Mar 27, 2017 at 01:46:11PM -0700, Darrick J. Wong wrote:
> Suspend has this annoying behavior in XFS where it freezes workqueues in
> some arbitrary order.  This is a problem because the sync call can cause
> an AIL push, which may have to perform a RMW cycle on an inode cluster
> buffer if that buffer has been reclaimed.  When this happens, the AIL
> issues a buffer read for which the io completion ends up on the xfs_buf
> workqueue.  If /that/ workqueue has already been frozen, the suspend
> will timeout because we froze the workqueues in the wrong order.
> 
> It seems suspicious to be freezing IO helper threads[1], so let's just
> not do that anymore.  Prior to this patch, 4.10 fails to suspend on my
> laptop about 80% of the time; afterwards, it works every time.  I've not
> done much suspend-and-crash testing on it though.

The problem with doing this is that it opens up an even worse race
condition - a memory corruption condition, and potentially a
filesystem corruption condition if not caught after resume quickly
enough.

That is, if we don't freeze the m_buf_workqueue, we end up doing
this:

freezer			aild		m_buf_workqueue
.....
freeze user processes
sync
freeze work queues
			pushes dirty metadata
			<starts IO>
freeze kernel threads
					<IO completion interrupt>
					<work queued>
create_image()
					run IO completion work

At this point, we have IO completion in XFS modifying memory state
that is being snapshotted by the freezer process. Hence we can end
up with the hibernation image having an inconsistent state such as
an inode marked clean (because it was copied after IO completion)
but the AIL still has the inode item linked into it (because it was
copied before IO completion).

The only way to avoid this race condition is to ensure that the
m_buf_workqueue cannot run work while the hibernation image is being
created. This is still just a workaround - we can lose IO
completions completely if they occur after the image creation begins
- but it removes the most common case of memory corruption that has
previously been seen during hibernation.

Unfortunately, these races are just about impossible to trigger in
test environments, so it's no surprise that you haven't "seen
problems".  The decision that I made here is that it is better for
suspend to hang and annoy people than it is for users to suffer
silent memory and filesystem corruption resulting in data loss
that has no obvious logical cause, cannot be reproduced or
debugged...

AFAICT, we can't fix this problem in XFS - we need the suspend code
to /freeze the filesystems/ to safely quiesce them because the only
choices we have right now is to choose the least worst behaviour of
either "hang during suspend" or "be silent and deadly".

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
