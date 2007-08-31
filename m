Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 30 Aug 2007 21:43:05 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7V4h14p015575
	for <xfs@oss.sgi.com>; Thu, 30 Aug 2007 21:43:03 -0700
Message-ID: <46D79C62.1010304@sandeen.net>
Date: Thu, 30 Aug 2007 23:43:14 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] Increase lockdep MAX_LOCK_DEPTH
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: xfs-oss <xfs@oss.sgi.com>

The xfs filesystem can exceed the current lockdep 
MAX_LOCK_DEPTH, because when deleting an entire cluster of inodes,
they all get locked in xfs_ifree_cluster().  The normal cluster
size is 8192 bytes, and with the default (and minimum) inode size 
of 256 bytes, that's up to 32 inodes that get locked.  Throw in a 
few other locks along the way, and 40 seems enough to get me through
all the tests in the xfsqa suite on 4k blocks.  (block sizes
above 8K will still exceed this though, I think)

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Index: linux-2.6.23-rc3/include/linux/sched.h
===================================================================
--- linux-2.6.23-rc3.orig/include/linux/sched.h
+++ linux-2.6.23-rc3/include/linux/sched.h
@@ -1125,7 +1125,7 @@ struct task_struct {
 	int softirq_context;
 #endif
 #ifdef CONFIG_LOCKDEP
-# define MAX_LOCK_DEPTH 30UL
+# define MAX_LOCK_DEPTH 40UL
 	u64 curr_chain_key;
 	int lockdep_depth;
 	struct held_lock held_locks[MAX_LOCK_DEPTH];
