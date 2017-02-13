Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39348 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751623AbdBMRqt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Feb 2017 12:46:49 -0500
Message-ID: <1487008001.3125.41.camel@HansenPartnership.com>
Subject: xfs: fix inode uid/gid initialization
From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Mon, 13 Feb 2017 09:46:41 -0800
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Seth Forshee <seth.forshee@canonical.com>

I was debugging a creation failure using a vfs shifting patch set and
discovered that xfs itself doesn't actually respect the superblock
namespace in a couple of places (these showed up as files with the
wrong ownership in my tests).  The fix is to convert xfs away from hand
rolling inode_init_owner() and to use the i_uid/gid_read/write
functions.

The rule should be that we use the i_uid/gid_read/write() functions
when converting to or from the filesystem id_uid and id_gid view.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

---
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index de32f0f..1b0d97e 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -814,10 +814,10 @@ xfs_ialloc(
 	if (ip->i_d.di_version == 1)
 		ip->i_d.di_version = 2;
 
-	inode->i_mode = mode;
+	inode_init_owner(inode, pip ? VFS_I(pip) : NULL, mode);
 	set_nlink(inode, nlink);
-	ip->i_d.di_uid = xfs_kuid_to_uid(current_fsuid());
-	ip->i_d.di_gid = xfs_kgid_to_gid(current_fsgid());
+	ip->i_d.di_uid = i_uid_read(inode);
+	ip->i_d.di_gid = i_gid_read(inode);
 	xfs_set_projid(ip, prid);
 
 	if (pip && XFS_INHERIT_GID(pip)) {
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 22c1615..306766d 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -643,8 +643,8 @@ xfs_setattr_nonsize(
 		 */
 		ASSERT(udqp == NULL);
 		ASSERT(gdqp == NULL);
-		error = xfs_qm_vop_dqalloc(ip, xfs_kuid_to_uid(uid),
-					   xfs_kgid_to_gid(gid),
+		error = xfs_qm_vop_dqalloc(ip, from_kuid(inode->i_sb->s_user_ns, uid),
+					   from_kgid(inode->i_sb->s_user_ns, gid),
 					   xfs_get_projid(ip),
 					   qflags, &udqp, &gdqp, NULL);
 		if (error)
@@ -714,8 +714,9 @@ xfs_setattr_nonsize(
 				olddquot1 = xfs_qm_vop_chown(tp, ip,
 							&ip->i_udquot, udqp);
 			}
-			ip->i_d.di_uid = xfs_kuid_to_uid(uid);
 			inode->i_uid = uid;
+			ip->i_d.di_uid = i_uid_read(inode);
+
 		}
 		if (!gid_eq(igid, gid)) {
 			if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_GQUOTA_ON(mp)) {
@@ -726,8 +727,8 @@ xfs_setattr_nonsize(
 				olddquot2 = xfs_qm_vop_chown(tp, ip,
 							&ip->i_gdquot, gdqp);
 			}
-			ip->i_d.di_gid = xfs_kgid_to_gid(gid);
 			inode->i_gid = gid;
+			ip->i_d.di_gid = i_gid_read(inode);
 		}
 	}
 
@@ -1213,8 +1214,8 @@ xfs_setup_inode(
 	/* make the inode look hashed for the writeback code */
 	hlist_add_fake(&inode->i_hash);
 
-	inode->i_uid    = xfs_uid_to_kuid(ip->i_d.di_uid);
-	inode->i_gid    = xfs_gid_to_kgid(ip->i_d.di_gid);
+	i_uid_write(inode, ip->i_d.di_uid);
+	i_gid_write(inode, ip->i_d.di_gid);
 
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFBLK:
