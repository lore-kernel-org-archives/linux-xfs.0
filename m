Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5CFInLj211029 for <xfs@oss.sgi.com>; Fri, 12 Jun 2009 10:18:52 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D71A12F0441
	for <xfs@oss.sgi.com>; Fri, 12 Jun 2009 08:19:11 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id CxTlGtNKEul9NimX for
	<xfs@oss.sgi.com>; Fri, 12 Jun 2009 08:19:11 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1MF8X9-0002fO-Im
	for xfs@oss.sgi.com; Fri, 12 Jun 2009 15:19:11 +0000
Date: Fri, 12 Jun 2009 11:19:11 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: fix small mismerge in xfs_vn_mknod
Message-ID: <20090612151911.GA9832@infradead.org>
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

Identation got messed up when merging the current_umask changes with
the generic ACL support.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2009-06-12 17:16:26.902939418 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_iops.c	2009-06-12 17:16:48.611940327 +0200
@@ -225,8 +225,8 @@ xfs_vn_mknod(
 		if (IS_ERR(default_acl))
 			return -PTR_ERR(default_acl);
 
-	if (!default_acl)
-		mode &= ~current_umask();
+		if (!default_acl)
+			mode &= ~current_umask();
 	}
 
 	xfs_dentry_to_name(&name, dentry);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
