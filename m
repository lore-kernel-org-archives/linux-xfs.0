Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 055397F56
	for <xfs@oss.sgi.com>; Thu,  5 Dec 2013 09:59:53 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9624BAC005
	for <xfs@oss.sgi.com>; Thu,  5 Dec 2013 07:59:52 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id DsjVPPmW7CyZD8C4 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 05 Dec 2013 07:59:51 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1VobLD-0004vj-9Y
	for xfs@oss.sgi.com; Thu, 05 Dec 2013 15:59:51 +0000
Message-Id: <20131205155951.199565525@bombadil.infradead.org>
Date: Thu, 05 Dec 2013 07:58:31 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/5] xfs: take the ilock around xfs_bmapi_read in
	xfs_zero_remaining_bytes
References: <20131205155830.620826868@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs_zero_remaining_bytes-locking
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

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_bmap_util.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap_util.c	2013-12-05 11:37:57.791685284 +0100
+++ xfs/fs/xfs/xfs_bmap_util.c	2013-12-05 11:39:43.599683113 +0100
@@ -1147,6 +1147,7 @@ xfs_zero_remaining_bytes(
 	xfs_mount_t		*mp = ip->i_mount;
 	int			nimap;
 	int			error = 0;
+	uint			lock_mode;
 
 	/*
 	 * Avoid doing I/O beyond eof - it's not necessary
@@ -1159,11 +1160,15 @@ xfs_zero_remaining_bytes(
 	if (endoff > XFS_ISIZE(ip))
 		endoff = XFS_ISIZE(ip);
 
+	lock_mode = xfs_ilock_map_shared(ip);
+
 	bp = xfs_buf_get_uncached(XFS_IS_REALTIME_INODE(ip) ?
 					mp->m_rtdev_targp : mp->m_ddev_targp,
 				  BTOBB(mp->m_sb.sb_blocksize), 0);
-	if (!bp)
-		return XFS_ERROR(ENOMEM);
+	if (!bp) {
+		error = XFS_ERROR(ENOMEM);
+		goto out_unlock;
+	}
 
 	xfs_buf_unlock(bp);
 
@@ -1209,6 +1214,8 @@ xfs_zero_remaining_bytes(
 		}
 	}
 	xfs_buf_free(bp);
+out_unlock:
+	xfs_iunlock_map_shared(ip, lock_mode);
 	return error;
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
