Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 31 Aug 2007 08:48:29 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7VFmO4p012984
	for <xfs@oss.sgi.com>; Fri, 31 Aug 2007 08:48:26 -0700
Date: Sat, 1 Sep 2007 01:48:23 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] log replay should not overwrite newer ondisk inodes
Message-ID: <20070831154822.GD734179@sgi.com>
References: <46D6279F.40601@sgi.com> <46D6480F.4040307@sgi.com> <46D64CAD.6050705@sgi.com> <46D67FE6.20205@sgi.com> <46D68510.1020404@sgi.com> <46D77B79.3040104@sgi.com> <46D792A1.7030308@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46D792A1.7030308@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mark Goodwin <markgw@sgi.com>
Cc: Lachlan McIlroy <lachlan@sgi.com>, Timothy Shimmin <tes@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, Aug 31, 2007 at 02:01:37PM +1000, Mark Goodwin wrote:
> Lachlan McIlroy wrote:
> >Timothy Shimmin wrote:
> >>Timothy Shimmin wrote:
> >>>>>  But I'm not sure this is an error...
> >>>>>  Hmmmm...I'm a bit confused.
> >>>>>  So you are _almost_ combining an error check with a flushiter check?
> >>>>>  If one buffer is an inode magic# and the other isn't then we
> >>>>>  have an error right - and could report it - but we are not doing 
> >>>>>that here.
> >>>>Not exactly.  If what's on disk is not an inode but the log item is
> >>>>then that could be because we haven't written the inode to disk yet
> >>>>and we need to perform recovery.
> >>>Yeah, I was thinking about that afterward.
> >>>The item's format which gives the blk# for the buf to read could
> >>>be a block which hasn't been used for an inode yet.
> >>>
> >>Well, if what's on disk is not an inode but some other data
> >>and it happens to have the inode magic# which is remotely possible,
> >>then we are making a bad assumption.
> >>i.e. if we're not sure what the block/buffer should be, then testing the
> >>MAGIC# isn't a guarantee it's an inode then.
> >>Well not for the freeing of inode clusters case I would assume.
> >>Or am I missing something?
> >I don't think you're missing anything!
> >
> >You're right though - a magic number check is no guarantee.  On the same
> >vein, adding a generation number check isn't much better.
> 
> unlink will have to invalidate the on-disk inode magic number? Or only
> when the whole cluster is free'd?

An unlinked inode is only detectable by the mode parameter being zero.
The rest of the inode will look valid.

To detect the difference between a newly allocated inode *chunk*
that has been written to and a stale inode chunk that we have
just allocated and not written to yet, you need to walk every inode
in the chunk and determine if the mode parameter is zero in every
inode.

If the mode is zero for all inodes and there are generation numbers
that are not zero, then you've detected a stale buffer and you should
replay the inode cluster buffer initialisation.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
