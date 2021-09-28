Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F37E4C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Sep 2021 22:29:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB7C061381
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Sep 2021 22:29:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243096AbhI1Wao (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Sep 2021 18:30:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:59564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243072AbhI1Wao (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 28 Sep 2021 18:30:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 367646138D;
        Tue, 28 Sep 2021 22:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632868144;
        bh=hsxQl9PH+QjDIO1Yv+GJZTvBhCfxcSJRg1Jxy1Tno1I=;
        h=Date:From:To:Cc:Subject:From;
        b=J01X64G+H7Da9BD/ZDPiKppydJorEDMIelEc0EPKfH1AB+WxRVa+YWQGq8/XjiK+g
         QcB6AKzEmD+xeQ9AQhfWVHCnM74sZ6XonxmeAIU80GeViQJHgGdBqS1Bhl4jAMDc2c
         vTBpSz84p0HhFXKxp0lI0IIh5p7XGJRBCGY8Qy0E8PGUvcSeK/jvGbmQL9/B//ghgU
         hpe0Z5WA91j8shlwNdoZoZ5tgnO3P2ZD9xVVlzwQwSYgYya1aGbfs186xCwIOBDBY+
         JB9b0dRFC0Sbath0LbFChcokJQOIComG7Ai0a3TMrmVye7LP9Ctnj8EV20FxeWy4Bj
         XjJGzR8AvO2og==
Date:   Tue, 28 Sep 2021 17:33:07 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] xfs: Use kvcalloc() instead of kvzalloc()
Message-ID: <20210928223307.GA295934@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Use 2-factor argument multiplication form kvcalloc() instead of
kvzalloc().

Link: https://github.com/KSPP/linux/issues/162
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 fs/xfs/xfs_ioctl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 0c795dc093ef..174cd8950cb6 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1547,7 +1547,7 @@ xfs_ioc_getbmap(
 	if (bmx.bmv_count > ULONG_MAX / recsize)
 		return -ENOMEM;
 
-	buf = kvzalloc(bmx.bmv_count * sizeof(*buf), GFP_KERNEL);
+	buf = kvcalloc(bmx.bmv_count, sizeof(*buf), GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
@@ -1601,11 +1601,11 @@ xfs_ioc_getfsmap(
 	 */
 	count = min_t(unsigned int, head.fmh_count,
 			131072 / sizeof(struct fsmap));
-	recs = kvzalloc(count * sizeof(struct fsmap), GFP_KERNEL);
+	recs = kvcalloc(count, sizeof(struct fsmap), GFP_KERNEL);
 	if (!recs) {
 		count = min_t(unsigned int, head.fmh_count,
 				PAGE_SIZE / sizeof(struct fsmap));
-		recs = kvzalloc(count * sizeof(struct fsmap), GFP_KERNEL);
+		recs = kvcalloc(count, sizeof(struct fsmap), GFP_KERNEL);
 		if (!recs)
 			return -ENOMEM;
 	}
-- 
2.27.0

