Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6E8727F37
	for <xfs@oss.sgi.com>; Thu,  7 Jan 2016 23:28:14 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 68F1B8F8052
	for <xfs@oss.sgi.com>; Thu,  7 Jan 2016 21:28:14 -0800 (PST)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20]) by
	cuda.sgi.com with ESMTP id uCW7pkkv3L7EbkBw for
	<xfs@oss.sgi.com>; Thu, 07 Jan 2016 21:28:12 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v8 0/9] DAX fsync/msync support
Date: Thu,  7 Jan 2016 22:27:50 -0700
Message-Id: <1452230879-18117-1-git-send-email-ross.zwisler@linux.intel.com>
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
Cc: Dave Hansen <dave.hansen@linux.intel.com>, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, "H. Peter Anvin" <hpa@zytor.com>, Jeff Layton <jlayton@poochiereds.net>, Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org, x86@kernel.org, Ingo Molnar <mingo@redhat.com>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, Alexander Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew.r.wilcox@intel.com>

Changes since v7 [1]:

1) Update patch 1 so that we initialize bh->b_bdev before passing it to
get_block() instead of working around the fact that it could still be NULL
after get_block() completes. (Dan)

2) Add a check to dax_radix_entry() so that we WARN_ON_ONCE() and exit
gracefully if we find a page cache entry still in the radix tree when
trying to insert a DAX entry.

This series replaces v7 in the MM tree and in the "akpm" branch of the next
tree.  A working tree can be found here:

https://git.kernel.org/cgit/linux/kernel/git/zwisler/linux.git/log/?h=fsync_v8

[1]: https://lists.01.org/pipermail/linux-nvdimm/2016-January/003886.html

Ross Zwisler (9):
  dax: fix NULL pointer dereference in __dax_dbg()
  dax: fix conversion of holes to PMDs
  pmem: add wb_cache_pmem() to the PMEM API
  dax: support dirty DAX entries in radix tree
  mm: add find_get_entries_tag()
  dax: add support for fsync/msync
  ext2: call dax_pfn_mkwrite() for DAX fsync/msync
  ext4: call dax_pfn_mkwrite() for DAX fsync/msync
  xfs: call dax_pfn_mkwrite() for DAX fsync/msync

 arch/x86/include/asm/pmem.h |  11 +--
 fs/block_dev.c              |   2 +-
 fs/dax.c                    | 215 ++++++++++++++++++++++++++++++++++++++++----
 fs/ext2/file.c              |   4 +-
 fs/ext4/file.c              |   4 +-
 fs/inode.c                  |   2 +-
 fs/xfs/xfs_file.c           |   7 +-
 include/linux/dax.h         |   7 ++
 include/linux/fs.h          |   3 +-
 include/linux/pagemap.h     |   3 +
 include/linux/pmem.h        |  22 ++++-
 include/linux/radix-tree.h  |   9 ++
 mm/filemap.c                |  91 +++++++++++++++++--
 mm/truncate.c               |  69 +++++++-------
 mm/vmscan.c                 |   9 +-
 mm/workingset.c             |   4 +-
 16 files changed, 393 insertions(+), 69 deletions(-)

-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
