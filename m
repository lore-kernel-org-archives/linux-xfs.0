Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98986C83F12
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Aug 2023 07:29:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbjH1H3C (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Aug 2023 03:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbjH1H2q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Aug 2023 03:28:46 -0400
X-Greylist: delayed 63 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 28 Aug 2023 00:28:35 PDT
Received: from esa5.hc1455-7.c3s2.iphmx.com (esa5.hc1455-7.c3s2.iphmx.com [68.232.139.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBAA81B8
        for <linux-xfs@vger.kernel.org>; Mon, 28 Aug 2023 00:28:35 -0700 (PDT)
X-IronPort-AV: E=McAfee;i="6600,9927,10815"; a="129222843"
X-IronPort-AV: E=Sophos;i="6.02,207,1688396400"; 
   d="scan'208";a="129222843"
Received: from unknown (HELO yto-r1.gw.nic.fujitsu.com) ([218.44.52.217])
  by esa5.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2023 16:27:30 +0900
Received: from yto-m1.gw.nic.fujitsu.com (yto-nat-yto-m1.gw.nic.fujitsu.com [192.168.83.64])
        by yto-r1.gw.nic.fujitsu.com (Postfix) with ESMTP id 6BFE2DB4CB
        for <linux-xfs@vger.kernel.org>; Mon, 28 Aug 2023 16:27:27 +0900 (JST)
Received: from kws-ab3.gw.nic.fujitsu.com (kws-ab3.gw.nic.fujitsu.com [192.51.206.21])
        by yto-m1.gw.nic.fujitsu.com (Postfix) with ESMTP id A3193CFBC1
        for <linux-xfs@vger.kernel.org>; Mon, 28 Aug 2023 16:27:26 +0900 (JST)
Received: from irides.g08.fujitsu.local (unknown [10.167.234.230])
        by kws-ab3.gw.nic.fujitsu.com (Postfix) with ESMTP id 240E520050196
        for <linux-xfs@vger.kernel.org>; Mon, 28 Aug 2023 16:27:26 +0900 (JST)
From:   Shiyang Ruan <ruansy.fnst@fujitsu.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: correct calculation for blockcount
Date:   Mon, 28 Aug 2023 15:24:50 +0800
Message-ID: <20230828072450.1510248-1-ruansy.fnst@fujitsu.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-27840.005
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-27840.005
X-TMASE-Result: 10-0.529400-10.000000
X-TMASE-MatchedRID: hp3d3iDR7tilTHNxJDwdpIL5ja7E+OhyTfK5j0EZbyvAuQ0xDMaXkH4q
        tYI9sRE/7wJL2+8U4LF0VliN2pDsnUkjllSXrjtQFEUknJ/kEl5jFT88f69nG/oLR4+zsDTtjoc
        zmuoPCq3JDgGl0dhlG8tmV4u0/2s9MTn+1OjF/ZFAVyKeZOA53gGURmmn2G+kU6BvSjkysyCGgI
        tPilyQGuS7JSRhMnuAb3xtRYICUc9V11D6oeeWTijsyb0et6ZhZb4TGzaNUFj434fmRikSqUsZL
        d9fb2hk
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The blockcount, which means length, should be "end + 1 - start".  So,
add the missing "+1" here.

Fixes: 5cf32f63b0f4 ("xfs: fix the calculation for "end" and "length"")
Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
---
 fs/xfs/xfs_notify_failure.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_notify_failure.c b/fs/xfs/xfs_notify_failure.c
index 4a9bbd3fe120..459fc8a39635 100644
--- a/fs/xfs/xfs_notify_failure.c
+++ b/fs/xfs/xfs_notify_failure.c
@@ -151,7 +151,7 @@ xfs_dax_notify_ddev_failure(
 		agend = min(be32_to_cpu(agf->agf_length),
 				ri_high.rm_startblock);
 		notify.startblock = ri_low.rm_startblock;
-		notify.blockcount = agend - ri_low.rm_startblock;
+		notify.blockcount = agend + 1 - ri_low.rm_startblock;
 
 		error = xfs_rmap_query_range(cur, &ri_low, &ri_high,
 				xfs_dax_failure_fn, &notify);
-- 
2.41.0

