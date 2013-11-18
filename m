Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9132429DF9
	for <xfs@oss.sgi.com>; Mon, 18 Nov 2013 07:10:45 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7042E304066
	for <xfs@oss.sgi.com>; Mon, 18 Nov 2013 05:10:42 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id b9ZFyH17Jr1k4kuJ (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 18 Nov 2013 05:10:41 -0800 (PST)
Date: Mon, 18 Nov 2013 05:10:40 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/2] xfs: tiny xfs_setattr_mode cleanup
Message-ID: <20131118131040.GA21649@infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Remove the pointless tp argument, and properly align the local variable
declarations.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_iops.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

Index: linux/fs/xfs/xfs_iops.c
===================================================================
--- linux.orig/fs/xfs/xfs_iops.c	2013-11-14 17:58:06.612700222 +0100
+++ linux/fs/xfs/xfs_iops.c	2013-11-18 11:54:46.083792257 +0100
@@ -459,14 +459,12 @@ xfs_vn_getattr(
 
 static void
 xfs_setattr_mode(
-	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
 	struct iattr		*iattr)
 {
-	struct inode	*inode = VFS_I(ip);
-	umode_t		mode = iattr->ia_mode;
+	struct inode		*inode = VFS_I(ip);
+	umode_t			mode = iattr->ia_mode;
 
-	ASSERT(tp);
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
 	ip->i_d.di_mode &= S_IFMT;
@@ -633,7 +631,7 @@ xfs_setattr_nonsize(
 	 * Change file access modes.
 	 */
 	if (mask & ATTR_MODE)
-		xfs_setattr_mode(tp, ip, iattr);
+		xfs_setattr_mode(ip, iattr);
 
 	/*
 	 * Change file access or modified times.
@@ -871,7 +869,7 @@ xfs_setattr_size(
 	 * Change file access modes.
 	 */
 	if (mask & ATTR_MODE)
-		xfs_setattr_mode(tp, ip, iattr);
+		xfs_setattr_mode(ip, iattr);
 
 	if (mask & ATTR_CTIME) {
 		inode->i_ctime = iattr->ia_ctime;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
