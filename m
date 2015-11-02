Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B1E6D29DFC
	for <xfs@oss.sgi.com>; Mon,  2 Nov 2015 13:53:03 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A5F298F8033
	for <xfs@oss.sgi.com>; Mon,  2 Nov 2015 11:53:03 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 2yb6DS8KnSCIsBKF (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 02 Nov 2015 11:53:02 -0800 (PST)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 1/2] xfs: Fixes to "invalidate cached acl if set directly via
	xattr"
Date: Mon,  2 Nov 2015 20:52:53 +0100
Message-Id: <1446493974-24669-2-git-send-email-agruenba@redhat.com>
In-Reply-To: <1446493974-24669-1-git-send-email-agruenba@redhat.com>
References: <1446493974-24669-1-git-send-email-agruenba@redhat.com>
References: <1446217508-22157-1-git-send-email-agruenba@redhat.com>
	<20151102025352.GY19199@dastard>
In-Reply-To: <20151102025352.GY19199@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, Andreas Gruenbacher <agruenba@kernel.org>, Andreas Gruenbacher <agruenba@redhat.com>, xfs@oss.sgi.com

Don't match arbitrary name prefixes like "S" when checking for the
attribute names "SGI_ACL_{FILE,DEFAULT}".

Function forget_cached_acl only exists in kernels that have POSIX ACL
support; guard calls to that function by CONFIG_XFS_POSIX_ACL.

Signed-off-by: Andreas Gruenbacher <agruenba@kernel.org>
---
 fs/xfs/xfs_xattr.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 2e1eb80..1542d64 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -80,10 +80,12 @@ xfs_xattr_set(struct dentry *dentry, const char *name, const void *value,
 	 * consistent.
 	 */
 	if (!error && (xflags & ATTR_ROOT)) {
-		if (!strncmp(name, SGI_ACL_FILE, strlen(name)))
+#ifdef CONFIG_XFS_POSIX_ACL
+		if (!strcmp(name, SGI_ACL_FILE)
 			forget_cached_acl(VFS_I(ip), ACL_TYPE_ACCESS);
-		else if (!strncmp(name, SGI_ACL_DEFAULT, strlen(name)))
+		else if (!strcmp(name, SGI_ACL_DEFAULT))
 			forget_cached_acl(VFS_I(ip), ACL_TYPE_DEFAULT);
+#endif
 	}
 
 	return error;
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
