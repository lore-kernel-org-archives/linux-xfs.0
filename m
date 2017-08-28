Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23959 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751182AbdH1SRX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Aug 2017 14:17:23 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7SIHMad019562
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 28 Aug 2017 18:17:22 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v7SIHLwa028496
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 28 Aug 2017 18:17:22 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v7SIHLS6008344
        for <linux-xfs@vger.kernel.org>; Mon, 28 Aug 2017 18:17:21 GMT
Subject: [PATCH 08/12] xfs: create structure verifier function for short
 form symlinks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 28 Aug 2017 11:17:20 -0700
Message-ID: <150394424043.24826.12593310858509794590.stgit@magnolia>
In-Reply-To: <150394418979.24826.12970283067445908653.stgit@magnolia>
References: <150394418979.24826.12970283067445908653.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, darrick.wong@oracle.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a function to check the structure of short form symlink targets.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_shared.h         |    1 +
 fs/xfs/libxfs/xfs_symlink_remote.c |   36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index c6f4eb4..536fb35 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -143,5 +143,6 @@ bool xfs_symlink_hdr_ok(xfs_ino_t ino, uint32_t offset,
 			uint32_t size, struct xfs_buf *bp);
 void xfs_symlink_local_to_remote(struct xfs_trans *tp, struct xfs_buf *bp,
 				 struct xfs_inode *ip, struct xfs_ifork *ifp);
+void *xfs_symlink_shortform_verify(struct xfs_inode *ip);
 
 #endif /* __XFS_SHARED_H__ */
diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
index 1ac8c4d..ef5e754 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.c
+++ b/fs/xfs/libxfs/xfs_symlink_remote.c
@@ -209,3 +209,39 @@ xfs_symlink_local_to_remote(
 	xfs_trans_log_buf(tp, bp, 0, sizeof(struct xfs_dsymlink_hdr) +
 					ifp->if_bytes - 1);
 }
+
+/* Verify the consistency of an inline symlink. */
+void *
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
+	for (; sfp < endp; sfp++) {
+		if (*sfp == 0)
+			return __this_address;
+	}
+
+	/* We /did/ null-terminate the buffer, right? */
+	if (*endp != 0)
+		return __this_address;
+	return NULL;
+}

