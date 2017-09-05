Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:31464 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753751AbdIEWgT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 5 Sep 2017 18:36:19 -0400
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 4/9] ext4: add ext4_should_use_dax()
Date: Tue,  5 Sep 2017 16:35:36 -0600
Message-Id: <20170905223541.20594-5-ross.zwisler@linux.intel.com>
In-Reply-To: <20170905223541.20594-1-ross.zwisler@linux.intel.com>
References: <20170905223541.20594-1-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org

This helper, in the spirit of ext4_should_dioread_nolock() et al., replaces
the complex conditional in ext4_set_inode_flags() and will soon be called
in multiple places.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/ext4/ext4_jbd2.h | 15 +++++++++++++++
 fs/ext4/inode.c     |  4 +---
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index 48143e3..65e2aa9 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -462,4 +462,19 @@ static inline int ext4_should_dioread_nolock(struct inode *inode)
 	return 1;
 }
 
+static inline bool ext4_should_use_dax(struct inode *inode)
+{
+	if (!test_opt(inode->i_sb, DAX))
+		return false;
+	if (!S_ISREG(inode->i_mode))
+		return false;
+	if (ext4_should_journal_data(inode))
+		return false;
+	if (ext4_has_inline_data(inode))
+		return false;
+	if (ext4_encrypted_inode(inode))
+		return false;
+	return true;
+}
+
 #endif	/* _EXT4_JBD2_H */
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c774bdc..864fb94 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4599,9 +4599,7 @@ void ext4_set_inode_flags(struct inode *inode)
 		new_fl |= S_NOATIME;
 	if (flags & EXT4_DIRSYNC_FL)
 		new_fl |= S_DIRSYNC;
-	if (test_opt(inode->i_sb, DAX) && S_ISREG(inode->i_mode) &&
-	    !ext4_should_journal_data(inode) && !ext4_has_inline_data(inode) &&
-	    !ext4_encrypted_inode(inode))
+	if (ext4_should_use_dax(inode))
 		new_fl |= S_DAX;
 	inode_set_flags(inode, new_fl,
 			S_SYNC|S_APPEND|S_IMMUTABLE|S_NOATIME|S_DIRSYNC|S_DAX);
-- 
2.9.5

