Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 73DFA29E36
	for <xfs@oss.sgi.com>; Sun, 19 May 2013 18:52:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1269EAC001
	for <xfs@oss.sgi.com>; Sun, 19 May 2013 16:52:02 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	KEWIj6qBJa8ECC7j for <xfs@oss.sgi.com>;
	Sun, 19 May 2013 16:51:55 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UeDOC-0006AD-QA
	for xfs@oss.sgi.com; Mon, 20 May 2013 09:51:44 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UeDO2-0003yp-NZ
	for xfs@oss.sgi.com; Mon, 20 May 2013 09:51:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 08/14] xfs: remote attribute allocation may be contiguous
Date: Mon, 20 May 2013 09:51:15 +1000
Message-Id: <1369007481-15185-9-git-send-email-david@fromorbit.com>
In-Reply-To: <1369007481-15185-1-git-send-email-david@fromorbit.com>
References: <1369007481-15185-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

When CRCs are enabled, there may be multiple allocations made if the
headers cause a length overflow. This, however, does not mean that
the number of headers required increases, as the second and
subsequent extents may be contiguous with the previous extent. Hence
when we map the extents to write the attribute data, we may end up
with less extents than allocations made. Hence the assertion that we
consume th enumber of headers we calculated in the allocation loop
is incorrect and needs to be removed.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_attr_remote.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_attr_remote.c b/fs/xfs/xfs_attr_remote.c
index dee8446..aad95b0 100644
--- a/fs/xfs/xfs_attr_remote.c
+++ b/fs/xfs/xfs_attr_remote.c
@@ -359,6 +359,11 @@ xfs_attr_rmtval_set(
 		 * into requiring more blocks. e.g. for 512 byte blocks, we'll
 		 * spill for another block every 9 headers we require in this
 		 * loop.
+		 *
+		 * Note that this can result in contiguous allocation of blocks,
+		 * so we don't use all the space we allocate for headers as we
+		 * have one less header for each contiguous allocation that
+		 * occurs in the map/write loop below.
 		 */
 		if (crcs && blkcnt == 0) {
 			int total_len;
@@ -439,7 +444,6 @@ xfs_attr_rmtval_set(
 		lblkno += map.br_blockcount;
 	}
 	ASSERT(valuelen == 0);
-	ASSERT(hdrcnt == 0);
 	return 0;
 }
 
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
