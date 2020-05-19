Return-Path: <SRS0=UH25=7B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3907FC433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 06:38:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13281207D8
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 06:38:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="er33yqCc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbgESGiv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 May 2020 02:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726841AbgESGiv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 May 2020 02:38:51 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D86C061A0C
        for <linux-xfs@vger.kernel.org>; Mon, 18 May 2020 23:38:50 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id p21so5926399pgm.13
        for <linux-xfs@vger.kernel.org>; Mon, 18 May 2020 23:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=tQMnvRU+IDkdiJKep97Zbo4i7WT86bo/Uxtwr/dZ5Jc=;
        b=er33yqCcQNmDtv31yINidjucIFcGE6Ik7ndt/pUEQt6K/KQwvItr1sB7cGWDXIw+H/
         dXM62FUuGMJp6Deu+2W/BkpQ1mzvpP24zqG8PTDLu2iMQh6Jw6one6eCid2R0wE7aUP3
         YL1GxFZIpYc4f507yzJWhBkD1FT4OKHYemEEvQViyTDW9SqAz927lyDY1SDYDCrkVdPe
         6YOJuHra6lm8haglbbuSzSrs/0VvClJleME06YCQzOaqanjLR34m1GxGkzJCxQ3juf3j
         SzdnvgOQ3+I9dKVE9/i+fwAmDMxU4ExYH/YtO37FNKd9T44TCwMNKIqORo2Jo54uA/d6
         0ZPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=tQMnvRU+IDkdiJKep97Zbo4i7WT86bo/Uxtwr/dZ5Jc=;
        b=GDybpi+j45GruYeO/G/bcBiV2pIJDxbefvN932Do9XjG/xrj9sy+PC8uL0ouo56icw
         1BJdz1aEz2LnG0cfXUFGI4N9t7gP2TVbrOsWIALSVO/JWH/wT9niHC/nq+Xz6l1/YPpY
         giHRrlREsW16GzwzVDp7j3Q6ULLDKA+xMfkwt07wzBVHX3nCnZFZQrFoYKTxv7UHN+jl
         ptPouLkyFfQMJMWy+l6Ujr8y5dcXByLZwKwY8XxkDgeZVb3VVKkirqkNVPP6FgfkFc8f
         YQfjypJ16Fv8mffv3RpoGkNx7s5EkD7RNoUMjlUG0ZyrivvmZwVJwGC4lHhmsOnnMUYI
         LWrA==
X-Gm-Message-State: AOAM532Ra9mtiNYexeydvLFhwGdKhHK09e6grcLTff0IQcb8gBi14Y2n
        LnUIG8+Vze0+Yf4Bj7pNk02LqOA=
X-Google-Smtp-Source: ABdhPJxoKKLrk/ACkTZifbzqcKW+Jyglk2MUCfnKjQPsu/hfPSDHfz5aSOLMXWHhw0/8M5FWhwQI9g==
X-Received: by 2002:aa7:92cc:: with SMTP id k12mr19477683pfa.184.1589870330221;
        Mon, 18 May 2020 23:38:50 -0700 (PDT)
Received: from he-cluster.localdomain ([67.216.221.250])
        by smtp.gmail.com with ESMTPSA id k13sm8072804pfd.14.2020.05.18.23.38.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 May 2020 23:38:49 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH] mkfs: simplify the configured sector sizes setting in validate_sectorsize
Date:   Tue, 19 May 2020 14:38:40 +0800
Message-Id: <1589870320-29475-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

There are two places that set the configured sector sizes in validate_sectorsize,
actually we can simplify them and combine into one if statement.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 mkfs/xfs_mkfs.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 039b1dcc..e1904d57 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1696,14 +1696,6 @@ validate_sectorsize(
 	int			dry_run,
 	int			force_overwrite)
 {
-	/* set configured sector sizes in preparation for checks */
-	if (!cli->sectorsize) {
-		cfg->sectorsize = dft->sectorsize;
-	} else {
-		cfg->sectorsize = cli->sectorsize;
-	}
-	cfg->sectorlog = libxfs_highbit32(cfg->sectorsize);
-
 	/*
 	 * Before anything else, verify that we are correctly operating on
 	 * files or block devices and set the control parameters correctly.
@@ -1730,6 +1722,7 @@ validate_sectorsize(
 	memset(ft, 0, sizeof(*ft));
 	get_topology(cli->xi, ft, force_overwrite);
 
+	/* set configured sector sizes in preparation for checks */
 	if (!cli->sectorsize) {
 		/*
 		 * Unless specified manually on the command line use the
@@ -1759,9 +1752,10 @@ _("specified blocksize %d is less than device physical sector size %d\n"
 				ft->lsectorsize);
 			cfg->sectorsize = ft->lsectorsize;
 		}
+	} else
+		cfg->sectorsize = cli->sectorsize;
 
-		cfg->sectorlog = libxfs_highbit32(cfg->sectorsize);
-	}
+	cfg->sectorlog = libxfs_highbit32(cfg->sectorsize);
 
 	/* validate specified/probed sector size */
 	if (cfg->sectorsize < XFS_MIN_SECTORSIZE ||
-- 
2.20.0

