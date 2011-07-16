Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6G1LDPo228022 for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 20:21:14 -0500
Received: from e3.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7C9EE1507862
	for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 18:21:12 -0700 (PDT)
Received: from e3.ny.us.ibm.com (e3.ny.us.ibm.com [32.97.182.143]) by
	cuda.sgi.com with ESMTP id efTFdSBsCZHaadu5 for
	<xfs@oss.sgi.com>; Fri, 15 Jul 2011 18:21:12 -0700 (PDT)
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p6G0vn6Y027878
	for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 20:57:49 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p6G1LBsv163856 for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 21:21:12 -0400
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p6G1LBDs007292
	for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 19:21:11 -0600
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Fri, 15 Jul 2011 18:21:10 -0700
Message-Id: <20110716012110.6629.52933.sendpatchset@chandra-lucid.beaverton.ibm.com>
In-Reply-To: <20110716012105.6629.24407.sendpatchset@chandra-lucid.beaverton.ibm.com>
References: <20110716012105.6629.24407.sendpatchset@chandra-lucid.beaverton.ibm.com>
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
---
 fs/xfs/linux-2.6/xfs_buf.h |    1 -
 fs/xfs/xfs_trans_buf.c     |    2 +-
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
index 50a7d5f..2c78bfe 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -233,7 +233,6 @@ extern void xfs_buf_terminate(void);
 	({ char __b[BDEVNAME_SIZE]; bdevname((target)->bt_bdev, __b); __b; })
 
 
-#define XFS_BUF_BFLAGS(bp)	((bp)->b_flags)
 #define XFS_BUF_ZEROFLAGS(bp)	((bp)->b_flags &= \
 		~(XBF_READ|XBF_WRITE|XBF_ASYNC|XBF_DELWRI|XBF_ORDERED))
 
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 03b3b7f..d54b3f7 100644
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
