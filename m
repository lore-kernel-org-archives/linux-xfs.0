Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2RGkn9k128454 for <xfs@oss.sgi.com>; Tue, 27 Mar 2012 11:46:49 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	rIyQ7ZJSwWhM9Ood (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 27 Mar 2012 09:46:48 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1SCZXj-0007EJ-9t
	for xfs@oss.sgi.com; Tue, 27 Mar 2012 16:46:47 +0000
Message-Id: <20120327164647.258334763@bombadil.infradead.org>
Date: Tue, 27 Mar 2012 12:44:10 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 10/10] xfs: remove some obsolete comments in xfs_trans_ail.c
References: <20120327164400.967415009@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-cleanup-ail-comments
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_trans_ail.c |   14 --------------
 1 file changed, 14 deletions(-)

Index: xfs/fs/xfs/xfs_trans_ail.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_ail.c	2012-03-25 17:16:19.787923358 +0200
+++ xfs/fs/xfs/xfs_trans_ail.c	2012-03-25 17:16:37.094590345 +0200
@@ -760,20 +760,6 @@ xfs_trans_ail_delete_bulk(
 	}
 }
 
-/*
- * The active item list (AIL) is a doubly linked list of log
- * items sorted by ascending lsn.  The base of the list is
- * a forw/back pointer pair embedded in the xfs mount structure.
- * The base is initialized with both pointers pointing to the
- * base.  This case always needs to be distinguished, because
- * the base has no lsn to look at.  We almost always insert
- * at the end of the list, so on inserts we search from the
- * end of the list to find where the new item belongs.
- */
-
-/*
- * Initialize the doubly linked list to point only to itself.
- */
 int
 xfs_trans_ail_init(
 	xfs_mount_t	*mp)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
