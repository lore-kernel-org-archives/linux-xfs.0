Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13BB3C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 05:14:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbjBIFOE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 00:14:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbjBIFOD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 00:14:03 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1C22CC63;
        Wed,  8 Feb 2023 21:14:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=tA+XtNRH/WNZjjh5eePbq3UsXVjhS3jfXV4NZNpMdeY=; b=KCWStTtIj27TC3HC2nknuyw8BB
        +uNIcNxZo1hwKcVJ9OR068uhDPGSV8sicFaqZWessIjmpc3hj3nSrUDt/ecgN8+ym778WJAFz4TTQ
        C8q5fcH1WWpUi6za77MDcTeNcgnJ51sUTvNu8mbJPBDyxSq9k/Ysl09HezlHJazJVnSzRy8svKJhw
        IxRfyWGZf+W1X8DD+tg7nEsOgCDc1sO5WakXQq6qQHt6HYX+mOMWV7eUb2Jpuo6lInbsr+RRt1Y98
        kCqGS5mj/34bAvlPWNCnWyJIG4j9CfTaw290vKTepF3jQgdryQ/xj/kJJHpQ7V2Mz3wIH85QGSPXO
        7BvMQmHw==;
Received: from [2001:4bb8:182:9f5b:acdc:d3c1:a8cd:f858] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pPzFy-000Btb-Az; Thu, 09 Feb 2023 05:14:02 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH 2/7] btrfs: add 125 to the auto and quick groups
Date:   Thu,  9 Feb 2023 06:13:50 +0100
Message-Id: <20230209051355.358942-3-hch@lst.de>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230209051355.358942-1-hch@lst.de>
References: <20230209051355.358942-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

btrfs/125 runs in 5 seconds on my VM setup, and found a regression in a
recent series.  Add it to the auto and quick groups.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/btrfs/125 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/btrfs/125 b/tests/btrfs/125
index b58f2aa2..1b6e5d78 100755
--- a/tests/btrfs/125
+++ b/tests/btrfs/125
@@ -22,7 +22,7 @@
 # Verify if all three checkpoints match
 #
 . ./common/preamble
-_begin_fstest replace volume balance
+_begin_fstest replace volume balance auto quick
 
 # Override the default cleanup function.
 _cleanup()
-- 
2.39.1

