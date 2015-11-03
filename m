Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5C8747F58
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 07:48:06 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CC1A5AC002
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 05:48:02 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id KROKwXSzHpzNpLph (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 03 Nov 2015 05:48:01 -0800 (PST)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH] xfs: Fix error path in xfs_get_acl
Date: Tue,  3 Nov 2015 14:47:57 +0100
Message-Id: <1446558477-21981-1-git-send-email-agruenba@redhat.com>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com
Cc: Andreas Gruenbacher <agruenba@redhat.com>

Here is another bugfix patch, previously discussed here:

  http://oss.sgi.com/archives/xfs/2015-10/msg00295.html

Thanks,
Andreas


Error codes from xfs_attr_get other than -ENOATTR were not properly
reported.  Fix that.

In addition, the declaration of struct xfs_inode in xfs_acl.h isn't needed.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/xfs/xfs_acl.c | 1 +
 fs/xfs/xfs_acl.h | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 763e365..6bb470f 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -163,6 +163,7 @@ xfs_get_acl(struct inode *inode, int type)
 		 */
 		if (error == -ENOATTR)
 			goto out_update_cache;
+		acl = ERR_PTR(error);
 		goto out;
 	}
 
diff --git a/fs/xfs/xfs_acl.h b/fs/xfs/xfs_acl.h
index 75af0a4..52f8255 100644
--- a/fs/xfs/xfs_acl.h
+++ b/fs/xfs/xfs_acl.h
@@ -20,7 +20,6 @@
 
 struct inode;
 struct posix_acl;
-struct xfs_inode;
 
 #ifdef CONFIG_XFS_POSIX_ACL
 extern struct posix_acl *xfs_get_acl(struct inode *inode, int type);
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
