Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B8B8C29E06
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 10:49:10 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 978C730407B
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 08:49:07 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id cdbrgZh5tEuv4eIn (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 06 Dec 2013 08:49:06 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1VoyaQ-0000Aw-4v
	for xfs@oss.sgi.com; Fri, 06 Dec 2013 16:49:06 +0000
Message-Id: <20131206164906.026365999@bombadil.infradead.org>
Date: Fri, 06 Dec 2013 08:48:21 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/7] xfs: take the ilock around xfs_bmapi_read in
	xfs_zero_remaining_bytes
References: <20131206164819.371654241@bombadil.infradead.org>
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
--- xfs.orig/fs/xfs/xfs_bmap_util.c	2013-12-05 22:08:41.087843028 +0100
+++ xfs/fs/xfs/xfs_bmap_util.c	2013-12-05 22:13:56.187836562 +0100
@@ -1168,9 +1168,15 @@ xfs_zero_remaining_bytes(
 	xfs_buf_unlock(bp);
 
 	for (offset = startoff; offset <= endoff; offset = lastoffset + 1) {
+		uint lock_mode;
+
 		offset_fsb = XFS_B_TO_FSBT(mp, offset);
 		nimap = 1;
+
+		lock_mode = xfs_ilock_map_shared(ip);
 		error = xfs_bmapi_read(ip, offset_fsb, 1, &imap, &nimap, 0);
+		xfs_iunlock_map_shared(ip, lock_mode);
+
 		if (error || nimap < 1)
 			break;
 		ASSERT(imap.br_blockcount >= 1);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
