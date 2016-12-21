Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45812 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964903AbcLUREK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Dec 2016 12:04:10 -0500
From: Jeff Layton <jlayton@redhat.com>
Subject: [RFC PATCH v1 23/30] xfs: convert to new i_version API
Date: Wed, 21 Dec 2016 12:03:40 -0500
Message-Id: <1482339827-7882-24-git-send-email-jlayton@redhat.com>
In-Reply-To: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
References: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c | 4 ++--
 fs/xfs/xfs_icache.c           | 4 ++--
 fs/xfs/xfs_inode.c            | 2 +-
 fs/xfs/xfs_inode_item.c       | 2 +-
 fs/xfs/xfs_trans_inode.c      | 2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index dd483e2767f7..a45e9ae5a17e 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -263,7 +263,7 @@ xfs_inode_from_disk(
 	to->di_flags	= be16_to_cpu(from->di_flags);
 
 	if (to->di_version == 3) {
-		inode->i_version = be64_to_cpu(from->di_changecount);
+		inode_set_iversion_read(inode, be64_to_cpu(from->di_changecount));
 		to->di_crtime.t_sec = be32_to_cpu(from->di_crtime.t_sec);
 		to->di_crtime.t_nsec = be32_to_cpu(from->di_crtime.t_nsec);
 		to->di_flags2 = be64_to_cpu(from->di_flags2);
@@ -313,7 +313,7 @@ xfs_inode_to_disk(
 	to->di_flags = cpu_to_be16(from->di_flags);
 
 	if (from->di_version == 3) {
-		to->di_changecount = cpu_to_be64(inode->i_version);
+		to->di_changecount = cpu_to_be64(inode_get_iversion_raw(inode));
 		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.t_sec);
 		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.t_nsec);
 		to->di_flags2 = cpu_to_be64(from->di_flags2);
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index ff4d6311c7f4..f5be7fef8f59 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -278,14 +278,14 @@ xfs_reinit_inode(
 	int		error;
 	uint32_t	nlink = inode->i_nlink;
 	uint32_t	generation = inode->i_generation;
-	uint64_t	version = inode->i_version;
+	uint64_t	version = inode_get_iversion_raw(inode);
 	umode_t		mode = inode->i_mode;
 
 	error = inode_init_always(mp->m_super, inode);
 
 	set_nlink(inode, nlink);
 	inode->i_generation = generation;
-	inode->i_version = version;
+	inode_set_iversion_read(inode, version);
 	inode->i_mode = mode;
 	return error;
 }
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index b9557795eb74..dad9c6476d6f 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -851,7 +851,7 @@ xfs_ialloc(
 	ip->i_d.di_flags = 0;
 
 	if (ip->i_d.di_version == 3) {
-		inode->i_version = 1;
+		inode_set_iversion(inode, 1);
 		ip->i_d.di_flags2 = 0;
 		ip->i_d.di_cowextsize = 0;
 		ip->i_d.di_crtime.t_sec = (__int32_t)tv.tv_sec;
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index d90e7811ccdd..838a045cf9e5 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -364,7 +364,7 @@ xfs_inode_to_log_dinode(
 	to->di_flags = from->di_flags;
 
 	if (from->di_version == 3) {
-		to->di_changecount = inode->i_version;
+		to->di_changecount = inode_get_iversion_raw(inode);
 		to->di_crtime.t_sec = from->di_crtime.t_sec;
 		to->di_crtime.t_nsec = from->di_crtime.t_nsec;
 		to->di_flags2 = from->di_flags2;
diff --git a/fs/xfs/xfs_trans_inode.c b/fs/xfs/xfs_trans_inode.c
index dab8daa676f9..844c08886170 100644
--- a/fs/xfs/xfs_trans_inode.c
+++ b/fs/xfs/xfs_trans_inode.c
@@ -117,7 +117,7 @@ xfs_trans_log_inode(
 	 */
 	if (!(ip->i_itemp->ili_item.li_desc->lid_flags & XFS_LID_DIRTY) &&
 	    IS_I_VERSION(VFS_I(ip))) {
-		VFS_I(ip)->i_version++;
+		inode_inc_iversion_locked(VFS_I(ip));
 		flags |= XFS_ILOG_CORE;
 	}
 
-- 
2.7.4

