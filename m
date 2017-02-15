Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60462 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752044AbdBOSJC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Feb 2017 13:09:02 -0500
Date: Wed, 15 Feb 2017 13:09:00 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [Bug 192981] New: page allocation stalls
Message-ID: <20170215180859.GB62565@bfoster.bfoster>
References: <bug-192981-27@https.bugzilla.kernel.org/>
 <20170123135111.13ac3e47110de10a4bd503ef@linux-foundation.org>
 <8f450abd-4e05-92d3-2533-72b05fea2012@beget.ru>
 <20170215160538.GA62565@bfoster.bfoster>
 <a055abbf-a471-d111-9491-dc5b00208228@beget.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a055abbf-a471-d111-9491-dc5b00208228@beget.ru>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Alexander Polakov <apolyakov@beget.ru>
Cc: linux-mm@kvack.org, linux-xfs@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org

On Wed, Feb 15, 2017 at 07:52:13PM +0300, Alexander Polakov wrote:
> On 02/15/2017 07:05 PM, Brian Foster wrote:
> > You're in inode reclaim, blocked on a memory allocation for an inode
> > buffer required to flush a dirty inode. I suppose this means that the
> > backing buffer for the inode has already been reclaimed and must be
> > re-read, which ideally wouldn't have occurred before the inode is
> > flushed.
> > 
> > > But it cannot get memory, because it's low (?). So it stays blocked.
> > > 
> > > Other processes do the same but they can't get past the mutex in
> > > xfs_reclaim_inodes_nr():
> > > 
> > ...
> > > Which finally leads to "Kernel panic - not syncing: Out of memory and no
> > > killable processes..." as no process is able to proceed.
> > > 
> > > I quickly hacked this:
> > > 
> > > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > > index 9ef152b..8adfb0a 100644
> > > --- a/fs/xfs/xfs_icache.c
> > > +++ b/fs/xfs/xfs_icache.c
> > > @@ -1254,7 +1254,7 @@ struct xfs_inode *
> > >         xfs_reclaim_work_queue(mp);
> > >         xfs_ail_push_all(mp->m_ail);
> > > 
> > > -       return xfs_reclaim_inodes_ag(mp, SYNC_TRYLOCK | SYNC_WAIT,
> > > &nr_to_scan);
> > > +       return 0; // xfs_reclaim_inodes_ag(mp, SYNC_TRYLOCK | SYNC_WAIT,
> > > &nr_to_scan);
> > >  }
> > > 
> > 
> > So you've disabled inode reclaim completely...
> 
> I don't think this is correct. I disabled direct / kswapd reclaim.
> XFS uses background worker for async reclaim:
> 
> http://lxr.free-electrons.com/source/fs/xfs/xfs_icache.c#L178
> http://lxr.free-electrons.com/source/fs/xfs/xfs_super.c#L1534
> 

Ah, Ok. It sounds like this allows the reclaim thread to carry on into
other shrinkers and free up memory that way, perhaps. This sounds kind
of similar to the issue brought up previously here[1], but not quite the
same in that instead of backing off of locking to allow other shrinkers
to progress, we back off of memory allocations required to free up
inodes (memory).

In theory, I think something analogous to a trylock for inode to buffer
mappings that are no longer cached (or more specifically, cannot
currently be allocated) may work around this, but it's not immediately
clear to me whether that's a proper fix (it's also probably not a
trivial change either). I'm still kind of curious why we end up with
dirty inodes with reclaimed buffers. If this problem repeats, is it
always with a similar stack (i.e., reclaim -> xfs_iflush() ->
xfs_imap_to_bp())?

How many independent filesystems are you running this workload against?
Can you describe the workload in more detail?

...
> > The bz shows you have non-default vm settings such as
> > 'vm.vfs_cache_pressure = 200.' My understanding is that prefers
> > aggressive inode reclaim, yet the code workaround here is to bypass XFS
> > inode reclaim. Out of curiousity, have you reproduced this problem using
> > the default vfs_cache_pressure value (or if so, possibly moving it in
> > the other direction)?
> 
> Yes, we've tried that, it had about 0 influence.
> 

Which.. with what values? And by zero influence, do you simply mean the
stall still occurred or you have some other measurement of slab sizes or
some such that are unaffected?

Brian

> -- 
> Alexander Polakov | system software engineer | https://beget.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
