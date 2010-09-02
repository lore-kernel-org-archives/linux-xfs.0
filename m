Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o821HAp4175011 for <xfs@oss.sgi.com>; Wed, 1 Sep 2010 20:17:11 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4A6F715DE6C1
	for <xfs@oss.sgi.com>; Wed,  1 Sep 2010 18:28:25 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	MxKYL49BLUMl2tNM for <xfs@oss.sgi.com>;
	Wed, 01 Sep 2010 18:28:25 -0700 (PDT)
Date: Thu, 2 Sep 2010 11:17:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: deleting 2TB lots of files with delaylog: sync helps?
Message-ID: <20100902011744.GS705@dastard>
References: <201009010130.41500@zmi.at> <4C7DC21B.1040705@hardwarefreak.com>
	<20100901034156.GQ705@dastard> <201009010945.59204@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201009010945.59204@zmi.at>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Wed, Sep 01, 2010 at 09:45:58AM +0200, Michael Monnerie wrote:
> On Mittwoch, 1. September 2010 Dave Chinner wrote:
> > Without delayed logging, 150MB/s is enough for a single threaded
> > unlink to consume an entire CPU core on any modern CPU
>  
> Just as Stan I'm puzzled by this. Why is it such a hard work for the 
> CPU, what does it do? Is it really about calculating something, or has 
> it to do with lock contention, cold caches, cache line bouncing and 
> other "horrible" things so the CPU can't get it's maximum power? I'm 
> really curious to understand that.

Ok, it seems that people don't have any real idea of th complexity
of directory operations in XFS, so I'll give you a quick overview.

The XFS directory structure is excedingly complex and the algorithm
is designed to trade off using more CPU time to issue fewer disk IOs
during operations and so provide deterministic, predictable
scalability. The result is that it consumes more CPU per operation
than ext3/4, but the algorithms scale far better than ext3/4.

Here's what an unlink must do on XFS:

	-> determine the directory format:
		-> short form (a handful of entries, not interesting)
		-> leaf form (up to a few thousand entries)
		-> node/leaf form (up to a few tens of thousand entries)
		-> btree form
	-> hash the name
	-> walk the directory hash btree index to find the
	   leaf the entry exists in
		-> the btree code has lots of interesting readahead
		   heuristics to minimise the impact of seek latency on
		   tree walks and modifications
	-> all blocks are read on demand from disk/cache
	-> remove entry from the leaf
	-> update the freespace entry in the leaf
	-> update the dirctory hash index
	-> update the directory freespace index
	-> update the by-offset directory index
	-> track all modified regions of all blocks
	   in transaction structure

	If any of these result in an index block merge or
	a leaf being freed,then for every block being freed:

	-> punch hole in directory extent map
	-> free block
		-> add free extent back to AG freespace trees
		  (both the by-size indexed tree, and the by-offset
		  indexed tree). For each tree:
			-> adjust freelist to have enough free
			   blocks for any allocation required
			-> lookup tree to position cursor for insert
			-> determine if record merge is required
			-> insert/modify record
				-> may rquire split (allocation)
			-> update index
				-> may require multiple splits as we
				   walk back up the tree
			-> track all modified regions of all blocks
		-> mark block busy

	-> commit transaction.

At < 100k entries in a directory, XFS consumes roughly 2-3x more CPU
per operation than ext3/4. However, at somewhere between 100k-200k
entries, ext4 directory hashing results in directory fragmentation
bad enough that the IO patterns become completely random and
performance becomes seek bound. I can get ext4 performance to
continue to scale to 1m entries because my disk backend can do
10kiops!

In contrast, XFS CPU consumption increases per-operation in a
predictable fashion - O(log n) where n is the number of directory
entries. e.g for 4k directory blocks it increases by ~2x from 100k
entries to 1m entries, and another 2x from 1M entries to 10M entries
and so on, but the result is that the IO patterns are rarely enough
to cause operations to become seek bound.

> Maybe there should be an extra SSE4 assembler instruction "rm on XFS" so 
> we can delete files faster? ;-)

You'd need an entire ASIC, not an instruction ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
