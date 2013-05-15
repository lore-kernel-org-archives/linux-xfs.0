Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A9C1E7F37
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 16:41:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 407F0AC002
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 14:41:13 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	G01le30gqXJXdDij for <xfs@oss.sgi.com>;
	Wed, 15 May 2013 14:41:11 -0700 (PDT)
Date: Thu, 16 May 2013 07:41:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: wishlist: xfs_repair should detect files with too small sizes
Message-ID: <20130515214105.GZ24635@dastard>
References: <20130514215550.GK17260@hellgate> <20130515004736.GM29466@dastard>
	<20130515080355.GL17260@hellgate>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130515080355.GL17260@hellgate>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Andras Korn <korn-xfs@elan.rulez.org>
Cc: xfs@oss.sgi.com

On Wed, May 15, 2013 at 10:03:55AM +0200, Andras Korn wrote:
> On Wed, May 15, 2013 at 10:47:36AM +1000, Dave Chinner wrote:
> 
> > > I have thousands of files on xfs whose inode claims their size is zero, but
> > > they have blocks allocated to them; du(1) reports a nonzero size. xfs_repair
> > > 3.1.9 ignores this. xfs_db can be used to recover the contents of the files
> > > (using commands like inode 1234; write core.size 4567).
> > > 
> > > David Chinner explained to me that xfs_repair ignores these files because
> > > it's legitimate to have blocks beyond eof (e.g. due to fallocate()), and
> > 
> > Actually due to speculative preallocation done by delayed
> > allocation.
> 
> But if the space is preallocated speculatively and then remains unused,
> shouldn't it get freed up somehow, eventually?

It does, whichever happens first:

	- the file is closed if the "keep on close" heuristic hasn't
	  been triggered
	- the file has been clean for 5 minutes (background sweeper)
	- the inode is reclaimed from cache.

If the system crashes, it is not cleaned up on reboot until the file
is read into cache again and the above can happen...

> > > that unwritten extent flagging doesn't help because such extents don't need
> > > to be flagged as it's impossible to read them.
> > 
> > fallocate will leave unwritten extents beyond EOF, in which case we
> > can detect it, but we know there's nothing to be done as there's no
> > data....
> 
> OK, so we have the following cases:
> 
> 1. fallocate. The file has more space allocated to it than the size field in
> its inode says, and the extra extents are flagged as unwritten.
> 
> 2. speculative preallocation. Same as above, but the extents are not flagged
> as unwritten.
> 
> 3. corruption. The file's inode reports an incorrect size for whatever
> reason. If it's too much, that's easy to detect; the problem is telling if
> it's too little.
> 
> Distinguishing between #1 and #2 is possible based on the unwritten flags.
> In case #2, I think the extra space should be possible to free up (perhaps
> by xfs_repair?). Of course, I suppose you could just run truncate(1) on all
> files...
> 
> The problem is recognising #3.
> 
> Do I have that right?

Yes.

But iin case #2 it is not xfs_repair's place to remove blocks that
are legitimately attached to an inode and correctly referenced. If
it does that, then you lose any hope of recovering from a missing
file size update on a crash as you lose all references to the data
that is on disk. i.e. you can't find the data to recover it.

> > > I think it would be useful to have the ability to distinguish between files
> > > that legitimately have extents beyond EOF and files whose inode incorrectly
> > > reports a too-small size.
> > 
> > How? Add a transaction to track the data that has been written?
> > 
> > Well, we already do that - with the inode size.
> 
> Ah, yes, that's true.
> 
> OK, thinking about it I realise there doesn't appear to be a good way of
> preventing the problem, but I'm still not sure some heuristic couldn't be
> invented to detect and partially remedy it after the fact.

Trying to remedy it in xfs_repair does more harm than good. What
happens now allows recovery of data if the inode size was wrong. If
we remove the blocks beyond EOF, we lose that ability and hence make
unrecoverable data loss more likely in common failure scenarios.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
