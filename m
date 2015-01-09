Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8D8597F47
	for <xfs@oss.sgi.com>; Fri,  9 Jan 2015 12:12:10 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1D83CAC006
	for <xfs@oss.sgi.com>; Fri,  9 Jan 2015 10:12:06 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id G9yaoX7oKqUUDDq1 for <xfs@oss.sgi.com>;
	Fri, 09 Jan 2015 10:12:05 -0800 (PST)
Message-ID: <54B019F4.8030009@sandeen.net>
Date: Fri, 09 Jan 2015 12:12:04 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 2/2] xfs: mark the xfs-alloc workqueue as high priority
References: <54B01927.2010506@redhat.com>
In-Reply-To: <54B01927.2010506@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>
Cc: Tejun Heo <tj@kernel.org>

I had a case reported where a system under high stress
got deadlocked.  A btree split was handed off to the xfs
allocation workqueue, and it is holding the xfs_ilock
exclusively.  However, other xfs_end_io workers are
not running, because they are waiting for that lock.
As a result, the xfs allocation workqueue never gets
run, and everything grinds to a halt.

To be honest, it's not clear to me how the workqueue
subsystem manages this sort of thing.  But in testing,
making the allocation workqueue high priority so that
it gets added to the front of the pending work list,
resolves the problem.  We did similar things for
the xfs-log workqueues, for similar reasons.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

(slight whitespace shift is to fit in 80 cols, sorry!)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index e5bdca9..9c549e1 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -874,7 +874,7 @@ xfs_init_mount_workqueues(
 		goto out_destroy_log;
 
 	mp->m_alloc_workqueue = alloc_workqueue("xfs-alloc/%s",
-			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0, mp->m_fsname);
+		       WQ_MEM_RECLAIM|WQ_FREEZABLE|WQ_HIGHPRI, 0, mp->m_fsname);
 	if (!mp->m_alloc_workqueue)
 		goto out_destroy_eofblocks;
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
