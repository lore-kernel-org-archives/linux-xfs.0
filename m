Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BB8EEED620
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Sep 2023 18:41:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235871AbjIOSk5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Sep 2023 14:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236832AbjIOSkm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Sep 2023 14:40:42 -0400
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [IPv6:2001:67c:2050:0:465::103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDBD035AA;
        Fri, 15 Sep 2023 11:39:54 -0700 (PDT)
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4RnNJc0jbrz9skM;
        Fri, 15 Sep 2023 20:39:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
        s=MBO0001; t=1694803168;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q4TCivlOldBFT8Z2wAp0Ng9dYEvWAP3/q/X1t2+ztPU=;
        b=RPZ4s8vKpZT/VgCDTXGfaQnmmINoQDMFRzcMXIHnpBidw45xmmsecAsEx/bgHiklwedk3E
        jvirvcLSdjCEKPoKBTXOwRhiD+JcHZqICcAdTub1hkWK1sl+vUO2I19nRcEBG44QWyKZYa
        Q9/F/S6P5EG0+NyIw3zXCVgYKM66eP7A+kreb4oIgyIl6glr1J0ELYt+/5YuNN/+WZ++4c
        gG0NIEJsO5zNGaAPcdC78ZH6UEtst+I+MpVN/IUixQdfIfKRDwezhqBQuACrnDm0eW/GMh
        9oc+cvHQHKIr4P0CNSWVZ8eOFxkQ1CJn2IaTfklFETTMeeOw5hpiP+jYbhuJCg==
From:   Pankaj Raghav <kernel@pankajraghav.com>
To:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     p.raghav@samsung.com, david@fromorbit.com, da.gomez@samsung.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        willy@infradead.org, djwong@kernel.org, linux-mm@kvack.org,
        chandan.babu@oracle.com, mcgrof@kernel.org, gost.dev@samsung.com
Subject: [RFC 13/23] readahead: set file_ra_state->ra_pages to be at least mapping_min_order
Date:   Fri, 15 Sep 2023 20:38:38 +0200
Message-Id: <20230915183848.1018717-14-kernel@pankajraghav.com>
In-Reply-To: <20230915183848.1018717-1-kernel@pankajraghav.com>
References: <20230915183848.1018717-1-kernel@pankajraghav.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4RnNJc0jbrz9skM
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Luis Chamberlain <mcgrof@kernel.org>

Set the file_ra_state->ra_pages in file_ra_state_init() to be at least
mapping_min_order of pages if the bdi->ra_pages is less than that.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 mm/readahead.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/readahead.c b/mm/readahead.c
index ef3b23a41973..5c4e7ee64dc1 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -138,7 +138,13 @@
 void
 file_ra_state_init(struct file_ra_state *ra, struct address_space *mapping)
 {
+	unsigned int order = mapping_min_folio_order(mapping);
+	unsigned int min_nrpages = 1U << order;
+	unsigned int max_pages = inode_to_bdi(mapping->host)->io_pages;
+
 	ra->ra_pages = inode_to_bdi(mapping->host)->ra_pages;
+	if (ra->ra_pages < min_nrpages && min_nrpages < max_pages)
+		ra->ra_pages = min_nrpages;
 	ra->prev_pos = -1;
 }
 EXPORT_SYMBOL_GPL(file_ra_state_init);
-- 
2.40.1

