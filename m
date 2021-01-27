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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21945C433E6
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 09:09:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA47620756
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 09:09:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbhA0JJB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Jan 2021 04:09:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232723AbhA0JGg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Jan 2021 04:06:36 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 371B8C061793
        for <linux-xfs@vger.kernel.org>; Wed, 27 Jan 2021 01:05:55 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id u11so664879plg.13
        for <linux-xfs@vger.kernel.org>; Wed, 27 Jan 2021 01:05:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FlRBrXghcoL+QMaCJ226ytHaCVFUZumYdVE9mAWKET0=;
        b=B/Jr7xkOugvS4sC+bhGkVYPuo2Bm2B8hEnFFq3F9a3HKBJtDC2i/1Zz3NGUWiEs3hZ
         Nxw4PXIqromF3rZATC3NCjBLGjgoHiuwkRWQlEHEEr4VrGaAupFmRQf6/HpCloUVIVSM
         cyWLe0pbh2DyqcutBSkvDoEev66jrBNh3gINOLxcCm8jifeYbTwYEOSILC41qFM2VS8s
         ZEEQeUkhRb3zS1RTBeJ/mO/OlLETZ3KWMCAhXIhohficLBdpPJc7FQlYDmZF2OhSxmAz
         A4641MCdxylEGJX6jTQOJcVqo39ybbOuU43X74BzsJA2vOmOrPiDTCB6k060VZbhpIVF
         O2oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FlRBrXghcoL+QMaCJ226ytHaCVFUZumYdVE9mAWKET0=;
        b=f57cUQWisiCieR3w+EjUVFZdJDagZ6MfYkHVT+ZfazDsvbevqgexbmEcw5EwUr+9sO
         NbmYefAfKdRqTi1M6oXkjwj73oS7vQTnz4925T12avbUSIrEbnQd7xc9qPzkULT2Bif5
         2tcYt53lvJKTn95wNclE85tJuRalHljmLYBs10cHnVdO1MpXS33I+ccdCgqr3TMe+c95
         Iyr99OtWq4t0SclK2fJAwfP47ZWlGX4uGDRKqVYBnmpuyVMXiP804clCqfU9UIwxeTnB
         gT+mclCylaZk7h1TofjfTjkkEVbSaxNXoJwoZhyNRUZxBvaNDqZh8T9DzC0LvvyG9z26
         uSQA==
X-Gm-Message-State: AOAM533l/FtM4a3odY2oJ5u6Yn4LPCkrOrLRnhzec5ZUck1+MeU9rmjZ
        ejWNEEUVFNNU7i7Km2QAGSDA/D0MwCc=
X-Google-Smtp-Source: ABdhPJzLEHPnXA4svfNxKxCCPIof/6VywcUni4o0uVQ80IlKfRWPsejO5rKVJgab9jEH/dIg2vAyXw==
X-Received: by 2002:a17:902:aa8f:b029:df:c8a9:f8b4 with SMTP id d15-20020a170902aa8fb02900dfc8a9f8b4mr10435696plr.48.1611738354659;
        Wed, 27 Jan 2021 01:05:54 -0800 (PST)
Received: from localhost.localdomain ([122.171.171.5])
        by smtp.gmail.com with ESMTPSA id c3sm1711830pfj.105.2021.01.27.01.05.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 01:05:54 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, djwong@kernel.org,
        allison.henderson@oracle.com, kernel test robot <lkp@intel.com>
Subject: [PATCH] xfs: Fix 'set but not used' warning in xfs_bmap_compute_alignments()
Date:   Wed, 27 Jan 2021 14:35:37 +0530
Message-Id: <20210127090537.2640164-1-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

With both CONFIG_XFS_DEBUG and CONFIG_XFS_WARN disabled, the only reference to
local variable "error" in xfs_bmap_compute_alignments() gets eliminated during
pre-processing stage of the compilation process. This causes the compiler to
generate a "set but not used" warning.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
This patch is applicable on top of current xfs-linux/for-next branch.

 fs/xfs/libxfs/xfs_bmap.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 2cd24bb06040..ba56554e8c05 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3471,7 +3471,6 @@ xfs_bmap_compute_alignments(
 	struct xfs_mount	*mp = args->mp;
 	xfs_extlen_t		align = 0; /* minimum allocation alignment */
 	int			stripe_align = 0;
-	int			error;
 
 	/* stripe alignment for allocation is determined by mount parameters */
 	if (mp->m_swidth && (mp->m_flags & XFS_MOUNT_SWALLOC))
@@ -3484,10 +3483,10 @@ xfs_bmap_compute_alignments(
 	else if (ap->datatype & XFS_ALLOC_USERDATA)
 		align = xfs_get_extsz_hint(ap->ip);
 	if (align) {
-		error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
-						align, 0, ap->eof, 0, ap->conv,
-						&ap->offset, &ap->length);
-		ASSERT(!error);
+		if (xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
+			align, 0, ap->eof, 0, ap->conv, &ap->offset,
+			&ap->length))
+			ASSERT(0);
 		ASSERT(ap->length);
 	}
 
-- 
2.29.2

