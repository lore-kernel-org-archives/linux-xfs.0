Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 192107F4E
	for <xfs@oss.sgi.com>; Fri, 16 Aug 2013 18:22:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C4645304059
	for <xfs@oss.sgi.com>; Fri, 16 Aug 2013 16:22:20 -0700 (PDT)
Received: from mail-pd0-f182.google.com (mail-pd0-f182.google.com
	[209.85.192.182]) by cuda.sgi.com with ESMTP id
	jq6ttlt0D6M6574g (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 16 Aug 2013 16:22:19 -0700 (PDT)
Received: by mail-pd0-f182.google.com with SMTP id r10so1801004pdi.27
	for <xfs@oss.sgi.com>; Fri, 16 Aug 2013 16:22:19 -0700 (PDT)
From: Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v3 0/5] Rework mtime and ctime updates on mmaped
Date: Fri, 16 Aug 2013 16:22:07 -0700
Message-Id: <cover.1376679411.git.luto@amacapital.net>
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

Later on, a new address_space op ->flush_cmtime is called at various
points at which a filesystem should update timestamps if the file was
previously modified through mmap.

The core changes have no effect on unmodified filesystems.  To opt in, a filesystem should implement ->flush_ctime (most likely by using generic_flush_cmtime) and should avoid updating timestamps in ->page_mkwrite.

I've converted ext4.  If it works well, it will be easy to convert all
the other filesystems.

Changes from v2:
 - The core code now interacts with filesystems only through
   address_space ops, so there should be fewer layering issues.
 - MS_ASYNC is handled correctly.

Changes from v1:
 - inode_update_time_writable now locks against the fs freezer.
 - Minor cleanups.
 - Major changelog improvements.

Andy Lutomirski (5):
  mm: Track mappings that have been written via ptes
  fs: Add inode_update_time_writable
  mm: Notify filesystems when it's time to apply a deferred cmtime
    update
  mm: Scan for dirty ptes and update cmtime on MS_ASYNC
  ext4: Defer mmap cmtime update until writeback

 fs/ext4/inode.c           |  4 ++-
 fs/inode.c                | 72 +++++++++++++++++++++++++++++++---------
 include/linux/fs.h        | 10 ++++++
 include/linux/pagemap.h   | 11 +++++++
 include/linux/writeback.h |  1 +
 mm/memory.c               |  7 +++-
 mm/mmap.c                 |  9 ++++-
 mm/msync.c                | 83 ++++++++++++++++++++++++++++++++++++++++-------
 mm/page-writeback.c       | 26 +++++++++++++++
 mm/rmap.c                 | 27 +++++++++++++--
 10 files changed, 219 insertions(+), 31 deletions(-)

-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
