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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F5BCC07E96
	for <linux-xfs@archiver.kernel.org>; Sun, 11 Jul 2021 08:52:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF8B061178
	for <linux-xfs@archiver.kernel.org>; Sun, 11 Jul 2021 08:52:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbhGKIy7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 11 Jul 2021 04:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbhGKIy6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 11 Jul 2021 04:54:58 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAB9FC0613DD;
        Sun, 11 Jul 2021 01:52:11 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id bt15so3181297pjb.2;
        Sun, 11 Jul 2021 01:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AO84Rj9d4JTCVtMc0GFQEjjZrGayiHrdPf63NXsjTXk=;
        b=V6+MLYUKdwPuNCKa40xLrfBNXa1WJ+LsGO5wz4YrDV3j06rBL4dWtojpz5aezPi6Sg
         t8O3SLqKB/wFE6idh0b/Xp2wLoUMMUU9YsMB0v+a1FdTFUIzpSb96dzC6Gp7d+qj7thq
         SOIJGJ2MceFPAQMnh351ivwl8o8HJDn3RPTPjlTy4ETgf5grtfsNwmN9pskj3HgEiAD1
         pzk+zA+qG8KMxv/E2AcdKDS8inMDS/Oc8LvZOq3AaJ57coFIBOd04jPWEru4ps7AYpKR
         kdZVADBnpFsaUF82YsZ0qm6tloZ/TaYdrN/tIx+BIRSkSjt3CJwoLjTBXUM4p/g/MPCx
         rplQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AO84Rj9d4JTCVtMc0GFQEjjZrGayiHrdPf63NXsjTXk=;
        b=gzNe2SNXrk3hiBhFAg2l7bvEWF/qLZQaEp8n/2XA0P6/PCFV2Z5PTP/XShY5xaf0Zb
         4d6RxnljJMJ+ZVczkLrRmwtzoODrucKFkVx2gc05xf2/Eoj94pMMepky1rr0rQyqlNgw
         QFPP3prkoeptzVtFHk9KyUEQv7cck6pZhsk1pfvZsix+2n/bvUCkZLyVpibVcuKNebAg
         voXKi4CrEi/1seQW4nBgAOuYuOR1its+f72T2V6aiDqNzZ6AkggtJhy2X9wDsWcI1JAR
         DfkR2v+RshVAGYk3x6Zq63ASeGSCuCDNkymb7XHCAzaUA4jhaMdalBygFubggRizQV7X
         Dg/A==
X-Gm-Message-State: AOAM531+3SnHmmD5hMPq40ksN9l+tC8sPUmDk56oIQAbyOgaoHcYiHoG
        zCcBOzkAcjCwP0Kieq5FAgk=
X-Google-Smtp-Source: ABdhPJy+td5j+G5CiMGpUv60KPDVXAOvs0eL+/nOewNXQ/0NTmwSAcdVeI/dxN4yywPJpxuqjUkUjA==
X-Received: by 2002:a17:90b:33c8:: with SMTP id lk8mr7670420pjb.0.1625993531235;
        Sun, 11 Jul 2021 01:52:11 -0700 (PDT)
Received: from localhost.localdomain ([49.37.51.242])
        by smtp.gmail.com with ESMTPSA id h76sm12378486pfe.77.2021.07.11.01.52.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 01:52:10 -0700 (PDT)
From:   Dwaipayan Ray <dwaipayanray1@gmail.com>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        lukas.bulwahn@gmail.com, Dwaipayan Ray <dwaipayanray1@gmail.com>
Subject: [PATCH] fs:xfs: cleanup __FUNCTION__ usage
Date:   Sun, 11 Jul 2021 14:21:53 +0530
Message-Id: <20210711085153.95856-1-dwaipayanray1@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

__FUNCTION__ exists only for backwards compatibility reasons
with old gcc versions. Replace it with __func__.

Signed-off-by: Dwaipayan Ray <dwaipayanray1@gmail.com>
---
 fs/xfs/xfs_icreate_item.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
index 9b3994b9c716..017904a34c02 100644
--- a/fs/xfs/xfs_icreate_item.c
+++ b/fs/xfs/xfs_icreate_item.c
@@ -201,7 +201,7 @@ xlog_recover_icreate_commit_pass2(
 	if (length != igeo->ialloc_blks &&
 	    length != igeo->ialloc_min_blks) {
 		xfs_warn(log->l_mp,
-			 "%s: unsupported chunk length", __FUNCTION__);
+			 "%s: unsupported chunk length", __func__);
 		return -EINVAL;
 	}
 
@@ -209,7 +209,7 @@ xlog_recover_icreate_commit_pass2(
 	if ((count >> mp->m_sb.sb_inopblog) != length) {
 		xfs_warn(log->l_mp,
 			 "%s: inconsistent inode count and chunk length",
-			 __FUNCTION__);
+			 __func__);
 		return -EINVAL;
 	}
 
-- 
2.28.0

