Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5B6EC4320A
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 21:50:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B005F60FC1
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 21:50:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbhHBVuk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Aug 2021 17:50:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38345 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230313AbhHBVuk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Aug 2021 17:50:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627941030;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qg6dUznY7Krc9uLhf+rKiMh4Ft5JeGh86ypCDysYG2g=;
        b=FiOo7IiABzoG+MCt1BjFeZ00GY198uIDkicN65StqtNLVri70574g21iJAn9Mp4keJ9BsV
        Saszi7SwKbrjJ4reYIYVP7J2SCA5sVFfZbKKAXX6XyWu2mqiybFAmJW2gSn2bz/teZMM+X
        KK0tLdPVzSjYC7QTNUHzm3plh2ZQJ9k=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-512-f1VagQXyM3CA-PejL16zhg-1; Mon, 02 Aug 2021 17:50:28 -0400
X-MC-Unique: f1VagQXyM3CA-PejL16zhg-1
Received: by mail-wr1-f70.google.com with SMTP id a9-20020a0560000509b029015485b95d0cso1325114wrf.5
        for <linux-xfs@vger.kernel.org>; Mon, 02 Aug 2021 14:50:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qg6dUznY7Krc9uLhf+rKiMh4Ft5JeGh86ypCDysYG2g=;
        b=aCxonbUUp+t+UG9tglDP0BkNFafXOlweglQbunmrJ2uFgd7de9G5JxDMupUNH+ZPGN
         FeNx2hoY+VnQlKWr3sV9gDHpkUSMk9NP3Y43yo1qTmhOqDK754ZBofdKaniQDyMVvbF3
         J6fhHVPx19JWWzVueVsOREQ8LpxH7kc3z+sosYbSlIdqRf4kZn2/sibQYn/wc8qF1iub
         at/dSrjKeGiLiisrAyGeFlzenE4rTZ0tXvaXARZKnGzd4ttv3m7mQ8Zb43MgQUIvcJol
         LtMkKuuJhINZ8PyANntjPH65s7XfOOrCSakHZR0mxmqWZNM8SKhLs0LuqRXJfWC2ov9f
         OB+Q==
X-Gm-Message-State: AOAM5319M8L1TBUwtmRUF8oqE4c2ndcw8fl2XSKGO2a4EV3/EVd5zs8t
        ybtPaxKixxWqL+36gPEFuwDuMUgzGJY22Y4UTFnlNZ4g9qSp4v+R2tt3cKaPI1zh4bonkc9XctG
        0AMtKtSJGlCvbiVOPj8e1qyARiYaZNWWrgz0aqnjXRP+wOloZhsQPoI0t5GditoVVUWPSkCs=
X-Received: by 2002:a05:600c:4f46:: with SMTP id m6mr4196048wmq.68.1627941027203;
        Mon, 02 Aug 2021 14:50:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw/e3XhmkL99nicevby06cu28Twq+Him28oLVc5NqzNRsE+FVgku2EXnQXuh6Up8C4mt01VlQ==
X-Received: by 2002:a05:600c:4f46:: with SMTP id m6mr4196038wmq.68.1627941027027;
        Mon, 02 Aug 2021 14:50:27 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id u11sm12838418wrt.89.2021.08.02.14.50.26
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 14:50:26 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/8] xfsprogs: Rename platform.h -> common.h
Date:   Mon,  2 Aug 2021 23:50:18 +0200
Message-Id: <20210802215024.949616-3-preichl@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210802215024.949616-1-preichl@redhat.com>
References: <20210802215024.949616-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

No other platform then linux is supported so rename to something more
common.
---
 copy/xfs_copy.c                  | 2 +-
 libfrog/{platform.h => common.h} | 0
 libfrog/topology.c               | 2 +-
 libxfs/init.c                    | 2 +-
 libxfs/rdwr.c                    | 2 +-
 repair/xfs_repair.c              | 2 +-
 6 files changed, 5 insertions(+), 5 deletions(-)
 rename libfrog/{platform.h => common.h} (100%)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index fc7d225f..c80b42d1 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -12,7 +12,7 @@
 #include <stdarg.h>
 #include "xfs_copy.h"
 #include "libxlog.h"
-#include "libfrog/platform.h"
+#include "libfrog/common.h"
 
 #define	rounddown(x, y)	(((x)/(y))*(y))
 #define uuid_equal(s,d) (platform_uuid_compare((s),(d)) == 0)
diff --git a/libfrog/platform.h b/libfrog/common.h
similarity index 100%
rename from libfrog/platform.h
rename to libfrog/common.h
diff --git a/libfrog/topology.c b/libfrog/topology.c
index b1b470c9..b059829e 100644
--- a/libfrog/topology.c
+++ b/libfrog/topology.c
@@ -11,7 +11,7 @@
 #endif /* ENABLE_BLKID */
 #include "xfs_multidisk.h"
 #include "topology.h"
-#include "platform.h"
+#include "common.h"
 
 #define TERABYTES(count, blog)	((uint64_t)(count) << (40 - (blog)))
 #define GIGABYTES(count, blog)	((uint64_t)(count) << (30 - (blog)))
diff --git a/libxfs/init.c b/libxfs/init.c
index 1ec83791..d1e87002 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -21,7 +21,7 @@
 #include "xfs_trans.h"
 #include "xfs_rmap_btree.h"
 #include "xfs_refcount_btree.h"
-#include "libfrog/platform.h"
+#include "libfrog/common.h"
 
 #include "libxfs.h"		/* for now */
 
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index fd456d6b..f8e4cf0a 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -17,7 +17,7 @@
 #include "xfs_inode_fork.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
-#include "libfrog/platform.h"
+#include "libfrog/common.h"
 
 #include "libxfs.h"
 
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 38406eea..af24b356 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -23,7 +23,7 @@
 #include "slab.h"
 #include "rmap.h"
 #include "libfrog/fsgeom.h"
-#include "libfrog/platform.h"
+#include "libfrog/common.h"
 #include "bulkload.h"
 #include "quotacheck.h"
 
-- 
2.31.1

