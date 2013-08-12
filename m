Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 625EF7F81
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 08:20:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 43616304043
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 06:20:51 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	0rXjZoEFUKUolDeW for <xfs@oss.sgi.com>;
	Mon, 12 Aug 2013 06:20:49 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V8s2h-0004xy-04
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 23:20:15 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V8s2g-0007Mi-V6
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 23:20:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: ***** SUSPECTED SPAM ***** [RFD 15/17] xfs: introduce a method vector
	for unlinked list operations
Date: Mon, 12 Aug 2013 23:20:05 +1000
Message-Id: <1376313607-28133-16-git-send-email-david@fromorbit.com>
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

Filesystems with V3 inodes can log unlinked inode list modifications
as part of the inode core without needing to use the inode buffers
to log the list modifications or walk the list. However, this
requires a very different method of implementing the unlinked lists,
and so it makes sense to factor out the unlinked list implementation
into a pair of vectored operations for adding and removing the inode
from the current unlinked list.

Add an operations vector to the struct xfs_inode and hook it up so
that all inodes use it to call the current linked list manipulation
functions.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index b55fd34..2bb7060 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -22,6 +22,8 @@ struct posix_acl;
 struct xfs_dinode;
 struct xfs_inode;
 
+struct xfs_iops;
+
 /*
  * Fork identifiers.
  */
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
