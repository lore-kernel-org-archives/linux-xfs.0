Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23891 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751182AbdH1SRR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Aug 2017 14:17:17 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7SIHFdh019452
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 28 Aug 2017 18:17:16 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v7SIHFwo028199
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 28 Aug 2017 18:17:15 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v7SIHFcM008210
        for <linux-xfs@vger.kernel.org>; Mon, 28 Aug 2017 18:17:15 GMT
Subject: [PATCH 07/12] xfs: create structure verifier function for shortform
 xattrs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 28 Aug 2017 11:17:14 -0700
Message-ID: <150394423410.24826.11125117377573689783.stgit@magnolia>
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

Create a function to perform structure verification for short form
extended attributes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c |   70 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_attr_leaf.h |    1 +
 2 files changed, 71 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 16bc966..742e8a3 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -873,6 +873,76 @@ xfs_attr_shortform_allfit(
 	return xfs_attr_shortform_bytesfit(dp, bytes);
 }
 
+/* Verify the consistency of an inline attribute fork. */
+void *
+xfs_attr_shortform_verify(
+	struct xfs_inode		*ip)
+{
+	struct xfs_attr_shortform	*sfp;
+	struct xfs_attr_sf_entry	*sfep;
+	struct xfs_attr_sf_entry	*next_sfep;
+	char				*endp;
+	struct xfs_ifork		*ifp;
+	int				i;
+	int				size;
+
+	ASSERT(ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL);
+	ifp = XFS_IFORK_PTR(ip, XFS_ATTR_FORK);
+	sfp = (struct xfs_attr_shortform *)ifp->if_u1.if_data;
+	size = ifp->if_bytes;
+
+	/*
+	 * Give up if the attribute is way too short.
+	 */
+	if (size < sizeof(struct xfs_attr_sf_hdr))
+		return __this_address;
+
+	endp = (char *)sfp + size;
+
+	/* Check all reported entries */
+	sfep = &sfp->list[0];
+	for (i = 0; i < sfp->hdr.count; i++) {
+		/*
+		 * struct xfs_attr_sf_entry has a variable length.
+		 * Check the fixed-offset parts of the structure are
+		 * within the data buffer.
+		 */
+		if (((char *)sfep + sizeof(*sfep)) >= endp)
+			return __this_address;
+
+		/* Don't allow names with known bad length. */
+		if (sfep->namelen == 0)
+			return __this_address;
+
+		/*
+		 * Check that the variable-length part of the structure is
+		 * within the data buffer.  The next entry starts after the
+		 * name component, so nextentry is an acceptable test.
+		 */
+		next_sfep = XFS_ATTR_SF_NEXTENTRY(sfep);
+		if ((char *)next_sfep > endp)
+			return __this_address;
+
+		/*
+		 * Check for unknown flags.  Short form doesn't support
+		 * the incomplete or local bits.
+		 */
+		if (sfep->flags & ~(XFS_ATTR_ROOT | XFS_ATTR_SECURE))
+			return __this_address;
+
+		/* Check for invalid namespace combinations. */
+		if ((sfep->flags & XFS_ATTR_ROOT) &&
+		    (sfep->flags & XFS_ATTR_SECURE))
+			return __this_address;
+
+		sfep = next_sfep;
+	}
+	if ((void *)sfep != (void *)endp)
+		return __this_address;
+
+	return NULL;
+}
+
 /*
  * Convert a leaf attribute list to shortform attribute list
  */
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
index f7dda0c..f7bc912 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -52,6 +52,7 @@ int	xfs_attr_shortform_to_leaf(struct xfs_da_args *args);
 int	xfs_attr_shortform_remove(struct xfs_da_args *args);
 int	xfs_attr_shortform_allfit(struct xfs_buf *bp, struct xfs_inode *dp);
 int	xfs_attr_shortform_bytesfit(struct xfs_inode *dp, int bytes);
+void	*xfs_attr_shortform_verify(struct xfs_inode *ip);
 void	xfs_attr_fork_remove(struct xfs_inode *ip, struct xfs_trans *tp);
 
 /*

