Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E7C5E848A
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 19:01:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6B1CCAC002
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 17:01:32 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id RLO8qCrfe1a7ekSt (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 17:01:30 -0700 (PDT)
Subject: [PATCH 25/29] xfs_repair: collect relatime reverse-mapping data for
	refcount/rmap tree rebuilding
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 17:01:20 -0700
Message-ID: <147216968057.7022.6386690839466970601.stgit@birch.djwong.org>
In-Reply-To: <147216950911.7022.438115723996286926.stgit@birch.djwong.org>
References: <147216950911.7022.438115723996286926.stgit@birch.djwong.org>
MIME-Version: 1.0
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Collect reverse-mapping data for realtime files so that we can later
check and rebuild the reference count tree and the reverse mapping
tree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/dinode.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index f768cdf..04759dc 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -594,6 +594,7 @@ process_bmbt_reclist_int(
 	xfs_agblock_t		ebno;
 	xfs_extlen_t		blen;
 	xfs_agnumber_t		locked_agno = -1;
+	struct aglock		*ag_lock;
 	int			error = 1;
 
 	if (type == XR_INO_RTDATA)
@@ -639,8 +640,20 @@ _("zero length extent (off = %" PRIu64 ", fsbno = %" PRIu64 ") in ino %" PRIu64
 			 */
 			if (process_rt_rec(mp, &irec, ino, tot, check_dups))
 				return 1;
+			/* collect reverse mappings for realtime files */
+			if (collect_rmaps && !check_dups) {
+				ag_lock = &ag_locks[(signed)NULLAGNUMBER];
+				pthread_mutex_lock(&ag_lock->lock);
+				error = rmap_add_rec(mp, ino, whichfork,
+						&irec, true);
+				pthread_mutex_unlock(&ag_lock->lock);
+				if (error)
+					do_error(
+_("couldn't add reverse mapping\n")
+						);
+			}
 			/*
-			 * skip rest of loop processing since that'irec.br_startblock
+			 * skip rest of loop processing since that's
 			 * all for regular file forks and attr forks
 			 */
 			continue;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
