Return-Path: <SRS0=kyg5=BY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72F19C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Aug 2020 08:10:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 488D420771
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Aug 2020 08:10:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iOjVvRid"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbgHNIKB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Aug 2020 04:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbgHNIKB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Aug 2020 04:10:01 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 046B2C061383
        for <linux-xfs@vger.kernel.org>; Fri, 14 Aug 2020 01:10:01 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id u10so3835978plr.7
        for <linux-xfs@vger.kernel.org>; Fri, 14 Aug 2020 01:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JsRw6B599oq+UPDByCJYf/bZpP5uc5Yihgn4D62MRKs=;
        b=iOjVvRidRMPl8oVXq2CdDkzGlLSn3z0oiWGcefHfFO85mfL8/yBdHU1EiiWatLy+s5
         I04WH2/lUDi3q2qHmrXzgRUBGOJ/CrgX0AFXC6eQKFAXkVJUb3Gyrbx7jFKzUL6nXFPo
         huFFdI1RoIpswzPW+AWMj5CGF1jOsoHgCE2fgyWNwQkNsbb46taAlgBTZ40gYA4huor8
         CYOZV+VkBZYsK7gVr5+biX01jXJRN/Zpw8klvcfcYfpmOZE4oQv2tFKM5bTHR85+bk33
         Q2dLDnUZ43EqN1urUj33xgZ1Wa+5UTt5YIGvUxV2eGVWGCbvVrtLIpSkTxsspU4rni+f
         pZyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JsRw6B599oq+UPDByCJYf/bZpP5uc5Yihgn4D62MRKs=;
        b=VlBqumqsKwlJhms925vEMLPU2/oT0s/CrC7XdZ+WaXiv2aN/AvmDYYm5B8gIKxHEzL
         w8Mt36A4hIqQG5d+X4rDzGGR/Bit6f5bdLwZzgD1X0AYQrtqRFN79drvvyqMineD1tbL
         niXA253ayVN+M6i1iunt++LDHXOU6RJHcs3OVv/442W2NRseUw6Thp28tZKdgmQhifWH
         EHk9Sk8koSvb5caBq4po/ZRbpbuSwF8k4VE2vscf5+BNNuXl4O7zo0HpuBXOS+z7+jIR
         21YJddanru7UXv1leQu5j3aIqqrbZEaQQUPuaUF/sw7r7zsWZ0BKlgdDt6D90Gy/NCJb
         blaw==
X-Gm-Message-State: AOAM533OOX/Wqq4yTH+TzVpLBeu0sd2KbXD8WqcRi5eXn0cSqG23ez33
        WJp9UP11qjKIZQ/hQESWNxaqKBVCqzk=
X-Google-Smtp-Source: ABdhPJyW0j2pufYY+YlubFoehDO/GELR/5iFeUVCFkAaIZ1GWBpCThmJUhatRq0Kvdbfy0zolsZZDQ==
X-Received: by 2002:a17:90b:b18:: with SMTP id bf24mr1322778pjb.94.1597392600272;
        Fri, 14 Aug 2020 01:10:00 -0700 (PDT)
Received: from localhost.localdomain ([122.179.47.119])
        by smtp.gmail.com with ESMTPSA id z17sm8594289pfq.38.2020.08.14.01.09.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 01:09:59 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: [PATCH V2 09/10] xfs: Check for extent overflow when remapping an extent
Date:   Fri, 14 Aug 2020 13:38:32 +0530
Message-Id: <20200814080833.84760-10-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200814080833.84760-1-chandanrlinux@gmail.com>
References: <20200814080833.84760-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
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

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_inode_fork.h | 15 +++++++++++++++
 fs/xfs/xfs_reflink.c           |  5 +++++
 2 files changed, 20 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index d750bdff17c9..afff20703270 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -85,6 +85,21 @@ struct xfs_ifork {
  * Hence number of extents increases by 2.
  */
 #define XFS_IEXT_REFLINK_END_COW_CNT 2
+/*
+ * Remapping an extent involves unmapping the existing extent and
+ * mapping in the new extent.
+ * When unmapping, an extent containing the entire unmap
+ * range can be split into two extents,
+ * i.e. | Old extent | hole | Old extent |
+ * Hence extent count increases by 1.
+ *
+ * Mapping in the new extent into the destination file can increase
+ * the extent count by 1.
+ */
+#define XFS_IEXT_REFLINK_REMAP_CNT(smap_real, dmap_written) \
+	(((smap_real) ? 1 : 0) + ((dmap_written) ? 1 : 0))
+
+
 /*
  * Fork handling.
  */
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 04a7754ee681..134d49f8c941 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1100,6 +1100,11 @@ xfs_reflink_remap_extent(
 			goto out_cancel;
 	}
 
+	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+			XFS_IEXT_REFLINK_REMAP_CNT(smap_real, dmap_written));
+	if (error)
+		goto out_cancel;
+
 	if (smap_real) {
 		/*
 		 * If the extent we're unmapping is backed by storage (written
-- 
2.28.0

