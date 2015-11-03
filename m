Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7CDE77F56
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 07:44:13 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5A2A1304051
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 05:44:10 -0800 (PST)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.10]) by
	cuda.sgi.com with ESMTP id YIEAh1AN3nFlOAkf (version=TLSv1.2
	cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 03 Nov 2015 05:44:08 -0800 (PST)
From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] xfs: only modify ACLs if CONFIG_XFS_POSIX_ACL enabled
Date: Tue, 03 Nov 2015 14:43:58 +0100
Message-ID: <4425824.kIWhRaBxBZ@wuerfel>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, Brian Foster <bfoster@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Dave Chinner <dchinner@redhat.com>, linux-arm-kernel@lists.infradead.org

A recent bug fix added a call to forget_cached_acl(), but that
function is not always available, so we can get a build error
here:

fs/xfs/xfs_xattr.c: In function 'xfs_xattr_set':
fs/xfs/xfs_xattr.c:84:4: error: implicit declaration of function 'forget_cached_acl' [-Werror=implicit-function-declaration]

This changes the code to use the same #ifdef that we already
use to encapsule the existing ACL handling.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 6caa105651cb ("xfs: invalidate cached acl if set directly via xattr")
---
This started breaking ARM davinci_all_defconfig today in linux-next

diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 2e1eb80d5374..6229325abdd3 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -73,6 +73,7 @@ xfs_xattr_set(struct dentry *dentry, const char *name, const void *value,
 		return xfs_attr_remove(ip, (unsigned char *)name, xflags);
 	error = xfs_attr_set(ip, (unsigned char *)name,
 				(void *)value, size, xflags);
+#ifdef CONFIG_XFS_POSIX_ACL
 	/*
 	 * Invalidate any cached ACLs if the user has bypassed the ACL
 	 * interface. We don't validate the content whatsoever so it is caller
@@ -85,6 +86,7 @@ xfs_xattr_set(struct dentry *dentry, const char *name, const void *value,
 		else if (!strncmp(name, SGI_ACL_DEFAULT, strlen(name)))
 			forget_cached_acl(VFS_I(ip), ACL_TYPE_DEFAULT);
 	}
+#endif
 
 	return error;
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
