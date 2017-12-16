Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757038AbdLPNre (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 16 Dec 2017 08:47:34 -0500
From: Jeff Layton <jlayton@kernel.org>
Subject: [PATCH v2 14/19] xfs: convert to new i_version API
Date: Sat, 16 Dec 2017 08:46:51 -0500
Message-Id: <20171216134656.15561-15-jlayton@kernel.org>
In-Reply-To: <20171216134656.15561-1-jlayton@kernel.org>
References: <20171216134656.15561-1-jlayton@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-nfs@vger.kernel.org, bfields@fieldses.org, neilb@suse.de, jack@suse.de, linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-integrity@vger.kernel.org, zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com, linux-afs@lists.infradead.org, dhowells@redhat.com

From: Jeff Layton <jlayton@redhat.com>

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c | 5 +++--
 fs/xfs/xfs_icache.c           | 4 ++--
 fs/xfs/xfs_inode.c            | 2 +-
 fs/xfs/xfs_inode_item.c       | 2 +-
 fs/xfs/xfs_trans_inode.c      | 2 +-
 5 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 6b7989038d75..207db10d78d5 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -264,7 +264,8 @@ xfs_inode_from_disk(
 	to->di_flags	= be16_to_cpu(from->di_flags);
 
 	if (to->di_version == 3) {
-		inode->i_version = be64_to_cpu(from->di_changecount);
+		inode_set_iversion_queried(inode,
+					   be64_to_cpu(from->di_changecount));
 		to->di_crtime.t_sec = be32_to_cpu(from->di_crtime.t_sec);
 		to->di_crtime.t_nsec = be32_to_cpu(from->di_crtime.t_nsec);
 		to->di_flags2 = be64_to_cpu(from->di_flags2);
@@ -314,7 +315,7 @@ xfs_inode_to_disk(
 	to->di_flags = cpu_to_be16(from->di_flags);
 
 	if (from->di_version == 3) {
-		to->di_changecount = cpu_to_be64(inode->i_version);
+		to->di_changecount = cpu_to_be64(inode_peek_iversion(inode));
 		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.t_sec);
 		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.t_nsec);
 		to->di_flags2 = cpu_to_be64(from->di_flags2);
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 43005fbe8b1e..11ac85a75dc2 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -293,14 +293,14 @@ xfs_reinit_inode(
 	int		error;
 	uint32_t	nlink = inode->i_nlink;
 	uint32_t	generation = inode->i_generation;
-	uint64_t	version = inode->i_version;
+	uint64_t	version = inode_peek_iversion(inode);
 	umode_t		mode = inode->i_mode;
 
 	error = inode_init_always(mp->m_super, inode);
 
 	set_nlink(inode, nlink);
 	inode->i_generation = generation;
-	inode->i_version = version;
+	inode_set_iversion_queried(inode, version);
 	inode->i_mode = mode;
 	return error;
 }
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 801274126648..be6d87980dd5 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -833,7 +833,7 @@ xfs_ialloc(
 	ip->i_d.di_flags = 0;
 
 	if (ip->i_d.di_version == 3) {
-		inode->i_version = 1;
+		inode_set_iversion(inode, 1);
 		ip->i_d.di_flags2 = 0;
 		ip->i_d.di_cowextsize = 0;
 		ip->i_d.di_crtime.t_sec = (int32_t)tv.tv_sec;
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 6ee5c3bf19ad..2ca02e7b3966 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -354,7 +354,7 @@ xfs_inode_to_log_dinode(
 	to->di_next_unlinked = NULLAGINO;
 
 	if (from->di_version == 3) {
-		to->di_changecount = inode->i_version;
+		to->di_changecount = inode_peek_iversion(inode);
 		to->di_crtime.t_sec = from->di_crtime.t_sec;
 		to->di_crtime.t_nsec = from->di_crtime.t_nsec;
 		to->di_flags2 = from->di_flags2;
diff --git a/fs/xfs/xfs_trans_inode.c b/fs/xfs/xfs_trans_inode.c
index daa7615497f9..b41a92d18140 100644
--- a/fs/xfs/xfs_trans_inode.c
+++ b/fs/xfs/xfs_trans_inode.c
@@ -117,7 +117,7 @@ xfs_trans_log_inode(
 	 */
 	if (!(ip->i_itemp->ili_item.li_desc->lid_flags & XFS_LID_DIRTY) &&
 	    IS_I_VERSION(VFS_I(ip))) {
-		VFS_I(ip)->i_version++;
+		inode_inc_iversion(VFS_I(ip));
 		flags |= XFS_ILOG_CORE;
 	}
 
-- 
2.14.3

