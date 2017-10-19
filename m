Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:49711 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754832AbdJSOWE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2017 10:22:04 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 13/18] xfs: don't change inode mode if ACL update fails
Date: Thu, 19 Oct 2017 16:21:18 +0200
Message-Id: <20171019142123.18109-14-hch@lst.de>
In-Reply-To: <20171019142123.18109-1-hch@lst.de>
References: <20171019142123.18109-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>

From: Dave Chinner <dchinner@redhat.com>

commit 67f2ffe31d1a683170c2ba0ecc643e42a5fdd397 upstream.

If we get ENOSPC half way through setting the ACL, the inode mode
can still be changed even though the ACL does not exist. Reorder the
operation to only change the mode of the inode if the ACL is set
correctly.

Whilst this does not fix the problem with crash consistency (that requires
attribute addition to be a deferred op) it does prevent ENOSPC and other
non-fatal errors setting an xattr to be handled sanely.

This fixes xfstests generic/449.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_acl.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 7034e17535de..3354140de07e 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -247,6 +247,8 @@ xfs_set_mode(struct inode *inode, umode_t mode)
 int
 xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 {
+	umode_t mode;
+	bool set_mode = false;
 	int error = 0;
 
 	if (!acl)
@@ -257,16 +259,24 @@ xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 		return error;
 
 	if (type == ACL_TYPE_ACCESS) {
-		umode_t mode;
-
 		error = posix_acl_update_mode(inode, &mode, &acl);
 		if (error)
 			return error;
-		error = xfs_set_mode(inode, mode);
-		if (error)
-			return error;
+		set_mode = true;
 	}
 
  set_acl:
-	return __xfs_set_acl(inode, acl, type);
+	error =  __xfs_set_acl(inode, acl, type);
+	if (error)
+		return error;
+
+	/*
+	 * We set the mode after successfully updating the ACL xattr because the
+	 * xattr update can fail at ENOSPC and we don't want to change the mode
+	 * if the ACL update hasn't been applied.
+	 */
+	if (set_mode)
+		error = xfs_set_mode(inode, mode);
+
+	return error;
 }
-- 
2.14.2

