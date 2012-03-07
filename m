Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q274olUe020640 for <xfs@oss.sgi.com>; Tue, 6 Mar 2012 22:50:47 -0600
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	gASr8Yp5zSfGYAm3 for <xfs@oss.sgi.com>;
	Tue, 06 Mar 2012 20:50:45 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1S58pm-0001o6-Cl
	for xfs@oss.sgi.com; Wed, 07 Mar 2012 15:50:42 +1100
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1S58pb-0007Ux-Ul
	for xfs@oss.sgi.com; Wed, 07 Mar 2012 15:50:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 06/10] xfs: remove remaining scraps of struct xfs_iomap
Date: Wed,  7 Mar 2012 15:50:24 +1100
Message-Id: <1331095828-28742-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1331095828-28742-1-git-send-email-david@fromorbit.com>
References: <1331095828-28742-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_vnode.h    |    1 -
 fs/xfs/xfs_vnodeops.h |    3 ---
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_vnode.h b/fs/xfs/xfs_vnode.h
index 7c220b4..db14d0c 100644
--- a/fs/xfs/xfs_vnode.h
+++ b/fs/xfs/xfs_vnode.h
@@ -22,7 +22,6 @@
 
 struct file;
 struct xfs_inode;
-struct xfs_iomap;
 struct attrlist_cursor_kern;
 
 /*
diff --git a/fs/xfs/xfs_vnodeops.h b/fs/xfs/xfs_vnodeops.h
index 0c877cb..447e146 100644
--- a/fs/xfs/xfs_vnodeops.h
+++ b/fs/xfs/xfs_vnodeops.h
@@ -10,7 +10,6 @@ struct kiocb;
 struct pipe_inode_info;
 struct uio;
 struct xfs_inode;
-struct xfs_iomap;
 
 
 int xfs_setattr_nonsize(struct xfs_inode *ip, struct iattr *vap, int flags);
@@ -49,8 +48,6 @@ int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
 int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name, int flags);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 		int flags, struct attrlist_cursor_kern *cursor);
-int xfs_bmap(struct xfs_inode *ip, xfs_off_t offset, ssize_t count,
-		int flags, struct xfs_iomap *iomapp, int *niomaps);
 void xfs_tosspages(struct xfs_inode *inode, xfs_off_t first,
 		xfs_off_t last, int fiopt);
 int xfs_flushinval_pages(struct xfs_inode *ip, xfs_off_t first,
-- 
1.7.9

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
