Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:10338 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754400AbdAJVwh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 10 Jan 2017 16:52:37 -0500
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v4 0/7] DAX tracepoints, mm argument simplification
Date: Tue, 10 Jan 2017 14:52:15 -0700
Message-Id: <1484085142-2297-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Theodore Ts'o <tytso@mit.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger.kernel@dilger.ca>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Ingo Molnar <mingo@redhat.com>, Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, Steven Rostedt <rostedt@goodmis.org>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org

Andrew,

This contains both my DAX tracepoint code and Dave Jiang's MM argument
simplifications.  Dave's code was written with my tracepoint code as a
baseline, so it seemed simplest to keep them together in a single series.

This series is based on the v4.10-rc3-mmots-2017-01-09-17-08 snapshot.  A
working tree can be found here:

https://git.kernel.org/cgit/linux/kernel/git/zwisler/linux.git/log/?h=mmots_dax_tracepoint

Changes from the previous versions of these patches:
 - Combined Dave's code and mine into a single series.
 - Resolved some minor merge conflics in Dave's patches so they could be
   applied to the latest mmots snapshot.
 - Added Reviewed-by and Acked-by tags to patches as appropriate.

My goal for this series is to get it merged for v4.11.

Thanks,
- Ross

Dave Jiang (2):
  mm, dax: make pmd_fault() and friends to be the same as fault()
  mm, dax: move pmd_fault() to take only vmf parameter

Ross Zwisler (5):
  tracing: add __print_flags_u64()
  dax: add tracepoint infrastructure, PMD tracing
  dax: update MAINTAINERS entries for FS DAX
  dax: add tracepoints to dax_pmd_load_hole()
  dax: add tracepoints to dax_pmd_insert_mapping()

 MAINTAINERS                   |   5 +-
 drivers/dax/dax.c             |  26 ++++---
 fs/dax.c                      | 114 ++++++++++++++++--------------
 fs/ext4/file.c                |  13 ++--
 fs/xfs/xfs_file.c             |  15 ++--
 include/linux/dax.h           |   6 +-
 include/linux/mm.h            |  28 +++++++-
 include/linux/pfn_t.h         |   6 ++
 include/linux/trace_events.h  |   4 ++
 include/trace/events/fs_dax.h | 156 ++++++++++++++++++++++++++++++++++++++++++
 include/trace/trace_events.h  |  11 +++
 kernel/trace/trace_output.c   |  38 ++++++++++
 mm/memory.c                   |  11 ++-
 13 files changed, 338 insertions(+), 95 deletions(-)
 create mode 100644 include/trace/events/fs_dax.h

-- 
2.7.4

