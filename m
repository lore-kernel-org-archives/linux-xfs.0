Return-Path: <SRS0=FhJw=5Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E468EC43331
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Mar 2020 10:09:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B31FA20781
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Mar 2020 10:09:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rx7ghVWF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730224AbgCaKJ7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Mar 2020 06:09:59 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43794 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729997AbgCaKJ7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Mar 2020 06:09:59 -0400
Received: by mail-pl1-f193.google.com with SMTP id v23so7937493ply.10
        for <linux-xfs@vger.kernel.org>; Tue, 31 Mar 2020 03:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=kR6u28OGPMHcOHPlRnQKkOcI+c683D0UilS0di8j6lc=;
        b=Rx7ghVWFebwxuAE49R4hwayoA9qMzrQjbvoJmcTAt1t21uFJiXQasj40RnEC7vfNNI
         P4aWn5sw41PvxmkDMXBA0uewpNvLyF+09akafiL/uufH1a+MGEMeg7+E8bPTtJ4CLbw4
         ID3JFUpyiIAVbu69CCasNtUAvhWhbh/Uc4o6++KgS98dpDoF8fDh9os0F0JxKS3nnY0t
         KO2d7gttKVpSRRjSwDd3qPjLu9OJ3Hr8ph/Lk4MQtm92m5z+L9CL8jj/paIgEQ0GxE3W
         AbGMkEyXmOSmHEx4h7pqQyPPVBuN/Id58airTsmsdv0x1u91M5evAl4a4nn49fTx6i0s
         HG3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=kR6u28OGPMHcOHPlRnQKkOcI+c683D0UilS0di8j6lc=;
        b=RJe/FU+PmaIyy3yp/cI3nwLdvjnxh5EeBo0tLEPuOZ1MWDh40xUOdIuAEwTpqOPcFC
         KchlgbMxv+YkvOt3of8393Oa7dCGzOBfam2asZCrbGsLEK+s4ALiH0ejM5C6QafuY2E4
         vI6ZLDB+J90IilPyaic0CZUF7q2q3ccFfCyXis41i42+2MpjfCcXBCExz4WPAdwiRtoh
         fZ0fWXWYYlDG4WfjvA8zOV2lmAacymLdkcxjp/dt5hZ3tamkeG5miLMXUyup30zjhwIv
         INDLPfPIpuYZDqX+pA8/xobyIiq42FDsvy05ihYRlQdgen/jI7nZh7GvLaWrqGa4zB7E
         5wGg==
X-Gm-Message-State: AGi0PubFf2FtyArDbJUPtHTcY0e43VIc2qQIG/6HgILJcTVnJdzUPpRi
        YP3+rOx4hXrUuRa5oxqFbkFQ++g=
X-Google-Smtp-Source: APiQypIV48VfwzN1lubddmmcCjA9X47/F1Z78MeYts7V1OiXP/cl3/1tbzVVGvo2WTJraOTE94Nv3w==
X-Received: by 2002:a17:90a:5d87:: with SMTP id t7mr3085024pji.61.1585649397754;
        Tue, 31 Mar 2020 03:09:57 -0700 (PDT)
Received: from he-cluster.localdomain ([67.216.221.250])
        by smtp.gmail.com with ESMTPSA id iq14sm1546467pjb.43.2020.03.31.03.09.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 31 Mar 2020 03:09:57 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH] xfs: move trace_xfs_dquot_dqalloc() to proper place
Date:   Tue, 31 Mar 2020 18:09:47 +0800
Message-Id: <1585649387-22890-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

The trace event xfs_dquot_dqalloc does not depend on the
value uq, so move it to proper place.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 fs/xfs/xfs_qm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 0b09096..5569af9 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1631,6 +1631,8 @@ struct xfs_qm_isolate {
 	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
 		return 0;
 
+	trace_xfs_dquot_dqalloc(ip);
+
 	lockflags = XFS_ILOCK_EXCL;
 	xfs_ilock(ip, lockflags);
 
@@ -1714,8 +1716,6 @@ struct xfs_qm_isolate {
 			pq = xfs_qm_dqhold(ip->i_pdquot);
 		}
 	}
-	if (uq)
-		trace_xfs_dquot_dqalloc(ip);
 
 	xfs_iunlock(ip, lockflags);
 	if (O_udqpp)
-- 
1.8.3.1

