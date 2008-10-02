Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 01 Oct 2008 17:33:58 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m920XsQ6026181
	for <xfs@oss.sgi.com>; Wed, 1 Oct 2008 17:33:55 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 54F0E134F9DA
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2008 17:35:31 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id snvHL7HDvhGyXkH9 for <xfs@oss.sgi.com>; Wed, 01 Oct 2008 17:35:31 -0700 (PDT)
Date: Thu, 2 Oct 2008 10:32:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: RAID5/6 writes
Message-ID: <20081002003251.GA30001@disturbed>
References: <20081001175237.GJ32037@cordes.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081001175237.GJ32037@cordes.ca>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Peter Cordes <peter@cordes.ca>
Cc: xfs@oss.sgi.com

On Wed, Oct 01, 2008 at 02:52:37PM -0300, Peter Cordes wrote:
>  I just had an idea for speeding up writes to parity-based RAIDs
> (RAID4,5,6).[1]  If XFS wants to write sectors 1,2,3, 5,6,7, but it
> knows that block 4 is free space, it might be better to write sector 4
> (with zeros, don't put uninitialized kernel memory on disk!).

How does XFS know that block 4 is free space? Or indeed that this is
a single block sized hole in range of blocks mapped to different inodes
or filesystem metadata?

If you want something like this, you need to have the lower layer
discover holes like this and instead of immediately initiating
a RMW cycle, it calls back to the filesystem to determine is hole
is free space. That works for all filesystems not just XFS.

> It's
> probably only useful to do this if XFS has data in memory to prove
> that the gap is not part of the filesystem.  Doing extra reads
> probably doesn't make sense except in very special cases.  (e.g.
> repeated writes to the same location with the same hole, so just one
> read would let them all become full-block or even full-stripe writes.)

That's the sort of workload the stripe cache is supposed to optimise;
every subsequent sparse write to the same stripe line avoids the
read part of the RMW cycle. The filesystem is the wrong layer to
optimise this type of workload....

FWIW, XFS has it's own problems with writeback triggering RMW
cycles - this sort of thing for data could be considered noise
compared to the RMW storm that can be caused by inode writeback
under memory pressure as XFS has to do RMW cycles itself on the
inode cluster buffers. See the Inode Writeback section of this
document:

http://oss.sgi.com/archives/xfs/2008-09/msg00289.html

This can only be fixed at the filesystem level because no amount of
tweaking the storage can improve the I/O patterns that XFS is
issuing. These RMW cycles in inode writeback can cause the inode
flush rate to drop to a few tens of inodes per second. When you have
hundreds of thousands of dirty inodes in a system, it can take
*hours* to flush the dirty inodes to disk....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
