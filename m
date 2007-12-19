Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Dec 2007 19:43:54 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id lBJ3hkM8020244
	for <xfs@oss.sgi.com>; Tue, 18 Dec 2007 19:43:49 -0800
Date: Wed, 19 Dec 2007 14:43:49 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [review] Remove the xfs refcache
Message-ID: <20071219034349.GU4396912@sgi.com>
References: <4765EC66.5020202@sgi.com> <4765F444.8010705@sgi.com> <20071217071426.GA11462@infradead.org> <47674892.9070506@sgi.com> <20071218074405.GI4396912@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071218074405.GI4396912@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Lachlan McIlroy <lachlan@sgi.com>, Christoph Hellwig <hch@infradead.org>, Donald Douwsma <donaldd@sgi.com>, xfs-oss <xfs@oss.sgi.com>, gnb@sgi.com

On Tue, Dec 18, 2007 at 06:44:05PM +1100, David Chinner wrote:
> On Tue, Dec 18, 2007 at 03:12:02PM +1100, Lachlan McIlroy wrote:
> > Since I have been able to reproduce some of our NAS/NFS performance problems
> > without NFS (that is demonstrate that the problems are in XFS) it makes some
> > sense to fix these in XFS.  I have observed that for some non-NFS workloads
> > we see a significant reduction in log traffic with the OFC in XFS so for
> > reasons beyond NFS there may be a need to reactivate the refcache code.  For
> > the moment we are still analysing the pros/cons.
> 
> Reactivating the ref cache is fundamentally the wrong thing to do.
> Most of these problems come from the mismatch of inode life cycles
> between Linux and XFS and this is the basic problem we need to solve.
> 
> For example - do the open-write-close related performance issues go
> away if you remove the xfs_free_eofblocks() call in xfs_release()?
> i.e. are we just being stupid about the way we deal with closing
> of file descriptors?
> 
> This should work because the linux inode will remain around with a
> ref-count of 1 on the unused list due to the dentry pinning it
> in place. Only when the dentry gets reclaimed (e.g. memory pressure,
> unlink, unmount, etc) will the truncate occur, and hence repeated
> single file open-write-close based workloads (like the nfsd) don't
> issue a truncate transaction and trash the EOF preallocation on
> every close....
> 
> And look at the code - the *only thing* the refcache does is avoid
> the truncate in xfs_release(). So, the patch below is the equivalent
> of re-introducing the refcache into XFS but uses the linux inode
> life cycle to keep references around.
> 
> FWIW, this means that EOF pre-allocations will not get trimmed
> immediately which may have disk usage implications for users with
> small quotas, those that create lots of small files, or there are
> lots of written inodes with prealocated space cached in memory
> when a crash occurs.

FYI - numbers to back this up.

As an example of where the failure to truncate EOF blocks (i.e.
speculative preallocation) is bad, try creating several thousand
small files (say 1 byte) and seeing how long they take to sync
to disk.

With EOF truncation, we get all the data blocks allocated adjacently
so the elevator merges them together and we see large I/Os going
to disk (i.e. 512k I/os going to disk where 128 different file datai
writes have been merged).

Without EOF truncation, these files retain their speculative allocation
(default 64k) and so when written out we get a stream of 4k I/Os
separated by 64k. That is, one seek per inode written out instead of
it being large sequential I/O convering 128 files per I/O.

To demonstrate, sequntial creation of 1 byte files in a 30s period
followed by a (timed) sync:

With EOF truncation:

                      Creates                |       Deletes
Loads    Files  rate  usr   sys   intr  csw/s|  rate  usr   sys   intr  csw/s
-----  -------  ---- ----- ----- -----  -----|  ---- ----- ----- -----  -----
    1    39312  1070   6.8  91.8   4.3   1959   1572   0.9 107.1   0.4   1109
    2    68458  1627   9.9 155.4   2.6   1316   2535   1.7 207.5   0.7   1157

Without EOF truncation:

                      Creates                |       Deletes
Loads    Files  rate  usr   sys   intr  csw/s|  rate  usr   sys   intr  csw/s
-----  -------  ---- ----- ----- -----  -----|  ---- ----- ----- -----  -----
    1    42691   461   3.0  37.7   2.2   1535   1579   1.0 123.2   0.6   1105
    2    72785   530   3.3  44.4   2.8   1684   1774  37.8 179.7   5.1   2754

Note that without EOF truncation we create 5-10% more files in the
30s period this test ran for (due to it being CPU bound and not
issuing empty EOF truncation transactions), but the overall rate
includes the time it takes to write the data to disk as well. The
data write is far slower without EOF truncation....

Hence we see that the overall create+data write rate suffers
*greatly* due to the lack of EOF truncation, and hence why
avoiding EOF truncation on file close for local I/O is generally
considered a bad thing.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
