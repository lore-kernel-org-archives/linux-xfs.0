Return-Path: <SRS0=KYGq=CZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A8FAC43461
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Sep 2020 20:23:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FB0A21941
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Sep 2020 20:23:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P+dJGFNO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbgIPUXk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Sep 2020 16:23:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727092AbgIPR2X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Sep 2020 13:28:23 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB3CC0698C2
        for <linux-xfs@vger.kernel.org>; Wed, 16 Sep 2020 04:19:29 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id o20so3754483pfp.11
        for <linux-xfs@vger.kernel.org>; Wed, 16 Sep 2020 04:19:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=S3Epjv9w0LHvPlkba7DGhBp1VxXvar4r/UAB1crOeW0=;
        b=P+dJGFNOC7PpIOlNRQp9Cip0JztcqdSoOYHfypjeOmrJO6foTc9dfd99jBlGoZs7iq
         n81ZiEe+Gjx1Zt9Q2UrXto6OJb2OkEWQfh8tN4+wvffZb2DUZA1VQutI3q4ijJC1/M1h
         +6x3MherKsflb5ccqbS0cEpBdCBYizXExKAEHYc7e8zeU3ewI3A9NRdH1E7XsHjBz5u1
         sMFEifmBBBqEuBNdWz9d5I6ln2ntBmSOXejfxVbyrA0MD7gqazezXSKlTjvMa3UzyfyB
         Su1HumMXEVG/7e8McOY4GYkl0/P3dxWlfQDC8Apq/vkHJK8x79MKHcvH5QHr6bbUrEp5
         GiYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=S3Epjv9w0LHvPlkba7DGhBp1VxXvar4r/UAB1crOeW0=;
        b=C1wJSsPA2e1f/8vBVe5wylVx8W13ymBOsN4HT9WkAdxRkwUYtREUGSh4yJrEvXTzci
         hIQMIQ5EKQcitjgSQlt2KvUyZ0SxDjnEdrWVPujpBWQUnpOvqGHYXgPWqCA6XMkEBeAL
         Q+atvvWJ072pgrcT3LCQH94E+M7frRQ0NLfHHuW5X5IuYb8r/VyWsXq9z31dlWNZ7fWw
         4XIzpFbTwT5ystbAIff16vqFf+usI4TGhloYEHW7TFpHrpSclbrSYaQh/niJMph2YrZa
         F1C0huejDSAhVmDCxAkh8nd9X78rsx6PLL6ia8Rn4kO66fgmXSKggMg37y3iHNOMom4q
         PMmw==
X-Gm-Message-State: AOAM532jKgG/8r9iZA7NKCSYeLxAeAPCsRMvg6VNZ/2wwPWStqQkfGfs
        1xUhgJC65pK/UwN67TAL0x1IzpeC2rN4
X-Google-Smtp-Source: ABdhPJwQcIopbXHIdWDu7196yFJQB5JAFiszeqLQ9+wxN3HLfX6xzbDIBVZW2bZANWX9hBQgkOGI3g==
X-Received: by 2002:a62:2985:0:b029:142:2501:34d6 with SMTP id p127-20020a6229850000b0290142250134d6mr5906951pfp.47.1600255168793;
        Wed, 16 Sep 2020 04:19:28 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id v204sm3492195pfc.10.2020.09.16.04.19.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Sep 2020 04:19:28 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH] xfs: fix some comments
Date:   Wed, 16 Sep 2020 19:19:12 +0800
Message-Id: <1600255152-16086-10-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1600255152-16086-1-git-send-email-kaixuxia@tencent.com>
References: <1600255152-16086-1-git-send-email-kaixuxia@tencent.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

Fix the comments to help people understand the code.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 fs/xfs/libxfs/xfs_da_format.h | 4 ++--
 fs/xfs/xfs_dquot.c            | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 4fe974773d85..b58943f2eb41 100644
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

