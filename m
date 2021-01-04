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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B71CC433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Jan 2021 10:33:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2356E2242A
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Jan 2021 10:33:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbhADKdD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Jan 2021 05:33:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726256AbhADKdD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Jan 2021 05:33:03 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEFA0C06179F
        for <linux-xfs@vger.kernel.org>; Mon,  4 Jan 2021 02:31:59 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id j1so14329823pld.3
        for <linux-xfs@vger.kernel.org>; Mon, 04 Jan 2021 02:31:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BZXvtq1IJJ8A9t02QtWduGxtYXovGQz5DbuSLAdCy3M=;
        b=cEWr7Q6qpyv6yC1EB3+/fBoRSP2d4ZJpA5gAVYh7BHvjWV8nBtTCiL8Qo4biOxD06j
         hq/d7rCS5gXe1JaYXxb/dV7EGWwGQa2LTmcil9eBB+S666NblGNX9va8UN/79uSxcThh
         cY4MCA62BP1Shv3bVuWBcHD8R9uXsDS6f27g54S+fxA1yIQorZ90us68boq1AW3CSYWj
         0GFvzcnLP8eCCFx6AgxhNogK5j51obDmIW6SnsRwOmmyh8DBV7qrWGtSDzfRdeE3pOGT
         ZCGdaef+RK/AG+cK76KXcwfaK2pg/wl4E4Xlo3oLI8JjWoLXU7GROfUWR+1tf3LL7aHl
         helQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BZXvtq1IJJ8A9t02QtWduGxtYXovGQz5DbuSLAdCy3M=;
        b=rLXpSo7M3L6JmZ/1q3OW0bsBpzgNwBz+VodB/EdUZAO4EAs4qcaaIbiZ7r802BVvq/
         ZhR6ijBxL/bW7Q87SJ3RwbJajXhO+d8Smug45SKF4nfFD3Ov2zOsoXecKM8OZ0WEK09C
         UogkQUKbPFepRcpG6CzTaPZqh0Uyok4GoXfEYEQxldr+gCi2+NdozzmR/QEdKICWCs+2
         15uRDNs4+LiqnHGRW3rD6p7mB7NwlX6rG6247XdqqN9rsNnSFf+vMOHAIMJoPnc6FrYD
         3XFrTpLXAXSA15ZCLLABHRVqbxbiAlQjihczYG7J/ARji7fuzGyL3PK/g+jY9yfjky2L
         A64Q==
X-Gm-Message-State: AOAM533EePweua8v6+m+CnEl/LMthVLdk7Ef/HRZ6J/pQS0U8Jo0MiNw
        6pQdfFQfbGCTLXqfOhInuOe73xbH03dHHg==
X-Google-Smtp-Source: ABdhPJy89li06Z/PamZcufS6V5xuVb9LjzQF0GNi6KjcxezJ8LYZKzUFFB4gsqLFbYw+fJOGbxNrZw==
X-Received: by 2002:a17:902:8483:b029:dc:3e69:4095 with SMTP id c3-20020a1709028483b02900dc3e694095mr48500462plo.66.1609756319493;
        Mon, 04 Jan 2021 02:31:59 -0800 (PST)
Received: from localhost.localdomain ([122.167.42.132])
        by smtp.gmail.com with ESMTPSA id q6sm51265782pfu.23.2021.01.04.02.31.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 02:31:59 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        hch@lst.de, allison.henderson@oracle.com
Subject: [PATCH V12 08/14] xfs: Check for extent overflow when remapping an extent
Date:   Mon,  4 Jan 2021 16:01:14 +0530
Message-Id: <20210104103120.41158-9-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210104103120.41158-1-chandanrlinux@gmail.com>
References: <20210104103120.41158-1-chandanrlinux@gmail.com>
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

