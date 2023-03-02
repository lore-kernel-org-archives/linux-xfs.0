Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 220DEC6FA8E
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Mar 2023 23:11:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbjCBXL4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Mar 2023 18:11:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjCBXLz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Mar 2023 18:11:55 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B8B4DE23
        for <linux-xfs@vger.kernel.org>; Thu,  2 Mar 2023 15:11:54 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id i5so930687pla.2
        for <linux-xfs@vger.kernel.org>; Thu, 02 Mar 2023 15:11:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112; t=1677798714;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xTxeiT7xT2Qrf0Dkpul9ZQi+TSSZXmrtixTQFazYnW0=;
        b=3BN0fgOMIdzqbTAxAYlAZO/4Pz5DxErAfyJZu0e8YZXaILwL3YmjeLv2bsiMGK1LFT
         CC02XMn8XdlypSfuQ8e8/h6AwedJPXYgvyp3KFjAm9yVB7DIKygJp70p3BuBTbsl2j/F
         BFDEo2uHWEGP3QpclpVb8o7GA+e4/uAgVgtCFWQnLmTUiQS16WV+8Vm6Mnf7/XvH/7MR
         LuNnGEBb2D/FK/l4xzrQhCvK4I2YOaPvBYFBhZQvufDFx137A2LpAOQnEuT8qxeulNjF
         R7XNSAXO1FENMeOVPyMUnhF8TRhocf67LWkP7VJ0GEw5cCuN8WsLSxp+WXsOAeT2o85/
         0ITA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677798714;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xTxeiT7xT2Qrf0Dkpul9ZQi+TSSZXmrtixTQFazYnW0=;
        b=FZbJXfB07ZN7kuz9Nm9ZLEcM8fDurAdmom3Wg9DV8gaMhVjxcOrDEJHT1aDxp7voMr
         uZseAkFbuJmijoydlvG5ImZvdlNPOZ9zx+WjSL4cifqOUZLR57PvWYrLb830k1ha4aiD
         CfynF014l66njtpNiJbsABEc4VkZEhYR2NL94u7VGvfsU93wJDnoQVBew0m84yXRfmZK
         ovlGP4VeApKU5fOCJehiSXZIqJqUA+jJbhjKExeXeFgsbPJmVVg5Gm+iMOo719gK8GTC
         ibxSvlPofbbxzDNvvPUUiWTH4FpSufrYCyo4gCsApRmlI5pLB82HdEABaA1MTKjKKujQ
         OpOg==
X-Gm-Message-State: AO0yUKVbfd8vExKtQ+4ECwT0is0mng7dH3aQLlHXTzHk+FbTTHgDTAPR
        jlMzvGXebbRduSACh+uoEeS64F7fa9FgesjQ
X-Google-Smtp-Source: AK7set8E2X7b1y+MyHXRxLjGDX5OCaurMiJgj5jASe9WkmJ1jWoHu9SCtLyN1zKAACT54tA2l8AE0w==
X-Received: by 2002:a17:90a:1d1:b0:230:a1ce:f673 with SMTP id 17-20020a17090a01d100b00230a1cef673mr13780212pjd.4.1677798713750;
        Thu, 02 Mar 2023 15:11:53 -0800 (PST)
Received: from dread.disaster.area (pa49-186-4-237.pa.vic.optusnet.com.au. [49.186.4.237])
        by smtp.gmail.com with ESMTPSA id it6-20020a17090afb0600b00234899c65e7sm263336pjb.28.2023.03.02.15.11.53
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 15:11:53 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pXs5W-004613-Ha
        for linux-xfs@vger.kernel.org; Fri, 03 Mar 2023 10:11:50 +1100
Date:   Fri, 3 Mar 2023 10:11:50 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH V2] xfs: fix off-by-one-block in xfs_discard_folio()
Message-ID: <20230302231150.GK360264@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The recent writeback corruption fixes changed the code in
xfs_discard_folio() to calculate a byte range to for punching
delalloc extents. A mistake was made in using round_up(pos) for the
end offset, because when pos points at the first byte of a block, it
does not get rounded up to point to the end byte of the block. hence
the punch range is short, and this leads to unexpected behaviour in
certain cases in xfs_bmap_punch_delalloc_range.

e.g. pos = 0 means we call xfs_bmap_punch_delalloc_range(0,0), so
there is no previous extent and it rounds up the punch to the end of
the delalloc extent it found at offset 0, not the end of the range
given to xfs_bmap_punch_delalloc_range().

Fix this by handling the zero block offset case correctly.

Fixes: 7348b322332d ("xfs: xfs_bmap_punch_delalloc_range() should take a byte range")
Reported-by: Pengfei Xu <pengfei.xu@intel.com>
Found-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---

Version 2
- update xfs_discard_folio() comment to reflect reality
- simplify the end offset calculation and comment to reflect the
  fact the punch range always ends at the end of the supplied folio
  regardless of the position we start the punch from.

 fs/xfs/xfs_aops.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 41734202796f..2ef78aa1d3f6 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -449,15 +449,17 @@ xfs_prepare_ioend(
 }
 
 /*
- * If the page has delalloc blocks on it, we need to punch them out before we
- * invalidate the page.  If we don't, we leave a stale delalloc mapping on the
- * inode that can trip up a later direct I/O read operation on the same region.
+ * If the folio has delalloc blocks on it, the caller is asking us to punch them
+ * out. If we don't, we can leave a stale delalloc mapping covered by a clean
+ * page that needs to be dirtied again before the delalloc mapping can be
+ * converted. This stale delalloc mapping can trip up a later direct I/O read
+ * operation on the same region.
  *
- * We prevent this by truncating away the delalloc regions on the page.  Because
+ * We prevent this by truncating away the delalloc regions on the folio. Because
  * they are delalloc, we can do this without needing a transaction. Indeed - if
  * we get ENOSPC errors, we have to be able to do this truncation without a
- * transaction as there is no space left for block reservation (typically why we
- * see a ENOSPC in writeback).
+ * transaction as there is no space left for block reservation (typically why
+ * we see a ENOSPC in writeback).
  */
 static void
 xfs_discard_folio(
@@ -475,8 +477,13 @@ xfs_discard_folio(
 		"page discard on page "PTR_FMT", inode 0x%llx, pos %llu.",
 			folio, ip->i_ino, pos);
 
+	/*
+	 * The end of the punch range is always the offset of the the first
+	 * byte of the next folio. Hence the end offset is only dependent on the
+	 * folio itself and not the start offset that is passed in.
+	 */
 	error = xfs_bmap_punch_delalloc_range(ip, pos,
-			round_up(pos, folio_size(folio)));
+				folio_pos(folio) + folio_size(folio));
 
 	if (error && !xfs_is_shutdown(mp))
 		xfs_alert(mp, "page discard unable to remove delalloc mapping.");
