Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2A03C28CBC
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 14:59:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AB012083B
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 14:59:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q+3Up5Hj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728005AbgEIO75 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 10:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726782AbgEIO75 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 10:59:57 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DFE2C061A0C
        for <linux-xfs@vger.kernel.org>; Sat,  9 May 2020 07:59:57 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id b12so72210plz.13
        for <linux-xfs@vger.kernel.org>; Sat, 09 May 2020 07:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=i+tAnuK5SkoNquAQL0UA5l0BzJYq4XRNXMVdYvicKqA=;
        b=Q+3Up5HjyCsglpPw7uL7FJrgvk1GWP+qM8tor+fOh9hMf8QF25owRMezPeR5Orb6mO
         iILLWT3hTDLsZTY1TybejNw+PMWloGu9ZoYqrAuIpaOvCAzktE3PxXdbtUROnYZXaoXP
         StWYZlUnIwz2asfvsKLUPPA1u5B+jrYNe/cL9IPUS6FGl38upBVsiZL89NyUy2NyeCSa
         TrKaSRYjMWcxpOUfsKv9+5uExKb7ugR7EggUMheoA+oMxaB5SRm7Z2j6brCOv59OJmw8
         DtOsgn8hOFCnGTVlaJvQAB+9x4KWIWkz5UpPhIQZDeehirsFsUC8ChgB7DaQsYNem4zv
         6Fmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=i+tAnuK5SkoNquAQL0UA5l0BzJYq4XRNXMVdYvicKqA=;
        b=YL9dT+sSKUh6bhtKOf2gr+F2QfIJsQsRBm0mZQ17l43os/uRqF6mS4V+scCaH9rQwp
         3Bm2M5Qqj/Vpv7Qcj8KOWR/nO4aVvEoeoONK9CsFQRoBBBJnpHuX1409KFxnKJbTi6by
         R0IcgqwLXZeITZv674Lo5GfYs5nkMOj1jfeO+be3RUwaaqNbBTdsqQk0bBth39eBXER6
         psKoe5UTCJBZ6Rq3gcpaAZGU8oNFfkJZNpIfAjEeobySciHgGPCT+POP1whk0AMmBo/4
         wToXVGm5Dtt5q7G6vhbdcYLiwjlb6WHhkShc4EFjQfsG1VIx/DeeYOha7CgcSX3dULWE
         Tn0g==
X-Gm-Message-State: AGi0PuYuG6AOH9gyA5LtNdRRieYvzpM3wuUuQvEZWyQnFjnHS2ZBrinO
        pP++GWqF+OqU0k28QkhMMr5qUAo=
X-Google-Smtp-Source: APiQypIcufQRHu4zUaP85Qa6T/8Grj9K41f6E2gDToAd2uuKvkeJ6xclzmqXdEve77XAJGkY5C/Yrg==
X-Received: by 2002:a17:902:9f8a:: with SMTP id g10mr7323481plq.233.1589036396457;
        Sat, 09 May 2020 07:59:56 -0700 (PDT)
Received: from he-cluster.localdomain ([67.216.221.250])
        by smtp.gmail.com with ESMTPSA id a12sm4794833pfr.28.2020.05.09.07.59.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 09 May 2020 07:59:55 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH] xfs: fix the warning message in xfs_validate_sb_common()
Date:   Sat,  9 May 2020 22:59:47 +0800
Message-Id: <1589036387-15975-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

The warning message should be PQUOTA/GQUOTA_{ENFD|CHKD} can't along
with superblock earlier than version 5, so fix it.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 fs/xfs/libxfs/xfs_sb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index c526c5e5ab76..4df87546bd40 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -243,7 +243,7 @@ xfs_validate_sb_common(
 	} else if (sbp->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
 				XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD)) {
 			xfs_notice(mp,
-"Superblock earlier than Version 5 has XFS_[PQ]UOTA_{ENFD|CHKD} bits.");
+"Superblock earlier than Version 5 has XFS_{P|G}QUOTA_{ENFD|CHKD} bits.");
 			return -EFSCORRUPTED;
 	}
 
-- 
2.20.0

