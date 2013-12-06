Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 07EE529E12
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 10:49:11 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D0DBB8F804B
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 08:49:07 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id J1iZI8dFENI5ls3z (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 06 Dec 2013 08:49:07 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1VoyaQ-0000Cd-L9
	for xfs@oss.sgi.com; Fri, 06 Dec 2013 16:49:06 +0000
Message-Id: <20131206164906.534601472@bombadil.infradead.org>
Date: Fri, 06 Dec 2013 08:48:24 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 5/7] xfs: use xfs_ilock_map_shared in xfs_attr_get
References: <20131206164819.371654241@bombadil.infradead.org>
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
--- xfs.orig/fs/xfs/xfs_attr.c	2013-12-05 22:19:26.087829792 +0100
+++ xfs/fs/xfs/xfs_attr.c	2013-12-05 22:23:54.307824288 +0100
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
+	lock_mode = xfs_ilock_map_shared(ip);
 	error = xfs_attr_get_int(ip, &xname, value, valuelenp, flags);
-	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+	xfs_iunlock_map_shared(ip, lock_mode);
 	return(error);
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
