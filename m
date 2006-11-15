Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 14 Nov 2006 17:21:24 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAF1LFaG022077
	for <xfs@oss.sgi.com>; Tue, 14 Nov 2006 17:21:17 -0800
Message-ID: <455A68AF.8030309@agami.com>
Date: Tue, 14 Nov 2006 17:09:03 -0800
From: Shailendra Tripathi <stripathi@agami.com>
MIME-Version: 1.0
Subject: Re: [RFC 0/3] Convert XFS inode hashes to radix trees
References: <20061003060610.GV3024@melbourne.sgi.com>
In-Reply-To: <20061003060610.GV3024@melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev@sgi.com, xfs@oss.sgi.com

Hi David,
                I regret for making comments and questions on this quite 
late (somehow I missed to email).
It does appear to me that using this approach can potentially help in 
cluster hash list related manipulations.
However, this appears (to me) to be at the cost of regular inode lookup.

As of now, each of the hash buckets have their own lock. This helps in 
not making the xfs_iget
operations hot. I have not seen of xfs_iget anywhere on the top in my 
profiling of Linux for SPECFS. 
With this code, the number of hash buckets can be appropriately sized 
(based upon memory availability).

However, it appears to be that radix tree (even with 15) can become a 
bottleneck. Lets assume that there are
600K inodes on a reasonably big end system and assuming fare 
distribution, each of the radix tree will
have 600K/15 ~ 40K inodes per hash tree. Insertion and deletion  to the 
list have to take writer_lock and
given their frequency, both readers (lookups) and writers will be affected.
 
That means, if one tree is locked for insertion or deletion, remaining 
40K inodes will be just serialized. However, in
current design, by sacrificing little extra memory, we can allocate more 
hash buckets and eventually the locked down
inodes can be made pretty small.  My knowledge on radix tree is little 
limited, but I think, increasing the number of trees
would be much more costly in memory terms. Given less memory usage and 
performance, I tend to believe that hash
table is more scalable than radix tree for inode tables.
        Have you done any performance testing with these patches. I am 
quite curious to know the results. If not, may be I can
try do some perf. testing with these changes albeit on a old kernel tree.
       Am I missing something here ? Please let me know.

Thanks and Regards,
Shailendra

David Chinner wrote:
> One of the long standing problems with XFS on large machines and
> filesystems is the sizing of the inode cache hashes used by XFS to
> index the xfs_inode_t structures. The mount option ihashsize became
> a necessity because the default calculations simply can't get it
> right for all situations.
>
> On top of that, as we increase the size of the inode hash and cache
> more inodes, the inode cluster hash becomes the limiting factor,
> especially when we have sparse cluster population.  The result of
> this is that we can always get to the point where either the ihash
> or the chash is a scalability or performance limitation.
>
> The following three patches replace the hashes with a more scalable
> solution that should not require tweaking in most situations.
>
> I chose a radix tree to replace the hash chains because of a neat
> alignment of XFS inode structures and the kernel radix tree fanout.
> XFS allocates inodes in clusters of 64 inodes and the radix tree
> keeps 64 sequential entries per node.  That means all for the inodes
> in a cluster will always sit in the same node of the radix tree.
>
> Using this relationship, we completely remove the need for the
> cluster hash to track clusters because we can use a gang lookup on
> the radix tree to search for an existing inode in the cluster in an
> efficient manner.
>
> The following three patches sit on top of the recently posted
> i_flags cleanup patch.
> (http://marc.theaimsgroup.com/?l=linux-xfs&m=115985254820322&w=2)
>
> The first patch replaces the inode hash chains with radix trees.  A
> single radix tree with a read/write lock does not provide enough
> parallelism to prevent performance regressions under simultanenous
> create/unlink workloadds, so we hash the inode clusters into
> different radix trees each with their own read/write lock. The
> default is to create (2*ncpus)-1 radix trees up to a maximum of 15.
> At this point I have left the ihashsize mount option alone but
> limited the maximum number it can take to 128. if you specify more
> than 128 (i.e. everyone currently using this mount option), it
> falls back to the default.
>
> The second patch introduces a per-cluster object lock for chaining
> the inodes in the cluster together (for xfs_iflush()). The inode
> chain is currently locked by cluster hash chain lock, so we need
> some other method of locking if we are to remove the cluster hash
> altogether.
>
> The third patch removes the cluster hash and replaces it with some
> masking and a radix tree gang lookup.
>
> Overall, the patchset removes more than 200 lines of code from the
> xfs inode caching and lookup code and provides more consistent
> scalability for large numbers of cached inodes. The only down side
> is that it limits us to 32 bit inode numbers of 32 bit platforms due
> to the way the radix tree uses unsigned longs for it's indexes
>
> Comments, thoughts, etc are welcome.
>
> Cheers,
>
> Dave.
>   
