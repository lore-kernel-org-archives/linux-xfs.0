Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0B8A47F72
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 08:20:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DFCBA8F8054
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 06:20:44 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	YTBqBXhQlF3xzcsw for <xfs@oss.sgi.com>;
	Mon, 12 Aug 2013 06:20:42 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V8s2g-0004xh-NH
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 23:20:14 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V8s2g-0007LX-MM
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 23:20:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: ***** SUSPECTED SPAM ***** [RFD 01/17] xfs: inode allocation tickets
Date: Mon, 12 Aug 2013 23:19:51 +1000
Message-Id: <1376313607-28133-2-git-send-email-david@fromorbit.com>
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

If we want to split inode allocation up into a background chunk allocator and an
indvidual free inode allocator, then we need to be able to guarantee that a free
inode will be available before we take a log reservation for the free inode
allocation.

If we don't guarantee that we can allocate an inode before we reserve log space
for the individual inode allocation, then we may reserve all the remaining log
space for the free inode allocation and then not be able to reserve space for
a ne winode chunk allocation in the log. This will cause an inode allocation
deadlock.

To avoid this deadlock, use a ticket system to guarantee an allocation has a
reserved free inode before it proceeds to the transaction reservation for the
allocation. This allows the free inode allocation to block waiting for
background allocation to allocate more inode chunks in a sane and rational
manner.

The ticket system needs to be a per-allocation group ticket, as inodes are
allocated and tracked at a per-AG granularity. Hence we need to restructure the
inode allocation code to select an AG for the new inode as early as possible
and then take a ticket on that AG. It is entirely possible that we can then get
an ENOSPC error for the inode chunk allocation, so we must be able to fall all
the way back to this ticket allocation loop to try another AG in this case.
Hauling this AG selection loop out of the internal free inode allocation code
might be sufficiently complex to warrant multiple setup patches by itself....

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_ialloc.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_ialloc.h b/fs/xfs/xfs_ialloc.h
index 68c0732..1da16f5 100644
--- a/fs/xfs/xfs_ialloc.h
+++ b/fs/xfs/xfs_ialloc.h
@@ -24,6 +24,8 @@ struct xfs_imap;
 struct xfs_mount;
 struct xfs_trans;
 
+struct xfs_ialloc_ticket;
+
 /*
  * Allocation parameters for inode allocation.
  */
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
