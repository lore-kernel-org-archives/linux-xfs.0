Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f54.google.com ([74.125.83.54]:34493 "EHLO
        mail-pg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755892AbdHYRdC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Aug 2017 13:33:02 -0400
Received: by mail-pg0-f54.google.com with SMTP id a7so2436003pgn.1
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2017 10:33:02 -0700 (PDT)
Date: Fri, 25 Aug 2017 10:33:00 -0700
From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH] xfs: check for race with xfs_reclaim_inode() in
 xfs_ifree_cluster()
Message-ID: <20170825173300.GA4215@vader.DHCP.thefacebook.com>
References: <93321e051fb5f80c4727844748cca04604a8757a.1503618336.git.osandov@fb.com>
 <20170825135659.GA40964@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170825135659.GA40964@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, kernel-team@fb.com

On Fri, Aug 25, 2017 at 09:57:01AM -0400, Brian Foster wrote:
> On Thu, Aug 24, 2017 at 04:50:09PM -0700, Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
> > 
> > After xfs_ifree_cluster() finds an inode in the radix tree and verifies
> > that the inode number is what it expected, xfs_reclaim_inode() can swoop
> > in and free it. xfs_ifree_cluster() will then happily continue working
> > on the freed inode. Most importantly, it will mark the inode stale,
> > which will probably be overwritten when the inode slab object is
> > reallocated, but if it has already been reallocated then we can end up
> > with an inode spuriously marked stale.
> > 
> > In 8a17d7ddedb4 ("xfs: mark reclaimed inodes invalid earlier") we added
> > a second check to xfs_iflush_cluster() to detect this race, but the
> > similar RCU lookup in xfs_ifree_cluster() needs the same treatment.
> > 
> > Signed-off-by: Omar Sandoval <osandov@fb.com>
> > ---
> > Based on v4.13-rc6. Let me know if my reasoning here is completely off,
> > the XFS inode machinery makes my head spin.
> > 
> >  fs/xfs/xfs_icache.c | 10 +++++-----
> >  fs/xfs/xfs_inode.c  | 23 ++++++++++++++++++-----
> >  2 files changed, 23 insertions(+), 10 deletions(-)

[snip]

> Ok, so we're down in the codepath where we've removed the last inode in
> a chunk and we've freed the inode chunk. We lock each cluster buffer,
> lookup each inode in the cluster to mark it stale, then invalidate the
> buffer.
> 
> Here, we check the inode number and stale state under the spinlock while
> on the reclaim side, we do the lookup and set the reclaim flag under the
> spinlock. It seems both paths can get at least that far without
> necessarily stomping on eachother.
> 
> Next, both paths acquire the ilock...
> 
> If xfs_ifree_cluster() gets the lock it acquires the flush lock and
> marks the inode stale (possibly attaching to the invalidated buffer if
> it is dirty, which I think is irrelevant here). Hence when reclaim
> acquires the lock, it sees a stale inode and immediately reclaims it. So
> far so good.
> 
> If reclaim had acquired the lock, it (potentially) reclaims the inode
> and resets i_ino = 0 before the ilock is released as indication. Then
> the inode is removed from the tree and scheduled for rcu freeing. On the
> xfs_ifree_cluster() side, each ilock trylock failure cycles the rcu read
> lock and retries the initial lookup. I think that means there's a good
> chance the previous i_ino check would either fail the lookup or detect
> the reclaimed inode and skip it appropriately. That said, it does appear
> like there's a very small window where if the lookup and i_flags_lock
> checks (in xfs_ifree_cluster()) occur before reclaim resets i_ino but
> reclaim releases ilock such that the (xfs_ifree_cluster()) ilock trylock
> does not fail, we go on and stale a possibly free inode.

Much better explanation than I gave, but yes, exactly.

> This code is hairy and it's easily possible that I'm missing something
> as well. Even so, I think the additional check is harmless and
> defensive and so this looks Ok to me:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Thanks!

> I am curious whether you've hit a problem that this patch addresses or
> if this is just an observation?

We've been chasing a corruption here for a few weeks where a file will
end up getting clobbered by another file. E.g., file A is inode X, and
inode X gets reused for file B a while later. It happens with extremely
low frequency on our machines running hdfs, but there are enough
occurrences of it and there is little to no collateral damage, so we're
reasonably convinced that it's a kernel bug and not a hardware problem.

Our first theory was a race in the inobt code (these are all v4
filesystems so no finobt), but the synchronization there is pretty
straightforward and I didn't see any way it could go wrong.

Our next theory was inode reclaim, since we've only seen this on our
hdfs machines which are always under memory pressure and not on anything
else we use XFS on. iget vs reclaim is tricky but it looks like all of
the possible races there are plugged. That leaves flushing and unlinking
vs reclaim. These machines are on our 4.6 branch, so we're missing
1f2dcfe89eda ("xfs: xfs_inode_free() isn't RCU safe") and 8a17d7ddedb4
("xfs: mark reclaimed inodes invalid earlier"). I found the race in this
patch as I was reading the code to figure out how to trigger those
races.

Where I'm at right now is trying to trigger one of these races, and then
trying to come up with the unlikely series of events that goes from any
of these races happening to inodes being reused on disk. Sorry for the
brain dump, it's been a tough investigation ;)
