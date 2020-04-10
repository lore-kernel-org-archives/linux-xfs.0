Return-Path: <SRS0=tPAf=52=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6704C2BA2B
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Apr 2020 08:57:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99F0120787
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Apr 2020 08:57:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GxCA/hWS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbgDJI5M (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Apr 2020 04:57:12 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:40019 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbgDJI5M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Apr 2020 04:57:12 -0400
Received: by mail-pl1-f196.google.com with SMTP id h11so474035plk.7
        for <linux-xfs@vger.kernel.org>; Fri, 10 Apr 2020 01:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=FKUaibJN+h4608b8vBcypSOYpY7275dZNuWgyWQIA6g=;
        b=GxCA/hWSVRgmEokDAKzSxLLGjDeWUx+houURKUv7uQKsHDg4kH77AHEssFWXmGAEq4
         Bgn5AlqqpTK1yHg/jGQ6bo5BfMvViP5ZvoR0sDOJ8LJswQjbxg4kupoHl/P/4D3eyUUb
         +7z7Mvj7br4wP4SPIpvKfZtbQGXu1R9os1fJ2JP31LT5Uk5ijhEKYt3oVjL1Q1oMCFSX
         nzdqZFLp6aoKfbeDZg9oDx8fdTj9SdHcC1D42YISMNTkBgxS5Cpw+nmxak6lb0VN6dFG
         qUzYSpxYeSVUPN1XfzUjgHeUkgzDH07lnpGmHmSfAHbj1ekBd8nf3Rka90drTrepFIfq
         Y0LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=FKUaibJN+h4608b8vBcypSOYpY7275dZNuWgyWQIA6g=;
        b=sum/5h8pJmAChQv0DXlOBLGBmw8J0LTpsq9zQz6MuH7moLteSqvlkjX+PCFpwY25CZ
         te9nRaScaGvfi8Tle8jTv2+nnifKYwZOhEFC6LyIR0T9WzOaxoAHcJqMFqLZSf6pipKn
         HcE8IU9F+LvrDye+oUny8XarbNxHsXQYx/g4seigd1ChmIWpeKW+htOn+coaqedEpxx0
         X5ILQUmv1cuj7qF5igKKhO+VP5xLndvgfdwLMVKz+KDoBm7kkPKigiwP4+nlW0TAXQp/
         pqnfKTXQy3/TIdKXhq8SOBIj1VbGTihlcxwGuq9uYTfJvi7HBLzvSMgaKMBiAOibJEAk
         rlfw==
X-Gm-Message-State: AGi0PubfcUVSygWdVbmdaQkP1T5TGLCU3ApDkJd8m2sFqgsMKM0iD8RK
        VG3k34wlEq3JUdG+ksaf4dCtHPBRyg==
X-Google-Smtp-Source: APiQypL+/N3fr8mWDqKfJ4OAiAolhFzBgjz75Yg22ThA7EV3GVeWTvGoD7o1AaKBACJQJ4JrD6VHOQ==
X-Received: by 2002:a17:90b:1944:: with SMTP id nk4mr4072096pjb.70.1586509031432;
        Fri, 10 Apr 2020 01:57:11 -0700 (PDT)
Received: from he-cluster.localdomain ([67.216.221.250])
        by smtp.gmail.com with ESMTPSA id e26sm1185902pff.167.2020.04.10.01.57.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 Apr 2020 01:57:10 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH] xfs: simplify the flags setting in xfs_qm_scall_quotaon
Date:   Fri, 10 Apr 2020 16:57:04 +0800
Message-Id: <1586509024-5856-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

Simplify the setting of the flags value, and only consider
quota enforcement stuff here.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 fs/xfs/xfs_qm_syscalls.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 5d5ac65..944486f 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -357,11 +357,11 @@
 	int		error;
 	uint		qf;
 
-	flags &= (XFS_ALL_QUOTA_ACCT | XFS_ALL_QUOTA_ENFD);
 	/*
-	 * Switching on quota accounting must be done at mount time.
+	 * Switching on quota accounting must be done at mount time,
+	 * only consider quota enforcement stuff here.
 	 */
-	flags &= ~(XFS_ALL_QUOTA_ACCT);
+	flags &= XFS_ALL_QUOTA_ENFD;
 
 	if (flags == 0) {
 		xfs_debug(mp, "%s: zero flags, m_qflags=%x",
-- 
1.8.3.1

