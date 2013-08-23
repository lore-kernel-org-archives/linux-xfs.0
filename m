Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 50FE47CBF
	for <xfs@oss.sgi.com>; Thu, 22 Aug 2013 19:03:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 158D5304064
	for <xfs@oss.sgi.com>; Thu, 22 Aug 2013 17:03:35 -0700 (PDT)
Received: from mail-pb0-f48.google.com (mail-pb0-f48.google.com
	[209.85.160.48]) by cuda.sgi.com with ESMTP id T08B1aRmL0WE8wHG
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 22 Aug 2013 17:03:34 -0700 (PDT)
Received: by mail-pb0-f48.google.com with SMTP id ma3so2475182pbc.21
	for <xfs@oss.sgi.com>; Thu, 22 Aug 2013 17:03:34 -0700 (PDT)
From: Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v3 0/5] Rework mtime and ctime updates on mmaped writes
Date: Thu, 22 Aug 2013 17:03:16 -0700
Message-Id: <cover.1377193658.git.luto@amacapital.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-kernel@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>, Dave Hansen <dave.hansen@linux.intel.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Andy Lutomirski <luto@amacapital.net>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, Tim Chen <tim.c.chen@linux.intel.com>

Writes via mmap currently update mtime and ctime in ->page_mkwrite.
This hurts both throughput and latency.  In workloads that dirty a
large number of mmapped pages, ->page_mkwrite can be hot and
file_update_time is slow and scales poorly.  Updating timestamps can
also sleep, which hurts latency for real-time workloads.

This is also a correctness issue.  SuS says:

    The st_ctime and st_mtime fields of a file that is mapped with
    MAP_SHARED and PROT_WRITE, will be marked for update at some point
    in the interval between a write reference to the mapped region and
    the next call to msync() with MS_ASYNC or MS_SYNC for that portion
    of the file by any process. If there is no such call, these fields
    may be marked for update at any time after a write reference if
    the underlying file is modified as a result.

Currently, if the same mmapped page is written twice, the timestamp
may not be update at all after the second write, whereas SuS (and
anything using timestamps to invalidate caches, backup data, etc.)
would expect the timestamp to eventually be updated.

This patchset attempts to fix both issues at once.  It adds a new
address_space flag AS_CMTIME that is set atomically whenever the
system transfers a pte dirty bit to a struct page backed by the
address_space.  This can happen with various locks held and when low
on memory.

Later on, a_ops.update_cmtime_deferred is called to tell the FS to
update cmtime due to a previous mmapped write.

The core changes have no effect on unmodified filesystems.  To opt in,
a filesystem should implement .update_cmtime_deferred (most likely by
using generic_update_cmtime_deferred) and must call either
mapping_flush_cmtime or mapping_test_clear_cmtime in .writepages.
Filesystems should avoid updating timestamps in ->page_mkwrite.

The reason that this is not completely automatic is that filesystems
without backing stores do not really fit in to this model.
Eventually, someone can add support.

I've converted ext4, xfs, and btrfs.  Converting most other
filesystems should be straightforward.

I wrote an xfstest for this.  ext4, xfs, and btrfs pass.  It's here:

https://github.com/amluto/xfstests/commit/5fbb72ac799cc44a9c4c6d3919f00a479202c899

This series is pullable from:

https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/log/?h=mmap_mtime/patch_v4

Changes from v3:
 - The new address space op is now called update_cmtime_deferred.
   Callers take care of protection from fs freezing and checking
   AS_CMTIME.  I fixed a deadlock in the freezer interaction.
 - Block plugs should be handled better.
 - Fixed an infinite loop in msync(MS_ASYNC).
 - Converted xfs and btrfs.
 - Misc minor cleanups.
 - Fixed a corner case: reclaim or migration could have cleaned all
   pages without updating cmtime.

Changes from v2:
 - The core code now interacts with filesystems only through
   address_space ops, so there should be fewer layering issues.
 - MS_ASYNC is handled correctly.

Changes from v1:
 - inode_update_time_writable now locks against the fs freezer.
 - Minor cleanups.
 - Major changelog improvements.

Andy Lutomirski (7):
  mm: Track mappings that have been written via ptes
  fs: Add inode_update_time_writable
  mm: Allow filesystems to defer cmtime updates
  mm: Scan for dirty ptes and update cmtime on MS_ASYNC
  ext4: Defer mmap cmtime updates
  btrfs: Defer mmap cmtime updates
  xfs: Defer mmap cmtime updates

 fs/btrfs/extent_io.c      |  1 +
 fs/btrfs/inode.c          | 32 +++++++++---------
 fs/buffer.c               |  7 ----
 fs/ext4/inode.c           | 11 +++++--
 fs/inode.c                | 64 +++++++++++++++++++++++++++---------
 fs/xfs/xfs_aops.c         |  1 +
 include/linux/fs.h        |  9 +++++
 include/linux/pagemap.h   | 22 +++++++++++++
 include/linux/writeback.h |  1 +
 mm/memory.c               |  7 +++-
 mm/migrate.c              |  2 ++
 mm/mmap.c                 |  6 +++-
 mm/msync.c                | 84 ++++++++++++++++++++++++++++++++++++++++-------
 mm/page-writeback.c       | 53 +++++++++++++++++++++++++++++-
 mm/rmap.c                 | 27 +++++++++++++--
 mm/vmscan.c               |  1 +
 16 files changed, 272 insertions(+), 56 deletions(-)

-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
