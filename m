Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A92147F37
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 07:25:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 966038F8059
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 05:25:09 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	unZ3uZYPG0THzBlU for <xfs@oss.sgi.com>;
	Fri, 07 Jun 2013 05:25:08 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Ukvj6-0005Sw-I0
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 22:25:04 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Ukvj6-00031C-EA
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 22:25:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 05/12] xfs: remote attribute allocation may be contiguous
Date: Fri,  7 Jun 2013 22:24:54 +1000
Message-Id: <1370607901-11538-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1370607901-11538-1-git-send-email-david@fromorbit.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370607901-11538-1-git-send-email-david@fromorbit.com>
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
 libxfs/xfs_attr_remote.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index f0ca926..09a168b 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -336,6 +336,11 @@ xfs_attr_rmtval_set(
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
@@ -416,7 +421,6 @@ xfs_attr_rmtval_set(
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
