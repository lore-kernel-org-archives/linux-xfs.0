Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7B7037F4E
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 11:18:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4FAD6304075
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 09:18:30 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 0A4tstd8pS2p22FL for
	<xfs@oss.sgi.com>; Tue, 15 Apr 2014 09:18:29 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s3FGISix031910
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 12:18:28 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s3FGIS94024201
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 12:18:28 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 1/4] xfs: fix tmpfile/selinux ilock deadlock
Date: Tue, 15 Apr 2014 12:18:23 -0400
Message-Id: <1397578706-5385-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1397578706-5385-1-git-send-email-bfoster@redhat.com>
References: <1397578706-5385-1-git-send-email-bfoster@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

xfstests generic/004 reproduces an ilock deadlock using the tmpfile
interface when selinux is enabled. This occurs because
xfs_create_tmpfile() takes the ilock and then calls d_tmpfile(). The
latter eventually calls into xfs_xattr_get() which attempts to get the
lock again. E.g.:

xfs_io          D ffffffff81c134c0  4096  3561   3560 0x00000080
ffff8801176a1a68 0000000000000046 ffff8800b401b540 ffff8801176a1fd8
00000000001d5800 00000000001d5800 ffff8800b401b540 ffff8800b401b540
ffff8800b73a6bd0 fffffffeffffffff ffff8800b73a6bd8 ffff8800b5ddb480
Call Trace:
[<ffffffff8177f969>] schedule+0x29/0x70
[<ffffffff81783a65>] rwsem_down_read_failed+0xc5/0x120
[<ffffffffa05aa97f>] ? xfs_ilock_attr_map_shared+0x1f/0x50 [xfs]
[<ffffffff813b3434>] call_rwsem_down_read_failed+0x14/0x30
[<ffffffff810ed179>] ? down_read_nested+0x89/0xa0
[<ffffffffa05aa7f2>] ? xfs_ilock+0x122/0x250 [xfs]
[<ffffffffa05aa7f2>] xfs_ilock+0x122/0x250 [xfs]
[<ffffffffa05aa97f>] xfs_ilock_attr_map_shared+0x1f/0x50 [xfs]
[<ffffffffa05701d0>] xfs_attr_get+0x90/0xe0 [xfs]
[<ffffffffa0565e07>] xfs_xattr_get+0x37/0x50 [xfs]
[<ffffffff8124842f>] generic_getxattr+0x4f/0x70
[<ffffffff8133fd9e>] inode_doinit_with_dentry+0x1ae/0x650
[<ffffffff81340e0c>] selinux_d_instantiate+0x1c/0x20
[<ffffffff813351bb>] security_d_instantiate+0x1b/0x30
[<ffffffff81237db0>] d_instantiate+0x50/0x70
[<ffffffff81237e85>] d_tmpfile+0xb5/0xc0
[<ffffffffa05add02>] xfs_create_tmpfile+0x362/0x410 [xfs]
[<ffffffffa0559ac8>] xfs_vn_tmpfile+0x18/0x20 [xfs]
[<ffffffff81230388>] path_openat+0x228/0x6a0
[<ffffffff810230f9>] ? sched_clock+0x9/0x10
[<ffffffff8105a427>] ? kvm_clock_read+0x27/0x40
[<ffffffff8124054f>] ? __alloc_fd+0xaf/0x1f0
[<ffffffff8123101a>] do_filp_open+0x3a/0x90
[<ffffffff817845e7>] ? _raw_spin_unlock+0x27/0x40
[<ffffffff8124054f>] ? __alloc_fd+0xaf/0x1f0
[<ffffffff8121e3ce>] do_sys_open+0x12e/0x210
[<ffffffff8121e4ce>] SyS_open+0x1e/0x20
[<ffffffff8178eda9>] system_call_fastpath+0x16/0x1b

Pull the d_tmpfile() call up into xfs_vn_tmpfile() after the transaction
has been committed and the inode unlocked. This pattern is consistent
with other dcache callers (e.g., d_instantiate()) in xfs_iops.c.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_inode.c |  6 +++---
 fs/xfs/xfs_inode.h |  4 ++--
 fs/xfs/xfs_iops.c  | 14 +++++++++++---
 3 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 5e7a38f..0e63c7d 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1333,8 +1333,8 @@ xfs_create(
 int
 xfs_create_tmpfile(
 	struct xfs_inode	*dp,
-	struct dentry		*dentry,
-	umode_t			mode)
+	umode_t			mode,
+	struct xfs_inode	**ipp)
 {
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_inode	*ip = NULL;
@@ -1402,7 +1402,6 @@ xfs_create_tmpfile(
 	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp, pdqp);
 
 	ip->i_d.di_nlink--;
-	d_tmpfile(dentry, VFS_I(ip));
 	error = xfs_iunlink(tp, ip);
 	if (error)
 		goto out_trans_abort;
@@ -1415,6 +1414,7 @@ xfs_create_tmpfile(
 	xfs_qm_dqrele(gdqp);
 	xfs_qm_dqrele(pdqp);
 
+	*ipp = ip;
 	return 0;
 
  out_trans_abort:
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 396cc1f..4a612fd 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -333,8 +333,8 @@ int		xfs_lookup(struct xfs_inode *dp, struct xfs_name *name,
 			   struct xfs_inode **ipp, struct xfs_name *ci_name);
 int		xfs_create(struct xfs_inode *dp, struct xfs_name *name,
 			   umode_t mode, xfs_dev_t rdev, struct xfs_inode **ipp);
-int		xfs_create_tmpfile(struct xfs_inode *dp, struct dentry *dentry,
-			   umode_t mode);
+int		xfs_create_tmpfile(struct xfs_inode *dp, umode_t mode,
+				   struct xfs_inode **ipp);
 int		xfs_remove(struct xfs_inode *dp, struct xfs_name *name,
 			   struct xfs_inode *ip);
 int		xfs_link(struct xfs_inode *tdp, struct xfs_inode *sip,
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 89b07e4..8fdbc38 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1053,11 +1053,19 @@ xfs_vn_tmpfile(
 	struct dentry	*dentry,
 	umode_t		mode)
 {
-	int		error;
+	int			error;
+	struct xfs_inode	*ip;
+	struct inode		*inode;
 
-	error = xfs_create_tmpfile(XFS_I(dir), dentry, mode);
+	error = xfs_create_tmpfile(XFS_I(dir), mode, &ip);
+	if (unlikely(error))
+		return -error;
 
-	return -error;
+	inode = VFS_I(ip);
+
+	d_tmpfile(dentry, inode);
+
+	return 0;
 }
 
 static const struct inode_operations xfs_inode_operations = {
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
