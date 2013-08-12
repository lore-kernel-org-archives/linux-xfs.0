Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 07FA07F6D
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 08:20:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E958B304043
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 06:20:47 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	geyLX0f9f5fq9cRI for <xfs@oss.sgi.com>;
	Mon, 12 Aug 2013 06:20:46 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V8s2g-0004xo-Re
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 23:20:14 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V8s2g-0007M9-Qj
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 23:20:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: ***** SUSPECTED SPAM ***** [RFD 08/17] xfs: inode chunk freeing in
	the background
Date: Mon, 12 Aug 2013 23:19:58 +1000
Message-Id: <1376313607-28133-9-git-send-email-david@fromorbit.com>
In-Reply-To: <1376313607-28133-1-git-send-email-david@fromorbit.com>
References: <1376313607-28133-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Now that inode chunk freeing has been separated from freeing indivdiual inodes
we no longer need to do it in-line with the high level unlink inode operation.
As such, we can move inode chunk freeing into a workqueue and trigger it to run
asynchronously.

Moving the chunk freeing to the background allows us to delay the decision to
free the inode chunk and further optimise inode chunk freeing according to the
current workload.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_ag.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_ag.h b/fs/xfs/xfs_ag.h
index 1a97646..b34f641 100644
--- a/fs/xfs/xfs_ag.h
+++ b/fs/xfs/xfs_ag.h
@@ -253,6 +253,7 @@ typedef struct xfs_perag {
 	xfs_agino_t	pagi_count;	/* number of allocated inodes */
 
 	int		pagi_chunk_alloc_rate;
+	int		pagi_chunk_free_rate;
 
 	/*
 	 * Inode allocation search lookup optimisation.
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
