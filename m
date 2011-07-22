Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6M0WkjP051379 for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 19:32:46 -0500
Received: from e2.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F13128C6E5
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 17:32:45 -0700 (PDT)
Received: from e2.ny.us.ibm.com (e2.ny.us.ibm.com [32.97.182.142]) by
	cuda.sgi.com with ESMTP id pXx0e9Y2VwuGfT5c for
	<xfs@oss.sgi.com>; Thu, 21 Jul 2011 17:32:45 -0700 (PDT)
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by e2.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p6M0BWBX030798
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 20:11:32 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p6M0Whmu1675410
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 20:32:43 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p6M0Wgwp014340 for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 21:32:42 -0300
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Thu, 21 Jul 2011 17:32:35 -0700
Message-Id: <20110722003235.21069.37370.sendpatchset@chandra-lucid.beaverton.ibm.com>
In-Reply-To: <20110722003226.21069.58401.sendpatchset@chandra-lucid.beaverton.ibm.com>
References: <20110722003226.21069.58401.sendpatchset@chandra-lucid.beaverton.ibm.com>
Subject: [PATCH 01/12] xfs: Remove the macro XFS_BUF_BFLAGS
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
Cc: Chandra Seetharaman <sekharan@us.ibm.com>

Remove the definition of the macro XFS_BUF_BFLAGS and its usage.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/linux-2.6/xfs_buf.c |    2 +-
 fs/xfs/linux-2.6/xfs_buf.h |    1 -
 fs/xfs/xfs_trans_buf.c     |    2 +-
 3 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index b2b4119..969fd15 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -1094,7 +1094,7 @@ STATIC int
 xfs_bioerror_relse(
 	struct xfs_buf	*bp)
 {
-	int64_t		fl = XFS_BUF_BFLAGS(bp);
+	int64_t		fl = bp->b_flags;
 	/*
 	 * No need to wait until the buffer is unpinned.
 	 * We aren't flushing it.
diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
index 6a83b46..6b6c25f 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -232,7 +232,6 @@ extern void xfs_buf_terminate(void);
 	({ char __b[BDEVNAME_SIZE]; bdevname((target)->bt_bdev, __b); __b; })
 
 
-#define XFS_BUF_BFLAGS(bp)	((bp)->b_flags)
 #define XFS_BUF_ZEROFLAGS(bp) \
 	((bp)->b_flags &= ~(XBF_READ|XBF_WRITE|XBF_ASYNC|XBF_DELWRI| \
 			    XBF_SYNCIO|XBF_FUA|XBF_FLUSH))
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 15584fc..1bc04d4 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -430,7 +430,7 @@ shutdown_abort:
 	if (XFS_BUF_ISSTALE(bp) && XFS_BUF_ISDELAYWRITE(bp))
 		xfs_notice(mp, "about to pop assert, bp == 0x%p", bp);
 #endif
-	ASSERT((XFS_BUF_BFLAGS(bp) & (XBF_STALE|XBF_DELWRI)) !=
+	ASSERT((bp->b_flags & (XBF_STALE|XBF_DELWRI)) !=
 				     (XBF_STALE|XBF_DELWRI));
 
 	trace_xfs_trans_read_buf_shut(bp, _RET_IP_);
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
