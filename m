Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 016B17F54
	for <xfs@oss.sgi.com>; Thu,  5 Dec 2013 09:59:53 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D10B2304071
	for <xfs@oss.sgi.com>; Thu,  5 Dec 2013 07:59:52 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id GWvc0KWd8NAI6fhH (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 05 Dec 2013 07:59:51 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1VobLD-0004wr-KF
	for xfs@oss.sgi.com; Thu, 05 Dec 2013 15:59:51 +0000
Message-Id: <20131205155951.506063990@bombadil.infradead.org>
Date: Thu, 05 Dec 2013 07:58:33 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/5] xfs: use xfs_ilock_map_shared in xfs_qm_dqiterate
References: <20131205155830.620826868@bombadil.infradead.org>
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
--- xfs.orig/fs/xfs/xfs_qm.c	2013-11-18 14:39:01.967589998 +0100
+++ xfs/fs/xfs/xfs_qm.c	2013-12-05 12:32:36.623617997 +0100
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
+		lock_mode = xfs_ilock_map_shared(qip);
 		error = xfs_bmapi_read(qip, lblkno, maxlblkcnt - lblkno,
 				       map, &nmaps, 0);
-		xfs_iunlock(qip, XFS_ILOCK_SHARED);
+		xfs_iunlock_map_shared(qip, lock_mode);
 		if (error)
 			break;
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
