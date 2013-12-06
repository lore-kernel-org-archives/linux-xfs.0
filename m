Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 90BB529E1A
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 14:31:30 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 76FCC8F8065
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 12:31:30 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id A6t2uj9fyKjDfIlE (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 06 Dec 2013 12:31:29 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1Vp23d-0004yV-DY
	for xfs@oss.sgi.com; Fri, 06 Dec 2013 20:31:29 +0000
Message-Id: <20131206203129.330138179@bombadil.infradead.org>
Date: Fri, 06 Dec 2013 12:30:15 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 09/11] xfs: use xfs_ilock_attr_map_shared in xfs_attr_get
References: <20131206203006.914776999@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-attr-locking
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
To: xfs@oss.sgi.com

We might not have read in the extent list at this point, so make sure we
take the ilock exclusively if we have to do so.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_attr.c
===================================================================
--- xfs.orig/fs/xfs/xfs_attr.c	2013-12-06 17:20:27.447331601 +0100
+++ xfs/fs/xfs/xfs_attr.c	2013-12-06 19:41:05.119158446 +0100
@@ -164,6 +164,7 @@ xfs_attr_get(
 {
 	int		error;
 	struct xfs_name	xname;
+	uint		lock_mode;
 
 	XFS_STATS_INC(xs_attr_get);
 
@@ -174,9 +175,9 @@ xfs_attr_get(
 	if (error)
 		return error;
 
-	xfs_ilock(ip, XFS_ILOCK_SHARED);
+	lock_mode = xfs_ilock_attr_map_shared(ip);
 	error = xfs_attr_get_int(ip, &xname, value, valuelenp, flags);
-	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+	xfs_iunlock(ip, lock_mode);
 	return(error);
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
