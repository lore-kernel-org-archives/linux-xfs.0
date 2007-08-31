Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 31 Aug 2007 06:51:19 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7VDpD4p022771
	for <xfs@oss.sgi.com>; Fri, 31 Aug 2007 06:51:15 -0700
Date: Fri, 31 Aug 2007 23:50:42 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] Increase lockdep MAX_LOCK_DEPTH
Message-ID: <20070831135042.GD422459@sgi.com>
References: <46D79C62.1010304@sandeen.net> <1188542389.6112.44.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1188542389.6112.44.camel@twins>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Peter Zijlstra <peterz@infradead.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-kernel Mailing List <linux-kernel@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>, Dave Chinner <dgc@sgi.com>, Ingo Molnar <mingo@elte.hu>

On Fri, Aug 31, 2007 at 08:39:49AM +0200, Peter Zijlstra wrote:
> On Thu, 2007-08-30 at 23:43 -0500, Eric Sandeen wrote:
> > The xfs filesystem can exceed the current lockdep 
> > MAX_LOCK_DEPTH, because when deleting an entire cluster of inodes,
> > they all get locked in xfs_ifree_cluster().  The normal cluster
> > size is 8192 bytes, and with the default (and minimum) inode size 
> > of 256 bytes, that's up to 32 inodes that get locked.  Throw in a 
> > few other locks along the way, and 40 seems enough to get me through
> > all the tests in the xfsqa suite on 4k blocks.  (block sizes
> > above 8K will still exceed this though, I think)
> 
> As 40 will still not be enough for people with larger block sizes, this
> does not seems like a solid solution. Could XFS possibly batch in
> smaller (fixed sized) chunks, or does that have significant down sides?

The problem is not filesystem block size, it's the xfs inode cluster buffer
size / the size of the inodes that determines the lock depth. the common case
is 8k/256 = 32 inodes in a buffer, and they all get looked during inode
cluster writeback.

This inode writeback clustering is one of the reasons XFS doesn't suffer from
atime issues as much as other filesystems - it doesn't need to do as much I/O
to write back dirty inodes to disk.

IOWs, we are not going to make the inode clusters smallers - if anything they
are going to get *larger* in future so we do less I/O during inode writeback
than we do now.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
