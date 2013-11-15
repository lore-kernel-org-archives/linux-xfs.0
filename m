Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6682B7F9D
	for <xfs@oss.sgi.com>; Fri, 15 Nov 2013 11:38:49 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 36B1C304059
	for <xfs@oss.sgi.com>; Fri, 15 Nov 2013 09:38:49 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id b1Xx0EGNAAjGcL0C (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 15 Nov 2013 09:38:48 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1VhNM0-0006TQ-3J
	for xfs@oss.sgi.com; Fri, 15 Nov 2013 17:38:48 +0000
Date: Fri, 15 Nov 2013 09:38:48 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: remove unused FI_ flags
Message-ID: <20131115173848.GA24872@infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_vnode.h |    9 ---------
 1 file changed, 9 deletions(-)

Index: xfs/fs/xfs/xfs_vnode.h
===================================================================
--- xfs.orig/fs/xfs/xfs_vnode.h	2013-10-11 17:03:21.244338013 +0100
+++ xfs/fs/xfs/xfs_vnode.h	2013-10-22 07:21:09.236045186 +0100
@@ -35,15 +35,6 @@ struct attrlist_cursor_kern;
 	{ IO_INVIS,	"INVIS"}
 
 /*
- * Flush/Invalidate options for vop_toss/flush/flushinval_pages.
- */
-#define FI_NONE			0	/* none */
-#define FI_REMAPF		1	/* Do a remapf prior to the operation */
-#define FI_REMAPF_LOCKED	2	/* Do a remapf prior to the operation.
-					   Prevent VM access to the pages until
-					   the operation completes. */
-
-/*
  * Some useful predicates.
  */
 #define VN_MAPPED(vp)	mapping_mapped(vp->i_mapping)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
