Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:63245 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753802AbdIEWgT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 5 Sep 2017 18:36:19 -0400
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 5/9] ext4: ext4_change_inode_journal_flag error handling
Date: Tue,  5 Sep 2017 16:35:37 -0600
Message-Id: <20170905223541.20594-6-ross.zwisler@linux.intel.com>
In-Reply-To: <20170905223541.20594-1-ross.zwisler@linux.intel.com>
References: <20170905223541.20594-1-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, stable@vger.kernel.org

Rework the error handling in ext4_change_inode_journal_flag() so that
multiple paths can re-use portions of the same cleanup code via gotos
instead of each path doing their own cleanup.  This will benefit later
patches that add more paths to this function that must be unwound on error.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
CC: stable@vger.kernel.org
---
 fs/ext4/inode.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 864fb94..d218991 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5953,11 +5953,8 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 	if (val) {
 		down_write(&EXT4_I(inode)->i_mmap_sem);
 		err = filemap_write_and_wait(inode->i_mapping);
-		if (err < 0) {
-			up_write(&EXT4_I(inode)->i_mmap_sem);
-			ext4_inode_resume_unlocked_dio(inode);
-			return err;
-		}
+		if (err < 0)
+			goto out_unlock;
 	}
 
 	percpu_down_write(&sbi->s_journal_flag_rwsem);
@@ -5975,12 +5972,8 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 		ext4_set_inode_flag(inode, EXT4_INODE_JOURNAL_DATA);
 	else {
 		err = jbd2_journal_flush(journal);
-		if (err < 0) {
-			jbd2_journal_unlock_updates(journal);
-			percpu_up_write(&sbi->s_journal_flag_rwsem);
-			ext4_inode_resume_unlocked_dio(inode);
-			return err;
-		}
+		if (err < 0)
+			goto out_journal_unlock;
 		ext4_clear_inode_flag(inode, EXT4_INODE_JOURNAL_DATA);
 	}
 	ext4_set_aops(inode);
@@ -6009,6 +6002,15 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 	ext4_std_error(inode->i_sb, err);
 
 	return err;
+
+out_journal_unlock:
+	jbd2_journal_unlock_updates(journal);
+	percpu_up_write(&sbi->s_journal_flag_rwsem);
+out_unlock:
+	if (val)
+		up_write(&EXT4_I(inode)->i_mmap_sem);
+	ext4_inode_resume_unlocked_dio(inode);
+	return err;
 }
 
 static int ext4_bh_unmapped(handle_t *handle, struct buffer_head *bh)
-- 
2.9.5

