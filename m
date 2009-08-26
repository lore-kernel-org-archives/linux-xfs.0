Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7QBb4wQ007696 for <xfs@oss.sgi.com>; Wed, 26 Aug 2009 06:37:22 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 21DCF3FCA41
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2009 04:37:36 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 0kypjkMnfkBtKTb4 for
	<xfs@oss.sgi.com>; Wed, 26 Aug 2009 04:37:36 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1MgGoq-00022w-Nz
	for xfs@oss.sgi.com; Wed, 26 Aug 2009 11:37:36 +0000
Date: Wed, 26 Aug 2009 07:37:36 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: use correct log reservation when handling ENOSPC in
	xfs_create
Message-ID: <20090826113736.GA15562@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

We added the ENOSPC handling patch in xfs_create just after it got mered
with xfs_mkdir.  Change the log reservation to the variable for either
the create or mkdir value so it does the right thing if get here for creating
a directory.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.c	2009-08-24 11:35:52.794261954 -0300
+++ xfs/fs/xfs/xfs_vnodeops.c	2009-08-24 11:36:25.466636450 -0300
@@ -1479,8 +1479,8 @@ xfs_create(
 	if (error == ENOSPC) {
 		/* flush outstanding delalloc blocks and retry */
 		xfs_flush_inodes(dp);
-		error = xfs_trans_reserve(tp, resblks, XFS_CREATE_LOG_RES(mp), 0,
-			XFS_TRANS_PERM_LOG_RES, XFS_CREATE_LOG_COUNT);
+		error = xfs_trans_reserve(tp, resblks, log_res, 0,
+				XFS_TRANS_PERM_LOG_RES, log_count);
 	}
 	if (error == ENOSPC) {
 		/* No space at all so try a "no-allocation" reservation */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
