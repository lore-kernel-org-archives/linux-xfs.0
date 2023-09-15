Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49F2AEED61A
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Sep 2023 18:41:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236595AbjIOSla (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Sep 2023 14:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236829AbjIOSlM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Sep 2023 14:41:12 -0400
X-Greylist: delayed 70 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 15 Sep 2023 11:40:08 PDT
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050:0:465::202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E965E2719;
        Fri, 15 Sep 2023 11:40:08 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [10.196.197.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4RnNJn36Rwz9sbW;
        Fri, 15 Sep 2023 20:39:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
        s=MBO0001; t=1694803177;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iOYqPSu+oVCOd89+RaAtiuAgqa7oaErhDOx7o0+X38E=;
        b=flQNjUnyU25W7ZGoZco4mDtUzalhwJdm/Bip/rbg2I7G+1AE2WK86hUhNm9re8XYQltTbW
        Q1UDpffAJOx5HxpxhTPWaT+BSJpH86ccESygaGzrHRoAl5a6HWVXDBTEyaXOGrB36BUlFJ
        UJidHKi+CEgQGEa5bx3L4Zay4lNQkQrS+WRXtZcwIJXqP8EAA8xyZ7WjuimYFHT6oowESq
        Fo+uCzgXisnLoV5PFAOd1As8LnA3i8F2vc9tZxxok3KJTKvhHophEy6lJ04F5KBoY0aNft
        1ZXo8HQVFMQ3CahHpKra2M7qoAf4kdCWBLeQrGgqKkHiklzRWbTaCAql3Y6Xfw==
From:   Pankaj Raghav <kernel@pankajraghav.com>
To:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     p.raghav@samsung.com, david@fromorbit.com, da.gomez@samsung.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        willy@infradead.org, djwong@kernel.org, linux-mm@kvack.org,
        chandan.babu@oracle.com, mcgrof@kernel.org, gost.dev@samsung.com
Subject: [RFC 16/23] readahead: add folio with at least mapping_min_order in page_cache_ra_order
Date:   Fri, 15 Sep 2023 20:38:41 +0200
Message-Id: <20230915183848.1018717-17-kernel@pankajraghav.com>
In-Reply-To: <20230915183848.1018717-1-kernel@pankajraghav.com>
References: <20230915183848.1018717-1-kernel@pankajraghav.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Luis Chamberlain <mcgrof@kernel.org>

Set the folio order to at least mapping_min_order before calling
ra_alloc_folio().

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 mm/readahead.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/readahead.c b/mm/readahead.c
index 838dd9ca8dad..fb5ff180c39e 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -506,6 +506,7 @@ void page_cache_ra_order(struct readahead_control *ractl,
 {
 	struct address_space *mapping = ractl->mapping;
 	pgoff_t index = readahead_index(ractl);
+	unsigned int min_order = mapping_min_folio_order(mapping);
 	pgoff_t limit = (i_size_read(mapping->host) - 1) >> PAGE_SHIFT;
 	pgoff_t mark = index + ra->size - ra->async_size;
 	int err = 0;
@@ -535,10 +536,16 @@ void page_cache_ra_order(struct readahead_control *ractl,
 				order = 0;
 		}
 		/* Don't allocate pages past EOF */
-		while (index + (1UL << order) - 1 > limit) {
+		while (order > min_order && index + (1UL << order) - 1 > limit) {
 			if (--order == 1)
 				order = 0;
 		}
+
+		if (order < min_order)
+			order = min_order;
+
+		VM_BUG_ON(index & ((1UL << order) - 1));
+
 		err = ra_alloc_folio(ractl, index, mark, order, gfp);
 		if (err)
 			break;
-- 
2.40.1

