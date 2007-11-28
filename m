Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 28 Nov 2007 01:07:38 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAS97WLV025272
	for <xfs@oss.sgi.com>; Wed, 28 Nov 2007 01:07:33 -0800
Date: Wed, 28 Nov 2007 20:07:37 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH, RFC] Delayed logging of file sizes
Message-ID: <20071128090737.GO119954183@sgi.com>
References: <20071126011044.GG114266761@sgi.com> <474A2180.7000605@sgi.com> <20071126021515.GH114266761@sgi.com> <474A3A92.2040200@sgi.com> <20071126050300.GI114266761@sgi.com> <474B8F51.5030102@sgi.com> <20071127105358.GG119954183@sgi.com> <474CB9AE.9020604@sgi.com> <20071128020135.GM119954183@sgi.com> <474CEC2E.8000206@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474CEC2E.8000206@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Nov 28, 2007 at 03:18:54PM +1100, Lachlan McIlroy wrote:
> David Chinner wrote:
> >>>[ I do know the answer to this question and there's a day of kdb tracing
> >>>behind the answer. I wrote a 15 line comment to explain what was going
> >>>on in one of my patches. ]
> >>Are you referring to the !(inode->i_state & I_LOCK) check?
> >
> >Yup.
> I've never liked that check, can we just get rid of it?

No - removing the check is what lead me to understand why it
was necessary.

> >Sorry, I missed an important work there - could not be implemented
> >_efficiently_.
> >
> >Basically, you are logging the inode, then call xfs_iflush, which
> >immediately sees it pinned and forces the log. That's an extra
> >transaction *and* log I/O for every inode we write. That defeats all
> >inode clustering and and will seriously harm performance.
> I didn't see another way around it.  We only need to force the log for
> pinned inodes if it is a sync writeback, otherwise we can just try again
> later.

But we don't do that right now - we call xfs_ipinwait() in xfs_iflush()
which forces the log.

> >Also, the change fails to log changes to inodes in the same
> >cluster that get written out because they are dirty.
> That's where it all sort of falls apart.  I didn't want to log the inode
> in xfs_iflush_int() because we have the flush lock held and I was pretty
> sure logging a transaction with the flush lock held would be a bad idea.
> That's why I specifically removed the code that resets i_update_core in
> xfs_iflush_int() - so that other inodes in the same cluster will still be
> flagged as having unlogged changes even after the inodes have been synced
> to disk.  But as I said it was an idea that needed some polishing.

It's messy, and if we are logging changes then we should never write
to disk unlogged changes....

> >>>So, the cleaner fix is to do this - change the xfs_inode_flush()
> >>>just to unconditionally log the inode and don't do inode writeback *at
> >>>all* from there. That will catch all cases of unlogged changes and leave
> >>>inode writeback to tail-pushing or xfssyncd which can be driven by
> >>>the radix tree.
> >>Huh?  Aren't we trying to minimize the number of transactions we do?  My
> >>changes introduce new transactions but only when we have to.  You're 
> >>saying
> >>here that we log the inode unconditionally - how is that better?  I'm not
> >>trying to defend my changes here (I don't care how the problem gets fixed)
> >>- I'm just trying to understand why your suggestions are a good idea.
> >
> >Because we can log entire inode cluster's worth of changes in a single
> >transaction. One transaction vs one I/O - it's a decent tradeoff to
> >avoid this problem, esp. as we'll get improved inode writeback clustering
> >if we flush from the radix tree (i.e. clusters get flushed in ascending
> >inode number order).....
> That should help a lot but it will use even more space in the log - quite a
> lot more if just one inode in the cluster needs to be logged.

32 inodes * 100 bytes for the inode core - 3k per inode is we log the
entire cluster. But we know what is dirty and what isn't, so that's worst
case. i.e. we only log those that are dirty. It's not log space I'm
worried about here - it's the transaction overhead....

Still, doing it as a cluster is probably premature optimisation. Lets
see what logging only the dirty inodes gets us and go from there.

> Do you plan
> to do this in the write_inode path?  If so we'll have inodes that have been
> logged (with a previous cluster) that still have I_DIRTY set.

I'll cross that one if we need to - we can probably just clear it if
the inode is not otherwise dirty...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
