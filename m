Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:16236 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752507AbdFNRWU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Jun 2017 13:22:20 -0400
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v2 0/3] DAX common 4k zero page
Date: Wed, 14 Jun 2017 11:22:08 -0600
Message-Id: <20170614172211.19820-1-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Theodore Ts'o <tytso@mit.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger.kernel@dilger.ca>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Dave Hansen <dave.hansen@intel.com>, Ingo Molnar <mingo@redhat.com>, Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <mawilcox@microsoft.com>, Steven Rostedt <rostedt@goodmis.org>, linux-doc@vger.kernel.org, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org

When servicing mmap() reads from file holes the current DAX code allocates
a page cache page of all zeroes and places the struct page pointer in the
mapping->page_tree radix tree.  This has two major drawbacks:

1) It consumes memory unnecessarily.  For every 4k page that is read via a
DAX mmap() over a hole, we allocate a new page cache page.  This means that
if you read 1GiB worth of pages, you end up using 1GiB of zeroed memory.

2) The fact that we had to check for both DAX exceptional entries and for
page cache pages in the radix tree made the DAX code more complex.

This series solves these issues by following the lead of the DAX PMD code
and using a common 4k zero page instead.  This reduces memory usage for
some workloads, and it also simplifies the code in fs/dax.c, removing about
100 lines of code.

My hope is to have this reviewed and merged in time for v4.13 via the MM
tree, so if you could spare some review cycles I'd be grateful.

---
Changes since v1:
 - Leave vm_insert_mixed() instact with previous functionality and add
   vm_insert_mixed_mkwrite() as a peer so it is more readable/greppable.
   (Dan)

Ross Zwisler (3):
  mm: add vm_insert_mixed_mkwrite()
  dax: relocate dax_load_hole()
  dax: use common 4k zero page for dax mmap reads

 Documentation/filesystems/dax.txt |   5 +-
 fs/dax.c                          | 265 ++++++++++++--------------------------
 fs/ext2/file.c                    |  25 +---
 fs/ext4/file.c                    |  32 +----
 fs/xfs/xfs_file.c                 |   2 +-
 include/linux/dax.h               |  13 +-
 include/linux/mm.h                |   2 +
 include/trace/events/fs_dax.h     |   2 -
 mm/memory.c                       |  49 ++++++-
 9 files changed, 141 insertions(+), 254 deletions(-)

-- 
2.9.4

