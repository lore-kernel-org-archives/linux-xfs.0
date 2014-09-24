Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7050D7F74
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 18:37:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F2FE0AC004
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 16:37:51 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	1DpYRzeD386ctHM3 for <xfs@oss.sgi.com>;
	Wed, 24 Sep 2014 16:37:49 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XWw81-0004yE-Ju
	for xfs@oss.sgi.com; Thu, 25 Sep 2014 09:37:45 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XWw81-00056j-Iq
	for xfs@oss.sgi.com; Thu, 25 Sep 2014 09:37:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/4] xfs: fix use of agi_newino in finobt lookup
Date: Thu, 25 Sep 2014 09:37:40 +1000
Message-Id: <1411601863-19594-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1411601863-19594-1-git-send-email-david@fromorbit.com>
References: <1411601863-19594-1-git-send-email-david@fromorbit.com>
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

Sparse warns that we are passing the big-endian valueo f agi_newino
to the initial btree lookup function when trying to find a new
inode. This is wrong - we need to pass the host order value, not the
disk order value. This will adversely affect the next inode
allocated, but given that the free inode btree is usually much
smaller than the allocated inode btree it is much less likely to be
a performance issue if we start the search in the wrong place.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index d213a2e..23dcb72 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1076,8 +1076,8 @@ xfs_dialloc_ag_finobt_newino(
 	int i;
 
 	if (agi->agi_newino != cpu_to_be32(NULLAGINO)) {
-		error = xfs_inobt_lookup(cur, agi->agi_newino, XFS_LOOKUP_EQ,
-					 &i);
+		error = xfs_inobt_lookup(cur, be32_to_cpu(agi->agi_newino),
+					 XFS_LOOKUP_EQ, &i);
 		if (error)
 			return error;
 		if (i == 1) {
@@ -1085,7 +1085,6 @@ xfs_dialloc_ag_finobt_newino(
 			if (error)
 				return error;
 			XFS_WANT_CORRUPTED_RETURN(i == 1);
-
 			return 0;
 		}
 	}
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
