Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E28CE29E28
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 14:31:32 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 79C20AC004
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 12:31:29 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id khamB6DJaM0Bq53Y (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 06 Dec 2013 12:31:28 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1Vp23c-0004tr-9C
	for xfs@oss.sgi.com; Fri, 06 Dec 2013 20:31:28 +0000
Message-Id: <20131206203128.196574675@bombadil.infradead.org>
Date: Fri, 06 Dec 2013 12:30:07 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 01/11] xfs: no need to lock the inode in xfs_find_handle
References: <20131206203006.914776999@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-fix-xfs_find_handle-locking
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

Both the inode number and the generation do not change on a live inode.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_ioctl.c
===================================================================
--- xfs.orig/fs/xfs/xfs_ioctl.c	2013-12-06 19:16:33.819188640 +0100
+++ xfs/fs/xfs/xfs_ioctl.c	2013-12-06 19:17:04.087188019 +0100
@@ -112,15 +112,11 @@ xfs_find_handle(
 		memset(&handle.ha_fid, 0, sizeof(handle.ha_fid));
 		hsize = sizeof(xfs_fsid_t);
 	} else {
-		int		lock_mode;
-
-		lock_mode = xfs_ilock_map_shared(ip);
 		handle.ha_fid.fid_len = sizeof(xfs_fid_t) -
 					sizeof(handle.ha_fid.fid_len);
 		handle.ha_fid.fid_pad = 0;
 		handle.ha_fid.fid_gen = ip->i_d.di_gen;
 		handle.ha_fid.fid_ino = ip->i_ino;
-		xfs_iunlock_map_shared(ip, lock_mode);
 
 		hsize = XFS_HSIZE(handle);
 	}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
