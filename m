Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EACB47CA2
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 00:18:58 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BF9388F8033
	for <xfs@oss.sgi.com>; Sun, 14 Feb 2016 22:18:58 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	UO3Fs7UNaO6fcqkb for <xfs@oss.sgi.com>;
	Sun, 14 Feb 2016 22:18:56 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aVCUN-0000MA-Gd
	for xfs@oss.sgi.com; Mon, 15 Feb 2016 17:18:27 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aVCUN-0005GD-Fp
	for xfs@oss.sgi.com; Mon, 15 Feb 2016 17:18:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 02/14] xfs: add missing bmap cancel calls in error paths
Date: Mon, 15 Feb 2016 17:18:13 +1100
Message-Id: <1455517105-20033-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1455517105-20033-1-git-send-email-david@fromorbit.com>
References: <1455517105-20033-1-git-send-email-david@fromorbit.com>
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

From: Brian Foster <bfoster@redhat.com>

Source kernel commit d4a97a04227d5ba91b91888a016e2300861cfbc7

If a failure occurs after the bmap free list is populated and before
xfs_bmap_finish() completes successfully (which returns a partial
list on failure), the bmap free list must be cancelled. Otherwise,
the extent items on the list are never freed and a memory leak
occurs.

Several random error paths throughout the code suffer this problem.
Fix these up such that xfs_bmap_cancel() is always called on error.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 libxfs/xfs_bmap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index aef7cf3..b9e58e2 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -5938,6 +5938,7 @@ xfs_bmap_split_extent(
 	return xfs_trans_commit(tp);
 
 out:
+	xfs_bmap_cancel(&free_list);
 	xfs_trans_cancel(tp);
 	return error;
 }
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
