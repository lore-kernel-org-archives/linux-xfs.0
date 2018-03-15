Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:12040 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932898AbeCOQA4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Mar 2018 12:00:56 -0400
Subject: [PATCH v6 05/15] ext4, dax: introduce ext4_dax_aops
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 15 Mar 2018 08:51:50 -0700
Message-ID: <152112911073.24669.9909626935784919021.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152112908134.24669.10222746224538377035.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <152112908134.24669.10222746224538377035.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-nvdimm@lists.01.org
Cc: Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, david@fromorbit.com, hch@lst.de, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.orgjack@suse.cz, ross.zwisler@linux.intel.comhch@lst.de, linux-kernel@vger.kernel.org

In preparation for the dax implementation to start associating dax pages
to inodes via page->mapping, we need to provide a 'struct
address_space_operations' instance for dax. Otherwise, direct-I/O
triggers incorrect page cache assumptions and warnings.

Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/ext4/inode.c |   38 +++++++++++++++++++++++++++++++-------
 1 file changed, 31 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c94780075b04..f9884e41cb39 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2725,12 +2725,6 @@ static int ext4_writepages(struct address_space *mapping,
 	percpu_down_read(&sbi->s_journal_flag_rwsem);
 	trace_ext4_writepages(inode, wbc);
 
-	if (dax_mapping(mapping)) {
-		ret = dax_writeback_mapping_range(mapping, inode->i_sb->s_bdev,
-						  wbc);
-		goto out_writepages;
-	}
-
 	/*
 	 * No pages to write? This is mainly a kludge to avoid starting
 	 * a transaction for special inodes like journal inode on last iput()
@@ -2955,6 +2949,27 @@ static int ext4_writepages(struct address_space *mapping,
 	return ret;
 }
 
+static int ext4_dax_writepages(struct address_space *mapping,
+			       struct writeback_control *wbc)
+{
+	int ret;
+	long nr_to_write = wbc->nr_to_write;
+	struct inode *inode = mapping->host;
+	struct ext4_sb_info *sbi = EXT4_SB(mapping->host->i_sb);
+
+	if (unlikely(ext4_forced_shutdown(EXT4_SB(inode->i_sb))))
+		return -EIO;
+
+	percpu_down_read(&sbi->s_journal_flag_rwsem);
+	trace_ext4_writepages(inode, wbc);
+
+	ret = dax_writeback_mapping_range(mapping, inode->i_sb->s_bdev, wbc);
+	trace_ext4_writepages_result(inode, wbc, ret,
+				     nr_to_write - wbc->nr_to_write);
+	percpu_up_read(&sbi->s_journal_flag_rwsem);
+	return ret;
+}
+
 static int ext4_nonda_switch(struct super_block *sb)
 {
 	s64 free_clusters, dirty_clusters;
@@ -3946,6 +3961,13 @@ static const struct address_space_operations ext4_da_aops = {
 	.error_remove_page	= generic_error_remove_page,
 };
 
+static const struct address_space_operations ext4_dax_aops = {
+	.direct_IO		= ext4_direct_IO,
+	.writepages		= ext4_dax_writepages,
+	.set_page_dirty		= noop_set_page_dirty,
+	.invalidatepage		= noop_invalidatepage,
+};
+
 void ext4_set_aops(struct inode *inode)
 {
 	switch (ext4_inode_journal_mode(inode)) {
@@ -3958,7 +3980,9 @@ void ext4_set_aops(struct inode *inode)
 	default:
 		BUG();
 	}
-	if (test_opt(inode->i_sb, DELALLOC))
+	if (IS_DAX(inode))
+		inode->i_mapping->a_ops = &ext4_dax_aops;
+	else if (test_opt(inode->i_sb, DELALLOC))
 		inode->i_mapping->a_ops = &ext4_da_aops;
 	else
 		inode->i_mapping->a_ops = &ext4_aops;

