Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA39CC3A59F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 00:30:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8767F21874
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 00:30:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YUluvd3R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbfH3Aa1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 20:30:27 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34395 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727096AbfH3Aa1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 20:30:27 -0400
Received: by mail-pg1-f195.google.com with SMTP id n9so2534379pgc.1;
        Thu, 29 Aug 2019 17:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=laobROPMCD2dDBoUPF6ZOG8vC/RUeuCzEEYz7L8tAVA=;
        b=YUluvd3R2pC2zOLTvie3Ri5/rwIIDDMPdRoHLUKZQm3VlFTMsCcPhGQDKLJjew+kO2
         C4NNa3Ju3jSyv/W8tsmeXQydQpUImWGEod8YQq3Yz41m4pqVwh9JyUAqnzpRUjXE4/ld
         eqOLNN3hvwzn2Iwmx+k7enJSYD9fz/iQbF8GFH6Tjwz3bvgQCqaQCTmffFZ9jkuMUVgR
         FqoCDz2zZD7NRzdJRQBFyAieNR1BaVQKiPs1pwrm6GLqvMOqC3ib+yfKTxi2VX2tmkSu
         DxSSI2c9XoGDd8Ipia2BYZCt+ThGQBal9docK/DGuhBGYZCJaGB12w9JPgpGYND634f4
         dVow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=laobROPMCD2dDBoUPF6ZOG8vC/RUeuCzEEYz7L8tAVA=;
        b=mDwCKfq3VlLANVCokjyCbviwZ9gGj0PT0WJJsS+USNAbASxKio2fKtQtm64wgNxAJy
         C9NNepy77XGLitffV57iinbMEf33uhMhqzGGq/6dSQ6ZIYUwfI/Cu1SBBGWI29ylSR7n
         UK2xRuuI+m//zkE3IeehXlsaputNb0IqvF8yQrCiMT2vePPw787jmW5O6yqtt1n7c9CJ
         BVHg5ZCSLc2uwGps2GiOThmqCuJb8c7EDzur2a7VxMl3THcVghgyYCzi3PAnh4LQzShu
         UpkjbH+nxnd9ck1qTyGH0Cx03FJoDt5ua0XAM4nKs+2uQO+FRz6eEBoxTBY6vsjuGce5
         0MNg==
X-Gm-Message-State: APjAAAVGE/8mbqvw4eczCp4Fdhrv2Y5GUkKTCQwhKrfHJsu54o5ZdSw7
        RBs37pesdHPD/H3EdO8N0L9/XYRl
X-Google-Smtp-Source: APXvYqyUeMolNuYD14hhNTalzvGVXSLz7WMQ47L05cMLBQoEMo6zxGAGReUiYfDD0cfAQU8TYr9WWA==
X-Received: by 2002:a62:8688:: with SMTP id x130mr15526081pfd.162.1567125026337;
        Thu, 29 Aug 2019 17:30:26 -0700 (PDT)
Received: from LGEARND20B15 ([27.122.242.75])
        by smtp.gmail.com with ESMTPSA id a4sm4143607pfi.55.2019.08.29.17.30.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 17:30:25 -0700 (PDT)
Date:   Fri, 30 Aug 2019 09:30:22 +0900
From:   Austin Kim <austindh.kim@gmail.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        austindh.kim@gmail.com
Subject: [PATCH] xfs: Use WARN_ON_ONCE rather than BUG for bailout
 mount-operation
Message-ID: <20190830003022.GA152970@LGEARND20B15>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

If the CONFIG_BUG is enabled, BUG is executed and then system is crashed.
However, the bailout for mount is no longer proceeding.

For this reason, using WARN_ON_ONCE rather than BUG can prevent this situation.

Signed-off-by: Austin Kim <austindh.kim@gmail.com>
---
 fs/xfs/xfs_mount.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 322da69..c0d0b72 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -213,8 +213,7 @@ xfs_initialize_perag(
 			goto out_hash_destroy;
 
 		spin_lock(&mp->m_perag_lock);
-		if (radix_tree_insert(&mp->m_perag_tree, index, pag)) {
-			BUG();
+		if (WARN_ON_ONCE(radix_tree_insert(&mp->m_perag_tree, index, pag))) {
 			spin_unlock(&mp->m_perag_lock);
 			radix_tree_preload_end();
 			error = -EEXIST;
-- 
2.6.2

