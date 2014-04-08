Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A68157FE7
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 22:27:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 37EEBAC017
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 20:27:34 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id N9h6HQ7qnyDsEU9a for
	<xfs@oss.sgi.com>; Mon, 07 Apr 2014 20:27:30 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s383RTWj007772
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 7 Apr 2014 23:27:29 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s383RSio014984
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 7 Apr 2014 23:27:29 -0400
Message-ID: <53436CA0.1090106@redhat.com>
Date: Mon, 07 Apr 2014 22:27:28 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs_repair: fix prefetch queue waiting
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
To: xfs-oss <xfs@oss.sgi.com>

This fixes a regression caused by:

97b1fcf xfs_repair: fix array overrun in do_inode_prefetch

The thread creation loop has 2 ways to exit; either via
the loop counter based on thread_count, or the break statement
if we've started enough workers to cover all AGs.

Whether or not the loop counter "i" reflects the number of
threads started depends on whether or not we exited via the
break.

The above commit prevented us from indexing off the end
of the queues[] array if we actually advanced "i" all the
way to thread_count, but in the case where we break, "i"
is one *less* than the nr of threads started, so we don't
wait for completion of all threads, and all hell breaks
loose in phase 5.

Just stop with the cleverness of re-using the loop counter -
instead, explicitly count threads that we start, and then use
that counter to wait for each worker to complete.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

I have one fs which demonstrates the problem, and have verified
the regression & tested the fix against that.

I'll run this over xfstests overnight, but it seems obvious
from here (OTOH the other fix seemed obvious too) :(

diff --git a/repair/prefetch.c b/repair/prefetch.c
index e47a48e..4c32395 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -944,6 +944,7 @@ do_inode_prefetch(
 	int			i;
 	struct work_queue	queue;
 	struct work_queue	*queues;
+	int			queues_started = 0;
 
 	/*
 	 * If the previous phases of repair have not overflowed the buffer
@@ -987,6 +988,7 @@ do_inode_prefetch(
 
 		create_work_queue(&queues[i], mp, 1);
 		queue_work(&queues[i], prefetch_ag_range_work, 0, wargs);
+		queues_started++;
 
 		if (wargs->end_ag >= mp->m_sb.sb_agcount)
 			break;
@@ -995,7 +997,7 @@ do_inode_prefetch(
 	/*
 	 * wait for workers to complete
 	 */
-	while (i--)
+	for (i = 0; i < queues_started; i++)
 		destroy_work_queue(&queues[i]);
 	free(queues);
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
