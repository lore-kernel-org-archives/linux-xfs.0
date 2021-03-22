Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDACDC433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 03:46:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D71361964
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 03:46:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbhCVDpx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 21 Mar 2021 23:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbhCVDpv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 21 Mar 2021 23:45:51 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B0B2C061574;
        Sun, 21 Mar 2021 20:45:51 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id f12so11405556qtq.4;
        Sun, 21 Mar 2021 20:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6+L9vBAEuavtGSZ7afVQ2uB2vTzYH5d/kdoOHfGuczc=;
        b=RSSQiGYkp6J8bqeLbfclNWXuzmSOpCx0uqjhWnN8X/+PIKVM0Qiv7SLnV9CfnYp063
         RFQgR1ChCo0fCKHZW4xtPw9XY4lLFvfByNAMdVBYCSDauB22bdczm7G5d3jXZGlhfDVg
         +x4P2ULmkV/LMrAvHNFrRT5XWg5nSUSvRRbxNWGEzaSeMzFAWKTdpBJxAI6Q4iJWsqUa
         S7xYXL5s8vXs3zvePEfk4BsKVm7HXoL6Irnpq7JSQGWV5VAT+cq7mSU/AxmBW4ZFq/Ry
         A5y4kqy4UvNFe7RyzpvR3vJJ53Tndms8QcHJy9UvOdgVESlaltDtGL/LpAQN8fRW9Y79
         styA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6+L9vBAEuavtGSZ7afVQ2uB2vTzYH5d/kdoOHfGuczc=;
        b=Co5WHVcH29vRMwkZJnducWNDHGdNilwy7tU0h8R5LBX6dzNLhxcxNpCIj9TdcuHpTt
         EHAQtYkmFThtO5b4lZ3vwKVrOgVDwCSDCGW9CTz60u3VZXvz2qsy0whS5fCTJt7Dc/vx
         doB63tB+RChVMhJIQJtCLYLWULp+5OGEt6wjukxqK21fDiN1EeOY8mjDwTJekxGJtmRz
         +NEKoitH17WYumkcGQDA/5SemHbYDuJYddtHgHxrH2kGJ5mJmJ5TYs7yegdJUi4OWI3U
         1YqXD5w17rF4PfGxO81QYqbHDWe+DcjP3s9PhqHEL3mnRxUI1xOE2Z1RzxO0Ga59ztXt
         AdDA==
X-Gm-Message-State: AOAM53030yyZb2zkwo2MMj32y+k+0aM+5LD6Ufm4HoxcRMs+Sszt9rSm
        80VPw5RMob5433N0/6pbpAaY4P41+9hWdOxC
X-Google-Smtp-Source: ABdhPJyx8YZNBagSuObc0hXK2pKeyBf2+klnSrVO1S9DxXiWe7XQcwUELDLFB67c/GrGe4wedUi3LA==
X-Received: by 2002:ac8:424b:: with SMTP id r11mr8131474qtm.311.1616384750630;
        Sun, 21 Mar 2021 20:45:50 -0700 (PDT)
Received: from localhost.localdomain ([156.146.54.190])
        by smtp.gmail.com with ESMTPSA id d12sm8287618qth.11.2021.03.21.20.45.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 20:45:50 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     djwong@kernel.org, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH V2] xfs: Rudimentary spelling fix
Date:   Mon, 22 Mar 2021 09:15:38 +0530
Message-Id: <20210322034538.3022189-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

s/sytemcall/syscall/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
  Changes from V1:
   Randy's suggestion incorporated.

 fs/xfs/xfs_inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index f93370bd7b1e..3087d03a6863 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2870,7 +2870,7 @@ xfs_finish_rename(
 /*
  * xfs_cross_rename()
  *
- * responsible for handling RENAME_EXCHANGE flag in renameat2() sytemcall
+ * responsible for handling RENAME_EXCHANGE flag in renameat2() syscall
  */
 STATIC int
 xfs_cross_rename(
--
2.31.0

