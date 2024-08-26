Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9740C3BBE0;
	Mon, 26 Aug 2024 03:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724642108; cv=none; b=X57smyiUVIxWNT9zZziL3Cb4qFbJlxzRJNmVRJ6tkBAr7FIRjJasQrwvrrQCESOEtXbNswDgXWEtfpER8bhHkzRPDh4x+odgmj/dCWRzPNENxvJWpsp+gtoaF7Xaxq7083LG78/H5Hzy22nI96aKh5EUUm039ImZFRrcBe94lNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724642108; c=relaxed/simple;
	bh=DuYpXsvG9S0qrtyQKMASfZ/A2YRxAXluE+7qk7APOr4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MLcQZztemzLrX374y4suUNadFoz0bplpDTrZXWakqq0h4jl5C2eWbV0qNk96ozhVg12ds0bKhSjaDC7xxofXmM89abydXkgrRCYIjDw24kheEEmUKzxgwvvXhQGmipVNEsipwxcIlEVa+g4WM9an0YAIetT5pjvqLLy82s5TeCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4WsbQ55pMRz1j7DN;
	Mon, 26 Aug 2024 11:14:53 +0800 (CST)
Received: from kwepemf100017.china.huawei.com (unknown [7.202.181.16])
	by mail.maildlp.com (Postfix) with ESMTPS id EC4671A0188;
	Mon, 26 Aug 2024 11:15:01 +0800 (CST)
Received: from localhost.localdomain (10.175.104.67) by
 kwepemf100017.china.huawei.com (7.202.181.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 26 Aug 2024 11:15:01 +0800
From: Zizhi Wo <wozizhi@huawei.com>
To: <chandan.babu@oracle.com>, <djwong@kernel.org>, <dchinner@redhat.com>,
	<osandov@fb.com>, <john.g.garry@oracle.com>
CC: <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<wozizhi@huawei.com>, <yangerkun@huawei.com>
Subject: [PATCH 2/2] xfs: Fix incorrect parameter calculation in rt fsmap
Date: Mon, 26 Aug 2024 11:10:05 +0800
Message-ID: <20240826031005.2493150-3-wozizhi@huawei.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240826031005.2493150-1-wozizhi@huawei.com>
References: <20240826031005.2493150-1-wozizhi@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemf100017.china.huawei.com (7.202.181.16)

I noticed a bug related to xfs realtime device fsmap:
[root@fedora ~]# xfs_io -c 'fsmap -vvvv -r' /mnt
 EXT: DEV    BLOCK-RANGE         OWNER            FILE-OFFSET      AG AG-OFFSET          TOTAL
   0: 253:48 [0..7]:             unknown                                                     8
   1: 253:48 [8..1048575]:       free space                                            1048568
   2: 253:48 [1048576..1050623]: unknown                                                  2048
   3: 253:48 [1050624..2097151]: free space                                            1046528

Bug:
[root@fedora ~]# xfs_io -c 'fsmap -vvvv -r 1050621 1050621' /mnt
 EXT: DEV    BLOCK-RANGE         OWNER            FILE-OFFSET      AG AG-OFFSET        TOTAL
   0: 253:48 [1050621..1050623]: unknown                                                   3
   1: 253:48 [1050624..1050631]: free space                                                8
Normally, we should not get any results, but we do get two queries.

The root cause of this problem lies in the calculation of "end_rtb" in
xfs_getfsmap_rtdev_rtbitmap(), which uses XFS_BB_TO_FSB method (round up).
However, in the subsequent call to xfs_rtalloc_query_range(), "high_rec"
calculated based on "end_rtb" has a semantic meaning of being reachable
within the loop. The first round of the loop in xfs_rtalloc_query_range()
doesn't find any free extents. But after incrementing "rtstart" by 1, start
still does not exceed "high_key", and the second round of the loop entered.
It finds free extent and obtains the first unknown extent by subtracting it
from "info->next_daddr". Even though we can accurately handle it through
"info->end_daddr", two incorrect extents has already been returned before
the last query. The main call stack is as follows:

xfs_getfsmap_rtdev_rtbitmap
  // rounded up
  end_rtb = XFS_BB_TO_FSB(..., keys[1].fmr_physical)
  ahigh.ar_startext = xfs_rtb_to_rtxup(mp, end_rtb)
  xfs_rtalloc_query_range
    // high_key is calculated based on end_rtb
    high_key = min(high_rec->ar_startext, ...)
    while (rtstart <= high_key)
      // First loop, doesn't find free extent
      xfs_rtcheck_range
      rtstart = rtend + 1
      // Second loop, the free extent outside the query interval is found
      xfs_getfsmap_rtdev_rtbitmap_helper
        // unknown and free were printed out together in the second round
        xfs_getfsmap_helper

The issue is resolved by adjusting the relevant calculations. Both the loop
exit condition in the xfs_rtalloc_query_range() and the length calculation
condition (high_key - start + 1) in the xfs_rtfind_forw() reflect the open
interval semantics of "high_key". Therefore, when calculating "end_rtb",
XFS_BB_TO_FSBT is used. In addition, in order to satisfy the close interval
semantics, "key[1].fmr_physical" needs to be decremented by 1. For the
non-eofs case, there is no need to worry about over-counting because we can
accurately count the block number through "info->end_daddr".

After applying this patch, the above problem have been solved:
[root@fedora ~]# xfs_io -c 'fsmap -vvvv -r 1050621 1050621' /mnt
[root@fedora ~]#

Fixes: 4c934c7dd60c ("xfs: report realtime space information via the rtbitmap")
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |  4 +---
 fs/xfs/xfs_fsmap.c           | 20 +++++++++++++++++---
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 386b672c5058..7af4e7afda7d 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1034,8 +1034,7 @@ xfs_rtalloc_query_range(
 
 	if (low_rec->ar_startext > high_rec->ar_startext)
 		return -EINVAL;
-	if (low_rec->ar_startext >= mp->m_sb.sb_rextents ||
-	    low_rec->ar_startext == high_rec->ar_startext)
+	if (low_rec->ar_startext >= mp->m_sb.sb_rextents)
 		return 0;
 
 	high_key = min(high_rec->ar_startext, mp->m_sb.sb_rextents - 1);
@@ -1057,7 +1056,6 @@ xfs_rtalloc_query_range(
 		if (is_free) {
 			rec.ar_startext = rtstart;
 			rec.ar_extcount = rtend - rtstart + 1;
-
 			error = fn(mp, tp, &rec, priv);
 			if (error)
 				break;
diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 8a2dfe96dae7..42c4b94b0493 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -515,11 +515,20 @@ xfs_getfsmap_rtdev_rtbitmap(
 	int				error;
 
 	eofs = XFS_FSB_TO_BB(mp, xfs_rtx_to_rtb(mp, mp->m_sb.sb_rextents));
-	if (keys[0].fmr_physical >= eofs)
+	if (keys[0].fmr_physical >= eofs ||
+		keys[0].fmr_physical == keys[1].fmr_physical)
 		return 0;
 	start_rtb = XFS_BB_TO_FSBT(mp,
 				keys[0].fmr_physical + keys[0].fmr_length);
-	end_rtb = XFS_BB_TO_FSB(mp, min(eofs - 1, keys[1].fmr_physical));
+	/*
+	 * The passed keys[1] is an unreachable value, while "end_rtb" is used
+	 * to calculate "ahigh.ar_startext", serving as an input parameter for
+	 * xfs_rtalloc_query_range(), which is a value that can be reached.
+	 * Therefore, it is necessary to use "keys[1].fmr_physical - 1" here.
+	 * And because of the semantics of "end_rtb", it needs to be
+	 * supplemented by 1 in the last calculation.
+	 */
+	end_rtb = XFS_BB_TO_FSBT(mp, min(eofs - 1, keys[1].fmr_physical - 1));
 
 	info->missing_owner = XFS_FMR_OWN_UNKNOWN;
 
@@ -549,9 +558,14 @@ xfs_getfsmap_rtdev_rtbitmap(
 	/*
 	 * Report any gaps at the end of the rtbitmap by simulating a null
 	 * rmap starting at the block after the end of the query range.
+	 * For the boundary case of eofs, we need to increment the count
+	 * by 1 to prevent omission in block statistics.
+	 * For the boundary case of non-eofs, even if incrementing by 1
+	 * may lead to over-counting, it doesn't matter because it is
+	 * handled by "info->end_daddr" in this situation, not "ahigh".
 	 */
 	info->last = true;
-	ahigh.ar_startext = min(mp->m_sb.sb_rextents, ahigh.ar_startext);
+	ahigh.ar_startext = min(mp->m_sb.sb_rextents, ahigh.ar_startext + 1);
 
 	error = xfs_getfsmap_rtdev_rtbitmap_helper(mp, tp, &ahigh, info);
 	if (error)
-- 
2.39.2

