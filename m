Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF9FDC433DB
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jan 2021 03:31:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5F2622A99
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jan 2021 03:31:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbhAJDbI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 Jan 2021 22:31:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726447AbhAJDbH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Jan 2021 22:31:07 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C98DBC0617AB
        for <linux-xfs@vger.kernel.org>; Sat,  9 Jan 2021 19:30:05 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id s15so7714886plr.9
        for <linux-xfs@vger.kernel.org>; Sat, 09 Jan 2021 19:30:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BZXvtq1IJJ8A9t02QtWduGxtYXovGQz5DbuSLAdCy3M=;
        b=cZS/fLcYjmK/PYBrrQNS0DrD/Nh4JANVWu4FvWPs/9EhEaa2r0TggELsLFG0Byss6o
         YBPoFoia0Wc3Qr0tkvp/ijY3uD8qdsKbokEKfYu/LmL1/Qxgf3RbqJ5JiKjr9ADJcqwQ
         hnkbl19axti64+8oUnr6MulnJZMGVHwVF/hvOtsuzD+MMyb7D6G5/P8F+tK3QrzXjG/0
         cLKKl3fmt7pNWJI5PG6O8NBiN0vzOackxT73iZAspgulBkuOwvICgHrY5rSU6VQXf2Md
         zacwCWB/EoTlIWR0WOKdPTXbLZjkVbJdy4x8N9KSeNXuzik/GWKbp7gff99qPui+Mjuf
         5xtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BZXvtq1IJJ8A9t02QtWduGxtYXovGQz5DbuSLAdCy3M=;
        b=cI5XFQFMTAEoZyFQ810KZAschlaWkykWo13alTV/9ClLypwmPsTHCenxkb0PBYMWmo
         a60EarxJTb5x/OL4hThpyspDDrCJXuSq08lmb/3soDnaseaJ+etZGM84dLjyPNHnxP/J
         dlDay3lE8meLMMidbx+U3dEQImzbIWrOY1pTnh10+8xOB3C18nB5e8zqiyZk8OMSlN+z
         vSIeMn6W0bGS+AhWQ2qK5k6e3mRvLV7p+MBxR7Izw3ZQ+JWyT2/fEBCve+kwqH6E9CwE
         01eTA4fMlTbmUu0ovC3GIWMGEofN1frmpqUXIJRUaWM0A9kZk4Ls0bj1peD3Tee7nCVt
         p2zA==
X-Gm-Message-State: AOAM533leeHLUMw4erBTipvJe5a+G65dXCenCKAoFNurUxPH8G7iCRVA
        AxLR346TACzC5NRJH9D5WwJO8OZuScCI+g==
X-Google-Smtp-Source: ABdhPJxg4N2t3DOpKpWJWpnM8uH1pbAFjxpL53+gK19Z2OQCVd5oCmu+OSCd0T6kEpHNj4K9J25PAQ==
X-Received: by 2002:a17:902:6b89:b029:da:fc41:baec with SMTP id p9-20020a1709026b89b02900dafc41baecmr10907723plk.39.1610249405274;
        Sat, 09 Jan 2021 19:30:05 -0800 (PST)
Received: from localhost.localdomain ([122.179.92.100])
        by smtp.gmail.com with ESMTPSA id x6sm14079861pfq.57.2021.01.09.19.30.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jan 2021 19:30:04 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        djwong@kernel.org, hch@lst.de, allison.henderson@oracle.com
Subject: [PATCH V13 10/16] xfs: Check for extent overflow when remapping an extent
Date:   Sun, 10 Jan 2021 08:59:22 +0530
Message-Id: <20210110032928.3120861-11-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210110032928.3120861-1-chandanrlinux@gmail.com>
References: <20210110032928.3120861-1-chandanrlinux@gmail.com>
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

