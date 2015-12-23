Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2217D7F37
	for <xfs@oss.sgi.com>; Wed, 23 Dec 2015 13:39:35 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 10879304053
	for <xfs@oss.sgi.com>; Wed, 23 Dec 2015 11:39:31 -0800 (PST)
Received: from mga14.intel.com ([192.55.52.115]) by cuda.sgi.com with ESMTP id
	aDpgYZxsAIrlkRc4 for <xfs@oss.sgi.com>;
	Wed, 23 Dec 2015 11:39:28 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v6 0/7] DAX fsync/msync support
Date: Wed, 23 Dec 2015 12:39:13 -0700
Message-Id: <1450899560-26708-1-git-send-email-ross.zwisler@linux.intel.com>
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

Changes since v5 [1]:

1) Merged with Dan's changes to fs/dax.c that were staged in -mm and -next.

2) Store sectors in the address_space radix tree for DAX entries instead of
addresses.  This allows us to get the addresses from the block driver
via dax_map_atomic() during fsync/msync so that we can protect against
races with block device removal. (Dan)

3) Reordered things a bit in dax_writeback_one() so we clear the
PAGECACHE_TAG_TOWRITE tag even if the radix tree entry is corrupt.  This
prevents us from getting into an infinite loop where we don't proceed far
enough in dax_writeback_one() to clear that flag, but
dax_writeback_mapping_range() will keep finding that entry via
find_get_entries_tag().

4) Changed the ordering of the radix tree insertion so that it happens
before the page insertion into the page tables.  This ensures that we don't
end up in a case where the page table insertion succeeds and the radix tree
insertion fails which could give us a writeable PTE that has no
corresponding radix tree entry.

5) Got rid of the 'nrdax' variable in struct address_space and renamed
'nrshadows' to 'nrexceptional' so that it can be used for both DAX and
shadow exceptional entries.  We explicitly prevent shadow entries from
being added to radix trees for DAX mappings, so the single counter can
safely be reused for both purposes. (Jan)

6) Updated all my WARN_ON() calls so I use the return value to know whether
I've hit an erorr. (Andrew)

This series applies cleanly and was tested against next-20151223.

A working tree can be found here:

https://git.kernel.org/cgit/linux/kernel/git/zwisler/linux.git/log/?h=fsync_v6

[1]: https://lists.01.org/pipermail/linux-nvdimm/2015-December/003588.html

Ross Zwisler (7):
  pmem: add wb_cache_pmem() to the PMEM API
  dax: support dirty DAX entries in radix tree
  mm: add find_get_entries_tag()
  dax: add support for fsync/msync
  ext2: call dax_pfn_mkwrite() for DAX fsync/msync
  ext4: call dax_pfn_mkwrite() for DAX fsync/msync
  xfs: call dax_pfn_mkwrite() for DAX fsync/msync

 arch/x86/include/asm/pmem.h |  11 +--
 fs/block_dev.c              |   2 +-
 fs/dax.c                    | 196 ++++++++++++++++++++++++++++++++++++++++++--
 fs/ext2/file.c              |   4 +-
 fs/ext4/file.c              |   4 +-
 fs/inode.c                  |   2 +-
 fs/xfs/xfs_file.c           |   7 +-
 include/linux/dax.h         |   7 ++
 include/linux/fs.h          |   3 +-
 include/linux/pagemap.h     |   3 +
 include/linux/pmem.h        |  22 ++++-
 include/linux/radix-tree.h  |   9 ++
 mm/filemap.c                |  91 ++++++++++++++++++--
 mm/truncate.c               |  69 +++++++++-------
 mm/vmscan.c                 |   9 +-
 mm/workingset.c             |   4 +-
 16 files changed, 384 insertions(+), 59 deletions(-)

-- 
2.6.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
