Return-Path: <SRS0=hW3p=B6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0D20C433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Aug 2020 05:44:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D19F52075E
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Aug 2020 05:44:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QaYAMABG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbgHTFoc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Aug 2020 01:44:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbgHTFoc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Aug 2020 01:44:32 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00F25C061757
        for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2020 22:44:32 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id k18so500749pfp.7
        for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2020 22:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mfv1u4ZxUw56HFujRb/h1GTHbvSe3gGbHoUGMz89LXY=;
        b=QaYAMABGtLWkhjCeKUnIE5+UODmNz723rHusGzSMls29rsLYv9lEQvwLyRUAFF32gr
         QsNB3CzVCKIWPXM9E0d401/2j5jvIfX7vj0UuRVkZ4gogeZclyz6F33rBldcrbD+uvo+
         5/VoRx7W+IMcO8LgziDufbcpBgcRJgWy6WHR6EZiXbN5jfQIcjjgKJHVeidqloZhpQjW
         gRAiP/3ut89XPzxNSQwwi7uvEv41Qi8cuc0B46IqvUc+0LkF2pJcpCrDU2fe25AjNlW0
         98BUdxcDFnhBggNpyKY8TkQ1UhFhl8h4CntOxM6Sebf+rsqY3nJe2VuExvDGmYRZUYwr
         iOEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mfv1u4ZxUw56HFujRb/h1GTHbvSe3gGbHoUGMz89LXY=;
        b=gRmDPpDMnJZ6tlpwrqX+vPCaOTbVZtBX/hmEreJYDPuoGkLg1hegf1PruKUHfkNcCn
         fuZVmey+NzspWak7f+3NkfRlXgenOck22Ew/d4TLKsDczAWYof8UiISA48/Nr9zKll2N
         r4EgaGJYff7GfNKaBCWAA4oEZrbHBN6ryVXLrZEKydObm6vOL6sD2BQZcJQHBC/lVt8l
         I/E1NZhyFPsD/fWsIE6T7OMjw7+98YdagKn7R9urfPlUq36tI4aOt3yQQG75o1obAt1F
         fbCaOG08QR1vfzL86s+SpkTKkaEbXo9QPRDtu7nMpflw6IKa4tFo2W+2WScveR2EJsaL
         JbFQ==
X-Gm-Message-State: AOAM531FTqLQ9MABQtC0vwjpZuMtt8i4P3ogQM0pG7W3tZtUhNjZYYv9
        owrtQTTIk2Ng7d+Qcz63mZs4TCJX1os=
X-Google-Smtp-Source: ABdhPJwc5y3rzy4ZLtCvS6GwIULf6rSAtt2d66ZW67wPfuSYPgpprtz3YL3lpepX1N4M0nnRD2wFmw==
X-Received: by 2002:a65:664a:: with SMTP id z10mr1339855pgv.352.1597902271226;
        Wed, 19 Aug 2020 22:44:31 -0700 (PDT)
Received: from localhost.localdomain ([122.171.166.150])
        by smtp.gmail.com with ESMTPSA id l4sm1044034pgk.74.2020.08.19.22.44.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 22:44:30 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com, hch@infradead.org
Subject: [PATCH V3 09/10] xfs: Check for extent overflow when remapping an extent
Date:   Thu, 20 Aug 2020 11:13:48 +0530
Message-Id: <20200820054349.5525-10-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820054349.5525-1-chandanrlinux@gmail.com>
References: <20200820054349.5525-1-chandanrlinux@gmail.com>
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
 fs/xfs/libxfs/xfs_inode_fork.h | 14 ++++++++++++++
 fs/xfs/xfs_reflink.c           |  5 +++++
 2 files changed, 19 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 850d53162545..d1c675cf803a 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -86,6 +86,20 @@ struct xfs_ifork {
  * Hence number of extents increases by 2.
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
 
 /*
  * Fork handling.
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index c1d2a741e1af..9884fd51efee 100644
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

