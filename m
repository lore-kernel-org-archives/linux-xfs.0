Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6AKoLGL153467 for <xfs@oss.sgi.com>; Sun, 10 Jul 2011 15:50:21 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2CCCE15EED40
	for <xfs@oss.sgi.com>; Sun, 10 Jul 2011 13:50:18 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	tZbA8fiqBfCEy4we for <xfs@oss.sgi.com>;
	Sun, 10 Jul 2011 13:50:18 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1Qg0xG-0002wr-BX
	for xfs@oss.sgi.com; Sun, 10 Jul 2011 20:50:18 +0000
Message-Id: <20110710205018.325145774@bombadil.infradead.org>
Date: Sun, 10 Jul 2011 16:49:24 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 08/11] xfs: remove the unused xfs_buf_delwri_sort function
References: <20110710204916.856267100@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-xfs_buf_delwri_sort
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

Index: xfs/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_buf.c	2011-07-09 12:26:19.035110293 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_buf.c	2011-07-09 12:26:36.285109419 +0200
@@ -1721,14 +1721,6 @@ xfs_buf_cmp(
 	return 0;
 }
 
-void
-xfs_buf_delwri_sort(
-	xfs_buftarg_t	*target,
-	struct list_head *list)
-{
-	list_sort(NULL, list, xfs_buf_cmp);
-}
-
 STATIC int
 xfsbufd(
 	void		*data)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
