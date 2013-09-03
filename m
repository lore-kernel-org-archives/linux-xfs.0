Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D3BAD7F54
	for <xfs@oss.sgi.com>; Mon,  2 Sep 2013 19:07:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A6D468F8049
	for <xfs@oss.sgi.com>; Mon,  2 Sep 2013 17:07:03 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	IA6PvU8p4MQD3TsG for <xfs@oss.sgi.com>;
	Mon, 02 Sep 2013 17:07:01 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1VGe94-0002IT-RU
	for xfs@oss.sgi.com; Tue, 03 Sep 2013 10:06:58 +1000
Date: Tue, 3 Sep 2013 10:06:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH v2] xfs: check magic numbers in dir3 leaf verifier first
Message-ID: <20130903000658.GJ12779@dastard>
References: <1378119020-31299-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1378119020-31299-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

xfs: check magic numbers in dir3 leaf verifier first

From: Dave Chinner <dchinner@redhat.com>

Calling xfs_dir3_leaf_hdr_from_disk() in a verifier before
validating the magic numbers in the buffer results in ASSERT
failures due to mismatching magic numbers when a corruption occurs.
Seeing as the verifier is supposed to catch the corruption and pass
it back to the caller, having the verifier assert fail on error
defeats the purpose of detecting the errors in the first place.

Check the magic numbers direct from the buffer before decoding the
header.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
v2: magic number size is 16 bits, not 32 bits. Was only wrong for v4
filesystem checking, xfstests/204 triggered failure.

 fs/xfs/xfs_dir2_leaf.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
index 08984ee..fb57893 100644
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -165,6 +165,7 @@ xfs_dir3_leaf_check_int(
 	    (char *)&ents[hdr->count] > (char *)xfs_dir2_leaf_bests_p(ltp))
 		return false;
 
+
 	/* Check hash value order, count stale entries.  */
 	for (i = stale = 0; i < hdr->count; i++) {
 		if (i + 1 < hdr->count) {
@@ -180,6 +181,11 @@ xfs_dir3_leaf_check_int(
 	return true;
 }
 
+/*
+ * We verify the magic numbers before decoding the leaf header so that on debug
+ * kernels we don't get assertion failures in xfs_dir3_leaf_hdr_from_disk() due
+ * to incorrect magic numbers.
+ */
 static bool
 xfs_dir3_leaf_verify(
 	struct xfs_buf		*bp,
@@ -191,24 +197,25 @@ xfs_dir3_leaf_verify(
 
 	ASSERT(magic == XFS_DIR2_LEAF1_MAGIC || magic == XFS_DIR2_LEAFN_MAGIC);
 
-	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		struct xfs_dir3_leaf_hdr *leaf3 = bp->b_addr;
+		__uint16_t		magic3;
 
-		if ((magic == XFS_DIR2_LEAF1_MAGIC &&
-		     leafhdr.magic != XFS_DIR3_LEAF1_MAGIC) ||
-		    (magic == XFS_DIR2_LEAFN_MAGIC &&
-		     leafhdr.magic != XFS_DIR3_LEAFN_MAGIC))
-			return false;
+		magic3 = (magic == XFS_DIR2_LEAF1_MAGIC) ? XFS_DIR3_LEAF1_MAGIC
+							 : XFS_DIR3_LEAFN_MAGIC;
 
+		if (leaf3->info.hdr.magic != cpu_to_be16(magic3))
+			return false;
 		if (!uuid_equal(&leaf3->info.uuid, &mp->m_sb.sb_uuid))
 			return false;
 		if (be64_to_cpu(leaf3->info.blkno) != bp->b_bn)
 			return false;
 	} else {
-		if (leafhdr.magic != magic)
+		if (leaf->hdr.info.magic != cpu_to_be16(magic))
 			return false;
 	}
+
+	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
 	return xfs_dir3_leaf_check_int(mp, &leafhdr, leaf);
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
