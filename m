Return-Path: <SRS0=fxM9=DK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44100C46466
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Oct 2020 05:57:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 044DF206F8
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Oct 2020 05:57:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FlQM5MGp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725766AbgJCF5D (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 3 Oct 2020 01:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgJCF5D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Oct 2020 01:57:03 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67C04C0613D0
        for <linux-xfs@vger.kernel.org>; Fri,  2 Oct 2020 22:57:03 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id t23so1687512pji.0
        for <linux-xfs@vger.kernel.org>; Fri, 02 Oct 2020 22:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ybzMGAH7mRYLjz5sy5yNWonaXyIH8jR0aIDyNXY08k0=;
        b=FlQM5MGp8crSuuMUruutVJ8KJc8FWX7FqcAx007+gCnAufkJiBAJp/vnmSTNPLeGwb
         AHnjPpfhdc6A/b3zUNtVkgXlnVS7+hwpqJqbAdkNQex15Swhrh8F70wlS5jJlKuXJAob
         es1sjp+BTXH9ZvfyaEItpv+Sk4+HBKoTZd+hZMIvcIuNd4YKaV4HJJ8acPk+YiajO3ok
         XoYOM+hvjbZjToWuWyWou8G/0ra2hZxM4qh7GtTZl5Ug5qwKQ1Ne54uS9/W/9PdDeCd/
         aSFoP4bcVdazSKdIM+IH2j20QJiQfNiVr++c9tRiVXnF/tMS7i0tdn/9SlaVRJWkBs4Q
         1LGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ybzMGAH7mRYLjz5sy5yNWonaXyIH8jR0aIDyNXY08k0=;
        b=QLYgaqvuyHZZs7ooDhE8UFM1/LO8vYaoN8fwaffItY0Tj5JFdD/mPzs4FGqnhe9dhZ
         wpiR25ncvYRwffCGqMzq5md2qqECkuvD1fj20P4unp5dUxqgzDQtnQLS/BsmWdUCD8RU
         JE+hjfOsdkr46i9krm85fkqCAoid6v/3okNWPxOrRFDN2yVlufIVR8EAIn+vyV9GlvlR
         8cVs7I+NIPhnmeyD/HdgaNE13CN1I21washgfz9nlL+GcTTwlUi/0Ujfv26dUaNBA/L3
         SeUFnjVuM83NSXPcqZ1ufpu3f0iVjhi7Bkqz1j2Dh56LyBxOTILAKWL0NYYnlsQiHOwb
         Lyog==
X-Gm-Message-State: AOAM533EB3gdbh/38MSrdEwgUBCpHXPbVjtNy6+vHidPmNapAPZzCLZ1
        iNs0eZiRipSpivPrtirsGHwSbdNrwJgZbg==
X-Google-Smtp-Source: ABdhPJzQ9s9azyOzP8WSpmQszetstX1Y+UyFHc00XxRx9cMNFRas+b6gEy7NfFsFOssLV73iTN4Zkg==
X-Received: by 2002:a17:90a:ff17:: with SMTP id ce23mr1073653pjb.221.1601704622504;
        Fri, 02 Oct 2020 22:57:02 -0700 (PDT)
Received: from localhost.localdomain ([122.171.168.96])
        by smtp.gmail.com with ESMTPSA id 125sm4106664pff.59.2020.10.02.22.57.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2020 22:57:01 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: [PATCH V5 07/12] xfs: Check for extent overflow when moving extent from cow to data fork
Date:   Sat,  3 Oct 2020 11:26:28 +0530
Message-Id: <20201003055633.9379-8-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201003055633.9379-1-chandanrlinux@gmail.com>
References: <20201003055633.9379-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Moving an extent to data fork can cause a sub-interval of an existing
extent to be unmapped. This will increase extent count by 1. Mapping in
the new extent can increase the extent count by 1 again i.e.
 | Old extent | New extent | Old extent |
Hence number of extents increases by 2.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_inode_fork.h | 9 +++++++++
 fs/xfs/xfs_reflink.c           | 5 +++++
 2 files changed, 14 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index afb647e1e3fa..b99e67e7b59b 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -78,6 +78,15 @@ struct xfs_ifork {
  */
 #define XFS_IEXT_WRITE_UNWRITTEN_CNT	(2)
 
+/*
+ * Moving an extent to data fork can cause a sub-interval of an existing extent
+ * to be unmapped. This will increase extent count by 1. Mapping in the new
+ * extent can increase the extent count by 1 again i.e.
+ * | Old extent | New extent | Old extent |
+ * Hence number of extents increases by 2.
+ */
+#define XFS_IEXT_REFLINK_END_COW_CNT	(2)
+
 /*
  * Fork handling.
  */
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 16098dc42add..4f0198f636ad 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -628,6 +628,11 @@ xfs_reflink_end_cow_extent(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
+	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+			XFS_IEXT_REFLINK_END_COW_CNT);
+	if (error)
+		goto out_cancel;
+
 	/*
 	 * In case of racing, overlapping AIO writes no COW extents might be
 	 * left by the time I/O completes for the loser of the race.  In that
-- 
2.28.0

