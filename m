Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57824 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751017AbeBUC1V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Feb 2018 21:27:21 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w1L2Nkja001754
        for <linux-xfs@vger.kernel.org>; Tue, 20 Feb 2018 21:27:20 -0500
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2g8y2p1tmr-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Tue, 20 Feb 2018 21:27:20 -0500
Received: from localhost
        by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Tue, 20 Feb 2018 19:27:19 -0700
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH V2 1/2] xfs: Remove "committed" argument of xfs_dir_ialloc
Date: Wed, 21 Feb 2018 07:58:25 +0530
Message-Id: <20180221022826.7020-1-chandan@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, hch@infradead.org, darrick.wong@oracle.com, bfoster@redhat.com

xfs_dir_ialloc() rolls the current transaction when allocation of a new
inode required the space manager to perform an allocation and replinish
the Inode btree.

None of the callers of xfs_dir_ialloc() need to know if the
transaction was committed. Hence this commit removes the "committed"
argument of xfs_dir_ialloc.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
Changelog:
v1 -> v2:
1. Add a patch to remove the "commited" argument of xfs_dir_ialloc.
   Hence the second patch now has xfs_dir_ialloc() invoking
   xfs_trans_roll() by passing NULL as the second argument.
   
 fs/xfs/xfs_inode.c   | 14 +++-----------
 fs/xfs/xfs_inode.h   |  2 +-
 fs/xfs/xfs_qm.c      |  4 +---
 fs/xfs/xfs_symlink.c |  2 +-
 4 files changed, 6 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 604ee38..37d9426 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -972,10 +972,8 @@ xfs_dir_ialloc(
 	xfs_nlink_t	nlink,
 	dev_t		rdev,
 	prid_t		prid,		/* project id */
-	xfs_inode_t	**ipp,		/* pointer to inode; it will be
+	xfs_inode_t	**ipp)		/* pointer to inode; it will be
 					   locked. */
-	int		*committed)
-
 {
 	xfs_trans_t	*tp;
 	xfs_inode_t	*ip;
@@ -1050,8 +1048,6 @@ xfs_dir_ialloc(
 		}
 
 		code = xfs_trans_roll(&tp);
-		if (committed != NULL)
-			*committed = 1;
 
 		/*
 		 * Re-attach the quota info that we detached from prev trx.
@@ -1088,9 +1084,6 @@ xfs_dir_ialloc(
 		}
 		ASSERT(!ialloc_context && ip);
 
-	} else {
-		if (committed != NULL)
-			*committed = 0;
 	}
 
 	*ipp = ip;
@@ -1217,8 +1210,7 @@ xfs_create(
 	 * entry pointing to them, but a directory also the "." entry
 	 * pointing to itself.
 	 */
-	error = xfs_dir_ialloc(&tp, dp, mode, is_dir ? 2 : 1, rdev, prid, &ip,
-			NULL);
+	error = xfs_dir_ialloc(&tp, dp, mode, is_dir ? 2 : 1, rdev, prid, &ip);
 	if (error)
 		goto out_trans_cancel;
 
@@ -1351,7 +1343,7 @@ xfs_create_tmpfile(
 	if (error)
 		goto out_trans_cancel;
 
-	error = xfs_dir_ialloc(&tp, dp, mode, 1, 0, prid, &ip, NULL);
+	error = xfs_dir_ialloc(&tp, dp, mode, 1, 0, prid, &ip);
 	if (error)
 		goto out_trans_cancel;
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 3e8dc99..50a2a84 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -431,7 +431,7 @@ xfs_extlen_t	xfs_get_cowextsz_hint(struct xfs_inode *ip);
 
 int		xfs_dir_ialloc(struct xfs_trans **, struct xfs_inode *, umode_t,
 			       xfs_nlink_t, dev_t, prid_t,
-			       struct xfs_inode **, int *);
+			       struct xfs_inode **);
 
 /* from xfs_file.c */
 enum xfs_prealloc_flags {
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 5b848f4..ec39ae2 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -748,7 +748,6 @@ xfs_qm_qino_alloc(
 {
 	xfs_trans_t	*tp;
 	int		error;
-	int		committed;
 	bool		need_alloc = true;
 
 	*ip = NULL;
@@ -788,8 +787,7 @@ xfs_qm_qino_alloc(
 		return error;
 
 	if (need_alloc) {
-		error = xfs_dir_ialloc(&tp, NULL, S_IFREG, 1, 0, 0, ip,
-				&committed);
+		error = xfs_dir_ialloc(&tp, NULL, S_IFREG, 1, 0, 0, ip);
 		if (error) {
 			xfs_trans_cancel(tp);
 			return error;
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 2e9e793..5b66ac1 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -264,7 +264,7 @@ xfs_symlink(
 	 * Allocate an inode for the symlink.
 	 */
 	error = xfs_dir_ialloc(&tp, dp, S_IFLNK | (mode & ~S_IFMT), 1, 0,
-			       prid, &ip, NULL);
+			       prid, &ip);
 	if (error)
 		goto out_trans_cancel;
 
-- 
2.9.5

