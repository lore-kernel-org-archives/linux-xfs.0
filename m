Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9AGrTx9189853 for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 11:53:29 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 910CD1C7C9D4
	for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 09:53:28 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	cFqtVVvZmmNmFtHU for <xfs@oss.sgi.com>;
	Mon, 10 Oct 2011 09:53:28 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RDJ6W-0008HN-32
	for xfs@oss.sgi.com; Mon, 10 Oct 2011 16:53:28 +0000
Message-Id: <20111010165328.053475674@bombadil.infradead.org>
Date: Mon, 10 Oct 2011 12:52:51 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 09/11] xfs: remove xfs_buf_target_name
References: <20111010165242.656850411@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-xfs_buf_target_name
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

The calling convention that returns a pointer to a static buffer is
fairly nasty, so just opencode it in the only caller that is left.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alex Elder <aelder@sgi.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>

Index: xfs/fs/xfs/xfs_buf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_buf.c	2011-10-07 16:40:30.765017266 +0200
+++ xfs/fs/xfs/xfs_buf.c	2011-10-09 16:32:03.385324804 +0200
@@ -1457,9 +1457,13 @@ xfs_setsize_buftarg_flags(
 	btp->bt_smask = sectorsize - 1;
 
 	if (set_blocksize(btp->bt_bdev, sectorsize)) {
+		char name[BDEVNAME_SIZE];
+
+		bdevname(btp->bt_bdev, name);
+
 		xfs_warn(btp->bt_mount,
 			"Cannot set_blocksize to %u on device %s\n",
-			sectorsize, xfs_buf_target_name(btp));
+			sectorsize, name);
 		return EINVAL;
 	}
 
Index: xfs/fs/xfs/xfs_buf.h
===================================================================
--- xfs.orig/fs/xfs/xfs_buf.h	2011-10-07 16:40:30.769018056 +0200
+++ xfs/fs/xfs/xfs_buf.h	2011-10-09 16:31:46.237323692 +0200
@@ -230,15 +230,6 @@ extern void xfs_buf_delwri_promote(struc
 extern int xfs_buf_init(void);
 extern void xfs_buf_terminate(void);
 
-static inline const char *
-xfs_buf_target_name(struct xfs_buftarg *target)
-{
-	static char __b[BDEVNAME_SIZE];
-
-	return bdevname(target->bt_bdev, __b);
-}
-
-
 #define XFS_BUF_ZEROFLAGS(bp) \
 	((bp)->b_flags &= ~(XBF_READ|XBF_WRITE|XBF_ASYNC|XBF_DELWRI| \
 			    XBF_SYNCIO|XBF_FUA|XBF_FLUSH))

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
