Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DBA8A7F51
	for <xfs@oss.sgi.com>; Fri, 18 Dec 2015 23:22:33 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7CAE6AC003
	for <xfs@oss.sgi.com>; Fri, 18 Dec 2015 21:22:30 -0800 (PST)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24]) by
	cuda.sgi.com with ESMTP id GKFOAF5gCHHUSIRH for
	<xfs@oss.sgi.com>; Fri, 18 Dec 2015 21:22:28 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v5 0/7] DAX fsync/msync support
Date: Fri, 18 Dec 2015 22:22:13 -0700
Message-Id: <1450502540-8744-1-git-send-email-ross.zwisler@linux.intel.com>
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

Changes from v4:
 - Explicity prevent shadow entries from being added to radix trees for DAX
   mappings in patch 2.  The only shadow entries that would be generated
   for DAX radix trees would be to track zero page mappings that were
   created for holes.  These pages would receive minimal benefit from
   having shadow entries, and the choice to have only one type of
   exceptional entry in a given radix tree makes the logic simpler both in
   clear_exceptional_entry() and in the rest of DAX.  (Jan)

 - Added Reviewed-by from Jan to patch 3.

This series is built upon ext4/master.  A working tree with this series
applied can be found here:

https://git.kernel.org/cgit/linux/kernel/git/zwisler/linux.git/log/?h=fsync_v5

Ross Zwisler (7):
  pmem: add wb_cache_pmem() to the PMEM API
  dax: support dirty DAX entries in radix tree
  mm: add find_get_entries_tag()
  dax: add support for fsync/sync
  ext2: call dax_pfn_mkwrite() for DAX fsync/msync
  ext4: call dax_pfn_mkwrite() for DAX fsync/msync
  xfs: call dax_pfn_mkwrite() for DAX fsync/msync

 arch/x86/include/asm/pmem.h |  11 +--
 fs/block_dev.c              |   3 +-
 fs/dax.c                    | 159 ++++++++++++++++++++++++++++++++++++++++++--
 fs/ext2/file.c              |   4 +-
 fs/ext4/file.c              |   4 +-
 fs/inode.c                  |   1 +
 fs/xfs/xfs_file.c           |   7 +-
 include/linux/dax.h         |   7 ++
 include/linux/fs.h          |   1 +
 include/linux/pagemap.h     |   3 +
 include/linux/pmem.h        |  22 +++++-
 include/linux/radix-tree.h  |   9 +++
 mm/filemap.c                |  84 ++++++++++++++++++++++-
 mm/truncate.c               |  64 ++++++++++--------
 mm/vmscan.c                 |   9 ++-
 15 files changed, 339 insertions(+), 49 deletions(-)

-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
