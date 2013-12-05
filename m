Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 490357F5A
	for <xfs@oss.sgi.com>; Thu,  5 Dec 2013 09:59:53 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 358468F8050
	for <xfs@oss.sgi.com>; Thu,  5 Dec 2013 07:59:53 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id R5rHhew8nL5N2Gyt (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 05 Dec 2013 07:59:52 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1VobLD-0004xQ-QA
	for xfs@oss.sgi.com; Thu, 05 Dec 2013 15:59:51 +0000
Message-Id: <20131205155951.679310054@bombadil.infradead.org>
Date: Thu, 05 Dec 2013 07:58:34 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 4/5] xfs: use xfs_ilock_map_shared in xfs_attr_get
References: <20131205155830.620826868@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-fix-attr-locking
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

diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index b861270..5343034 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
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
