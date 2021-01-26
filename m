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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1197CC433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 06:36:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C888322B3F
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 06:36:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730696AbhAZGg1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 01:36:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729376AbhAZGfl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jan 2021 01:35:41 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DD16C06178C
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jan 2021 22:33:13 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id md11so1446777pjb.0
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jan 2021 22:33:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZflUbONAaK9/L9BOxfPqTzOfgjlgC/1JMj3JWXw1dMQ=;
        b=XAGu8RZCw6eOMbH4B5pZ8xVkJMZYnVHb5iPgQKSNFUBr1g25Zys1ds25YLFiUWnNb3
         71UB0mVEXgU/+XHumIVC5VyKwNlPXxYw5KNm76T6rqlK6DmFQ2t065Gm7lom2f8Cxx18
         lsCti2GCGkRgDGpjISqPAxbEEsBTK8fqxqS8uP0kv/E2EYQjzTsYEE4Np7+8Szx3LclM
         tZ+zuHL+NDb/8jWyRUSeJ3UYpqdTdy9RTRXO7eF/XzOiP+7DPLll28zceBnBHUrHxg9B
         F64nz8g1dJQURTIfi+n/pumU/oDJvGseWZ1eOticfS0MLaRkJXLoftja5X3rHgrQfVD3
         kKDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZflUbONAaK9/L9BOxfPqTzOfgjlgC/1JMj3JWXw1dMQ=;
        b=m67TN8pI5j3wuNk+DmNBz1OL4Kc1XEBfIkirNVrRTpZN30LacCcZOcqO7QXOwOYqJS
         M0h73bhchQauDsDnZAH6+SJm9SKHQyGolNAb/VcuoG/BIS6WEkTkTgzBYhannuKcb6xc
         Z/UrR6r2KXGAu9XNILeXdkumNzcP1H4zaPWNy/Sc9o9nVr4Hk8KVNmMu3TVkAujEueYq
         gw89biQjxuolL8hpoPsJuPFLgbLuUqV3aJ2IMBjU/UKO/DmhXUapUPdy5hqttoRUZPPr
         Fo2StbgZd7q2QafUT1rX5Zg37couuAioK53ig6DxqWVb+DH59aF8NEG0o26F3TPPeuWo
         50RQ==
X-Gm-Message-State: AOAM5321DDzKeXiigpG9xi4T+Fq274+ZN3llivZT9P5qWw3P31nzOSf4
        ImoIlNPL9V2PIT9swTuV6wQsa8iHcGM=
X-Google-Smtp-Source: ABdhPJxWIaMUHnTftbEfDalPdkh13y6nSoRkF6oWsUxKmOeRODiYIqevZGvJCAfkfrssFu+bAH8iww==
X-Received: by 2002:a17:90b:94c:: with SMTP id dw12mr4364262pjb.77.1611642793002;
        Mon, 25 Jan 2021 22:33:13 -0800 (PST)
Received: from localhost.localdomain ([122.167.33.191])
        by smtp.gmail.com with ESMTPSA id w21sm17296578pff.220.2021.01.25.22.33.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 22:33:12 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, djwong@kernel.org,
        hch@lst.de, allison.henderson@oracle.com,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH V15 09/16] xfs: Check for extent overflow when moving extent from cow to data fork
Date:   Tue, 26 Jan 2021 12:02:25 +0530
Message-Id: <20210126063232.3648053-10-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210126063232.3648053-1-chandanrlinux@gmail.com>
References: <20210126063232.3648053-1-chandanrlinux@gmail.com>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_inode_fork.h | 9 +++++++++
 fs/xfs/xfs_reflink.c           | 5 +++++
 2 files changed, 14 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 917e289ad962..c8f279edc5c1 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -79,6 +79,15 @@ struct xfs_ifork {
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
index 6fa05fb78189..ca0ac1426d74 100644
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
2.29.2

