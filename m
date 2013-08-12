Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C83777F81
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 08:20:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B7DF9304043
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 06:20:51 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	AefabgICxIj53bCf for <xfs@oss.sgi.com>;
	Mon, 12 Aug 2013 06:20:50 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V8s2h-0004y0-0l
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 23:20:15 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V8s2g-0007Mn-Vx
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 23:20:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: ***** SUSPECTED SPAM ***** [RFD 16/17] xfs: add in-core unlinked list
	for v3 inodes
Date: Mon, 12 Aug 2013 23:20:06 +1000
Message-Id: <1376313607-28133-17-git-send-email-david@fromorbit.com>
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

The first step in optimising unlinked list processing for v3 inodes
is to avoid having to walk the inode buffers to find the next inode
in the list. By definition, inodes on the unlinked list must be in
the inode cache and so we can add a set of incore hash lists to the
struct xfs_perag that match the on disk structure.

This allows us to use in-core locks rather than buffer locks to
provide exclusion for walking and manipulating the list. It also
allows us to use double linked lists so we don't need to walk the
list to find the adjacent inode on the list that needs to be
modified when we remove an inode from the unlinked list.

Further, it allows us to keep track of the tail of the unlinked list
so we can add inodes to the tail of the list instead of the head.
The combination of incore locking and adding inodes to the tail of
the unlinked lists means we can avoid locking the AGI during
additions to the unlinked list (execpt when the list is empty),
meaning we can execute concurrent list modifications safely when the
AGI itself doesn't need direct modification as part of the
operation.  This removes a significant serialisation point from the
unlink(2) path.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_ag.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_ag.h b/fs/xfs/xfs_ag.h
index c423191..17f7d43 100644
--- a/fs/xfs/xfs_ag.h
+++ b/fs/xfs/xfs_ag.h
@@ -235,6 +235,8 @@ typedef struct xfs_agfl {
  */
 #define XFS_PAGB_NUM_SLOTS	128
 
+struct xfs_iunlink_list;
+
 typedef struct xfs_perag {
 	struct xfs_mount *pag_mount;	/* owner filesystem */
 	xfs_agnumber_t	pag_agno;	/* AG this structure belongs to */
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
