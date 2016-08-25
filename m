Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3ED47807B
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:45:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E8AA18F8035
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:45:31 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id nBobvN3D2OurfA7F (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:45:30 -0700 (PDT)
Subject: [PATCH 19/20] xfs: cross-reference realtime bitmap to realtime
	rmapbt scrubber
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:45:26 -0700
Message-ID: <147216872624.3688.9023416667706304844.stgit@birch.djwong.org>
In-Reply-To: <147216860614.3688.3200692982609112535.stgit@birch.djwong.org>
References: <147216860614.3688.3200692982609112535.stgit@birch.djwong.org>
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

When we're checking the realtime rmapbt, cross-reference the entries
with the realtime bitmap too.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_scrub.c |    8 ++++++++
 1 file changed, 8 insertions(+)


diff --git a/fs/xfs/xfs_scrub.c b/fs/xfs/xfs_scrub.c
index f1f4a2f..f0cd21f 100644
--- a/fs/xfs/xfs_scrub.c
+++ b/fs/xfs/xfs_scrub.c
@@ -2845,10 +2845,12 @@ xfs_scrub_rtrmapbt_helper(
 {
 	struct xfs_mount		*mp = bs->cur->bc_mp;
 	struct xfs_rmap_irec		irec;
+	bool				is_free;
 	bool				non_inode;
 	bool				is_bmbt;
 	bool				is_attr;
 	int				error;
+	int				err2;
 
 	error = xfs_rmap_btrec_to_irec(bs->cur, rec, &irec);
 	if (error)
@@ -2868,6 +2870,12 @@ xfs_scrub_rtrmapbt_helper(
 	XFS_BTREC_SCRUB_CHECK(bs, !non_inode);
 	XFS_BTREC_SCRUB_CHECK(bs, !is_attr);
 
+	/* Check the rtbitmap thinks it's free. */
+	err2 = xfs_rtbitmap_extent_is_free(mp, irec.rm_startblock,
+			irec.rm_blockcount, &is_free);
+	if (!err2)
+		XFS_BTREC_SCRUB_CHECK(bs, !is_free);
+
 	return error;
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
