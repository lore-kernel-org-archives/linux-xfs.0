Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 19 Nov 2006 18:14:40 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kAK2ETaG021709
	for <xfs@oss.sgi.com>; Sun, 19 Nov 2006 18:14:31 -0800
Date: Mon, 20 Nov 2006 13:13:28 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [RFC 0/3] Convert XFS inode hashes to radix trees
Message-ID: <20061120021328.GZ11034@melbourne.sgi.com>
References: <20061003060610.GV3024@melbourne.sgi.com> <455A68AF.8030309@agami.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <455A68AF.8030309@agami.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Shailendra Tripathi <stripathi@agami.com>
Cc: xfs-dev@sgi.com, xfs@oss.sgi.com

On Tue, Nov 14, 2006 at 05:09:03PM -0800, Shailendra Tripathi wrote:
> Hi David,
>                I regret for making comments and questions on this quite 
> late (somehow I missed to email).
> It does appear to me that using this approach can potentially help in 
> cluster hash list related manipulations.
> However, this appears (to me) to be at the cost of regular inode lookup.

Yes, there is less parallelism in the radix tree approach, as I stated
in the original description.

> As of now, each of the hash buckets have their own lock. This helps in 
> not making the xfs_iget
> operations hot. I have not seen of xfs_iget anywhere on the top in my 
> profiling of Linux for SPECFS. 
> With this code, the number of hash buckets can be appropriately sized 
> (based upon memory availability).

Sure, but tuning for specsfs is not the problem we are trying to
solve here.  The problem we are solving is scaling to tens of
millions of cached inodes in core -without needing to tune- the
filesystem and the inode hashes are the number one problem there.


> However, it appears to be that radix tree (even with 15) can become a 
> bottleneck. Lets assume that there are
> 600K inodes on a reasonably big end system and assuming fare 

Only 600k cached inodes? That's not a "big end" system - we're
seeing problems with single filesystem inode caches almost two
_orders of magnitude_ larger than this on production machines.

> distribution, each of the radix tree will
> have 600K/15 ~ 40K inodes per hash tree. Insertion and deletion  to the 
> list have to take writer_lock and
> given their frequency, both readers (lookups) and writers will be affected.

Right, but we've been hacking at this code time and time again
because of scalability problems due to hash sizing, inefficient list
traversal, non MRU ordering of the hash lists, etc.  Hash tables are
simply too inflexible when it comes to scaling to really, really
large numbers of cached inodes.

The advantage of radix trees is logarithmic scaling, so the length
of time the lock is held (either shared or exclusive) is reduced
substantially when cache misses (i.e. when you need to do an insert)
occur. Hence the reduction in the number of locks is somewhat
negated by the reduced time we need to hold the lock for.

So, I've traded off massively overblown parallelism for a struture
that scales far better and, by my measurements, provides the same
throughput.

And, FWIW, I'm not really concerned about cache hit parallelism in
the face of insert and delete exclusive locking because this patch
in the -mm tree from Nick Piggin:

radix-tree-rcu-lockless-readside.patch

is the right way to solve this problem and will be far better
than even the existing hash is in terms of lookup parallelism.

>        Have you done any performance testing with these patches. I am 
> quite curious to know the results. If not, may be I can
> try do some perf. testing with these changes albeit on a old kernel tree.

Yes, I have done some performance testing on them (but not specsfs).
IIRC (I can't find the results right now), a single radix tree performed
the same as a default hash up to ~8 parallel threads all doing
creates or removes and the tests ran up to about 5 million inodes
in core on the one filesystem. With a hash of 7 radix trees (4p machine)
the radix tree implemetnation at 8 threads had about 10% improvement
in throughput and this increased to about 15% by 128 threads. Also,
there was a reduction in CPU usage of about 10% when the thread count
increased past about 16....

The other big difference is theimprovement in inode reclaim speed -
unmount of a filesystem with ~13 million inodes in core dropped from
about 20 minutes to under 2 minutes i.e. ~18 minutes reclaiming
inodes (i.e. removing them form the hashes) down to ~30s during
unmount.

>       Am I missing something here ? Please let me know.

The potential that lockless radix tree lookups imply, I think ;)

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
