Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:41674 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728133AbfAACRR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:17:17 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012DnfX018635
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:17:16 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2pp0btp77m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:17:16 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x012HAma020109
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:17:10 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x012HANK006209
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:17:10 GMT
Subject: [PATCH 03/12] xfs: decide if inode needs inactivation
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:17:09 -0800
Message-ID: <154630902931.16693.13552621144812255351.stgit@magnolia>
In-Reply-To: <154630901076.16693.13111277988041606505.stgit@magnolia>
References: <154630901076.16693.13111277988041606505.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a predicate function to decide if an inode needs (deferred)
inactivation.  Any file that has been unlinked or has speculative
preallocations either for post-EOF writes or for CoW qualifies.
This function will also be used by the upcoming deferred inactivation
patch.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.c |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.h |    1 +
 2 files changed, 53 insertions(+)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 662ee537ffb5..4121523659e3 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1784,6 +1784,58 @@ xfs_inactive_ifree(
 	return 0;
 }
 
+/*
+ * Returns true if we need to update the on-disk metadata before we can free
+ * the memory used by this inode.  Updates include freeing post-eof
+ * preallocations; freeing COW staging extents; and marking the inode free in
+ * the inobt if it is on the unlinked list.
+ */
+bool
+xfs_inode_needs_inactivation(
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_ifork	*cow_ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
+
+	/*
+	 * If the inode is already free, then there can be nothing
+	 * to clean up here.
+	 */
+	if (VFS_I(ip)->i_mode == 0)
+		return false;
+
+	/* If this is a read-only mount, don't do this (would generate I/O) */
+	if (mp->m_flags & XFS_MOUNT_RDONLY)
+		return false;
+
+	/* Try to clean out the cow blocks if there are any. */
+	if (cow_ifp && cow_ifp->if_bytes > 0)
+		return true;
+
+	if (VFS_I(ip)->i_nlink != 0) {
+		/*
+		 * force is true because we are evicting an inode from the
+		 * cache. Post-eof blocks must be freed, lest we end up with
+		 * broken free space accounting.
+		 *
+		 * Note: don't bother with iolock here since lockdep complains
+		 * about acquiring it in reclaim context. We have the only
+		 * reference to the inode at this point anyways.
+		 */
+		if (xfs_can_free_eofblocks(ip, true) &&
+		    xfs_inode_has_posteof_blocks(ip))
+			return true;
+
+		return false;
+	}
+
+	/*
+	 * Link count dropped to zero, which means we have to mark the inode
+	 * free on disk and remove it from the AGI unlinked list.
+	 */
+	return true;
+}
+
 /*
  * xfs_inactive
  *
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 02a938661ba8..c7d638aaec1b 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -500,5 +500,6 @@ extern struct kmem_zone	*xfs_inode_zone;
 
 bool xfs_inode_verify_forks(struct xfs_inode *ip);
 bool xfs_inode_has_posteof_blocks(struct xfs_inode *ip);
+bool xfs_inode_needs_inactivation(struct xfs_inode *ip);
 
 #endif	/* __XFS_INODE_H__ */
