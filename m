Return-Path: <SRS0=nloy=5V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1540C2BA19
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Apr 2020 09:17:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8437C206C1
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Apr 2020 09:17:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C1KlcGXx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgDEJR2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 5 Apr 2020 05:17:28 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:38023 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbgDEJR2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Apr 2020 05:17:28 -0400
Received: by mail-pj1-f66.google.com with SMTP id m15so5123401pje.3
        for <linux-xfs@vger.kernel.org>; Sun, 05 Apr 2020 02:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=b+leENUJgrORs7s4w2DEFFssoBzFRIRTCVgDzwkFbqo=;
        b=C1KlcGXxrLEePvDgE91S8oETAApJ1OW6Z+6kjAdjL3+gAqgjxigXI2BsqKTjrjU/nL
         FHgby9+N9mlGisQqm84NVTcE4QpjKIw1hPXCI5OWah8wtLOwgp8KAp15veXWCVbh10XU
         XP/2mxIIkj56lubP571N3EitLNA4lr+Y/drsq8BApztvVyoAq5bmjv5GNgCGQ4zxsSY6
         sj4rIE+xuwc31m+Um6BnPAVuMDipuUBlyvAvzfSV6EkFNaORpfR48u8HpwwmIyA4zTK3
         8ujkf4xpva2QGP/UnB6txth8ROqD1S9QL7cM5OjCDeBvKxQIGssm2zGLKaKgIDOpI8Yy
         XOvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=b+leENUJgrORs7s4w2DEFFssoBzFRIRTCVgDzwkFbqo=;
        b=ZHRVYO0c6EcVdbGjNGDHPilZFUifhCQqX/g+sjoTnFVMdu0bd4szmsbiwngUqRuaBc
         4m2WTAcjDpCBls+/dOuLUc2JynrS29Ff1WrbsWE3cDSFaBhNwPT34E2pm+VYMZkMZQi+
         2WEwaQfLF7ao3DRvFtUNtFr3hZiQ3erLyNwSBmhluAc0J+NTEYSvRQtQK+bCZZf5udEy
         mVnksgLUKcaVXnk6PTc/GCaPgZhSp15jPSzuT0YviERysxzpfkCxiJX9qMMwPCjw6gCV
         uZvSWsH4GYFXYAh/Vi/Om4wqhpaRTcDF5VK58RGPTPNK6QobhE08nck+YCBw4VJRlq0w
         UUhg==
X-Gm-Message-State: AGi0Pub62R1flw80pgplyUe39WFHH6NKW0F+SWCVYEKKL54xXizRgiy6
        z/MgKbj1kknskIEfetQdwpzkiPY=
X-Google-Smtp-Source: APiQypLBtRtEgXpS1sq8PLoz4NZzHjMh8rZPOEpzugfOdGv7vpxbBsAlcSpxjJWgYXob2aFnY02Jlg==
X-Received: by 2002:a17:90a:a40d:: with SMTP id y13mr20178478pjp.116.1586078247267;
        Sun, 05 Apr 2020 02:17:27 -0700 (PDT)
Received: from he-cluster.localdomain ([67.216.221.250])
        by smtp.gmail.com with ESMTPSA id f8sm7380436pgc.75.2020.04.05.02.17.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 Apr 2020 02:17:26 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH] xfs: check if reserved free disk blocks is needed
Date:   Sun,  5 Apr 2020 17:17:19 +0800
Message-Id: <1586078239-14289-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

We don't need to create the new quota inodes from disk when
they exist already, so add check if reserved free disk blocks
is needed in xfs_trans_alloc().

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 fs/xfs/xfs_qm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 6678baa..b684b04 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -780,7 +780,8 @@ struct xfs_qm_isolate {
 	}
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_create,
-			XFS_QM_QINOCREATE_SPACE_RES(mp), 0, 0, &tp);
+			need_alloc ? XFS_QM_QINOCREATE_SPACE_RES(mp) : 0,
+			0, 0, &tp);
 	if (error)
 		return error;
 
-- 
1.8.3.1

