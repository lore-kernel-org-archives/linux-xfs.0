Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:48608 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727484AbeIZQiG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Sep 2018 12:38:06 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w8QAO291037394
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:49 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2mnvtur9bq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:49 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w8QAPngi013104
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:49 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w8QAPmfV018458
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:49 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v3 17/30] xfsprogs: define parent pointer xattr format
Date: Wed, 26 Sep 2018 03:23:20 -0700
Message-Id: <1537957413-10630-18-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1537957413-10630-1-git-send-email-allison.henderson@oracle.com>
References: <1537957413-10630-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

We need to define the parent pointer attribute format before we
start adding support for it into all the code that needs to use it.
The EA format we will use encodes the following information:

    name={parent inode #, parent inode generation, dirent offset}
    value={dirent filename}

The inode/gen gives all the information we need to reliably identify
the parent without requiring child->parent lock ordering, and allows
userspace to do pathname component level reconstruction without the
kernel ever needing to verify the parent itself as part of ioctl
calls.

By using the dirent offset in the EA name, we have a method of
knowing the exact parent pointer EA we need to modify/remove in
rename/unlink without an unbound EA name search.

By keeping the dirent name in the value, we have enough information
to be able to validate and reconstruct damaged directory trees.
While the diroffset of a filename alone is not unique enough to
identify the child, the {diroffset,filename,child_inode} tuple is
sufficient. That is, if the diroffset gets reused and points to a
different filename, we can detect that from the contents of EA. If a
link of the same name is created, then we can check whether it
points at the same inode as the parent EA we current have.

[achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t,
       changed p_ino to xfs_ino_t and p_namelen to uint8_t,
       moved to xfs_da_format for xfs_dir2_dataptr_t]

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong<darrick.wong@oracle.com>
---
 libxfs/xfs_da_format.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/libxfs/xfs_da_format.h b/libxfs/xfs_da_format.h
index 67cb9ea..b6405d7 100644
--- a/libxfs/xfs_da_format.h
+++ b/libxfs/xfs_da_format.h
@@ -873,4 +873,29 @@ static inline unsigned int xfs_dir2_dirblock_bytes(struct xfs_sb *sbp)
 	return 1 << (sbp->sb_blocklog + sbp->sb_dirblklog);
 }
 
+/*
+ * Parent pointer attribute format definition
+ *
+ * EA name encodes the parent inode number, generation and the offset of
+ * the dirent that points to the child inode. The EA value contains the
+ * same name as the dirent in the parent directory.
+ */
+struct xfs_parent_name_rec {
+	__be64  p_ino;
+	__be32  p_gen;
+	__be32  p_diroffset;
+};
+
+/*
+ * incore version of the above, also contains name pointers so callers
+ * can pass/obtain all the parent pointer information in a single structure
+ */
+struct xfs_parent_name_irec {
+	xfs_ino_t		p_ino;
+	uint32_t		p_gen;
+	xfs_dir2_dataptr_t	p_diroffset;
+	const char		*p_name;
+	uint8_t			p_namelen;
+};
+
 #endif /* __XFS_DA_FORMAT_H__ */
-- 
2.7.4
