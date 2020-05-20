Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95DABC433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 03:24:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B2A42070A
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 03:24:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aK3IGuqg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726938AbgETDYN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 May 2020 23:24:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726352AbgETDYM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 May 2020 23:24:12 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74346C061A0E
        for <linux-xfs@vger.kernel.org>; Tue, 19 May 2020 20:24:12 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id ci21so606128pjb.3
        for <linux-xfs@vger.kernel.org>; Tue, 19 May 2020 20:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=4NhX2uXgJL1LWI0tSsiqd5VdE3Q8GIQ9D1IoNheo0c0=;
        b=aK3IGuqgK92z2qA8jdO6Wu5Ag5l+Q1Gt7e8SQFC85z0yVLPn0rdJ6hFqmzQW0bNIDB
         IZOdEs5AAxdXcwJxUdT++78At4dQ8LxUv95+SfK9mpssqlsOXgp8et7GrupN87tZf4iF
         07AMORtp9F/j8t92HhUqZEm00rN1HF8QOmqkrB/YQGyvih02HGt+O6nZ8YlhMDRb3TtT
         1gGjhHNBnUAgdgOx74N/GD/8/59mICpi4ZWi6nxn9wP/5v6JOFDlpGPPZv56Fg5yIqOl
         QbYHV1cJ+S0XgSYj49VGAQcKYGc7TQYLG7R9LBKdmiqmAtTnuFogU3dYcwFVR6kQ+ktL
         F+8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=4NhX2uXgJL1LWI0tSsiqd5VdE3Q8GIQ9D1IoNheo0c0=;
        b=h91MPKr68AuquMHDzDaAcy5jUNMBOMxwHRoNichyIFttB7yMHIgRaP/uYot5G8na/4
         te/rFrC0qgpgD5kALPUBWZ+OZWp66BgIHicAnfH6ZrE1x3nBQ6m4RP67cG+7jTyAfhIe
         SGDPMEWEzm9JG/7DFFOGNJm1l0b9VWbJ41V41g11kbdMtJ9rPE6OF+WzQO/REl+9wQF5
         m1/jNPSxNR9u7+o9YWjGyxzFO0+kvRAewyJBaf9/DVogix49sJFT1E2VgPBP+hj/OnI7
         +/v8wCQopSwoAeJ8gEwec0Ko9kSwbBNKexismduSRQFvt2kJ2zTkfONLPk75EEbWSsiJ
         VwSw==
X-Gm-Message-State: AOAM533dczV9wmA7YuoVvDPVyAsvhC8BRcUqLucrdeNZ43v/0AEjQww5
        j6i+Hqndw1Ay5Q9sXA6pCg==
X-Google-Smtp-Source: ABdhPJwwxm4Knln9I33GpJgCNUrdFpyE4pTGUweWzF7/ECJrxXJlDUVwV1XZWUEVeLRJuGqyUfNFLQ==
X-Received: by 2002:a17:90b:360c:: with SMTP id ml12mr2601712pjb.205.1589945051990;
        Tue, 19 May 2020 20:24:11 -0700 (PDT)
Received: from he-cluster.localdomain ([67.216.221.250])
        by smtp.gmail.com with ESMTPSA id z1sm710434pjn.43.2020.05.19.20.24.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 May 2020 20:24:11 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH v2] mkfs: simplify the configured sector sizes setting in validate_sectorsize
Date:   Wed, 20 May 2020 11:24:00 +0800
Message-Id: <1589945040-1207-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

There are two places that set the configured sector sizes in
validate_sectorsize, actually we can simplify them and combine into one
if statement. Use the default value structure to set the topology sectors
when probing fails.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
v2:
 -Use the default value structure to set the topology sectors.

 mkfs/xfs_mkfs.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 039b1dcc..d553b0a0 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1696,14 +1696,6 @@ validate_sectorsize(
 	int			dry_run,
 	int			force_overwrite)
 {
-	/* set configured sector sizes in preparation for checks */
-	if (!cli->sectorsize) {
-		cfg->sectorsize = dft->sectorsize;
-	} else {
-		cfg->sectorsize = cli->sectorsize;
-	}
-	cfg->sectorlog = libxfs_highbit32(cfg->sectorsize);
-
 	/*
 	 * Before anything else, verify that we are correctly operating on
 	 * files or block devices and set the control parameters correctly.
@@ -1730,6 +1722,7 @@ validate_sectorsize(
 	memset(ft, 0, sizeof(*ft));
 	get_topology(cli->xi, ft, force_overwrite);
 
+	/* set configured sector sizes in preparation for checks */
 	if (!cli->sectorsize) {
 		/*
 		 * Unless specified manually on the command line use the
@@ -1741,9 +1734,8 @@ validate_sectorsize(
 		 * Set the topology sectors if they were not probed to the
 		 * minimum supported sector size.
 		 */
-
 		if (!ft->lsectorsize)
-			ft->lsectorsize = XFS_MIN_SECTORSIZE;
+			ft->lsectorsize = dft->sectorsize;
 
 		/* Older kernels may not have physical/logical distinction */
 		if (!ft->psectorsize)
@@ -1759,9 +1751,10 @@ _("specified blocksize %d is less than device physical sector size %d\n"
 				ft->lsectorsize);
 			cfg->sectorsize = ft->lsectorsize;
 		}
+	} else
+		cfg->sectorsize = cli->sectorsize;
 
-		cfg->sectorlog = libxfs_highbit32(cfg->sectorsize);
-	}
+	cfg->sectorlog = libxfs_highbit32(cfg->sectorsize);
 
 	/* validate specified/probed sector size */
 	if (cfg->sectorsize < XFS_MIN_SECTORSIZE ||
-- 
2.20.0

