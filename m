Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 638A8CA0EC3
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Sep 2023 21:29:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345578AbjIKVVX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Sep 2023 17:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236524AbjIKKtt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Sep 2023 06:49:49 -0400
Received: from esa9.hc1455-7.c3s2.iphmx.com (esa9.hc1455-7.c3s2.iphmx.com [139.138.36.223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61CBBE9
        for <linux-xfs@vger.kernel.org>; Mon, 11 Sep 2023 03:49:44 -0700 (PDT)
X-IronPort-AV: E=McAfee;i="6600,9927,10829"; a="119902817"
X-IronPort-AV: E=Sophos;i="6.02,243,1688396400"; 
   d="scan'208";a="119902817"
Received: from unknown (HELO yto-r1.gw.nic.fujitsu.com) ([218.44.52.217])
  by esa9.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2023 19:49:41 +0900
Received: from yto-m4.gw.nic.fujitsu.com (yto-nat-yto-m4.gw.nic.fujitsu.com [192.168.83.67])
        by yto-r1.gw.nic.fujitsu.com (Postfix) with ESMTP id 8F28910879
        for <linux-xfs@vger.kernel.org>; Mon, 11 Sep 2023 19:49:39 +0900 (JST)
Received: from kws-ab4.gw.nic.fujitsu.com (kws-ab4.gw.nic.fujitsu.com [192.51.206.22])
        by yto-m4.gw.nic.fujitsu.com (Postfix) with ESMTP id D2D64D3F02
        for <linux-xfs@vger.kernel.org>; Mon, 11 Sep 2023 19:49:38 +0900 (JST)
Received: from irides.g08.fujitsu.local (unknown [10.167.234.230])
        by kws-ab4.gw.nic.fujitsu.com (Postfix) with ESMTP id 472406C9DA
        for <linux-xfs@vger.kernel.org>; Mon, 11 Sep 2023 19:49:38 +0900 (JST)
From:   Shiyang Ruan <ruansy.fnst@fujitsu.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2] xfs: correct calculation for agend and blockcount
Date:   Mon, 11 Sep 2023 18:46:41 +0800
Message-ID: <20230911104641.331240-1-ruansy.fnst@fujitsu.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828072450.1510248-1-ruansy.fnst@fujitsu.com>
References: <20230828072450.1510248-1-ruansy.fnst@fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-27868.007
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-27868.007
X-TMASE-Result: 10-0.578200-10.000000
X-TMASE-MatchedRID: Mq65of7y/lFdcKkf2LpmairLqyE6Ur/jwTlc9CcHMZerwqxtE531VCzy
        bVqWyY2NLMbSJC+OPZpw8Y4z2QaJbh8TzIzimOwP/hxxPCwzUoPEQdG7H66TyHEqm8QYBtMOULs
        0Yo8g+OF6XEjjvskZFHzc+anKATzy8YxSr4t7lATK/8k0UfMfWocxHQdEYQsT5TDkhhlxHqr7O3
        /YTyTZ/XfxMQbVZE5/mOQbL4HfAv71SoQ16dM3BosC52Cg2T5/LkB52NJ63oQ=
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The agend should be "start + length - 1", then, blockcount should be
"end + 1 - start".  Correct 2 calculation mistakes.

Fixes: 5cf32f63b0f4 ("xfs: fix the calculation for "end" and "length"")
Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
---
 fs/xfs/xfs_notify_failure.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_notify_failure.c b/fs/xfs/xfs_notify_failure.c
index 4a9bbd3fe120..8b8ef776bdc3 100644
--- a/fs/xfs/xfs_notify_failure.c
+++ b/fs/xfs/xfs_notify_failure.c
@@ -148,10 +148,10 @@ xfs_dax_notify_ddev_failure(
 			ri_high.rm_startblock = XFS_FSB_TO_AGBNO(mp, end_fsbno);
 
 		agf = agf_bp->b_addr;
-		agend = min(be32_to_cpu(agf->agf_length),
+		agend = min(be32_to_cpu(agf->agf_length) - 1,
 				ri_high.rm_startblock);
 		notify.startblock = ri_low.rm_startblock;
-		notify.blockcount = agend - ri_low.rm_startblock;
+		notify.blockcount = agend + 1 - ri_low.rm_startblock;
 
 		error = xfs_rmap_query_range(cur, &ri_low, &ri_high,
 				xfs_dax_failure_fn, &notify);
-- 
2.42.0

