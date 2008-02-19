Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Feb 2008 18:49:17 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1J2n6Ie023349
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2008 18:49:10 -0800
Date: Tue, 19 Feb 2008 13:49:24 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: tuning, many small files, small blocksize
Message-ID: <20080219024924.GB155407@sgi.com>
References: <e03b90ae0802152101t2bfa4644kcca5d6329239f9ff@mail.gmail.com> <47BA10EC.3090004@tlinx.org> <20080218235103.GW155407@sgi.com> <47BA2AFD.2060409@tlinx.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BA2AFD.2060409@tlinx.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linda Walsh <xfs@tlinx.org>
Cc: David Chinner <dgc@sgi.com>, Jeff Breidenbach <jeff@jab.org>, xfs@oss.sgi.com

On Mon, Feb 18, 2008 at 05:03:57PM -0800, Linda Walsh wrote:
> David Chinner wrote:
> >That makes no sense. Inodes are *unique* - they are not shared with
> >any other inode at all. Could you explain why you think that 256
> >byte inodes are any different to larger inodes in this respect?
> ---
> 	Sorry to be unclear, but it would seem to me that if the
> minimum physical blocksize on disk is 512 bytes, then either a 256
> byte inode will share that block with another inode, or you are
> wasting 256 bytes on each inode.  The latter interpretation doesn't
> make logical sense.
> 
> 	If the minimum physical I/O size is larger than 512 bytes,
> then I would assume even more, *unique*, inodes could be packed
> in per block.

Inode I/O in XFS is done in *8k clusters* regardless of inode size.
We _never_ do single inode I/O and hence you logic completely
breaks down at that point ;). Inode clustering is a substantial
performance optimisation that speeds up inode writeback a
great deal. e.g. i broke clustering recently and we got bug
reports about how slow XFS had become after an upgrade to the
latest -rcX kernel....

FWIW, while inodes are still operated on completely
independently there are only occasional problems where
inode write I/O conflict. e.g.

http://oss.sgi.com/archives/xfs/2008-02/msg00137.html

> >>Remember, in xfs, if the last bit of left-over data in an inode will fit
> >>into the inode, it can save a block-allocation, though I don't know
> >>how this will affect speed.
> >
> >No, that's wrong. We never put data in inodes.
> ---
> 	You mean file data, no?

Right. data = file data.

> 	Doesn't directory and link data
> get packed in?

That's metadata and metadata != file data. metadata gets packed
into the inode.

> It always gnawed at me, as to why inode's packing
> in small bits of data was disallowed for file data, but not
> other types of data.

We disallow file data and allow metadata to be in the inode because
metadata is journalled and data is not and mixing the two introduces
extremely nasty consistency corner cases into crash recovery.  It
can be done, but it's tricky and complex.

> How about extended attribute data?

That's metadata.

> >>Also, it depends on the situation, but sometimes flattening out the
> >>directory structure can speed up lookup time.
> >
> >Like using large directory block sizes to make large directory
> >btrees wider and flatter and therefore use less seeks for any given
> >random directory lookup? ;)
> ---
> 	Are you saying that directory entries are stored in a sorted
> order in a B-Tree?  Hmmm...

Put simply, yes. in more detail:

http://oss.sgi.com/projects/xfs/publications/papers/xfs_filesystem_structure.pdf

(grrrr - the link is currently broken - bug raised, will work soon)

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
