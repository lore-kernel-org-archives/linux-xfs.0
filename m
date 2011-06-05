Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p55BCesS154356 for <xfs@oss.sgi.com>; Sun, 5 Jun 2011 06:12:40 -0500
Received: from ZenIV.linux.org.uk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DEFA716625D2
	for <xfs@oss.sgi.com>; Sun,  5 Jun 2011 04:12:33 -0700 (PDT)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id bR7DwinobNrc768f for
	<xfs@oss.sgi.com>; Sun, 05 Jun 2011 04:12:33 -0700 (PDT)
Date: Sun, 5 Jun 2011 12:12:31 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH] fix ->mknod() return value on xfs_get_acl() failure
Message-ID: <20110605111231.GD11521@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: linux-kernel@vger.kernel.org

	->mknod() should return negative on errors and PTR_ERR() gives
already negative value...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
index dd21784..d44d92c 100644
--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -182,7 +182,7 @@ xfs_vn_mknod(
 	if (IS_POSIXACL(dir)) {
 		default_acl = xfs_get_acl(dir, ACL_TYPE_DEFAULT);
 		if (IS_ERR(default_acl))
-			return -PTR_ERR(default_acl);
+			return PTR_ERR(default_acl);
 
 		if (!default_acl)
 			mode &= ~current_umask();

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
