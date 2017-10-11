Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58251 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752386AbdJKUGR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 11 Oct 2017 16:06:17 -0400
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/19 v3] dax, ext4, xfs: Synchronous page faults
Date: Wed, 11 Oct 2017 22:05:44 +0200
Message-Id: <20171011200603.27442-1-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Ted Tso <tytso@mit.edu>, "Darrick J. Wong" <darrick.wong@oracle.com>, Jan Kara <jack@suse.cz>

Hello,

here is the third version of my patches to implement synchronous page faults
for DAX mappings to make flushing of DAX mappings possible from userspace so
that they can be flushed on finer than page granularity and also avoid the
overhead of a syscall.

We use a new mmap flag MAP_SYNC to indicate that page faults for the mapping
should be synchronous.  The guarantee provided by this flag is: While a block
is writeably mapped into page tables of this mapping, it is guaranteed to be
visible in the file at that offset also after a crash.

How I implement this is that ->iomap_begin() indicates by a flag that inode
block mapping metadata is unstable and may need flushing (use the same test as
whether fdatasync() has metadata to write). If yes, DAX fault handler refrains
from inserting / write-enabling the page table entry and returns special flag
VM_FAULT_NEEDDSYNC together with a PFN to map to the filesystem fault handler.
The handler then calls fdatasync() (vfs_fsync_range()) for the affected range
and after that calls DAX code to update the page table entry appropriately.

The first patch in this series is taken from Dan Williams' series for
MAP_DIRECT so that we get a reliable way of detecting whether MAP_SYNC is
supported or not.

I did some basic performance testing on the patches over ramdisk - timed
latency of page faults when faulting 512 pages. I did several tests: with file
preallocated / with file empty, with background file copying going on / without
it, with / without MAP_SYNC (so that we get comparison).  The results are
(numbers are in microseconds):

File preallocated, no background load no MAP_SYNC:
min=9 avg=10 max=46
8 - 15 us: 508
16 - 31 us: 3
32 - 63 us: 1

File preallocated, no background load, MAP_SYNC:
min=9 avg=10 max=47
8 - 15 us: 508
16 - 31 us: 2
32 - 63 us: 2

File empty, no background load, no MAP_SYNC:
min=21 avg=22 max=70
16 - 31 us: 506
32 - 63 us: 5
64 - 127 us: 1

File empty, no background load, MAP_SYNC:
min=40 avg=124 max=242
32 - 63 us: 1
64 - 127 us: 333
128 - 255 us: 178

File empty, background load, no MAP_SYNC:
min=21 avg=23 max=67
16 - 31 us: 507
32 - 63 us: 4
64 - 127 us: 1

File empty, background load, MAP_SYNC:
min=94 avg=112 max=181
64 - 127 us: 489
128 - 255 us: 23

So here we can see the difference between MAP_SYNC vs non MAP_SYNC is about
100-200 us when we need to wait for transaction commit in this setup. 

Anyway, here are the patches and AFAICT the series is pretty much complete
so we can start thinking how to merge this. Changes to ext4 / XFS are pretty
minimal so either tree is fine I guess. Comments are welcome.

Changes since v2:
* avoid unnecessary flushing of faulted page (Ross) - I've realized it makes no
  sense to remeasure my benchmark results (after actually doing that and seeing
  no difference, sigh) since I use ramdisk and not real PMEM HW and so flushes
  are ignored.
* handle nojournal mode of ext4
* other smaller cleanups & fixes (Ross)
* factor larger part of finishing of synchronous fault into a helper (Christoph)
* reorder pfnp argument of dax_iomap_fault() (Christoph)
* add XFS support from Christoph
* use proper MAP_SYNC support in mmap(2)
* rebased on top of 4.14-rc4

Changes since v1:
* switched to using mmap flag MAP_SYNC
* cleaned up fault handlers to avoid passing pfn in vmf->orig_pte
* switched to not touching page tables before we are ready to insert final
  entry as it was unnecessary and not really simplifying anything
* renamed fault flag to VM_FAULT_NEEDDSYNC
* other smaller fixes found by reviewers

								Honza
