Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 02 Oct 2006 23:07:09 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k9366vaG032214
	for <xfs@oss.sgi.com>; Mon, 2 Oct 2006 23:06:59 -0700
Date: Tue, 3 Oct 2006 16:06:10 +1000
From: David Chinner <dgc@sgi.com>
Subject: [RFC 0/3] Convert XFS inode hashes to radix trees
Message-ID: <20061003060610.GV3024@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev@sgi.com
Cc: xfs@oss.sgi.com


One of the long standing problems with XFS on large machines and
filesystems is the sizing of the inode cache hashes used by XFS to
index the xfs_inode_t structures. The mount option ihashsize became
a necessity because the default calculations simply can't get it
right for all situations.

On top of that, as we increase the size of the inode hash and cache
more inodes, the inode cluster hash becomes the limiting factor,
especially when we have sparse cluster population.  The result of
this is that we can always get to the point where either the ihash
or the chash is a scalability or performance limitation.

The following three patches replace the hashes with a more scalable
solution that should not require tweaking in most situations.

I chose a radix tree to replace the hash chains because of a neat
alignment of XFS inode structures and the kernel radix tree fanout.
XFS allocates inodes in clusters of 64 inodes and the radix tree
keeps 64 sequential entries per node.  That means all for the inodes
in a cluster will always sit in the same node of the radix tree.

Using this relationship, we completely remove the need for the
cluster hash to track clusters because we can use a gang lookup on
the radix tree to search for an existing inode in the cluster in an
efficient manner.

The following three patches sit on top of the recently posted
i_flags cleanup patch.
(http://marc.theaimsgroup.com/?l=linux-xfs&m=115985254820322&w=2)

The first patch replaces the inode hash chains with radix trees.  A
single radix tree with a read/write lock does not provide enough
parallelism to prevent performance regressions under simultanenous
create/unlink workloadds, so we hash the inode clusters into
different radix trees each with their own read/write lock. The
default is to create (2*ncpus)-1 radix trees up to a maximum of 15.
At this point I have left the ihashsize mount option alone but
limited the maximum number it can take to 128. if you specify more
than 128 (i.e. everyone currently using this mount option), it
falls back to the default.

The second patch introduces a per-cluster object lock for chaining
the inodes in the cluster together (for xfs_iflush()). The inode
chain is currently locked by cluster hash chain lock, so we need
some other method of locking if we are to remove the cluster hash
altogether.

The third patch removes the cluster hash and replaces it with some
masking and a radix tree gang lookup.

Overall, the patchset removes more than 200 lines of code from the
xfs inode caching and lookup code and provides more consistent
scalability for large numbers of cached inodes. The only down side
is that it limits us to 32 bit inode numbers of 32 bit platforms due
to the way the radix tree uses unsigned longs for it's indexes

Comments, thoughts, etc are welcome.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
