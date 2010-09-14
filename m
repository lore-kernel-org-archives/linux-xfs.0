Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8EAu5w2121077 for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 05:56:05 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3D3711E65308
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 03:56:51 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	QghMsUZAw3yomv8z for <xfs@oss.sgi.com>;
	Tue, 14 Sep 2010 03:56:51 -0700 (PDT)
Received: from dastard (unverified [121.44.127.68])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	38830797-1927428
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 20:26:50 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OvTBx-0004OL-4t
	for xfs@oss.sgi.com; Tue, 14 Sep 2010 20:56:49 +1000
Received: from dave by disturbed with local (Exim 4.72)
	(envelope-from <dave@disturbed.disaster>) id 1OvTBa-0000Pv-Q5
	for xfs@oss.sgi.com; Tue, 14 Sep 2010 20:56:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 03/18] xfs: remove debug assert for per-ag reference counting
Date: Tue, 14 Sep 2010 20:56:02 +1000
Message-Id: <1284461777-1496-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1284461777-1496-1-git-send-email-david@fromorbit.com>
References: <1284461777-1496-1-git-send-email-david@fromorbit.com>
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

When we start taking references per cached buffer to the the perag
it is cached on, it will blow the current debug maximum reference
count assert out of the water. The assert has never caught a bug,
and we have tracing to track changes if there ever is a problem,
so just remove it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_mount.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index aeb9d72..00c7a87 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -210,8 +210,6 @@ xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno)
 	pag = radix_tree_lookup(&mp->m_perag_tree, agno);
 	if (pag) {
 		ASSERT(atomic_read(&pag->pag_ref) >= 0);
-		/* catch leaks in the positive direction during testing */
-		ASSERT(atomic_read(&pag->pag_ref) < 1000);
 		ref = atomic_inc_return(&pag->pag_ref);
 	}
 	spin_unlock(&mp->m_perag_lock);
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
