Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1K2nuB4042726 for <xfs@oss.sgi.com>; Sun, 19 Feb 2012 20:49:56 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	mfd11Dxb3SAd0dGM (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 19 Feb 2012 18:31:53 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RzJ2e-0005dP-9R
	for xfs@oss.sgi.com; Mon, 20 Feb 2012 02:31:52 +0000
Message-Id: <20120220023152.240595946@bombadil.infradead.org>
Date: Sun, 19 Feb 2012 21:31:21 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 02/12] xfs: do exact log space wakeups in
	xlog_ungrant_log_space
References: <20120220023119.435889631@bombadil.infradead.org>
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

Reviewed-by: Ben Myers <bpm@sgi.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
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
