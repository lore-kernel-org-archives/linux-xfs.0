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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 442F7C433E9
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 05:18:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 173B022273
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 05:18:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731367AbhAZFSD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 00:18:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727304AbhAYJ7L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Jan 2021 04:59:11 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F337C061354
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jan 2021 01:58:26 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id o20so8119857pfu.0
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jan 2021 01:58:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sb3etncdsxXNLSGVOVcBLUG8wmaDbcjw9I3HFDmXDPQ=;
        b=KY6u6l9cLVsVHZjO/WMU4A8lOvpSQiuqRehEmZtR3uCR6BiBo1ZG1nHZl1Ayz5AR5C
         1otNyIcdE6f0YYos7IgmbZVRzIuwj8GOPkAl6KtpdkAhqU031YPMDrP7z/rktDQBOVr1
         W6WHtRnA/ivIOLFBs8mF4DkQ49i5gY0jUGzDLJAMO4nxGaRptM+b24VITUY2/aNd/753
         p850TkYj7WA864LF9NdIbXeU+OTlwfeD6l8qaecS0zhAU66GEoqSq46+wxsqrykDkHWZ
         xLNEvSRo0IL/3/nb8zoVsiSOHlYSKA/LzmBB5d/J4s1AwXnrRCpgM9CUZxM7ctBepEss
         ojaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sb3etncdsxXNLSGVOVcBLUG8wmaDbcjw9I3HFDmXDPQ=;
        b=FyBM8IOUcljwzUryR+PgdfU2gCqV4U5Xl9Ub3pDugY7HvESQ0WHun/fYxDUDanuwJO
         HzU6V7I47D5PFsMfAyORdRXLG/2ONm6R+oJTWtUfkjQUx0UwKmsa1SPF1cLY70u1siOe
         1wv2JbbYlSuSYNIVScV8OneUxY3kG3OZDGb9jp3YPOIaKRDHr35lh3Slg26qwThgAz4S
         N0zxATCUtaPlpofrQfHBF/ha/BJKnd0dTo7l8HW3hkWTJhuj0SPB5r6jp9b680Q9sT+l
         f/n3giCUEvBmTfbUiBB41/lAT+cmXsXd6bvsUkYZhFFTiQzo4r3ATyW2eQ/KLfb1f7GW
         VH+g==
X-Gm-Message-State: AOAM533DeNx11DnMM8V1c5wy0LI1poIdfU4nwEd4ueX9hRQF+OZOGHR2
        sctXns9oFwIYSVkN+GKGydW/Xoslh4Q=
X-Google-Smtp-Source: ABdhPJwn/oCh2Cuz6W4lGFORRLpg2+AASPgpz4FZf6qsPboqzETPFZifcWcH03UyUJ//We9Fes5raw==
X-Received: by 2002:a63:c4a:: with SMTP id 10mr182109pgm.397.1611568705814;
        Mon, 25 Jan 2021 01:58:25 -0800 (PST)
Received: from localhost.localdomain ([122.182.225.185])
        by smtp.gmail.com with ESMTPSA id e20sm2680269pgr.48.2021.01.25.01.58.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 01:58:25 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, sandeen@sandeen.net
Subject: [PATCH 2/2] xfsprogs: xfs_fsr: Limit the scope of cmp()
Date:   Mon, 25 Jan 2021 15:28:09 +0530
Message-Id: <20210125095809.219833-2-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210125095809.219833-1-chandanrlinux@gmail.com>
References: <20210125095809.219833-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

cmp() function is being referred to by only from within fsr/xfs_fsr.c. Hence
this commit limits its scope to the current file.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fsr/xfs_fsr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 635e4c70..2d070320 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -81,7 +81,7 @@ char * gettmpname(char *fname);
 char * getparent(char *fname);
 int fsrprintf(const char *fmt, ...);
 int read_fd_bmap(int, struct xfs_bstat *, int *);
-int cmp(const void *, const void *);
+static int cmp(const void *, const void *);
 static void tmp_init(char *mnt);
 static char * tmp_next(char *mnt);
 static void tmp_close(char *mnt);
@@ -699,7 +699,7 @@ out0:
 /*
  * To compare bstat structs for qsort.
  */
-int
+static int
 cmp(const void *s1, const void *s2)
 {
 	return( ((struct xfs_bulkstat *)s2)->bs_extents -
-- 
2.29.2

