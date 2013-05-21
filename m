Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0E88429E06
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 03:02:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E0E3B30404E
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 01:02:34 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	4uwvUHEyjklfBOAg for <xfs@oss.sgi.com>;
	Tue, 21 May 2013 01:02:33 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 02/11] xfs: remote attribute allocation may be contiguous
Date: Tue, 21 May 2013 18:02:01 +1000
Message-Id: <1369123330-9579-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1369123330-9579-1-git-send-email-david@fromorbit.com>
References: <1369123330-9579-1-git-send-email-david@fromorbit.com>
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
Cc: bpm@sgi.com

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
