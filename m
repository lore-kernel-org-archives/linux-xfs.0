Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA88wnuW101994 for <xfs@oss.sgi.com>; Tue, 8 Nov 2011 02:58:50 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F1AE116243AF
	for <xfs@oss.sgi.com>; Tue,  8 Nov 2011 00:58:46 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	jEUeUFcIqkOfzW9J for <xfs@oss.sgi.com>;
	Tue, 08 Nov 2011 00:58:46 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RNhW2-0007ZY-4P
	for xfs@oss.sgi.com; Tue, 08 Nov 2011 08:58:46 +0000
Message-Id: <20111108085846.083679026@bombadil.infradead.org>
Date: Tue, 08 Nov 2011 03:56:15 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/5] fix: force shutdown handling in xfs_end_io
References: <20111108085614.478431403@bombadil.infradead.org>
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

Index: linux-2.6/fs/xfs/xfs_aops.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_aops.c	2011-11-02 09:00:45.569119028 +0100
+++ linux-2.6/fs/xfs/xfs_aops.c	2011-11-07 12:19:22.282316090 +0100
@@ -189,7 +189,7 @@ xfs_end_io(
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
