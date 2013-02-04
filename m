Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 02FFB7F63
	for <xfs@oss.sgi.com>; Mon,  4 Feb 2013 10:13:26 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C7F36304043
	for <xfs@oss.sgi.com>; Mon,  4 Feb 2013 08:13:22 -0800 (PST)
Received: from mail-ie0-f173.google.com (mail-ie0-f173.google.com
	[209.85.223.173]) by cuda.sgi.com with ESMTP id
	2sUVvRD5ETZOBge9 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 04 Feb 2013 08:13:21 -0800 (PST)
Received: by mail-ie0-f173.google.com with SMTP id 9so5918917iec.4
	for <xfs@oss.sgi.com>; Mon, 04 Feb 2013 08:13:20 -0800 (PST)
Message-ID: <510FDE17.9020207@inktank.com>
Date: Mon, 04 Feb 2013 10:13:11 -0600
From: Alex Elder <elder@inktank.com>
MIME-Version: 1.0
Subject: [PATCH 1/2] xfs: memory barrier before wake_up_bit()
References: <510FDDE5.4050103@inktank.com>
In-Reply-To: <510FDDE5.4050103@inktank.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

In xfs_ifunlock() there is a call to wake_up_bit() after clearing
the flush lock on the xfs inode.  This is not guaranteed to be safe,
as noted in the comments above wake_up_bit() beginning with:

    In order for this to function properly, as it uses
    waitqueue_active() internally, some kind of memory
    barrier must be done prior to calling this.

I claim no mastery of the details and subtlety of memory barrier
use, but I believe the issue is that the call to waitqueue_active()
in __wake_up_bit(), could be operating on a value of "wq" that is
out of date.  This patch fixes this by inserting a call to smp_mb()
in xfs_iunlock before calling wake_up_bit(), along the lines of
what's done in unlock_new_inode().  A litte more explanation
follows.


In __xfs_iflock(), prepare_to_wait_exclusive() adds a wait queue
entry to the end of a bit wait queue before setting the current task
state to UNINTERRUPTIBLE.  And although setting the task state
issues a full smp_mb() (which ensures changes made are visible to
the rest of the system at that point) that alone does not guarantee
that other CPUs will instantly avail themselves of the updated
value.  A separate CPU needs to issue at least a read barrier in
order to ensure the wq value it uses to determine whether there are
waiters is up-to-date, and waitqueue_active() does not do that.

I came to suspect this code because we had a customer with a system
that was hung with one or more tasks stuck in __xfs_iflock().  A
little poking around the affected code led me to the comments in
wake_up_bit().

Signed-off-by: Alex Elder <elder@inktank.com>
---
 fs/xfs/xfs_inode.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 22baf6e..237e7f6 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -419,6 +419,7 @@ static inline void xfs_iflock(struct xfs_inode *ip)
 static inline void xfs_ifunlock(struct xfs_inode *ip)
 {
 	xfs_iflags_clear(ip, XFS_IFLOCK);
+	smp_mb();
 	wake_up_bit(&ip->i_flags, __XFS_IFLOCK_BIT);
 }

-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
