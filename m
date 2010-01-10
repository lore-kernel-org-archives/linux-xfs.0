Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0ANtCuo064706 for <xfs@oss.sgi.com>; Sun, 10 Jan 2010 17:55:12 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9EB43EF1ABB
	for <xfs@oss.sgi.com>; Sun, 10 Jan 2010 15:56:05 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	FEirSPANuzJxzQE9 for <xfs@oss.sgi.com>;
	Sun, 10 Jan 2010 15:56:05 -0800 (PST)
Received: from discord (unverified [121.44.168.156])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11502689-1927428
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 10:26:04 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NU7da-0002qW-MI
	for xfs@oss.sgi.com; Mon, 11 Jan 2010 10:56:02 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NU7ZY-0007Yx-NK
	for xfs@oss.sgi.com; Mon, 11 Jan 2010 10:51:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/4] xfs: Remove inode iolock held check during allocation
Date: Mon, 11 Jan 2010 10:51:48 +1100
Message-Id: <1263167508-9346-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1263167508-9346-1-git-send-email-david@fromorbit.com>
References: <1263167508-9346-1-git-send-email-david@fromorbit.com>
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

lockdep complains about a the lock not being initialised as we do
an ASSERT based check that the lock is not held before we initialise
it to catch inodes freed with the lock held.

lockdep does this check for us in the lock initialisation code, so
remove the ASSERT to stop the lockdep warning.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_iget.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index fa402a6..155e798 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -73,7 +73,6 @@ xfs_inode_alloc(
 	ASSERT(atomic_read(&ip->i_pincount) == 0);
 	ASSERT(!spin_is_locked(&ip->i_flags_lock));
 	ASSERT(completion_done(&ip->i_flush));
-	ASSERT(!rwsem_is_locked(&ip->i_iolock.mr_lock));
 
 	mrlock_init(&ip->i_iolock, MRLOCK_BARRIER, "xfsio", ip->i_ino);
 
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
