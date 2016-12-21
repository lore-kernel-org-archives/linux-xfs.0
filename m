Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45734 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935782AbcLURD6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Dec 2016 12:03:58 -0500
From: Jeff Layton <jlayton@redhat.com>
Subject: [RFC PATCH v1 10/30] ntfs: remove i_version handling
Date: Wed, 21 Dec 2016 12:03:27 -0500
Message-Id: <1482339827-7882-11-git-send-email-jlayton@redhat.com>
In-Reply-To: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
References: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

Nothing uses this, and the i_version is never incremented on ntfs.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/ntfs/inode.c | 9 ---------
 fs/ntfs/mft.c   | 6 ------
 2 files changed, 15 deletions(-)

diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index 7c410f879412..1c1ee489284b 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -560,13 +560,6 @@ static int ntfs_read_locked_inode(struct inode *vi)
 	ntfs_debug("Entering for i_ino 0x%lx.", vi->i_ino);
 
 	/* Setup the generic vfs inode parts now. */
-
-	/*
-	 * This is for checking whether an inode has changed w.r.t. a file so
-	 * that the file can be updated if necessary (compare with f_version).
-	 */
-	vi->i_version = 1;
-
 	vi->i_uid = vol->uid;
 	vi->i_gid = vol->gid;
 	vi->i_mode = 0;
@@ -1240,7 +1233,6 @@ static int ntfs_read_locked_attr_inode(struct inode *base_vi, struct inode *vi)
 	base_ni = NTFS_I(base_vi);
 
 	/* Just mirror the values from the base inode. */
-	vi->i_version	= base_vi->i_version;
 	vi->i_uid	= base_vi->i_uid;
 	vi->i_gid	= base_vi->i_gid;
 	set_nlink(vi, base_vi->i_nlink);
@@ -1507,7 +1499,6 @@ static int ntfs_read_locked_index_inode(struct inode *base_vi, struct inode *vi)
 	ni	= NTFS_I(vi);
 	base_ni = NTFS_I(base_vi);
 	/* Just mirror the values from the base inode. */
-	vi->i_version	= base_vi->i_version;
 	vi->i_uid	= base_vi->i_uid;
 	vi->i_gid	= base_vi->i_gid;
 	set_nlink(vi, base_vi->i_nlink);
diff --git a/fs/ntfs/mft.c b/fs/ntfs/mft.c
index b6f402194f02..165133321577 100644
--- a/fs/ntfs/mft.c
+++ b/fs/ntfs/mft.c
@@ -2641,12 +2641,6 @@ ntfs_inode *ntfs_mft_record_alloc(ntfs_volume *vol, const int mode,
 			goto undo_mftbmp_alloc;
 		}
 		vi->i_ino = bit;
-		/*
-		 * This is for checking whether an inode has changed w.r.t. a
-		 * file so that the file can be updated if necessary (compare
-		 * with f_version).
-		 */
-		vi->i_version = 1;
 
 		/* The owner and group come from the ntfs volume. */
 		vi->i_uid = vol->uid;
-- 
2.7.4

