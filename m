Return-Path: <SRS0=WPjR=DA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD6CEC2D0A8
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 06:59:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BDEE221F0
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 06:59:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uuGmAQk8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgIWG7f (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Sep 2020 02:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726652AbgIWG7e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Sep 2020 02:59:34 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF3D9C061755
        for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2020 23:59:34 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id d19so6348827pld.0
        for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2020 23:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bgj/YZjhrsYxUdODnTUVN8FzNBeqdxMgw3D4BR0tbjg=;
        b=uuGmAQk8dvW/SA2/GMc/j+gU+AASuzVpODDznLF9aRF9s/+9XqKOeYJWyRI1iowfbH
         680h/srU9/GnOYvFD4xSZJag02cWNO+khHBXfouFLIHTd/DYWk5TdwU/ggSzhi9eg/6Z
         ya9GeoatEzFby6vnwJyP2tt1eIi16eUFT85uut8sY12vrXaP9vM1uv1cbN1ECPC2t5YH
         ZI4Tbyo/0vo+1NWPAiuaK6ED+WoX7l0fRyI07rCDinX2JOhhnqxz6Xoz62mdKBcKbGLv
         XD5OIRlGGum6oprq4yKrhIUxJr13dF1aR8uhFwVNiu5ukhn66N9FM+hGWQbs+AqnKp3n
         b2IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bgj/YZjhrsYxUdODnTUVN8FzNBeqdxMgw3D4BR0tbjg=;
        b=pSEnBFfTFd8l9TuuI25PWkqkJ6b+qGL4G5YW05E+THlvr43y+G/YAHo4zl56mnElSC
         Ka5+gX4MDZt0CZcfneXnqOSB3lesEtxXI5m6nK+eQ+9HreKNz4AWTC9zEbDj7jkK/ncN
         y/+QBFeknDHB4CrbMEeu+K+1nsMtTs7gsIUV+sJ6DosX6/PlIDeWrCJiTWw+W0p04jjR
         gsFrBdojv+KGdiSTmkqF4GonRKqdxh3NMmp9fZg5fE62fO+AFHi7HjzeS1GfLKjBHGjD
         Q2T24mOP82+mU2CHXBWAJWo1FySPtT5gCkMA0QQjQw3FfUgcPyyoDa67XQ0lTdnZicsO
         Fw6A==
X-Gm-Message-State: AOAM533TqCtlA3wRCvBSIualFwNXpMX1/2uOJvV3rznhp0gZXuzRS210
        dOS70zF0Vzdqr3KTlgRzaT4yGaXITqr2
X-Google-Smtp-Source: ABdhPJwjnGLNjwuUtIGBoSheqVVF+9r79uQNHuWxr+E/wTaC+2wErlzYSt7xfMVIVVWfAyYDMoGpBw==
X-Received: by 2002:a17:902:8489:b029:d2:4363:d47c with SMTP id c9-20020a1709028489b02900d24363d47cmr5315457plo.74.1600844374090;
        Tue, 22 Sep 2020 23:59:34 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id c68sm10685745pfc.31.2020.09.22.23.59.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Sep 2020 23:59:33 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH v3 7/7] xfs: fix some comments
Date:   Wed, 23 Sep 2020 14:59:18 +0800
Message-Id: <1600844358-16601-8-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1600844358-16601-1-git-send-email-kaixuxia@tencent.com>
References: <1600844358-16601-1-git-send-email-kaixuxia@tencent.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

Fix the comments to help people understand the code.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_da_format.h | 4 ++--
 fs/xfs/xfs_dquot.c            | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 78225cc959d6..f13ee8939e78 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -35,8 +35,8 @@ typedef struct xfs_da_blkinfo {
  */
 #define XFS_DA3_NODE_MAGIC	0x3ebe	/* magic number: non-leaf blocks */
 #define XFS_ATTR3_LEAF_MAGIC	0x3bee	/* magic number: attribute leaf blks */
-#define	XFS_DIR3_LEAF1_MAGIC	0x3df1	/* magic number: v2 dirlf single blks */
-#define	XFS_DIR3_LEAFN_MAGIC	0x3dff	/* magic number: v2 dirlf multi blks */
+#define	XFS_DIR3_LEAF1_MAGIC	0x3df1	/* magic number: v3 dirlf single blks */
+#define	XFS_DIR3_LEAFN_MAGIC	0x3dff	/* magic number: v3 dirlf multi blks */
 
 struct xfs_da3_blkinfo {
 	/*
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 3072814e407d..1d95ed387d66 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -831,8 +831,8 @@ xfs_qm_dqget_checks(
 }
 
 /*
- * Given the file system, id, and type (UDQUOT/GDQUOT), return a locked
- * dquot, doing an allocation (if requested) as needed.
+ * Given the file system, id, and type (UDQUOT/GDQUOT/PDQUOT), return a
+ * locked dquot, doing an allocation (if requested) as needed.
  */
 int
 xfs_qm_dqget(
-- 
2.20.0

