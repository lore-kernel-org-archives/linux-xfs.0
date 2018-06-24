Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:43626 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752063AbeFXTXp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 Jun 2018 15:23:45 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5OJDx2G182745
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jun 2018 19:23:44 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2jt7narhf4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jun 2018 19:23:44 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w5OJNh3N019226
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jun 2018 19:23:44 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w5OJNhPq020352
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jun 2018 19:23:43 GMT
Subject: [PATCH 02/21] xfs: add helper to decide if an inode has allocated
 cow blocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 24 Jun 2018 12:23:42 -0700
Message-ID: <152986822251.3155.14348466047540978889.stgit@magnolia>
In-Reply-To: <152986820984.3155.16417868536016544528.stgit@magnolia>
References: <152986820984.3155.16417868536016544528.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a helper to decide if an inode has real or unwritten extents in the
CoW fork.  The upcoming repair freeze functionality will have to know if
it's safe to iput an inode -- if the inode has incore any state that
would require a transaction to unwind during iput, we'll have to defer
the iput.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.c |   19 +++++++++++++++++++
 fs/xfs/xfs_inode.h |    1 +
 2 files changed, 20 insertions(+)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 7a96c4e0ab5c..e6859dfc29af 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3689,3 +3689,22 @@ xfs_iflush_int(
 corrupt_out:
 	return -EFSCORRUPTED;
 }
+
+/* Decide if there are real or unwritten extents in the CoW fork. */
+bool
+xfs_inode_has_cow_blocks(
+	struct xfs_inode		*ip)
+{
+	struct xfs_iext_cursor		icur;
+	struct xfs_bmbt_irec		irec;
+	struct xfs_ifork		*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
+
+	if (!ifp)
+		return false;
+
+	for_each_xfs_iext(ifp, &icur, &irec) {
+		if (!isnullstartblock(irec.br_startblock))
+			return true;
+	}
+	return false;
+}
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 2ed63a49e890..735d0788bfdb 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -503,5 +503,6 @@ extern struct kmem_zone	*xfs_inode_zone;
 #define XFS_DEFAULT_COWEXTSZ_HINT 32
 
 bool xfs_inode_verify_forks(struct xfs_inode *ip);
+bool xfs_inode_has_cow_blocks(struct xfs_inode *ip);
 
 #endif	/* __XFS_INODE_H__ */

