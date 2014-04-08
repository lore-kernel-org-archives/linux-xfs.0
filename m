Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D881F8094
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 12:25:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C4AA58F8052
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 10:25:19 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 32YIFpWyMmwoGZA4 for
	<xfs@oss.sgi.com>; Tue, 08 Apr 2014 10:25:18 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s38HPGSE031267
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 8 Apr 2014 13:25:17 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s38HPGnf004097
	for <xfs@oss.sgi.com>; Tue, 8 Apr 2014 13:25:16 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: fix tmpfile/selinux deadlock and initialize security
Date: Tue,  8 Apr 2014 13:25:15 -0400
Message-Id: <1396977915-35768-1-git-send-email-bfoster@redhat.com>
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

xfs_vn_tmpfile() also fails to initialize security on the newly created
inode.

Pull the d_tmpfile() call up into xfs_vn_tmpfile() after the transaction
has been committed and the inode unlocked. Also, initialize security on
the inode based on the parent directory provided via the tmpfile call.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Hi all,

I thought this looked safe given that d_tmpfile() looks generally like a
d_instantiate() call with some extra magic for handling the tmpfile, but
I could be missing something wrt to locking. ext4 looks like it defers
the unlock_new_inode() call until after d_tmpfile() but I'm not quite
sure why that is. We call it from xfs_setup_inode() further down in the
inode allocation path.

This has only seen some targeted testing so far. generic/004 passes with
selinux enabled and I've verified (via xfs_repair) that the inode is
pulled off the unlinked list if the security initialization fails.

Brian

 fs/xfs/xfs_inode.c |  5 +++--
 fs/xfs/xfs_inode.h |  2 +-
 fs/xfs/xfs_iops.c  | 20 +++++++++++++++++---
 3 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 5e7a38f..768087b 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1334,7 +1334,8 @@ int
 xfs_create_tmpfile(
 	struct xfs_inode	*dp,
 	struct dentry		*dentry,
-	umode_t			mode)
+	umode_t			mode,
+	struct xfs_inode	**ipp)
 {
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_inode	*ip = NULL;
@@ -1402,7 +1403,6 @@ xfs_create_tmpfile(
 	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp, pdqp);
 
 	ip->i_d.di_nlink--;
-	d_tmpfile(dentry, VFS_I(ip));
 	error = xfs_iunlink(tp, ip);
 	if (error)
 		goto out_trans_abort;
@@ -1415,6 +1415,7 @@ xfs_create_tmpfile(
 	xfs_qm_dqrele(gdqp);
 	xfs_qm_dqrele(pdqp);
 
+	*ipp = ip;
 	return 0;
 
  out_trans_abort:
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 396cc1f..f2fcde5 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -334,7 +334,7 @@ int		xfs_lookup(struct xfs_inode *dp, struct xfs_name *name,
 int		xfs_create(struct xfs_inode *dp, struct xfs_name *name,
 			   umode_t mode, xfs_dev_t rdev, struct xfs_inode **ipp);
 int		xfs_create_tmpfile(struct xfs_inode *dp, struct dentry *dentry,
-			   umode_t mode);
+			   umode_t mode, struct xfs_inode **ipp);
 int		xfs_remove(struct xfs_inode *dp, struct xfs_name *name,
 			   struct xfs_inode *ip);
 int		xfs_link(struct xfs_inode *tdp, struct xfs_inode *sip,
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 89b07e4..ef1ca01 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1053,11 +1053,25 @@ xfs_vn_tmpfile(
 	struct dentry	*dentry,
 	umode_t		mode)
 {
-	int		error;
+	int			error;
+	struct xfs_inode	*ip;
+	struct inode		*inode;
 
-	error = xfs_create_tmpfile(XFS_I(dir), dentry, mode);
+	error = xfs_create_tmpfile(XFS_I(dir), dentry, mode, &ip);
+	if (unlikely(error))
+		return -error;
 
-	return -error;
+	inode = VFS_I(ip);
+
+	error = xfs_init_security(inode, dir, &dentry->d_name);
+	if (unlikely(error)) {
+		iput(inode);
+		return -error;
+	}
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
