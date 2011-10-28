Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9SA3cpm145311 for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 05:03:38 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EF2DD20384D
	for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 03:03:37 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	RJvNAh6nNycFd90g for <xfs@oss.sgi.com>;
	Fri, 28 Oct 2011 03:03:37 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RJjHl-0002vp-Em
	for xfs@oss.sgi.com; Fri, 28 Oct 2011 10:03:37 +0000
Message-Id: <20111028100337.411618173@bombadil.infradead.org>
Date: Fri, 28 Oct 2011 05:54:33 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 10/45] fix: force shutdown handling in xfs_end_io
References: <20111028095423.796574703@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-fix-end-io-error-handling
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

Only ioend->io_error gets propagated back to e.g. AIO completions.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_aops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: xfs/fs/xfs/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_aops.c	2011-10-27 22:39:56.068672482 +0200
+++ xfs/fs/xfs/xfs_aops.c	2011-10-27 22:39:56.902173367 +0200
@@ -184,7 +184,7 @@ xfs_end_io(
 	int		error = 0;
 
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
-		error = -EIO;
+		ioend->io_error = -EIO;
 		goto done;
 	}
 	if (ioend->io_error)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
