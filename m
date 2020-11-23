Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C49A4C2D0E4
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Nov 2020 09:39:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53AC5207FF
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Nov 2020 09:39:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="codmWv3Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725797AbgKWJi6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Nov 2020 04:38:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725275AbgKWJi6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Nov 2020 04:38:58 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F04FC0613CF
        for <linux-xfs@vger.kernel.org>; Mon, 23 Nov 2020 01:38:58 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id w6so14410426pfu.1
        for <linux-xfs@vger.kernel.org>; Mon, 23 Nov 2020 01:38:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=AoFYnbFW0b+Mn/nvt/JfBPz6WewmSCSedge/6NK8KTk=;
        b=codmWv3ZKAqOtrngiHcGJDy12AFdwKR+WB0qSGPvCTg1/LYiJSnNop8EuWq9GkTuX9
         kv9/nYV72nB7cpMVrGl0VAkR4gZ1FJoYB9Ta1brtVl23GyV0AFOmYo9I+0UGYW1bvT9V
         ehX8fbw9sCx9nSejlc7VPZYC5S2s3gh/mkDXR5Q8eokVjSv2EHGhkpcM1OT17VEHZDel
         wg4kGxwXpFCPpeGOp96DBf6qOyXrTy2/MFFnFXTFWVhV/+pK65JIkGN6J4on7hnkbAyr
         NHOVHCV+KbgVRiiHXwi7nRQx1CsyBww583eEx9nLTMYSkZH1OoLv+DybC/Xau6wbNATZ
         TnWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=AoFYnbFW0b+Mn/nvt/JfBPz6WewmSCSedge/6NK8KTk=;
        b=SB+YzTAtWkMxlgnHOZV4PC70tC3yslWqvFECxVL6YjcEcBjGyfDU+dnuDGZaN4yIZc
         nIujJqXfZEpbM0STjKQEeaQLtxwiaVFSHGROM0LiQCROu8IqbXpcFsxVQU1hxqUoUgnD
         AvIJU/5DhGD1bc1BHx1oxEdpTkYs3AclL4oNAKpQVYyHqTjqgfZZJnWJK2Ja7vIbvU/7
         vDb/BdiWhTKVyGrDPUv4nlNdSqsgjs4eaLqeG2ZrebHICw8rS7771/NdxLeY1+uc5UQr
         /CMndC2rLNpcWC2JXH2d8r/66eXW/6lsO3n7Hf6Q9Nhj5RVccl0LCnMnQrutaQbM8eOj
         aWCA==
X-Gm-Message-State: AOAM5326pOIA+Fpd2LI5VTMi8HNOrxMg3N/XuU7OkX86nyn5ddwrAA5S
        OehkgmRPNwoSoZC4zqMYTD9puQHflHSd
X-Google-Smtp-Source: ABdhPJyGtofuig4GfToVOVEuo/5CvNn9q15SacAgI1ES7dvaPWB4Hzx27J/xO6213NvpsubKLpWEjQ==
X-Received: by 2002:a17:90a:4283:: with SMTP id p3mr19024488pjg.174.1606124337472;
        Mon, 23 Nov 2020 01:38:57 -0800 (PST)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id cv4sm13055569pjb.1.2020.11.23.01.38.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 23 Nov 2020 01:38:56 -0800 (PST)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH] xfs: show the proper user quota options
Date:   Mon, 23 Nov 2020 17:38:52 +0800
Message-Id: <1606124332-22100-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

The quota option 'usrquota' should be shown if both the XFS_UQUOTA_ACCT
and XFS_UQUOTA_ENFD flags are set. The option 'uqnoenforce' should be
shown when only the XFS_UQUOTA_ACCT flag is set. The current code logic
seems wrong, Fix it and show proper options.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 fs/xfs/xfs_super.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index e3e229e52512..5ebd6cdc44a7 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -199,10 +199,12 @@ xfs_fs_show_options(
 		seq_printf(m, ",swidth=%d",
 				(int)XFS_FSB_TO_BB(mp, mp->m_swidth));
 
-	if (mp->m_qflags & (XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD))
-		seq_puts(m, ",usrquota");
-	else if (mp->m_qflags & XFS_UQUOTA_ACCT)
-		seq_puts(m, ",uqnoenforce");
+	if (mp->m_qflags & XFS_UQUOTA_ACCT) {
+		if (mp->m_qflags & XFS_UQUOTA_ENFD)
+			seq_puts(m, ",usrquota");
+		else
+			seq_puts(m, ",uqnoenforce");
+	}
 
 	if (mp->m_qflags & XFS_PQUOTA_ACCT) {
 		if (mp->m_qflags & XFS_PQUOTA_ENFD)
-- 
2.20.0

