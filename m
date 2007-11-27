Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 27 Nov 2007 02:54:02 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lARArrnm015191
	for <xfs@oss.sgi.com>; Tue, 27 Nov 2007 02:53:57 -0800
Date: Tue, 27 Nov 2007 21:53:58 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH, RFC] Delayed logging of file sizes
Message-ID: <20071127105358.GG119954183@sgi.com>
References: <47467B87.2000000@sgi.com> <20071125225928.GE114266761@sgi.com> <474A112D.2040006@sgi.com> <20071126011044.GG114266761@sgi.com> <474A2180.7000605@sgi.com> <20071126021515.GH114266761@sgi.com> <474A3A92.2040200@sgi.com> <20071126050300.GI114266761@sgi.com> <474B8F51.5030102@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474B8F51.5030102@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Nov 27, 2007 at 02:30:25PM +1100, Lachlan McIlroy wrote:
> David Chinner wrote:
> >Sorry, i wasn't particularly clear. What I mean was that i_update_core
> >might disappear completely with the changes I'm making.
> >
> >Basically, we have three different methods of marking the inode dirty
> >at the moment - on  the linux inode (mark_inode_dirty[_sync]()), the
> >i_update_core = 1 for unlogged changes and logged changes are tracked via 
> >the
> >inode log item in the AIL.
> >
> >One top of that, we have three different methods of flushing them - one
> >from the generic code for inodes dirtied by mark_inode_dirty(), one from
> >xfssyncd for inodes that are only dirtied by setting i_update_core = 1
> >and the other from the xfsaild when log tail pushing.
> >
> >Ideally we should only have a single method for pushing out inodes. The 
> >first
> >step to that is tracking the dirty state in a single tree (the inode radix
> >trees). That means we have to hook ->dirty_inode() to catch all dirtying 
> >via
> >mark_inode_dirty[_sync]() and mark the inodes dirty in the radix tree. 
> >Then we
> >need to use xfs_mark_inode_dirty_sync() everywhere that we dirty the inode.
> Don't we already call mark_inode_dirty[_sync]() everywhere we dirty the 
> inode?

Maybe. Maybe not. Tell me - does xfs_ichgtime() do the right thing?

[ I do know the answer to this question and there's a day of kdb tracing
behind the answer. I wrote a 15 line comment to explain what was going
on in one of my patches. ]

> >Once we have all the dirty state in the radix trees we can now get rid of
> >i_update_core and i_update_size - all they do is mark the inode dirty and
> >we don't really care about the difference between them(*) - and just use
> >the dirty bit in the radix tree when necessary.
> If we want to check if an inode is dirty do we have to look up the dirty
> bit in the tree or is there some easy way to get it from the inode?

xfs_inode_clean(ip) is my preferred interface. How that is finally
implemented will be determined by how this all cleans up and what
performs the best. If lockless tree lookups don't cause performance
problems, then there is little reason to keep redundant information
around.

> By consolidating the different ways of dirtying an inode we lose the ability
> to know why it is dirty and what action needs to be done to undirty it.

The only way to undirty an inode is to write it to disk.

> For example if the inode log item has bits set then we know we have to flush
> the log otherwise there is no need.  With a general purpose dirty bit we 

No, if the log item is present and dirty (i.e. inode is in the AIL),
all it means is that we need to attach a callback to the buffer
(xfs_iflush_done) when dispatching the I/O to do processing of the
log item on I/O completion. Whether i_update_core is set or not
in this case is irrelevant - the log item state overrides that.

> will
> have to flush regardless.  And my recent attempt to fix the log replay issue
> relies on i_update_core to indicate there are unlogged changes - I don't see
> how that will work with these changes.

But your changes could not be implemented, either. You can't log the inode
to clean it - it merely transfers the writeback from one list to
another.

So, the cleaner fix is to do this - change the xfs_inode_flush()
just to unconditionally log the inode and don't do inode writeback *at
all* from there. That will catch all cases of unlogged changes and leave
inode writeback to tail-pushing or xfssyncd which can be driven by
the radix tree.

Basically, if we only ever write state to disk that we've logged,
then we are home free. That means the only time we should update
the unlogged fields - timestamps and inode size - is during a
transaction commit and not during inode writeback. If we do that
then i_update_core and i_update_size go away completely and the
only place we need track inode dirty state in XFS is when the
inodes are in the AIL list.

Even better: this removes one of the three places where we do inode
writeback and is a significant step towards:

> >I'd even like to go as far as a two pass writeback algorithm; pass
> >one only writes data, and pass two only writes inodes. The second pass
> >for XFS needs to be delayed until data writeback is complete because of
> >delalloc and inode size updates redirtying the inode. The current
> >mechanism means we often do two inode writes for the one data write...

----

What I'm trying to say is that I don't think we can cleanly fix the problem
with the current structure, so let's not waste time on it. A cleaner
fix should just fall out a simpler writeback structure.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
