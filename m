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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6B8EC4332B
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jan 2021 16:11:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C7B4229C7
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jan 2021 16:11:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbhAJQLC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Jan 2021 11:11:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbhAJQLB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Jan 2021 11:11:01 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DD32C0617AA
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jan 2021 08:10:00 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id y8so8203714plp.8
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jan 2021 08:10:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BZXvtq1IJJ8A9t02QtWduGxtYXovGQz5DbuSLAdCy3M=;
        b=jLgiSRgeojCaUjU3dTKSm1uPj2S3BEBVW3LrVFJD9Mkq1SM/+bnR8RL1vqMSH564Bn
         DVKeRsVLRLOTYCXJ29QczCbaBiPvlER2Dw1fNdEZ2zODQr0efkJ/b/b+whC5rnifkxCa
         XeWKInYjWJedNUg5q4uJFCxBNQRd3rGA/1CtvQ8I2eaNa/SBclM0M6oW/yn+Kkq8BE+H
         oziAZwvGRNu0UfW6xxLyIWMjwCfZ5sinFoAn+DJMpNlKkBPn7tunttOW1fIp/rxztZdN
         sVcNTFMW5B9GQQMwzXByvEHxNw4G/AOQzd/3jlEUATXe4YEd3dnqUa6LGyOiJAn4rx36
         738A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BZXvtq1IJJ8A9t02QtWduGxtYXovGQz5DbuSLAdCy3M=;
        b=JKo+QiSKZtYklzfnTXp4XDY1UEDscaBmFRsLntwJHdZKRg2of/zAL4eB10X1iO+IsH
         W2eS06hsDI2wuGY1VMAtlFyqti0a/BUWiTTgXhydeKwtIvNW7AF2qeBkRwE93WVxtOKE
         uPeTo+q3diTLKv9ZI9bU1RGXoV1A1blHVlM9jfvfzMjE3Ea9fGFRWZaSha7vrISmv5G2
         DX0eplal32w6qZuxrIkZZmBBJOJFLY1xJMW8C0Fvg9Z+ibU8qp2lCEQe/aRLndD/tQuq
         /724Fg/bhJiCXGRTscQBQwJNJBAY94d87mWl6tUnUH6PVcafoGn8v7W5ORCKTgSwsAve
         7bUQ==
X-Gm-Message-State: AOAM530CqP09xcEw2w1eEvkrAhEt573cMI8YpbmKd5hcQlAmlPyZ1WrZ
        Ty7Z6cqqCYpWbOrspq+XV7TY+AGSUkg=
X-Google-Smtp-Source: ABdhPJzS3gVWuCouJM073uXO3IE0Pha+WRAFnvSH36Ms41Oj3KIQn2OeHdL0oVhJz6PU7KZw4XXbGA==
X-Received: by 2002:a17:90a:380c:: with SMTP id w12mr13282977pjb.117.1610294999658;
        Sun, 10 Jan 2021 08:09:59 -0800 (PST)
Received: from localhost.localdomain ([122.179.92.100])
        by smtp.gmail.com with ESMTPSA id d6sm15525896pfo.199.2021.01.10.08.09.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Jan 2021 08:09:59 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        djwong@kernel.org, hch@lst.de, allison.henderson@oracle.com
Subject: [PATCH V14 10/16] xfs: Check for extent overflow when remapping an extent
Date:   Sun, 10 Jan 2021 21:37:14 +0530
Message-Id: <20210110160720.3922965-11-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210110160720.3922965-1-chandanrlinux@gmail.com>
References: <20210110160720.3922965-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Remapping an extent involves unmapping the existing extent and mapping
in the new extent. When unmapping, an extent containing the entire unmap
range can be split into two extents,
i.e. | Old extent | hole | Old extent |
Hence extent count increases by 1.

Mapping in the new extent into the destination file can increase the
extent count by 1.

Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/xfs_reflink.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index ca0ac1426d74..e1c98dbf79e4 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1006,6 +1006,7 @@ xfs_reflink_remap_extent(
 	unsigned int		resblks;
 	bool			smap_real;
 	bool			dmap_written = xfs_bmap_is_written_extent(dmap);
+	int			iext_delta = 0;
 	int			nimaps;
 	int			error;
 
@@ -1099,6 +1100,16 @@ xfs_reflink_remap_extent(
 			goto out_cancel;
 	}
 
+	if (smap_real)
+		++iext_delta;
+
+	if (dmap_written)
+		++iext_delta;
+
+	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK, iext_delta);
+	if (error)
+		goto out_cancel;
+
 	if (smap_real) {
 		/*
 		 * If the extent we're unmapping is backed by storage (written
-- 
2.29.2

