Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:31464 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754017AbdIEWgU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 5 Sep 2017 18:36:20 -0400
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 7/9] ext4: prevent data corruption with inline data + DAX
Date: Tue,  5 Sep 2017 16:35:39 -0600
Message-Id: <20170905223541.20594-8-ross.zwisler@linux.intel.com>
In-Reply-To: <20170905223541.20594-1-ross.zwisler@linux.intel.com>
References: <20170905223541.20594-1-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, stable@vger.kernel.org

If an inode has inline data it is currently prevented from using DAX by a
check in ext4_should_use_dax().  When the inode grows inline data via
ext4_create_inline_data() or removes its inline data via
ext4_destroy_inline_data_nolock(), the value of S_DAX can change.

Currently these changes are unsafe because we don't hold off page faults
and I/O, write back dirty radix tree entries and invalidate all mappings.
This work is done in XFS via xfs_ioctl_setattr_dax_invalidate(), for
example.  This unsafe transitioning of S_DAX could potentially lead to data
corruption.

Fix this issue by preventing the DAX mount option from being used on
filesystems that were created to support inline data.  Inline data is an
option given to mkfs.ext4.

We prevent DAX from being used with inline data as opposed to trying to
safely manage the transition of S_DAX because of the locking complexities:

1) filemap_write_and_wait() eventually calls ext4_writepages(), which
acquires the sbi->s_journal_flag_rwsem.  This lock ranks above the
jbdw_handle which is eventually taken by ext4_journal_start().  This
essentially means that the writeback has to happen outside of the context
of an active journal handle (outside of ext4_journal_start() to
ext4_journal_stop().)

2) To lock out page faults we take a write lock on the ei->i_mmap_sem, and
this lock again ranks above the jbd2_handle taken by ext4_journal_start().
So, as with the writeback code in 1) above we have to take ei->i_mmap_sem
outside of the context of an active journal handle.

We are able to work around both of these restrictions and safely transition
S_DAX when we change the journaling mode, but for inline data it's much
harder because each of ext4_create_inline_data() and
ext4_destroy_inline_data_nolock() are passed in journal handles that have
already been started.

To be able to safely writeback and invalidate our dirty inode data we'd
either need to uplevel the locking, writeback and invalidate into all the
callers of those two functions, or we'd need to stop our current journal
handle, do the appropriate locking, writeback and invalidate, unlock and
restart the journal handle.

These both seem too complex, and I don't know if we have a valid use case
where we need to combine a filesystem with inline data and DAX, so just
prevent them from being used together.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
CC: stable@vger.kernel.org
---
 fs/ext4/inline.c | 10 ----------
 fs/ext4/super.c  |  5 +++++
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 28c5c3a..fd95019 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -302,11 +302,6 @@ static int ext4_create_inline_data(handle_t *handle,
 	EXT4_I(inode)->i_inline_size = len + EXT4_MIN_INLINE_DATA_SIZE;
 	ext4_clear_inode_flag(inode, EXT4_INODE_EXTENTS);
 	ext4_set_inode_flag(inode, EXT4_INODE_INLINE_DATA);
-	/*
-	 * Propagate changes to inode->i_flags as well - e.g. S_DAX may
-	 * get cleared
-	 */
-	ext4_set_inode_flags(inode);
 	get_bh(is.iloc.bh);
 	error = ext4_mark_iloc_dirty(handle, inode, &is.iloc);
 
@@ -451,11 +446,6 @@ static int ext4_destroy_inline_data_nolock(handle_t *handle,
 		}
 	}
 	ext4_clear_inode_flag(inode, EXT4_INODE_INLINE_DATA);
-	/*
-	 * Propagate changes to inode->i_flags as well - e.g. S_DAX may
-	 * get set.
-	 */
-	ext4_set_inode_flags(inode);
 
 	get_bh(is.iloc.bh);
 	error = ext4_mark_iloc_dirty(handle, inode, &is.iloc);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index d61a70e2..d549dfb 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3686,6 +3686,11 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	}
 
 	if (sbi->s_mount_opt & EXT4_MOUNT_DAX) {
+		if (ext4_has_feature_inline_data(sb)) {
+			ext4_msg(sb, KERN_ERR, "Cannot use DAX on a filesystem"
+					" that may contain inline data");
+			goto failed_mount;
+		}
 		err = bdev_dax_supported(sb, blocksize);
 		if (err)
 			goto failed_mount;
-- 
2.9.5

