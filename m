Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBCEEa51101943 for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 08:14:36 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 79BFF16EEFCA
	for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 06:14:34 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	ZEX9WGiu0b5roUgv for <xfs@oss.sgi.com>;
	Mon, 12 Dec 2011 06:14:34 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1Ra6eH-0007s9-OZ
	for xfs@oss.sgi.com; Mon, 12 Dec 2011 14:14:33 +0000
Message-Id: <20111212141433.714245384@bombadil.infradead.org>
Date: Mon, 12 Dec 2011 09:13:49 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [patch 02/12] xfs: do exact log space wakeups in
	xlog_ungrant_log_space
References: <20111212141346.986825692@bombadil.infradead.org>
Content-Disposition: inline;
	filename=xfs-exact-wakeups-in-xlog_ungrant_log_space
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

The only reason that xfs_log_space_wake had to do opportunistic wakeups
was that the old xfs_log_move_tail calling convention didn't allow for
exact wakeups when not updating the log tail LSN.  Since this issue has
been fixed we can do exact wakeups now.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_log.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: xfs/fs/xfs/xfs_log.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log.c	2011-12-11 15:30:49.977750776 +0100
+++ xfs/fs/xfs/xfs_log.c	2011-12-11 17:49:00.692836117 +0100
@@ -2748,7 +2748,7 @@ xlog_ungrant_log_space(xlog_t	     *log,
 
 	trace_xfs_log_ungrant_exit(log, ticket);
 
-	xfs_log_space_wake(log->l_mp, true);
+	xfs_log_space_wake(log->l_mp, false);
 }
 
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
