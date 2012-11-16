Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAG6hXfD067235 for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 00:43:33 -0600
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id S0gkigMA42Q6BLUc (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 15 Nov 2012 22:45:38 -0800 (PST)
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with
	ESMTP id qAG6jbSU003453
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 06:45:38 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	qAG6jabA019178
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 06:45:37 GMT
Received: from abhmt110.oracle.com (abhmt110.oracle.com [141.146.116.62])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id
	qAG6jat3005101 for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 00:45:36 -0600
Message-ID: <50A5E10B.5010109@oracle.com>
Date: Fri, 16 Nov 2012 14:45:31 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 05/15] xfs: Teach inode/space allocator aware of
	XFS_AG_STATE_ALLOC_DENY
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Teach inode/space allocators aware of the new AG state(XFS_AG_STATE_ALLOC_DENY).

- Don't chose an AG with this state.
- Don't mark pagi_inodeok upon an AG for xfs_set_inode32/64 mount options if the
given AG incore object has this state.


Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_alloc.c  |   15 ++++++++++++++-
 fs/xfs/xfs_ialloc.c |    6 +++++-
 fs/xfs/xfs_super.c  |   10 ++++++++++
 3 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index bd9cc41..d2eb856 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -493,6 +493,7 @@ STATIC int			/* error */
 xfs_alloc_ag_vextent(
 	xfs_alloc_arg_t	*args)	/* argument structure for allocation */
 {
+	xfs_perag_t	*pag = args->pag;
 	int		error=0;
 
 	ASSERT(args->minlen > 0);
@@ -500,6 +501,18 @@ xfs_alloc_ag_vextent(
 	ASSERT(args->minlen <= args->maxlen);
 	ASSERT(args->mod < args->prod);
 	ASSERT(args->alignment > 0);
+
+	/*
+	 * Return NULLAGBLOCK if the a.g. state is set to offline.
+	 * i.e. deny allocation.
+	 * FIXME: how about replacing XFS_AG_STATE_ALLOC_DENY to
+	 * XFS_AG_STATE_OFFLINE? maybe looks a bit more reasonable.
+	 */
+	if (unlikely(pag->pag_state & XFS_AG_STATE_ALLOC_DENY)) {
+		args->agbno = NULLAGBLOCK;
+		return 0;
+	}
+
 	/*
 	 * Branch to correct routine based on the type.
 	 */
@@ -1893,7 +1906,7 @@ xfs_alloc_fix_freelist(
 		/*
 		 * Stop if we run out.  Won't happen if callers are obeying
 		 * the restrictions correctly.  Can happen for free calls
-		 * on a completely full ag.
+		 * on a completely full ag, or an ag is set to offline.
 		 */
 		if (targs.agbno == NULLAGBLOCK) {
 			if (flags & XFS_ALLOC_FLAG_FREEING)
diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index 445bf1a..04fbb49 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -488,7 +488,11 @@ xfs_ialloc_ag_select(
 	flags = XFS_ALLOC_FLAG_TRYLOCK;
 	for (;;) {
 		pag = xfs_perag_get(mp, agno);
-		if (!pag->pagi_inodeok) {
+		/*
+		 * Skip the current AG if it's state is set to offline.
+		 */
+		if (!pag->pagi_inodeok ||
+		    unlikely(pag->pag_state & XFS_AG_STATE_ALLOC_DENY)) {
 			xfs_ialloc_next_ag(mp);
 			goto nextag;
 		}
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 26a09bd..e01f64c 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -642,6 +642,11 @@ xfs_set_inode32(struct xfs_mount *mp)
 		}
 
 		pag = xfs_perag_get(mp, index);
+		if (unlikely(pag->pag_state & XFS_AG_STATE_ALLOC_DENY)) {
+			xfs_perag_put(pag);
+			continue;
+		}
+
 		pag->pagi_inodeok = 1;
 		maxagi++;
 		if (index < max_metadata)
@@ -663,6 +668,11 @@ xfs_set_inode64(struct xfs_mount *mp)
 		struct xfs_perag	*pag;
 
 		pag = xfs_perag_get(mp, index);
+		if (unlikely(pag->pag_state & XFS_AG_STATE_ALLOC_DENY)) {
+			xfs_perag_put(pag);
+			continue;
+		}
+
 		pag->pagi_inodeok = 1;
 		pag->pagf_metadata = 0;
 		xfs_perag_put(pag);
-- 
1.7.4.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
