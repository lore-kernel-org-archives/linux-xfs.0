Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43CDCCA5534
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Sep 2023 10:32:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238816AbjIMKcy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Sep 2023 06:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235971AbjIMKcw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Sep 2023 06:32:52 -0400
Received: from esa11.hc1455-7.c3s2.iphmx.com (esa11.hc1455-7.c3s2.iphmx.com [207.54.90.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B190ED3
        for <linux-xfs@vger.kernel.org>; Wed, 13 Sep 2023 03:32:47 -0700 (PDT)
X-IronPort-AV: E=McAfee;i="6600,9927,10831"; a="111293206"
X-IronPort-AV: E=Sophos;i="6.02,142,1688396400"; 
   d="scan'208";a="111293206"
Received: from unknown (HELO yto-r2.gw.nic.fujitsu.com) ([218.44.52.218])
  by esa11.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 19:32:46 +0900
Received: from yto-m2.gw.nic.fujitsu.com (yto-nat-yto-m2.gw.nic.fujitsu.com [192.168.83.65])
        by yto-r2.gw.nic.fujitsu.com (Postfix) with ESMTP id ECEF9C68E1
        for <linux-xfs@vger.kernel.org>; Wed, 13 Sep 2023 19:32:42 +0900 (JST)
Received: from kws-ab4.gw.nic.fujitsu.com (kws-ab4.gw.nic.fujitsu.com [192.51.206.22])
        by yto-m2.gw.nic.fujitsu.com (Postfix) with ESMTP id 31C6FD5007
        for <linux-xfs@vger.kernel.org>; Wed, 13 Sep 2023 19:32:42 +0900 (JST)
Received: from irides.g08.fujitsu.local (unknown [10.167.234.230])
        by kws-ab4.gw.nic.fujitsu.com (Postfix) with ESMTP id 961731EBDBC;
        Wed, 13 Sep 2023 19:32:41 +0900 (JST)
From:   Shiyang Ruan <ruansy.fnst@fujitsu.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH v3] xfs: correct calculation for agend and blockcount
Date:   Wed, 13 Sep 2023 18:29:42 +0800
Message-ID: <20230913102942.601271-1-ruansy.fnst@fujitsu.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828072450.1510248-1-ruansy.fnst@fujitsu.com>
References: <20230828072450.1510248-1-ruansy.fnst@fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-27872.006
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-27872.006
X-TMASE-Result: 10--4.655300-10.000000
X-TMASE-MatchedRID: gONzw9UUP1YBOHW58ozCWsVUBXy8OM3/G24YVeuZGmN4YeSlHZYFoj13
        GoPFA1HFIvrftAIhWmLy9zcRSkKate8KS96Bnw4t8Jb881FGn9mCg7hXeiWNupsoi2XrUn/Jn6K
        dMrRsL14qtq5d3cxkNV1AUl3bmfTuuDe8/UiJb06remGyUQJ9b7CyNoKg8+kxAQsV7jHnAIjeWR
        fwlDqXefNjlcykiDnHAZAkFozJ/xJb6lpU6KYTMIxrU96OxkmsFcUQf3Yp/ridO0/GUi4gFb0fO
        PzpgdcEKeJ/HkAZ8Is=
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The agend should be "start + length - 1", then, blockcount should be
"end + 1 - start".  Correct 2 calculation mistakes.

Also, rename "agend" to "range_agend" because it's not the end of the AG
per se; it's the end of the dead region within an AG's agblock space.

Fixes: 5cf32f63b0f4 ("xfs: fix the calculation for "end" and "length"")
Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_notify_failure.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_notify_failure.c b/fs/xfs/xfs_notify_failure.c
index 4a9bbd3fe120..a7daa522e00f 100644
--- a/fs/xfs/xfs_notify_failure.c
+++ b/fs/xfs/xfs_notify_failure.c
@@ -126,8 +126,8 @@ xfs_dax_notify_ddev_failure(
 		struct xfs_rmap_irec	ri_low = { };
 		struct xfs_rmap_irec	ri_high;
 		struct xfs_agf		*agf;
-		xfs_agblock_t		agend;
 		struct xfs_perag	*pag;
+		xfs_agblock_t		range_agend;
 
 		pag = xfs_perag_get(mp, agno);
 		error = xfs_alloc_read_agf(pag, tp, 0, &agf_bp);
@@ -148,10 +148,10 @@ xfs_dax_notify_ddev_failure(
 			ri_high.rm_startblock = XFS_FSB_TO_AGBNO(mp, end_fsbno);
 
 		agf = agf_bp->b_addr;
-		agend = min(be32_to_cpu(agf->agf_length),
+		range_agend = min(be32_to_cpu(agf->agf_length) - 1,
 				ri_high.rm_startblock);
 		notify.startblock = ri_low.rm_startblock;
-		notify.blockcount = agend - ri_low.rm_startblock;
+		notify.blockcount = range_agend + 1 - ri_low.rm_startblock;
 
 		error = xfs_rmap_query_range(cur, &ri_low, &ri_high,
 				xfs_dax_failure_fn, &notify);
-- 
2.42.0

