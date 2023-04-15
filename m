Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CC72C77B73
	for <linux-xfs@archiver.kernel.org>; Sat, 15 Apr 2023 22:45:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbjDOWpj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 15 Apr 2023 18:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjDOWpi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 15 Apr 2023 18:45:38 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 762971BEC
        for <linux-xfs@vger.kernel.org>; Sat, 15 Apr 2023 15:45:37 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-63b70f0b320so577182b3a.1
        for <linux-xfs@vger.kernel.org>; Sat, 15 Apr 2023 15:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1681598737; x=1684190737;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=gqOJC0alGSWXVk0klsx/uBvCTNNWYdEedqkZz2HvgRA=;
        b=uszqIXEDE6YeMj3hu4UPrJlryvdLNRzB1wXsqbM3p5i78vck6XheeV2jPeocwzv7n3
         3y4KwB1+J5jUl08oNdM9syPWI1IQsWRoC/DZRh/PHbAYGfPTBhEK1gadaNLjlnxboACF
         TqaV/yZEEfghJ0f0LK5XTBruOZ4B6tn9tEIcpqIyCye+5hFMCImHWiSHduuyHwzlD0Bf
         yT9LylviXDrbUVHqm7pJrPs1/VsU+QPPy8+zENYv+X/GaBje7Q62/Yu8wqh3eGE1LWcb
         W3j8coUNRToctJjCQlUA5++ys0m8QcR6Wl/c4465CkG3f/siEpV/R379a43kdOetVw3V
         wHLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681598737; x=1684190737;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gqOJC0alGSWXVk0klsx/uBvCTNNWYdEedqkZz2HvgRA=;
        b=FBmMOw2dMeHMFywp7mZnnegqDo/BWD9bhHtNxovWTqa8mR430+E22cSCDWxoUZR9bD
         VlUKU1khhKZko4D4dYu98xv5nxgc3tEoPxf76ZFq9hMFHbqdlfRKUzyXfQ1rYX/HMyrX
         jyhnCaj9NYnCDMdjgomhMsjeAHHYKZPO7pZrM0WM/vpi/bQUxathotP32GVfMofM1RnQ
         dI9IHosc/9fktXWpfWKDdlpgh8jsy9bUW/IdgAZ769xZcefxOs9QVruYwCInmpXU1EuW
         sj8w6uRsFNxnh8YSUS1+MJ0JBXRj6RA0CIPAWUGagOIwMFf258q45BCsQlvo1lJZc9wW
         X7pQ==
X-Gm-Message-State: AAQBX9fBvrT+h0j2J+ev3z54QWKFOMkjWIe7zTqe4NDw2rNCmB7vJizo
        mJ6T5PNmGU9l9wYBKqaZaQO5G9xRw2p2yLZ6NpM0vQ==
X-Google-Smtp-Source: AKy350Ywp4ck7B5+XC5UqRF5zPSjNFRxffcSm19wyqcnCWPMIDM6Cu8yWpiFGfQIvyXZh3sBtnaK/Q==
X-Received: by 2002:a05:6a00:22c9:b0:63b:7ab1:6c53 with SMTP id f9-20020a056a0022c900b0063b7ab16c53mr5422428pfj.8.1681598736924;
        Sat, 15 Apr 2023 15:45:36 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-41-174.pa.nsw.optusnet.com.au. [49.180.41.174])
        by smtp.gmail.com with ESMTPSA id r10-20020a63d90a000000b0051b72ef978fsm2752483pgg.20.2023.04.15.15.45.35
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Apr 2023 15:45:36 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pnoeC-003qhJ-JG
        for linux-xfs@vger.kernel.org; Sun, 16 Apr 2023 08:45:32 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pnoeC-002XLl-1l
        for linux-xfs@vger.kernel.org;
        Sun, 16 Apr 2023 08:45:32 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: fix duplicate includes
Date:   Sun, 16 Apr 2023 08:45:32 +1000
Message-Id: <20230415224532.604844-1-david@fromorbit.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Header files were already included, just not in the normal order.
Remove the duplicates, preserving normal order. Also move xfs_ag.h
include to before the scrub internal includes which are normally
last in the include list.

Fixes: d5c88131dbf0 ("xfs: allow queued AG intents to drain before scrubbing")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/scrub/refcount.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index ed5eb367ce49..304ea1e1bfb0 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -9,6 +9,7 @@
 #include "xfs_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
+#include "xfs_ag.h"
 #include "xfs_btree.h"
 #include "xfs_rmap.h"
 #include "xfs_refcount.h"
@@ -16,9 +17,6 @@
 #include "scrub/common.h"
 #include "scrub/btree.h"
 #include "scrub/trace.h"
-#include "xfs_trans_resv.h"
-#include "xfs_mount.h"
-#include "xfs_ag.h"
 
 /*
  * Set us up to scrub reference count btrees.
-- 
2.39.2

