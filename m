Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:40156 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752448AbdLWBOH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Dec 2017 20:14:07 -0500
Subject: [PATCH 11/20] xfs: create structure verifier function for short
 form symlinks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 22 Dec 2017 17:08:13 -0800
Message-ID: <151399129325.23543.1193796017454328976.stgit@magnolia>
In-Reply-To: <151399122361.23543.15718507168231759645.stgit@magnolia>
References: <151399122361.23543.15718507168231759645.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a function to check the structure of short form symlink targets.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_shared.h         |    1 +
 fs/xfs/libxfs/xfs_symlink_remote.c |   34 ++++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index c6f4eb4..67ccb1a 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -143,5 +143,6 @@ bool xfs_symlink_hdr_ok(xfs_ino_t ino, uint32_t offset,
 			uint32_t size, struct xfs_buf *bp);
 void xfs_symlink_local_to_remote(struct xfs_trans *tp, struct xfs_buf *bp,
 				 struct xfs_inode *ip, struct xfs_ifork *ifp);
+xfs_failaddr_t xfs_symlink_shortform_verify(struct xfs_inode *ip);
 
 #endif /* __XFS_SHARED_H__ */
diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
index 5497014..adf2d78 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.c
+++ b/fs/xfs/libxfs/xfs_symlink_remote.c
@@ -209,3 +209,37 @@ xfs_symlink_local_to_remote(
 	xfs_trans_log_buf(tp, bp, 0, sizeof(struct xfs_dsymlink_hdr) +
 					ifp->if_bytes - 1);
 }
+
+/* Verify the consistency of an inline symlink. */
+xfs_failaddr_t
+xfs_symlink_shortform_verify(
+	struct xfs_inode	*ip)
+{
+	char			*sfp;
+	char			*endp;
+	struct xfs_ifork	*ifp;
+	int			size;
+
+	ASSERT(ip->i_d.di_format == XFS_DINODE_FMT_LOCAL);
+	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+	sfp = (char *)ifp->if_u1.if_data;
+	size = ifp->if_bytes;
+	endp = sfp + size;
+
+	/* Zero length symlinks can exist while we're deleting a remote one. */
+	if (size == 0)
+		return NULL;
+
+	/* No negative sizes or overly long symlink targets. */
+	if (size < 0 || size > XFS_SYMLINK_MAXLEN)
+		return __this_address;
+
+	/* No NULLs in the target either. */
+	if (memchr(sfp, 0, size - 1))
+		return __this_address;
+
+	/* We /did/ null-terminate the buffer, right? */
+	if (*endp != 0)
+		return __this_address;
+	return NULL;
+}

