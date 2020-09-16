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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13201C43461
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Sep 2020 20:23:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABDD421973
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Sep 2020 20:23:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xmck3jhO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbgIPUXc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Sep 2020 16:23:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727029AbgIPR2i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Sep 2020 13:28:38 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E94C061D7C
        for <linux-xfs@vger.kernel.org>; Wed, 16 Sep 2020 04:19:22 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id 7so3686956pgm.11
        for <linux-xfs@vger.kernel.org>; Wed, 16 Sep 2020 04:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qFUDpBU26Mp2CZ1pN86YJ8N41WIECKRcFl6Y6ElKLLU=;
        b=Xmck3jhO7rt8LgnTjHMsYTsjWmEhXZqFFXEZKdpkg5cvyHjJ79pYgC8DP+AzSiJCPZ
         sypbXTa2/c++MfjEJ18VIHHCP0DJtCAMxHRCg3nTXuJb4S+qyTAG92us0C2WF7z15zJd
         geolwD8u4bpIPidmG/7r29hVuY74DtuMEVguvkmGSGEN086/UEcDxQMt0EemeNBgG/N/
         Gsawh5xFNMwV+ypRnRto8ak7B/D76b7maOgdbUFIFu1xxNeMTSBzCzFNCELYoTEswlyb
         aerSrk91+XFTEV7Vp0Ihbm3INsEBgRPT2bm4ny7Hia2JhZSBK3Ypm630bOVUH4YYP1e0
         yz9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=qFUDpBU26Mp2CZ1pN86YJ8N41WIECKRcFl6Y6ElKLLU=;
        b=C+iVAd11wa9LGp+7kbiwiJ/VRDOdKsika1l251dp7adETd4CKtBRMF9ea1ofaV3arg
         I2zWCYnZmUWY4fi+g/pNLWdwBYVgLSotLmYSqZ5QVQr8Qe0YO+9kwtBe0VhlMWt/gF2V
         1y7GVFy59/hGdtbMM+YCLJgGlNm/c1KoMr/cIhwp+uiRyHcKXTuv/s5cKoJ5n4/cX6q7
         1vbEQ08XqnC+FhnrRedq/iygyXCD5gK17C2I0wLhoXofj6+h/Q1w9T44o9B2MBzYC2IH
         q0rq5Lctn9WIJrNNrq7+bPscR0FmUCRL5RRk18gOuyz9Q6wRyzv7KLDE/zYtSM5LjYOb
         u9sQ==
X-Gm-Message-State: AOAM530HXhGHljmiEgOE/XYY7QAlt4WaZCE1tROHTVv9tYhf25ULnrHO
        zAFGpNTK3MwGHJA2Wqde4V+hz6hFXQ==
X-Google-Smtp-Source: ABdhPJxI5DKJBPYkgYuYbx5YfPKdNvJqSeI9/BAjnFxlrZDq6YB2KPVFAjhhu/IEh/8Fr2csInkdGA==
X-Received: by 2002:a63:4656:: with SMTP id v22mr2107958pgk.116.1600255161759;
        Wed, 16 Sep 2020 04:19:21 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id v204sm3492195pfc.10.2020.09.16.04.19.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Sep 2020 04:19:21 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH] xfs: remove the unnecessary xfs_dqid_t type cast
Date:   Wed, 16 Sep 2020 19:19:06 +0800
Message-Id: <1600255152-16086-4-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1600255152-16086-1-git-send-email-kaixuxia@tencent.com>
References: <1600255152-16086-1-git-send-email-kaixuxia@tencent.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

Since the type prid_t and xfs_dqid_t both are uint32_t, seems the
type cast is unnecessary, so remove it.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 fs/xfs/xfs_qm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 3f82e0c92c2d..41a459ffd1f2 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1715,7 +1715,7 @@ xfs_qm_vop_dqalloc(
 	if ((flags & XFS_QMOPT_PQUOTA) && XFS_IS_PQUOTA_ON(mp)) {
 		if (ip->i_d.di_projid != prid) {
 			xfs_iunlock(ip, lockflags);
-			error = xfs_qm_dqget(mp, (xfs_dqid_t)prid,
+			error = xfs_qm_dqget(mp, prid,
 					XFS_DQTYPE_PROJ, true, &pq);
 			if (error) {
 				ASSERT(error != -ENOENT);
-- 
2.20.0

