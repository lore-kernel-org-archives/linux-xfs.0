Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6M5V4xF120778 for <xfs@oss.sgi.com>; Thu, 22 Jul 2010 00:31:05 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 99B36466619
	for <xfs@oss.sgi.com>; Wed, 21 Jul 2010 22:34:06 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id iYo8F88bkMKoFWPI for
	<xfs@oss.sgi.com>; Wed, 21 Jul 2010 22:34:06 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1OboMz-0000Sc-8u
	for xfs@oss.sgi.com; Thu, 22 Jul 2010 05:30:57 +0000
Date: Thu, 22 Jul 2010 01:30:57 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs_io: allow resvsp command for foreign filesystems
Message-ID: <20100722053057.GA1768@infradead.org>
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

Recent kernels implement the RESVP ioctl in common code, so using
command for non-XFS filesystems is fine.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/io/prealloc.c
===================================================================
--- xfsprogs-dev.orig/io/prealloc.c	2010-07-21 19:11:34.943494680 +0200
+++ xfsprogs-dev/io/prealloc.c	2010-07-21 19:11:57.093494680 +0200
@@ -182,7 +182,7 @@ prealloc_init(void)
 	resvsp_cmd.cfunc = resvsp_f;
 	resvsp_cmd.argmin = 2;
 	resvsp_cmd.argmax = 2;
-	resvsp_cmd.flags = CMD_NOMAP_OK;
+	resvsp_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
 	resvsp_cmd.args = _("off len");
 	resvsp_cmd.oneline =
 		_("reserves space associated with part of a file");

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
