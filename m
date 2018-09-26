Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:48506 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727151AbeIZQ3l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Sep 2018 12:29:41 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w8QAE7O6079729
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:17:26 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2mndpphg63-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:17:25 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w8QAHJew031071
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:17:20 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w8QAHJI1014088
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:17:19 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v9 05/28] xfs: Hold inode locks in xfs_ialloc
Date: Wed, 26 Sep 2018 03:14:44 -0700
Message-Id: <1537956907-10244-6-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1537956907-10244-1-git-send-email-allison.henderson@oracle.com>
References: <1537956907-10244-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Modify xfs_ialloc to hold locks after return.  Caller
will be responsible for manual unlock.  We will need
this later to hold locks across parent pointer operations

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_inode.c   | 6 +++++-
 fs/xfs/xfs_qm.c      | 1 +
 fs/xfs/xfs_symlink.c | 3 +++
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index d957a46..1ef9d03 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -744,6 +744,8 @@ xfs_lookup(
  * to attach to or associate with (i.e. pip == NULL) because they
  * are not linked into the directory structure - they are attached
  * directly to the superblock - and so have no parent.
+ *
+ * Caller is responsible for unlocking the inode manually upon return
  */
 static int
 xfs_ialloc(
@@ -942,7 +944,7 @@ xfs_ialloc(
 	/*
 	 * Log the new values stuffed into the inode.
 	 */
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
 	xfs_trans_log_inode(tp, ip, flags);
 
 	/* now that we have an i_mode we can setup the inode structure */
@@ -1264,6 +1266,7 @@ xfs_create(
 	xfs_qm_dqrele(pdqp);
 
 	*ipp = ip;
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return 0;
 
  out_trans_cancel:
@@ -1359,6 +1362,7 @@ xfs_create_tmpfile(
 	xfs_qm_dqrele(pdqp);
 
 	*ipp = ip;
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return 0;
 
  out_trans_cancel:
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 52ed790..69006e5 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -820,6 +820,7 @@ xfs_qm_qino_alloc(
 	}
 	if (need_alloc)
 		xfs_finish_inode_setup(*ip);
+	xfs_iunlock(*ip, XFS_ILOCK_EXCL);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index a3e98c6..07b1036 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -352,6 +352,7 @@ xfs_symlink(
 	xfs_qm_dqrele(pdqp);
 
 	*ipp = ip;
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return 0;
 
 out_trans_cancel:
@@ -373,6 +374,8 @@ xfs_symlink(
 
 	if (unlock_dp_on_error)
 		xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	if (ip)
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 }
 
-- 
2.7.4
