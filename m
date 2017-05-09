Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38786 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755038AbdEIPu0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 May 2017 11:50:26 -0400
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH v4 16/27] fs: adapt sync_file_range to new reporting infrastructure
Date: Tue,  9 May 2017 11:49:19 -0400
Message-Id: <20170509154930.29524-17-jlayton@redhat.com>
In-Reply-To: <20170509154930.29524-1-jlayton@redhat.com>
References: <20170509154930.29524-1-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, linux-mm@kvack.org, jfs-discussion@lists.sourceforge.net, linux-xfs@vger.kernel.org, cluster-devel@redhat.com, linux-f2fs-devel@lists.sourceforge.net, v9fs-developer@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-block@vger.kernel.org
Cc: dhowells@redhat.com, akpm@linux-foundation.org, hch@infradead.org, ross.zwisler@linux.intel.com, mawilcox@microsoft.com, jack@suse.com, viro@zeniv.linux.org.uk, corbet@lwn.net, neilb@suse.de, clm@fb.com, tytso@mit.edu, axboe@kernel.dk, josef@toxicpanda.com, hubcap@omnibond.com, rpeterso@redhat.com, bo.li.liu@oracle.com

Since it returns errors in a way similar to fsync, have it use the same
method for returning previously-reported writeback errors.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/sync.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/sync.c b/fs/sync.c
index 11ba023434b1..89a03b5252d2 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -271,8 +271,11 @@ SYSCALL_DEFINE1(fdatasync, unsigned int, fd)
  *
  *
  * SYNC_FILE_RANGE_WAIT_BEFORE and SYNC_FILE_RANGE_WAIT_AFTER will detect any
- * I/O errors or ENOSPC conditions and will return those to the caller, after
- * clearing the EIO and ENOSPC flags in the address_space.
+ * error condition that occurred prior to or after writeback, and will return
+ * that to the caller, while advancing the file's errseq_t cursor. Note that
+ * any errors returned here may have occurred in an area of the file that is
+ * not covered by the given range as most filesystems track writeback errors
+ * on a per-address_space basis
  *
  * It should be noted that none of these operations write out the file's
  * metadata.  So unless the application is strictly performing overwrites of
@@ -282,7 +285,7 @@ SYSCALL_DEFINE1(fdatasync, unsigned int, fd)
 SYSCALL_DEFINE4(sync_file_range, int, fd, loff_t, offset, loff_t, nbytes,
 				unsigned int, flags)
 {
-	int ret;
+	int ret, ret2;
 	struct fd f;
 	struct address_space *mapping;
 	loff_t endbyte;			/* inclusive */
@@ -356,7 +359,9 @@ SYSCALL_DEFINE4(sync_file_range, int, fd, loff_t, offset, loff_t, nbytes,
 
 	if (flags & SYNC_FILE_RANGE_WAIT_AFTER)
 		ret = filemap_fdatawait_range(mapping, offset, endbyte);
-
+	ret2 = filemap_report_wb_error(f.file);
+	if (!ret)
+		ret = ret2;
 out_put:
 	fdput(f);
 out:
-- 
2.9.3

