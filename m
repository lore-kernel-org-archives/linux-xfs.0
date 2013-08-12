Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 429E97F5A
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 08:20:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 325078F8054
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 06:20:47 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	Mh3uCGEItkGzhkZ1 for <xfs@oss.sgi.com>;
	Mon, 12 Aug 2013 06:20:45 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V8s2g-0004xn-R5
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 23:20:14 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V8s2g-0007M4-Q7
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 23:20:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: ***** SUSPECTED SPAM ***** [RFD 07/17] xfs: separate inode chunk
	freeing from inode freeing
Date: Mon, 12 Aug 2013 23:19:57 +1000
Message-Id: <1376313607-28133-8-git-send-email-david@fromorbit.com>
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

Currenetly inode chunk freeing is done when the last inode in the
inode chunk is marked as free. This results in immediate inode chunk
removal, which for some workloads is not desirable as they allocate
more inodes almost immediately (e.g. workloads with lots of
temporary or short-term files).

There are other reasons this behaviour is undesirable - if we are
allocating inode chunks in regions of stripe units or larger, we
don't want to punch holes in the middle of the inode regions as
inodes are freed - we want to keep the contiguous until we can free
them an entire stripe unit at a time. This minimises the free space
fragmentation that inode chunk removal can cause, and also prevents
interleaving of inode chunks with other data and/or metadata over
time.

Hence we should separate the inode chunk freeing from indvidual
inode freeing. The process is similar to the separation of the inode
chunk allocation - the first step is to separate out the inode btree
transaction and log reservation from the "inactive" transaction so
we can run a separate transaction after the inactive transaction has
been committed to free the inode chunk.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_trans.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index f469e72..4c80c84 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -110,7 +110,8 @@ typedef struct xfs_trans_header {
 #define	XFS_TRANS_CHECKPOINT		42
 #define	XFS_TRANS_ICREATE		43
 #define	XFS_TRANS_IALLOC_CHUNK		44
-#define	XFS_TRANS_TYPE_MAX		44
+#define	XFS_TRANS_IFREE_CHUNK		45
+#define	XFS_TRANS_TYPE_MAX		45
 /* new transaction types need to be reflected in xfs_logprint(8) */
 
 #define XFS_TRANS_TYPES \
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
