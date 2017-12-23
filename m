Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:39132 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757136AbdLWBNJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Dec 2017 20:13:09 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBN1CN8Y079580
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 01:13:09 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2f1cvd81ag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 01:13:09 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vBN188BD029481
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 01:08:08 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vBN188N5006248
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 01:08:08 GMT
Subject: [PATCH 10/20] xfs: create structure verifier function for shortform
 xattrs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 22 Dec 2017 17:08:07 -0800
Message-ID: <151399128719.23543.1964091568041834715.stgit@magnolia>
In-Reply-To: <151399122361.23543.15718507168231759645.stgit@magnolia>
References: <151399122361.23543.15718507168231759645.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a function to perform structure verification for short form
extended attributes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c |   74 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_attr_leaf.h |    1 +
 2 files changed, 75 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 68c66fa..ae3bccb 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -872,6 +872,80 @@ xfs_attr_shortform_allfit(
 	return xfs_attr_shortform_bytesfit(dp, bytes);
 }
 
+/* Verify the consistency of an inline attribute fork. */
+xfs_failaddr_t
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
+		 * the incomplete or local bits, so we can use the namespace
+		 * mask here.
+		 */
+		if (sfep->flags & ~XFS_ATTR_NSP_ONDISK_MASK)
+			return __this_address;
+
+		/*
+		 * Check for invalid namespace combinations.  We only allow
+		 * one namespace flag per xattr, so we can just count the
+		 * bits (i.e. hweight) here.
+		 */
+		if (hweight8(sfep->flags & XFS_ATTR_NSP_ONDISK_MASK) > 1)
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
index 894124e..4da08af 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -53,6 +53,7 @@ int	xfs_attr_shortform_to_leaf(struct xfs_da_args *args,
 int	xfs_attr_shortform_remove(struct xfs_da_args *args);
 int	xfs_attr_shortform_allfit(struct xfs_buf *bp, struct xfs_inode *dp);
 int	xfs_attr_shortform_bytesfit(struct xfs_inode *dp, int bytes);
+xfs_failaddr_t xfs_attr_shortform_verify(struct xfs_inode *ip);
 void	xfs_attr_fork_remove(struct xfs_inode *ip, struct xfs_trans *tp);
 
 /*

