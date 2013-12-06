Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2D7AE29E1A
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 14:31:31 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A9A5EAC00F
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 12:31:30 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id IiMEuo0dWtS2J7v8 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 06 Dec 2013 12:31:29 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1Vp23d-0004xw-9G
	for xfs@oss.sgi.com; Fri, 06 Dec 2013 20:31:29 +0000
Message-Id: <20131206203129.185131308@bombadil.infradead.org>
Date: Fri, 06 Dec 2013 12:30:14 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 08/11] xfs: use xfs_ilock_data_map_shared in xfs_qm_dqiterate
References: <20131206203006.914776999@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-quota-locking-2
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

Index: xfs/fs/xfs/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/xfs_qm.c	2013-12-06 17:20:27.491331600 +0100
+++ xfs/fs/xfs/xfs_qm.c	2013-12-06 19:39:27.251160455 +0100
@@ -1193,16 +1193,18 @@ xfs_qm_dqiterate(
 	lblkno = 0;
 	maxlblkcnt = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
 	do {
+		uint		lock_mode;
+
 		nmaps = XFS_DQITER_MAP_SIZE;
 		/*
 		 * We aren't changing the inode itself. Just changing
 		 * some of its data. No new blocks are added here, and
 		 * the inode is never added to the transaction.
 		 */
-		xfs_ilock(qip, XFS_ILOCK_SHARED);
+		lock_mode = xfs_ilock_data_map_shared(qip);
 		error = xfs_bmapi_read(qip, lblkno, maxlblkcnt - lblkno,
 				       map, &nmaps, 0);
-		xfs_iunlock(qip, XFS_ILOCK_SHARED);
+		xfs_iunlock(qip, lock_mode);
 		if (error)
 			break;
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
