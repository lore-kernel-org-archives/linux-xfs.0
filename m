Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3520BCCA482
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jun 2022 16:06:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241523AbiFFQGB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Jun 2022 12:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241568AbiFFQF4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Jun 2022 12:05:56 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F22F1912E8;
        Mon,  6 Jun 2022 09:05:55 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id k16so20493968wrg.7;
        Mon, 06 Jun 2022 09:05:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wIQ8SbeGnrxRzelf44sWZSiCxelEYptJHBoYPCZkwKo=;
        b=Ot/xSCCYP8hNUNiAXKSvq6f4tZNmZ7rKO+T8XkRRg78MzTw/gUBlH4hrdkLg/oY150
         y1CJIJ2wWb2D/ramGOvdlnPU+tjUkf2F9I/TtATnFolCnTxcU567ImRvG4g/+FfKOUh1
         tqjeeJtmHD88Mog3RQJ2HoKx01oHyrcVQLLRtEjhlmjTVSWFTkov9yHQqlTF0mLjX6u/
         Wmt2vIwN8ihAubO98dZ0LC89A7NsPYAtiYCeGNeztiC+YrjgJbnXkgeqbbLhnWNQx7BE
         nUzkWZwHCiIug8NXk70VPf8Emd5tIKUBSJIfBDBMkRbqDvC3Ts3Y6MkYf7DMlohLWmPp
         3iKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wIQ8SbeGnrxRzelf44sWZSiCxelEYptJHBoYPCZkwKo=;
        b=m8zuvX3gen+HVwXKaIRvKQHl9ug1t9n8iXJtNNlEwrBrmPvtzW1GDApaO8ZyWN8Hxv
         KSnWHZtl/eeCEPPlmWvazGzaaOeUQKbpilRywnyFlREX4ootAHghsP39D9iVCCYBVzct
         M75GAnf+bLa18X4VOvH/3nbDGom9DNaC8iBi4abnO/6WuKgwgNtsiWfqGS3ispFNppTz
         c0z0ozI3ohaMbclvUoAe4hx9g1LblIPl8nRESxoBtVNFSsUW+egapSwD0ldJW+Z7gCOW
         Xpfkwu9OwN9rjpbIRO5Wx9h76eJ7pHyxuS/MSlOm3a9SgFSnss/gJscbyGVBMbZ+ByVy
         1ndw==
X-Gm-Message-State: AOAM530H/XWjjzyoEFxj7jQhCC5cD8apU9/igxwUJ9bhMSO2JqYg6MbW
        bJuOJ2GjBvnh5MAxAj9buwE=
X-Google-Smtp-Source: ABdhPJx9FnVRP+SlLfBgtMNCXzFwR6wPt/+IqDxGi8T6pBsKLFVzUzJDfJrFbTV9YM6wRrYyPD7vVg==
X-Received: by 2002:a5d:6b8b:0:b0:211:6641:628c with SMTP id n11-20020a5d6b8b000000b002116641628cmr22847695wrx.105.1654531553904;
        Mon, 06 Jun 2022 09:05:53 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (bzq-166-168-31-246.red.bezeqint.net. [31.168.166.246])
        by smtp.gmail.com with ESMTPSA id n22-20020a05600c3b9600b00397342e3830sm25681327wms.0.2022.06.06.09.05.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 09:05:53 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Anthony Iliopoulos <ailiop@suse.com>
Subject: [PATCH 5.10 CANDIDATE 5/7] xfs: fix xfs_trans slab cache name
Date:   Mon,  6 Jun 2022 19:05:35 +0300
Message-Id: <20220606160537.689915-6-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220606160537.689915-1-amir73il@gmail.com>
References: <20220606160537.689915-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Anthony Iliopoulos <ailiop@suse.com>

commit 25dfa65f814951a33072bcbae795989d817858da upstream.

Removal of kmem_zone_init wrappers accidentally changed a slab cache
name from "xfs_trans" to "xf_trans". Fix this so that userspace
consumers of /proc/slabinfo and /sys/kernel/slab can find it again.

Fixes: b1231760e443 ("xfs: Remove slab init wrappers")
Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index b4a3a71bd667..d220a63d7883 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1926,7 +1926,7 @@ xfs_init_zones(void)
 	if (!xfs_ifork_zone)
 		goto out_destroy_da_state_zone;
 
-	xfs_trans_zone = kmem_cache_create("xf_trans",
+	xfs_trans_zone = kmem_cache_create("xfs_trans",
 					   sizeof(struct xfs_trans),
 					   0, 0, NULL);
 	if (!xfs_trans_zone)
-- 
2.25.1

