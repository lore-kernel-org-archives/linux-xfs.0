Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:48128 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727337AbeHHTqf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 8 Aug 2018 15:46:35 -0400
Subject: [PATCH v2 1/2] ext4: Close race between direct IO and
 ext4_break_layouts()
From: Dave Jiang <dave.jiang@intel.com>
Date: Wed, 08 Aug 2018 10:25:52 -0700
Message-ID: <153374910694.40645.17166196534680658204.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: tytso@mit.edu, darrick.wong@oracle.com, jack@suse.cz, zwisler@kernel.org
Cc: linux-nvdimm@lists.01.org, david@fromorbit.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, lczerner@redhat.com, linux-ext4@vger.kernel.org, hch@lst.de

From: Ross Zwisler <zwisler@kernel.org>

If the refcount of a page is lowered between the time that it is returned
by dax_busy_page() and when the refcount is again checked in
ext4_break_layouts() => ___wait_var_event(), the waiting function
ext4_wait_dax_page() will never be called.  This means that
ext4_break_layouts() will still have 'retry' set to false, so we'll stop
looping and never check the refcount of other pages in this inode.

Instead, always continue looping as long as dax_layout_busy_page() gives us
a page which it found with an elevated refcount.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---

v2:
- remove verbiage in comment header (Jan)

 fs/ext4/inode.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 8f6ad7667974..d2663a1e3ec2 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4191,9 +4191,8 @@ int ext4_update_disksize_before_punch(struct inode *inode, loff_t offset,
 	return 0;
 }
 
-static void ext4_wait_dax_page(struct ext4_inode_info *ei, bool *did_unlock)
+static void ext4_wait_dax_page(struct ext4_inode_info *ei)
 {
-	*did_unlock = true;
 	up_write(&ei->i_mmap_sem);
 	schedule();
 	down_write(&ei->i_mmap_sem);
@@ -4203,14 +4202,12 @@ int ext4_break_layouts(struct inode *inode)
 {
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	struct page *page;
-	bool retry;
 	int error;
 
 	if (WARN_ON_ONCE(!rwsem_is_locked(&ei->i_mmap_sem)))
 		return -EINVAL;
 
 	do {
-		retry = false;
 		page = dax_layout_busy_page(inode->i_mapping);
 		if (!page)
 			return 0;
@@ -4218,8 +4215,8 @@ int ext4_break_layouts(struct inode *inode)
 		error = ___wait_var_event(&page->_refcount,
 				atomic_read(&page->_refcount) == 1,
 				TASK_INTERRUPTIBLE, 0, 0,
-				ext4_wait_dax_page(ei, &retry));
-	} while (error == 0 && retry);
+				ext4_wait_dax_page(ei));
+	} while (error == 0);
 
 	return error;
 }

