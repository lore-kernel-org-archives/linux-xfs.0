Return-Path: <SRS0=uuBg=DT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E372C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 09:30:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF144208D5
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 09:30:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AZiRJaLt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729414AbgJLJa0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Oct 2020 05:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729379AbgJLJa0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Oct 2020 05:30:26 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F15D1C0613CE
        for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2020 02:30:25 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id t18so8257725plo.1
        for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2020 02:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=druk7Lat4GoRfwFJZReJkIQMKuIUdAgXOVtXjP44X6M=;
        b=AZiRJaLtO9U2dUIPi55nj1UeSZRRlYgMdOUaPo9+ZhEErseo9OFsxH6T/e3R+FQRPR
         TKHmdIV710REoaDU70trWJM+OBZaqX5LV5m8tKgjjh+iFjeoaLk1D7MWaqysyoXjjZEw
         RdDp4CJG1nqr50tY4eJIOWP+JE91QS1Er5hgJKcRDg7igvramT8yPPw2u7l/qZkRmgWK
         hBP8AESHdxJTj5fP+H+rVLjJQ9WFn4SicbfR4D7SmqEpSmiCsErtI1b/LwfnUDQVnuAa
         LdYWOZfXtnCwIFpPvrdRbNapcnz04Wh9zzNFeBuNj+Y1varcoZGo5W4tT7lunadE49+e
         Yo/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=druk7Lat4GoRfwFJZReJkIQMKuIUdAgXOVtXjP44X6M=;
        b=c9Eg7EgfHcsrM9gky4O8s0lPKGxlnWxnrIKCrLtJRA0LJUjqiQsu8Z0x/x1XX344z+
         iloP7cFo1ov4fav2kjc/CPjJbb2Ghn4RVH/FUwcjxMgUz1M1UOACwjGSezWlwqBtSDbs
         L7fINDks3kkck9caAMuVyghJwPg+Ys9tYIgGdpZjA91AY2+k8jf1MeTzGoINLJzvQvaZ
         QSqiGyQ1IjcCLb/8SL/Al/DG9T1TRsZyJ3iiqBWmSds555kRiMRGL1bGQYzIx3q1Kxut
         0A5Kg4H46TY5Hm/E2z6wDHe4sQYrKows0h65r1Jzu5kxsUHNbil5QnX8TLzaMImgRJv/
         oHSQ==
X-Gm-Message-State: AOAM532jpgW1+f9mnxNC7//4BHUk6Stx7tKQX0QxK5N91TOqN6jvGhib
        /Fe77S4Zj/6rNqzZqIv/7kVjpr10uZc=
X-Google-Smtp-Source: ABdhPJyb17QvkV9ThkYqfwwFLAITr9Qxj7FX1S6AZYIrTJkp5V/B5DAbvICiKiZ/1x0umv8AclIIjA==
X-Received: by 2002:a17:902:7102:b029:d3:ef48:e51e with SMTP id a2-20020a1709027102b02900d3ef48e51emr21967345pll.72.1602495025218;
        Mon, 12 Oct 2020 02:30:25 -0700 (PDT)
Received: from localhost.localdomain ([122.172.180.109])
        by smtp.gmail.com with ESMTPSA id z142sm19451985pfc.179.2020.10.12.02.30.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 02:30:24 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: [PATCH V6 08/11] xfs: Check for extent overflow when remapping an extent
Date:   Mon, 12 Oct 2020 14:59:35 +0530
Message-Id: <20201012092938.50946-9-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012092938.50946-1-chandanrlinux@gmail.com>
References: <20201012092938.50946-1-chandanrlinux@gmail.com>
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

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_inode_fork.h | 15 +++++++++++++++
 fs/xfs/xfs_reflink.c           |  5 +++++
 2 files changed, 20 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index b99e67e7b59b..ded3c1b56c94 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -87,6 +87,21 @@ struct xfs_ifork {
  */
 #define XFS_IEXT_REFLINK_END_COW_CNT	(2)
 
+/*
+ * Remapping an extent involves unmapping the existing extent and mapping in the
+ * new extent.
+ *
+ * When unmapping, an extent containing the entire unmap range can be split into
+ * two extents,
+ * i.e. | Old extent | hole | Old extent |
+ * Hence extent count increases by 1.
+ *
+ * Mapping in the new extent into the destination file can increase the extent
+ * count by 1.
+ */
+#define XFS_IEXT_REFLINK_REMAP_CNT(smap_real, dmap_written) \
+	(((smap_real) ? 1 : 0) + ((dmap_written) ? 1 : 0))
+
 /*
  * Fork handling.
  */
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 4f0198f636ad..c9f9ff68b5bb 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1099,6 +1099,11 @@ xfs_reflink_remap_extent(
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

