Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA88t3PW089563 for <xfs@oss.sgi.com>; Mon, 8 Nov 2010 02:55:03 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EF6E91398EE4
	for <xfs@oss.sgi.com>; Mon,  8 Nov 2010 00:56:28 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	aJdLF3TYTfYqQ16k for <xfs@oss.sgi.com>;
	Mon, 08 Nov 2010 00:56:28 -0800 (PST)
Received: from dastard (unverified [121.44.100.105])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	45631768-1927428
	for <xfs@oss.sgi.com>; Mon, 08 Nov 2010 19:26:27 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1PFNWS-0001CS-Ce
	for xfs@oss.sgi.com; Mon, 08 Nov 2010 19:56:16 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PFNVa-0004nJ-IB
	for xfs@oss.sgi.com; Mon, 08 Nov 2010 19:55:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 01/16] xfs: fix per-ag reference counting in inode reclaim
	tree walking
Date: Mon,  8 Nov 2010 19:55:04 +1100
Message-Id: <1289206519-18377-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1289206519-18377-1-git-send-email-david@fromorbit.com>
References: <1289206519-18377-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

The walk fails to decrement the per-ag reference count when the
non-blocking walk fails to obtain the per-ag reclaim lock, leading
to an assert failure on debug kernels when unmounting a filesystem.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_sync.c |    1 +
 fs/xfs/xfs_mount.c          |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index 37d3325..afb0d7c 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -853,6 +853,7 @@ restart:
 		if (trylock) {
 			if (!mutex_trylock(&pag->pag_ici_reclaim_lock)) {
 				skipped++;
+				xfs_perag_put(pag);
 				continue;
 			}
 			first_index = pag->pag_ici_reclaim_cursor;
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index b1498ab..19e9dfa 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -275,6 +275,7 @@ xfs_free_perag(
 		pag = radix_tree_delete(&mp->m_perag_tree, agno);
 		spin_unlock(&mp->m_perag_lock);
 		ASSERT(pag);
+		ASSERT(atomic_read(&pag->pag_ref) == 0);
 		call_rcu(&pag->rcu_head, __xfs_free_perag);
 	}
 }
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
