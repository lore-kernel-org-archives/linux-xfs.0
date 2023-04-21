Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7326AC77B76
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Apr 2023 22:24:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbjDUWYq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Apr 2023 18:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjDUWYp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Apr 2023 18:24:45 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DF131BD7
        for <linux-xfs@vger.kernel.org>; Fri, 21 Apr 2023 15:24:44 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-63b7096e2e4so2396412b3a.2
        for <linux-xfs@vger.kernel.org>; Fri, 21 Apr 2023 15:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1682115883; x=1684707883;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QhdeCI3QilMyjL2fD8tZZlS9uWoF9L7TKC84LZ8ACnY=;
        b=BR/eu9wxo1ityjmlgUFBlzz+zeOXanQtAGamjwG2k7k81TK/4iygMhNxQaqaccdZ1U
         KbP1j+QhOnOVkWpDu1+tJpspj1tR4ZR3iAvRVOOLMRcd9y5MUPXQ0w/aDnqmXCbVC+sk
         f7cd/M3D1ZS5BScXVnydA9wGddOx8yvxw4ddpulUzRCmfQiZF7Y7xwwbH7ygRge6JcMU
         a2b4KfgqoirA0omV5q2HdWf8ljSEDoBIWdkAJJZ7BfPI8aM9YA57ZehAteQoTP6pPp91
         LSC+BJWCjZkQprI+qKs14cbrCLS5k+s8V9JxB8b2GD5txfq6wutKKMi8V4hSt+8El5Dd
         /yZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682115883; x=1684707883;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QhdeCI3QilMyjL2fD8tZZlS9uWoF9L7TKC84LZ8ACnY=;
        b=b6dqtDLgTwkZGq7d7p0e2dfYWkqkc4PzNPKb1p2QySwmTQGJQFWujkZaE45hBWf480
         IUrxRat3GDduj4orgVM7UHweRyH2Q2EvQ0vINDOqEgQ4V4Qg8nawNW8rYWTo/RSr3q4d
         qnCxKE+tkWBMoH6YQQo2s+kpZj4BbyrJbEKxVjO/CVvuIKl3k+AUR6EvJ68MqcCUzE1+
         fPI3Y2+38+64wcH66fu8Ji/X9PUBmNWH+CsfM0f54SZFJcTBhGMTBhFC+tJ8w166etXK
         YYcm+9E2r/dQRTEaPGArfkU7eS5W3AtYyM3NZkgS9s+ThbL27Bts7OjF7slGeY7m8p5p
         OKWg==
X-Gm-Message-State: AAQBX9dgtK4tMfPMmxW705AnxCQtVn89eD9sBzK8MTWZmHeePK0esXQj
        rwXnHwTqyXIpmhkW1T30Wx0bC54MnzgfTYSpTcA=
X-Google-Smtp-Source: AKy350YwMcdMsSxWLr53G061RGysVDZ1XykYjG4E43t47404696C/s86jwDyFNOKq3HvdE/NwQXGmg==
X-Received: by 2002:a05:6a21:6d98:b0:ec:60b9:c724 with SMTP id wl24-20020a056a216d9800b000ec60b9c724mr8654927pzb.33.1682115883579;
        Fri, 21 Apr 2023 15:24:43 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-41-174.pa.nsw.optusnet.com.au. [49.180.41.174])
        by smtp.gmail.com with ESMTPSA id c17-20020a056a000ad100b005ae02dc5b94sm3417270pfl.219.2023.04.21.15.24.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 15:24:43 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1ppzBI-006DZk-Ie; Sat, 22 Apr 2023 08:24:40 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1ppzBI-00BQFD-1j;
        Sat, 22 Apr 2023 08:24:40 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     bfoster@redhat.com
Subject: [PATCH] xfs: fix livelock in delayed allocation at ENOSPC
Date:   Sat, 22 Apr 2023 08:24:40 +1000
Message-Id: <20230421222440.2722482-1-david@fromorbit.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

On a filesystem with a non-zero stripe unit and a large sequential
write, delayed allocation will set a minimum allocation length of
the stripe unit. If allocation fails because there are no extents
long enough for an aligned minlen allocation, it is supposed to
fall back to unaligned allocation which allows single block extents
to be allocated.

When the allocator code was rewritting in the 6.3 cycle, this
fallback was broken - the old code used args->fsbno as the both the
allocation target and the allocation result, the new code passes the
target as a separate parameter. The conversion didn't handle the
aligned->unaligned fallback path correctly - it reset args->fsbno to
the target fsbno on failure which broke allocation failure detection
in the high level code and so it never fell back to unaligned
allocations.

This resulted in a loop in writeback trying to allocate an aligned
block, getting a false positive success, trying to insert the result
in the BMBT. This did nothing because the extent already was in the
BMBT (merge results in an unchanged extent) and so it returned the
prior extent to the conversion code as the current iomap.

Because the iomap returned didn't cover the offset we tried to map,
xfs_convert_blocks() then retries the allocation, which fails in the
same way and now we have a livelock.

Reported-by: Brian Foster <bfoster@redhat.com>
Fixes: 85843327094f ("xfs: factor xfs_bmap_btalloc()")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 1a4e446194dd..b512de0540d5 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3540,7 +3540,6 @@ xfs_bmap_btalloc_at_eof(
 	 * original non-aligned state so the caller can proceed on allocation
 	 * failure as if this function was never called.
 	 */
-	args->fsbno = ap->blkno;
 	args->alignment = 1;
 	return 0;
 }
-- 
2.39.2

