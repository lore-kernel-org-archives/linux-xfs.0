Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 112D77F87
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 08:20:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E2A56304043
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 06:20:50 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	GSad75LerHnk0Gft for <xfs@oss.sgi.com>;
	Mon, 12 Aug 2013 06:20:49 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V8s2g-0004xq-SH
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 23:20:15 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V8s2g-0007ME-RJ
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 23:20:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: ***** SUSPECTED SPAM ***** [RFD 09/17] xfs: optimise inode chunk
	freeing
Date: Mon, 12 Aug 2013 23:19:59 +1000
Message-Id: <1376313607-28133-10-git-send-email-david@fromorbit.com>
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

Now that the inode chunk freeing is done asynchronously, we can make
more intelligent decisions about freeing inode chunks. As we have a
inode btree that tracks free inodes, we can quickly find out whether
the adjacent inode chunks are free. We can then match inode chunk
freeing patterns to the allocation patterns that are in use.

We can also track the rate at which we are freeing inode chunks and
compare that to the rate at which we are allocating inode chunks. If
we are both allocating and freeing inode chunks, then we should slow
down the rate at which we are freeing inode chunks so that
allocation can occur directly from the empty inode chunks rather
than forcing them to be reallocated shortly after then have been
freed.

Further, for sequential chunks we should be able to implement bulk
removal of the records from the inode btrees as long as we can
guarantee that it only results in a single merge operation. The
constraints and processes would be similar to the bulk insert
operation proposed for inode allocation.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_ag.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_ag.h b/fs/xfs/xfs_ag.h
index b34f641..c423191 100644
--- a/fs/xfs/xfs_ag.h
+++ b/fs/xfs/xfs_ag.h
@@ -254,6 +254,7 @@ typedef struct xfs_perag {
 
 	int		pagi_chunk_alloc_rate;
 	int		pagi_chunk_free_rate;
+	xfs_agino_t	pagi_free_chunk;
 
 	/*
 	 * Inode allocation search lookup optimisation.
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
