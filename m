Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAEGHfcu193819 for <xfs@oss.sgi.com>; Sat, 14 Nov 2009 10:17:43 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0F0E989D0D
	for <xfs@oss.sgi.com>; Sat, 14 Nov 2009 08:18:01 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id UeMY8lfFLoxPBFeu for
	<xfs@oss.sgi.com>; Sat, 14 Nov 2009 08:18:01 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1N9LK5-0004WL-NK
	for xfs@oss.sgi.com; Sat, 14 Nov 2009 16:18:01 +0000
Message-Id: <20091114161801.612419979@bombadil.infradead.org>
Date: Sat, 14 Nov 2009 11:17:20 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/7] xfs: rename xfs_attr_fetch to xfs_attr_get_int
References: <20091114161717.233372584@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs_attr_get_int
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

Using a totally different name for the lowlevel get operation does not
fit the _int convention used in the rest of the attr code, so rename it.

While we're at it also fix the prototype to use the normal convention
and mark it static as it's never used outside of xfs_attr.c.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_attr.c
===================================================================
--- xfs.orig/fs/xfs/xfs_attr.c	2009-11-12 17:10:20.047264798 +0100
+++ xfs/fs/xfs/xfs_attr.c	2009-11-12 17:18:17.703273473 +0100
@@ -123,9 +123,13 @@ xfs_inode_hasattr(
  * Overall external interface routines.
  *========================================================================*/
 
-int
-xfs_attr_fetch(xfs_inode_t *ip, struct xfs_name *name,
-		char *value, int *valuelenp, int flags)
+STATIC int
+xfs_attr_get_int(
+	struct xfs_inode	*ip,
+	struct xfs_name		*name,
+	char			*value,
+	int			*valuelenp,
+	int			flags)
 {
 	xfs_da_args_t   args;
 	int             error;
@@ -188,7 +192,7 @@ xfs_attr_get(
 		return error;
 
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
-	error = xfs_attr_fetch(ip, &xname, value, valuelenp, flags);
+	error = xfs_attr_get_int(ip, &xname, value, valuelenp, flags);
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 	return(error);
 }
Index: xfs/fs/xfs/xfs_attr.h
===================================================================
--- xfs.orig/fs/xfs/xfs_attr.h	2009-11-12 17:10:20.056254911 +0100
+++ xfs/fs/xfs/xfs_attr.h	2009-11-12 17:18:17.703273473 +0100
@@ -131,7 +131,6 @@ typedef struct xfs_attr_list_context {
  */
 int xfs_attr_calc_size(struct xfs_inode *, int, int, int *);
 int xfs_attr_inactive(struct xfs_inode *dp);
-int xfs_attr_fetch(struct xfs_inode *, struct xfs_name *, char *, int *, int);
 int xfs_attr_rmtval_get(struct xfs_da_args *args);
 int xfs_attr_list_int(struct xfs_attr_list_context *);
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
