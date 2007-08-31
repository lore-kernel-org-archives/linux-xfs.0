Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 31 Aug 2007 07:33:26 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7VEXI4p029920
	for <xfs@oss.sgi.com>; Fri, 31 Aug 2007 07:33:23 -0700
Message-ID: <46D826BA.1060705@sandeen.net>
Date: Fri, 31 Aug 2007 09:33:30 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] Increase lockdep MAX_LOCK_DEPTH
References: <46D79C62.1010304@sandeen.net> <1188542389.6112.44.camel@twins> <20070831135042.GD422459@sgi.com>
In-Reply-To: <20070831135042.GD422459@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel Mailing List <linux-kernel@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>, Ingo Molnar <mingo@elte.hu>

David Chinner wrote:
> On Fri, Aug 31, 2007 at 08:39:49AM +0200, Peter Zijlstra wrote:
>> On Thu, 2007-08-30 at 23:43 -0500, Eric Sandeen wrote:
>>> The xfs filesystem can exceed the current lockdep 
>>> MAX_LOCK_DEPTH, because when deleting an entire cluster of inodes,
>>> they all get locked in xfs_ifree_cluster().  The normal cluster
>>> size is 8192 bytes, and with the default (and minimum) inode size 
>>> of 256 bytes, that's up to 32 inodes that get locked.  Throw in a 
>>> few other locks along the way, and 40 seems enough to get me through
>>> all the tests in the xfsqa suite on 4k blocks.  (block sizes
>>> above 8K will still exceed this though, I think)
>> As 40 will still not be enough for people with larger block sizes, this
>> does not seems like a solid solution. Could XFS possibly batch in
>> smaller (fixed sized) chunks, or does that have significant down sides?
> 
> The problem is not filesystem block size, it's the xfs inode cluster buffer
> size / the size of the inodes that determines the lock depth. the common case
> is 8k/256 = 32 inodes in a buffer, and they all get looked during inode
> cluster writeback.

Right, but as I understand it, the cluster size *minimum* is the block
size; that's why I made reference to block size - 16k blocks would have
64 inodes per cluster, minimum, potentially all locked in these paths.
Just saying that today, larger blocks -> larger clusters -> more locks.

Even though MAX_LOCK_DEPTH of 40 may not accomodate these scenarios, at
least it would accomodate the most common case today...

Peter, unless there is some other reason to do so, changing xfs
performance behavior simply to satisfy lockdep limitations* doesn't seem
like the best plan.

I suppose one slightly flakey option would be for xfs to see whether
lockdep is enabled and adjust cluster size based on MAX_LOCK_DEPTH... on
the argument that lockdep is likely used in debugging kernels where
sheer performance is less important... but, that sounds pretty flakey to me.

-Eric

*and I don't mean that in a pejorative sense; just the fact that some
max depth must be chosen - the literal "limitation."
