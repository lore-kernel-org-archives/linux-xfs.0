Return-Path: <SRS0=FK3z=6C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADC96C2BA19
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Apr 2020 05:31:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5366521D82
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Apr 2020 05:31:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mSywhp92"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725782AbgDRFbB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 18 Apr 2020 01:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725440AbgDRFbB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 18 Apr 2020 01:31:01 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6466DC061A0C
        for <linux-xfs@vger.kernel.org>; Fri, 17 Apr 2020 22:31:01 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id hi11so1320066pjb.3
        for <linux-xfs@vger.kernel.org>; Fri, 17 Apr 2020 22:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=RbDqtLr8RsvrjQEGGLyeLV/oEjrP3rpWR1VRA0tLKws=;
        b=mSywhp92oHWXeXQIkN3ulC8SSkoKZP2kW7zvNDCRj3J4g7vT09uJ5yRxH0LNCEgZ5y
         P9eDNWfQbXuGRb0jBHiQlmoSVguh5xZ5KxJzGnuSr9sUyURzq6LSIkTEdtgR9aFGkfBq
         k5bwSNPVXulQS4+KDDbvI00jHZ6+dXPuSqQ2GWtcz/LA5E7gYMZFJPiXKisjhEpNKc3P
         9fRgw70RdRIutNvWioaHkCnGmfr8jpqWzDzZ4lzrEd+9KzYTi5L9Qjktse5mT9QhF9fS
         G7CiW2AcVUHEkmLjQmnw0ZiqinmeGqinvMSgdgG8Y8LnDNnMA1Izu1GR2r3bPHFbzPyu
         r+7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=RbDqtLr8RsvrjQEGGLyeLV/oEjrP3rpWR1VRA0tLKws=;
        b=MoVr4mPKCoHG9RWr6eDB8jwwUe1RJcP44neOp0SsLhHYTiC0uAqLe0ZgtPu+jO4AMa
         Jp2GuqaZH9lzIxIVhh0s2JmSenCM+ASoobV9sBbioXByZUsDZx3YktUoyu07oiNz5E6n
         rMUCGgRHQrCZHLJBt6PC7CTsIaRbJ+5a/yD0RTAp3GVkb7mKLX3uOMxue4HkwJreWMCA
         FBR5Tg3YK7RGLnrOjLfWCYYFHgIliBqLmX/XnfRHuy3pIwHoo8nyi0YEPe7x8r73wpkQ
         cJXmyLIILxOm8lRjoOd245kTt8kVuRHNrtPiOV9YxULajwmgkMToyVpB5/v4nnBVJeVi
         hxaw==
X-Gm-Message-State: AGi0PuZtkYFZ5Ue5Rr77mqO3a3BOnrID/AD2OXQr3huxBOGHN8kD3Q1x
        xjiK5UjNJ7TX8MxdmgQ4X9iowHk=
X-Google-Smtp-Source: APiQypLYEttuSPVJiCcW9K+eft5ZnQkJ27/u4Sff0oiaOiWWmkTsMOkAawQDuh/zJv32fasHpqr2Ig==
X-Received: by 2002:a17:90b:19d1:: with SMTP id nm17mr8618709pjb.74.1587187860551;
        Fri, 17 Apr 2020 22:31:00 -0700 (PDT)
Received: from he-cluster.localdomain ([67.216.221.250])
        by smtp.gmail.com with ESMTPSA id y131sm21129080pfb.78.2020.04.17.22.30.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 Apr 2020 22:31:00 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH] xfs: remove unnecessary check of the variable resblks in xfs_symlink
Date:   Sat, 18 Apr 2020 13:30:51 +0800
Message-Id: <1587187851-11130-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

Since the "no-allocation" reservations has been removed, the resblks
value should be larger than zero, so remove the unnecessary check.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 fs/xfs/xfs_symlink.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 13fb4b919648..973441992b08 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -243,8 +243,7 @@ xfs_symlink(
 	 */
 	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp, pdqp);
 
-	if (resblks)
-		resblks -= XFS_IALLOC_SPACE_RES(mp);
+	resblks -= XFS_IALLOC_SPACE_RES(mp);
 	/*
 	 * If the symlink will fit into the inode, write it inline.
 	 */
@@ -265,8 +264,7 @@ xfs_symlink(
 		if (error)
 			goto out_trans_cancel;
 
-		if (resblks)
-			resblks -= fs_blocks;
+		resblks -= fs_blocks;
 		ip->i_d.di_size = pathlen;
 		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
-- 
2.20.0

