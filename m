Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9299B7F75
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 08:20:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 785F58F8054
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 06:20:49 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	qUGEteOzRx82GqdX for <xfs@oss.sgi.com>;
	Mon, 12 Aug 2013 06:20:48 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V8s2h-0004y1-1B
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 23:20:15 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V8s2h-0007Ms-0H
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 23:20:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: ***** SUSPECTED SPAM ***** [RFD 17/17] xfs: log unlinked list
	modifications in the incore v3 inode
Date: Mon, 12 Aug 2013 23:20:07 +1000
Message-Id: <1376313607-28133-18-git-send-email-david@fromorbit.com>
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

Now that we have incore unlinked lists and try-lock capability for
unlinked list removal operations, we can now switch the v3 inodes to
use transactions that directly modify and log the in-core inode
unlinked list pointers.

To do this, we need to lock the inode that points to the current
inode and update it's unlinked list pointer and log it. With that
modification, the current inode has been removed from the unlinked
list. If the current inode is at the head of the unlinked list, then
instead of an inode modification we need to modify the AGI unlinked
bucket pointer.

This can all be contained within the .iunlink_remove() method for v3
inodes, but we have to be careful about locking the previous inode -
it needs to use trylock semantics so we don't introduce deadlock
problems, and that means we need to ensure that the xfs_ifree path
handles EAGAIN errors correctly and passes it back to the caller so
that it can be retried again at a later time.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 2bb7060..4c10fa9 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -253,6 +253,7 @@ typedef struct xfs_inode {
 	struct xfs_dquot	*i_udquot;	/* user dquot */
 	struct xfs_dquot	*i_gdquot;	/* group dquot */
 	struct xfs_dquot	*i_pdquot;	/* project dquot */
+	struct list_head	i_unlink_list;
 
 	/* Inode location stuff */
 	xfs_ino_t		i_ino;		/* inode number (agno/agino)*/
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
