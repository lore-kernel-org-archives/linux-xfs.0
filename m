Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4VG6ZP0178980 for <xfs@oss.sgi.com>; Mon, 31 May 2010 11:06:35 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9AE13387869
	for <xfs@oss.sgi.com>; Mon, 31 May 2010 09:09:02 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 0pNhtVY5i5Rz6YSA for
	<xfs@oss.sgi.com>; Mon, 31 May 2010 09:09:02 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1OJ7Xy-00018V-9X
	for xfs@oss.sgi.com; Mon, 31 May 2010 16:09:02 +0000
Message-Id: <20100531160902.179351623@bombadil.infradead.org>
Date: Mon, 31 May 2010 12:07:42 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 15/17] xfs: remove the unused XFS_TRANS_NOSLEEP/XFS_TRANS_WAIT
	flags
References: <20100531160727.842750532@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-dead-trans-flags
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

Index: xfs/fs/xfs/xfs_trans.h
===================================================================
--- xfs.orig/fs/xfs/xfs_trans.h	2010-05-29 18:12:37.780017895 +0200
+++ xfs/fs/xfs/xfs_trans.h	2010-05-29 18:23:22.618003507 +0200
@@ -184,8 +184,6 @@ struct xfs_log_item_desc {
 /*
  * Values for call flags parameter.
  */
-#define	XFS_TRANS_NOSLEEP		0x1
-#define	XFS_TRANS_WAIT			0x2
 #define	XFS_TRANS_RELEASE_LOG_RES	0x4
 #define	XFS_TRANS_ABORT			0x8
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
