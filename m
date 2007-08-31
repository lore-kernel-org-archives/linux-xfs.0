Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 31 Aug 2007 07:34:01 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7VEXt4p030095
	for <xfs@oss.sgi.com>; Fri, 31 Aug 2007 07:33:57 -0700
Subject: Re: [PATCH] Increase lockdep MAX_LOCK_DEPTH
From: Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20070831135042.GD422459@sgi.com>
References: <46D79C62.1010304@sandeen.net> <1188542389.6112.44.camel@twins>
	 <20070831135042.GD422459@sgi.com>
Content-Type: text/plain
Date: Fri, 31 Aug 2007 16:33:51 +0200
Message-Id: <1188570831.6112.64.camel@twins>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-kernel Mailing List <linux-kernel@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>, Ingo Molnar <mingo@elte.hu>

On Fri, 2007-08-31 at 23:50 +1000, David Chinner wrote:
> On Fri, Aug 31, 2007 at 08:39:49AM +0200, Peter Zijlstra wrote:
> > On Thu, 2007-08-30 at 23:43 -0500, Eric Sandeen wrote:
> > > The xfs filesystem can exceed the current lockdep 
> > > MAX_LOCK_DEPTH, because when deleting an entire cluster of inodes,
> > > they all get locked in xfs_ifree_cluster().  The normal cluster
> > > size is 8192 bytes, and with the default (and minimum) inode size 
> > > of 256 bytes, that's up to 32 inodes that get locked.  Throw in a 
> > > few other locks along the way, and 40 seems enough to get me through
> > > all the tests in the xfsqa suite on 4k blocks.  (block sizes
> > > above 8K will still exceed this though, I think)
> > 
> > As 40 will still not be enough for people with larger block sizes, this
> > does not seems like a solid solution. Could XFS possibly batch in
> > smaller (fixed sized) chunks, or does that have significant down sides?
> 
> The problem is not filesystem block size, it's the xfs inode cluster buffer
> size / the size of the inodes that determines the lock depth. the common case
> is 8k/256 = 32 inodes in a buffer, and they all get looked during inode
> cluster writeback.
> 
> This inode writeback clustering is one of the reasons XFS doesn't suffer from
> atime issues as much as other filesystems - it doesn't need to do as much I/O
> to write back dirty inodes to disk.
> 
> IOWs, we are not going to make the inode clusters smallers - if anything they
> are going to get *larger* in future so we do less I/O during inode writeback
> than we do now.....

Since they are all trylocks it seems to suggest there is no hard _need_
to lock a whole inode cluster at once, and could iterate through it with
less inodes locked.

Granted I have absolutely no understanding of what I'm talking about :-)

Trouble is, we'd like to have a sane upper bound on the amount of held
locks at any one time, obviously this is just wanting, because a lot of
lock chains also depend on the number of online cpus...
